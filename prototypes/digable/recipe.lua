return
{
    type = "recipe",
    name = "canex-digable",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 0.5,
    ingredients =
    {
        {type = "item", name = "stone", amount = 5},
        {type = "fluid", name = "water", amount = 25}
    },
    results = {{type ="item", name = "canex-digable", amount = 1}},
    order = "c[landfill]-b[canal]",
}