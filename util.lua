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

return util