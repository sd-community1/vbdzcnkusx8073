-- ============================================
-- 🎮 Beautiful HUD Loader
-- 📥 محمل الملفات الرئيسي
-- ✨ بواسطة: sd-community1
-- 🔗 GitHub: https://github.com/sd-community1/vbdzcnkusx8073
-- ============================================

--[[
    📝 كيفية الاستخدام:
    --------------------------------------------------
    -- الطريقة البسيطة:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/sd-community1/vbdzcnkusx8073/main/loader.lua"))()
    
    -- مع إعدادات مخصصة:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/sd-community1/vbdzcnkusx8073/main/loader.lua"))():Init({
        theme = "Neon",
        position = "TopLeft",
        showFPS = true,
        showTime = true,
        showPlayers = true
    })
]]--

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- ============================================
-- 🔧 المتغيرات العامة
-- ============================================
local BeautifulHUD = {}
BeautifulHUD.__index = BeautifulHUD

-- روابط GitHub
local REPO_URL = "https://github.com/sd-community1/vbdzcnkusx8073"
local RAW_BASE = "https://raw.githubusercontent.com/sd-community1/vbdzcnkusx8073/main"

-- ============================================
-- 📦 دالة تحميل الملفات
-- ============================================
local function LoadModule(modulePath)
    local url = RAW_BASE .. "/" .. modulePath
    
    local success, result = pcall(function()
        local content = game:HttpGet(url, true)
        if not content or content == "" then
            error("الملف فارغ: " .. modulePath)
        end
        return loadstring(content)()
    end)
    
    if not success then
        warn("[BeautifulHUD] ❌ فشل تحميل: " .. modulePath)
        warn("الخطأ: " .. tostring(result))
        return nil
    end
    
    print("[BeautifulHUD] ✅ تم تحميل: " .. modulePath)
    return result
end

-- ============================================
-- 📁 قائمة الملفات المطلوبة
-- ============================================
local REQUIRED_FILES = {
    -- ملفات الإعدادات
    {"config.lua", "الإعدادات الرئيسية"},
    
    -- ملفات الموديولات
    {"src/Modules/FPSMonitor.lua", "عداد الفريمات"},
    {"src/Modules/PlayerTracker.lua", "متعقب اللاعبين"},
    {"src/Modules/TimeManager.lua", "مدير الوقت"},
    
    -- ملفات الواجهة
    {"src/UI/Elements/Panel.lua", "اللوحة الرئيسية"},
    {"src/UI/UIManager.lua", "مدير الواجهة"},
    
    -- ملفات الأدوات
    {"src/Utils/Animation.lua", "مكتبة الحركات"},
    {"src/Utils/Urls.lua", "إدارة الروابط"},
    {"src/Utils/ColorUtils.lua", "أدوات الألوان"}
}

-- الملفات الاختيارية
local OPTIONAL_FILES = {
    {"src/UI/Themes/DarkTheme.lua", "الثيم الداكن"},
    {"src/UI/Themes/LightTheme.lua", "الثيم الفاتح"},
    {"src/UI/Themes/NeonTheme.lua", "الثيم النيون"},
    {"examples/Example_Basic.lua", "مثال الاستخدام"},
    {"CHANGELOG.md", "سجل التغييرات"}
}

-- ============================================
-- 🚀 دالة التحميل الرئيسية
-- ============================================
function BeautifulHUD:LoadAllModules()
    print("========================================")
    print("🎮 Beautiful HUD - جاري التحميل...")
    print("📦 بواسطة: sd-community1")
    print("🔗 " .. REPO_URL)
    print("========================================")
    
    local loadedModules = {}
    local failedModules = {}
    
    -- تحميل الملفات المطلوبة
    for _, fileInfo in ipairs(REQUIRED_FILES) do
        local path, name = fileInfo[1], fileInfo[2]
        local module = LoadModule(path)
        
        if module then
            loadedModules[path] = module
            print("✅ " .. name .. " - جاهز")
        else
            table.insert(failedModules, path)
            print("❌ " .. name .. " - فشل التحميل")
        end
        
        -- تأخير بسيط بين الملفات
        RunService.Heartbeat:Wait()
    end
    
    -- تحميل الملفات الاختيارية
    for _, fileInfo in ipairs(OPTIONAL_FILES) do
        local path, name = fileInfo[1], fileInfo[2]
        local module = LoadModule(path)
        
        if module then
            loadedModules[path] = module
            print("✨ " .. name .. " - جاهز (اختياري)")
        end
        
        RunService.Heartbeat:Wait()
    end
    
    -- عرض النتائج
    print("========================================")
    print("📊 نتائج التحميل:")
    print("✅ الملفات المحملة: " .. #REQUIRED_FILES - #failedModules .. "/" .. #REQUIRED_FILES)
    
    if #failedModules > 0 then
        print("❌ الملفات الفاشلة:")
        for _, path in ipairs(failedModules) do
            print("   - " .. path)
        end
        
        if #failedModules >= 3 then
            warn("[BeautifulHUD] ⚠️ العديد من الملفات فشلت في التحميل!")
            warn("قد لا يعمل HUD بشكل صحيح.")
        end
    end
    
    return loadedModules
end

-- ============================================
-- 🎯 دالة التهيئة
-- ============================================
function BeautifulHUD:Init(userConfig)
    print("🎯 جاري تهيئة Beautiful HUD...")
    
    -- انتظار تحميل اللاعب
    if not Players.LocalPlayer then
        print("⏳ في انتظار تحميل اللاعب...")
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    end
    
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    print("✅ اللاعب جاهز: " .. Players.LocalPlayer.Name)
    
    -- تحميل جميع الموديولات
    local modules = self:LoadAllModules()
    
    -- التحقق من الملفات الأساسية
    if not modules["config.lua"] then
        error("❌ ملف الإعدادات مفقود! لا يمكن المتابعة.")
        return nil
    end
    
    if not modules["src/UI/Elements/Panel.lua"] then
        error("❌ لوحة الواجهة مفقودة! لا يمكن المتابعة.")
        return nil
    end
    
    -- دمج الإعدادات
    local config = modules["config.lua"]
    local defaultSettings = config.GetDefault()
    
    local finalConfig = {}
    if userConfig then
        -- التحقق من صحة الإعدادات
        finalConfig = config.Validate(userConfig)
    else
        finalConfig = defaultSettings
    end
    
    -- إنشاء نظام HUD
    local hudSystem = {}
    
    -- تهيئة الموديولات
    if modules["src/Modules/FPSMonitor.lua"] then
        hudSystem.FPSMonitor = modules["src/Modules/FPSMonitor.lua"].new()
        print("✅ FPS Monitor - جاهز")
    end
    
    if modules["src/Modules/TimeManager.lua"] then
        hudSystem.TimeManager = modules["src/Modules/TimeManager.lua"].new()
        print("✅ Time Manager - جاهز")
    end
    
    if modules["src/Modules/PlayerTracker.lua"] then
        hudSystem.PlayerTracker = modules["src/Modules/PlayerTracker.lua"].new()
        print("✅ Player Tracker - جاهز")
    end
    
    -- إنشاء الواجهة
    if modules["src/UI/Elements/Panel.lua"] then
        local Panel = modules["src/UI/Elements/Panel.lua"]
        hudSystem.Panel = Panel.new(finalConfig)
        
        if hudSystem.Panel.Create then
            hudSystem.Panel:Create()
            print("✅ Panel UI - تم إنشاؤها")
        end
    end
    
    -- دالة التحديث
    function hudSystem:Update()
        if self.FPSMonitor and self.Panel and self.Panel.UpdateFPS then
            local fps = self.FPSMonitor:update()
            self.Panel:UpdateFPS(fps)
        end
        
        if self.TimeManager and self.Panel and self.Panel.UpdateTime then
            local time = self.TimeManager:getFormattedTime()
            self.Panel:UpdateTime(time)
        end
        
        if self.PlayerTracker and self.Panel and self.Panel.UpdatePlayers then
            local players = self.PlayerTracker:getPlayerList()
            self.Panel:UpdatePlayers(players)
        end
    end
    
    -- دالة التدمير
    function hudSystem:Destroy()
        if self.Panel and self.Panel.Destroy then
            self.Panel:Destroy()
        end
        
        -- فصل جميع الروابط
        for key in pairs(self) do
            self[key] = nil
        end
        
        print("🗑️ تم تدمير Beautiful HUD")
    end
    
    -- بدء التحديثات التلقائية
    if finalConfig.modules.fps or finalConfig.modules.time or finalConfig.modules.players then
        local updateConnection
        updateConnection = RunService.RenderStepped:Connect(function()
            hudSystem:Update()
        end)
        
        -- إضافة التوصيلات للتنظيف لاحقاً
        hudSystem._connections = {
            update = updateConnection
        }
    end
    
    -- إشعار النجاح
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🎮 Beautiful HUD",
        Text = "تم التحميل بنجاح!\nاضغط " .. tostring(finalConfig.controls.toggleKey) .. " للتحكم",
        Duration = 6,
        Icon = "rbxassetid://4483345998"
    })
    
    print("========================================")
    print("✨ Beautiful HUD جاهز للاستخدام!")
    print("🎯 الإعدادات الحالية:")
    print("   • الثيم: " .. finalConfig.theme)
    print("   • الموقع: " .. finalConfig.position)
    print("   • FPS: " .. (finalConfig.modules.fps and "✅" or "❌"))
    print("   • الوقت: " .. (finalConfig.modules.time and "✅" or "❌"))
    print("   • اللاعبين: " .. (finalConfig.modules.players and "✅" or "❌"))
    print("🔧 اضغط " .. tostring(finalConfig.controls.toggleKey) .. " للإظهار/الإخفاء")
    print("========================================")
    
    -- حفظ في الذاكرة
    _G.BeautifulHUD = hudSystem
    _G.BeautifulHUD_Config = finalConfig
    
    return hudSystem
end

-- ============================================
-- 🔧 واجهة API بسيطة
-- ============================================
local PublicAPI = {
    -- تحميل سريع
    QuickLoad = function(config)
        local hud = BeautifulHUD:Init(config or {})
        return hud
    end,
    
    -- تحميل الملفات فقط
    LoadModules = function()
        return BeautifulHUD:LoadAllModules()
    end,
    
    -- الحصول على الإصدار
    GetVersion = function()
        local config = LoadModule("config.lua")
        if config then
            return config.GetVersion()
        end
        return "1.0.0"
    end,
    
    -- معلومات النظام
    Info = {
        Author = "sd-community1",
        Repository = REPO_URL,
        FilesLoaded = 0
    }
}

-- ============================================
-- 🚀 التحميل التلقائي عند تنفيذ الملف
-- ============================================
if not _G.BeautifulHUD_Loaded then
    _G.BeautifulHUD_Loaded = true
    
    -- عرض رسالة ترحيب
    print("\n" .. string.rep("=", 50))
    print("🎮 مرحباً بك في Beautiful HUD!")
    print("📦 استخدم: _G.BeautifulHUD.QuickLoad()")
    print("🔗 أو: loadstring(...)():Init(settings)")
    print(string.rep("=", 50) .. "\n")
    
    -- محاولة تحميل تلقائي إذا كان في بيئة Roblox
    if RunService:IsRunning() then
        task.spawn(function()
            task.wait(1) -- انتظار تحميل اللعبة
            print("🔄 جرب التحميل التلقائي...")
            local success, result = pcall(function()
                return PublicAPI.QuickLoad()
            end)
            
            if success and result then
                print("✅ التحميل التلقائي ناجح!")
            else
                print("ℹ️ استخدم التحميل اليدوي للإعدادات المخصصة")
            end
        end)
    end
end

-- إرجاع واجهة API
return PublicAPI
