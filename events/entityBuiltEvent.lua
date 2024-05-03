local dig_manager = require("digManager")

local function entity_built_event(event)
    local entity = event.created_entity
    if entity.valid then
      if entity.name == "canal-excavator"
      or entity.is_registered_for_construction() and entity.ghost_prototype.name == "canal-excavator" then
        entity.rotatable = false
      elseif entity.is_registered_for_construction()
      and entity.ghost_prototype.name == "tile-canal-marker"
      and dig_manager.is_dug(entity.surface, entity.position) then
        entity.destroy()
      end
    end
 end

 return entity_built_event