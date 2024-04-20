return {
    type = "resource",
    name = "rsc-canal-marker",
    icon = "__my_first_mod__/graphics/icons/icon.png",
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
    map_color = {r = 0.490, g = 0.304, b = 0.0245},
    mining_visualisation_tint = {r = 0.490, g = 0.304, b = 0.0245, a = 1.000},

    -- stages = data.raw["resource"]["copper-ore"].stages,
    stages = {
      sheet = {
        -- Replace the following lines to make them visible for debugging purposes
        -- filename = "__my_first_mod__/graphics/canal-marker-vis.png",
        filename = "__my_first_mod__/graphics/canal-marker.png",
        size = 64,
        variation_count = 1
      }
    },
    stage_counts = {1}
    -- stage_counts = {32, 28, 24, 20, 16, 12, 8, 4},
    -- stages =
    -- {
    --   sheet =
    --   {
    --     filename = "__my_first_mod__/graphics/resource.png",
    --     priority = "extra-high",
    --     size = 64,
    --     frame_count = 8,
    --     variation_count = 8,
    --     hr_version = nil
    --     -- {
    --     --   filename = "__base__/graphics/entity/" .. resource_parameters.name .. "/hr-" .. resource_parameters.name .. ".png",
    --     --   priority = "extra-high",
    --     --   size = 128,
    --     --   frame_count = 8,
    --     --   variation_count = 8,
    --     --   scale = 0.5
    --     -- }
    --   }
    -- }

}