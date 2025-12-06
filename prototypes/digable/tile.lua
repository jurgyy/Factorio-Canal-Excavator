return
{
    type = "tile",
    name = "canex-digable",
    order = "e[canal][digable]",
    collision_mask = {layers = {ground_tile = true, cliff = true}},
    layer = 100,
    variants = data.raw.tile["dirt-5"].variants,
    transitions = data.raw.tile["dirt-5"].transitions,
    transitions_between_transitions = data.raw.tile["dirt-5"].transitions_between_transitions,
    walking_sound = data.raw.tile["dirt-5"].walking_sound,
    map_color={ r = 0.181, g = 0.104, b = 0.075},
    scorch_mark_color = {r = 1.000, g = 1.000, b = 1.000, a = 1.000},
    minable = {mining_time = 0.1, result = "canex-digable"},
    decorative_removal_probability = 1,
    walking_speed_modifier = 0.6,
    tint = { r = 0.300, g = 0.300, b = 0.200,   a = 0.25 },
    factoriopedia_simulation = {
        mods = {"canal-excavator"},
        game_view_settings = { default_show_value = false, update_entity_selection = true },
        init_file = "__canal-excavator__/prototypes/tips-and-tricks/factoriopedia-sim-digable.lua"
    }
}