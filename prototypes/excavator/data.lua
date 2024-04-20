local entity = require("__my_first_mod__/prototypes/excavator/entity")
local item = require("__my_first_mod__/prototypes/excavator/item")
local recipe = require("__my_first_mod__/prototypes/excavator/recipe")

data:extend{entity, item}
data:extend {recipe}