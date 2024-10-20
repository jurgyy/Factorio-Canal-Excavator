local flib_bounding_box = require("__flib__/bounding-box")

local ore_manager = {}

local function get_resource_entity_current_name()
  local resource_steps = 10
  local productivity = 1 + game.forces["player"].mining_drill_productivity_bonus
  if productivity < 1 then
      game.print("Productivity lower than one not supported. Falling back as if productivity is equal to 1.")
      productivity = 1
  end
  local index = math.floor(resource_steps / productivity)
  if index < 1 then
      index = 1
  end
  return "canex-rsc-digable-" .. index
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
  return storage.ore_starting_amount
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

  if resource == nil or not resource.valid then
    game.print("Canal Excavator: Unable to create resource if this happens regularly, please notify the mod creator")
    return
  end

  if storage.resources == nil then
    storage.resources = {}
  end
  local uid = script.register_on_entity_destroyed(resource)
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
  return surface.find_entities_filtered{
    area = flib_bounding_box.from_position(position, true),
    name = {"canex-excavator"},
    invert = true
  }
end

return ore_manager