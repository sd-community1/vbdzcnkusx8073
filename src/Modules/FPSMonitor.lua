local RunService = game:GetService("RunService")

local FPSMonitor = {}
FPSMonitor.__index = FPSMonitor

function FPSMonitor.new()
    local self = setmetatable({}, FPSMonitor)
    
    self.LastTime = tick()
    self.FrameCount = 0
    self.CurrentFPS = 60
    self.Samples = {}
    self.MaxSamples = 60
    
    return self
end

function FPSMonitor:GetFPS()
    self.FrameCount += 1
    
    local currentTime = tick()
    local elapsed = currentTime - self.LastTime
    
    if elapsed >= 1 then
        self.CurrentFPS = math.floor(self.FrameCount / elapsed)
        self.FrameCount = 0
        self.LastTime = currentTime
        
        -- تخزين العينات للمتوسط المتحرك
        table.insert(self.Samples, self.CurrentFPS)
        if #self.Samples > self.MaxSamples then
            table.remove(self.Samples, 1)
        end
    end
    
    return self:GetSmoothedFPS()
end

function FPSMonitor:GetSmoothedFPS()
    if #self.Samples == 0 then
        return self.CurrentFPS
    end
    
    local sum = 0
    for _, fps in ipairs(self.Samples) do
        sum += fps
    end
    
    return math.floor(sum / #self.Samples)
end

function FPSMonitor:GetMinFPS()
    local min = math.huge
    for _, fps in ipairs(self.Samples) do
        if fps < min then
            min = fps
        end
    end
    return min ~= math.huge and min or self.CurrentFPS
end

function FPSMonitor:GetMaxFPS()
    local max = 0
    for _, fps in ipairs(self.Samples) do
        if fps > max then
            max = fps
        end
    end
    return max > 0 and max or self.CurrentFPS
end

return FPSMonitor
