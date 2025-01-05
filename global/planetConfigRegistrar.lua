---@type CanexPlanetsConfig
local planet_configs = {}
local prefix = require("configSettingsPrefix")
local registrar = {}

---@generic k
---@generic v
---@param t table<k, v>
---@param element v
---@return k? index
local function get_index(t, element)
    for idx, val in pairs(t) do
        if val == element then return idx end
    end
end

---Register or overwrite the configuration of the excavator for a given planet
---@param planet_name string
---@param planet_config CanexPlanetConfig|CanexPlanetOverwriteConfig
local function canex_register_planet_config(planet_name, planet_config)
    local existing_planet = planet_configs[planet_name]
    if existing_planet then
        ---@cast planet_config CanexPlanetOverwriteConfig

        for key, value in pairs(planet_config) do
            if key == "fluidBodyTilesModifier" then goto continue end

            if key == "fluidBodyTiles" then
                local modifier = planet_config[key .. "Modifier"] or "replace"
                if modifier == "add" then
                    for _, v in pairs(planet_config[key]) do
                        if get_index(existing_planet[key], v) then
                            error(v .. " already in config " .. planet_name .. "[" .. key .. "]")
                        end
                        table.insert(existing_planet[key], v)
                    end
                elseif modifier == "remove" then
                    for _, v in pairs(planet_config[key]) do
                        local index = get_index(existing_planet[key], v)
                        if not index then
                            error(v .. " not in config " .. planet_name .. "[" .. key .. "]")
                        end
                        table.remove(existing_planet[key], index)
                    end
                elseif modifier == "replace" then
                    existing_planet[key] = value
                end
            else
                planet_configs[planet_name][key] = value
            end
            ::continue::
        end
    else
        ---@cast planet_config CanexPlanetConfig
        planet_configs[planet_name] = planet_config
    end
end

registrar.register_configs_from_settings = function()
    for name, setting in pairs(settings.startup) do
        if name:find(prefix) then
            ---@type table<string, CanexPlanetConfig|CanexPlanetOverwriteConfig>
            local configs = require(setting.value --[[@as string]])
            for planet_name, config in pairs(configs) do
                canex_register_planet_config(planet_name, config)
            end
        end
    end
end

---Retrieve the registered planet config
---@param planet_name string
---@return CanexPlanetConfig
registrar.canex_get_planet_config = function(planet_name)
    return planet_configs[planet_name]
end

---Retrieve the table with all CanexPlanetsConfig index by the planet name
---@return CanexPlanetsConfig
registrar.canex_get_planets_config = function()
    return planet_configs
end

---@param command CustomCommandData
registrar.canex_dump_planet_config = function(command)
    if command.parameter then
        local config = serpent.line(registrar.canex_get_planet_config(command.parameter))
        log(config)
        game.print(config)
    else
        local config = serpent.line(registrar.canex_get_planets_config())
        log(config)
        game.print(config)
    end
end

return registrar