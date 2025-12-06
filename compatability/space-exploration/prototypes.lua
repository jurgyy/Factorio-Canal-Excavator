local universe = require("__space-exploration__.scripts.universe-raw")
if not universe then error("Unable to load Space Exploration universe") end

local icon = {
  icon = "__space-exploration-graphics__/graphics/entity/starmap/planet-base.png",
  icon_size = 512,
  scale = 1/4
}

data:extend({
  ---- Example for a surface with a fixed configuration:
  -- {
  --   type = "mod-data",
  --   name = "canex-se-hermes-config",
  --   data_type = "canex-surface-config",
  --   data = {
  --     surfaceName = "Hermes",
  --     localisation = "Hermes",
  --     mineResult = "se-water-ice",
  --     oreStartingAmount = 50,
  --     tint = {r = 159, g = 193, b = 222}
  --   }
  -- },
  ---- Here the surface called "Hermes" would yield se-water-ice.
  ---- If surfaces are dynamically created you can also register templates.
  ---- This requires some compatabillity scripting via remote interfaces.
  ---- See the registration of the remote at the bottom of this file and the remote interface in control/remote.lua
  ---- And how the registrations are used in control/events/surfaceCreatedEvent.lua
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
  },
  -- Register the remote
  {
    type = "mod-data",
    name = "canex-se-surface-created-remote",
    data_type = "canex-surface-created-remote",
    data = {
      interface = "canal-excavator", -- Since I've implemented the remote for SE myself, this is set to this mod's remote interface, but I generally expect your remote interface here.
      get_surface_template_function = "se_get_zone_template"
    }
  }
})