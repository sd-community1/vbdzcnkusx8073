-- Example_Basic.lua
-- مثال الاستخدام الأساسي لـ Beautiful HUD
-- رابط RAW: https://raw.githubusercontent.com/sd-community1/vbdzcnkusx8073/main/examples/Example_Basic.lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

print("🎮 Beautiful HUD - المثال الأساسي")
print("📦 جاري التحميل...")

-- ============================================
-- 1. تحميل الـ HUD
-- ============================================
local LOADER_URL = "https://raw.githubusercontent.com/sd-community1/vbdzcnkusx8073/main/loader.lua"

local function LoadHUD()
    local success, result = pcall(function()
        return loadstring(game:HttpGet(LOADER_URL))()
    end)
    
    if success then
        print("✅ تم تحميل المكتبة بنجاح")
        return result
    else
        warn("❌ فشل التحميل:", result)
        return nil
    end
end

-- ============================================
-- 2. تهيئة الـ HUD
-- ============================================
local BeautifulHUD = LoadHUD()

if not BeautifulHUD then
    -- محاولة بديلة (تحميل المكونات مباشرة)
    print("🔄 جرب تحميل المكونات مباشرة...")
    
    local function LoadModule(modulePath)
        local url = "https://raw.githubusercontent.com/sd-community1/vbdzcnkusx8073/main/" .. modulePath
        local success, module = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)
        return success and module
    end
    
    -- يمكنك تحميل المكونات هنا إذا فشل الـ loader
else
    -- ============================================
    -- 3. تشغيل الـ HUD مع إعدادات بسيطة
    -- ============================================
    local myHUD = BeautifulHUD:Init({
        -- الإعدادات الأساسية
        theme = "Dark",                -- Dark, Light, Neon
        position = "TopRight",         -- TopLeft, TopRight, BottomLeft, BottomRight
        
        -- المعلومات المطلوبة
        showFPS = true,               -- عرض عدد الفريمات
        showTime = true,              -- عرض الوقت
        showPlayers = true,           -- عرض اللاعبين
        showPing = false,             -- عرض البينج (إختياري)
        
        -- التصميم
        transparency = 0.15,          -- شفافية الخلفية (0-1)
        fontSize = 14,                -- حجم الخط
        width = 250,                  -- عرض الـ HUD
        height = 300,                 -- ارتفاع الـ HUD
        
        -- اللاعبين
        maxPlayers = 8,               -- أقصى عدد لاعبين يعرض
        showAvatars = true,           -- عرض صور البروفايل
        
        -- التحكم
        draggable = true,             -- قابلية السحب
        toggleKey = Enum.KeyCode.F8,  -- زر إظهار/إخفاء
        hideOnStart = false           -- إخفاء عند البدء
    })
    
    print("✨ تم تشغيل Beautiful HUD!")
    print("🎯 اضغط F8 لإظهار/إخفاء الـ HUD")
    
    -- ============================================
    -- 4. أحداث إضافية (اختياري)
    -- ============================================
    
    -- حدث عند تغيير الـ FPS
    if myHUD.OnFPSChange then
        myHUD.OnFPSChange:Connect(function(fps)
            if fps < 30 then
                -- يمكنك إضافة تنبيه عند انخفاض الـ FPS
                print("⚠️ تحذير: FPS منخفض (" .. fps .. ")")
            end
        end)
    end
    
    -- حدث عند دخول لاعب جديد
    if myHUD.OnPlayerJoined then
        myHUD.OnPlayerJoined:Connect(function(playerName)
            print("🎮 لاعب انضم: " .. playerName)
        end)
    end
    
    -- حدث عند خروج لاعب
    if myHUD.OnPlayerLeft then
        myHUD.OnPlayerLeft:Connect(function(playerName)
            print("🚪 لاعب غادر: " .. playerName)
        end)
    end
    
    -- ============================================
    -- 5. وظائف مساعدة
    -- ============================================
    
    -- وظيفة لتغيير الثيم أثناء اللعب
    local function ChangeTheme(themeName)
        if myHUD.SetTheme then
            myHUD:SetTheme(themeName)
            print("🎨 تم تغيير الثيم إلى: " .. themeName)
        end
    end
    
    -- وظيفة لتحديث إعدادات معينة
    local function UpdateSettings(newSettings)
        if myHUD.UpdateSettings then
            myHUD:UpdateSettings(newSettings)
            print("⚙️ تم تحديث الإعدادات")
        end
    end
    
    -- ============================================
    -- 6. مثال: تغيير الثيم حسب الوقت
    -- ============================================
    
    -- الحصول على الوقت الحالي
    local function GetHour()
        return os.date("*t").hour
    end
    
    -- تغيير الثيم تلقائياً حسب الوقت
    RunService.Heartbeat:Connect(function()
        local hour = GetHour()
        
        -- ثيم داكن في الليل
        if hour >= 18 or hour <= 6 then
            if myHUD.GetCurrentTheme and myHUD.GetCurrentTheme() ~= "Dark" then
                ChangeTheme("Dark")
            end
        -- ثيم فاتح في النهار
        else
            if myHUD.GetCurrentTheme and myHUD.GetCurrentTheme() ~= "Light" then
                ChangeTheme("Light")
            end
        end
    end)
    
    -- ============================================
    -- 7. إرجاع كائن الـ HUD للاستخدام الخارجي
    -- ============================================
    return myHUD
end

-- ملاحظة: إذا كنت تريد تشغيل هذا الملف مباشرة
if script:IsA("LocalScript") then
    print("📝 هذا الملف جاهز للتنفيذ!")
end
