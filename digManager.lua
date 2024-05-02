local flib_bounding_box = require("__flib__/bounding-box")

local util = require("util")
local grid_spiral = require("gridSpiral")

local dig_manager = {}

local last_nth_tick = nil
dig_manager.check_interval = 15 -- If this value ever gets changed between mod versions, make sure all the registered transitions still fire

local water_tile_names = {"deepwater", "deepwater-green", "water", "water-green", "water-mud", "water-shallow", "water-wube"}
local dug_tile_name = "tile-dug"

local function is_any_neighbour_named(surface, center, tile_names)
  local surrounding = {
    {x = center.x - 1, y = center.y},
    {x = center.x + 1, y = center.y},
    {x = center.x, y = center.y - 1},
    {x = center.x, y = center.y + 1}
  }
  for _, pos in ipairs(surrounding) do
    local tile = surface.get_tile(pos.x, pos.y)

    for _, tile_name in ipairs(tile_names) do
      if tile.name == tile_name then
        return true
      end
    end
  end

  return false
end

local function die_water_colliding_entities(surface, bbox)
    local entities = surface.find_entities_filtered{
        area = bbox,
        collision_mask = "water-tile"
    }

    for _, entity in pairs(entities) do
        entity.die()
    end
end

local function destroy_corpses(surface, bbox)
    local remnants = surface.find_entities_filtered{
        area = bbox,
        type = "corpse"
    }

    for _, entity in pairs(remnants) do
        entity.destroy()
    end
end

local function set_dug(surface, position)
  if global.dug[surface.index] == nil then
    global.dug[surface.index] = {}
  end
  
  local xfloor = math.floor(position.x)
  local yfloor = math.floor(position.y)
  if global.dug[surface.index][xfloor] == nil then
    global.dug[surface.index][xfloor] = {}
  end

  global.dug[surface.index][xfloor][yfloor] = true

  surface.set_tiles({
    {name=dug_tile_name, position={position.x, position.y}},
  })
end

local function find_nearest_safe_tile(surface, entity, max_steps)
    max_steps = max_steps or 100

    local spiral = grid_spiral.new(entity.position.x, entity.position.y)
    for _ = 1, max_steps do
        local pos = spiral:Position()
        if not surface.entity_prototype_collides(entity, pos, false, entity.direction) then
            return pos
        end

        spiral:goNext()
    end

    return nil
end

local function move_players(surface, bbox)
    local players = surface.find_entities_filtered{
        area = bbox,
        collision_mask = "player-layer"
    }

    for _, player in pairs(players) do
        local safe_position = find_nearest_safe_tile(surface, player, 100)
        if safe_position == nil then
            player.die()
        else
            player.teleport(safe_position)
        end
    end
end

function dig_manager.set_water(surface, position)
    global.dug[surface.index][math.floor(position.x)][math.floor(position.y)] = nil
    --util.highlight_position(surface, position, {r = 0, g = 0, b = 1.0})

    local bbox = flib_bounding_box.from_position(position, true)
    die_water_colliding_entities(surface, bbox)
    destroy_corpses(surface, bbox)
    move_players(surface, bbox)

    if settings.global["place-shallow-water"].value then
        surface.set_tiles({{name="water-shallow", position=position}})
    else
        surface.set_tiles({{name="water", position=position}})
    end
end
  
function dig_manager.is_dug(surface, position)
    if global.dug[surface.index] == nil then
        return false
    end

    local xfloor = math.floor(position.x)

    if global.dug[surface.index][xfloor] == nil then
        return false
    end

    local yfloor = math.floor(position.y)
    if global.dug[surface.index][xfloor][yfloor] == nil then
        return false
    end

    return global.dug[surface.index][xfloor][yfloor]
end
  
function dig_manager.recursive_create_water(surface, center)
    dig_manager.set_water(surface, center)

    -- If a neighbouring tile is dug, register it for a delayed transition into water
    local surrounding = {
        {x = center.x - 1, y = center.y},
        {x = center.x + 1, y = center.y},
        {x = center.x, y = center.y - 1},
        {x = center.x, y = center.y + 1}
    }

    for _, pos in ipairs(surrounding) do
        if dig_manager.is_dug(surface, pos) then
            dig_manager.register_delayed_transition(surface, pos)
        end
    end
end
  
function dig_manager.register_delayed_transition(surface, position, mult)
    -- Register a mined out tile to transition into a water tile after a short random delay.
    
    -- TODO a tile can be registered twice if two water touching tiles got dug the same tick and a third adjacent tile was already dug but not touching water.
    -- This is less obvious with a small variation in check interfal, but if between the two triggers landfill get's placed, the second trigger
    -- Replaces the landfill with water again.

    if last_nth_tick == nil then
        -- In the case game just loaded and before the first check interval a transition gets registered, calculate last_nth_tick manually.
        last_nth_tick = math.floor(game.tick / dig_manager.check_interval) * dig_manager.check_interval
    end

    local tick
    if mult == nil then
        tick = last_nth_tick + dig_manager.check_interval * math.random(1, 6)
    elseif mult <= 0 then
        -- Delay has to be at least 1 tick out, so execute it on the next check
        tick = last_nth_tick + dig_manager.check_interval
    else
        tick = last_nth_tick + dig_manager.check_interval * mult 
    end

    -- tick = current_tick + delay
    if global.dug_to_water[tick] == nil then
        global.dug_to_water[tick] = {}
    end

    table.insert(global.dug_to_water[tick], {surface=surface, position=position})
end

function dig_manager.periodic_check_dug_event(event)
    game.print(event.tick)
    last_nth_tick = event.tick

    if global.dug_to_water[event.tick] ~= nil then
        for _, transition in ipairs(global.dug_to_water[event.tick]) do
            dig_manager.recursive_create_water(transition.surface, transition.position)
        end
        global.dug_to_water[event.tick] = nil
    end
end

function dig_manager.resource_depleted_event(event)
    if event.entity.name ~= "rsc-canal-marker" then
        return
    end

    local position = event.entity.position
    local surface = event.entity.surface

    set_dug(surface, position)
    if is_any_neighbour_named(surface, position, water_tile_names) then
        dig_manager.register_delayed_transition(surface, position, 1)
    end
end

return dig_manager