local surface_config_helper = require("global.surfaceConfigHelper")
local surface_configs = surface_config_helper.get_all_surface_config()

local resourceTemplate = require("prototypes.digable.resourceTemplate")

for _, surface_config in pairs(surface_configs) do
  log("Adding Canex config for surface " .. surface_config.surfaceName)

  local resource = table.deepcopy(resourceTemplate)
  resource.name = resource.name .. surface_config.surfaceName
  resource.minable.results[1].name = surface_config.mineResult
  resource.map_color = surface_config.tint
  resource.mining_visualisation_tint = surface_config.tint
  resource.stages.sheet.tint = surface_config.tint
  resource.icons[1].tint = surface_config.tint

  if mods["space-age"] then
    local planet = data.raw["planet"][surface_config.surfaceName]
    if planet then
      resource.icons[2] = resource.icons[1]
      if planet.icons then
        resource.icons[1] = planet.icons[1]
      else
        resource.icons[1] = {
          icon = planet.icon,
        }
      end
      resource.icons[1].scale = 0.5
      resource.icons[1].shift = {x = -16, y = -16}
    end
  end

  if surface_config.localisation then
    resource.localised_name =  {"entity-name.canex-rsc-digable-surface", {"entity-description.canex-on", surface_config.localisation}}
    resource.localised_description = {"entity-description.canex-rsc-digable-surface", {"entity-description.canex-on", surface_config.localisation}}
  end

  data:extend({resource})
end

for name, mod_data in pairs(data.raw["mod-data"]) do
  if mod_data.data_type == surface_config_helper.surface_template_data_type then
    ---@cast mod_data CanexSurfaceTemplateModData

    local template_config = mod_data.data
    -- config.name = mod_data.name
    data.raw["mod-data"][name].data.name = name
    local resource = table.deepcopy(resourceTemplate)
    resource.name = resource.name .. mod_data.name
    if template_config.localisation then
      resource.localised_name = {"entity-name.canex-rsc-digable-surface", {"entity-description.canex-in", template_config.localisation}}
      resource.localised_description = {"entity-description.canex-rsc-digable-surface", {"entity-description.canex-in", template_config.localisation}}
    end
    resource.minable.results[1].name = template_config.mineResult
    resource.map_color = template_config.tint
    resource.mining_visualisation_tint = template_config.tint
    resource.stages.sheet.tint = template_config.tint
    resource.icons[1].tint = template_config.tint

    local icon = template_config.icon
    if icon then
      if (icon.type) then
        local prototype = data.raw[icon.type][icon.name]
        resource.icons[2] = resource.icons[1]
        if prototype.icons then
          resource.icons[1] = prototype.icons[1]
        else
          resource.icons[1] = {
            icon = prototype.icon,
          }
        end
        resource.icons[1].shift = {x = -16, y = -16}
      else
        resource.icons[2] = resource.icons[1]
        resource.icons[2].scale = 0.5 / icon.scale
        resource.icons[1] = icon
        resource.icons[1].shift = {x = -16 / icon.scale, y = -16 / icon.scale}
      end
      --resource.icons[1].scale = 0.5
    end
    data:extend({resource})
  end
end