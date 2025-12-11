local TimeManager = {}
TimeManager.__index = TimeManager

function TimeManager.new()
    local self = setmetatable({}, TimeManager)
    return self
end

function TimeManager:getFormattedTime()
    return os.date("%H:%M:%S")
end

return TimeManager
