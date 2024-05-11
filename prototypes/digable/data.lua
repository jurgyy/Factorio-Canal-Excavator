data:extend{require("__canal-excavator__/prototypes/digable/category")}
data:extend(require("__canal-excavator__/prototypes/digable/resource"))
data:extend{require("__canal-excavator__/prototypes/digable/recipe")}

local tile = require("__canal-excavator__/prototypes/digable/tile")
local item = require("__canal-excavator__/prototypes/digable/item")
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
