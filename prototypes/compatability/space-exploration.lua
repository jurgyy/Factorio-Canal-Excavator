local universe = require("__space-exploration__.scripts.universe-raw")
if not universe then error("Unable to load Space Exploration universe") end

local icon = {
  icon = "__space-exploration-graphics__/graphics/entity/starmap/planet-base.png",
  icon_size = 512,
  scale = 1/4
}

data:extend({
  -- Example for a "fixed" zone:
  -- {
  --   type = "mod-data",
  --   name = "canex-se-glacier-config",
  --   data_type = "canex-surface-config",
  --   data = {
  --     surfaceName = "Glacier",
  --     localisation = "Glacier",
  --     mineResult = "se-water-ice",
  --     oreStartingAmount = 50,
  --     tint = {r = 159, g = 193, b = 222}
  --   }
  -- },
  -- Any Vitamelange zone:
  {
    type = "mod-data",
    name = "canex-se-vitamelange-template",
    data_type = "canex-surface-template",
    data = {
      icon = icon,
      localisation = {"se.canex-vita-zones"},
      mineResult = "se-vitamelange",
      oreStartingAmount = 5,
      tint = {r = 102, g = 102, b = 51}
    }
  },
  {
    type = "mod-data",
    name = "canex-se-ice-template",
    data_type = "canex-surface-template",
    data = {
      icon = icon,
      localisation = {"se.canex-frozen-zones"},
      mineResult = "se-water-ice",
      oreStartingAmount = 25,
      tint = {r = 159, g = 193, b = 222}
    }
  },
  {
    type = "mod-data",
    name = "canex-se-stone-template",
    data_type = "canex-surface-template",
    data = {
      icon = icon,
      localisation = {"se.canex-rocky-zones"},
      mineResult = "stone",
      oreStartingAmount = 10,
      tint = {r = 102, g = 78, b = 6},
    }
  }
})