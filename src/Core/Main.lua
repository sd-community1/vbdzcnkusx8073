local Main = {}
Main.__index = Main

function Main.new()
    local self = setmetatable({}, Main)
    return self
end

function Main:init()
    print("Beautiful HUD Initialized")
end

return Main
