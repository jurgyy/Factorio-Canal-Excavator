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
    --game.player.insert{name = "canex-digable", count = 250}
    game.print("dug: " .. helpers.table_to_json(storage.dug))
    for surfaceIndex, surfaceData in pairs(storage.dug) do
      for x, column in pairs(surfaceData) do
          for y, dug in pairs(column) do
              if dug then
                  local position = {x = x, y = y}
                  util.highlight_position(game.surfaces[surfaceIndex], position, {r = 0.7, g = 0.5, b = 0.1, a = 1})
              end
          end
      end
    end
    game.print("remaining_ore: " .. helpers.table_to_json(storage.remaining_ore))
    for surfaceIndex, surfaceData in pairs(storage.remaining_ore) do
      for x, column in pairs(surfaceData) do
          for y, value in pairs(column) do
              -- Call the create_local_flying_text function
              local position = {x = x + 0.5, y = y + 0.5}
              util.highlight_position(game.surfaces[surfaceIndex], position, {r = 0.1, g = 0.8, b = 0.1, a = 1})
              game.player.create_local_flying_text{text = {"story.canex-remaining", value}, position = position, speed=0, time_to_live=300}
          end
      end
    end
  
    game.print("dug_to_water: " .. helpers.table_to_json(storage.dug_to_water))
    for tick, entries in pairs(storage.dug_to_water) do
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


---Is the surface on a valid planet? i.e. only Nauvis and alike planets. Returns true if space age isn't installed
---@param surface LuaSurface
---@return boolean
function util.surface_is_valid(surface)
    if not script.active_mods["space-age"] then
        return true
    end
    local planet = surface.planet
    if not planet then
        return false
    end
    local surface_properties = planet.prototype.surface_properties
    if not surface_properties then
        return false
    end
    
    local pressure = surface_properties["pressure"]
    return pressure == game.planets["nauvis"].prototype.surface_properties["pressure"]
end

---Draw text
---@param text string
---@param surface LuaSurface
---@param position MapPosition
function util.show_error(text, surface, position)
    rendering.draw_text{
        text = text,
        surface = surface,
        target = position,
        color = {1, 1, 1, 1},
        time_to_live = 150,
        scale_with_zoom = true,
    }
end

---Is a position landfilled
---@param surface LuaSurface
---@param position MapPosition
function util.is_position_landfilled(surface, position)
    local tile = surface.get_tile(position.x, position.y)
    if tile.name == "landfill" or tile.hidden_tile == "landfill" then
    return true
    end
    return false
end

return util