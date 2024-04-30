return {
    name = "tile-dug",
    type = "tile",
    order = "e[canal][dug]",
    
    collision_mask = {"ground-tile"},
    variants = data.raw.tile["dirt-5"].variants,
    transitions = data.raw.tile["sand-3"].transitions,
    transitions_between_transitions = data.raw.tile["sand-3"].transitions_between_transitions,
    
    walking_sound = data.raw.tile["dirt-5"].walking_sound,
    map_color={r=100, g=53, b=38},
    scorch_mark_color = {r = 0.412, g = 0.298, b = 0.197, a = 1.000},
    pollution_absorption_per_second = data.raw.tile["dirt-5"].pollution_absorption_per_second,
    vehicle_friction_modifier = data.raw.tile["dirt-5"].vehicle_friction_modifier,
    decorative_removal_probability = 1,
    
    trigger_effect = data.raw.tile["dirt-5"].trigger_effect,
    
    layer = 10,
    autoplace = nil,
    walking_speed_modifier = 0.6,
    tint = { r = 0.900, g = 0.800, b = 0.03,   a = 0.5 }
  }