local dig_manager = require("digManager")
local ore_manager = require("oreManager")
local planet_registrar = require("global.planetConfigRegistrar")

local util = require("util")

local entity_built = require("events.entityBuilt")
local place_tile_events = require("events.placeTileEvent")
local tile_mined_event = require("events.tileMinedEvent")
local entity_destroyed_event = require("events.entityDestroyedEvent")
local surface_deleted_event = require("events.surfaceDeletedEvent")

-- Place markers to mark where to dig
-- Place excavators to dig the area
-- Once dug, ground turned into "dug" tile
-- Dug checks if it touches water
-- If yes:
--   random delay [15, 90) ticks to turn into water
--   Notify surrounding dug tiles

---@class DugToWaterTick
---@field surface LuaSurface
---@field position MapPosition
---@field tile string?

script.on_init(function()
  -- TODO: dug_to_water and dug has the same data, use metatables to not store it more than once
  -- dug_to_water contains all dug tiles that have yet to be transformed into water. Indexed by the tick they will transform
  storage.dug_to_water = {}  --[[@as table<integer, table<DugToWaterTick>>]]
  -- dug contains all tiles that have been dug that have yet to be transformed into water. Indexed by [surface.index][x][y]
  storage.dug = {}           --[[@as table<integer, table<integer, table<integer, boolean>>>]]
  -- remaining_ore contains all tiles that were started, have since been removed. Indexed by [surface.index][x][y]
  storage.remaining_ore = {} --[[@as table<integer, table<integer, table<integer, integer>>>]]
  -- List of all place resources. Indexed by the entity's on_object_destroyed registration_number
  storage.resources = {}     --[[@as table<integer, LuaEntity>]]
end)

script.on_configuration_changed(function(configurationChangedData)
  -- In case alien-biomes get disabled but the setting is still on
  if not script.active_mods["alien-biomes"] and settings.global["place-shallow-water"].value then
    game.print("Disabling shallow water")
    settings.global["place-shallow-water"] = { value = false }
  end
end)

commands.add_command("canex-transition-dug", nil, dig_manager.transition_dug)
commands.add_command("canex-reset-partially-dug", nil, ore_manager.clear_stored_ore_amount)
commands.add_command("canex-debug", nil, util.canalDebug)
commands.add_command("canex-show-planet-config", nil, planet_registrar.canex_dump_planet_config )

script.on_event(defines.events.on_resource_depleted, dig_manager.resource_depleted_event)

script.on_event(defines.events.on_player_built_tile, place_tile_events.place_tile_event)
script.on_event(defines.events.on_robot_built_tile, place_tile_events.place_tile_event)
script.on_event(defines.events.script_raised_set_tiles, place_tile_events.script_place_tile_event)

script.on_event(defines.events.on_player_mined_tile, tile_mined_event)
script.on_event(defines.events.on_robot_mined_tile, tile_mined_event)

script.on_event(defines.events.on_built_entity, entity_built.event, entity_built.filter)
script.on_event(defines.events.on_robot_built_entity, entity_built.event, entity_built.filter)
script.on_event(defines.events.script_raised_built, entity_built.event, entity_built.filter)
script.on_event(defines.events.script_raised_revive, entity_built.event, entity_built.filter)

script.on_event(defines.events.on_object_destroyed, entity_destroyed_event)
script.on_event(defines.events.on_surface_deleted, surface_deleted_event)

script.on_nth_tick(dig_manager.check_interval, dig_manager.periodic_check_dug_event)

