return
{
    type = "tile",
    name = "canex-tile-digable",
    order = "e[canal][digable]",
    collision_mask = {"ground-tile"},
    layer = 100,
    variants = data.raw.tile["dirt-5"].variants,
    transitions = data.raw.tile["dirt-5"].transitions,
    transitions_between_transitions = data.raw.tile["dirt-5"].transitions_between_transitions,
    walking_sound = data.raw.tile["dirt-5"].walking_sound,
    map_color={ r = 0.181, g = 0.104, b = 0.075},
    scorch_mark_color = {r = 1.000, g = 1.000, b = 1.000, a = 1.000},
    pollution_absorption_per_second = 0,
    minable = {mining_time = 0.1, result = "canex-item-digable"},
    decorative_removal_probability = 1,
    walking_speed_modifier = 0.6,
    tint = { r = 0.300, g = 0.300, b = 0.200,   a = 0.25 }
}