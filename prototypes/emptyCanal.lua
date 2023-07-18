local tile_trigger_effects = require("__base__.prototypes.tile.tile-trigger-effects")
-- local tiles = require("__base__.prototypes.tile.tiles")

local default_transition_group_id = 0
local water_transition_group_id = 1
local out_of_map_transition_group_id = 2


local function water_transition_template_with_effect(to_tiles, normal_res_transition, high_res_transition, options)
    return make_generic_transition_template(to_tiles, water_transition_group_id, nil, normal_res_transition, high_res_transition, options, true, false, true)
end

local ttfxmaps = {}
ttfxmaps.water_dirt =
{
  filename_norm = "__base__/graphics/terrain/effect-maps/water-dirt-mask.png",
  filename_high = "__base__/graphics/terrain/effect-maps/hr-water-dirt-mask.png",
  count = 8,
  o_transition_tall = false,
  u_transition_count = 2,
  o_transition_count = 1
}


local water_tile_type_names = { "water", "deepwater", "water-green", "deepwater-green", "water-shallow", "water-mud", "water-wube", "grass-1", "grass-2", "grass-3", "grass-4" }

local function make_out_of_map_transition_template(to_tiles, normal_res_transition, high_res_transition, options, base_layer, background, mask)
    return make_generic_transition_template(to_tiles, out_of_map_transition_group_id, nil, normal_res_transition, high_res_transition, options, base_layer, background, mask)
end

local function generic_transition_between_transitions_template(group1, group2, normal_res_transition, high_res_transition, options)
    return make_generic_transition_template(nil, group1, group2, normal_res_transition, high_res_transition, options, true, true, true)
end

local function init_transition_between_transition_common_options(base)
    local t = base or {}

    t.background_layer_offset = t.background_layer_offset or 1
    t.background_layer_group = t.background_layer_group or "zero"
    if (t.offset_background_layer_by_tile_layer == nil) then
        t.offset_background_layer_by_tile_layer = true
    end

    return t
end

local function init_transition_between_transition_water_out_of_map_options(base)
    return init_transition_between_transition_common_options(base)
end

local function create_transition_to_out_of_map_from_template(normal_res_template_path, high_res_template_path, options)
    return make_out_of_map_transition_template
    (
      { "out-of-map" },
      normal_res_template_path,
      high_res_template_path,
      {
        o_transition_tall = false,
        side_count = 8,
        inner_corner_count = 4,
        outer_corner_count = 4,
        u_transition_count = 1,
        o_transition_count = 1,
        base = init_transition_between_transition_common_options()
      },
      options.has_base_layer == true,
      options.has_background == true,
      options.has_mask == true
    )
  end

local ground_to_out_of_map_transition =
  create_transition_to_out_of_map_from_template("__base__/graphics/terrain/out-of-map-transition/out-of-map-transition.png",
                                                "__base__/graphics/terrain/out-of-map-transition/hr-out-of-map-transition.png",
                                                { has_base_layer = false, has_background = true, has_mask = true })


-- ~~~DIRT_LANDFILL

local landfill_transitions =
{
  water_transition_template_with_effect
  (
      water_tile_type_names,
      "__base__/graphics/terrain/water-transitions/landfill.png",
      "__base__/graphics/terrain/water-transitions/hr-landfill.png",
      {
        effect_map = ttfxmaps.water_dirt,
        o_transition_tall = false,
        u_transition_count = 2,
        o_transition_count = 4,
        side_count = 8,
        outer_corner_count = 8,
        inner_corner_count = 8
      }
  ),
  ground_to_out_of_map_transition
}

local patch_for_inner_corner_of_transition_between_transition =
{
  filename = "__base__/graphics/terrain/water-transitions/water-patch.png",
  width = 32,
  height = 32,
  hr_version =
  {
    filename = "__base__/graphics/terrain/water-transitions/hr-water-patch.png",
    scale = 0.5,
    width = 64,
    height = 64
  }
}

local dirt_out_of_map_transition =
  make_generic_transition_template
  (
    nil,
    default_transition_group_id,
    out_of_map_transition_group_id,
    "__base__/graphics/terrain/out-of-map-transition/dirt-out-of-map-transition.png",
    "__base__/graphics/terrain/out-of-map-transition/hr-dirt-out-of-map-transition.png",
    {
      inner_corner_tall = true,
      inner_corner_count = 3,
      outer_corner_count = 3,
      side_count = 3,
      u_transition_count = 1,
      o_transition_count = 0,
      base = init_transition_between_transition_common_options()
    },
    false,
    true,
    true
  )

local landfill_transitions_between_transitions =
{
  make_generic_transition_template --generic_transition_between_transitions_template
  (
      nil,
      default_transition_group_id,
      water_transition_group_id,
      "__my_first_mod__/graphics/transitions/landfill.png",
      "__my_first_mod__/graphics/transitions/hr-landfill.png",
      {
        effect_map = ttfxmaps.water_dirt_to_land,
        o_transition_tall = false,
        inner_corner_count = 3,
        outer_corner_count = 3,
        side_count = 3,
        u_transition_count = 1,
        o_transition_count = 0,
        base = { water_patch = patch_for_inner_corner_of_transition_between_transition, }
      },
      true,
      false,
      true
  ),
  dirt_out_of_map_transition,
  generic_transition_between_transitions_template
  (
      water_transition_group_id,
      out_of_map_transition_group_id,
      "__base__/graphics/terrain/out-of-map-transition/landfill-shore-out-of-map-transition.png",
      "__base__/graphics/terrain/out-of-map-transition/hr-landfill-shore-out-of-map-transition.png",
      {
        effect_map = ttfxmaps.water_dirt_to_out_of_map,
        o_transition_tall = false,
        inner_corner_count = 3,
        outer_corner_count = 3,
        side_count = 3,
        u_transition_count = 1,
        o_transition_count = 0,
        base = init_transition_between_transition_water_out_of_map_options()
      }
  )
}

local function append_transition_mask_template(normal_res_transition, high_res_transition, options, tab)
    local function make_transition_variation(x_, cnt_, line_len_)
      local t =
      {
        picture = normal_res_transition,
        count = cnt_,
        line_length = line_len_ or cnt_,
        x = x_
      }
  
      if high_res_transition then
        t.hr_version =
        {
          picture = high_res_transition,
          count = cnt_,
          line_length = line_len_ or cnt_,
          x = 2 * x_,
          scale = 0.5
        }
      end
      return t
    end
  
    local mv = (options and options.mask_variations) or 8
    local suffix = (options and options.mask_suffix) or "mask"
    tab["inner_corner_" .. suffix] = make_transition_variation(0, mv)
    tab["outer_corner_" .. suffix] = make_transition_variation(288, mv)
    tab["side_" .. suffix]         = make_transition_variation(576, mv)
    tab["u_transition_" .. suffix] = make_transition_variation(864, 1, 1)
    tab["o_transition_" .. suffix] = make_transition_variation(1152, 1, 2)
  
    return tab
  end

-- Tile
data:extend {{
    type = "tile",
    name = "tile-empty-canal",
    order = "e[empty-canal]",
    collision_mask = {"ground-tile"},
    layer = 200,
    
    transitions = landfill_transitions,
    transitions_between_transitions = landfill_transitions_between_transitions,
    trigger_effect = tile_trigger_effects.landfill_trigger_effect(),

    variants = data.raw["tile"]["lab-white"].variants,
    -- variants = append_transition_mask_template(
    -- "__base__/graphics/terrain/masks/transition-1.png",
    -- "__base__/graphics/terrain/masks/hr-transition-1.png",
    -- nil,
    -- {
    --   main =
    --   {
    --     {
    --       picture = "__base__/graphics/terrain/concrete/concrete-dummy.png",
    --       count = 1,
    --       size = 1
    --     },
    --     {
    --       picture = "__base__/graphics/terrain/concrete/concrete-dummy.png",
    --       count = 1,
    --       size = 2,
    --       probability = 0.39
    --     },
    --     {
    --       picture = "__base__/graphics/terrain/concrete/concrete-dummy.png",
    --       count = 1,
    --       size = 4,
    --       probability = 1
    --     }
    --   },

    --   material_background =
    --   {
    --     picture = "__base__/graphics/terrain/landfill.png",
    --     count = 8,
    --     hr_version =
    --     {
    --       picture = "__base__/graphics/terrain/hr-landfill.png",
    --       count = 8,
    --       scale = 0.5
    --     }
    --   }
    -- }),

    walking_sound = concrete_sounds,
    map_color={r = 0.490, g = 0.304, b = 0.0245},
    scorch_mark_color = {r = 1.000, g = 1.000, b = 1.000, a = 1.000},
    pollution_absorption_per_second = 0,
    minable = {mining_time = 0.1, result = "item-canal-marker"},
    decorative_removal_probability = 1 
}}