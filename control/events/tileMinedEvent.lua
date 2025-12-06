local canex_util = require("canex-util")
local ore_manager = require("control.oreManager")
local dig_manager = require("control.digManager")
local surfaces_manager = require("control.surfacesManager")
local digableTileName = require("prototypes.getTileNames").digable


--- @param event EventData.on_player_mined_tile|EventData.on_robot_mined_tile
local function tile_mined_event(event)
  local surface = game.surfaces[event.surface_index]
  if not canex_util.surface_is_valid(surface) then return end

  local surface_config = surfaces_manager.get_surface_config(surface)
  if surface_config == nil then error("Trying to retrieve config of unconfigured surface") end

  for _, tile in ipairs(event.tiles) do
    if tile.old_tile.name == digableTileName then
      local ores = surface.find_entities_filtered{
        position = {x = tile.position.x + 0.5, y = tile.position.y + 0.5},
        type = "resource",
        name = surfaces_manager.resource_names
      }
      
      --game.print("tile mined")
      for _, ore in pairs(ores) do
        -- TODO all entities are at the same pos so in the case of multiple entities they overwrite eachother
        -- Does that ever happen? Will trigger print in insert function.
        if ore.amount < surface_config.oreStartingAmount then
          ore_manager.insert_stored_ore_amount(surface, tile.position, ore.amount)
        end

        ore_manager.delete_ore(ore)
      end
    end

    if tile.old_tile.is_foundation then
      local new_tile = surface.get_tile(tile.position.x, tile.position.y)
      dig_manager.transition_surrounding_if_dug(surface, tile.position, new_tile.name)
    end
  end
end

return tile_mined_event