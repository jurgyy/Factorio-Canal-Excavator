local flib_bounding_box = require("__flib__/bounding-box")

local ore_manager = require("oreManager")
local dig_manager = require("digManager")
local planets_manager = require("planetsManager")

local tile_mined_event = require("events.tileMinedEvent")
local util = require("util")
local dugTileName = require("getTileNames").dug


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
---@param player LuaPlayer
---@param position MapPosition
local function mark_for_deconstruction(surface, position, player)
    local entities = ore_manager.get_colliding_entities(surface, position)
    for _, entity in pairs(entities) do
        if not ore_manager.is_canex_resource_name(entity.name) then
            entity.order_deconstruction(player.force, player, 1)
        end
    end
end

--- Set active to true on all excavators in a radius of a position
---@param surface LuaSurface
---@param position MapPosition
---@param radius number
local function wake_up_excavators(surface, position, radius)
    local excavators = find_entities_in_radius(surface, position, radius, "canex-excavator")
    for _, excavator in ipairs(excavators) do
        excavator.update_connections()
    end
end

--- Undo a place tile event
---@param surface LuaSurface
---@param tile OldTileAndPosition|Tile
---@param item_name string?
local function undo_set_tile(surface, tile, item_name)
    local pos = {tile.position.x + 0.50, tile.position.y + 0.50}

    if item_name then
        surface.spill_item_stack{position=pos, stack={name=item_name}, force = "player"}
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
    local valid = util.surface_is_valid(surface)
    local radius = prototypes.entity["canex-excavator"].mining_drill_radius - 1
    local shown_error = false

    for _, tile in ipairs(event.tiles) do
        local position = tile.position --[[@as MapPosition]]
        if not valid then
            undo_set_tile(surface, tile, event.item.name)
            if not shown_error then
                util.show_error({"story.canex-invalid-surface"}, surface, {tile.position.x + 0.65, tile.position.y + 0.40})
                shown_error = true
            end
        elseif dig_manager.is_dug(surface, tile.position) then
            undo_set_tile(surface, tile, event.item.name)
            util.show_error({"story.canex-already-dug"}, surface, {tile.position.x + 0.65, tile.position.y + 0.40})
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
---@param tile Tile|string Placed tile
---@return string? name Refund item name
local function find_script_tile_refund_item(tile)
    local tile_name = tile.name or tile
    local item_name = script_tile_refund_map[tile_name]
    if item_name then
        return item_name
    end

    for _, item_prototype in pairs(prototypes.get_item_filtered({{filter = "place-as-tile"}})) do
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
    --error("Could not find item that places " .. tile_name)
end

--- Event handler for script_raised_set_tiles event
---@param event EventData.script_raised_set_tiles
local function place_tile_as_script(event)
    local surface = game.surfaces[event.surface_index]
    local valid = util.surface_is_valid(surface)
    local radius = prototypes.entity["canex-excavator"].mining_drill_radius - 1
    local shown_error = false

    for _, tile in ipairs(event.tiles) do
        if tile.name == "canex-tile-digable" then
            local position = tile.position
            local is_dug = dig_manager.is_dug(surface, position)
            local item_name = find_script_tile_refund_item(tile)
            if not item_name then error("Unable to retrieve item that places tile " .. tile.name) end
            if item_name ~= "canex-digable" then goto continue end
            
            if not valid then
                undo_set_tile(surface, tile, item_name)
                if not shown_error then
                    util.show_error({"story.canex-invalid-surface"}, surface, {tile.position.x + 0.65, tile.position.y + 0.40})
                    shown_error = true
                end
            elseif is_dug then
                undo_set_tile(surface, tile, item_name)
                util.show_error({"story.canex-already-dug"}, surface, {tile.position.x + 0.65, tile.position.y + 0.40})
            else
                local ore = ore_manager.create_ore(surface, position)
                if ore == nil then
                    undo_set_tile(surface, tile, find_script_tile_refund_item(tile))
                else
                    wake_up_excavators(surface, position, radius)
                end
            end
        else
            -- if surface.find_entities_filtered{area = flib_bounding_box.from_position(tile.position, true), name="canex-rsc-digable"} then
            --     game.print("was ore")
            -- end
           -- TODO check if the tile was excavatable_surface and then remove the ore.
           -- OldTileAndPosition[] isn't exposed in this event so have to find a workaround unless Wube
           -- implements it: https://forums.factorio.com/viewtopic.php?f=28&t=114555
        end
        ::continue::
    end
end

---Mines the tile and undoes possible removal offshore tiles that happend when placing the tile.
---Also removes the item(s) from the player's undo/redo stack
---@param player LuaPlayer
---@param surface LuaSurface
---@param tile LuaTile
local function player_undo_set_tile(player, surface, tile)
    player.mine_tile(tile)
    local undo_redo_stack = player.undo_redo_stack
    local undo_items = undo_redo_stack.get_undo_item(1)
    
    for i, undo_item in pairs(undo_items) do
        if undo_item.previous_tile
        and undo_item.previous_tile ~= dugTileName
        and tile.position.x == undo_item.position.x
        and tile.position.y == undo_item.position.y then
            local previous_tile_prototype = prototypes.tile[undo_item.previous_tile]
            if not previous_tile_prototype.is_foundation then
                -- Remove previous tile from player's inventory
                local item_name = find_script_tile_refund_item(undo_item.previous_tile)
                if item_name then
                    player.remove_item{name=item_name, count=1}
                end
            end
            -- Place the previous tile
            surface.set_tiles{
                tiles = {name = undo_item.previous_tile, position = undo_item.position}
            }

            undo_redo_stack.remove_undo_action(1, i)
            break
        end
    end
end

--- Event handler for on_player_built_tile
---@param event EventData.on_player_built_tile
local function place_tile_as_player(event)
    local surface = game.surfaces[event.surface_index]
    local valid = util.surface_is_valid(surface)
    local player = game.players[event.player_index]
    local radius = prototypes.entity["canex-excavator"].mining_drill_radius - 1
    local shown_error = false

    for _, tile in ipairs(event.tiles) do
        local lua_tile = surface.get_tile(tile.position.x, tile.position.y)
        if not valid then
            player_undo_set_tile(player, surface, lua_tile)
            if not shown_error then
                util.show_error({"story.canex-invalid-surface"}, surface, {tile.position.x + 0.65, tile.position.y + 0.40})
                shown_error = true
            end
        elseif util.is_position_landfilled(surface, tile.position) then
            player_undo_set_tile(player, surface, lua_tile)
            util.show_error({"story.canex-not-on-landfill"}, surface, {tile.position.x + 0.65, tile.position.y + 0.40})
        elseif dig_manager.is_dug(surface, tile.position) then
            player_undo_set_tile(player, surface, lua_tile)
            util.show_error({"story.canex-already-dug"}, surface, {tile.position.x + 0.65, tile.position.y + 0.40})
        else
            local position = tile.position --[[@as MapPosition]]
            local ore = ore_manager.create_ore(surface, position)
            if ore == nil then
                player.mine_tile(lua_tile)
            else
                wake_up_excavators(surface, position, radius)

                if settings.get_player_settings(event.player_index)["auto-deconstruct"].value then
                    mark_for_deconstruction(surface, position, player)
                end
            end
        end
    end
end

---@param event EventData.script_raised_set_tiles
local function script_place_tile_event(event)
    local surface = game.surfaces[event.surface_index]
    local planet_config = planets_manager.get_planet_config(surface)

    for _, tile in pairs(event.tiles) do
        if planets_manager.is_tile_water(planet_config, tile.name) then
            dig_manager.transition_surrounding_if_dug(surface, tile.position)
        end
    end
    place_tile_as_script(event)
end

--- Combined event handler for on_player_built_tile and on_robot_built_tile
---@param event EventData.on_player_built_tile|EventData.on_robot_built_tile
local function place_tile_event(event)
    local surface = game.surfaces[event.surface_index]
    local planet_config = planets_manager.get_planet_config(surface)

    if planets_manager.is_tile_water(planet_config, event.tile.name) then
        for _, old_tile_and_pos in ipairs(event.tiles) do
            dig_manager.transition_surrounding_if_dug(surface, old_tile_and_pos.position)
        end
        return
    end
    if not event.item or event.item.name ~= "canex-digable" then
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