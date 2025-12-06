--- Surface Config
---@class CanexSurfaceConfigModData : data.ModData The data stage mod-data type for `CanexSurfaceConfig`
---@field data_type "canex-surface-config"
---@field data CanexSurfaceConfig

---@class LuaCanexSurfaceConfigModData : LuaModData The runtime mod-data type for `CanexSurfaceConfig`
---@field data_type "canex-surface-config"
---@field data CanexSurfaceConfig

---@class CanexConfigBase Base class for both SurfaceConfig as well as SurfaceTemplates
---@field localisation LocalisedString? Localised name to use for the resource: "Excavatable resource {localisation}". Expected to be lower case except for proper nouns.
---@field mineResult string Mine result item
---@field oreStartingAmount integer Amount of ore that should be placed when placing a excavatable tile
---@field tint Color Tint for the dust, rocks and resource

---@class CanexSurfaceConfig : CanexConfigBase
---@field surfaceName string
-- Also contains fields of CanexConfigBase (see above)

--------------------------------
--- Surface Template
---@class CanexSurfaceTemplateModData : data.ModData The data stage mod-data type for `CanexSurfaceTemplate`
---@field data_type "canex-surface-template"
---@field data CanexSurfaceTemplate

---@class LuaCanexSurfaceTemplateModData : LuaModData The runtime stage mod-data type for `CanexSurfaceTemplate`
---@field data_type "canex-surface-template"
---@field data CanexSurfaceTemplate

---@class CanexSurfaceTemplate : CanexConfigBase
---@field icon table?
---@field name string name of the parent object. Will be set in Canex data-final-fixes.
-- Also contains fields of CanexConfigBase (see above)

--------------------------------
--- Remote for surface created event handler
---@class CanexSurfaceCreatedRemoteModData : data.ModData The data stage mod-data type for `CanexSurfaceCreatedRemote`
---@field data_type "canex-surface-created-remote"
---@field data CanexSurfaceCreatedRemote

---@class LuaCanexSurfaceCreatedRemoteModData : LuaModData The runtime mod-data type for `CanexSurfaceCreatedRemote`
---@field data_type "canex-surface-created-remote"
---@field data CanexSurfaceCreatedRemote

---@class CanexSurfaceCreatedRemote
---@field interface string Remote interface to call `get_surface_template_function` on
---@field get_surface_template_function string Remote function that takes a LuaSurface and returns the CanexSurfaceTemplate.name associated with the surface or nil


---@type table<string, CanexSurfaceConfig>
local surface_config_cache = {}

local surfaceConfigHelper = {}
surfaceConfigHelper.surface_config_data_type = "canex-surface-config"
surfaceConfigHelper.surface_template_data_type = "canex-surface-template"

local function get_all_surface_config()
  local iterator = nil
  if script then
    iterator = prototypes.mod_data
  else
    iterator = data.raw["mod-data"]
  end

  for _, prototype in pairs(iterator) do
    if prototype.data_type == surfaceConfigHelper.surface_config_data_type then
      surface_config_cache[prototype.data.surfaceName] = prototype.data
      -- resource_names[prototype.data.surfaceName] = "canex-rsc-digable-" .. prototype.data.surfaceName
    end
  end
  return surface_config_cache
end

--get_all_surface_config()

---@param surfaceName string SurfacePrototype.name
---@return string mod_data_name
surfaceConfigHelper.get_mod_data_name = function (surfaceName)
  return "canex-" .. surfaceName .. "-config"
end

---@param surfaceName string SurfacePrototype.name
---@return CanexSurfaceConfig?
surfaceConfigHelper.get_mod_data = function(surfaceName)
  local name = surfaceConfigHelper.get_mod_data_name(surfaceName)
  local cached = surface_config_cache[name]
  if cached then return cached end

  local mod_data
  if script then
    -- Runtime
    mod_data = prototypes.mod_data[name]
    ---@cast mod_data LuaCanexSurfaceConfigModData
  else
    -- Data stage
    mod_data = data.raw["mod-data"][name]
    ---@cast mod_data CanexSurfaceConfigModData
  end

  if not mod_data then return nil end
  if mod_data.data_type ~= surfaceConfigHelper.surface_config_data_type then error("Retrieved mod_data object of unexpected type: " .. mod_data.data_type) end

  surface_config_cache[surfaceName] = mod_data.data
  return mod_data.data
end


---@return table<string, CanexSurfaceConfig> SurfaceConfigMap Table that maps a surface's name with its CanexSurfaceConfig
surfaceConfigHelper.get_all_surface_config = function()
  if all_cached then
    return surface_config_cache
  end

  local iterator = nil
  if script then
    iterator = prototypes.mod_data
  else
    iterator = data.raw["mod-data"]
  end

  for _, prototype in pairs(iterator) do
    if prototype.data_type == surfaceConfigHelper.surface_config_data_type then
      surface_config_cache[prototype.data.surfaceName] = prototype.data
    end
  end

  all_cached = true
  return surface_config_cache
end

---@param command CustomCommandData
surfaceConfigHelper.dump_surface_config = function(command)
    if command.parameter then
        local config = serpent.line(surfaceConfigHelper.get_mod_data(command.parameter))
        log(config)
        game.print(config)
    else
        local config = serpent.line(surfaceConfigHelper.get_all_surface_config())
        log(config)
        game.print(config)
    end
end

return surfaceConfigHelper