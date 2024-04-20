return
{
    type = "item",
    name = "item-canal-marker",
    --place_result = "rsc-canal-marker",
    place_as_tile =
    {
      result = "tile-canal-marker",
      condition_size = 1,
      condition = { "water-tile" }
    },
    icon = "__my_first_mod__/graphics/icons/icon.png",
    tint = {r=0.49, g=0.49, b=0.49, a=0.2},
    icon_size = 64,
    icon_mipmaps = 4,
    pictures =
    {
        { size = 64, filename = "__my_first_mod__/graphics/icons/icon.png",   scale = 0.25, mipmap_count = 4 }
    },
    subgroup = "raw-resource",
    order = "e[canal-marker]",
    stack_size = 50
}