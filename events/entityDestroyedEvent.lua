local function entity_destroyed_event(event)
    if storage.resources[event.registration_number] ~= nil then
      storage.resources[event.registration_number] = nil
    end
end

return entity_destroyed_event