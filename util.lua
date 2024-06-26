local flib_bounding_box = require("__flib__/bounding-box")

local util = {}

function util.to_str(s)
    if s == nil then
        return "nil"
    end
    return tostring(s)
end

function util.highlight_position(surface, position, color)
    local bbox = flib_bounding_box.from_position(position, true)
    bbox = flib_bounding_box.resize(bbox, -0.02)
    util.highlight_bbox(surface, bbox, color)
end


function util.highlight_bbox(surface, bbox, color)
    if color == nil then
        color = {r = 0, g = 1, b = 0, a = 1}
    end
    rendering.draw_rectangle {
        color = color,
        left_top = bbox.left_top,
        right_bottom = bbox.right_bottom,
        time_to_live = 120,
        surface = surface
    }
end

function util.canalDebug()
    --game.player.insert{name = "canex-excavator", count = 50}
    --game.player.insert{name = "canex-item-digable", count = 250}
    game.print("dug: " .. game.table_to_json(global.dug))
    for surfaceIndex, surfaceData in pairs(global.dug) do
      for x, column in pairs(surfaceData) do
          for y, dug in pairs(column) do
              if dug then
                  local position = {x = x, y = y}
                  util.highlight_position(game.surfaces[surfaceIndex], position, {r = 0.7, g = 0.5, b = 0.1, a = 1})
              end
          end
      end
    end
    game.print("remaining_ore: " .. game.table_to_json(global.remaining_ore))
    for surfaceIndex, surfaceData in pairs(global.remaining_ore) do
      for x, column in pairs(surfaceData) do
          for y, value in pairs(column) do
              -- Call the create_local_flying_text function
              local position = {x = x + 0.5, y = y + 0.5}
              util.highlight_position(game.surfaces[surfaceIndex], position, {r = 0.1, g = 0.8, b = 0.1, a = 1})
              game.player.create_local_flying_text{text = {"story.canex-remaining", value}, position = position, speed=0, time_to_live=300}
          end
      end
    end
  
    game.print("dug_to_water: " .. game.table_to_json(global.dug_to_water))
    for tick, entries in pairs(global.dug_to_water) do
      for _, entry in pairs(entries) do
          -- Call the highlight_position function
          local surface = entry.surface
          local position = entry.position
          util.highlight_position(surface, position, {r = 0.1, g = 0.1, b = 0.8, a = 1})
          
          -- Call the create_local_flying_text function
          game.player.create_local_flying_text{text = {"story.canex-dug", tick - game.tick}, position = position, speed = 0, time_to_live = 300}
      end
    end
end

return util