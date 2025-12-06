local remotes_manager = require("control.remoteManager")
local surface_manager = require("control.surfacesManager")

---Ask all registered remotes for the created surface's CanexSurfaceTemplate.
---If one is found, register it with the surface manager.
---@param event EventData.on_surface_created
local function surface_created_event(event)
  local surface = game.surfaces[event.surface_index]
  if surface_manager.get_surface_config(surface) then
    return
  end
  local surface_template = nil

  for _, sc_remote in pairs(remotes_manager.surface_created_remotes) do
    surface_template = remote.call(sc_remote.interface, sc_remote.get_surface_template_function, surface)
    if surface_template then
      break
    end
  end

  if surface_template then
    surface_manager.add_surface_config(surface, surface_template)
  end
end

return surface_created_event