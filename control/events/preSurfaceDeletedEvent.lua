---@param event EventData.on_pre_surface_deleted
local function pre_surface_deleted_event(event)
    local surface = game.get_surface(event.surface_index)
    if surface then
        storage.runtime_surface_config[surface.name] = nil
    end
end

return pre_surface_deleted_event