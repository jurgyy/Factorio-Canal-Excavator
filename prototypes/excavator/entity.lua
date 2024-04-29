local hit_effects = require ("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local graphicsFunc = require ("__my_first_mod__/prototypes/excavator/animations")

return 
{
    type = "mining-drill",
    name = "canal-excavator",
    icon = "__my_first_mod__/graphics/icons/excavator-64.png", -- TODO mipmaps
    icon_size = 64,
    icon_mipmaps = 0,
    minable =
    {
        mining_time = 0.1,
        result = "canal-excavator"
    },
    max_health = 500,
    resource_categories = {"ent-canal-marker"},
    corpse = "electric-mining-drill-remnants", -- TODO
    dying_explosion = "electric-mining-drill-explosion",
    
    collision_mask = {"object-layer", "train-layer"},
    collision_box = {{ -1.49, -5.49}, {1.49, 1.49}},
    selection_box = {{ -1.5, -5.5}, {1.5, 1.5}},
    drawing_box = {{ -1.5, -5.5}, {1.5, 1.5}}, -- TODO: more in the upwards direction?
    
    damaged_trigger_effect = hit_effects.entity(),
    input_fluid_box = nil,
    
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/electric-mining-drill.ogg",
        volume = 0.5
      },
      audible_distance_modifier = 0.6,
      fade_in_ticks = 4,
      fade_out_ticks = 20
    },
    vehicle_impact_sound = sounds.generic_impact,
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,

    graphics_set = graphicsFunc(),
    wet_mining_graphics_set = nil,
    integration_patch = nil,

    mining_speed = 0.5,
    energy_source =
    {
      type = "electric",
      emissions_per_minute = 20,
      usage_priority = "secondary-input"
    },
    energy_usage = "180kW",
    
    resource_searching_radius = 2.49,
    vector_to_place_result = {0, -6},
    module_specification =
    {
        module_slots = 5,
        -- module_info_icon_shift = {10, 0}
    },
    radius_visualisation_picture =
    {
      filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-radius-visualization.png",
      width = 10,
      height = 10
    },
    monitor_visualization_tint = {r=78, g=173, b=255},
    fast_replaceable_group = nil,

    circuit_wire_connection_points = circuit_connector_definitions["electric-mining-drill"].points, -- TODO
    circuit_connector_sprites = circuit_connector_definitions["electric-mining-drill"].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance,

    water_reflection =
    {
      pictures =
      {
        filename = "__my_first_mod__/graphics/sprites/reflections.png",
        priority = "extra-high",
        width = 66,
        height = 71,
        shift = util.by_pixel(0, 50),
        variation_count = 4,
        scale = 5
      },
      rotate = false,
      orientation_to_variation = true
    }
}