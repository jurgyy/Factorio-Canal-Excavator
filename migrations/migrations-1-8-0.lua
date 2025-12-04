if not settings.startup["no-tiles"].value then
  return
end

local planetsManager = require("control.planetsManager")

for _, surface in pairs(game.surfaces) do
  local tiles = surface.find_tiles_filtered{name="yellow-refined-concrete"}
  if not planetsManager.is_surface_configured(surface) then
    game.print("Canal Excavator: Skipping migration on surface \"" .. surface.name .. "\" as its planet is not configured in Canal Excavator.")
    goto continue
  end

  local set_tiles = {}
  for _, tile in pairs(tiles) do
    table.insert(set_tiles, {name = "canex-digable", position = tile.position})
  end
  surface.set_tiles(set_tiles)
  for _, tile in pairs(tiles) do
    surface.set_hidden_tile(tile.position, nil)
  end

  tiles = surface.find_tiles_filtered{name="brown-refined-concrete"}
  set_tiles = {}
  for _, tile in pairs(tiles) do
    table.insert(set_tiles, {name = "canex-dug", position = tile.position})
  end
  surface.set_tiles(set_tiles)

  ::continue::
end

game.print("Canal Excavator: Executed migration. Please check your excavators to see if all \"diggable\" and \"dug\" tiles are still as expected.")
game.print("If you encounter any issues, please [font=default-bold]don't[/font] save your game, roll back Canal Excavator to version 1.7 and share your save file with the mod creator.")

