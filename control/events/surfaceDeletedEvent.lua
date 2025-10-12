---@param event EventData.on_surface_deleted
local function surface_deleted_event(event)
    storage.remaining_ore[event.surface_index] = nil
    storage.dug[event.surface_index] = nil
end

return surface_deleted_event