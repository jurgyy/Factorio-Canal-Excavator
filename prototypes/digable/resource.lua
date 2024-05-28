local resource = {
    type = "resource",
    name = "canex-rsc-digable",
    localised_name  = {"entity-name.canex-rsc-digable"},
    icon = "__canal-excavator-graphics__/graphics/icons/marker.png",
    icon_size = 32,
    flags = {"placeable-player", "player-creation", "not-repairable", "not-flammable"},
    category = "canex-rsc-cat-digable",
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
      results = {{
        name = "stone",
        probability = 1,
        amount = 1
      }}
    },
    collision_box = {{ -0.49, -0.49}, {0.49, 0.49}},
    selection_box = {{ -0.49, -0.49}, {0.49, 0.49}},
    map_color = { r = 0.181, g = 0.104, b = 0.075},
    mining_visualisation_tint = {r = 0.490, g = 0.304, b = 0.0245, a = 1.000},

    stages = table.deepcopy(data.raw.resource["stone"].stages),
    stage_counts = data.raw.resource["stone"].stage_counts,
}

local tint = { r = 0.1, g = 0.1, b = 0.1, a = 0.5 }
resource.stages.sheet.tint = tint
resource.stages.sheet.hr_version.tint = tint


local resources = {resource}
local resource_granularity = require("resourceGranularity")

for i = 1, resource_granularity do
    local reducedResource = table.deepcopy(resource)

    reducedResource.name = resource.name .. "-" .. i
    reducedResource.minable.results[1].probability = i / resource_granularity

    table.insert(resources, reducedResource)
end

resource.name = resource.name .. "-" .. resource_granularity

return resources
