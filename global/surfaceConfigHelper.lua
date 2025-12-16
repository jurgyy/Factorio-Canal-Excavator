--- Surface Config
---@class CanexSurfaceConfigModData : data.ModData The data stage mod-data type for `CanexSurfaceConfig`
---@field data_type "canex-surface-config"
---@field data CanexSurfaceConfig

---@class LuaCanexSurfaceConfigModData : LuaModData The runtime mod-data type for `CanexSurfaceConfig`
---@field data_type "canex-surface-config"
---@field data CanexSurfaceConfig

---@class CanexConfigBase Base class for both SurfaceConfig as well as SurfaceTemplates
---@field localisation LocalisedString? Localised name to use for the resource: "Excavatable resource {localisation}". Expected to be lower case except for proper nouns.
---@field mineResult string|data.ItemProductPrototype[] Mine result(s) of the item
---@field oreStartingAmount integer Amount of ore that should be placed when placing a excavatable tile
---@field tint Color Tint for the dust, rocks and resource
---@field icon_data CanexIconData? Optional icon data. Only used for the Factoriopedia icon of the resources. With Space Age defaults to the icon of the planet with the same name as surfaceName.
---@field mining_time double? How many seconds are required to mine this object at 1 mining speed. Defaults to 1.
---@field custom_resource_category string? Custom resource category to use. If unset, uses "canex-rsc-cat-digable". Set only if you also add a CanexExcavatorConfig with this custom_resource_category.

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

--------------------------------
--- Optional Icon data
---@class CanexIconData Only used for the Factoriopedia icon of the resources. If unset it uses the planet's icon if Space Age is installed, otherwise it shows just the resource icon.
---@field filename string? Filename of the icon.
---@field icons data.IconData[]? List of icons. Ignored if filename is set.
---@field icon_size integer? Size of the icon. Defaults to the icon size of icon_source or 64.
---@field icon_source_type string? Prototype type with an icon or icons to copy from. Ignored if filename or icons are set. If unset and Space Age is installed, uses "planet".
---@field icon_source_name string? Prototype name with an icon or icons to copy from. Ignored if filename or icons are set. Defaults to CanexSurfaceConfig.name

--------------------------------
--- Excavator Config for when you want to create custom canal excavators
---@class CanexExcavatorConfigModData : data.ModData The data stage mod-data type for `CanexExcavatorConfig`
---@field data_type "canex-excavator-config"
---@field data CanexExcavatorConfig

---@class LuaCanexExcavatorConfigModData : LuaModData The runtime mod-data type for `CanexExcavatorConfig`
---@field data_type "canex-excavator-config"
---@field data CanexExcavatorConfig

---@class CanexExcavatorConfig Config for each mining drill that should be able to mine excavatable tiles. Is used to add the resource category and during runtime events.
---@field entity_name string Name of the excavator entity
---@field item_name string Name of the excavator item
---@field custom_resource_category string? Custom resource category to use. If unset, uses "canex-rsc-cat-digable"

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