data:extend({
    {
        type = "technology",
        name = "canal-excavator",
        icon_size = 256,
        icon = "__canal_excavator__/graphics/tech.png",
        effects = {
            {
                type = "unlock-recipe",
                recipe = "canal-excavator"
            },
            {
                type = "unlock-recipe",
                recipe = "rec-canal-marker"
            }
        },
        prerequisites = {"utility-science-pack"},
        unit = {
            count = 250,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"utility-science-pack", 1}
            },
            time = 30
        },
        order = "c-k-c"
    }
})