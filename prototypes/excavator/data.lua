local entity = require("__canal-excavator__/prototypes/excavator/entity")
local item = require("__canal-excavator__/prototypes/excavator/item")
local mod_data = {
    type = "mod-data",
    name = "canex-excavator",
    data_type = "canex-excavator-config",
    data = {
        entity_name = entity.name,
        item_name = item.name
    }
}


local recipe
if mods["space-exploration"] then
    recipe = require("__canal-excavator__/prototypes/excavator/recipeSpaceExploration")
else
    recipe = require("__canal-excavator__/prototypes/excavator/recipe")
end

data:extend{entity, item, recipe, mod_data}