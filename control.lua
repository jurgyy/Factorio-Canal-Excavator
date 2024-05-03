local dig_manager = require("digManager")

local entity_built_event = require("events.entityBuiltEvent")
local place_tile_event = require("events.placeTileEvent")
local tile_mined_event = require("events.tileMinedEvent")

-- Place markers to mark where to dig
-- Place excavators to dig the area
-- Once dug, ground turned into "dug" tile
-- Dug checks if it touches water
-- If yes:
--   random delay [15, 90) ticks to turn into water
--   Notify surrounding dug tiles

local function get_landfill_stone_cost()
  for _, ingredient in ipairs(game.recipe_prototypes["landfill"].ingredients) do
    if ingredient.name == "stone" then
      return ingredient.amount
    end
  end
  return 20
end

script.on_init(function()
  -- dug_to_water contains all dug tiles that have yet to be transformed into water. indexed by the tick they will transform
  global.dug_to_water = {}
  -- dug contains all tiles that have been dug that have yet to be transformed into water. Indexed by [surface.index][x][y]
  global.dug = {}
  -- remaining_ore contains all tiles that were started, have since been removed. Indexed by [surface.index][x][y]
  global.remaining_ore = {}

  global.ore_starting_amount = get_landfill_stone_cost()
end)

script.on_configuration_changed(function(configurationChangedData)
  global.ore_starting_amount = get_landfill_stone_cost()
end)

commands.add_command("transition-dug", nil, dig_manager.transition_dug)

script.on_event(defines.events.on_resource_depleted, dig_manager.resource_depleted_event)
script.on_event(defines.events.on_player_built_tile, place_tile_event)
script.on_event(defines.events.on_robot_built_tile, place_tile_event)
script.on_event(defines.events.on_player_mined_tile, tile_mined_event)
script.on_event(defines.events.on_robot_mined_tile, tile_mined_event)
script.on_event(defines.events.on_built_entity, entity_built_event)

script.on_nth_tick(dig_manager.check_interval, dig_manager.periodic_check_dug_event)

