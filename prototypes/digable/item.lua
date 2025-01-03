return
{
    type = "item",
    name = "canex-digable",
    place_as_tile =
    {
      result = "canex-tile-digable",
      condition_size = 1,
      condition = { layers = { water_tile = true }}
    },
    icon = "__canal-excavator-graphics__/graphics/icons/marker.png",
    tint = {r=0.49, g=0.49, b=0.49, a=0.2},
    icon_size = 64,
    icon_mipmaps = 4,
    pictures =
    {
        { size = 64, filename = "__canal-excavator-graphics__/graphics/icons/marker.png",   scale = 0.25, mipmap_count = 4 }
    },
    subgroup = "terrain",
    order = "c[landfill]-b[canal]",
    stack_size = 50
}