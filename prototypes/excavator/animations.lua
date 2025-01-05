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
              height = 520,
              frame_count = 64,
              shift = util.by_pixel(-6.5, -107.5), 
              animation_speed = animation_speed,
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
              draw_as_shadow = true,
              repeat_count = 1,
              scale = 0.5
            }
          }
        }
      },
      working_visualisations =
      {
        {-- Rocks
          fadeout = false,
          apply_tint = "resource-color",

          north_animation = 
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/north/rocks.png",
            line_length = 8,
            width = 97,
            height = 495,
            shift = util.by_pixel(-9.75, -98.25),
            frame_count = 64,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
          east_animation =
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/east/rocks.png",
            line_length = 8,
            width = 360,
            height = 332,
            shift = util.by_pixel(36.0, -62.0),
            frame_count = 64,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
          south_animation = {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/south/rocks.png",
            line_length = 8,
            width = 95,
            height = 188,
            shift = util.by_pixel(3.25, 21.0),
            frame_count = 64,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
          west_animation = 
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/west/rocks.png",
            line_length = 8,
            width = 370,
            height = 325,
            shift = util.by_pixel(-39.0, -56.75),
            frame_count = 64,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
        },
        {-- Drop
          fadeout = true,
          apply_tint = "resource-color",

          north_animation = 
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/north/drop.png",
            line_length = 8,
            width = 57,
            height = 160,
            shift = util.by_pixel(-8.75, -192.5),
            frame_count = 64,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
          east_animation =
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/east/drop.png",
            line_length = 8,
            width = 62,
            height = 209,
            shift = util.by_pixel(135.5, -86.75),
            frame_count = 64,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
          south_animation = {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/south/drop.png",
            line_length = 8,
            width = 57,
            height = 202,
            shift = util.by_pixel(2.75, 50.0),
            frame_count = 64,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
          west_animation = 
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/west/drop.png",
            line_length = 8,
            width = 57,
            height = 205,
            shift = util.by_pixel(-137.25, -84.25),
            frame_count = 64,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
        },
        {-- Hopper Dust
          fadeout = true,
          apply_tint = "resource-color",

          north_animation = 
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/north/hopperDust.png",
            line_length = 8,
            width = 124,
            height = 118,
            shift = util.by_pixel(-10.0, -169.5),
            frame_count = 64,
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
            height = 127,
            shift = util.by_pixel(136.25, -62.25),
            frame_count = 64,
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
            height = 117,
            shift = util.by_pixel(3.5, 81.25),
            frame_count = 64,
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
            height = 120,
            shift = util.by_pixel(-136.75, -56.0),
            frame_count = 64,
            animation_speed = animation_speed,
            direction_count = 1,
            repeat_count = 1,
            scale = 0.5,
          },
        },
        { -- Floor Dust
          fadeout = true,
          apply_tint = "resource-color",

          north_animation =
          {
            priority = "high",
            filename = "__canal-excavator-graphics__/graphics/sprites/north/floorDust.png",
            line_length = 8,
            width = 192,
            height = 157,
            shift = util.by_pixel(-10.5, -11.25),
            frame_count = 64,
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