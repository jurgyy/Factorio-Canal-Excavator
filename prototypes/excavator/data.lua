local entity = require("__canal_excavator__/prototypes/excavator/entity")
local item = require("__canal_excavator__/prototypes/excavator/item")

local recipe
if mods["space-exploration"] then
    recipe = require("__canal_excavator__/prototypes/excavator/recipeSpaceExploration")
else
    recipe = require("__canal_excavator__/prototypes/excavator/recipe")
end

data:extend{entity, item, recipe}