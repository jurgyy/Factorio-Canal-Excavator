local template = require("prototypes.digable.resourceTemplate")

local configs = canex_get_planets_config()

for name, config in pairs(configs) do
    log("Adding Canex config for planet " .. name)

    local resource = table.deepcopy(template)
    resource.name = resource.name .. name
    resource.minable.results[1].name = config.mineResult
    resource.map_color = config.tint
    resource.mining_visualisation_tint = config.tint
    resource.stages.sheet.tint = config.tint
    data:extend({resource})
end
