return {
    name = "tile-dug",
    type = "tile",
    order = "e[canal][dug]",
    
    collision_mask = {"ground-tile"},
    variants = data.raw.tile["dirt-5"].variants,
    transitions = data.raw.tile["dirt-5"].transitions,
    transitions_between_transitions = data.raw.tile["dirt-5"].transitions_between_transitions,
    
    walking_sound = data.raw.tile["dirt-5"].walking_sound,
    map_color={r=0.063, g=0.133, b=0.149},
    scorch_mark_color = {r = 0.312, g = 0.148, b = 0.147, a = 1.000},
    pollution_absorption_per_second = data.raw.tile["dirt-5"].pollution_absorption_per_second,
    vehicle_friction_modifier = data.raw.tile["dirt-5"].vehicle_friction_modifier,
    decorative_removal_probability = 1,
    
    trigger_effect = data.raw.tile["dirt-5"].trigger_effect,
    
    layer = 10,
    autoplace = nil,
    walking_speed_modifier = 0.6,
    tint = { r = 0.400, g = 0.400, b = 0.260,   a = 0.25 }
  }