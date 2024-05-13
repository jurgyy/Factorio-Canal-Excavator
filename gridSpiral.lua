-- Lua implementation of the following Stack Overflow answer:
-- https://stackoverflow.com/questions/3706219/algorithm-for-iterating-over-an-outward-spiral-on-a-discrete-2d-grid-from-the-or/14010215#14010215
-- Modified to support an off-center position

local grid_spiral = {}
grid_spiral.__index = grid_spiral

function grid_spiral.new(centerX, centerY)
    local self = setmetatable({}, grid_spiral)
    self.layer = 1
    self.leg = 1
    self.x = 1
    self.y = 0
    self.centerX = centerX or 0
    self.centerY = centerY or 0
    return self
end

function grid_spiral:goNext()
    if self.leg == 0 then
        self.x = self.x + 1
        if self.x == self.layer then
            self.leg = self.leg + 1
        end
    elseif self.leg == 1 then
        self.y = self.y + 1
        if self.y == self.layer then
            self.leg = self.leg + 1
        end
    elseif self.leg == 2 then
        self.x = self.x - 1
        if -self.x == self.layer then
            self.leg = self.leg + 1
        end
    elseif self.leg == 3 then
        self.y = self.y - 1
        if -self.y == self.layer then
            self.leg = 0
            self.layer = self.layer + 1
        end
    end
end

function grid_spiral:Position()
    return {x = self.x + self.centerX, y = self.y + self.centerY}
end

return grid_spiral

-- Example usage:
-- local spiral = gridSpiral.new(5, 5)  -- Initialize with centerX = 5, centerY = 5
-- for i = 1, 25 do -- Perform 25 steps
--     local pos = spiral:Position()
--     print("Position: (" .. pos.x .. ", " .. pos.y .. ")")
--     spiral:goNext()
-- end
