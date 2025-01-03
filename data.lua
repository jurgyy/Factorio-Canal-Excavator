require("prototypes.globalFunctions")

require("prototypes.excavator.data")
require("prototypes.digable.data")
require("prototypes.dug.data")
require("prototypes.technology")

local planetConfigs = require("planetConfig")

for name, config in pairs(planetConfigs) do
    canex_register_planet_config(name, config)
end