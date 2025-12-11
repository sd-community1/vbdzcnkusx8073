-- src/Utils/Urls.lua
local Urls = {}

Urls.BASE = "https://raw.githubusercontent.com/sd-community1/vbdzcnkusx8073/main"

-- جميع الملفات
Urls.FILES = {
    LOADER = Urls.BASE .. "/loader.lua",
    CONFIG = Urls.BASE .. "/config.lua",
    
    -- UI
    PANEL = Urls.BASE .. "/src/UI/Elements/Panel.lua",
    
    -- Modules
    FPS_MONITOR = Urls.BASE .. "/src/Modules/FPSMonitor.lua",
    PLAYER_TRACKER = Urls.BASE .. "/src/Modules/PlayerTracker.lua",
    TIME_MANAGER = Urls.BASE .. "/src/Modules/TimeManager.lua",
    
    -- Utils
    ANIMATION = Urls.BASE .. "/src/Utils/Animation.lua",
    COLOR_UTILS = Urls.BASE .. "/src/Utils/ColorUtils.lua"
}

-- دالة لتحميل أي موديول
function Urls.Load(moduleName)
    local url = Urls.FILES[moduleName:upper()] or Urls.BASE .. moduleName
    local success, module = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if not success then
        warn("❌ فشل تحميل:", moduleName, "\n", module)
        return nil
    end
    
    return module
end

return Urls
