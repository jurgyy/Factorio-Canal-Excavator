local registered = {}

---@param configs table<string, CanexPlanetConfig|CanexPlanetOverwriteConfig>
local function validate_configs(configs)
    for name, config in pairs(configs) do
        local error_template = "Missing required field in CanexPlanetConfig for "  .. name .. ": "
        if not registered[name] then
            if not config.mineResult then error(error_template .. "mineResult") end
            if not config.oreStartingAmount then error(error_template .. "oreStartingAmount") end
            if not config.tint then error(error_template .. "tint") end
        end
    end
end

local prefix = require("settings.configSettingsPrefix")

---Register your CanexPlanetConfig configurations by referencing a file that returns an array of them.
---Validates your file when called:
---If you are registering a new planet, all non-nullable fields require a value.
---If you are modifying Vanilla or other already registered configs all fields are nullable.
---@param modname string Your mod name without leading and trailing underscores. Example: "canal-excavator"
---@param filepath string Filepath without extension. Example "interface.canal-excavator.canex-config"
function canex_settings_register_config_file(modname, filepath)
    local fullpath = "__" .. modname .. "__." .. filepath

    ---@type table<string, CanexPlanetConfig|CanexPlanetOverwriteConfig>
    local configs = require(fullpath)
    --validate_configs(configs)
    local setting = {
        type = "string-setting",
        name = prefix .. modname,
        setting_type = "startup",
        default_value = fullpath,
        hidden = true,
    }
    data:extend{setting}
end