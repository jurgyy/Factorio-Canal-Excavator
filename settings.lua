data:extend({
    {
        name = "place-shallow-water",
        type = "bool-setting",
        setting_type = "runtime-global",
        default_value = false,
        hidden = mods["alien-biomes"] == nil
    },
    {
        name = "no-tiles",
        type = "bool-setting",
        setting_type = "startup",
        default_value = false
    },
    {
        name = "auto-deconstruct",
        type = "bool-setting",
        setting_type = "runtime-per-user",
        default_value = true
    }
})