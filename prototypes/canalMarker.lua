-- Copied from __base__
local dirt_sounds =
{
  {
    filename = "__base__/sound/walking/dirt-1-01.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-02.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-03.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-04.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-05.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-06.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-07.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-08.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-09.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-10.ogg",
    volume = 0.8
  }
}

-- Category
data:extend {{
    type = "resource-category",
    name = "ent-canal-marker"
}}

-- Resource entity
data:extend {{
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

}}

-- Tile
data:extend {{
    type = "tile",
    name = "tile-canal-marker",
    order = "e[canal-marker]",
    collision_mask = {"ground-tile"},
    layer = 200,
    variants = data.raw["tile"]["landfill"].variants,
    walking_sound = dirt_sounds,
    map_color={r = 0.490, g = 0.304, b = 0.0245},
    scorch_mark_color = {r = 1.000, g = 1.000, b = 1.000, a = 1.000},
    pollution_absorption_per_second = 0,
    minable = {mining_time = 0.1, result = "item-canal-marker"},
    decorative_removal_probability = 1 
}}

-- Item
data:extend {{
    type = "item",
    name = "item-canal-marker",
    --place_result = "rsc-canal-marker",
    place_as_tile =
    {
      result = "tile-canal-marker",
      condition_size = 1,
      condition = { "water-tile" }
    },
    icon = "__my_first_mod__/graphics/icons/icon.png",
    tint = {r=0.49, g=0.49, b=0.49, a=0.2},
    icon_size = 64,
    icon_mipmaps = 4,
    pictures =
    {
        { size = 64, filename = "__my_first_mod__/graphics/icons/icon.png",   scale = 0.25, mipmap_count = 4 }
    },
    subgroup = "raw-resource",
    order = "e[canal-marker]",
    stack_size = 50
}}

-- Recipe
data:extend {{
    type = "recipe",
    name = "rec-canal-marker",
    normal =
    {
        energy_required = 2,
        ingredients =
        {
            --{"iron-plate", 10}
        },
        result = "item-canal-marker"
    },
    expensive =
    {
        energy_required = 2,
        ingredients =
        {
            --{"iron-plate", 20}
        },
        result = "item-canal-marker"
    }
}}


