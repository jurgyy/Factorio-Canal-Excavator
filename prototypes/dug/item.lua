-- Not meant to be used, just for debugging
return {
    type = "item",
    name = "canal-sand",
    place_as_tile =
    {
      result = "tile-dug",
      condition_size = 1,
      condition = { "water-tile" }
    },
    icons = {{
        icon = "__base__/graphics/icons/stone-2.png",
        tint = {r=0.33, g=0.15, b=0, a=0.5}
    }},
    icon_size = 64,
    icon_mipmaps = 4,
    pictures =
    {
        { size = 64, filename = "__base__/graphics/icons/info.png",   scale = 0.25, mipmap_count = 4 }
    },
    subgroup = "raw-resource",
    order = "e[canal-marker]",
    stack_size = 50
  }