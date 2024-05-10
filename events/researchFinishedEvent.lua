local ore_manager = require("oreManager")

local function get_keys(t)
  local keys={}
  for key, _ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end

local function update_ores()
  -- Get all the keys before iterating so you don't modify the key list while iterating.
  local keys = get_keys(global.resources)
  
  for _, key in ipairs(keys) do
    local old_ore = global.resources[key]
    if old_ore.valid then

      local new_ore = ore_manager.create_ore(old_ore.surface, old_ore.position)
      new_ore.amount = old_ore.amount

      ore_manager.delete_ore(old_ore)
    end
  end
end

local function research_finished_event(event)
  if string.sub(event.research.name, 1, 20) == "mining-productivity-" then
    update_ores()
  end
end

return research_finished_event