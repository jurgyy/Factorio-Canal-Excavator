local tile = require("__canal-excavator__/prototypes/dug/tile")
if settings.startup["no-tiles"].value then
    local tileName = require("getTileNames").dug

    for key, value in pairs(tile) do
        if key ~= "name" then
            data.raw.tile[tileName][key] = value
        end
    end
else
    local item = require("__canal-excavator__/prototypes/dug/item")
    data:extend{tile, item}
end
