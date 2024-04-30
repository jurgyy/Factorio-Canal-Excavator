local ore_manager = require("oreManager")

local function tile_mined_event(event)
  local surface = game.surfaces[event.surface_index]
  for _, tile in ipairs(event.tiles) do
    if tile.old_tile.name == "tile-canal-marker" then
      local entities = surface.find_entities_filtered{
        position = {x = tile.position.x + 0.5, y = tile.position.y + 0.5},
        name = "rsc-canal-marker"
      }
      
      --game.print("tile mined")
      for _, entity in pairs(entities) do
        -- TODO all entities are at the same pos so in the case of multiple entities they overwrite eachother
        -- Does that ever happen? Will trigger print in insert function.
        if entity.amount < global.ore_starting_amount then
          ore_manager.insert_stored_ore_amount(surface, tile.position, entity.amount)
        end

        entity.destroy()
      end
    end
  end
end

return tile_mined_event