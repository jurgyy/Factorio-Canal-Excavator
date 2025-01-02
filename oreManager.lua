local flib_bounding_box = require("__flib__/bounding-box")
local planets_manager = require("planetsManager")

local ore_manager = {}

local function get_resource_entity_current_name()
  return "canex-rsc-digable"
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
  
  local planet_config = planets_manager.get_planet_config(surface)
  return planet_config.oreStartingAmount
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
  local name = get_resource_entity_current_name()
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

function ore_manager.get_colliding_entities(surface, position)
  local area = flib_bounding_box.from_position(position, true)
  area.left_top.x = area.left_top.x + 0.01
  area.left_top.y = area.left_top.y + 0.01
  area.right_bottom.x = area.right_bottom.x - 0.01
  area.right_bottom.y = area.right_bottom.y - 0.01

  return surface.find_entities_filtered{
    area = area,
    name = {"canex-excavator"},
    invert = true
  }
end

return ore_manager