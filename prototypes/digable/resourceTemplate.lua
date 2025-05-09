local template = {
    type = "resource",
    name = "canex-rsc-digable-",
    localised_name  = {"entity-name.canex-rsc-digable"},
    icon = "__canal-excavator-graphics__/graphics/icons/marker.png",
    icon_size = 32,
    flags = {"placeable-player", "player-creation", "not-repairable", "not-flammable"},
    category = "canex-rsc-cat-digable",
    order = "e[canal-marker]",
    highlight = false,
    minimum = 0,
    normal = 1,
    cliff_removal_probability = 0,
    walking_sound = sound_variations("__base__/sound/walking/resources/ore", 10, 0.7)[1],
    minable =
    {
      mining_time = 1,
      results = {{
        type = "item",
        name = "stone",
        probability = 1,
        amount = 1
      }}
    },
    collision_box = {{ -0.49, -0.49}, {0.49, 0.49}},
    selection_box = {{ -0.49, -0.49}, {0.49, 0.49}},
    map_color = { r = 0.181, g = 0.104, b = 0.075},
    mining_visualisation_tint = {r = 0.490, g = 0.304, b = 0.5245, a = 1.000},

    stages =
    {
      sheet =
      {
        filename = "__canal-excavator-graphics__/graphics/resource.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5
      }
    },
    stage_counts = data.raw.resource["stone"].stage_counts,
}

local tint = { r = 0.1, g = 0.1, b = 0.1, a = 0.5 }
template.stages.sheet.tint = tint

template.icons = {{
  icon = "__canal-excavator-graphics__/graphics/icons/resource.png"
}}
template.icon = nil

return template
