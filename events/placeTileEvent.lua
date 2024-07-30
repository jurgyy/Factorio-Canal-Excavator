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
---@param tile OldTileAndPosition|Tile
---@param item_name string?
local function undo_set_tile(surface, tile, item_name)
    local pos = {tile.position.x + 0.80, tile.position.y + 0.80}

    if item_name then
        surface.spill_item_stack(pos, {name=item_name}, false, "neutral", true)
    end

    local old_tile_name = (tile.old_tile and tile.old_tile.name) or surface.get_hidden_tile(pos)
    if not old_tile_name then
        error("Couldn't retrieve old_tile_name")
    end
    surface.set_tiles({{name=old_tile_name, position=tile.position}})
end

--- Event handler for on_robot_built_tile event
---@param event EventData.on_robot_built_tile
local function place_tile_as_robot(event)
    local surface = game.surfaces[event.surface_index]
    local radius = game.entity_prototypes["canex-excavator"].mining_drill_radius - 1

    for _, tile in ipairs(event.tiles) do
        local position = tile.position --[[@as MapPosition]]
        if dig_manager.is_dug(surface, tile.position) then
                undo_set_tile(surface, tile, event.item.name)
        else
            local ore = ore_manager.create_ore(surface, position)
            if ore == nil then
                undo_set_tile(surface, tile, event.item.name)
            else
                wake_up_excavators(surface, position, radius)
            end
        end
    end
end

local script_tile_refund_map = {}

---Find the item that places a given tile
---@param tile Tile Placed tile
---@return string? name Refund item name
local function find_script_tile_refund_item(tile)
    local tile_name = tile.name
    local item_name = script_tile_refund_map[tile_name]
    if item_name then
        return item_name
    end

    for _, item_prototype in pairs(game.get_filtered_item_prototypes({{filter = "place-as-tile"}})) do
        local place_result = item_prototype.place_as_tile_result
        if place_result then
            local place_result_name = place_result.result.name
            if place_result_name == tile_name then
                item_name = item_prototype.name
                script_tile_refund_map[tile_name] = item_name
                return item_name
            end
        end
    end
    error("Could not find item that places " .. tile_name)
    return
end

--- Event handler for script_raised_set_tiles event
---@param event EventData.script_raised_set_tiles
local function place_tile_as_script(event)
    local surface = game.surfaces[event.surface_index]
    local radius = game.entity_prototypes["canex-excavator"].mining_drill_radius - 1
    for _, tile in ipairs(event.tiles) do
        if tile.name == "canex-tile-digable" then
            local position = tile.position --[[@as MapPosition]]
            local is_dug = dig_manager.is_dug(surface, position)
            local item_name = find_script_tile_refund_item(tile)
            if not item_name then error("Unable to retrieve item that places tile " .. tile.name) end
            if item_name ~= "canex-item-digable" then goto continue end
            
            if is_dug then
                undo_set_tile(surface, tile, item_name)
            else
                local ore = ore_manager.create_ore(surface, position)
                if ore == nil then
                    undo_set_tile(surface, tile, find_script_tile_refund_item(tile))
                else
                    wake_up_excavators(surface, position, radius)
                end
            end
        --else
           -- TODO check if the tile was excavatable_surface and then remove the ore.
           -- OldTileAndPosition[] isn't exposed in this event so have to find a workaround unless Wube
           -- implements it: https://forums.factorio.com/viewtopic.php?f=28&t=114555
        end
        ::continue::
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

---@param event EventData.script_raised_set_tiles
local function script_place_tile_event(event)
    for _, tile in pairs(event.tiles) do
        if dig_manager.tile_is_water(tile.name) then
            dig_manager.transition_surrounding_if_dug(game.surfaces[event.surface_index], tile.position)
        end
    end
    place_tile_as_script(event)
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

return {
    place_tile_event = place_tile_event,
    script_place_tile_event = script_place_tile_event
}