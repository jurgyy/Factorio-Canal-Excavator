---@class CanexPlanetConfigModData : data.ModData
---@field data_type "canex-planet-config"
---@field data CanexPlanetConfig

---@class LuaCanexPlanetConfigModData : LuaModData
---@field data_type "canex-planet-config"
---@field data CanexPlanetConfig

---@alias CanexPlanetsConfig table<string, CanexPlanetConfig> Table indexed by the PlanetPrototype.name with that planets excavator configuration

---@class CanexPlanetConfig
---@field mineResult string Mine result item
---@field isDefault boolean? Fallback config for surfaces without a planet. Only one config can be the default
---@field oreStartingAmount integer Amount of ore that should be placed when placing a excavatable tile
---@field tint Color Tint for the dust, rocks and resource

---@class CanexPlanetOverwriteConfig
---@field mineResult string?
---@field isDefault boolean?
---@field oreStartingAmount integer?
---@field tint Color?
---@field overwrite boolean Set this to true to signal you want to overwrite


local planetConfigHelper = {}

---@type table<string, CanexPlanetConfig>
local config_cache = {}
local all_cached = false
local planet_config_data_type = "canex-planet-config"

---@param planetName string PlanetPrototype.name
---@return string mod_data_name
planetConfigHelper.get_mod_data_name = function (planetName)
  return "canex-" .. planetName .. "-config"
end

---@param planetName string PlanetPrototype.name
---@return CanexPlanetConfig?
planetConfigHelper.get_mod_data = function(planetName)
  local name = planetConfigHelper.get_mod_data_name(planetName)
  local cached = config_cache[name]
  if cached then return cached end

  local mod_data
  if script then
    -- Runtime
    mod_data = prototypes.mod_data[name]
    ---@cast mod_data LuaCanexPlanetConfigModData
  else
    -- Data stage
    mod_data = data.raw["mod-data"][name]
    ---@cast mod_data CanexPlanetConfigModData
  end

  if not mod_data then return nil end
  if mod_data.data_type ~= planet_config_data_type then error("Retrieved mod_data object of unexpected type: " .. mod_data.data_type) end

  config_cache[planetName] = mod_data.data
  return mod_data.data
end

---@return table<string, CanexPlanetConfig>
planetConfigHelper.get_all_planets_config = function()
  if all_cached then
    return config_cache
  end

  local planets
  if script then
    for name, prototype in pairs(prototypes.space_location) do
      if prototype.type == "planet" then
        planetConfigHelper.get_mod_data(name)
      end
    end
  else
    for _, prototype in pairs(data.raw.planet) do
      planetConfigHelper.get_mod_data(prototype.name)
    end
  end
  all_cached = true
  return config_cache
end

---@param command CustomCommandData
planetConfigHelper.dump_planet_config = function(command)
    if command.parameter then
        local config = serpent.line(planetConfigHelper.get_mod_data(command.parameter))
        log(config)
        game.print(config)
    else
        local config = serpent.line(planetConfigHelper.get_all_planets_config())
        log(config)
        game.print(config)
    end
end

return planetConfigHelper