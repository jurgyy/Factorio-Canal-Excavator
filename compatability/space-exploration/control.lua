local surface_manager = require("control.surfacesManager")

local se_control = {}

  ---@param event EventData.on_surface_created
se_control.on_surface_created = function(event)
    local surface = game.surfaces[event.surface_index]
    local zone = remote.call("space-exploration", "get_zone_from_name", {zone_name = surface.name})

    ---@diagnostic disable: undefined-field
    if not zone or not zone.tags then return end
    local tags = zone.tags
    if not tags["water"] or tags["water"] == "water_none" then return end

    local primary_resource = zone.primary_resource
    ---@diagnostic enable: undefined-field

    if tags["temperature"] and tags["temperature"] == "temperature_frozen" then
      surface_manager.add_surface_config(surface, "canex-se-ice-template")
      return
    end
    if primary_resource == "se-vitamelange" then
      surface_manager.add_surface_config(surface, "canex-se-vitamelange-template")
      return
    end
    surface_manager.add_surface_config(surface, "canex-se-stone-template")
end

return se_control