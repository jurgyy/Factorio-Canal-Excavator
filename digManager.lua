local util = require("util")

local transform_manager = {}

local last_nth_tick = nil
transform_manager.check_interval = 15

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

function transform_manager.set_water(surface, position)
    -- game.print("Set water")
    --game.print("Set water: " .. math.floor(position.x) .. ", " .. math.floor(position.y))
    global.dug[surface.index][math.floor(position.x)][math.floor(position.y)] = nil
    util.highlight_position(surface, position)

    -- Die all entities that collide with water
    local entities = surface.find_entities_filtered{
        position = position,
        collision_mask = "water-tile"
    }

    -- Set the tile to water
    surface.set_tiles({{name="water", position=position}})

    for _, entity in pairs(entities) do
        --game.print("Killing " .. entity.name)
        entity.die()
    end

    -- Destory all remnants on the tile that might have been created by the die function earlier
    local remnants = surface.find_entities_filtered{
        position = position,
        type = "corpse"
    }
    for _, entity in pairs(remnants) do
        -- game.print("remnant destroyed: " .. entity.name)
        entity.destroy()
    end
end
  
function transform_manager.is_dug(surface, position)
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
  
function transform_manager.recursive_create_water(surface, center)
    transform_manager.set_water(surface, center)

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
        if transform_manager.is_dug(surface, pos) then
        -- TODO a single tile can be registered by multiple neighbours causing the set_water function to be called multiple
        -- times at possibly different moments.
        transform_manager.register_delayed_transition(game.tick, surface, pos)
        end
    end
end
  
function transform_manager.register_delayed_transition(current_tick, surface, position, mult)
    -- TODO current_tick?
    -- Register a mined out tile to transition into a water tile after a short random delay.
    local tick
    if mult == nil then
        tick = last_nth_tick + transform_manager.check_interval * math.random(1, 6)
    elseif mult <= 0 then
        -- Delay has to be at least 1 tick out, so execute it on the next check
        tick = last_nth_tick + transform_manager.check_interval
    else
        tick = last_nth_tick + transform_manager.check_interval * mult 
    end

    -- tick = current_tick + delay
    if global.dug_to_water[tick] == nil then
        global.dug_to_water[tick] = {}
    end

    table.insert(global.dug_to_water[tick], {surface=surface, position=position})
end

function transform_manager.periodic_check_dug_event(event)
    -- game.print("check " .. event.tick .. " | " .. event.nth_tick)
    last_nth_tick = event.tick

    if global.dug_to_water[event.tick] ~= nil then
        -- game.print("transitioning")
        for _, transition in ipairs(global.dug_to_water[event.tick]) do
        --game.print("transitioning position " .. transition.position.x .. ", " .. transition.position.y)
        transform_manager.recursive_create_water(transition.surface, transition.position)
        end
        global.dug_to_water[event.tick] = nil
    end
end

function transform_manager.resource_depleted_event(event)
    if event.entity.name ~= "rsc-canal-marker" then
        return
    end

    local position = event.entity.position
    local surface = event.entity.surface

    set_dug(surface, position)
    if is_any_neighbour_named(surface, position, water_tile_names) then
        transform_manager.register_delayed_transition(event.tick, surface, position, 1)
    end
end

return transform_manager