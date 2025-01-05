local planet_registrar = require("global.planetConfigRegistrar")

planet_registrar.load_configs_from_settings()
local configs = planet_registrar.canex_get_planets_config()

local template = require("prototypes.digable.resourceTemplate")

for name, config in pairs(configs) do
    log("Adding Canex config for planet " .. name)

    local resource = table.deepcopy(template)
    resource.name = resource.name .. name
    resource.minable.results[1].name = config.mineResult
    resource.map_color = config.tint
    resource.mining_visualisation_tint = config.tint
    resource.stages.sheet.tint = config.tint
    resource.icons[1].tint = config.tint

    if mods["space-age"] then
        local planet = data.raw["planet"][name]
        if planet then
            local planet_localisation = planet.localised_name or ("space-location-name." .. name)
            resource.localised_name = {"entity-name.canex-rsc-digable-planet", {planet_localisation}}

            resource.icons[2] = resource.icons[1]
            if planet.icons then
                resource.icons[1] = planet.icons[1]
            else
                resource.icons[1] = {
                    icon = planet.icon,
                }
            end
            resource.icons[1].scale = 0.5
            resource.icons[1].shift = {x = -16, y = -16}
        end
    end

    data:extend({resource})
end
