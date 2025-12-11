-- ============================================
-- 🎨 Color Utilities Module
-- 🌈 أدوات ومعالجات الألوان
-- ✨ جزء من Beautiful HUD
-- ============================================

local ColorUtils = {}

-- ============================================
-- 🎯 تحويل الألوان
-- ============================================

-- تحويل Hex إلى RGB
function ColorUtils.hexToRGB(hex)
    hex = hex:gsub("#", "")
    
    if #hex == 3 then -- Short format #RGB
        hex = hex:gsub("(.)", "%1%1") -- Expand to #RRGGBB
    end
    
    if #hex ~= 6 then
        warn("[ColorUtils] ⚠️ تنسيق Hex غير صحيح:", hex)
        return Color3.new(1, 1, 1)
    end
    
    local success, r, g, b = pcall(function()
        return 
            tonumber("0x" .. hex:sub(1, 2)) / 255,
            tonumber("0x" .. hex:sub(3, 4)) / 255,
            tonumber("0x" .. hex:sub(5, 6)) / 255
    end)
    
    if success then
        return Color3.new(r, g, b)
    else
        warn("[ColorUtils] ❌ فشل تحويل Hex:", hex)
        return Color3.new(1, 1, 1)
    end
end

-- تحويل RGB إلى Hex
function ColorUtils.rgbToHex(color)
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    
    return string.format("#%02X%02X%02X", r, g, b)
end

-- تحويل HSV إلى RGB
function ColorUtils.hsvToRGB(h, s, v)
    h = h % 1
    s = math.clamp(s, 0, 1)
    v = math.clamp(v, 0, 1)
    
    local c = v * s
    local x = c * (1 - math.abs((h * 6) % 2 - 1))
    local m = v - c
    
    local r1, g1, b1
    
    if h < 1/6 then
        r1, g1, b1 = c, x, 0
    elseif h < 2/6 then
        r1, g1, b1 = x, c, 0
    elseif h < 3/6 then
        r1, g1, b1 = 0, c, x
    elseif h < 4/6 then
        r1, g1, b1 = 0, x, c
    elseif h < 5/6 then
        r1, g1, b1 = x, 0, c
    else
        r1, g1, b1 = c, 0, x
    end
    
    return Color3.new(r1 + m, g1 + m, b1 + m)
end

-- تحويل RGB إلى HSV
function ColorUtils.rgbToHSV(color)
    local r, g, b = color.R, color.G, color.B
    
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local delta = max - min
    
    local h, s, v
    
    -- الحصول على القيمة (Value)
    v = max
    
    -- الحصول على التشبع (Saturation)
    if max > 0 then
        s = delta / max
    else
        s = 0
    end
    
    -- الحصول على الصبغة (Hue)
    if delta > 0 then
        if max == r then
            h = (g - b) / delta
            if g < b then
                h = h + 6
            end
        elseif max == g then
            h = 2 + (b - r) / delta
        else -- max == b
            h = 4 + (r - g) / delta
        end
        h = h / 6
    else
        h = 0
    end
    
    return h, s, v
end

-- ============================================
-- 🎨 توليد الألوان
-- ============================================

-- توليد لون عشوائي
function ColorUtils.random()
    return Color3.new(
        math.random(),
        math.random(), 
        math.random()
    )
end

-- توليد لون عشوائي مريح للعين
function ColorUtils.randomPleasant()
    local h = math.random()
    local s = math.random(0.4, 0.8)
    local v = math.random(0.6, 0.9)
    
    return ColorUtils.hsvToRGB(h, s, v)
end

-- توليد لون بتدرج حسب النسبة
function ColorUtils.lerp(color1, color2, t)
    t = math.clamp(t, 0, 1)
    
    return Color3.new(
        color1.R + (color2.R - color1.R) * t,
        color1.G + (color2.G - color1.G) * t,
        color1.B + (color2.B - color1.B) * t
    )
end

-- لون قوس قزح متحرك
function ColorUtils.rainbow(t)
    return ColorUtils.hsvToRGB(t % 1, 0.8, 1)
end

-- توليد تدرج لوني
function ColorUtils.gradient(colors, t)
    t = math.clamp(t, 0, 1)
    
    if #colors == 1 then
        return colors[1]
    end
    
    local segment = 1 / (#colors - 1)
    local index = math.floor(t / segment) + 1
    index = math.min(index, #colors - 1)
    
    local localT = (t % segment) / segment
    
    return ColorUtils.lerp(colors[index], colors[index + 1], localT)
end

-- ============================================
-- ⚖️ تعديل الألوان
-- ============================================

-- جعل اللون أفتح (تفتيح)
function ColorUtils.lighten(color, amount)
    amount = amount or 0.2
    
    return Color3.new(
        math.min(1, color.R + amount),
        math.min(1, color.G + amount),
        math.min(1, color.B + amount)
    )
end

-- جعل اللون أغمق (تعتيم)
function ColorUtils.darken(color, amount)
    amount = amount or 0.2
    
    return Color3.new(
        math.max(0, color.R - amount),
        math.max(0, color.G - amount),
        math.max(0, color.B - amount)
    )
end

-- تغيير التشبع
function ColorUtils.saturate(color, amount)
    local h, s, v = ColorUtils.rgbToHSV(color)
    s = math.clamp(s + amount, 0, 1)
    
    return ColorUtils.hsvToRGB(h, s, v)
end

-- تغيير الإضاءة
function ColorUtils.brighten(color, amount)
    local h, s, v = ColorUtils.rgbToHSV(color)
    v = math.clamp(v + amount, 0, 1)
    
    return ColorUtils.hsvToRGB(h, s, v)
end

-- عكس اللون (مكمل)
function ColorUtils.invert(color)
    return Color3.new(
        1 - color.R,
        1 - color.G,
        1 - color.B
    )
end

-- تحويل إلى تدرج رمادي
function ColorUtils.grayscale(color)
    local average = (color.R + color.G + color.B) / 3
    return Color3.new(average, average, average)
end

-- ============================================
-- 🎯 فحص الألوان
-- ============================================

-- حساب سطوع اللون (لمعرفة إذا كان فاتح أم داكن)
function ColorUtils.luminance(color)
    return 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
end

-- معرفة إذا كان اللون فاتح (مناسب للنص الداكن)
function ColorUtils.isLight(color, threshold)
    threshold = threshold or 0.5
    return ColorUtils.luminance(color) > threshold
end

-- معرفة إذا كان اللون داكن (مناسب للنص الفاتح)
function ColorUtils.isDark(color, threshold)
    return not ColorUtils.isLight(color, threshold)
end

-- الحصول على لون نص مناسب للخلفية
function ColorUtils.getTextColor(backgroundColor)
    if ColorUtils.isLight(backgroundColor) then
        return Color3.new(0, 0, 0) -- نص أسود
    else
        return Color3.new(1, 1, 1) -- نص أبيض
    end
end

-- حساب التباين بين لونين
function ColorUtils.contrastRatio(color1, color2)
    local l1 = ColorUtils.luminance(color1)
    local l2 = ColorUtils.luminance(color2)
    
    local lighter = math.max(l1, l2)
    local darker = math.min(l1, l2)
    
    return (lighter + 0.05) / (darker + 0.05)
end

-- التحقق إذا كان التباين كافيًا (للوصولية)
function ColorUtils.hasSufficientContrast(color1, color2, minRatio)
    minRatio = minRatio or 4.5 -- الحد الأدنى الموصى به
    return ColorUtils.contrastRatio(color1, color2) >= minRatio
end

-- ============================================
-- 🎨 لوحات الألوان
-- ============================================

-- لوحة ألوان متماشية (Analogous)
function ColorUtils.analogousPalette(baseColor, count)
    count = count or 5
    local h, s, v = ColorUtils.rgbToHSV(baseColor)
    
    local palette = {}
    local step = 30 / 360 -- 30 درجة
    
    for i = -math.floor(count/2), math.floor(count/2) do
        local newH = (h + i * step) % 1
        table.insert(palette, ColorUtils.hsvToRGB(newH, s, v))
    end
    
    return palette
end

-- لوحة ألوان متكاملة (Complementary)
function ColorUtils.complementaryPalette(baseColor)
    local h, s, v = ColorUtils.rgbToHSV(baseColor)
    local complementaryH = (h + 0.5) % 1
    
    return {
        baseColor,
        ColorUtils.hsvToRGB(complementaryH, s, v)
    }
end

-- لوحة ألوان ثلاثية (Triadic)
function ColorUtils.triadicPalette(baseColor)
    local h, s, v = ColorUtils.rgbToHSV(baseColor)
    
    return {
        baseColor,
        ColorUtils.hsvToRGB((h + 1/3) % 1, s, v),
        ColorUtils.hsvToRGB((h + 2/3) % 1, s, v)
    }
end

-- لوحة ألوان رباعية (Tetradic)
function ColorUtils.tetradicPalette(baseColor)
    local h, s, v = ColorUtils.rgbToHSV(baseColor)
    
    return {
        baseColor,
        ColorUtils.hsvToRGB((h + 0.25) % 1, s, v),
        ColorUtils.hsvToRGB((h + 0.5) % 1, s, v),
        ColorUtils.hsvToRGB((h + 0.75) % 1, s, v)
    }
end

-- لوحة ألوان أحادية (Monochromatic)
function ColorUtils.monochromaticPalette(baseColor, count)
    count = count or 5
    local h, s, v = ColorUtils.rgbToHSV(baseColor)
    
    local palette = {}
    local step = 1 / (count + 1)
    
    for i = 1, count do
        local newV = math.clamp(v + (i * step) - 0.5, 0, 1)
        local newS = math.clamp(s + (i * step / 2) - 0.25, 0, 1)
        table.insert(palette, ColorUtils.hsvToRGB(h, newS, newV))
    end
    
    return palette
end

-- ============================================
-- 🔧 دوال مساعدة
-- ============================================

-- تنسيق اللون لسلسلة نصية
function ColorUtils.toString(color, format)
    format = format or "rgb"
    
    if format:lower() == "rgb" then
        return string.format("RGB(%d, %d, %d)", 
            math.floor(color.R * 255),
            math.floor(color.G * 255),
            math.floor(color.B * 255)
        )
    elseif format:lower() == "hex" then
        return ColorUtils.rgbToHex(color)
    else
        local h, s, v = ColorUtils.rgbToHSV(color)
        return string.format("HSV(%.2f, %.2f, %.2f)", h, s, v)
    end
end

-- مقارنة لونين (مع هامش خطأ)
function ColorUtils.equals(color1, color2, tolerance)
    tolerance = tolerance or 0.01
    
    return math.abs(color1.R - color2.R) < tolerance and
           math.abs(color1.G - color2.G) < tolerance and
           math.abs(color1.B - color2.B) < tolerance
end

-- نسخ اللون
function ColorUtils.copy(color)
    return Color3.new(color.R, color.G, color.B)
end

-- ============================================
-- 🎨 ألوان جاهزة
-- ============================================
ColorUtils.Presets = {
    -- ألوان أساسية
    Red = Color3.fromRGB(255, 50, 50),
    Green = Color3.fromRGB(50, 255, 50),
    Blue = Color3.fromRGB(50, 100, 255),
    
    -- ألوان ثانوية
    Yellow = Color3.fromRGB(255, 255, 50),
    Cyan = Color3.fromRGB(50, 255, 255),
    Magenta = Color3.fromRGB(255, 50, 255),
    Orange = Color3.fromRGB(255, 150, 50),
    Purple = Color3.fromRGB(150, 50, 255),
    
    -- ألوان محايدة
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(0, 0, 0),
    Gray = Color3.fromRGB(128, 128, 128),
    LightGray = Color3.fromRGB(200, 200, 200),
    DarkGray = Color3.fromRGB(50, 50, 50),
    
    -- ألوان خاصة
    Transparent = Color3.new(1, 1, 1), -- مع شفافية
    RobloxBlue = Color3.fromRGB(0, 162, 255),
    DiscordBlurple = Color3.fromRGB(88, 101, 242)
}

-- الحصول على لون من المحفوظات بالاسم
function ColorUtils.getPreset(name)
    return ColorUtils.Presets[name] or ColorUtils.Presets.White
end

return ColorUtils
