if settings.startup["no-tiles"].value then
    return {
        digable = "yellow-refined-concrete",
        dug = "brown-refined-concrete"
    }
end
return {
    digable = "canex-digable",
    dug = "canex-tile-dug"
}