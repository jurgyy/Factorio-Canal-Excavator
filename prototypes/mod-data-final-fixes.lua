local surface_config_helper = require("global.surfaceConfigHelper")
local surface_configs = surface_config_helper.get_all_surface_config()

local resourceTemplate = require("prototypes.digable.resourceTemplate")

---@param resource data.ResourceEntityPrototype
---@param config CanexSurfaceConfig|CanexSurfaceTemplate
local function handle_icons(resource, config)
  local icon_data = config.icon_data
  local icon_source_type = icon_data and icon_data.icon_source_type or (mods["space-age"] and "planet")
  local icon_source_name = icon_data and icon_data.icon_source_name or config.surfaceName
  local filename =  icon_data and icon_data.filename
  local icons = icon_data and icon_data.icons
  local icon_size = icon_data and icon_data.icon_size

  local icon_layers = {}
  if icon_source_type and icon_source_name or filename or icons then
    if filename then
      icon_layers[1] = {
        icon = filename,
      }
    elseif icons then
      icon_layers = icons
    else
      if not icon_source_type or not icon_source_name or not data.raw[icon_source_type] then
        error("Can't find icon for " .. (config.surfaceName or "template"))
      end
      local icon_source = data.raw[icon_source_type][icon_source_name]
      if icon_source then
        if icon_source.icons then
          icon_layers = icon_source.icons
        else
          icon_layers[1] = {
            icon = icon_source.icon,
          }
        end
      end
    end

    resource.icons[#icon_layers + 1] = resource.icons[1]
    ---@diagnostic disable-next-line: param-type-mismatch
    for i, icon in ipairs(icon_layers) do
      icon_size = icon_size or icon.icon_size or 64
      resource.icons[i] = icon
      resource.icons[i].icon_size = icon_size
      resource.icons[i].scale = 0.5 * (64 / icon_size)
      resource.icons[i].shift = {x = -16, y = -16}
      resource.icons[i].tint = icon.tint
    end
  end
end

---@param config CanexSurfaceConfig|CanexSurfaceTemplate
---@return data.ResourceEntityPrototype
local function create_resource_copy(config)
  local resource = table.deepcopy(resourceTemplate)
  resource.name = resource.name .. (config.surfaceName or config.name)
  local mineResultType = type(config.mineResult)
  if mineResultType == "table" then
    resource.minable.results = config.mineResult
  elseif mineResultType == "string" then
    resource.minable.results[1].name = config.mineResult --[[@as string]]
  else
    error("Unknown mineResult type '" .. mineResultType .. "' for canex config " .. (config.surfaceName or config.name))
  end
  resource.map_color = config.tint
  resource.mining_visualisation_tint = config.tint
  resource.stages.sheet.tint = config.tint
  resource.icons[1].tint = config.tint
  resource.minable.mining_time = config.mining_time or resource.minable.mining_time or 1
  local category = config.custom_resource_category

  if category then
    resource.category = category
    if not data.raw["resource-category"][category] then
      data:extend({
        {
          type = "resource-category",
          name = category
        }
      })
    end
  end

  handle_icons(resource, config)
  if config.localisation then
    local preposition = "entity-description.canex-on"
    if config.name then
      -- SurfaceTemplates
      preposition = "entity-description.canex-in"
    end
    resource.localised_name = {"entity-name.canex-rsc-digable-surface", {preposition, config.localisation}}
    resource.localised_description = {"entity-description.canex-rsc-digable-surface", {preposition, config.localisation}}
  end
  return resource
end

for _, surface_config in pairs(surface_configs) do
  log("Adding Canex config for surface " .. surface_config.surfaceName)
  data:extend({create_resource_copy(surface_config)})
end

for name, mod_data in pairs(data.raw["mod-data"]) do
  if mod_data.data_type == surface_config_helper.surface_template_data_type then
    ---@cast mod_data CanexSurfaceTemplateModData
    local template_config = mod_data.data
    data.raw["mod-data"][name].data.name = name
    data:extend({create_resource_copy(template_config)})

  elseif mod_data.data_type == "canex-excavator-config" then
    ---@cast mod_data CanexExcavatorConfigModData
    local config = mod_data.data
    local prototype = data.raw["mining-drill"][config.entity_name]
    if not prototype then
      error("No mining-drill prototype with name " .. config.entity_name)
    end

    if config.custom_resource_category then
      prototype.resource_categories = {config.custom_resource_category}
    end

    if not prototype.resource_categories then
      prototype.resource_categories = {"canex-rsc-cat-digable"}
    else
      local found = false
      for _, category in pairs(prototype.resource_categories) do
        if category == "canex-rsc-cat-digable" then
          found = true
          break
        end
      end
      if not found then
        table.insert(prototype.resource_categories, "canex-rsc-cat-digable")
      end
    end
  end
end