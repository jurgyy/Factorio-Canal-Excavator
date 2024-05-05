local function entity_destroyed_event(event)
    if global.resources[event.registration_number] ~= nil then
      global.resources[event.registration_number] = nil
    end
end

return entity_destroyed_event