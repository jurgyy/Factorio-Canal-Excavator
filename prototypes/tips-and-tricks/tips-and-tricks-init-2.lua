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

local function set_tiles(water_tile, surfaceName)
  surface.set_tiles({
    {name = water_tile, position={-9, -4}}, {name = water_tile, position={-8, -4}}, {name = water_tile, position={-7, -4}},
    {name = water_tile, position={-9, -3}}, {name = water_tile, position={-8, -3}}, {name = water_tile, position={-7, -3}},
    {name = water_tile, position={-9, -2}}, {name = water_tile, position={-8, -2}}, {name = water_tile, position={-7, -2}},
  })

  local tiles = {}
  for x = -6, 3, 1 do
    for y = -4, -2 , 1 do
      table.insert(tiles, {
        name = "canex-digable",
        position = {x, y}
      })
    end
  end

  surface.set_tiles(tiles, false, true, true, true)
  for x = -6, 3, 1 do
    local a = 1
    if x == -4 then a = 2 end

    for y = -4, -2 , 1 do
      local entity = surface.find_entity("canex-rsc-digable-nauvis", {x = x + .5, y = y + .5})
      if entity then
        if surfaceName ~= "nauvis" then
          local position = entity.position
          entity.destroy()
          entity = surface.create_entity{name="canex-rsc-digable-" .. surfaceName, position=position, force=player.force}
          remote.call("canal-excavator", "register_resource", entity)
        end
        entity.amount = a
      else
        error("Could not find resource at " .. x .. ", " .. y)
      end
    end
  end
end

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

local bp = "0eNqV1duKgzAQBuB3metYjNW2+irLIh7GbkCj5FDWLb77Ju62hdrCxBuJSb6R6M9coe4tTkpIA8UVRDNKDcXHFbQ4y6r3z2Q1IBRgVCX1NCoT1dgbWBgI2eI3FHz5ZIDSCCPwb+86mEtphxqVW8BuBvbYGCWaCCWq8xy5qqi6qkFgMI3aCaP0JZ0auV2zv2WuUiuU27hOpgxq23WoSi1+nMnj+7WwTenkXlrbWptqNd7XipcXxp69OYKtk+6yf2n3/Nov4JQO74PgjA4nQfCBDvMg+EiH4yD4RIbD3Jzshh0Ej8lw2KfjnAyH/Ww8IcNh8eD04GVhMD14hzCYHrxjGEwP3ikMpgcvD4PpweNhyeOP6PVj1bpHWzF55zEw8+S3CjlZ38S2HeMRQCE7Id1c1HyhfvXiT0G5rS81GiPkWft1CofxgqV1c71rdtiWwuDgpoyyuPjW6ceu2qMPM7ig0mud7JDkaZ5nJ77P8zhdll+Bq4VP"

local slot = 4

local fuel = nil
local prototype = get_first_fuel()
if prototype then
  fuel = prototype.name
  bp = "0eNqVlduKgzAQht9lrmMxHtrqq5RFPIzdgEZJYlm3+O4bW7qF2sKMN5LM5PtF/ZgrVN2Eo1HaQX4FVQ/aQn66glVnXXbrni57hBycKbUdB+OCCjsHiwClG/yBXC5fAlA75RTez94Wc6GnvkLjG8SDgR3Wzqg6QI3mPAc+FU1b1ggCxsF6wqDXSE8NIgGzv8mDT2qU8QdvxURANbUtmsKqX8+U4f+1iE10JD48/jYv3aX3xHiXvkS+Acd0cMICJ3RwzAKndHDEAu/pYMkCH+jgkAU+ksE8bkbm8l6EDMlg3qeTkgzm/WySLh5PD0kXjye0pIu354Hp4h14YLp4Rx6YLl7GAz/F64ay8VtbMeQnngA3j+tRpcdpnT9b/NM/pVulfS2ov9G+8+/Fk0d/YdE5pc927TPYDxcsJl/r/JzCplAOe19yZsJlnXrr2qc9R6iACxp7y0n3UZZkWXqUcZaFybL8AXF+bvU="
  player.set_quick_bar_slot(4, fuel)
  slot = slot + 1
end

player.set_quick_bar_slot(slot, "speed-module")
surface.create_entities_from_blueprint_string
{
  string = bp,
  position = {4, -4}
}

local tile_resources = {
  {"water", "nauvis"},
  {"lava", "vulcanus"},
  {"oil-ocean-shallow", "fulgora"},
  {"wetland-pink-tentacle", "gleba"},
  {"water-shallow", "nauvis"},
  {"brash-ice", "aquilo"}
}

local water_tiles = {}
for _, t in pairs(tile_resources) do
  if prototypes.tile[t[1]] then
    table.insert(water_tiles, t)
  end
end
local i = 0

local story_table =
{
  {
    {
      name = "start",
      condition = story_elapsed_check(0),
      action = function()
        local tile_resource = water_tiles[(i % #water_tiles) + 1]
        set_tiles(tile_resource[1], tile_resource[2])
        i = i + 1
        surface.create_entities_from_blueprint_string
        {
          string = "0eNqV0cEKgzAMBuB3ybmKTrtZX2WMUWsYBY3SVlGk776qhx3Ght7S8OcLpAtUzYC90eSgXECrjiyU9wWsfpFs1h7JFqEEJQmnCCclR+k6A56BphonKFP/YIDktNO4D2+P+UlDW6EJAfYLYdB3Nsx1tG4KVpTGnMG8FknMw45aG1R7oPDsi74cp0/K2XE5Pyfnx+XbPzlcXTtsg/P5QwYjGrsF+PUiciF4kWZCJLn3b4XHoR0=",
          position = {0, -3}
        }

        if fuel then
          for _, entity in pairs (surface.find_entities_filtered{area = {{-5.5, -3.5}, {5.5, 1.5}}, name="canex-excavator"}) do
              entity.insert{name=fuel, count=1}
          end
        end
        player.insert({name="canex-digable", count=70})
        player.insert({name="canex-excavator", count=6})
        player.insert({name="steel-chest", count=6})
        player.insert({name="speed-module", count=20})
      end
    },
    { condition = story_elapsed_check(1.5) },
    {
      condition = function()
        local target = game.simulation.get_widget_position({type = "quickbar-slot", data = "speed-module"})
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
      end
    },
    {
      condition = story_elapsed_check(0.25),
      action = function() player.clear_cursor() end
    },
    {
      condition = function() return game.simulation.move_cursor({position = {0, 4}}) end,
    },
    {
      condition = story_elapsed_check(3)
    },
    { condition = function() return game.simulation.move_cursor({position = {4.5, 0.5}}) end},
    {
      condition = story_elapsed_check(0.25),
      action = function()
        game.simulation.control_press{control = "mine", notify = false}
      end
    },
    { condition = story_elapsed_check(1) },
    { condition = function() return game.simulation.move_cursor({position = {1.5, 0.5}}) end},
    {
      condition = story_elapsed_check(0.25),
      action = function()
        game.simulation.control_press{control = "mine", notify = false}
      end
    },
    { condition = story_elapsed_check(0.5) },
    { condition = function() return game.simulation.move_cursor({position = {-1.5, 0.5}}) end},
    {
      condition = story_elapsed_check(0.25),
      action = function()
        game.simulation.control_press{control = "mine", notify = false}
      end
    },
    { condition = story_elapsed_check(0.5) },
    { condition = function() return game.simulation.move_cursor({position = {-4.5, 0.5}}) end},
    {
      condition = story_elapsed_check(0.25),
      action = function()
        game.simulation.control_press{control = "mine", notify = false}
      end
    },
    {
      condition = story_elapsed_check(1),
      action = function()
        surface.build_checkerboard{left_top = {x = -6, y = -4}, right_bottom = {x = 5, y = -1}}
        player.character.clear_items_inside()

        for _, entity in pairs (surface.find_entities_filtered{area = {{-5.5, -3.5}, {5.5, 1.5}}}) do
          if entity.name ~= "character" then
            entity.destroy()
          end
        end

        remote.call("canal-excavator", "reset")
        story_jump_to(storage.story, "start")
      end
    },
  }
}
tip_story_init(story_table)