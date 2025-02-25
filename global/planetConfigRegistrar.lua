---@type CanexPlanetsConfig
local planet_configs = {}
local prefix = require("settings.configSettingsPrefix")
local registrar = {}

---Register or overwrite the configuration of the excavator for a given planet
---@param planet_name string
---@param planet_config CanexPlanetConfig|CanexPlanetOverwriteConfig
local function register_planet_config(planet_name, planet_config)
    local existing_planet = planet_configs[planet_name]
    if planet_config.overwrite then
        ---@cast planet_config CanexPlanetOverwriteConfig
        if not existing_planet then error("Planet " .. planet_name .. " can't be overwritten as it's not registered yet") end

        for key, value in pairs(planet_config) do
            planet_configs[planet_name][key] = value
        end
    else
        ---@cast planet_config CanexPlanetConfig
        planet_configs[planet_name] = planet_config
    end
end

registrar.load_configs_from_settings = function()
    for name, setting in pairs(settings.startup) do
        if name:find(prefix) then
            ---@type table<string, CanexPlanetConfig|CanexPlanetOverwriteConfig>
            local configs = require(setting.value --[[@as string]])
            for planet_name, config in pairs(configs) do
                register_planet_config(planet_name, config)
            end
        end
    end
end

---Retrieve the registered planet config
---@param planet_name string
---@return CanexPlanetConfig
registrar.get_planet_config = function(planet_name)
    return planet_configs[planet_name]
end

---Retrieve the table with all CanexPlanetsConfig index by the planet name
---@return CanexPlanetsConfig
registrar.get_all_planets_config = function()
    return planet_configs
end

---@param command CustomCommandData
registrar.dump_planet_config = function(command)
    if command.parameter then
        local config = serpent.line(registrar.get_planet_config(command.parameter))
        log(config)
        game.print(config)
    else
        local config = serpent.line(registrar.get_all_planets_config())
        log(config)
        game.print(config)
    end
end

return registrar