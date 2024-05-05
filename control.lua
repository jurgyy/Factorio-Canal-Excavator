local dig_manager = require("digManager")
local ore_manager = require("oreManager")

local entity_built_event = require("events.entityBuiltEvent")
local place_tile_event = require("events.placeTileEvent")
local tile_mined_event = require("events.tileMinedEvent")
local research_finished_event = require("events.researchFinishedEvent")
local entity_destroyed_event = require("events.entityDestroyedEvent")

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
  -- TODO: dug_to_water and dug has the same data, use metatables to not store it more than once
  -- dug_to_water contains all dug tiles that have yet to be transformed into water. Indexed by the tick they will transform
  global.dug_to_water = {}
  -- dug contains all tiles that have been dug that have yet to be transformed into water. Indexed by [surface.index][x][y]
  global.dug = {}
  -- remaining_ore contains all tiles that were started, have since been removed. Indexed by [surface.index][x][y]
  global.remaining_ore = {}
  -- List of all place resources. Indexed by the entity's on_entity_destroyed registration_number
  global.resources = {}

  global.ore_starting_amount = get_landfill_stone_cost()
end)

script.on_configuration_changed(function(configurationChangedData)
  global.ore_starting_amount = get_landfill_stone_cost()
end)

commands.add_command("transition-dug", nil, dig_manager.transition_dug)
commands.add_command("reset-partially-dug", nil, ore_manager.clear_stored_ore_amount)

script.on_event(defines.events.on_resource_depleted, dig_manager.resource_depleted_event)
script.on_event(defines.events.on_player_built_tile, place_tile_event)
script.on_event(defines.events.on_robot_built_tile, place_tile_event)
script.on_event(defines.events.on_player_mined_tile, tile_mined_event)
script.on_event(defines.events.on_robot_mined_tile, tile_mined_event)
script.on_event(defines.events.on_built_entity, entity_built_event)
script.on_event(defines.events.on_research_finished, research_finished_event)
script.on_event(defines.events.on_entity_destroyed, entity_destroyed_event)
-- TODO
--script.on_event(defines.events.on_surface_deleted, surface_deleted_event)

script.on_nth_tick(dig_manager.check_interval, dig_manager.periodic_check_dug_event)

