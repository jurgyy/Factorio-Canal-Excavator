linear_animation = 
{
   1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16,
  17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
  33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64
}

animation_speed = 0.6

---------------
---
local function excavatorGrahpics()
    graphics_set =
    {
      drilling_vertical_movement_duration = 10,-- / animation_speed,
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
              animation_speed = animation_speed,
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
                animation_speed = animation_speed,
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
              animation_speed = animation_speed,
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
                animation_speed = animation_speed,
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
              animation_speed = animation_speed,
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
                animation_speed = animation_speed,
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
            { -- Machine animation
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/graphics-east.png", -- TODO
              line_length = 8,
              width = 258,
              height = 258,
              frame_count = 64,
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              direction_count = 1,
              repeat_count = 1,
              scale = 2,
              hr_version =
              {
                priority = "high",
                filename = "__my_first_mod__/graphics/sprites/hr/east/machine.png",
                line_length = 8,
                width = 466,
                height = 372,
                frame_count = 64,
                shift = util.by_pixel(59.5, -56), 
                -- preOffset:
                -- shift = util.by_pixel(7.5, 15.5), 
                animation_speed = animation_speed,
                frame_sequence = linear_animation,
                direction_count = 1,
                repeat_count = 1,
                scale = 0.5,
              }
            },
            { -- Shadows
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/shadows-east.png",
              line_length = 8,
              width = 258,
              height = 258,
              frame_count = 64,
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              draw_as_shadow = true,
              repeat_count = 1,
              hr_version =
              {
                priority = "high",
                filename = "__my_first_mod__/graphics/sprites/hr/east/shadows.png",
                line_length = 8,
                width = 738,
                height = 129,
                frame_count = 64,
                animation_speed = animation_speed,
                frame_sequence = linear_animation,
                draw_as_shadow = true,
                shift = util.by_pixel(137.5, 7.75), 
                repeat_count = 1,
                scale = 0.5
              }
            }
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
              animation_speed = animation_speed,
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
                animation_speed = animation_speed,
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
              animation_speed = animation_speed,
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
                animation_speed = animation_speed,
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
              animation_speed = animation_speed,
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
                animation_speed = animation_speed,
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
              animation_speed = animation_speed,
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
                animation_speed = animation_speed,
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
              animation_speed = animation_speed,
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
                animation_speed = animation_speed,
                draw_as_shadow = true,
                shift = util.by_pixel(-5, 2),
                repeat_count = 5,
                scale = 0.5
              }
            }
          }
        }
      },
      working_visualisations =
      {
        {  -- Hopper Dust
          fadeout = true,

          north_animation = nil,
          east_animation =
          {
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/graphics-east.png", -- TODO
            line_length = 8,
            width = 112,
            height = 272,
            shift = util.by_pixel(142.5, 19.0),
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 2,
            hr_version =
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/east/hopperDust.png",
              line_length = 8,
              width = 120,
              height = 160,
              shift = util.by_pixel(138.5, -55.5),
              frame_count = 64,
              frame_sequence = linear_animation,
              animation_speed = animation_speed,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            }
          },
          south_animation = nil,
          west_animation = nil,
        },
        { -- Floor Dust
          fadeout = true,

          north_animation = nil,
          east_animation =
          {  
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/graphics-east.png", -- TODO
            line_length = 8,
            width = 112,
            height = 272,
            shift = util.by_pixel(142.5, 19.0),
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 2,
            hr_version =
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/east/floorDust.png",
              line_length = 8,
              width = 203,
              height = 151,
              shift = util.by_pixel(-9.25, -6.25), 
              frame_count = 64,
              frame_sequence = linear_animation,
              animation_speed = animation_speed,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            }
          },
          south_animation = nil,
          west_animation = nil,
        },
      }
    }

    return graphics_set
end

return excavatorGrahpics