local entities_map = {}
local item_map = {}

local util = {}
---@type string[] List of excavator entity names
util.excavator_entity_names = {}
---@type string[] List of excavator item names
util.excavator_item_names = {}
util.max_mining_radius = 0

for _, mod_data in pairs(prototypes.mod_data) do
  if mod_data.data_type == "canex-excavator-config" then
    local data = mod_data.data

    table.insert(util.excavator_entity_names, data.entity_name)
    table.insert(util.excavator_item_names, data.item_name)

    entities_map[data.entity_name] = data
    item_map[data.item_name] = data

    local prototype = prototypes.entity[data.entity_name]
    if prototype.type ~= "mining-drill" then
      error("Excavator entity prototype of " .. data.entity_name .. " is not of type 'mining-drill' but " .. prototype.type)
    end
    if prototype.mining_drill_radius > util.max_mining_radius then
      util.max_mining_radius = prototype.mining_drill_radius
    end
  end
end

if util.max_mining_radius == 0 then
  error("No excavator prototypes found!")
end

---@param entity_name string
---@return boolean
util.is_excavator_entity = function(entity_name)
  return entities_map[entity_name] ~= nil
end

---@param item_name string
---@return boolean
util.is_excavator_item = function(item_name)
  return item_map[item_name] ~= nil
end

return util