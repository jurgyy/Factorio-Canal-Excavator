local flib_bounding_box = require("__flib__/bounding-box")

local grid_spiral = require("gridSpiral")
local dug_tile_name = require("getTileNames").dug
local planets_manager = require("planetsManager")

local dig_manager = {}

local last_nth_tick = nil
dig_manager.check_interval = 15 -- If this value ever gets changed between mod versions, make sure all the registered transitions still fire

--- Is any of the directly neighbouring tiles a water tile
---@param planetConfig CanexPlanetConfig
---@param surface LuaSurface
---@param center MapPosition
---@return boolean
local function is_next_to_water(planetConfig, surface, center)
  local surrounding = {
    {x = center.x - 1, y = center.y},
    {x = center.x + 1, y = center.y},
    {x = center.x, y = center.y - 1},
    {x = center.x, y = center.y + 1}
  }
  for _, pos in ipairs(surrounding) do
    local tile = surface.get_tile(pos.x, pos.y)

    local is_water = planets_manager.is_tile_water(planetConfig, tile.name)
    if is_water then
        return true
    end
  end

  return false
end

--- Calls die() on all entities that collide with a water tile (or shallow water, as per the mod settings) in a given bounding box
---@param planetConfig CanexPlanetConfig
---@param surface LuaSurface
---@param bbox BoundingBox
local function die_water_colliding_entities(planetConfig, surface, bbox)
    local mask = prototypes.tile[planetConfig.excavateResult].collision_mask.layers
    local entities = surface.find_entities_filtered{
        area = bbox,
        collision_mask = mask
    }

    for _, entity in pairs(entities) do
        if entity.valid and entity.name ~= "character" then
            entity.die()
        end
    end
end

--- Calls destroy on all entities of type corpse in a given bounding box
--- @param surface LuaSurface
--- @param bbox BoundingBox
local function destroy_corpses(surface, bbox)
    local remnants = surface.find_entities_filtered{
        area = bbox,
        type = "corpse"
    }

    for _, entity in pairs(remnants) do
        if entity.valid then
            entity.destroy()
        end
    end
end

--- Set change tile on the given location to water
---@param surface LuaSurface
---@param position MapPosition
local function set_dug(surface, position)
  if storage.dug[surface.index] == nil then
    storage.dug[surface.index] = {}
  end
 
  local xfloor = math.floor(position.x)
  local yfloor = math.floor(position.y)
  if storage.dug[surface.index][xfloor] == nil then
    storage.dug[surface.index][xfloor] = {}
  end

  storage.dug[surface.index][xfloor][yfloor] = true

  surface.set_tiles({
    {name=dug_tile_name, position={position.x, position.y}},
  })
end

--- Find the nearest center tile position by checking in a spiral pattern that doesn't collide with the given entity
---@param surface LuaSurface
---@param entity LuaEntity
---@param max_steps integer
---@return MapPosition | nil
local function find_nearest_safe_tile(surface, entity, max_steps)
    max_steps = max_steps or 100

    local x = math.floor(entity.position.x)
    local y = math.floor(entity.position.y)
    local spiral = grid_spiral.new(x, y)
    for _ = 1, max_steps do
        local pos = spiral:Position()
        if not surface.entity_prototype_collides(entity, pos, false, entity.direction) then
            return pos
        end

        spiral:goNext()
    end

    return nil
end

--- Teleport all players in a given bounding box to a safe position. If no safe tile is found, the player is killed.
---@param surface LuaSurface
---@param bbox BoundingBox
local function move_players(surface, bbox)
    local players = surface.find_entities_filtered{
        area = bbox,
        name = "character"
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


--- Change a tile to water and first die all colliding entities, destroy their corpses and move any players.
---@param planetConfig CanexPlanetConfig
---@param surface LuaSurface
---@param position MapPosition
function dig_manager.set_water(planetConfig, surface, position)
    storage.dug[surface.index][math.floor(position.x)][math.floor(position.y)] = nil

    local bbox = flib_bounding_box.from_position(position, true)
    die_water_colliding_entities(planetConfig, surface, bbox)
    destroy_corpses(surface, bbox)

    surface.set_tiles({{name=planetConfig.excavateResult, position=position}})
    if not planetConfig.resultIsWalkable then
        move_players(surface, bbox)
    end
end

--- Is the tile registered as dug
---@param surface LuaSurface
---@param position MapPosition|TilePosition
---@return boolean
function dig_manager.is_dug(surface, position)
    if storage.dug[surface.index] == nil then
        return false
    end

    local xfloor = math.floor(position.x)

    if storage.dug[surface.index][xfloor] == nil then
        return false
    end

    local yfloor = math.floor(position.y)
    if storage.dug[surface.index][xfloor][yfloor] == nil then
        return false
    end

    return storage.dug[surface.index][xfloor][yfloor]
end

---Register a delayed transition for all the surrounding tiles that were already dug.
---@param surface LuaSurface
---@param position MapPosition|TilePosition
function dig_manager.transition_surrounding_if_dug(surface, position)
    -- If a neighbouring tile is dug, register it for a delayed transition into water
    local surrounding = {
        {x = position.x - 1, y = position.y},
        {x = position.x + 1, y = position.y},
        {x = position.x, y = position.y - 1},
        {x = position.x, y = position.y + 1}
    }

    for _, pos in ipairs(surrounding) do
        if dig_manager.is_dug(surface, pos) then
            dig_manager.register_delayed_transition(surface, pos)
        end
    end
end

function dig_manager.check_should_transition(surface, position)
    local planetConfig = planets_manager.get_planet_config(surface)
    if is_next_to_water(planetConfig, surface, position) then
        dig_manager.transition_surrounding_if_dug(surface, position)
    end
end

--- Transform the tile to water and register a transition for any neighbouring tiles that are dug
---@param surface LuaSurface 
---@param position MapPosition
function dig_manager.recursive_create_water(surface, position)
    local planetConfig = planets_manager.get_planet_config(surface)

    dig_manager.set_water(planetConfig, surface, position)
    dig_manager.transition_surrounding_if_dug(surface, position)
end

--- Register a transition for a given tile on a later tick
---@param surface LuaSurface
---@param position MapPosition
---@param mult integer | nil optional multiplier for the check interval. If 0 or less the transition will be registered for the next check. If nil, a random integer multiplier between 1 and 6 will be chosen.
function dig_manager.register_delayed_transition(surface, position, mult)
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

    if storage.dug_to_water[tick] == nil then
        storage.dug_to_water[tick] = {}
    end

    table.insert(storage.dug_to_water[tick], {surface=surface, position=position})
end

--- Transition all tiles registered on the given tick
---@param tick integer
local function transition_tick(tick)
    if storage.dug_to_water[tick] ~= nil then
        for _, transition in ipairs(storage.dug_to_water[tick]) do
            dig_manager.recursive_create_water(transition.surface, transition.position)
        end
        storage.dug_to_water[tick] = nil
    end
end

--- Event handler to check if tiles should transition
---@param event NthTickEventData 
function dig_manager.periodic_check_dug_event(event)
    last_nth_tick = event.tick
    transition_tick(last_nth_tick)
end

--- Event handler for when the digable tile is depleted
---@param event EventData.on_resource_depleted
function dig_manager.resource_depleted_event(event)
    if event.entity.name ~= "canex-rsc-digable" then
        return
    end

    local position = event.entity.position
    local surface = event.entity.surface
    local planetConfig = planets_manager.get_planet_config(surface)

    set_dug(surface, position)
    if is_next_to_water(planetConfig, surface, position) then
        dig_manager.register_delayed_transition(surface, position, 1)
    end
end

--- Transition all dug tiles regardless of the tick on which they were registered
function dig_manager.transition_dug()
    if next(storage.dug_to_water) == nil then
        game.print("No tiles registered for transition.")
    else
        game.print("Force transitioning all tiles that are dug and touching water.")
        
        local count = 0
        for tick, _ in pairs(storage.dug_to_water) do
            count = count + 1
            transition_tick(tick)
        end
        game.print("Transitioned " .. count .. " dug tiles.")
    end
end

return dig_manager