local event = require("__flib__.event")

-- Place markers to mark where to dig
-- Place excavators to dig the area
-- Once dug, ground turned into "dug" tile
-- Dug checks if it touches water
-- If yes:
--   random delay [10, 60) ticks to turn into water
--   Notify surrounding dug tiles


function to_str(s)
  if s == nil then
    return "nil"
  end
  return tostring(s)
end

function highlight_position(surface, position)
  left = position[1] - 0.5
  right = position[1] + 0.5
  top  = position[2] - 0.5
  bottom = position[2] + 0.5

  highlight_bbox(surface, left, right, top, bottom)
end

function highlight_bbox(surface, left, right, top, bottom)
  rendering.draw_rectangle {
    color = {r = 0, g = 1, b = 0, a = 1},
    left_top = {x = left, y = top},
    right_bottom = {x = right, y = bottom},
    time_to_live = 120,
    surface = surface
  }
end

script.on_init(function()
    global.dug_to_water = {}
    global.remaining_ore = {}
end)

-- script.on_load(function()
--     if global.remaining_ore == nil then
--       global.remaining_ore = {}
--     end
-- end)
script.on_configuration_changed(function(configurationChangedData)
  game.print("on_configuration_changed")
  game.print("old version: " .. to_str(configurationChangedData.old_version))
  game.print("new version: " .. to_str(configurationChangedData.new_version))
  if configurationChangedData.mod_changes ~= nil then
    game.print("mod changes:")
    for _, k in ipairs(configurationChangedData.mod_changes) do
      game.print("\t" .. k .. ": " .. to_str(configurationChangedData.mod_changes[k].old_version) .. " to " .. to_str(configurationChangedData.mod_changes[k].new_version))
    end
  end

  game.print("mod startup settings changed: " .. to_str(configurationChangedData.mod_startup_settings_changed))
  game.print("migration applied: " .. to_str(configurationChangedData.migration_applied))
end)

local water_tile_names = {"deepwater", "deepwater-green", "water", "water-green", "water-mud", "water-shallow", "water-wube"}
-- local dug_tile_name = "brown-refined-concrete"
local dug_tile_name = "canal-sand"
local ore_starting_amount = 35
local last_nth_tick = nil
local check_interval = 15
--local canal_excavator_prototype = table.deepcopy(data.raw["mining-drill"]["canal-excavator"])


function is_any_neighbour_named(surface, center, tile_names)
  local surrounding = {{x = center.x - 1, y = center.y}, {x = center.x + 1, y = center.y}, {x = center.x, y = center.y - 1}, {x = center.x, y = center.y + 1}}
  for _, pos in ipairs(surrounding) do
    tile = surface.get_tile(pos.x, pos.y)

    for _, tile_name in ipairs(tile_names) do
      if tile.name == tile_name then
        return true
      end
    end
  end

  return false
end

function set_water(surface, position)
  -- game.print("Set water")

  highlight_position(surface, position)

  -- Die all entities that collide with water
  entities = surface.find_entities_filtered{
    position = {x = position[1], y = position[2]},
    collision_mask = "water-tile"
  }
  for _, entity in pairs(entities) do
    -- game.print("Killing " .. entity.name)
    entity.die()
  end

  -- Set the tile to water
  surface.set_tiles({{name="water", position=position}})

  -- Destory all remnants on the tile that might have been created by the die function earlier
  remnants = surface.find_entities_filtered{
    position = position,
    type = "corpse"
  }
  for _, entity in pairs(remnants) do
    -- game.print("remnant destroyed: " .. entity.name)
    entity.destroy()
  end
end

function recursive_create_water(surface, center)
  set_water(surface, {center.x, center.y})

  -- If a neighbouring tile is dug, register it for a delayed transition into water
  local surrounding = {
    {x = center.x - 1, y = center.y},
    {x = center.x + 1, y = center.y},
    {x = center.x, y = center.y - 1},
    {x = center.x, y = center.y + 1}
  }

  for _, pos in ipairs(surrounding) do
    tile = surface.get_tile(pos.x, pos.y)
    if tile.name == dug_tile_name then
      -- TODO a single tile can be registered by multiple neighbours causing the set_water function to be called multiple
      -- times at possibly different moments.
      register_delayed_transition(game.tick, surface, pos)
    end
  end
end

function register_delayed_transition(current_tick, surface, position, mult)
  -- Register a mined out tile to transition into a water tile after a short random delay.
  if delay == nil then
    mult = math.random(1, 6)
    tick = last_nth_tick + check_interval * mult
  elseif delay <= 0 then
    -- Delay has to be at least 1 tick out, so execute it on the next check
    tick = last_nth_tick + check_interval
  else
    tick = last_nth_tick + check_interval * mult 
  end
  
  -- tick = current_tick + delay

  if global.dug_to_water[tick] == nil then
    global.dug_to_water[tick] = {}
  end

  table.insert(global.dug_to_water[tick], {surface=surface, position=position})
end

function marker_depleted_event(event)
  if event.entity.name ~= "rsc-canal-marker" then
    return
  end
  
  local position = event.entity.position
  local surface = event.entity.surface

  if is_any_neighbour_named(surface, position, water_tile_names) then
    register_delayed_transition(event.tick, surface, position, 1)
  else
    surface.set_tiles({
      {name=dug_tile_name, position={position.x, position.y}},
    })
  end
end

function find_entities_in_radius(centerTile, radius, surface, name)
  -- Calculate the center position by adding 0.5 to both x and y
  local centerX = centerTile.position.x + 0.5
  local centerY = centerTile.position.y + 0.5
  
  -- Calculate the bounding box based on the center position and radius
  local left = centerX - radius
  local top = centerY - radius
  local right = centerX + radius
  local bottom = centerY + radius
  
  -- game.print(centerTile.position.x .. ", " .. centerTile.position.y .. " | radius: " .. radius)
  -- game.print("(" .. left .. ", " .. top .. "), (" .. right .. ", " .. bottom .. ")")

  -- Create the bounding box table
  local boundingBox = { left_top = { x = left, y = top }, right_bottom = { x = right, y = bottom } }
  
  highlight_bbox(surface, left, right, top, bottom)
  return surface.find_entities_filtered{area = boundingBox, name = name}
end

function get_conflicting_entities(surface, position)
  return surface.find_entities_filtered{
    position = position,
    name = {"canal-excavator", "rsc-canal-marker"},
    invert = true
  }
end

function place_tile_event(event)
  if event.item.name ~= "item-canal-marker" then
    return
  end
  
  radius = game.entity_prototypes["canal-excavator"].mining_drill_radius - 0.5
  surface = game.surfaces[event.surface_index]
  if event.player_index == nil then
    force = event.robot.force
  else
    force = game.get_player(event.player_index).force
  end

  for _, tile in ipairs(event.tiles) do
    -- For every placed tile, place a canal marker entity.

    entity = surface.create_entity{name="rsc-canal-marker", position=tile.position}
    entity.amount = get_ore_amount(tile.position)

    -- Wake-up idle excavators
    -- TODO a single excavator might be called multiple times with patch size >1. Can be optimized.
    excavators = find_entities_in_radius(tile, radius, surface, "canal-excavator")
    for _, excavator in ipairs(excavators) do
      -- game.print("Waking up excavator")
      excavator.active = true
    end

    -- Mark entities on tile for deconstruction
    non_excavators = get_conflicting_entities(surface, {tile.position.x + 0.5, tile.position.y + 0.5})
    for _, ent in pairs(non_excavators) do
      -- game.print(ent.name)
      ent.order_deconstruction(force)
    end
  end
end


function get_ore_amount(position)
  -- Retrieve the stored remaining_ore value or the starting amount if is a new tile
  idx_x = math.floor(position.x)
  idx_y = math.floor(position.y)

  if global.remaining_ore[idx_x] == nil or global.remaining_ore[idx_x][idx_y] == nil then
    return ore_starting_amount
  end
  return pop_remaining_ore(idx_x, idx_y)
end

function pop_remaining_ore(idx_x, idx_y)
  -- Retrieve the stored remaining_ore value and set index to nil
  amount = global.remaining_ore[idx_x][idx_y]
  -- game.print("Found existing amount: " .. amount)
  global.remaining_ore[idx_x][idx_y] = nil
  return amount
end

function insert_remaining_ore(position, amount)
  -- If an ore tile is removed, add the remaining amount to the global.remaining_ore table
  idx_x = math.floor(position.x)
  idx_y = math.floor(position.y)    

  -- game.print("Setting (" .. idx_x .. ", " .. idx_y .. ") to " .. amount)
  if global.remaining_ore[idx_x] == nil then
    global.remaining_ore[idx_x] = {}
  end

  if global.remaining_ore[idx_x][idx_y] ~= nil then
    game.print("Overwriting existing value. This shouldn't be happening")
  end

  global.remaining_ore[idx_x][idx_y] = amount
end

function tile_mined_event(event)
  surface = game.surfaces[event.surface_index]
  for _, tile in ipairs(event.tiles) do
    if tile.old_tile.name == "tile-canal-marker" then
      entities = surface.find_entities_filtered{
        position = {x = tile.position.x + 0.5, y = tile.position.y + 0.5},
        name = "rsc-canal-marker"
      }

      --game.print("tile mined")
      for _, entity in pairs(entities) do
        -- TODO all entities are at the same pos so in the case of multiple entities they overwrite eachother
        -- Does that ever happen? Will trigger print in insert function.
        if entity.amount < ore_starting_amount then
          insert_remaining_ore(tile.position, entity.amount)
        end
        entity.destroy()
      end
    end
  end
end

function disable_rotation_event(event)
  event.created_entity.rotatable = false
end

-- event.on_tick(function(e)
--   -- game.print("Does this fire?")
--   if global.dug_to_water[e.tick] ~= nil then
--     -- game.print("transitioning")
--     for _, transition in ipairs(global.dug_to_water[e.tick]) do
--       -- game.print("position " .. transition.position.x .. ", " .. transition.position.y)
--       recursive_create_water(transition.surface, transition.position)
--     end
--     global.dug_to_water[e.tick] = nil
--   end
-- end)


function each_second_event(event)
  -- game.print("check " .. event.tick .. " | " .. event.nth_tick)
  last_nth_tick = event.tick

  if global.dug_to_water[event.tick] ~= nil then
    -- game.print("transitioning")
    for _, transition in ipairs(global.dug_to_water[event.tick]) do
      -- game.print("position " .. transition.position.x .. ", " .. transition.position.y)
      recursive_create_water(transition.surface, transition.position)
    end
    global.dug_to_water[event.tick] = nil
  end
end

-- script.on_event(defines.events.on_built_entity, register_marker, {{filter="type", type="resource"}})
-- script.on_event(defines.events.on_entity_destroyed, change_marker_to_water) -- TODO: on_resource_depleted? https://lua-api.factorio.com/latest/events.html#on_resource_depleted
script.on_event(defines.events.on_resource_depleted, marker_depleted_event)
script.on_event(defines.events.on_player_built_tile, place_tile_event)
script.on_event(defines.events.on_robot_built_tile, place_tile_event)
script.on_event(defines.events.on_player_mined_tile, tile_mined_event)
script.on_event(defines.events.on_robot_mined_tile, tile_mined_event)

script.on_event(defines.events.on_built_entity, disable_rotation_event, {{filter="name", name="canal-excavator"}})
script.on_nth_tick(check_interval, each_second_event)

