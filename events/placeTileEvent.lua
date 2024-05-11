local flib_bounding_box = require("__flib__/bounding-box")

local ore_manager = require("oreManager")
local dig_manager = require("digManager")
local tile_mined_event = require("events.tileMinedEvent")
local util = require("util")


local function find_entities_in_radius(centerTile, radius, surface, name)
    -- Calculate the center position by adding 0.5 to both x and y
    local centerX = centerTile.position.x + 0.5
    local centerY = centerTile.position.y + 0.5

    local dim = 2 * radius
    local bbox = flib_bounding_box.from_dimensions( { x = centerX, y = centerY }, dim, dim )
    --util.highlight_bbox(surface, bbox)

    return surface.find_entities_filtered{area = bbox, name = name}
end

local function place_tile_event(event)
    if event.item.name ~= "canex-item-digable" then
        -- Call tile_mined_event in case the new tile is placed ontop of a digable tile
        tile_mined_event(event)
        return
    end

    local radius = game.entity_prototypes["canex-excavator"].mining_drill_radius - 1
    local surface = game.surfaces[event.surface_index]
    local placer
    if event.player_index == nil then
        placer = event.robot
    else
        placer = game.get_player(event.player_index)
    end

    for _, tile in ipairs(event.tiles) do
        if dig_manager.is_dug(surface, tile.position) then
            local lua_tile = surface.get_tile(tile.position)

            if event.player_index ~= nil then
                placer.mine_tile(lua_tile)
            end
        else
            ore_manager.create_ore(surface, tile.position)

            -- Wake-up idle excavators
            local excavators = find_entities_in_radius(tile, radius, surface, "canex-excavator")
            for _, excavator in ipairs(excavators) do
                excavator.active = true
            end

            -- Mark entities on tile for deconstruction
            if event.player_index ~= nil
            and settings.get_player_settings(event.player_index)["auto-deconstruct"].value then
                local non_excavators = ore_manager.get_colliding_entities(surface, tile.position)
                for _, ent in pairs(non_excavators) do
                    ent.order_deconstruction(placer.force)
                end
            end
        end
    end
end

return place_tile_event