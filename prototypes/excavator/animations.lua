linear_animation = 
{
   1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16,
  17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
  33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64
}

animation_speed = 0.6

local function excavatorGrahpics()
    graphics_set =
    {
      circuit_connector_layer = "object",
      circuit_connector_secondary_draw_order = { north = 14, east = 30, south = 127, west = 30 },

      animation =
      {
        north =
        {
          layers =
          {
            { -- Machine animation
              priority = "high",
              filename = "__canal-excavator-graphics__/graphics/sprites/north/machine.png",
              line_length = 8,
              width = 174,
              height = 526,
              frame_count = 64,
              shift = util.by_pixel(-6.5, -106.0), 
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            },
            { -- Shadows
              priority = "high",
              filename = "__canal-excavator-graphics__/graphics/sprites/north/shadows.png",
              line_length = 8,
              width = 514,
              height = 330,
              shift = util.by_pixel(79.0, -50.5), 
              frame_count = 64,
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              draw_as_shadow = true,
              repeat_count = 1,
              scale = 0.5
            }
          }
        },
        east =
        {
          layers =
          {
            { -- Machine animation
              priority = "high",
              filename = "__canal-excavator-graphics__/graphics/sprites/east/machine.png",
              line_length = 8,
              width = 466,
              height = 368,
              frame_count = 64,
              shift = util.by_pixel(59.5, -58.5), 
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            },
            { -- Shadows
              priority = "high",
              filename = "__canal-excavator-graphics__/graphics/sprites/east/shadows.png",
              line_length = 8,
              width = 743,
              height = 124,
              frame_count = 64,
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              draw_as_shadow = true,
              shift = util.by_pixel(135, 5.5), 
              repeat_count = 1,
              scale = 0.5
            }
          }
        },
        south =
        {
          layers =
          {
            { -- Machine animation
              priority = "high",
              filename = "__canal-excavator-graphics__/graphics/sprites/south/machine.png",
              line_length = 8,
              width = 174,
              height = 402,
              frame_count = 64,
              shift = util.by_pixel(-0.0, 70.0), 
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            },
            { -- Shadows
              priority = "high",
              filename = "__canal-excavator-graphics__/graphics/sprites/south/shadows.png",
              line_length = 8,
              width = 520,
              height = 330,
              shift = util.by_pixel(91.0, 90.5), 
              frame_count = 64,
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              draw_as_shadow = true,
              repeat_count = 1,
              scale = 0.5
            }
          }
        },
        west = 
        {
          layers =
          {
            { -- Machine animation
              priority = "high",
              filename = "__canal-excavator-graphics__/graphics/sprites/west/machine.png",
              line_length = 8,
              width = 466,
              height = 365,
              frame_count = 64,
              shift = util.by_pixel(-60.0, -55.25), 
              animation_speed = animation_speed,
              frame_sequence = linear_animation,
              direction_count = 1,
              repeat_count = 1,
              scale = 0.5,
            },
            { -- Shadows
              priority = "high",
              filename = "__canal-excavator-graphics__/graphics/sprites/west/shadows.png",
              line_length = 8,
              width = 568,
              height = 124,
              shift = util.by_pixel(-31.0, 5.0), 
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
      working_visualisations =
      {
        {-- Hopper Dust
          fadeout = true,

          north_animation = 
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/north/hopperDust.png",
            line_length = 8,
            width = 124,
            height = 185,
            shift = util.by_pixel(-10.0, -186.25), 
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
          east_animation =
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/east/hopperDust.png",
            line_length = 8,
            width = 109,
            height = 217,
            shift = util.by_pixel(136.25, -84.75), 
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
          south_animation = {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/south/hopperDust.png",
            line_length = 8,
            width = 124,
            height = 222,
            shift = util.by_pixel(3.5, 55.0), 
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
          west_animation = 
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/west/hopperDust.png",
            line_length = 8,
            width = 109,
            height = 219,
            shift = util.by_pixel(-136.75, -80.75), 
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
        },
        { -- Floor Dust
          fadeout = true,

          north_animation =
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/north/floorDust.png",
            line_length = 8,
            width = 192,
            height = 157,
            shift = util.by_pixel(-10.5, -11.25), 
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
          east_animation =
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/east/floorDust.png",
            line_length = 8,
            width = 195,
            height = 153,
            shift = util.by_pixel(-8.75, -5.25), 
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
          south_animation = {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/south/floorDust.png",
            line_length = 8,
            width = 197,
            height = 149,
            shift = util.by_pixel(4.75, 29.75), 
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
          west_animation =
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/west/floorDust.png",
            line_length = 8,
            width = 208,
            height = 126,
            shift = util.by_pixel(8.0, 5.5), 
            frame_count = 64,
            frame_sequence = linear_animation,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
        },
      },
      water_reflection =
      {
        pictures =
        {
          filename = "__canal-excavator-graphics__/graphics/sprites/reflections.png",
          priority = "extra-high",
          width = 176,
          height = 248,
          shift = util.by_pixel(-20, 0),
          variation_count = 4,
          scale = 2.5
        },
        rotate = false,
        orientation_to_variation = true
      }
    }

    return graphics_set
end

return excavatorGrahpics