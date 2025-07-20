local planet_config_helper = require("global.planetConfigHelper")

---@param planetName string PlanetPrototype.name
---@param config CanexPlanetConfig
---@return CanexPlanetConfigModData
local function create_planet_mod_data(planetName, config)
  return {
    type = "mod-data",
    name = planet_config_helper.get_mod_data_name(planetName),
    data_type = "canex-planet-config",
    data = config
  } --[[@as CanexPlanetConfigModData]]
end

data:extend{
  create_planet_mod_data("nauvis", {
        mineResult = "stone",
        oreStartingAmount = 10,
        tint = {r = 102, g = 78, b = 6},
        isDefault = true
  })
}

if mods["space-age"] then
  data:extend{
    create_planet_mod_data("vulcanus", {
        mineResult = "stone",
        oreStartingAmount = 40,
        tint = {r = 120, g = 120, b = 120}
    }),
    create_planet_mod_data("fulgora", {
        mineResult = "scrap",
        oreStartingAmount = 10,
        tint = {r = 173, g = 94, b = 72}
    }),
    create_planet_mod_data("gleba", {
        mineResult = "spoilage",
        oreStartingAmount = 50,
        tint = {r = 186, g = 196, b = 149}
    }),
    create_planet_mod_data("aquilo", {
        mineResult = "ice",
        oreStartingAmount = 50,
        tint = {r = 159, g = 193, b = 222}
    })
  }
end