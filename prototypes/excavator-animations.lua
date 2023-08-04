-- Generating a smooth sigmoid in python:
-- 4.25 rotations moves the gantry from top to bottom 
--
-- def sigmoid(rots=4.25, sprites=64, frames=128, width=10):
--   f = lambda x: (sprites * rots) / (1 + np.e**-(x - (width/2)))
--   a = [int(f(x)) % sprites + 1 for x in np.arange(0, width, width/frames)]
--   return (a + a[::-1])[:-1]
gearbox_animation_sequence = 
{
  2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 6, 6, 7, 7, 8, 8, 9, 10, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 23, 24, 26, 28, 30, 32, 34, 37, 39, 42, 45, 48, 51, 54, 57, 61, 1, 5, 9, 13, 17, 22, 27, 31, 36, 41, 46, 51, 57, 62, 3, 9, 14, 19, 24, 30, 35, 40, 45, 50, 54, 59, 64, 4, 8, 12, 16, 20, 24, 27, 30, 33, 36, 39, 42, 44, 47, 49, 51, 53, 55, 57, 58, 60, 61, 63, 64, 1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 13, 13, 13, 13, 14, 14, 14, 14, 14, 15, 15, 14, 14, 14, 14, 14, 13, 13, 13, 13, 12, 12, 12, 11, 11, 10, 10, 9, 9, 8, 7, 7, 6, 5, 4, 3, 2, 1, 64, 63, 61, 60, 58, 57, 55, 53, 51, 49, 47, 44, 42, 39, 36, 33, 30, 27, 24, 20, 16, 12, 8, 4, 64, 59, 54, 50, 45, 40, 35, 30, 24, 19, 14, 9, 3, 62, 57, 51, 46, 41, 36, 31, 27, 22, 17, 13, 9, 5, 1, 61, 57, 54, 51, 48, 45, 42, 39, 37, 34, 32, 30, 28, 26, 24, 23, 21, 20, 18, 17, 16, 15, 14, 13, 12, 11, 10, 10, 9, 8, 8, 7, 7, 6, 6, 5, 5, 5, 4, 4, 4, 4, 3, 3, 3, 3, 3, 2
}
-- sigmoid(rots=1)
trough_animation_sequence = 
{
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 6, 6, 7, 7, 7, 8, 8, 9, 10, 10, 11, 12, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 28, 29, 30, 31, 33, 34, 35, 36, 37, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 53, 54, 55, 55, 56, 57, 57, 58, 58, 58, 59, 59, 60, 60, 60, 61, 61, 61, 61, 62, 62, 62, 62, 62, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 62, 62, 62, 62, 62, 61, 61, 61, 61, 60, 60, 60, 59, 59, 58, 58, 58, 57, 57, 56, 55, 55, 54, 53, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 37, 36, 35, 34, 33, 31, 30, 29, 28, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 12, 11, 10, 10, 9, 8, 8, 7, 7, 7, 6, 6, 5, 5, 5, 4, 4, 4, 4, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
}

gantry_animation_sequence = 
{
   1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16,
  17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
  33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64
}
-- far_screw_animation_sequence = 
-- {
--   64, 59, 56, 53, 48, 40, 33, 28, 28, 33, 35, 40, 50, 55, 60, 64, 64
-- }
far_screw_animation_sequence =
{
  10, 10, 9, 9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 10, 10
}

-------------------------------
electric_drill_animation_speed = 0.4
electric_drill_animation_sequence =
{
  1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1
}

electric_drill_animation_shadow_sequence =
{
  1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
  21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1
}

---------------
---
local function excavatorGrahpics()
    graphics_set =
    {
      drilling_vertical_movement_duration = 10,-- / electric_drill_animation_speed,
      animation_progress = 1,
      min_animation_progress = 0,
      max_animation_progress = 30,

      status_colors = nil, --electric_mining_drill_status_colors(),

      circuit_connector_layer = "object",
      circuit_connector_secondary_draw_order = { north = 14, east = 30, south = 30, west = 30 },

      animation =
      {
        north =
        {
          layers =
          {
            {
              priority = "high",
              filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-N.png",
              line_length = 1,
              width = 96,
              height = 104,
              frame_count = 1,
              animation_speed = electric_drill_animation_speed,
              direction_count = 1,
              shift = util.by_pixel(0, -4),
              repeat_count = 5,
              hr_version =
              {
                priority = "high",
                filename = "__base__/graphics/entity/electric-mining-drill/hr-electric-mining-drill-N.png",
                line_length = 1,
                width = 190,
                height = 208,
                frame_count = 1,
                animation_speed = electric_drill_animation_speed,
                direction_count = 1,
                shift = util.by_pixel(0, -4),
                repeat_count = 5,
                scale = 0.5
              }
            },
            {
              priority = "high",
              filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-N-output.png",
              line_length = 5,
              width = 32,
              height = 34,
              frame_count = 5,
              animation_speed = electric_drill_animation_speed,
              direction_count = 1,
              shift = util.by_pixel(-4, -44),
              hr_version =
              {
                priority = "high",
                filename = "__base__/graphics/entity/electric-mining-drill/hr-electric-mining-drill-N-output.png",
                line_length = 5,
                width = 60,
                height = 66,
                frame_count = 5,
                animation_speed = electric_drill_animation_speed,
                direction_count = 1,
                shift = util.by_pixel(-3, -44),
                scale = 0.5
              }
            },
            {
              priority = "high",
              filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-N-shadow.png",
              line_length = 1,
              width = 106,
              height = 104,
              frame_count = 1,
              animation_speed = electric_drill_animation_speed,
              draw_as_shadow = true,
              shift = util.by_pixel(6, -4),
              repeat_count = 5,
              hr_version =
              {
                priority = "high",
                filename = "__base__/graphics/entity/electric-mining-drill/hr-electric-mining-drill-N-shadow.png",
                line_length = 1,
                width = 212,
                height = 204,
                frame_count = 1,
                animation_speed = electric_drill_animation_speed,
                draw_as_shadow = true,
                shift = util.by_pixel(6, -3),
                repeat_count = 5,
                scale = 0.5
              }
            }
          }
        },
        east =
        {
          layers =
          {
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/graphics-east.png", -- TODO
              line_length = 8,
              width = 258,
              height = 258,
              frame_count = 255,
              animation_speed = electric_drill_animation_speed / 2,
              frame_sequence = gearbox_animation_sequence,
              direction_count = 1,
              --shift = util.by_pixel(0, -4),
              repeat_count = 1,
              scale = 2,
              hr_version =
              {
                priority = "high",
                filename = "__my_first_mod__/graphics/sprites/hr/east/gearbox-far.png",
                line_length = 8,
                width = 696,
                height = 252,
                frame_count = 255,
                shift = util.by_pixel(-11.0, -111.0),
                animation_speed = electric_drill_animation_speed / 2,
                frame_sequence = gearbox_animation_sequence,
                direction_count = 1,
                repeat_count = 1,
                scale = 0.5
              }
            },
            -- Trough
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/graphics-east.png", -- TODO
              line_length = 8,
              width = 112,
              height = 272,
              shift = util.by_pixel(142.5, 19.0),
              frame_count = 255,
              frame_sequence = trough_animation_sequence,
              animation_speed = electric_drill_animation_speed / 2,
              direction_count = 1,
              repeat_count = 1,
              scale = 2,
              hr_version =
              {
                priority = "high",
                filename = "__my_first_mod__/graphics/sprites/hr/east/trough.png",
                line_length = 8,
                width = 112,
                height = 272,
                shift = util.by_pixel(142.5, 19.0),
                frame_count = 255,
                frame_sequence = trough_animation_sequence,
                animation_speed = electric_drill_animation_speed / 2,
                direction_count = 1,
                repeat_count = 1,
                scale = 0.5
              }
            },

          --   ---
          --   {
          --     priority = "high",
          --     filename = "__my_first_mod__/graphics/sprites/shadows-east.png",
          --     line_length = 8,
          --     width = 258,
          --     height = 258,
          --     frame_count = 128,
          --     animation_speed = electric_drill_animation_speed,
          --     frame_sequence = gantry_animation_sequence,
          --     draw_as_shadow = true,
          --   --   shift = util.by_pixel(10, 2),
          --     repeat_count = 1,
          --     hr_version =
          --     {
          --       priority = "high",
          --       filename = "__my_first_mod__/graphics/sprites/hr/shadows-east.png",
          --       line_length = 8,
          --       width = 1024,
          --       height = 1024,
          --       frame_count = 128,
          --       animation_speed = electric_drill_animation_speed,
          --       frame_sequence = gantry_animation_sequence,
          --       draw_as_shadow = true,
          --       shift = util.by_pixel(57, 2),
          --       repeat_count = 1,
          --       scale = 0.5
          --     }
          --   }
          }
        },
        south =
        {
          layers =
          {
            {
              priority = "high",
              filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-S.png",
              line_length = 1,
              width = 92,
              height = 98,
              frame_count = 1,
              animation_speed = electric_drill_animation_speed,
              direction_count = 1,
              shift = util.by_pixel(0, -2),
              repeat_count = 5,
              hr_version =
              {
                priority = "high",
                filename = "__base__/graphics/entity/electric-mining-drill/hr-electric-mining-drill-S.png",
                line_length = 1,
                width = 184,
                height = 192,
                frame_count = 1,
                animation_speed = electric_drill_animation_speed,
                direction_count = 1,
                shift = util.by_pixel(0, -1),
                repeat_count = 5,
                scale = 0.5
              }
            },
            {
              priority = "high",
              filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-S-shadow.png",
              line_length = 1,
              width = 106,
              height = 102,
              frame_count = 1,
              animation_speed = electric_drill_animation_speed,
              draw_as_shadow = true,
              shift = util.by_pixel(6, 2),
              repeat_count = 5,
              hr_version =
              {
                priority = "high",
                filename = "__base__/graphics/entity/electric-mining-drill/hr-electric-mining-drill-S-shadow.png",
                line_length = 1,
                width = 212,
                height = 204,
                frame_count = 1,
                animation_speed = electric_drill_animation_speed,
                draw_as_shadow = true,
                shift = util.by_pixel(6, 2),
                repeat_count = 5,
                scale = 0.5
              }
            }
          }
        },
        west =
        {
          layers =
          {
            {
              priority = "high",
              filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-W.png",
              line_length = 1,
              width = 96,
              height = 94,
              frame_count = 1,
              animation_speed = electric_drill_animation_speed,
              direction_count = 1,
              shift = util.by_pixel(0, -4),
              repeat_count = 5,
              hr_version =
              {
                priority = "high",
                filename = "__base__/graphics/entity/electric-mining-drill/hr-electric-mining-drill-W.png",
                line_length = 1,
                width = 192,
                height = 188,
                frame_count = 1,
                animation_speed = electric_drill_animation_speed,
                direction_count = 1,
                shift = util.by_pixel(0, -4),
                repeat_count = 5,
                scale = 0.5
              }
            },
            {
              priority = "high",
              filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-W-output.png",
              line_length = 5,
              width = 24,
              height = 28,
              frame_count = 5,
              animation_speed = electric_drill_animation_speed,
              direction_count = 1,
              shift = util.by_pixel(-30, -12),
              hr_version =
              {
                priority = "high",
                filename = "__base__/graphics/entity/electric-mining-drill/hr-electric-mining-drill-W-output.png",
                line_length = 5,
                width = 50,
                height = 60,
                frame_count = 5,
                animation_speed = electric_drill_animation_speed,
                direction_count = 1,
                shift = util.by_pixel(-31, -13),
                scale = 0.5
              }
            },
            {
              priority = "high",
              filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-W-shadow.png",
              line_length = 1,
              width = 102,
              height = 92,
              frame_count = 1,
              animation_speed = electric_drill_animation_speed,
              draw_as_shadow = true,
              shift = util.by_pixel(-6, 2),
              repeat_count = 5,
              hr_version =
              {
                priority = "high",
                filename = "__base__/graphics/entity/electric-mining-drill/hr-electric-mining-drill-W-shadow.png",
                line_length = 1,
                width = 200,
                height = 182,
                frame_count = 1,
                animation_speed = electric_drill_animation_speed,
                draw_as_shadow = true,
                shift = util.by_pixel(-5, 2),
                repeat_count = 5,
                scale = 0.5
              }
            }
          }
        }
      },

      shift_animation_waypoints =
      {
        north = { {0, 0}  },
        -- east = { {0,  3}, {0, 0} },
        east = { {0, 0.03}, {0, 0.07}, {0, 0.09}, {0, 0.13}, {0, 0.18}, {0, 0.24}, {0, 0.33}, {0, 0.45}, {0, 0.60}, {0, 0.78}, {0, 1.00}, {0, 1.24}, {0, 1.50}, {0, 1.76}, {0, 2.00}, {0, 2.22}, {0, 2.40}, {0, 2.55}, {0, 2.67}, {0, 2.76}, {0, 2.82}, {0, 2.87}, {0, 2.91}, {0, 2.93}, {0, 2.95}, {0, 2.95}, {0, 2.93}, {0, 2.91}, {0, 2.87}, {0, 2.82}, {0, 2.76}, {0, 2.67}, {0, 2.55}, {0, 2.40}, {0, 2.22}, {0, 2.00}, {0, 1.76}, {0, 1.50}, {0, 1.24}, {0, 1.00}, {0, 0.78}, {0, 0.60}, {0, 0.45}, {0, 0.33}, {0, 0.24}, {0, 0.18}, {0, 0.13}, {0, 0.09}, {0, 0.07}, {0, 0.05}, {0, 0.03} },
        south = { {0, 0} },
        west = { {0, 0} }
      },
      -- Gears animation speed: electric_drill_animation_speed / 2
      -- = 0.2 animations per frame
      --> 5 frames per animation
      -- 255 animations * 5 frames
      -- = 1275 frame animation loop
      -- Divisors: 1, 3, 5, 15, 17, 25, 51, 75, 85, 255, 425, 1275
      --                                 ^
      -- 51 waypoints sounds smooth enough
      -- shift_animation_transition_duration = 1275 / 51 = 25
      -- Python code to generate the sigmoid for the waypoints: 
      -- def waypoints(wp=51, h=3, w=9):
      --   s = lambda x, h: h/(1+np.e**(-x+w/2))
      --   a = [s(x, h) for x in np.arange(0, w, w/np.ceil(wp/2))]
      --   if wp % 2 != 0:
      --     # Remove single waypoint incase we have an odd number of frames
      --     a = [a[0]] + a[2:]
      --   a = a + a[::-1]
      --   return "{ " + ", ".join(f"{{0, {v:.2f}}}" for v in a) + " }"

      shift_animation_waypoint_stop_duration = 0,--1950 / electric_drill_animation_speed,
      shift_animation_transition_duration = 25,

      working_visualisations =
      {
        -- Far screw
        {
          animated_shift = true,
          always_draw = true,
          --render_layer = "higher-object-above",

          north_animation = nil,
          east_animation =
          {
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/graphics-east.png", -- TODO
            line_length = 8,
            width = 258,
            height = 258,
            frame_count = 25,
            animation_speed = 1 / (1275 / #far_screw_animation_sequence),
            frame_sequence = far_screw_animation_sequence,
            direction_count = 1,
            shift = util.by_pixel(0, -150),
            repeat_count = 1,
            scale = 2,
            hr_version =
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/east/screw-far.png",
              line_length = 8,
              width = 519,
              height = 314,
              shift = util.by_pixel(-10.75, -174.5),
              frame_count = 25,
              animation_speed = 1 / (1275 / #far_screw_animation_sequence),
              frame_sequence = far_screw_animation_sequence,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5
            }
          }
        },
        -- Far gears top
        {
          animated_shift = false,
          always_draw = true,
          --render_layer = "higher-object-above",

          north_animation = nil,
          east_animation =
          {
            animated_shift = true,
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/graphics-east.png", -- TODO
            line_length = 8,
            width = 258,
            height = 258,
            frame_count = 255,
            animation_speed = electric_drill_animation_speed / 2,
            frame_sequence = gantry_animation_sequence,
            direction_count = 1,
            --shift = util.by_pixel(0, -4),
            repeat_count = 1,
            scale = 2,
            hr_version =
            {
              animated_shift = true,
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/east/gearbox-far-top.png",
              line_length = 8,
              width = 696,
              height = 144,
              frame_count = 255,
              shift = util.by_pixel(-11.0, -138.0),
              animation_speed = electric_drill_animation_speed / 2,
              frame_sequence = gearbox_animation_sequence,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5
            }
          },
          south_animation = nil,
          west_animation = nil,
        },
        -- Excavator gantry
        {
          animated_shift = true,
          always_draw = true,
          --render_layer = "higher-object-above",

          north_animation = nil,
          east_animation =
          {
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/graphics-east.png", -- TODO
            line_length = 8,
            width = 258,
            height = 258,
            frame_count = 64,
            animation_speed = electric_drill_animation_speed,
            frame_sequence = gantry_animation_sequence,
            direction_count = 1,
            --shift = util.by_pixel(0, -4),
            repeat_count = 1,
            scale = 2,
            hr_version =
            {
              animated_shift = true,
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/east/gantry.png",
              line_length = 8,
              width = 776,
              height = 319,
              frame_count = 64,
              shift = util.by_pixel(-13.0, -71.25),
              animation_speed = electric_drill_animation_speed,
              frame_sequence = gantry_animation_sequence,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5
            }
          },
          south_animation = nil,
          west_animation = nil,
        },
        -- Dust
        {
          animated_shift = true,
          always_draw = false,
          fadeout = true,
          --render_layer = "higher-object-above",

          north_animation = nil,
          east_animation =
          {
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/graphics-east.png", -- TODO
            line_length = 8,
            width = 258,
            height = 258,
            frame_count = 64,
            animation_speed = electric_drill_animation_speed,
            frame_sequence = gantry_animation_sequence,
            direction_count = 1,
            --shift = util.by_pixel(0, -4),
            repeat_count = 1,
            scale = 2,
            hr_version =
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/east/dust.png",
              line_length = 8,
              width = 590,
              height = 110,
              shift = util.by_pixel(-31.0, -28.0),
              frame_count = 64,
              animation_speed = electric_drill_animation_speed,
              frame_sequence = gantry_animation_sequence,
              direction_count = 1,
              --shift = util.by_pixel(0, -4),
              scale = 0.5
            }
          },
          south_animation = nil,
          west_animation = nil,
        },
        -- Excavator gearbox near
        {
          always_draw = true,
          north_animation = nil,
          east_animation =
          {
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/graphics-east.png", -- TODO
            line_length = 8,
            width = 258,
            height = 258,
            frame_count = 255,
            animation_speed = electric_drill_animation_speed / 2,
            frame_sequence = gearbox_animation_sequence,
            direction_count = 1,
            --shift = util.by_pixel(0, -4),
            repeat_count = 1,
            scale = 2,
            hr_version =
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/east/gearbox-near.png",
              line_length = 8,
              width = 695,
              height = 250,
              frame_count = 255,
              shift = util.by_pixel(-10.75, 62.0),
              animation_speed = electric_drill_animation_speed / 2,
              frame_sequence = gearbox_animation_sequence,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5
            }
          },
          south_animation = nil,
          west_animation = nil,
        },
        
      
        -- -- Excavator shadows TODO
        -- {
        --   always_draw = true,
        --   north_animation = nil,
        --   east_animation =
        --   {
        --     priority = "high",
        --     filename = "__my_first_mod__/graphics/sprites/shadows.png",
        --     line_length = 8,
        --     width = 258,
        --     height = 258,
        --     frame_count = 128,
        --     animation_speed = electric_drill_animation_speed,
        --     frame_sequence = gantry_animation_sequence,
        --     draw_as_shadow = true,
        --   --   shift = util.by_pixel(10, 2),
        --     repeat_count = 1,
        --     hr_version =
        --     {
        --       priority = "high",
        --       filename = "__my_first_mod__/graphics/sprites/hr/shadows.png",
        --       line_length = 8,
        --       width = 1024,
        --       height = 1024,
        --       frame_count = 128,
        --       animation_speed = electric_drill_animation_speed,
        --       frame_sequence = gantry_animation_sequence,
        --       draw_as_shadow = true,
        --       shift = util.by_pixel(57, 2),
        --       repeat_count = 1,
        --       scale = 0.5
        --     }
        --   },
        --   south_animation = nil,
        --   west_animation = nil,
        -- },

        -- LEDs
        --electric_mining_drill_status_leds_working_visualisation(),

        -- light
        --electric_mining_drill_primary_light,
        --electric_mining_drill_secondary_light
      }
    }

    return graphics_set
end

return excavatorGrahpics