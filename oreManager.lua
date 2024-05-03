local ore_manager = {}

local function pop_stored_ore_amount(surface, x, y)
  -- Retrieve the stored remaining_ore value and set index to nil
  local amount = global.remaining_ore[surface.index][x][y]
  -- game.print("Found existing amount: " .. amount)
  global.remaining_ore[surface.index][x][y] = nil
  return amount
end

function ore_manager.pop_stored_ore_amount(surface, position)
  -- Retrieve the stored remaining_ore value or the starting amount if is a new tile
  local x = math.floor(position.x)
  local y = math.floor(position.y)

  if global.remaining_ore[surface.index] == nil
  or global.remaining_ore[surface.index][x] == nil
  or global.remaining_ore[surface.index][x][y] == nil then
    return global.ore_starting_amount
  end
  return pop_stored_ore_amount(surface, x, y)
end
  
function ore_manager.insert_stored_ore_amount(surface, position, amount)
  -- If an ore tile is removed, add the remaining amount to the global.remaining_ore table
  local x = math.floor(position.x)
  local y = math.floor(position.y)

  -- game.print("Setting (" .. idx_x .. ", " .. idx_y .. ") to " .. amount)
  if global.remaining_ore[surface.index] == nil then
    global.remaining_ore[surface.index] = {}
  end

  if global.remaining_ore[surface.index][x] == nil then
    global.remaining_ore[surface.index][x] = {}
  end

  if global.remaining_ore[surface.index][x][y] ~= nil then
    game.print("Overwriting existing value. This shouldn't be happening. Please submit a bug report on the Canal Excavator Github page and try to explain what you did.")
  end

  global.remaining_ore[surface.index][x][y] = amount
end

function ore_manager.clear_stored_ore_amount()
  local count
  if global.remaining_ore == nil then
    count = 0
  else
    count = #global.remaining_ore
  end
  
  game.print("Resetting " .. count .. " partially dug tiles")
  global.remaining_ore = {}
end

return ore_manager