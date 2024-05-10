if settings.startup["no-tiles"].value then
    return {
        digable = "yellow-refined-concrete",
        dug = "brown-refined-concrete"
    }
end
return {
    digable = "tile-canal-marker",
    dug = "tile-dug"
}