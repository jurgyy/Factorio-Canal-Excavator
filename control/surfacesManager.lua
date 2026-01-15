local surface_config_helper = require("global.surfaceConfigHelper")

local surfaceConfigs = surface_config_helper.get_all_surface_config()
local resource_names = {}

for surface_name, config in pairs(surfaceConfigs) do
  local resource_name = "canex-rsc-digable-" .. config.surfaceName
  if prototypes.entity[resource_name] then
    resource_names[surface_name] = resource_name
  end
end

surfacesManager = {}

surfacesManager.resource_names = resource_names

surfacesManager.load_stored_config = function()
  ---@cast surfaceConfigs +table<string, CanexSurfaceTemplate>
  for surfaceName, surfaceTemplate in pairs(storage.runtime_surface_config or {}) do
    surfaceConfigs[surfaceName] = surfaceTemplate
    resource_names[surfaceName] = "canex-rsc-digable-" .. surfaceTemplate.name
  end
end

---@param surface LuaSurface|string Surface or surface name
---@return boolean is_configured
surfacesManager.is_surface_configured = function(surface)
  local name = surface.name or surface
  return surfaceConfigs[name] ~= nil
end

---Get the config of a given surface.
---Returns nil if surface isn't configured.
---@param surface LuaSurface|string Surface or surface name
---@return CanexConfigBase?
surfacesManager.get_surface_config = function(surface)
  local name = surface.name or surface
  return surfaceConfigs[name]
end

---@param surface LuaSurface
---@param surfaceTemplateName string CanexSurfaceTemplate.name
surfacesManager.add_surface_config = function(surface, surfaceTemplateName)
  if not storage.runtime_surface_config then
    storage.runtime_surface_config = {}
  end
  local surfaceName = surface.name
  if storage.runtime_surface_config[surfaceName] then
    error("Surface " .. surface.name .. " already configured")
  end
  local mod_data = prototypes.mod_data[surfaceTemplateName]
  if not mod_data then
    error("No surface template with name " .. surfaceTemplateName)
  end
  if mod_data.data_type ~= surface_config_helper.surface_template_data_type then
    error("Surface template is of type " .. mod_data.data_type .. ", expected " .. surface_config_helper.surface_template_data_type)
  end

  surfaceConfigs[surfaceName] = mod_data.data
  resource_names[surfaceName] = "canex-rsc-digable-" .. mod_data.name
  storage.runtime_surface_config[surfaceName] = mod_data.data
end

return surfacesManager