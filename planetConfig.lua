---@alias CanexPlanetsConfig table<string, CanexPlanetConfig> Table indexed by the PlanetPrototype.name with that planets excavator configuration

---@class CanexPlanetConfig
---@field mineResult string Mine result item
---@field fluidBodyTiles table<string> Tiles that make up the sea bodies on this planet
---@field excavateResult string Tile that will be placed when a tile is excavated and next to one of the fluidBodyTiles
---@field resultIsWalkable boolean? Is resulting tile walkable like shallow water? Defaults to false
---@field isDefault boolean? Fallback config for surfaces without a planet. Only one config can be the default
---@field oreStartingAmount integer Amount of ore that should be placed when placing a excavatable tile

---@type CanexPlanetsConfig
local config = {
    nauvis = {
        mineResult = "stone",
        fluidBodyTiles = {"water", "deepwater", "water-green", "deepwater-green", "water-shallow", "water-mud"},
        excavateResult = "",
        oreStartingAmount = 10
    }
}

local nauvis_water = nil
if settings.global["place-shallow-water"].value then
    nauvis_water = "water-shallow"
    config["nauvis"].resultIsWalkable = true
else
    nauvis_water = "water"
end
config["nauvis"].excavateResult = nauvis_water

return config