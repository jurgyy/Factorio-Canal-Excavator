local remnant = require("__canal-excavator-graphics__/graphics/remnant/destruct")

---@type data.CorpsePrototype
local corpse = {
  name = "canex-excavator-remnants",
  type = "corpse",
  expires = false,
  final_render_layer = "remnants",
  flags = {"placeable-neutral", "not-on-map"},
  hidden_in_factoriopedia = true,
  icon = "__canal-excavator-graphics__/graphics/icons/excavator-64.png",
  order = "e-x-c",
  remove_on_tile_placement = false,
  selectable_in_game = false,
  subgroup = "extraction-machine-remnants",
  tile_width = 3,
  tile_height = 7,
  time_before_removed = 54000, -- 15 minutes
  collision_box = {{ -1.29, -5.39}, {1.29, 1.49}},
  selection_box = {{ -1.5, -5.5}, {1.5, 1.5}},
  collision_mask = {layers = {}},
  animation = {
    layers = {{
      filename = "__canal-excavator-graphics__/graphics/remnant/destruct.png",
      line_length = 1,
      direction_count = 4,
      width = remnant.width,
      height = remnant.height,
      shift = remnant.shift,
      scale = remnant.scale,
    }
  }}
}

return corpse