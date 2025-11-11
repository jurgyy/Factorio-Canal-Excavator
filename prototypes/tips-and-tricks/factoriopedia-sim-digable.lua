---@diagnostic disable: undefined-global
require("__core__/lualib/story")

---@diagnostic disable-next-line: unknown-cast-variable
---@cast game LuaGameScript

local surface = game.surfaces[1]

---@param tile string
---@param surface LuaSurface
---@param top_left MapPosition
---@param bottom_right MapPosition
---@param raise boolean?
local function set_area(tile, surface, top_left, bottom_right, raise)
  local tiles = {}
  for x = top_left.x, bottom_right.x, 1 do
    for y = top_left.y, bottom_right.y, 1 do
      table.insert(tiles, {
        name = tile,
        position = {x, y}
      })
    end
  end
  surface.set_tiles(tiles, true, true, true, raise == true)
end

set_area("water", surface, {x = -7, y = -3}, {x = -3, y = 3})
local top_left = {x = -4, y = -3}
local bottom_right = {x = -1, y = 3}
set_area("canex-digable", surface, top_left, bottom_right, true)

local bp = "0eNqV0+FqgzAQB/B3uc9JqVad8VXKkKhnF9BEkrPUFd990VLHpoXqN3OX3z/K5Q5F02NnlSbI7qBKox1k5zs4ddGymda0bBEyKKXGG8dbKa+SjIWRgdIV3iALxk8GqEmRwsfm+WXIdd8WaH0DeyLYYElWlRw12svAfSzaWpYIDDrjvGD0lOnVI4MBMh4kPqhS1u+baxGDoq9rtLlT354MjsszslVyuCS7vnAkZ2MVFS5RG8SJvfoDK4eHh/hBpYf437E35GiRyUrtOmOJF9jQGj7tcuO33WiXm7ztxrvcj7fdZJebLq7StdK+xMsvdBuu+Os+23OHREpf3NRmsTVXzHtfa/zQYpUrwtaXyPa4NThiiW+MrHBjXtJXH8OAhu5x8K4nmO7XFOYXfm8rgytaN/fHSSgiIeI0OAlxjMbxBwJrRVk="
surface.create_entities_from_blueprint_string
{
  string = bp,
  position = {4, -3}
}

function get_first_fuel()
  local burner_prototype = prototypes.entity["canex-excavator"].burner_prototype
  if burner_prototype then
    for _, prototype in pairs(prototypes.item) do
      local cat = next(burner_prototype.fuel_categories)
      if prototype.fuel_category == cat then
        return prototype
      end
    end
  end
  return nil
end

local prototype = get_first_fuel()
if prototype then
  for _, entity in pairs (surface.find_entities_filtered{area = {{-1, -1}, {1, 1}}, name="canex-excavator"}) do
    entity.insert{name=prototype.name, count=prototype.stack_size}
  end
end