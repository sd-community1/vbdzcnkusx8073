local PlayerTracker = {}
PlayerTracker.__index = PlayerTracker

function PlayerTracker.new()
    local self = setmetatable({}, PlayerTracker)
    self.players = {}
    return self
end

function PlayerTracker:getPlayerList()
    -- كود تتبع اللاعبين
end

return PlayerTracker
