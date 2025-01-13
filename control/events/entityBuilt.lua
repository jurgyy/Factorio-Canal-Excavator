local dig_manager = require("control.digManager")
local ore_manager = require("control.oreManager")
local digableTileName = require("prototypes.getTileNames").digable
local canex_util = require("canex-util")

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

---@param surface LuaSurface
---@param entity LuaEntity
local function is_on_ghost_landfill(surface, entity)
  local entities = surface.find_entities_filtered{
    position = entity.position,
    type = "tile-ghost"
  }
  for _, tile_ghost in pairs(entities) do
    if tile_ghost.ghost_prototype.is_foundation then
      return true
    end
  end
  return false
end

---Clear the undo stack of the latest place canex-digable actions.
---Works only for ghost tiles. The tile version is in placeTileEvent.lua
---@param player LuaPlayer
---@param position MapPosition Position of the ghost that was removed
local function undo_last_create_digable_ghost(player, position)
  local undo_redo_stack = player.undo_redo_stack
  local undo_items = undo_redo_stack.get_undo_item(1)

  local x = math.floor(position.x)
  local y = math.floor(position.y)

  for index = #undo_items, 1, -1 do
    local undo_item = undo_items[index]
    if undo_item.type == "built-tile"
    and undo_item.position.x == x
    and undo_item.position.y == y then
      undo_redo_stack.remove_undo_action(1, index)
    end
  end
end

---@param event EventData.on_built_entity
local function handle_ghost_digable_tile(event)
  local entity = event.entity
  local surface = entity.surface
  local valid = canex_util.surface_is_valid(surface)
  local undone = false
  local position = entity.position

  if not valid then
    canex_util.show_error({"story.canex-invalid-surface"}, surface, {entity.position.x + 0.65, entity.position.y + 0.40})
    remove_ghosts_tiles_at_entity(surface, entity)
    undone = true
  else
    if canex_util.is_position_landfilled(surface, entity.position) then
      canex_util.show_error({"story.canex-not-on-landfill"}, surface, {entity.position.x + 0.65, entity.position.y + 0.40})
      entity.destroy()
      undone = true
    elseif is_on_ghost_landfill(surface, entity) then
      canex_util.show_error({"story.canex-not-in-water"}, surface, {entity.position.x + 0.65, entity.position.y + 0.40})
      remove_ghosts_tiles_at_entity(surface, entity)
      undone = true
    elseif dig_manager.is_dug(entity.surface, entity.position) then
      canex_util.show_error({"story.canex-already-dug"}, surface, {entity.position.x + 0.65, entity.position.y + 0.40})
      entity.destroy()
      undone = true
    elseif event.player_index and settings.get_player_settings(event.player_index)["auto-deconstruct"].value then
      -- Mark entities on ghost tile for deconstruction
      local non_excavators = ore_manager.get_colliding_entities(entity.surface, entity.position)
      for _, collidingEntity in pairs(non_excavators) do
        if not collidingEntity.is_registered_for_construction()
        or collidingEntity.ghost_prototype.name ~= digableTileName then
          local player = game.get_player(event.player_index)
          if player then
            collidingEntity.order_deconstruction(player.force, player, 1)
          end
        end
      end
    end

  end
  if undone and event.player_index then
    player = game.players[event.player_index]
    if player then
      undo_last_create_digable_ghost(player, position)
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
      ---@cast event EventData.on_built_entity
      --Robots can't build ghosts
      --TODO Scripts can build ghosts
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