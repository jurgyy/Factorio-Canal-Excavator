local surface_config_helper = require("global.surfaceConfigHelper")
local universe = require("__space-exploration__.scripts.universe-raw")
if not universe then error("Unable to load Space Exploration universe") end

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
  ---- See the registration of the remote bellow and the remote interface in control/remote.lua
  ---- And how the registrations are used in control/events/surfaceCreatedEvent.lua
  {
    type = "mod-data",
    name = "canex-se-vitamelange-template",
    data_type = "canex-surface-template",
    data = {
      localisation = {"se.canex-vita-zones"},
      mineResult = "se-vitamelange",
      oreStartingAmount = 5,
      tint = {r = 102, g = 102, b = 51},
      icon_data = {
        icons = {
          {
            icon = "__space-exploration-graphics__/graphics/entity/starmap/planet-base.png",
            icon_size = 512,
            tint = {r = 150, g = 200, b = 130}
          },
          {
            icon = "__space-exploration-graphics__/graphics/entity/starmap/planet-water.png",
            icon_size = 512
          }
        }
      },
    }
  },
  {
    type = "mod-data",
    name = "canex-se-ice-template",
    data_type = "canex-surface-template",
    data = {
      localisation = {"se.canex-frozen-zones"},
      mineResult = "se-water-ice",
      oreStartingAmount = 25,
      tint = {r = 159, g = 193, b = 222},
      icon_data = {
        icons = {
          {
            icon = "__space-exploration-graphics__/graphics/entity/starmap/planet-base.png",
            icon_size = 512,
            tint = {r = 160, g = 215, b = 240}
          },
          {
            icon = "__space-exploration-graphics__/graphics/entity/starmap/planet-cloud-ice.png",
            icon_size = 512
          }
        }
      }
    }
  },
  {
    type = "mod-data",
    name = "canex-se-stone-template",
    data_type = "canex-surface-template",
    data = {
      localisation = {"se.canex-rocky-zones"},
      mineResult = "stone",
      oreStartingAmount = 10,
      tint = {r = 102, g = 78, b = 6},
      icon_data = {
        icons = {
          {
            icon = "__space-exploration-graphics__/graphics/entity/starmap/planet-base.png",
            icon_size = 512
          },
          {
            icon = "__space-exploration-graphics__/graphics/entity/starmap/planet-water.png",
            icon_size = 512
          }
        }
      }
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

-- Set the Nauvis icon with the SE graphics since without Space Age we don't have access to the vanilla icon.
local nauvis = surface_config_helper.get_mod_data_name("nauvis")
data.raw["mod-data"][nauvis].data.icon_data =
{
  icons = {
    {
      icon = "__space-exploration-graphics__/graphics/entity/starmap/planet-base.png",
      icon_size = 512,
      tint = {r = 170, g = 230, b = 145, a = 125},
    },
    {
      icon = "__space-exploration-graphics__/graphics/entity/starmap/planet-water.png",
      icon_size = 512
    },
    {
      icon = "__space-exploration-graphics__/graphics/entity/starmap/planet-haze.png",
      icon_size = 512,
      tint = {r = 20, g = 140, b = 190, a = 10}
    }
  }
}