local surface_config_helper = require("global.surfaceConfigHelper")

local surfaceConfigs = surface_config_helper.get_all_surface_config()

---@type CanexSurfaceConfig
local defaultConfig = nil
for name, config in pairs(surfaceConfigs) do
    if config.isDefault then
        if defaultConfig ~= nil then
            error(name .. " is already configured as default")
        end
        defaultConfig = config
    end
end
if not defaultConfig then error("No default surface configured") end

---Get a table with all the resource names for all the surfaces
---@return table<string> resource_names
local function get_all_resource_names()
    local resource_names = {}
    for _, config in pairs(surfaceConfigs) do
        table.insert(resource_names, "canex-rsc-digable-" .. config.surfaceName)
    end

    return resource_names
end

surfacesManager = {}

surfacesManager.resource_names = get_all_resource_names()

---@param surface LuaSurface|string Surface or surface name
---@return boolean is_configured
surfacesManager.is_surface_configured = function(surface)
    return surfaceConfigs[surface.name or surface] ~= nil
end

---Get the config of a given surface.
---Returns nil if surface isn't configured.
---@param surface LuaSurface|string Surface or surface name
---@return CanexSurfaceConfig?
surfacesManager.get_surface_config = function(surface)
    return surfaceConfigs[surface.name or surface]
end

return surfacesManager