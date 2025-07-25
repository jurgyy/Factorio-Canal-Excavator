local hit_effects = require ("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local graphicsFunc = require ("__canal-excavator-graphics__/animations")

---@diagnostic disable: undefined-global
circuit_connector_definitions["canex-excavator"] = circuit_connector_definitions.create_vector
(
    universal_connector_template,
    {
        { variation = 24, main_offset = util.by_pixel(-44, -132), shadow_offset = util.by_pixel(-50.5, -110), show_shadow = false },
        { variation = 26, main_offset = util.by_pixel(120, 0), shadow_offset = util.by_pixel(120, 19), show_shadow = true },
        { variation = 26, main_offset = util.by_pixel(40, 105), shadow_offset = util.by_pixel(43, 111), show_shadow = true },
        { variation = 26, main_offset = util.by_pixel(-124, -14), shadow_offset = util.by_pixel(-96, 22), show_shadow = true }
    }
)

local entity = {
    type = "mining-drill",
    name = "canex-excavator",
    icon = "__canal-excavator-graphics__/graphics/icons/excavator-64.png",
    icon_size = 64,
    icon_mipmaps = 0,
    minable =
    {
        mining_time = 0.1,
        result = "canex-excavator"
    },
    max_health = 500,
    resource_categories = {"canex-rsc-cat-digable"},
    corpse = "electric-mining-drill-remnants", -- TODO
    dying_explosion = "electric-mining-drill-explosion",
    
    collision_mask = {layers = {train = true, object = true}},
    collision_box = {{ -1.29, -5.39}, {1.29, 1.49}},
    selection_box = {{ -1.5, -5.5}, {1.5, 1.5}},
    drawing_box = {{ -1.5, -5.5}, {1.5, 1.5}},
    flags = { "player-creation", "placeable-neutral" },

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
      emissions_per_minute = {pollution = 20},
      usage_priority = "secondary-input"
    },
    energy_usage = "180kW",
    
    resource_searching_radius = 2.49,
    vector_to_place_result = {0, -5.9},
    allowed_effects = {"consumption", "speed", "pollution"},
    module_slots = 5,
    icons_positioning =
    {{
        inventory_index = defines.inventory.mining_drill_modules,
        shift = {0, -0.25},
        max_icons_per_row = 3,
        max_icon_rows = 2
    }},
    radius_visualisation_picture =
    {
      filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-radius-visualization.png",
      width = 10,
      height = 10
    },
    monitor_visualization_tint = {r=78, g=173, b=255},
    fast_replaceable_group = nil,
    circuit_connector = circuit_connector_definitions["canex-excavator"],
    circuit_wire_max_distance = default_circuit_wire_max_distance,

    water_reflection =
    {
      pictures =
      {
        filename = "__canal-excavator-graphics__/graphics/sprites/reflections.png",
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

if mods["space-age"] then
  entity.heating_energy = "200kW"
end

return entity