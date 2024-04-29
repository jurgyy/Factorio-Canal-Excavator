local ore_manager = require("oreManager")
local dig_manager = require("digManager")
local util = require("util")

local function get_conflicting_entities(surface, position)
    return surface.find_entities_filtered{
        position = position,
        name = {"canal-excavator", "rsc-canal-marker"},
        invert = true
    }
end

local function find_entities_in_radius(centerTile, radius, surface, name)
    -- Calculate the center position by adding 0.5 to both x and y
    local centerX = centerTile.position.x + 0.5
    local centerY = centerTile.position.y + 0.5

    -- Calculate the bounding box based on the center position and radius
    local left = centerX - radius
    local top = centerY - radius
    local right = centerX + radius
    local bottom = centerY + radius

    -- Create the bounding box table
    local bbox = { left_top = { x = left, y = top }, right_bottom = { x = right, y = bottom } }

    util.highlight_bbox(surface, bbox)

    return surface.find_entities_filtered{area = bbox, name = name}
end

local function place_tile_event(event)
    if event.item.name ~= "item-canal-marker" then
        return
    end

    local radius = game.entity_prototypes["canal-excavator"].mining_drill_radius - 0.5
    local surface = game.surfaces[event.surface_index]
    local placer
    if event.player_index == nil then
        placer = event.robot
    else
        placer = game.get_player(event.player_index)
    end

    if placer == nil then
        game.print("Placer nil. This shouldn't be happening please report it to the Canal Excavator Github page with the steps to reproduce this")
    end


    for _, tile in ipairs(event.tiles) do
        -- For every placed tile, place a canal marker entity.

        if dig_manager.is_dug(surface, tile.position) then
            --game.print("Tile is already dug: ".. surface.name .. " - ".. tile.position.x .. ", " .. tile.position.y)
            
            local lua_tile = surface.get_tile(tile.position)
            placer.mine_tile(lua_tile)
        else
            local entity = surface.create_entity{name="rsc-canal-marker", position=tile.position}
            entity.amount = ore_manager.pop_stored_ore_amount(surface, tile.position)

            -- Wake-up idle excavators
            -- TODO a single excavator might be called multiple times with patch size >1. Can be optimized.
            local excavators = find_entities_in_radius(tile, radius, surface, "canal-excavator")
            for _, excavator in ipairs(excavators) do
                -- game.print("Waking up excavator")
                excavator.active = true
            end

            -- Mark entities on tile for deconstruction
            local non_excavators = get_conflicting_entities(surface, {tile.position.x + 0.5, tile.position.y + 0.5})
            for _, ent in pairs(non_excavators) do
                -- game.print(ent.name)
                ent.order_deconstruction(placer.force)
            end
        end
    end
end

return place_tile_event