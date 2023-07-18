local canal_excavator = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
canal_excavator.name = "canal-excavator"
canal_excavator.resource_categories = {"ent-canal-marker"}
canal_excavator.minable.result = "canal-excavator"
canal_excavator.minable.mining_time = 0.1
canal_excavator.resource_searching_radius = 2.49
-- canal_excavator.collision_box = {{ -1.4, -1.4}, {1.4, 1.4}}
canal_excavator.collision_box = {{ -1.4, -2.6}, {1.4, 0.2}}
-- canal_excavator.drawing_box = {{ -1.4, -1.4}, {1.4, 1.4}}
canal_excavator.drawing_box = {{ -1.4, 0}, {1.4, 2.8}}
canal_excavator.selection_box = {{-1.5, -2.5}, {1.5, 0.5}}
canal_excavator.collision_mask = { "object-layer", "train-layer", "floor-layer"}
canal_excavator.allowed_effects = {"speed", "consumption", "pollution"}
canal_excavator.vector_to_place_result = {0, -3}
canal_excavator.input_fluid_box = nil
canal_excavator.output_fluid_box = nil
canal_excavator.module_specification =
{
  module_slots = 2,
  module_info_icon_shift = {0, 0}
}
-- .module_info_icon_shift = {0, -1.4}
--table.insert(canal_excavator.flags, "not-rotatable")

-------
-- Shift graphics/animation off-center

directions = {
    {d = "north", da="north_animation", pos = "north_position", idx = 2, offset = -1},
    {d = "east", da="east_animation",   pos = "east_position",  idx = 1, offset =  1},
    {d = "south", da="south_animation", pos = "south_position", idx = 2, offset =  1},
    {d = "west", da="west_animation",   pos = "west_position",  idx = 1, offset = -1}
}

for _, direction in pairs(directions) do
    for _, layer in pairs(canal_excavator.graphics_set.animation[direction.d].layers) do
        layer.shift[direction.idx] = layer.shift[direction.idx] + direction.offset
        layer.hr_version.shift[direction.idx] = layer.hr_version.shift[direction.idx] + direction.offset
    end
    
    canal_excavator.integration_patch[direction.d].shift[direction.idx] = canal_excavator.integration_patch[direction.d].shift[direction.idx] + direction.offset
    canal_excavator.integration_patch[direction.d].hr_version.shift[direction.idx] = canal_excavator.integration_patch[direction.d].hr_version.shift[direction.idx] + direction.offset
end

for _, animation in pairs(canal_excavator.graphics_set.working_visualisations) do
    for _, direction in pairs(directions) do
        if animation[direction.da] ~= nil then
            if animation[direction.da].layers ~= nil then
                for _, layer in pairs(animation[direction.da].layers) do
                    layer.shift[direction.idx] = layer.shift[direction.idx] + direction.offset
                    layer.hr_version.shift[direction.idx] = layer.hr_version.shift[direction.idx] + direction.offset
                end
            else
                animation[direction.da].shift[direction.idx] = animation[direction.da].shift[direction.idx] + direction.offset
                animation[direction.da].hr_version.shift[direction.idx] = animation[direction.da].hr_version.shift[direction.idx] + direction.offset
            end
        end
        if animation[direction.pos] ~= nil then
            animation[direction.pos][direction.idx] = animation[direction.pos][direction.idx] + direction.offset
        end
    end
end


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