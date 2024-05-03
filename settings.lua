-- Setting hidden since there is no way to get it to work without messing with other entity's collision_masks
data:extend({
    {
        name = "place-shallow-water",
        type = "bool-setting",
        setting_type = "runtime-global",
        default_value = false,
        hidden = true
    }
})