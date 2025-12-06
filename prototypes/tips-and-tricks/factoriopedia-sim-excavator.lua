---@diagnostic disable: undefined-global
require("__core__/lualib/story")

---@diagnostic disable-next-line: unknown-cast-variable
---@cast game LuaGameScript

game.simulation.camera_position = {0.5, -1}
game.simulation.camera_zoom = 1.4

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

set_area("water", surface, {x = -9, y = -5}, {x = -3, y = 3})
local top_left = {x = -4, y = -5}
local bottom_right = {x = -1, y = 3}
set_area("canex-digable", surface, top_left, bottom_right, true)

local bp = "0eNqV1OFugyAQB/B3uc/QlFa76qssi0E8OxJFA0eja3z3oU1dUl2ifpM7fn8w4APyymNrtSFIH6BVYxyknw9w+mZkNY4ZWSOkoKTBjmOn5F1SY2FgoE2BHaRi+GKAhjRpfE6eXvrM+DpHGxrYC8EKFVmtOBq0t56HWLSlVAgM2sYFoTFjZjdN6iHl4hSCCm3DvKkWMch9WaLNnP4JpDjOz8AWyac52fnckZyMRdR5jlohzuy/L7BwuDjETyo6xG/LXpGjWSYrjWsbSzzHipZwtMuNN7vxLvey2f3Y5X5sdi+73Otm97rLTWZXm1KbUOLqG92KK94OxKs/c0ikzc2NfRbr5o6ZD7Uq3AYsMk1YhxJZj2snUhznBVSNLHDlJI4t6/thQH37XHvrCcarO8aFgb8fAYM7Wjf1x5dTEiVJfBXnJDlGw/ALHolikg=="
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