local surface_config_helper = require("global.surfaceConfigHelper")
local configs = surface_config_helper.get_all_surface_config()

local resourceTemplate = require("prototypes.digable.resourceTemplate")

-- function extractSubstring(str)
--     local prefix = "canex-"
--     local suffix = "-config"

--     if string.sub(str, 1, #prefix) ~= prefix then
--         return nil
--     end
--     if string.sub(str, -#suffix) ~= suffix then
--         return nil
--     end

--     return string.sub(str, #prefix + 1, -#suffix - 1)
-- end

for _, config in pairs(configs) do
    log("Adding Canex config for surface " .. config.surfaceName)

    local resource = table.deepcopy(resourceTemplate)
    resource.name = resource.name .. config.surfaceName
    resource.minable.results[1].name = config.mineResult
    resource.map_color = config.tint
    resource.mining_visualisation_tint = config.tint
    resource.stages.sheet.tint = config.tint
    resource.icons[1].tint = config.tint

    if mods["space-age"] then
        local planet = data.raw["planet"][config.surfaceName]
        if planet then
            local planet_localisation = planet.localised_name or ("space-location-name." .. config.surfaceName)
            resource.localised_name = {"entity-name.canex-rsc-digable-surface", {planet_localisation}}

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
