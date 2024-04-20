-- Copied from __base__
local dirt_sounds =
{
  {
    filename = "__base__/sound/walking/dirt-1-01.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-02.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-03.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-04.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-05.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-06.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-07.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-08.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-09.ogg",
    volume = 0.8
  },
  {
    filename = "__base__/sound/walking/dirt-1-10.ogg",
    volume = 0.8
  }
}

return
{
    type = "tile",
    name = "tile-canal-marker",
    order = "e[canal-marker]",
    collision_mask = {"ground-tile"},
    layer = 200,
    variants = data.raw["tile"]["landfill"].variants,
    walking_sound = dirt_sounds,
    map_color={r = 0.490, g = 0.304, b = 0.0245},
    scorch_mark_color = {r = 1.000, g = 1.000, b = 1.000, a = 1.000},
    pollution_absorption_per_second = 0,
    minable = {mining_time = 0.1, result = "item-canal-marker"},
    decorative_removal_probability = 1 
}