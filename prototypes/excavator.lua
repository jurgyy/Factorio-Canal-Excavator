local graphicsFunc = require ("__my_first_mod__/prototypes/excavator-animations")

local canal_excavator = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
canal_excavator.name = "canal-excavator"
canal_excavator.resource_categories = {"ent-canal-marker"}
canal_excavator.minable.result = "canal-excavator"
canal_excavator.minable.mining_time = 0.1
canal_excavator.resource_searching_radius = 4
-- canal_excavator.collision_box = {{ -1.4, -1.4}, {1.4, 1.4}}
canal_excavator.collision_box = {{ -2.8, -4.8}, {3.8, 4.8}}
-- canal_excavator.drawing_box = {{ -1.4, -1.4}, {1.4, 1.4}}
canal_excavator.drawing_box = {{ -4, -5}, {4, 5}}
canal_excavator.selection_box = {{ -3.8, -4.8}, {3.8, 4.8}}
canal_excavator.collision_mask = { "object-layer", "train-layer", "floor-layer"}
canal_excavator.allowed_effects = {"speed", "consumption", "pollution"}
canal_excavator.vector_to_place_result = {1, -5.5}
canal_excavator.input_fluid_box = nil
canal_excavator.output_fluid_box = nil
-- canal_excavator.shift_animation_waypoint_stop_duration = 1000
-- canal_excavator.shift_animation_waypoint_stop_duration = 1000,
canal_excavator.module_specification =
{
  module_slots = 10,
  module_info_icon_shift = {0, 0}
}
-- .module_info_icon_shift = {0, -1.4}
--table.insert(canal_excavator.flags, "not-rotatable")

-------
-- Graphics/animation
canal_excavator.graphics_set = graphicsFunc()


------
-- Item

local canal_excavator_item = table.deepcopy(data.raw["item"]["electric-mining-drill"])
canal_excavator_item.name = "canal-excavator"
canal_excavator_item.place_result = "canal-excavator"
canal_excavator_item.icons = {
    {
        icon=canal_excavator.icon,
        tint={r=0.1, g=0.1, b=0.8, a=0.3}
    }
}

-- data.raw["item"]["iron-ore"].place_result = "iron-ore"
-- data.raw["item"]["copper-ore"].place_result = "copper-ore"


data:extend{canal_excavator, canal_excavator_item}

data:extend {{
    type = "recipe",
    name = "canal-excavator",
    normal =
    {
        energy_required = 2,
        ingredients =
        {
            {"iron-plate", 10}
        },
        result = "canal-excavator"
    },
    expensive =
    {
        energy_required = 2,
        ingredients =
        {
            {"iron-plate", 20}
        },
        result = "canal-excavator"
    }
}}