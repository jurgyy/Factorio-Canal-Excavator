remote.add_interface("canal-excavator",
{
  ---Does not clean up any remaining ore/tiles.
  ---Will crash if a player then mines a diggable tile or an excavator empties a resource
  reset = function()
    storage.dug_to_water = {}
    storage.dug = {}
    storage.remaining_ore = {}
    storage.resources = {}
  end,

  register_resource = function(resourceEntity)
    local uid = script.register_on_object_destroyed(resourceEntity)
    storage.resources[uid] = resourceEntity
  end
})