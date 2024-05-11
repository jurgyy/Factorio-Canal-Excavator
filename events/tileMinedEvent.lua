local ore_manager = require("oreManager")
local resource_granularity = require("resourceGranularity")
local digableTileName = require("getTileNames").digable

local function generate_resource_list()
  local resourceList = {"canex-rsc-digable"}
  for i = 1, resource_granularity do
      table.insert(resourceList, "canex-rsc-digable-" .. i)
  end
  return resourceList
end
local digable_resource_names = generate_resource_list()

local function tile_mined_event(event)
  local surface = game.surfaces[event.surface_index]
  for _, tile in ipairs(event.tiles) do
    if tile.old_tile.name == digableTileName then
      local ores = surface.find_entities_filtered{
        position = {x = tile.position.x + 0.5, y = tile.position.y + 0.5},
        type = "resource",
        name = digable_resource_names
      }
      
      --game.print("tile mined")
      for _, ore in pairs(ores) do
        -- TODO all entities are at the same pos so in the case of multiple entities they overwrite eachother
        -- Does that ever happen? Will trigger print in insert function.
        if ore.amount < global.ore_starting_amount then
          ore_manager.insert_stored_ore_amount(surface, tile.position, ore.amount)
        end

        ore_manager.delete_ore(ore)
      end
    end
  end
end

return tile_mined_event