-- ============================================
-- 👥 Player Tracker Module
-- 📊 متعقب اللاعبين وإدارة القوائم
-- ✨ جزء من Beautiful HUD
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local PlayerTracker = {}
PlayerTracker.__index = PlayerTracker

-- ============================================
-- 🎯 التهيئة
-- ============================================
function PlayerTracker.new(config)
    local self = setmetatable({}, PlayerTracker)
    
    -- الإعدادات
    self.config = config or {
        maxPlayers = 12,
        showAvatars = false,
        updateInterval = 3,
        cacheEnabled = true
    }
    
    -- البيانات
    self.players = {}
    self.playerList = {}
    self.cachedAvatars = {}
    self.playerCount = 0
    
    -- التوصيلات
    self.connections = {}
    
    -- الإحصائيات
    self.stats = {
        totalJoined = 0,
        totalLeft = 0,
        peakPlayers = 0
    }
    
    -- تهيئة
    self:initialize()
    
    return self
end

-- ============================================
-- 🔧 الدوال الأساسية
-- ============================================
function PlayerTracker:initialize()
    print("[PlayerTracker] جاري تهيئة متعقب اللاعبين...")
    
    -- تحديث اللاعبين الحاليين
    self:updateCurrentPlayers()
    
    -- إعداد الأحداث
    self:setupEvents()
    
    print("[PlayerTracker] ✅ تم التهيئة - " .. self.playerCount .. " لاعب")
end

function PlayerTracker:updateCurrentPlayers()
    self.playerList = {}
    local localPlayer = Players.LocalPlayer
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            self:addPlayerToCache(player)
            table.insert(self.playerList, self:getPlayerInfo(player))
        end
    end
    
    self.playerCount = #self.playerList
    
    -- تحديث الذروة
    if self.playerCount > self.stats.peakPlayers then
        self.stats.peakPlayers = self.playerCount
    end
end

function PlayerTracker:setupEvents()
    -- حدث دخول لاعب جديد
    self.connections.playerAdded = Players.PlayerAdded:Connect(function(player)
        task.wait(0.5) -- انتظار تحميل اللاعب
        self:onPlayerJoined(player)
    end)
    
    -- حدث خروج لاعب
    self.connections.playerRemoving = Players.PlayerRemoving:Connect(function(player)
        self:onPlayerLeft(player)
    end)
    
    -- حدث تغيير الاسم
    self.connections.displayNameChanged = nil -- سيتم إضافته إذا احتاج
    
    -- تنظيف دوري للكاش
    if self.config.cacheEnabled then
        self.connections.cleanup = RunService.Heartbeat:Connect(function()
            if tick() % 30 < 0.1 then -- كل 30 ثانية
                self:cleanupCache()
            end
        end)
    end
end

-- ============================================
-- 🎯 معالجة الأحداث
-- ============================================
function PlayerTracker:onPlayerJoined(player)
    if not player then return end
    
    self.stats.totalJoined = self.stats.totalJoined + 1
    self:addPlayerToCache(player)
    
    -- إضافة للقائمة
    local playerInfo = self:getPlayerInfo(player)
    table.insert(self.playerList, playerInfo)
    self.playerCount = self.playerCount + 1
    
    -- تحديث الذروة
    if self.playerCount > self.stats.peakPlayers then
        self.stats.peakPlayers = self.playerCount
    end
    
    -- إشعار (اختياري)
    if self.onPlayerJoinedCallback then
        self.onPlayerJoinedCallback(playerInfo)
    end
    
    print("[PlayerTracker] 🎮 انضم لاعب: " .. player.Name .. " (المجموع: " .. self.playerCount .. ")")
end

function PlayerTracker:onPlayerLeft(player)
    if not player then return end
    
    self.stats.totalLeft = self.stats.totalLeft + 1
    
    -- إزالة من القائمة
    for i, pInfo in ipairs(self.playerList) do
        if pInfo.userId == player.UserId then
            table.remove(self.playerList, i)
            break
        end
    end
    
    self.playerCount = self.playerCount - 1
    
    -- إزالة من الكاش
    self.cachedAvatars[player.UserId] = nil
    
    -- إشعار (اختياري)
    if self.onPlayerLeftCallback then
        self.onPlayerLeftCallback(self:getPlayerInfo(player))
    end
    
    print("[PlayerTracker] 🚪 غادر لاعب: " .. player.Name .. " (المجموع: " .. self.playerCount .. ")")
end

-- ============================================
-- 📊 الدوال العامة
-- ============================================
function PlayerTracker:getPlayerList()
    -- ترتيب أبجدي
    table.sort(self.playerList, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    
    return self.playerList
end

function PlayerTracker:getPlayerCount()
    return self.playerCount
end

function PlayerTracker:getPlayerInfo(player)
    if not player then return nil end
    
    return {
        name = player.Name,
        displayName = player.DisplayName,
        userId = player.UserId,
        accountAge = player.AccountAge,
        isFriends = player:IsFriendsWith(Players.LocalPlayer.UserId),
        team = player.Team and player.Team.Name or "No Team",
        isLocalPlayer = (player == Players.LocalPlayer)
    }
end

function PlayerTracker:getPlayerById(userId)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.UserId == userId then
            return self:getPlayerInfo(player)
        end
    end
    return nil
end

function PlayerTracker:searchPlayers(searchTerm)
    local results = {}
    searchTerm = searchTerm:lower()
    
    for _, playerInfo in ipairs(self.playerList) do
        if playerInfo.name:lower():find(searchTerm, 1, true) or
           playerInfo.displayName:lower():find(searchTerm, 1, true) then
            table.insert(results, playerInfo)
        end
    end
    
    return results
end

-- ============================================
-- 🖼️ إدارة الصور (مستقبلياً)
-- ============================================
function PlayerTracker:addPlayerToCache(player)
    if not player or not self.config.showAvatars then return end
    
    self.cachedAvatars[player.UserId] = {
        userId = player.UserId,
        name = player.Name,
        cachedAt = tick()
    }
    
    -- يمكن إضافة جلب صورة البروفايل هنا مستقبلاً
end

function PlayerTracker:getPlayerAvatar(userId)
    if not self.config.showAvatars then return nil end
    return self.cachedAvatars[userId]
end

function PlayerTracker:cleanupCache()
    local now = tick()
    local toRemove = {}
    
    for userId, data in pairs(self.cachedAvatars) do
        if now - data.cachedAt > 300 then -- بعد 5 دقائق
            table.insert(toRemove, userId)
        end
    end
    
    for _, userId in ipairs(toRemove) do
        self.cachedAvatars[userId] = nil
    end
    
    if #toRemove > 0 then
        print("[PlayerTracker] 🧹 تم تنظيف " .. #toRemove .. " لاعب من الكاش")
    end
end

-- ============================================
-- 📈 الإحصائيات
-- ============================================
function PlayerTracker:getStats()
    return {
        current = self.playerCount,
        peak = self.stats.peakPlayers,
        totalJoined = self.stats.totalJoined,
        totalLeft = self.stats.totalLeft,
        cacheSize = table.count(self.cachedAvatars)
    }
end

function PlayerTracker:getPlayerListFormatted()
    local list = {}
    
    for i, playerInfo in ipairs(self:getPlayerList()) do
        table.insert(list, string.format("#%d %s (%s)", 
            i, 
            playerInfo.displayName, 
            playerInfo.name
        ))
    end
    
    return list
end

-- ============================================
-- 🔔 نظام Callbacks
-- ============================================
function PlayerTracker:onPlayerJoined(callback)
    self.onPlayerJoinedCallback = callback
end

function PlayerTracker:onPlayerLeft(callback)
    self.onPlayerLeftCallback = callback
end

function PlayerTracker:onPlayerCountChanged(callback)
    self.onPlayerCountChangedCallback = callback
end

-- ============================================
-- 🧹 التنظيف
-- ============================================
function PlayerTracker:destroy()
    -- فصل جميع التوصيلات
    for _, connection in pairs(self.connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    -- مسح البيانات
    self.players = {}
    self.playerList = {}
    self.cachedAvatars = {}
    self.connections = {}
    
    print("[PlayerTracker] 🗑️ تم تدمير متعقب اللاعبين")
end

return PlayerTracker
