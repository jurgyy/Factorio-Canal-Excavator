local surface_config_helper = require("global.surfaceConfigHelper")

---@param config CanexSurfaceConfig
---@return CanexSurfaceConfigModData
local function create_surface_mod_data(config)
  return {
    type = "mod-data",
    name = surface_config_helper.get_mod_data_name(config.surfaceName),
    data_type = "canex-surface-config",
    data = config
  } --[[@as CanexSurfaceConfigModData]]
end

data:extend{
  create_surface_mod_data({
    surfaceName = "nauvis",
    localisation = {"space-location-name.nauvis"},
    mineResult = "stone",
    oreStartingAmount = 10,
    tint = {r = 102, g = 78, b = 6}
  })
}

if mods["space-age"] then
  data:extend{
    create_surface_mod_data({
        surfaceName = "vulcanus",
        localisation = {"space-location-name.vulcanus"},
        mineResult = "stone",
        oreStartingAmount = 20,
        mining_time = 4,
        tint = {r = 120, g = 120, b = 120}
    }),
    create_surface_mod_data({
        surfaceName = "fulgora",
        localisation = {"space-location-name.fulgora"},
        mineResult = "scrap",
        oreStartingAmount = 10,
        mining_time = 1.5,
        tint = {r = 173, g = 94, b = 72}
    }),
    create_surface_mod_data({
        surfaceName = "gleba",
        localisation = {"space-location-name.gleba"},
        mineResult = "spoilage",
        oreStartingAmount = 50,
        mining_time = 0.5,
        tint = {r = 186, g = 196, b = 149}
    }),
    create_surface_mod_data({
        surfaceName = "aquilo",
        localisation = {"space-location-name.aquilo"},
        mineResult = "ice",
        oreStartingAmount = 50,
        tint = {r = 159, g = 193, b = 222}
    })
  }
end