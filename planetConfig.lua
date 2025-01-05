---@alias CanexPlanetsConfig table<string, CanexPlanetConfig> Table indexed by the PlanetPrototype.name with that planets excavator configuration

---@class CanexPlanetConfig
---@field mineResult string Mine result item
---@field fluidBodyTiles table<string> Tiles that make up the sea bodies on this planet
---@field excavateResult string Tile that will be placed when a tile is excavated and next to one of the fluidBodyTiles
---@field resultIsWalkable boolean? Is resulting tile walkable like shallow water? Defaults to false
---@field isDefault boolean? Fallback config for surfaces without a planet. Only one config can be the default
---@field oreStartingAmount integer Amount of ore that should be placed when placing a excavatable tile
---@field tint Color Tint for the dust, rocks and resource

---@type CanexPlanetsConfig
local config = {
    nauvis = {
        mineResult = "stone",
        fluidBodyTiles = {"water", "deepwater", "water-green", "deepwater-green", "water-shallow", "water-mud"},
        excavateResult = "",
        oreStartingAmount = 10,
        tint = {r = 102, g = 78, b = 6},
        isDefault = true
    }
}

if settings and settings.global then
    -- Set only during Runtime stage. Not known before that
    local nauvis_water = nil
    if settings.global["place-shallow-water"].value then
        nauvis_water = "water-shallow"
        config["nauvis"].resultIsWalkable = true
    else
        nauvis_water = "water"
    end
    config["nauvis"].excavateResult = nauvis_water
end

if (script and script.active_mods["space-age"]) or (mods and mods["space-age"]) then
    config["vulcanus"] = {
        mineResult = "stone",
        fluidBodyTiles = {"lava-hot", "lava"},
        excavateResult = "lava",
        oreStartingAmount = 40,
        tint = {r = 120, g = 120, b = 120}
    }
    config["fulgora"] = {
        mineResult = "scrap",
        fluidBodyTiles = {"oil-ocean-shallow", "oil-ocean-deep"},
        excavateResult = "oil-ocean-shallow",
        resultIsWalkable = true,
        oreStartingAmount = 10,
        tint = {r = 173, g = 94, b = 211}
    }
    config["gleba"] = {
        mineResult = "spoilage",
        fluidBodyTiles = {"gleba-deep-lake", "wetland-blue-slime", "wetland-light-green-slime", "wetland-green-slime", "wetland-light-dead-skin", "wetland-dead-skin", "wetland-pink-tentacle", "wetland-red-tentacle", "wetland-yumako", "wetland-jellynut"},
        excavateResult = "wetland-blue-slime",
        resultIsWalkable = true,
        oreStartingAmount = 50,
        tint = {r = 186, g = 196, b = 149}
    }
    config["aquilo"] = {
        mineResult = "ice",
        fluidBodyTiles = {"ammoniacal-ocean", "ammoniacal-ocean-2", "brash-ice"},
        excavateResult = "brash-ice",
        resultIsWalkable = false,
        oreStartingAmount = 50,
        tint = {r = 159, g = 193, b = 222}
    }
end


return config