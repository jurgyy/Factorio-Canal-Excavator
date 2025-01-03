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


---Get a table with all the resource names for all the planets
---@return table<string> resource_names
local function get_all_resource_names()
    local resource_names = {}
    for name, _ in pairs(planetConfigs) do
        table.insert(resource_names, "canex-rsc-digable-" .. name)
    end

    return resource_names
end

planetsManager = {}

planetsManager.resource_names = get_all_resource_names()

---Is the planet corresponding to a given surface configured
---@param surface LuaSurface
---@return boolean is_configured
planetsManager.is_surface_configured = function(surface)
    if not surface.planet then
        return false
    end

    local planetName = surface.planet.name
    return planetConfigs[planetName] ~= nil
end
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

---Retrieve the name of the CanexPlanetsConfig key for a given surface. Returns the key of the default config if the surface has no planet
---@param surface LuaSurface
---@return string key
planetsManager.get_planet_config_name = function(surface)
    if surface.planet then
        return surface.planet.name
    end

    if not surface.planet then
        for name, config in pairs(planetConfigs) do
            if config.isDefault then
                return name
            end
        end
    end
    
    error("No default planet configured")
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