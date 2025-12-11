-- ============================================
-- 📐 Math Utilities Module
-- 🧮 أدوات ودوال رياضية
-- ✨ جزء من Beautiful HUD
-- ============================================

local MathUtils = {}

-- ============================================
-- 🎯 دوال الأساسيات
-- ============================================

-- تقييد قيمة بين حدين
function MathUtils.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- التقريب لعدد معين من الخانات العشرية
function MathUtils.round(num, decimals)
    decimals = decimals or 0
    local multiplier = 10 ^ decimals
    return math.floor(num * multiplier + 0.5) / multiplier
end

-- تحويل قيمة من مدى إلى مدى آخر
function MathUtils.map(value, inMin, inMax, outMin, outMax)
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

-- القيمة المطلقة
function MathUtils.abs(num)
    return math.abs(num)
end

-- الإشارة (+1, 0, -1)
function MathUtils.sign(num)
    if num > 0 then return 1
    elseif num < 0 then return -1
    else return 0 end
end

-- ============================================
-- 📈 دوال الإحصاء
-- ============================================

-- حساب المتوسط
function MathUtils.average(numbers)
    if #numbers == 0 then return 0 end
    
    local sum = 0
    for _, num in ipairs(numbers) do
        sum = sum + num
    end
    
    return sum / #numbers
end

-- حساب الوسيط
function MathUtils.median(numbers)
    if #numbers == 0 then return 0 end
    
    -- نسخ الجدول لعدم تعديل الأصل
    local sorted = {}
    for _, v in ipairs(numbers) do
        table.insert(sorted, v)
    end
    
    table.sort(sorted)
    local mid = math.floor(#sorted / 2) + 1
    
    if #sorted % 2 == 0 then
        return (sorted[mid - 1] + sorted[mid]) / 2
    else
        return sorted[mid]
    end
end

-- حساب مجموع الجدول
function MathUtils.sum(numbers)
    local total = 0
    for _, num in ipairs(numbers) do
        total = total + num
    end
    return total
end

-- إيجاد القيمة القصوى
function MathUtils.max(numbers)
    if #numbers == 0 then return 0 end
    local maxVal = numbers[1]
    for i = 2, #numbers do
        if numbers[i] > maxVal then
            maxVal = numbers[i]
        end
    end
    return maxVal
end

-- إيجاد القيمة الدنيا
function MathUtils.min(numbers)
    if #numbers == 0 then return 0 end
    local minVal = numbers[1]
    for i = 2, #numbers do
        if numbers[i] < minVal then
            minVal = numbers[i]
        end
    end
    return minVal
end

-- حساب الانحراف المعياري
function MathUtils.standardDeviation(numbers)
    if #numbers < 2 then return 0 end
    
    local avg = MathUtils.average(numbers)
    local sumSquares = 0
    
    for _, num in ipairs(numbers) do
        sumSquares = sumSquares + (num - avg) ^ 2
    end
    
    return math.sqrt(sumSquares / (#numbers - 1))
end

-- ============================================
-- ⏱️ دوال الوقت
-- ============================================

-- تنسيق الوقت من الثواني
function MathUtils.formatTime(seconds, format)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    
    if format == "short" then
        if hours > 0 then
            return string.format("%dh %02dm", hours, minutes)
        elseif minutes > 0 then
            return string.format("%dm %02ds", minutes, secs)
        else
            return string.format("%ds", secs)
        end
    else
        if hours > 0 then
            return string.format("%02d:%02d:%02d", hours, minutes, secs)
        else
            return string.format("%02d:%02d", minutes, secs)
        end
    end
end

-- حساب الفرق بين وقتين
function MathUtils.timeDifference(t1, t2)
    return math.abs(t2 - t1)
end

-- تحويل الثواني إلى وقت مقروء
function MathUtils.secondsToReadable(seconds)
    if seconds < 60 then
        return string.format("%.1f ثانية", seconds)
    elseif seconds < 3600 then
        return string.format("%.1f دقيقة", seconds / 60)
    elseif seconds < 86400 then
        return string.format("%.1f ساعة", seconds / 3600)
    else
        return string.format("%.1f يوم", seconds / 86400)
    end
end

-- ============================================
-- 📊 دوال الرسوم البيانية
-- ============================================

-- تسوية القيم للرسم البياني
function MathUtils.normalizeValues(values, maxHeight)
    if #values == 0 then return {} end
    
    local maxValue = MathUtils.max(values)
    if maxValue == 0 then maxValue = 1 end
    
    local normalized = {}
    for _, value in ipairs(values) do
        table.insert(normalized, (value / maxValue) * maxHeight)
    end
    
    return normalized
end

-- حساب الميل بين نقطتين
function MathUtils.calculateSlope(x1, y1, x2, y2)
    if x2 == x1 then
        return math.huge -- ميل عمودي
    end
    return (y2 - y1) / (x2 - x1)
end

-- إنشاء قيم متدرجة
function MathUtils.lerp(startValue, endValue, t)
    t = MathUtils.clamp(t, 0, 1)
    return startValue + (endValue - startValue) * t
end

-- ============================================
-- 🔢 دوال الجدولة
-- ============================================

-- إنشاء جدول من الأرقام
function MathUtils.range(start, stop, step)
    step = step or 1
    local t = {}
    
    if step > 0 then
        for i = start, stop, step do
            table.insert(t, i)
        end
    else
        for i = start, stop, step do
            table.insert(t, i)
        end
    end
    
    return t
end

-- خلط الجدول عشوائياً
function MathUtils.shuffleTable(t)
    local shuffled = {}
    
    -- نسخ الجدول
    for _, v in ipairs(t) do
        table.insert(shuffled, v)
    end
    
    -- خلط باستخدام Fisher-Yates
    for i = #shuffled, 2, -1 do
        local j = math.random(i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
    
    return shuffled
end

-- نسخ الجدول بعمق
function MathUtils.deepCopy(original)
    local copy = {}
    
    for k, v in pairs(original) do
        if type(v) == "table" then
            v = MathUtils.deepCopy(v)
        end
        copy[k] = v
    end
    
    return copy
end

-- دمج جدولين
function MathUtils.mergeTables(t1, t2)
    local result = MathUtils.deepCopy(t1)
    
    for k, v in pairs(t2) do
        if type(v) == "table" and type(result[k]) == "table" then
            result[k] = MathUtils.mergeTables(result[k], v)
        else
            result[k] = v
        end
    end
    
    return result
end

-- ============================================
-- 🎲 دوال عشوائية
-- ============================================

-- رقم عشوائي بين قيمتين (بما في ذلك الكسور)
function MathUtils.randomFloat(min, max)
    return min + math.random() * (max - min)
end

-- رقم عشوائي صحيح بين قيمتين
function MathUtils.randomInt(min, max)
    return math.random(min, max)
end

-- اختيار عنصر عشوائي من الجدول
function MathUtils.randomChoice(t)
    if #t == 0 then return nil end
    return t[math.random(#t)]
end

-- وزن عشوائي بناءً على الاحتمالات
function MathUtils.weightedRandom(weights)
    local total = 0
    for _, weight in ipairs(weights) do
        total = total + weight
    end
    
    local randomValue = math.random() * total
    local cumulative = 0
    
    for i, weight in ipairs(weights) do
        cumulative = cumulative + weight
        if randomValue <= cumulative then
            return i
        end
    end
    
    return #weights
end

-- ============================================
-- 📐 دوال هندسية
-- ============================================

-- حساب المسافة بين نقطتين
function MathUtils.distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

-- حساب المسافة ثلاثية الأبعاد
function MathUtils.distance3D(x1, y1, z1, x2, y2, z2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

-- حساب الزاوية بين نقطتين (بالراديان)
function MathUtils.angle(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

-- تحويل الراديان إلى درجات
function MathUtils.radToDeg(rad)
    return rad * (180 / math.pi)
end

-- تحويل الدرجات إلى راديان
function MathUtils.degToRad(deg)
    return deg * (math.pi / 180)
end

-- ============================================
-- 🔧 دوال مساعدة
-- ============================================

-- التحقق إذا كان الرقم زوجي
function MathUtils.isEven(num)
    return num % 2 == 0
end

-- التحقق إذا كان الرقم فردي
function MathUtils.isOdd(num)
    return num % 2 == 1
end

-- تحويل إلى نسبة مئوية
function MathUtils.toPercent(value, total)
    if total == 0 then return 0 end
    return (value / total) * 100
end

-- تحويل من نسبة مئوية
function MathUtils.fromPercent(percent, total)
    return (percent / 100) * total
end

-- تنفيذ دالة مع معالجة الأخطاء
function MathUtils.safeCall(func, ...)
    local success, result = pcall(func, ...)
    if success then
        return result
    else
        warn("[MathUtils] فشل تنفيذ الدالة:", result)
        return nil
    end
end

-- قياس وقت تنفيذ دالة
function MathUtils.measureTime(func, ...)
    local startTime = tick()
    local result = {func(...)}
    local endTime = tick()
    
    return {
        result = unpack(result),
        time = endTime - startTime
    }
end

-- ============================================
-- 📊 دوال FPS والأداء
-- ============================================

-- حساب متوسط FPS من عينات
function MathUtils.calculateAverageFPS(samples)
    if #samples == 0 then return 0 end
    
    local validSamples = {}
    for _, fps in ipairs(samples) do
        if fps > 0 and fps < 1000 then -- تصفية القيم غير المنطقية
            table.insert(validSamples, fps)
        end
    end
    
    if #validSamples == 0 then return 0 end
    
    return MathUtils.round(MathUtils.average(validSamples), 1)
end

-- حساب معدل الإطارات (Frame Time)
function MathUtils.fpsToFrameTime(fps)
    if fps <= 0 then return 0 end
    return 1000 / fps -- بالمللي ثانية
end

-- ============================================
-- 🎨 دوال الألوان (مساعدة ColorUtils)
-- ============================================

-- تحويل قيمة لونية (0-255 إلى 0-1)
function MathUtils.normalizeColorValue(value)
    return MathUtils.clamp(value / 255, 0, 1)
end

-- تحويل قيمة لونية (0-1 إلى 0-255)
function MathUtils.denormalizeColorValue(value)
    return math.floor(MathUtils.clamp(value, 0, 1) * 255)
end

-- ============================================
-- 📝 الثوابت الرياضية
-- ============================================
MathUtils.PI = math.pi
MathUtils.TAU = math.pi * 2
MathUtils.E = math.exp(1)
MathUtils.PHI = (1 + math.sqrt(5)) / 2 -- النسبة الذهبية

return MathUtils
