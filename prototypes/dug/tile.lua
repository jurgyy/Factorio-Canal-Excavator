return {
    name = "canex-dug",
    type = "tile",
    order = "e[canal][dug]",
    
    collision_mask = {layers = {ground_tile = true}},
    variants = data.raw.tile["landfill"].variants,
    transitions = data.raw.tile["landfill"].transitions,
    transitions_between_transitions = data.raw.tile["landfill"].transitions_between_transitions,
    
    walking_sound = data.raw.tile["landfill"].walking_sound,
    map_color={r=0.063, g=0.133, b=0.149},
    scorch_mark_color = {r = 0.312, g = 0.148, b = 0.147, a = 1.000},
    vehicle_friction_modifier = data.raw.tile["landfill"].vehicle_friction_modifier,
    decorative_removal_probability = 1,
    
    trigger_effect = data.raw.tile["landfill"].trigger_effect,
    
    layer = 99,
    autoplace = nil,
    walking_speed_modifier = 0.6,
    tint = { r = 0.500, g = 0.500, b = 0.03,   a = 0.2 },
    subgroup = "special-tiles",
}