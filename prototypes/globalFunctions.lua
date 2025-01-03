---@type CanexPlanetsConfig
local planet_configs = {}

---Register or overwrite the configuration of the excavator for a given planet
---@param planet_name string
---@param planet_config CanexPlanetConfig
function canex_register_planet_config(planet_name, planet_config)
    planet_configs[planet_name] = planet_config
end

---Retrieve the registered planet config
---@param planet_name string
---@return CanexPlanetConfig
function canex_get_planet_config(planet_name)
    return planet_configs[planet_name]
end

---@return CanexPlanetsConfig
function canex_get_planets_config()
    return planet_configs
end