require("prototypes.surfaceConfig")

require("prototypes.excavator.data")
require("prototypes.digable.data")
require("prototypes.dug.data")
require("prototypes.technology")
require("prototypes.tips-and-tricks.tips-and-tricks")

if mods["space-exploration"] then
  require("compatability.space-exploration.prototypes")
end