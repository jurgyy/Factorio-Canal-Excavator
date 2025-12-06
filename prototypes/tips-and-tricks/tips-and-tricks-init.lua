---@diagnostic disable: undefined-global
require("__core__/lualib/story")

---@diagnostic disable-next-line: unknown-cast-variable
---@cast game LuaGameScript

game.simulation.active_quickbars = 1
local player = game.simulation.create_test_player{name = "big K"}
player.character.teleport{0, 4}
player.force.research_all_technologies()

game.simulation.camera_player = player
game.simulation.camera_position = {0, 0.5}
game.simulation.camera_player_cursor_position = player.position
player.set_quick_bar_slot(1, "canex-digable")
player.set_quick_bar_slot(2, "canex-excavator")
player.set_quick_bar_slot(3, "transport-belt")

local surface = game.surfaces[1]

surface.set_tiles({
  {name = "water", position={-9, -4}}, {name = "water", position={-8, -4}}, {name = "water", position={-7, -4}},
  {name = "water", position={-9, -3}}, {name = "water", position={-8, -3}}, {name = "water", position={-7, -3}},
  {name = "water", position={-9, -2}}, {name = "water", position={-8, -2}}, {name = "water", position={-7, -2}},
})

local bp = "0eNqV09tugzAMBuB38XWoCoW28CrThDiYzhIYlEM1VvHuc9jGDqVayw1KHH+/hcgFytbhoIktZBegqmcD2dMFDJ24aP0eFx1CBthiZTVVATLq0xhIB+qmqBAmBcQ1vkIWTmql0+qCzdBrG5TY2h/Ho+lZAbIlS/iROi/GnF1XohZP/Z+uYOiNCD37SFGDvYJRXmEiSTVpaZyLsYLSNQ3q3NCbmOF2efzYf6KjJdq40thiNm5nbacVY6dufIIrJ9okn9Dm79Qrbny3u3vITe5244fc/d1u8pB7WNy2L2rZufIOtzQFdhx8J/Hg/D95hR8XnLghllJQvaBZGfr4e+iv47lBa4lPxh/T2PVnzJ3UWvlzsc7JYiclqx1O/h74tYR9X0cFZ9Rmjkn2URqnaXIMd2m6jafpHdBXPDw="

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

local fuel = nil
local fuel_stack_size = 0
local prototype = get_first_fuel()
if prototype then
  fuel = prototype.name
  fuel_stack_size = prototype.stack_size
  player.set_quick_bar_slot(4, fuel)
  bp = "0eNqVk9tugzAMQP/Fz6Eqt7bhV6oJcTGdJTAoCdUY4t9nqNZtLdVaXiJ8OceRnBHyusfOEDtIRqCiZQvJcQRLJ87qOcZZg5AA1lg4Q4WHjOY0eNKBpsoKhEkBcYkfkPiTWul0JmPbtcZ5OdbuV3kwvSlAduQIL9blZ0i5b3I0wlP/2xV0rRVCy7NSqJ50DfMh00BJRhqXZKQg76sKTWrpU5j+9vrNY9+oA/Vg/DvffhMvwmAT3whXsOHTWP0KNnoae3gFGz+N9bevcHdXLnFFLCmveEe7xg3/cL/LU4vOEZ/sXGawac+Y9pKrZSuwTMlhIylnepxW9Purvm6zUiL32uDBZRS4obsM3vWyy7LAs0wCP+9IwRmNXerjXaAjreODH2q9jabpC7RMJWM="
end

surface.create_entities_from_blueprint_string
{
  string = bp,
  position = {6, -4}
}

local story_table =
{
  {
    {
      name = "start",
      init = function() end,
      condition = story_elapsed_check(0),
      action = function()
        player.insert({name="canex-digable", count=100})
        player.insert({name="canex-excavator", count=10})
        player.insert({name="transport-belt", count=50})
        if fuel then
          player.insert({name=fuel, count=fuel_stack_size * 5})
        end
      end
    },
    {
      condition = function()
        local target = game.simulation.get_widget_position({type = "quickbar-slot", data = "canex-digable"})
        ---@cast target -?
        return game.simulation.move_cursor({position = target})
      end
    },
    {
      condition = story_elapsed_check(0.25),
      action = function()
        game.simulation.control_press{control = "pipette", notify = false}
      end
    },
    {
      condition = story_elapsed_check(0.1),
      action = function()
        game.simulation.control_press{control = "rotate", notify = false}
        game.simulation.control_press{control = "rotate", notify = false}
      end
    },
    { condition = function() return game.simulation.move_cursor({position = {-0.5, -2.5}}) end},
    {
      condition = story_elapsed_check(0.25),
      action = function() game.simulation.control_press{control = "larger-terrain-building-area", notify = true} end
    },
    { condition = story_elapsed_check(0.25) },
    { condition = function() return game.simulation.move_cursor({position = {-4.5, -2.5}}) end},
    {
      init = function() game.simulation.control_down{control = "build", notify = true} end,
      condition = function()
        return game.simulation.move_cursor({position = {2.5, -2.5}})
      end,
      action = function()
        game.simulation.control_up{control = "build"}
      end
    },
    {
      condition = story_elapsed_check(0.25),
      action = function()
        game.simulation.control_press{control = "smaller-terrain-building-area", notify = false}
        player.clear_cursor()
      end
    },
    {
      condition = function() return game.simulation.move_cursor({position = {-0.5, -2.5}}) end,
    },
    {
      condition = story_elapsed_check(0.5),
      action = function()
        game.simulation.control_press{control = "pipette", notify = true}
      end
    },
    { condition = story_elapsed_check(0.25) },
    { condition = function() return game.simulation.move_cursor({position = {-5, -3}}) end},
    {
      init = function() game.simulation.control_down{control = "build", notify = true} end,
      condition = function() return game.simulation.move_cursor({position = {4, -3}}) end,
    },
    {
      condition = story_elapsed_check(0.25),
      action = function()
        game.simulation.control_press{control = "rotate", notify = false}
        game.simulation.control_press{control = "rotate", notify = false}
        player.clear_cursor()
        if not fuel then
          story_jump_to(storage.story, "after-fuel")
        end
      end
    },
    {
      condition = function()
        local target = game.simulation.get_widget_position({type = "quickbar-slot", data = fuel})
        ---@cast target -?
        return game.simulation.move_cursor({position = target})
      end
    },
    {
      condition = story_elapsed_check(0.25),
      action = function()
        game.simulation.control_press{control = "pipette", notify = false}
      end
    },
    { condition = function() return game.simulation.move_cursor({position = {4.5, 0.5}}) end},
    {
      init = function() game.simulation.control_down{control = "inventory-transfer", notify = true} end,
      condition = function()
        return game.simulation.move_cursor({position = {-4.5, 0.5}})
      end,
      action = function()
        game.simulation.control_up{control = "inventory-transfer", notify = true}
        player.clear_cursor()
      end
    },
    {
      name = "after-fuel",
      condition = function()
        local target = game.simulation.get_widget_position({type = "quickbar-slot", data = "transport-belt"})
        ---@cast target -?
        return game.simulation.move_cursor({position = target})
      end
    },
    {
      condition = story_elapsed_check(0.25),
      action = function()
        game.simulation.control_press{control = "pipette", notify = false}
      end
    },
    {
      condition = story_elapsed_check(0.25),
      action = function()
        game.simulation.control_press{control = "rotate", notify = false}
      end
    },
    { condition = function() return game.simulation.move_cursor({position = {-4.5, 3.5}}) end},
    {
      init = function() game.simulation.control_down{control = "build", notify = true} end,
      condition = function() return game.simulation.move_cursor({position = {6.5, 3.5}}) end,
      action = function() game.simulation.control_press{control = "build", notify = false} end
    },
    {
      condition = story_elapsed_check(0.25),
      action = function()
        game.simulation.control_press{control = "reverse-rotate", notify = false}
        action = player.clear_cursor()
      end
    },
    { condition = function() return game.simulation.move_cursor({position = {0, 4}}) end},
    {
      condition = story_elapsed_check(3),
      action = function()
        surface.build_checkerboard{left_top = {x = -6, y = -4}, right_bottom = {x = 5, y = -1}}
        player.character.clear_items_inside()
        for _, entity in pairs (surface.find_entities_filtered{area = {{-5.5, -3.5}, {5.5, 4.5}}}) do
          if entity.name ~= "character" then
            entity.destroy{raise_destroy = true}
          end
        end

        remote.call("canal-excavator", "reset")
        story_jump_to(storage.story, "start")
      end
    }
  }
}
tip_story_init(story_table)