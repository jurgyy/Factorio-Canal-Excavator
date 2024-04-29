local event = require("__flib__.event")
local util = require("util")

local ore_manager = require("oreManager")
local dig_manager = require("digManager")

local place_tile_event = require("events.placeTileEvent")
local tile_mined_event = require("events.tileMinedEvent")

-- Place markers to mark where to dig
-- Place excavators to dig the area
-- Once dug, ground turned into "dug" tile
-- Dug checks if it touches water
-- If yes:
--   random delay [10, 60) ticks to turn into water
--   Notify surrounding dug tiles

script.on_init(function()
  -- dug_to_water contains all dug tiles that have yet to be transformed into water. indexed by the tick they will transform
  global.dug_to_water = {}
  -- dug contains all tiles that have been dug that have yet to be transformed into water. Indexed by [surface.index][x][y]
  global.dug = {}
  -- remaining_ore contains all tiles that were started, have since been removed. Indexed by [surface.index][x][y]
  global.remaining_ore = {}
end)

-- script.on_load(function()
--     if global.dug == nil then
--       global.dug = {}
--     end
-- end)

script.on_configuration_changed(function(configurationChangedData)
  game.print("on_configuration_changed")
  game.print("old version: " .. util.to_str(configurationChangedData.old_version))
  game.print("new version: " .. util.to_str(configurationChangedData.new_version))
  if configurationChangedData.mod_changes ~= nil then
    game.print("mod changes:")
    for _, k in ipairs(configurationChangedData.mod_changes) do
      game.print("\t" .. k .. ": " .. util.to_str(configurationChangedData.mod_changes[k].old_version) .. " to " .. util.to_str(configurationChangedData.mod_changes[k].new_version))
    end
  end

  game.print("mod startup settings changed: " .. util.to_str(configurationChangedData.mod_startup_settings_changed))
  game.print("migration applied: " .. util.to_str(configurationChangedData.migration_applied))
end)


local function local_tile_mined_event(event)
  tile_mined_event(event, ore_manager.ore_starting_amount)
end

function debug_check_leftover_dug_event(event)
  for i, dug in ipairs(global.dug_to_water) do
      game.print(i .. " dug tile on " .. dug.position.x .. ", " .. dug.position.y)
  end
end

-- script.on_event(defines.events.on_built_entity, register_marker, {{filter="type", type="resource"}})
-- script.on_event(defines.events.on_entity_destroyed, change_marker_to_water) -- TODO: on_resource_depleted? https://lua-api.factorio.com/latest/events.html#on_resource_depleted
script.on_event(defines.events.on_resource_depleted, dig_manager.resource_depleted_event)
script.on_event(defines.events.on_player_built_tile, place_tile_event)
script.on_event(defines.events.on_robot_built_tile, place_tile_event)
script.on_event(defines.events.on_player_mined_tile, local_tile_mined_event)
script.on_event(defines.events.on_robot_mined_tile, local_tile_mined_event)

script.on_nth_tick(dig_manager.check_interval, dig_manager.periodic_check_dug_event)
script.on_nth_tick(1, debug_check_leftover_dug_event)

