local dig_manager = require("digManager")
local ore_manager = require("oreManager")
local digableTileName = require("getTileNames").digable

local function entity_built_event(event)
  local entity = event.created_entity
  if entity.valid then
    if entity.name == "canal-excavator"
    or entity.is_registered_for_construction() and entity.ghost_prototype.name == "canal-excavator" then
      -- (Ghost) Excavator placed
      entity.rotatable = false

    elseif entity.is_registered_for_construction()
    and entity.ghost_prototype.name == digableTileName then
      -- Ghost marker placed
      if dig_manager.is_dug(entity.surface, entity.position) then
        entity.destroy()

      elseif settings.get_player_settings(event.player_index)["auto-deconstruct"].value then
        -- Mark entities on ghost tile for deconstruction
        local non_excavators = ore_manager.get_colliding_entities(event.created_entity.surface, event.created_entity.position)
        for _, collidingEntity in pairs(non_excavators) do
          if not collidingEntity.is_registered_for_construction() or collidingEntity.ghost_prototype.name ~= digableTileName then
            collidingEntity.order_deconstruction(game.get_player(event.player_index).force)
          end
        end
      end
    end
  end
end

return entity_built_event