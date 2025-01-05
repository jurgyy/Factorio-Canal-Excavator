local tile = require("__canal-excavator__/prototypes/dug/tile")
if settings.startup["no-tiles"].value then
    local tileName = require("prototypes.getTileNames").dug

    for key, value in pairs(tile) do
        if key ~= "name" then
            data.raw.tile[tileName][key] = value
        end
    end
else
    --data:extend{require("__canal-excavator__/prototypes/dug/item")}
    data:extend{tile}
end
