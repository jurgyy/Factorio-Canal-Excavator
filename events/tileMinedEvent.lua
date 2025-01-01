local ore_manager = require("oreManager")
local digableTileName = require("getTileNames").digable


local function tile_mined_event(event)
  local surface = game.surfaces[event.surface_index]
  for _, tile in ipairs(event.tiles) do
    if tile.old_tile.name == digableTileName then
      local ores = surface.find_entities_filtered{
        position = {x = tile.position.x + 0.5, y = tile.position.y + 0.5},
        type = "resource",
        name = "canex-rsc-digable"
      }
      
      --game.print("tile mined")
      for _, ore in pairs(ores) do
        -- TODO all entities are at the same pos so in the case of multiple entities they overwrite eachother
        -- Does that ever happen? Will trigger print in insert function.
        if ore.amount < storage.ore_starting_amount then
          ore_manager.insert_stored_ore_amount(surface, tile.position, ore.amount)
        end

        ore_manager.delete_ore(ore)
      end
    end
  end
end

return tile_mined_event