require("prototypes.surfaceConfig")

require("prototypes.excavator.data")
require("prototypes.digable.data")
require("prototypes.dug.data")
require("prototypes.technology")

if mods["space-exploration"] then
  require("compatability.space-exploration.prototypes")
end