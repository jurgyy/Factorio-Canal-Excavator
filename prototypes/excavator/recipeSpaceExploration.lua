local recipe = require("__canal_excavator__/prototypes/excavator/recipe")

recipe.normal.ingredients = {
    {"steel-plate", 50},
    {"concrete", 25},
    {"iron-gear-wheel", 5},
    {"electric-engine-unit", 5}
}

recipe.expensive.ingredients = {
    {"steel-plate", 100},
    {"concrete", 50},
    {"iron-gear-wheel", 10},
    {"electric-engine-unit", 10}
}

return recipe