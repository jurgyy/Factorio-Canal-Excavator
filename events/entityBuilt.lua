local dig_manager = require("digManager")
local ore_manager = require("oreManager")
local digableTileName = require("getTileNames").digable
local util = require("util")

local function is_excavator(entity)
  return entity.name == "canex-excavator"
  or entity.is_registered_for_construction() and entity.ghost_prototype.name == "canex-excavator"
end

local function is_digable(entity)
  return entity.is_registered_for_construction()
  and entity.ghost_prototype.name == digableTileName
end

---@param surface LuaSurface
---@param entity LuaEntity
local function remove_ghosts_tiles_at_entity(surface, entity)
    local entities = surface.find_entities_filtered{
      position = entity.position,
      type = "tile-ghost"
    }

    for _, tile_ghost in pairs(entities) do
        tile_ghost.destroy()
    end
end

local function is_on_ghost_landfill(surface, entity)
  local entities = surface.find_entities_filtered{
    position = entity.position,
    type = "tile-ghost"
  }
  for _, tile_ghost in pairs(entities) do
    if tile_ghost.ghost_name == "landfill" then
      return true
    end
  end
  return false
end

local function handle_ghost_digable_tile(event)
  local entity = event.entity
  local surface = entity.surface
  local valid = util.surface_is_valid(surface)

  if not valid then
    util.show_error({"story.canex-invalid-surface"}, surface, {entity.position.x + 0.65, entity.position.y + 0.40})
    remove_ghosts_tiles_at_entity(surface, entity)
  else
    if util.is_position_landfilled(surface, entity.position) then
      util.show_error({"story.canex-not-on-landfill"}, surface, {entity.position.x + 0.65, entity.position.y + 0.40})
      entity.destroy()
    elseif is_on_ghost_landfill(surface, entity) then
      util.show_error({"story.canex-not-in-water"}, surface, {entity.position.x + 0.65, entity.position.y + 0.40})
      remove_ghosts_tiles_at_entity(surface, entity)
    elseif dig_manager.is_dug(entity.surface, entity.position) then
      util.show_error({"story.canex-already-dug"}, surface, {entity.position.x + 0.65, entity.position.y + 0.40})
      entity.destroy()

    elseif event.player_index and settings.get_player_settings(event.player_index)["auto-deconstruct"].value then
      -- Mark entities on ghost tile for deconstruction
      local non_excavators = ore_manager.get_colliding_entities(entity.surface, entity.position)
      for _, collidingEntity in pairs(non_excavators) do
        if not collidingEntity.is_registered_for_construction()
        or collidingEntity.ghost_prototype.name ~= digableTileName then
          collidingEntity.order_deconstruction(game.get_player(event.player_index).force)
        end
      end
    end
  end
end

---@param event EventData.on_built_entity|EventData.on_robot_built_entity|EventData.script_raised_built
local function entity_built_event(event)
  local entity = event.entity
  if entity.valid then
    if is_excavator(entity) then
      entity.rotatable = false

    elseif is_digable(entity) then
      handle_ghost_digable_tile(event)
    end
  end
end

return {
  event = entity_built_event,
  filter = {
    {filter = "name", name = "canex-excavator"},
    {filter = "type", type = "mining-drill", mode = "and"},
  
    {filter = "name", name = "entity-ghost", mode = "or"},
    {filter = "type", type = "entity-ghost", mode = "and"},
    
    {filter = "name", name = "tile-ghost", mode = "or"},
    {filter = "type", type = "tile-ghost", mode = "and"},
    {filter = "ghost_name", name = digableTileName, mode = "and"},
    {filter = "ghost_type", type = "tile", mode = "and"}
  }
}