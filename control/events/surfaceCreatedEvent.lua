local se_control = require("compatability.space-exploration.control")

---@param event EventData.on_surface_created
local function surface_created_event(event)
  if script.active_mods["space-exploration"] then
    se_control.on_surface_created(event)
  end
end

return surface_created_event