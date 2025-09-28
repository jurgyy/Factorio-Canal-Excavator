---@class CanexSurfaceConfigModData : data.ModData
---@field data_type "canex-surface-config"
---@field data CanexSurfaceConfig

---@class LuaCanexSurfaceConfigModData : LuaModData
---@field data_type "canex-surface-config"
---@field data CanexSurfaceConfig

---@class CanexSurfaceConfig
---@field surfaceName string
---@field mineResult string Mine result item
---@field isDefault boolean? Fallback config for surfaces without a planet. Only one config can be the default TODO still required?
---@field oreStartingAmount integer Amount of ore that should be placed when placing a excavatable tile
---@field tint Color Tint for the dust, rocks and resource


local surfaceConfigHelper = {}

---@type table<string, CanexSurfaceConfig>
local surface_config_cache = {}
local all_cached = false
local surface_config_data_type = "canex-surface-config"

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
  if mod_data.data_type ~= surface_config_data_type then error("Retrieved mod_data object of unexpected type: " .. mod_data.data_type) end

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
    if prototype.data_type == surface_config_data_type then
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