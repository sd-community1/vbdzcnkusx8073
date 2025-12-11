-- Roblox Beautiful HUD Loader
-- بواسطة [اسمك]

local HttpService = game:GetService("HttpService")
local BASE_URL = "https://raw.githubusercontent.com/username/Roblox-Beautiful-HUD/main/src/"

local function loadModule(modulePath)
    local success, result = pcall(function()
        return loadstring(HttpService:GetAsync(BASE_URL .. modulePath))()
    end)
    
    if not success then
        warn("فشل تحميل الموديول: " .. modulePath .. "\n" .. result)
        return nil
    end
    
    return result
end

-- تحميل المكونات الأساسية
local Settings = loadModule("Core/Settings.lua")
local UIManager = loadModule("UI/UIManager.lua")
local FPSMonitor = loadModule("Modules/FPSMonitor.lua")
local PlayerTracker = loadModule("Modules/PlayerTracker.lua")
local TimeManager = loadModule("Modules/TimeManager.lua")

-- إنشاء الـ HUD
local BeautifulHUD = {}

function BeautifulHUD:Init(options)
    -- دمج الإعدادات
    self.Settings = Settings.new(options or {})
    
    -- تهيئة المكونات
    self.UI = UIManager.new(self.Settings)
    self.FPS = FPSMonitor.new()
    self.Players = PlayerTracker.new()
    self.Time = TimeManager.new()
    
    -- بناء الواجهة
    self.UI:Build()
    
    -- بدء التحديثات
    self:StartUpdates()
    
    print("✅ تم تحميل Beautiful HUD بنجاح!")
    return self
end

function BeautifulHUD:StartUpdates()
    game:GetService("RunService").RenderStepped:Connect(function(dt)
        -- تحديث FPS
        local fps = self.FPS:GetFPS()
        self.UI:UpdateFPS(fps)
        
        -- تحديث الوقت
        local time = self.Time:GetFormattedTime()
        self.UI:UpdateTime(time)
        
        -- تحديث قائمة اللاعبين
        local players = self.Players:GetPlayerList()
        self.UI:UpdatePlayers(players)
    end)
end

return BeautifulHUD
