local function surface_deleted_event(event)
    global.remaining_ore[event.surface_index] = nil
    global.dug[event.surface_index] = nil
end

return surface_deleted_event