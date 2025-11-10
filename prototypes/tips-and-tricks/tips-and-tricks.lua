local tnt1 = {
  type = "tips-and-tricks-item",
  name = "canex-excavator-tnt",
  tag = "[item=canex-digable][item=canex-excavator]",
  category = "game-interaction",
  order = "p-canex-1",
  trigger =
  {
    type = "research",
    technology = "canex-excavator"
  },
  simulation = {
    mods = {"canal-excavator"},
    game_view_settings = { default_show_value = false, show_controller_gui = true, show_quickbar = true, update_entity_selection = true },
    init_file = "__canal-excavator__/prototypes/tips-and-tricks/tips-and-tricks-init.lua"
  }
}

local tnt2 = {
  type = "tips-and-tricks-item",
  name = "canex-canals-tnt",
  tag = "[item=canex-digable][item=canex-excavator]",
  category = "game-interaction",
  order = "p-canex-2",
  starting_status = "dependencies-not-met",
  dependencies = {"canex-excavator-tnt"},
  simulation = {
    mods = {"canal-excavator"},
    game_view_settings = { default_show_value = false, show_controller_gui = true, show_quickbar = true, update_entity_selection = true },
    init_file = "__canal-excavator__/prototypes/tips-and-tricks/tips-and-tricks-init-2.lua"
  }
}

if mods["space-age"] then
  tnt2.localised_description = {
    "?",
    {"tile.lava"},
    {
      "",
      {"tips-and-tricks-item-description.canex-canals-tnt"},
      {"tips-and-tricks-item-description.canex-canals-sa-tnt"}
    },
    {"tips-and-tricks-item-description.canex-canals"}
  }
end

data:extend {tnt1, tnt2}
