local planetConfigs = require("planetConfig")

---@type CanexPlanetConfig
local defaultConfig = nil
for _, config in pairs(planetConfigs) do
    if config.isDefault then
        defaultConfig = config
    end
end

---@type table<string, CanexPlanetConfig> Table indexed by LuaSurface.name for that surface's PlanetConfig
local surface_planet_cache = {}

planetsManager = {}

planetsManager.get_planet_config = function(surface)
    if surface_planet_cache[surface.name] then return surface_planet_cache[surface.name] end

    if not surface.planet then
        return defaultConfig
    end

    local planetName = surface.planet.name
    local config = planetConfigs[planetName]
    if not config then
        error("Trying to retrieve Canex planet config of unconfigured planet " .. planetName)
    end

    surface_planet_cache[planetName] = config
    return config
end

---Returns true if the given tile name is the name of any of the known water tiles for the given planetConfig
---@param planetConfig CanexPlanetConfig The config of the planet that's being checked
---@param tile_name string The name of the tile you want to check
---@return boolean
planetsManager.is_tile_water = function(planetConfig, tile_name)
    for _, water_tile_name in ipairs(planetConfig.fluidBodyTiles) do
        if tile_name == water_tile_name then
            return true
        end
    end
    return false
end

return planetsManager