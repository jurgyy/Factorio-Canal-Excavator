local dig_manager = require("control.digManager")
local ore_manager = require("control.oreManager")
local surface_manager = require("control.surfacesManager")

local surface_config_helper = require("global.surfaceConfigHelper")

local canex_util = require("canex-util")

local entity_built = require("control.events.entityBuilt")
local place_tile_events = require("control.events.placeTileEvent")
local tile_mined_event = require("control.events.tileMinedEvent")
local entity_destroyed_event = require("control.events.entityDestroyedEvent")
local surface_created_event = require("control.events.surfaceCreatedEvent")
local surface_deleted_event = require("control.events.surfaceDeletedEvent")
local pre_surface_deleted_event = require("control.events.preSurfaceDeletedEvent")

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

---@alias tick integer
---@alias surfaceIndex integer
---@alias xPosition integer
---@alias yPosition integer
---@alias registrationNumber integer

script.on_init(function()
  -- TODO: dug_to_water and dug has the same data, use metatables to not store it more than once
  -- dug_to_water contains all dug tiles that have yet to be transformed into water. Indexed by the tick they will transform
  storage.dug_to_water = {}  --[[@as table<tick, table<DugToWaterTick>>]]
  -- dug contains all tiles that have been dug that have yet to be transformed into water. Indexed by [surface.index][x][y]
  storage.dug = {}           --[[@as table<surfaceIndex, table<xPosition, table<yPosition, boolean>>>]]
  -- remaining_ore contains all tiles that were started, have since been removed. Indexed by [surface.index][x][y]
  storage.remaining_ore = {} --[[@as table<surfaceIndex, table<xPosition, table<yPosition, integer>>>]]
  -- List of all placed resources. Indexed by the entity's on_object_destroyed registration_number
  storage.resources = {}     --[[@as table<registrationNumber, LuaEntity>]]

  storage.runtime_surface_config = {} --[[@as table<string, CanexSurfaceTemplate>]]
end)

script.on_load(function()
  surface_manager.load_stored_config()
end)

commands.add_command("canex-transition-dug", {"command.canex-transition-dug"}, dig_manager.transition_dug)
commands.add_command("canex-reset-partially-dug", {"command.canex-reset-partially-dug"}, ore_manager.clear_stored_ore_amount)
commands.add_command("canex-debug", {"command.canex-debug"}, canex_util.canalDebug)
commands.add_command("canex-show-surface-config", {"command.canex-show-surface-config"}, surface_config_helper.dump_surface_config )
commands.add_command("canex-remove-floating-resources", {"commands.canax-remove-floating"}, ore_manager.remove_floating)

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
script.on_event(defines.events.on_surface_created, surface_created_event)
script.on_event(defines.events.on_surface_deleted, surface_deleted_event)
script.on_event(defines.events.on_pre_surface_deleted, pre_surface_deleted_event)

script.on_nth_tick(dig_manager.check_interval, dig_manager.periodic_check_dug_event)
