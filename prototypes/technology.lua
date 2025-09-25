local tech = {
    type = "technology",
    name = "canex-excavator",
    icon_size = 256,
    icon = "__canal-excavator-graphics__/graphics/tech.png",
    effects = {
        {
            type = "unlock-recipe",
            recipe = "canex-excavator"
        },
        {
            type = "unlock-recipe",
            recipe = "canex-digable"
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

if mods["space-exploration"] then
    tech.prerequisites = { "electric-engine", "concrete" }
    tech.unit = {
        count = 200,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
        },
        time = 30
    }
end

data:extend({
    tech
})
