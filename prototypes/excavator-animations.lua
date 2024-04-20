linear_animation = 
{
   1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16,
  17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
  33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64
}

animation_speed = 0.6

offset = 
{
  hrScale = 0.5,
  north =
  {
    lr = 
    {
      x = 0,
      y = -128
    },
    hr =
    {
      x = -10,
      y = -114
    }
  },
  east = 
  {
    lr = 
    {
      x = 57,
      y = -71.5
    }
  }
}

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
            { -- Machine animation
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/lr/north/machine.png",
              line_length = 8,
              width = 92,
              height = 264,
              frame_count = 64,
              -- Given offset:
              	shift = util.by_pixel(7.0 + offset.north.lr.x, 8.0 + offset.north.lr.y), 
              -- shift = util.by_pixel(7.0, -120.0), 
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              direction_count = 1,
              repeat_count = 1,
              scale = 1,
              hr_version =
              {
                priority = "high",
                filename = "__my_first_mod__/graphics/sprites/hr/north/machine.png",
                line_length = 8,
                width = 182,
                height = 526,
                frame_count = 64,
                shift = util.by_pixel(14 * offset.hrScale + offset.north.hr.x, 16.0 * offset.hrScale + offset.north.hr.y), 
                animation_speed = animation_speed,
                frame_sequence = linear_animation,
                direction_count = 1,
                repeat_count = 1,
                scale = 0.5,
              }
            },
            { -- Shadows
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/lr/north/shadows.png",
              line_length = 8,
              width = 257,
              height = 165,
              shift = util.by_pixel(92.5 + offset.north.lr.x, 64.5 + offset.north.lr.y), 
              frame_count = 64,
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              draw_as_shadow = true,
              repeat_count = 1,
              hr_version =
              {
                priority = "high",
                filename = "__my_first_mod__/graphics/sprites/hr/north/shadows.png",
                line_length = 8,
                width = 513,
                height = 327,
                shift = util.by_pixel(184.5 * offset.hrScale + offset.north.hr.x, 129.5 * offset.hrScale + offset.north.hr.y), 
                frame_count = 64,
                animation_speed = animation_speed,
                frame_sequence = linear_animation,
                draw_as_shadow = true,
                repeat_count = 1,
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
              filename = "__my_first_mod__/graphics/sprites/lr/east/machine.png",
              line_length = 8,
              width = 234,
              height = 187,
              frame_count = 64,
              -- Given offset:
              -- shift = util.by_pixel(2.0, 15.5), 
              shift = util.by_pixel(2 + offset.east.lr.x, 15.5 + offset.east.lr.y),
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              direction_count = 1,
              repeat_count = 1,
              scale = 1,
              hr_version =
              {
                priority = "high",
                filename = "__my_first_mod__/graphics/sprites/hr/east/machine.png",
                line_length = 8,
                width = 466,
                height = 371,
                frame_count = 64,
                shift = util.by_pixel(59.5, -56), 
                -- Given offset:
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
              filename = "__my_first_mod__/graphics/sprites/lr/east/shadows.png",
              line_length = 8,
              width = 371,
              height = 66,
              shift = util.by_pixel(81.5 + offset.east.lr.x, 79.0 + offset.east.lr.y), 
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
            { -- Machine animation
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/lr/south/machine.png",
              line_length = 8,
              width = 92,
              height = 203,
              frame_count = 64,
              -- Given offset:
              -- 	shift = util.by_pixel(-7.0, 64.5), 
              shift = util.by_pixel(-2, 70),
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              direction_count = 1,
              repeat_count = 1,
              scale = 1,
              hr_version =
              {
                priority = "high",
                filename = "__my_first_mod__/graphics/sprites/hr/south/machine.png",
                line_length = 8,
                width = 181,
                height = 403,
                frame_count = 64,
                shift = util.by_pixel(-2, 70), 
                -- Given offset:
                -- shift = util.by_pixel(-6.75, 64.75), 
                animation_speed = animation_speed,
                frame_sequence = linear_animation,
                direction_count = 1,
                repeat_count = 1,
                scale = 0.5,
              }
            },
            { -- Shadows
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/lr/south/shadows.png",
              line_length = 8,
              width = 263,
              height = 166,
              shift = util.by_pixel(88.5, 90.5), 
              frame_count = 64,
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              draw_as_shadow = true,
              repeat_count = 1,
              hr_version =
              {
                priority = "high",
                filename = "__my_first_mod__/graphics/sprites/hr/south/shadows.png",
                line_length = 8,
                width = 522,
                height = 329,
                shift = util.by_pixel(88.25, 90.5), 
                frame_count = 64,
                animation_speed = animation_speed,
                frame_sequence = linear_animation,
                draw_as_shadow = true,
                repeat_count = 1,
                scale = 0.5
              }
            }
          }
        },
        west = 
        {
          layers =
          {
            { -- Machine animation
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/lr/west/machine.png",
              line_length = 8,
              width = 234,
              height = 184,
              frame_count = 64,
              -- Given offset:
              -- shift = util.by_pixel(-2, 10), 
              shift = util.by_pixel(-59, -56.0),
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              direction_count = 1,
              repeat_count = 1,
              scale = 1,
              hr_version =
              {
                priority = "high",
                filename = "__my_first_mod__/graphics/sprites/hr/west/machine.png",
                line_length = 8,
                width = 466,
                height = 367,
                frame_count = 64,
                shift = util.by_pixel(-59.5, -56), 
                -- Given offset:
                -- shift = util.by_pixel(-2, 10.25), 
                animation_speed = animation_speed,
                frame_sequence = linear_animation,
                direction_count = 1,
                repeat_count = 1,
                scale = 0.5,
              }
            },
            { -- Shadows
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/lr/west/shadows.png",
              line_length = 8,
              width = 285,
              height = 66,
              shift = util.by_pixel(-29.5, 4.0), 
              frame_count = 64,
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              draw_as_shadow = true,
              repeat_count = 1,
              hr_version =
              {
                priority = "high",
                filename = "__my_first_mod__/graphics/sprites/hr/west/shadows.png",
                line_length = 8,
                width = 567,
                height = 129,
                shift = util.by_pixel(-30.25, 3.5),
                frame_count = 64,
                animation_speed = animation_speed,
                frame_sequence = linear_animation,
                draw_as_shadow = true,
                repeat_count = 1,
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

          north_animation = 
          {
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/lr/north/hopperDust.png",
            line_length = 8,
            width = 87,
            height = 59,
            shift = util.by_pixel(-2.5 + offset.north.lr.x, -54.5 + offset.north.lr.y), 
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 1,
            hr_version =
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/north/hopperDust.png",
              line_length = 8,
              width = 185,
              height = 119,
              shift = util.by_pixel(-1.5 * offset.hrScale + offset.north.hr.x, -111.5 * offset.hrScale + offset.north.hr.y), 
              frame_count = 64,
              frame_sequence = linear_animation,
              animation_speed = animation_speed,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            }
          },
          east_animation =
          {
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/lr/east/hopperDust.png",
            line_length = 8,
            width = 59,
            height = 77,
            shift = util.by_pixel(136.5, -56.0),
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 1,
            hr_version =
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/east/hopperDust.png",
              line_length = 8,
              width = 125,
              height = 166,
              shift = util.by_pixel(138.5, -55.5),
              frame_count = 64,
              frame_sequence = linear_animation,
              animation_speed = animation_speed,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            }
          },
          south_animation = {
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/lr/south/hopperDust.png",
            line_length = 8,
            width = 93,
            height = 64,
            shift = util.by_pixel(6.5, 78.5),
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 1,
            hr_version =
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/south/hopperDust.png",
              line_length = 8,
              width = 187,
              height = 142,
              shift = util.by_pixel(4.5, 80.25), 
              frame_count = 64,
              frame_sequence = linear_animation,
              animation_speed = animation_speed,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            }
          },
          west_animation = 
          {
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/lr/west/hopperDust.png",
            line_length = 8,
            width = 61,
            height = 85,
            shift = util.by_pixel(-137.5, -45.5), 
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 1,
            hr_version =
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/west/hopperDust.png",
              line_length = 8,
              width = 123,
              height = 171,
              shift = util.by_pixel(-137.25, -47.5),
              --shift = util.by_pixel(-79.75, 18.75), 
              frame_count = 64,
              frame_sequence = linear_animation,
              animation_speed = animation_speed,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            }
          },
        },
        { -- Floor Dust
          fadeout = true,

          north_animation =
          {  
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/lr/north/floorDust.png",
            line_length = 8,
            width = 91,
            height = 80,
            shift = util.by_pixel(-1.5 + offset.north.lr.x, 101.0 + offset.north.lr.y), 
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 1,
            hr_version =
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/north/floorDust.png",
              line_length = 8,
              width = 196,
              height = 161,
              shift = util.by_pixel(-3 * offset.hrScale + offset.north.hr.x, 201.5 * offset.hrScale + offset.north.hr.y), 
              frame_count = 64,
              frame_sequence = linear_animation,
              animation_speed = animation_speed,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            }
          },
          east_animation =
          {  
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/lr/east/floorDust.png",
            line_length = 8,
            width = 91,
            height = 72,
            shift = util.by_pixel(-12.0, -8.5),
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 1,
            hr_version =
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/east/floorDust.png",
              line_length = 8,
              width = 196,
              height = 146,
              shift = util.by_pixel(-10.5, -7.5), 
              frame_count = 64,
              frame_sequence = linear_animation,
              animation_speed = animation_speed,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            }
          },
          south_animation = {  
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/lr/south/floorDust.png",
            line_length = 8,
            width = 98,
            height = 74,
            shift = util.by_pixel(7.0, 31.5), 
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 1,
            hr_version =
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/south/floorDust.png",
              line_length = 8,
              width = 193,
              height = 156,
              shift = util.by_pixel(7.0, 31.75),
              frame_count = 64,
              frame_sequence = linear_animation,
              animation_speed = animation_speed,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            }
          },
          west_animation =
          {  
            priority = "high",
            filename = "__my_first_mod__/graphics/sprites/lr/west/floorDust.png",
            line_length = 8,
            width = 97,
            height = 66,
            shift = util.by_pixel(10.5, 5.0), 
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 1,
            hr_version =
            {
              priority = "high",
              filename = "__my_first_mod__/graphics/sprites/hr/west/floorDust.png",
              line_length = 8,
              width = 194,
              height = 135,
              shift = util.by_pixel(9.5, 5.0), 
              frame_count = 64,
              frame_sequence = linear_animation,
              animation_speed = animation_speed,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            }
          },
        },
      }
    }

    return graphics_set
end

return excavatorGrahpics