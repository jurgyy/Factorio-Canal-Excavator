local dig_manager = require("digManager")

local function ghost_marker_built_event(event)
    local entity = event.created_entity
    if entity.valid
    and entity.is_registered_for_construction()
    and entity.ghost_prototype.name == "tile-canal-marker"
    and dig_manager.is_dug(entity.surface, entity.position) then
      entity.destroy()
    end
 end

 return ghost_marker_built_event