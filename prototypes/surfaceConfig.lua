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
        mineResult = "stone",
        oreStartingAmount = 40,
        tint = {r = 120, g = 120, b = 120}
    }),
    create_surface_mod_data({
        surfaceName = "fulgora",
        mineResult = "scrap",
        oreStartingAmount = 10,
        tint = {r = 173, g = 94, b = 72}
    }),
    create_surface_mod_data({
        surfaceName = "gleba",
        mineResult = "spoilage",
        oreStartingAmount = 50,
        tint = {r = 186, g = 196, b = 149}
    }),
    create_surface_mod_data({
        surfaceName = "aquilo",
        mineResult = "ice",
        oreStartingAmount = 50,
        tint = {r = 159, g = 193, b = 222}
    })
  }
end