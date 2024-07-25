local dig_manager = require("digManager")
local ore_manager = require("oreManager")
local digableTileName = require("getTileNames").digable

local function is_excavator(entity)
  return entity.name == "canex-excavator"
  or entity.is_registered_for_construction() and entity.ghost_prototype.name == "canex-excavator"
end

local function is_digable(entity)
  return entity.is_registered_for_construction()
  and entity.ghost_prototype.name == digableTileName
end

local function handle_ghost_digable_tile(event)
  if dig_manager.is_dug(event.created_entity.surface, event.created_entity.position) then
    if event.player_index ~= nil then
      local player = game.players[event.player_index]
      player.create_local_flying_text{text = {"story.canex-already-dug"}, position = event.created_entity.position, time_to_live = 150, speed=2.85 }
    else
      event.created_entity.surface.create_entity{
          name = "flying-text",
          position = event.created_entity.position,
          text = {"story.canex-already-dug"},
          time_to_live = 150,
          speed=2.85
      }
    end
    
    entity.destroy()

  elseif event.player_index and settings.get_player_settings(event.player_index)["auto-deconstruct"].value then
    -- Mark entities on ghost tile for deconstruction
    local non_excavators = ore_manager.get_colliding_entities(event.created_entity.surface, event.created_entity.position)
    for _, collidingEntity in pairs(non_excavators) do
      if not collidingEntity.is_registered_for_construction()
      or collidingEntity.ghost_prototype.name ~= digableTileName then
        collidingEntity.order_deconstruction(game.get_player(event.player_index).force)
      end
    end
  end
end

local function entity_built_event(event)
  local entity = event.created_entity
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
    -- TODO Bug in 1.1.17: https://forums.factorio.com/viewtopic.php?f=7&t=113438
    -- Change when Wube has fixed it.
    --{filter = "ghost_name", name = "tile-ghost", mode = "and"},--require("getTileNames").digable, mode = "and"},
    --{filter = "ghost_type", type = "tile-ghost", mode = "and"}--"tile", mode = "and"}
  }
}