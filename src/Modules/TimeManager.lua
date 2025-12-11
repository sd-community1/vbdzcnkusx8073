-- ============================================
-- ⏰ Time Manager Module
-- 🕒 مدير الوقت والتاريخ والتوقيتات
-- ✨ جزء من Beautiful HUD
-- ============================================

local RunService = game:GetService("RunService")

local TimeManager = {}
TimeManager.__index = TimeManager

-- ============================================
-- 🎯 التهيئة
-- ============================================
function TimeManager.new(config)
    local self = setmetatable({}, TimeManager)
    
    -- الإعدادات
    self.config = config or {
        format24h = true,
        showSeconds = true,
        showDate = false,
        showDayOfWeek = false,
        timezoneOffset = 0, -- إزاحة التوقيت
        updateInterval = 1
    }
    
    -- المتغيرات
    self.currentTime = ""
    self.currentDate = ""
    self.dayOfWeek = ""
    self.playTime = 0
    self.startTime = tick()
    
    -- التوقيتات
    self.timers = {}
    self.alarms = {}
    
    -- التوصيلات
    self.connections = {}
    
    -- البدء
    self:initialize()
    
    return self
end

-- ============================================
-- 🔧 الدوال الأساسية
-- ============================================
function TimeManager:initialize()
    print("[TimeManager] جاري تهيئة مدير الوقت...")
    
    -- تحديث الوقت أول مرة
    self:updateTime()
    
    -- بدء التحديثات
    self:startUpdates()
    
    print("[TimeManager] ✅ تم التهيئة")
end

function TimeManager:startUpdates()
    -- تحديث الوقت بانتظام
    self.connections.timeUpdate = RunService.Heartbeat:Connect(function(deltaTime)
        self.playTime = self.playTime + deltaTime
        
        -- تحديث كل ثانية
        if tick() % self.config.updateInterval < deltaTime then
            self:updateTime()
        end
        
        -- التحقق من المنبهات
        self:checkAlarms()
    end)
end

-- ============================================
-- ⏰ معالجة الوقت
-- ============================================
function TimeManager:updateTime()
    local now = os.time()
    
    -- تطبيق إزاحة التوقيت
    local adjustedTime = now + (self.config.timezoneOffset * 3600)
    local timeTable = os.date("*t", adjustedTime)
    
    -- تنسيق الوقت
    local hour = timeTable.hour
    local minute = timeTable.min
    local second = timeTable.sec
    
    if self.config.format24h then
        if self.config.showSeconds then
            self.currentTime = string.format("%02d:%02d:%02d", hour, minute, second)
        else
            self.currentTime = string.format("%02d:%02d", hour, minute)
        end
    else
        local ampm = "AM"
        if hour >= 12 then
            ampm = "PM"
            if hour > 12 then hour = hour - 12 end
        end
        if hour == 0 then hour = 12 end
        
        if self.config.showSeconds then
            self.currentTime = string.format("%02d:%02d:%02d %s", hour, minute, second, ampm)
        else
            self.currentTime = string.format("%02d:%02d %s", hour, minute, ampm)
        end
    end
    
    -- التاريخ
    if self.config.showDate then
        self.currentDate = os.date("%d/%m/%Y", adjustedTime)
    else
        self.currentDate = ""
    end
    
    -- يوم الأسبوع
    if self.config.showDayOfWeek then
        local days = {"الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"}
        self.dayOfWeek = days[timeTable.wday] or ""
    else
        self.dayOfWeek = ""
    end
end

function TimeManager:getTime()
    return self.currentTime
end

function TimeManager:getDate()
    return self.currentDate
end

function TimeManager:getDayOfWeek()
    return self.dayOfWeek
end

function TimeManager:getFullDateTime()
    local parts = {}
    
    if self.dayOfWeek ~= "" then
        table.insert(parts, self.dayOfWeek)
    end
    
    table.insert(parts, self.currentTime)
    
    if self.currentDate ~= "" then
        table.insert(parts, self.currentDate)
    end
    
    return table.concat(parts, " - ")
end

-- ============================================
-- ⏱️ وقت اللعب
-- ============================================
function TimeManager:getPlayTime()
    return self.playTime
end

function TimeManager:getFormattedPlayTime()
    local seconds = math.floor(self.playTime)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    if hours > 0 then
        return string.format("%d:%02d:%02d", hours, minutes, secs)
    else
        return string.format("%02d:%02d", minutes, secs)
    end
end

function TimeManager:getSessionStartTime()
    return self.startTime
end

function TimeManager:getUptime()
    return tick() - self.startTime
end

-- ============================================
-- ⏰ الموقتات والمنبهات
-- ============================================
function TimeManager:createTimer(name, duration, callback, repeating)
    local timer = {
        name = name or "Timer_" .. #self.timers + 1,
        duration = duration,
        elapsed = 0,
        callback = callback,
        repeating = repeating or false,
        active = true,
        startTime = tick()
    }
    
    self.timers[name] = timer
    
    return timer.name
end

function TimeManager:updateTimers(deltaTime)
    local toRemove = {}
    
    for name, timer in pairs(self.timers) do
        if timer.active then
            timer.elapsed = timer.elapsed + deltaTime
            
            if timer.elapsed >= timer.duration then
                -- تنفيذ الـ Callback
                if timer.callback then
                    pcall(timer.callback, timer.name, timer.elapsed)
                end
                
                if timer.repeating then
                    timer.elapsed = 0
                    timer.startTime = tick()
                else
                    table.insert(toRemove, name)
                end
            end
        end
    end
    
    -- إزالة الموقتات المنتهية
    for _, name in ipairs(toRemove) do
        self.timers[name] = nil
    end
end

function TimeManager:stopTimer(name)
    if self.timers[name] then
        self.timers[name].active = false
        return true
    end
    return false
end

function TimeManager:resumeTimer(name)
    if self.timers[name] then
        self.timers[name].active = true
        self.timers[name].startTime = tick()
        return true
    end
    return false
end

function TimeManager:removeTimer(name)
    self.timers[name] = nil
end

function TimeManager:getTimerProgress(name)
    if self.timers[name] then
        local timer = self.timers[name]
        return {
            elapsed = timer.elapsed,
            remaining = timer.duration - timer.elapsed,
            progress = timer.elapsed / timer.duration,
            active = timer.active
        }
    end
    return nil
end

-- ============================================
-- 🔔 المنبهات
-- ============================================
function TimeManager:setAlarm(name, timeString, callback)
    -- timeString بصيغة "HH:MM" أو "HH:MM:SS"
    local pattern = "(%d+):(%d+):?(%d*)"
    local hour, minute, second = timeString:match(pattern)
    
    hour = tonumber(hour)
    minute = tonumber(minute)
    second = tonumber(second) or 0
    
    if hour and minute then
        self.alarms[name] = {
            hour = hour,
            minute = minute,
            second = second,
            callback = callback,
            triggered = false
        }
        return true
    end
    
    return false
end

function TimeManager:checkAlarms()
    local now = os.date("*t")
    
    for name, alarm in pairs(self.alarms) do
        if not alarm.triggered and 
           now.hour == alarm.hour and 
           now.min == alarm.minute and 
           now.sec >= alarm.second then
           
            alarm.triggered = true
            
            if alarm.callback then
                pcall(alarm.callback, name)
            end
        elseif alarm.triggered and 
              (now.hour ~= alarm.hour or now.min ~= alarm.minute) then
            alarm.triggered = false
        end
    end
end

function TimeManager:removeAlarm(name)
    self.alarms[name] = nil
end

-- ============================================
-- 📊 معلومات إضافية
-- ============================================
function TimeManager:getTimeOfDay()
    local hour = tonumber(os.date("%H"))
    
    if hour >= 5 and hour < 12 then
        return "Morning", "☀️"
    elseif hour >= 12 and hour < 17 then
        return "Afternoon", "🌤️"
    elseif hour >= 17 and hour < 21 then
        return "Evening", "🌇"
    else
        return "Night", "🌙"
    end
end

function TimeManager:getSeason()
    local month = tonumber(os.date("%m"))
    
    if month >= 3 and month <= 5 then
        return "Spring", "🌼"
    elseif month >= 6 and month <= 8 then
        return "Summer", "☀️"
    elseif month >= 9 and month <= 11 then
        return "Autumn", "🍂"
    else
        return "Winter", "❄️"
    end
end

-- ============================================
-- ⚙️ التحكم
-- ============================================
function TimeManager:setTimeFormat(format24h)
    self.config.format24h = format24h
    self:updateTime()
end

function TimeManager:setShowSeconds(show)
    self.config.showSeconds = show
    self:updateTime()
end

function TimeManager:setShowDate(show)
    self.config.showDate = show
    self:updateTime()
end

function TimeManager:setTimezoneOffset(offset)
    self.config.timezoneOffset = offset
    self:updateTime()
end

-- ============================================
-- 🧹 التنظيف
-- ============================================
function TimeManager:destroy()
    -- فصل التوصيلات
    if self.connections.timeUpdate then
        self.connections.timeUpdate:Disconnect()
    end
    
    -- مسح البيانات
    self.timers = {}
    self.alarms = {}
    self.connections = {}
    
    print("[TimeManager] 🗑️ تم تدمير مدير الوقت")
end

return TimeManager
