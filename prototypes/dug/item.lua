-- Not meant to be used, just for debugging
return {
    type = "item",
    name = "canex-dug",
    place_as_tile =
    {
      result = "canex-tile-dug",
      condition_size = 1,
      condition = { "water-tile" }
    },
    icons = {{
        icon = "__base__/graphics/icons/stone-2.png",
        tint = {r=0.33, g=0.15, b=0, a=0.5}
    }},
    icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "special-tiles",
    order = "e[canal-marker]",
    stack_size = 50
  }