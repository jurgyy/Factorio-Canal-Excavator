local marker = {
    type = "resource",
    name = "rsc-canal-marker",
    icon = "__my_first_mod__/graphics/icons/marker.png",
    icon_size = 32,
    flags = {"placeable-player", "player-creation", "not-repairable", "not-flammable"},
    category = "ent-canal-marker",
    order = "e[canal-marker]",
    highlight = false,
    minimum = 0,
    normal = 1,
    walking_sound =
    {
        filename = "__base__/sound/walking/resources/ore-01.ogg",
        volume = 0.7
    },
    minable =
    {
      mining_time = 1,
      result = "stone"
    },
    collision_box = {{ -0.49, -0.49}, {0.49, 0.49}},
    selection_box = {{ -0.49, -0.49}, {0.49, 0.49}},
    map_color = { r = 0.181, g = 0.104, b = 0.075},
    mining_visualisation_tint = {r = 0.490, g = 0.304, b = 0.0245, a = 1.000},

    stages = {
      sheet = {
        -- Replace the following lines to make them visible for debugging purposes
        -- filename = "__my_first_mod__/graphics/canal-marker-vis.png",
        filename = "__my_first_mod__/graphics/canal-marker.png",
        size = 64,
        variation_count = 1
      }
    },
    stage_counts = {0}
    -- stages = data.raw.resource["stone"].stages,
    -- stage_counts = {32, 28, 24, 12, 8, 4, 2, 1},
}

-- local tint = { r = 0.300, g = 0.300, b = 0.03,   a = 0.5 }
-- marker.stages.sheet.tint = tint
-- marker.stages.sheet.hr_version.tint = tint
return marker