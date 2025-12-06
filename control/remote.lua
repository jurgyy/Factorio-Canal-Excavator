remote.add_interface("canal-excavator",
{
  ---Implementation of the remote interface function to get a CanexSurfaceTemplate name for a Space Exploration zone surface.
  ---For more information on remote interfaces see [the game's documentation](https://lua-api.factorio.com/stable/classes/LuaRemote.html)
  ---@param surface LuaSurface
  ---@return string? CanexSurfaceTemplate.name?
  se_get_zone_template = function(surface)
    -- SE specific implementation
    local zone = remote.call("space-exploration", "get_zone_from_name", {zone_name = surface.name})

    ---@diagnostic disable: undefined-field
    -- No information about this zone
    if not zone or not zone.tags then return end

    local tags = zone.tags
    -- No water, no excavation
    if not tags["water"] or tags["water"] == "water_none" then return end

    local primary_resource = zone.primary_resource
    ---@diagnostic enable: undefined-field

    -- Frozen zones yield ice
    if tags["temperature"] and tags["temperature"] == "temperature_frozen" then
      return "canex-se-ice-template"
    end

    -- Vita zones yield vitamelange
    if primary_resource == "se-vitamelange" then
      return "canex-se-vitamelange-template"
    end

    -- All other zones yield stone
    return "canex-se-stone-template"
  end,

  --------------------
  --- Remotes that are internally used

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