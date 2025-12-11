-- ============================================
-- 🎮 Beautiful HUD Configuration
-- ⚙️ ملف الإعدادات الرئيسي
-- ✨ بواسطة: sd-community1
-- ============================================

local Config = {}

-- ============================================
-- 🎨 إعدادات التصميم
-- ============================================
Config.Design = {
    -- الثيمات المتاحة
    Themes = {
        "Dark",     -- ثيم داكن
        "Light",    -- ثيم فاتح
        "Neon",     -- ثيم نيون
        "Cyberpunk" -- ثيم سيبربانك
    },
    
    -- الألوان الأساسية لكل ثيم
    ThemeColors = {
        Dark = {
            background = Color3.fromRGB(20, 20, 30),
            surface = Color3.fromRGB(30, 30, 45),
            primary = Color3.fromRGB(100, 150, 255),
            secondary = Color3.fromRGB(70, 70, 90),
            text = Color3.fromRGB(240, 240, 240),
            textSecondary = Color3.fromRGB(180, 180, 200),
            success = Color3.fromRGB(100, 255, 100),
            warning = Color3.fromRGB(255, 200, 100),
            error = Color3.fromRGB(255, 100, 100)
        },
        
        Light = {
            background = Color3.fromRGB(245, 245, 250),
            surface = Color3.fromRGB(255, 255, 255),
            primary = Color3.fromRGB(80, 120, 200),
            secondary = Color3.fromRGB(230, 230, 240),
            text = Color3.fromRGB(30, 30, 40),
            textSecondary = Color3.fromRGB(100, 100, 120),
            success = Color3.fromRGB(80, 200, 80),
            warning = Color3.fromRGB(220, 170, 80),
            error = Color3.fromRGB(220, 80, 80)
        },
        
        Neon = {
            background = Color3.fromRGB(10, 10, 20),
            surface = Color3.fromRGB(20, 10, 40),
            primary = Color3.fromRGB(255, 0, 255),
            secondary = Color3.fromRGB(0, 255, 255),
            text = Color3.fromRGB(255, 255, 255),
            textSecondary = Color3.fromRGB(200, 200, 255),
            success = Color3.fromRGB(0, 255, 150),
            warning = Color3.fromRGB(255, 255, 0),
            error = Color3.fromRGB(255, 50, 50)
        },
        
        Cyberpunk = {
            background = Color3.fromRGB(15, 10, 25),
            surface = Color3.fromRGB(25, 15, 40),
            primary = Color3.fromRGB(255, 20, 100),
            secondary = Color3.fromRGB(20, 255, 200),
            text = Color3.fromRGB(255, 255, 220),
            textSecondary = Color3.fromRGB(200, 180, 255),
            success = Color3.fromRGB(100, 255, 100),
            warning = Color3.fromRGB(255, 150, 50),
            error = Color3.fromRGB(255, 50, 100)
        }
    },
    
    -- أبعاد الـ HUD
    Sizes = {
        Small = {width = 250, height = 320},
        Medium = {width = 280, height = 350},
        Large = {width = 320, height = 400},
        Custom = {width = 280, height = 350} -- الافتراضي
    },
    
    -- أماكن العرض
    Positions = {
        "TopLeft",
        "TopRight",
        "BottomLeft", 
        "BottomRight",
        "Center"
    },
    
    -- الشفافية
    Transparency = {
        min = 0.05,   -- أقل شفافية
        max = 0.5,    -- أعلى شفافية
        default = 0.15 -- الافتراضي
    },
    
    -- زوايا مستديرة
    CornerRadius = {
        small = 8,
        medium = 12,
        large = 16,
        default = 12
    }
}

-- ============================================
-- 📊 إعدادات المعلومات المعروضة
-- ============================================
Config.Modules = {
    FPS = {
        enabled = true,
        updateInterval = 0.5, -- تحديث كل نصف ثانية
        showGraph = false,    -- عرض رسم بياني (مستقبلاً)
        colorBased = true,    -- تغيير اللون حسب القيمة
        thresholds = {
            good = 60,    -- FPS ≥ 60: أخضر
            medium = 30,  -- FPS ≥ 30: أصفر
            low = 0       -- FPS < 30: أحمر
        }
    },
    
    Time = {
        enabled = true,
        format = "24h", -- أو "12h"
        showSeconds = true,
        showDate = false,
        updateInterval = 1 -- تحديث كل ثانية
    },
    
    Players = {
        enabled = true,
        showCount = true,
        showList = true,
        maxVisible = 6,      -- أقصى لاعبين في القائمة
        showAvatars = false, -- عرض الصور (مستقبلاً)
        updateInterval = 3   -- تحديث كل 3 ثواني
    },
    
    System = {
        showPing = false,    -- عرض البينج
        showMemory = false,  -- عرض استخدام الذاكرة
        showCPU = false      -- عرض استخدام المعالج
    }
}

-- ============================================
-- 🎮 إعدادات التحكم
-- ============================================
Config.Controls = {
    ToggleKey = Enum.KeyCode.F8,
    HideKey = Enum.KeyCode.F9,
    ResizeKey = Enum.KeyCode.F10,
    
    -- قابلية السحب
    Draggable = true,
    DragOnlyFromHeader = true,
    
    -- الإختصارات
    Shortcuts = {
        ChangeTheme = Enum.KeyCode.T,
        ToggleTransparency = Enum.KeyCode.R,
        TogglePosition = Enum.KeyCode.P
    }
}

-- ============================================
-- ⚡ إعدادات الأداء
-- ============================================
Config.Performance = {
    -- تحسينات الأداء
    Optimize = {
        useDebounce = true,
        limitUpdates = true,
        cacheResults = true,
        cleanupOldData = true
    },
    
    -- حدود التحديث
    UpdateLimits = {
        maxFPSUpdates = 60,   -- أقصى تحديثات FPS في الثانية
        maxPlayerUpdates = 10, -- أقصى تحديثات اللاعبين في الثانية
        maxTimeUpdates = 1    -- أقصى تحديثات الوقت في الثانية
    },
    
    -- إدارة الذاكرة
    Memory = {
        maxPlayerCache = 50,  -- أقصى لاعبين في الكاش
        clearCacheInterval = 30, -- تنظيف الكاش كل 30 ثانية
        autoCleanup = true
    }
}

-- ============================================
-- 🔧 إعدادات المطور
-- ============================================
Config.Developer = {
    DebugMode = false,      -- وضع التصحيح
    ShowLogs = false,       -- عرض السجلات
    VerboseErrors = true,   -- أخطاء مفصلة
    
    -- روابط GitHub
    GitHub = {
        repository = "https://github.com/sd-community1/vbdzcnkusx8073",
        rawBase = "https://raw.githubusercontent.com/sd-community1/vbdzcnkusx8073/main",
        issues = "https://github.com/sd-community1/vbdzcnkusx8073/issues"
    },
    
    -- معلومات النسخة
    Version = {
        major = 1,
        minor = 0,
        patch = 0,
        build = "20241211",
        codename = "Aurora"
    }
}

-- ============================================
-- 🌍 إعدادات اللغة
-- ============================================
Config.Language = {
    default = "ar", -- اللغة الافتراضية (ar, en)
    
    strings = {
        ar = {
            title = "🎮 Beautiful HUD",
            fps = "FPS",
            time = "الوقت",
            players = "اللاعبين",
            ping = "البينج",
            playersTitle = "👥 اللاعبين الموجودين",
            loading = "جاري التحميل...",
            loaded = "تم التحميل بنجاح!",
            pressToToggle = "اضغط F8 للإظهار/الإخفاء",
            playerJoined = "انضم لاعب",
            playerLeft = "غادر لاعب"
        },
        
        en = {
            title = "🎮 Beautiful HUD",
            fps = "FPS",
            time = "Time",
            players = "Players",
            ping = "Ping",
            playersTitle = "👥 Online Players",
            loading = "Loading...",
            loaded = "Successfully loaded!",
            pressToToggle = "Press F8 to toggle",
            playerJoined = "Player joined",
            playerLeft = "Player left"
        }
    }
}

-- ============================================
-- 🔧 دوال المساعدة
-- ============================================

-- الحصول على الإعدادات الافتراضية
function Config.GetDefault()
    return {
        theme = "Dark",
        position = "TopRight",
        size = "Medium",
        transparency = Config.Design.Transparency.default,
        
        modules = {
            fps = Config.Modules.FPS.enabled,
            time = Config.Modules.Time.enabled,
            players = Config.Modules.Players.enabled,
            system = Config.Modules.System.showPing
        },
        
        controls = {
            toggleKey = Config.Controls.ToggleKey,
            draggable = Config.Controls.Draggable
        }
    }
end

-- التحقق من صحة الإعدادات
function Config.Validate(settings)
    local validated = {}
    
    -- التحقق من الثيم
    validated.theme = table.find(Config.Design.Themes, settings.theme) 
        and settings.theme 
        or "Dark"
    
    -- التحقق من الموقع
    validated.position = table.find(Config.Design.Positions, settings.position)
        and settings.position
        or "TopRight"
    
    -- التحقق من الشفافية
    validated.transparency = math.clamp(
        settings.transparency or Config.Design.Transparency.default,
        Config.Design.Transparency.min,
        Config.Design.Transparency.max
    )
    
    -- التحقق من الموديولات
    validated.modules = {
        fps = type(settings.modules) == "table" and (settings.modules.fps ~= false),
        time = type(settings.modules) == "table" and (settings.modules.time ~= false),
        players = type(settings.modules) == "table" and (settings.modules.players ~= false),
        system = type(settings.modules) == "table" and (settings.modules.system == true)
    }
    
    -- التحقق من الأحجام
    if settings.size and Config.Design.Sizes[settings.size] then
        validated.width = Config.Design.Sizes[settings.size].width
        validated.height = Config.Design.Sizes[settings.size].height
    else
        validated.width = Config.Design.Sizes.Custom.width
        validated.height = Config.Design.Sizes.Custom.height
    end
    
    -- التحقق من أزرار التحكم
    validated.controls = {
        toggleKey = settings.controls and settings.controls.toggleKey 
            and typeof(settings.controls.toggleKey) == "EnumItem"
            and settings.controls.toggleKey
            or Config.Controls.ToggleKey,
            
        draggable = settings.controls and settings.controls.draggable ~= nil
            and settings.controls.draggable
            or Config.Controls.Draggable
    }
    
    return validated
end

-- الحصول على معلومات النسخة
function Config.GetVersion()
    local v = Config.Developer.Version
    return string.format("%d.%d.%d", v.major, v.minor, v.patch)
end

-- الحصول على سلسلة نصية بلغة محددة
function Config.GetString(key, lang)
    lang = lang or Config.Language.default
    return Config.Language.strings[lang][key] or key
end

return Config
