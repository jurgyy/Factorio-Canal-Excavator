data:extend{require("__canal_excavator__/prototypes/marker/category")}
data:extend(require("__canal_excavator__/prototypes/marker/resource"))
data:extend{require("__canal_excavator__/prototypes/marker/recipe")}

local tile = require("__canal_excavator__/prototypes/marker/tile")
local item = require("__canal_excavator__/prototypes/marker/item")
if settings.startup["no-tiles"].value then
    log("Running with no-tiles")
    local tileName = require("getTileNames").digable
    
    for key, value in pairs(tile) do
        if key ~= "name" then
            data.raw.tile[tileName][key] = value
        end
    end
    item.place_as_tile.result = tileName
else
    data:extend{tile}
end

data:extend{item}
