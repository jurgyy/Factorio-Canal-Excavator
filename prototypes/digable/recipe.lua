return
{
    type = "recipe",
    name = "canex-rec-digable",
    category = "crafting-with-fluid",
    normal =
    {
        energy_required = 0.5,
        ingredients =
        {
            {type="item", name = "stone", amount = 5},
            {type = "fluid", name = "water", amount = 25}
        },
        result = "canex-item-digable"
    },
    expensive =
    {
        energy_required = 0.5,
        ingredients =
        {
            {type = "item", name = "stone", amount = 10},
            {type = "fluid", name = "water", amount = 50}
        },
        result = "canex-item-digable"
    }
}