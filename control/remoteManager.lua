---@type CanexSurfaceCreatedRemote[]
local remotes_cache = {}

---@return CanexSurfaceCreatedRemote[]
local function get_surface_created_remotes()
  local remotes = {}
  for _, prototype in pairs(prototypes.mod_data) do
    if prototype.data_type == "canex-surface-created-remote" then
      table.insert(remotes_cache, prototype.data)
    end
  end
  return remotes
end

get_surface_created_remotes()

local remote_manager = {}
remote_manager.surface_created_remotes = remotes_cache

return remote_manager