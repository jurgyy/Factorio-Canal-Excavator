local flib_bounding_box = require("__flib__/bounding-box")

local util = require("util")
local grid_spiral = require("gridSpiral")

local dig_manager = {}

local last_nth_tick = nil
dig_manager.check_interval = 15

local water_tile_names = {"deepwater", "deepwater-green", "water", "water-green", "water-mud", "water-shallow", "water-wube"}
local dug_tile_name = "canal-sand"

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
        game.print("Destroying " .. entity.name)
        entity.die()
    end
end

local function destroy_corpses(surface, bbox)
    local remnants = surface.find_entities_filtered{
        area = bbox,
        type = "corpse"
    }

    for _, entity in pairs(remnants) do
        -- game.print("remnant destroyed: " .. entity.name)
        entity.destroy()
    end
end

local function set_dug(surface, position)
  --game.print("Dug tile: ".. surface.name .. " - ".. position.x .. ", " .. position.y)
  
  if global.dug == nil then
    global.dug = {} -- todo remove
  end

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


local function find_nearest_empty_tile(surface, center, max_steps)
    max_steps = max_steps or 100

    local spiral = grid_spiral.new(center.x, center.y)
    for _ = 1, 100 do
        local pos = spiral:Position()
        local tile = surface.get_tile(pos)

        if tile.valid then
            if next(tile.prototype.collision_mask) ~= nil then
                if tile.prototype.collision_mask["ground-tile"] then
                    local bbox = flib_bounding_box.from_position(pos, true)
                    local entities = surface.find_entities(bbox)
                    if next(entities) == nil then
                        --util.highlight_bbox(surface, bbox)
                        return pos 
                    end
                --     util.highlight_bbox(surface, bbox, {r = 1, g = 1, b = 0, a = 1})
                --     log("Tile not empty")
                -- else
                --     util.highlight_bbox(surface, bbox, {r = 0, g = 0, b = 1, a = 1})
                --     log("Tile doesn't match mask")
                end
            -- else
            --     log("Collision mask empty")
            --     util.highlight_bbox(surface, bbox, {r = 1, g = 1, b = 1, a = 1})
            end
        -- else
        --     util.highlight_bbox(surface, bbox, {r = 1, g = 0, b = 0, a = 1})
        --     log("Tile not valid")
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
        local safe_position = find_nearest_empty_tile(surface, player.position, 100)
        if safe_position == nil then
            player.die()
        else
            player.teleport(safe_position)
        end
    end
end

function dig_manager.set_water(surface, position)
    -- game.print("Set water")
    --game.print("Set water: " .. math.floor(position.x) .. ", " .. math.floor(position.y))
    global.dug[surface.index][math.floor(position.x)][math.floor(position.y)] = nil
    util.highlight_position(surface, position)

    local bbox = flib_bounding_box.from_position(position, true)
    die_water_colliding_entities(surface, bbox)
    destroy_corpses(surface, bbox)
    move_players(surface, bbox)

    surface.set_tiles({{name="water", position=position}})
end
  
function dig_manager.is_dug(surface, position)
    if global.dug == nil then
        global.dug = {} -- todo remove
    end

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
        --tile = surface.get_tile(pos.x, pos.y)
        --if tile.name == dug_tile_name then
        if dig_manager.is_dug(surface, pos) then
        -- TODO a single tile can be registered by multiple neighbours causing the set_water function to be called multiple
        -- times at possibly different moments.
        dig_manager.register_delayed_transition(game.tick, surface, pos)
        end
    end
end
  
function dig_manager.register_delayed_transition(current_tick, surface, position, mult)
    -- TODO current_tick?
    -- Register a mined out tile to transition into a water tile after a short random delay.
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
    -- game.print("check " .. event.tick .. " | " .. event.nth_tick)
    last_nth_tick = event.tick

    if global.dug_to_water[event.tick] ~= nil then
        -- game.print("transitioning")
        for _, transition in ipairs(global.dug_to_water[event.tick]) do
        --game.print("transitioning position " .. transition.position.x .. ", " .. transition.position.y)
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
        dig_manager.register_delayed_transition(event.tick, surface, position, 1)
    end
end

return dig_manager