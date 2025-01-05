---@alias CanexPlanetsConfig table<string, CanexPlanetConfig> Table indexed by the PlanetPrototype.name with that planets excavator configuration

---@class CanexPlanetConfig
---@field mineResult string Mine result item
---@field isDefault boolean? Fallback config for surfaces without a planet. Only one config can be the default
---@field oreStartingAmount integer Amount of ore that should be placed when placing a excavatable tile
---@field tint Color Tint for the dust, rocks and resource

---@class CanexPlanetOverwriteConfig
---@field mineResult string?
---@field isDefault boolean?
---@field oreStartingAmount integer?
---@field tint Color?

---@type CanexPlanetsConfig
local config = {
    nauvis = {
        mineResult = "stone",
        oreStartingAmount = 10,
        tint = {r = 102, g = 78, b = 6},
        isDefault = true
    }
}

if (script and script.active_mods["space-age"]) or (mods and mods["space-age"]) then
    config["vulcanus"] = {
        mineResult = "stone",
        oreStartingAmount = 40,
        tint = {r = 120, g = 120, b = 120}
    }
    config["fulgora"] = {
        mineResult = "scrap",
        oreStartingAmount = 10,
        tint = {r = 173, g = 94, b = 72}
    }
    config["gleba"] = {
        mineResult = "spoilage",
        oreStartingAmount = 50,
        tint = {r = 186, g = 196, b = 149}
    }
    config["aquilo"] = {
        mineResult = "ice",
        oreStartingAmount = 50,
        tint = {r = 159, g = 193, b = 222}
    }
end


return config