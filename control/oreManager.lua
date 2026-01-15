local flib_bounding_box = require("__flib__/bounding-box")
local surfaces_manager = require("control.surfacesManager")
local digableTileName = require("prototypes.getTileNames").digable
local excavatorUtil = require("control.excavatorUtil")

local ore_manager = {}

---Get the name of the resource entity that should be placed on a given surface
---@param surface LuaSurface
---@return string? resource_entity_name
local function get_resource_entity_name(surface)
  local name = surfaces_manager.resource_names[surface.name]
  if not prototypes.entity[name] then
    game.print("Error: No resource entity defined for surface '" .. surface.name .. "'. Please notify the mod creator of this surface that their canex-config mod-data object should be added before the data-final-fixes stage.")
    return nil
  end
  return name
end

---@param resource_name string Name of a resource entity
---@return boolean is_canex_resource Is the resource a canex resource?
function ore_manager.is_canex_resource_name(resource_name)
  return string.sub(resource_name, 1, 17) == "canex-rsc-digable"
end

local function pop_stored_ore_amount(surface, x, y)
  -- Retrieve the stored remaining_ore value and set index to nil
  local amount = storage.remaining_ore[surface.index][x][y]
  -- game.print("Found existing amount: " .. amount)
  storage.remaining_ore[surface.index][x][y] = nil
  return amount
end

function ore_manager.is_tile_started(surface, position)
  return storage.remaining_ore[surface.index] ~= nil
     and storage.remaining_ore[surface.index][position.x] ~= nil
     and storage.remaining_ore[surface.index][position.x][position.y] ~= nil
end

function ore_manager.pop_stored_ore_amount(surface, position)
  -- Retrieve the stored remaining_ore value or the starting amount if is a new tile
  local x = math.floor(position.x)
  local y = math.floor(position.y)

  if ore_manager.is_tile_started(surface, position) then
    return pop_stored_ore_amount(surface, x, y)
  end

  local surface_config = surfaces_manager.get_surface_config(surface)
  if not surface_config then error("Trying to retrieve ore starting amount from unconfigured surface") end
  return surface_config.oreStartingAmount
end

function ore_manager.insert_stored_ore_amount(surface, position, amount)
  -- If an ore tile is removed, add the remaining amount to the storage.remaining_ore table
  local x = math.floor(position.x)
  local y = math.floor(position.y)

  -- game.print("Setting (" .. idx_x .. ", " .. idx_y .. ") to " .. amount)
  if storage.remaining_ore[surface.index] == nil then
    storage.remaining_ore[surface.index] = {}
  end

  if storage.remaining_ore[surface.index][x] == nil then
    storage.remaining_ore[surface.index][x] = {}
  end

  if storage.remaining_ore[surface.index][x][y] ~= nil then
    game.print("Overwriting existing value. This shouldn't be happening. Please submit a bug report on the Canal Excavator Github page and try to explain what you did.")
  end

  storage.remaining_ore[surface.index][x][y] = amount
end

function ore_manager.clear_stored_ore_amount()
  local count
  if storage.remaining_ore == nil then
    count = 0
  else
    count = #storage.remaining_ore
  end
  
  game.print("Resetting partially dug tiles")
  storage.remaining_ore = {}
end

---@param surface LuaSurface
---@param position MapPosition
---@return LuaEntity | nil
function ore_manager.create_ore(surface, position)
  local name = get_resource_entity_name(surface)
  if not name then
    return
  end
  local resource = surface.create_entity{name=name, position=position, force=game.forces.player}

  if not resource or not resource.valid then
    game.print("Canal Excavator: Unable to create resource. Please notify the mod creator when this happens")
    return
  end

  if storage.resources == nil then
    storage.resources = {}
  end
  local uid = script.register_on_object_destroyed(resource)
  storage.resources[uid] = resource

  resource.amount = ore_manager.pop_stored_ore_amount(surface, position)
  return resource
end

function ore_manager.delete_ore(entity)
  if entity.valid then
    entity.destroy()
  end
end

function ore_manager.remove_floating()
  for uid, entity in pairs(storage.resources) do
    if entity and entity.valid then
      local surface = entity.surface
      local tile = surface.get_tile(entity.position.x, entity.position.y)
      if tile.name ~= digableTileName then
        storage.resources[uid] = nil
        local remaining_surface = storage.remaining_ore[surface.index]
        if remaining_surface then
          local remaining_x = remaining_surface[entity.position.x]
          if remaining_x then
            remaining_x[entity.position.y] = nil
          end
        end
        entity.destroy()
      end
    end
  end
end

function ore_manager.get_colliding_entities(surface, position)
  local area = flib_bounding_box.from_position(position, true)
  area.left_top.x = area.left_top.x + 0.01
  area.left_top.y = area.left_top.y + 0.01
  area.right_bottom.x = area.right_bottom.x - 0.01
  area.right_bottom.y = area.right_bottom.y - 0.01

  return surface.find_entities_filtered{
    area = area,
    name = excavatorUtil.excavator_entity_names,
    invert = true
  }
end

return ore_manager