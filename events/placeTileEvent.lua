local flib_bounding_box = require("__flib__/bounding-box")

local ore_manager = require("oreManager")
local dig_manager = require("digManager")
local tile_mined_event = require("events.tileMinedEvent")
local util = require("util")


--- Return all entities of a certain name in an area given a position, radius. The function will center the position on a tile
---@param surface LuaSurface
---@param position MapPosition
---@param radius number
---@param name string
---@return LuaEntity[]
local function find_entities_in_radius(surface, position, radius, name)
    -- Calculate the center position by adding 0.5 to both x and y floor
    local centerX = math.floor(position.x) + 0.5
    local centerY = math.floor(position.y) + 0.5

    local dim = 2 * radius
    local bbox = flib_bounding_box.from_dimensions( { x = centerX, y = centerY }, dim, dim )

    return surface.find_entities_filtered{area = bbox, name = name}
end

--- Mark all entities colliding with the excavator for deconstruction given a position
---@param surface LuaSurface
---@param force string|integer|LuaForce
---@param position MapPosition
local function mark_for_deconstruction(surface, position, force)
    local non_excavators = ore_manager.get_colliding_entities(surface, position)
    for _, ent in pairs(non_excavators) do
        ent.order_deconstruction(force)
    end
end

--- Set active to true on all excavators in a radius of a position
---@param surface LuaSurface
---@param position MapPosition
---@param radius number
local function wake_up_excavators(surface, position, radius)
    local excavators = find_entities_in_radius(surface, position, radius, "canex-excavator")
    for _, excavator in ipairs(excavators) do
        excavator.active = true
    end
end

--- Undo a place tile event
---@param surface LuaSurface
---@param old_tile OldTileAndPosition
---@param item any
local function undo_set_tile(surface, old_tile, item)
    local pos = {old_tile.position.x + 0.80, old_tile.position.y + 0.80}

    surface.spill_item_stack(pos, {name=item.name}, false, "neutral", true)
    surface.set_tiles({{name=old_tile.old_tile.name, position=old_tile.position}})
end

--- Event handler for on_robot_built_tile event
---@param event EventData.on_robot_built_tile
local function place_tile_as_robot(event)
    local surface = game.surfaces[event.surface_index]
    local radius = game.entity_prototypes["canex-excavator"].mining_drill_radius - 1

    for _, tile in ipairs(event.tiles) do
        local position = tile.position --[[@as MapPosition]]
        if dig_manager.is_dug(surface, tile.position) then
                undo_set_tile(surface, tile, event.item)
        else
            local ore = ore_manager.create_ore(surface, position)
            if ore == nil then
                undo_set_tile(surface, tile, event.item)
            else
                wake_up_excavators(surface, position, radius)
            end
        end
    end
end

--- Event handler for on_player_built_tile
---@param event EventData.on_player_built_tile
local function place_tile_as_player(event)
    local surface = game.surfaces[event.surface_index]
    local player = game.players[event.player_index]
    local radius = game.entity_prototypes["canex-excavator"].mining_drill_radius - 1

    for _, tile in ipairs(event.tiles) do
        local lua_tile = surface.get_tile(tile.position.x, tile.position.y)
        if dig_manager.is_dug(surface, tile.position) then
            player.mine_tile(lua_tile)
            player.create_local_flying_text{text = {"story.canex-already-dug"}, position = {tile.position.x + 1.15, tile.position.y + 0.75}, time_to_live = 150, speed=2.85 }
        else
            local position = tile.position --[[@as MapPosition]]
            local ore = ore_manager.create_ore(surface, position)
            if ore == nil then
                player.mine_tile(lua_tile)
            else
                wake_up_excavators(surface, position, radius)

                if settings.get_player_settings(event.player_index)["auto-deconstruct"].value then
                    mark_for_deconstruction(surface, position, player.force)
                end
            end
        end
    end
end

--- Combined event handler for on_player_built_tile and on_robot_built_tile
---@param event EventData.on_player_built_tile|EventData.on_robot_built_tile
local function place_tile_event(event)
    if dig_manager.tile_is_water(event.tile.name) then
        for _, old_tile_and_pos in ipairs(event.tiles) do
            dig_manager.transition_surrounding_if_dug(game.surfaces[event.surface_index], old_tile_and_pos.position)
        end
        return
    end
    if not event.item or event.item.name ~= "canex-item-digable" then
        -- Call tile_mined_event in case the new tile is placed ontop of a digable tile
        tile_mined_event(event)
        return
    end

    if event.player_index == nil then
        place_tile_as_robot(event --[[@as EventData.on_robot_built_tile]])
        return
    else
        place_tile_as_player(event --[[@as EventData.on_player_built_tile]])
        return
    end
end

return place_tile_event