-- ============================================
-- 🎮 Beautiful HUD for Roblox - النسخة الكاملة
-- 📦 جميع المكونات في ملف واحد - لا يحتاج ملفات خارجية
-- ✨ بواسطة: sd-community1
-- 🔗 GitHub: https://github.com/sd-community1/vbdzcnkusx8073
-- ============================================

--[[
    📝 كيفية الاستخدام:
    --------------------------------------------------
    1. انسخ هذا الكود كاملاً (Ctrl+A ثم Ctrl+C)
    2. الصقه في أي حاقن (Executor) لـ Roblox
    3. اضغط Execute / تشغيل
    4. سيظهر HUD جميل في زاوية الشاشة!
    
    🎯 المميزات:
    --------------------------------------------------
    • عرض FPS دقيق بألوان متغيرة (أخضر/أصفر/أحمر)
    • ساعة رقمية بتنسيق 24 ساعة
    • قائمة اللاعبين مع أرقام تسلسلية
    • تصميم عصري مع تأثيرات حركية
    • 3 ثيمات جاهزة: Dark, Light, Neon
    • قابلية السحب والتكبير
    • زر إخفاء/إظهار (F8)
    • أداء عالي وخفيف على النظام
    
    🎨 الألوان:
    --------------------------------------------------
    • FPS ≥ 60: 🟢 أخضر
    • FPS ≥ 30: 🟡 أصفر  
    • FPS < 30: 🔴 أحمر
    
    ⚡ التحكم:
    --------------------------------------------------
    • F8: إظهار/إخفاء الـ HUD
    • اسحب العنوان: تحريك الـ HUD
    • مرر على البطاقات: تأثيرات مرئية
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- ============================================
-- 🛠️ مكتبة الأدوات المساعدة
-- ============================================
local Utils = {
    -- تنسيق الوقت
    formatTime = function(seconds)
        local hours = math.floor(seconds / 3600)
        local minutes = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60
        return string.format("%02d:%02d:%02d", hours, minutes, secs)
    end,
    
    -- تحويل Hex إلى RGB
    hexToRGB = function(hex)
        hex = hex:gsub("#", "")
        return Color3.fromRGB(
            tonumber("0x" .. hex:sub(1, 2)),
            tonumber("0x" .. hex:sub(3, 4)),
            tonumber("0x" .. hex:sub(5, 6))
        )
    end,
    
    -- قص النص الطويل
    truncateText = function(text, maxLength)
        if #text > maxLength then
            return text:sub(1, maxLength - 3) .. "..."
        end
        return text
    end
}

-- ============================================
-- 🎨 نظام الثيمات
-- ============================================
local Themes = {
    Dark = {
        name = "Dark",
        colors = {
            background = Color3.fromRGB(20, 20, 30),
            card = Color3.fromRGB(30, 30, 45),
            primary = Color3.fromRGB(100, 150, 255),
            text = Color3.fromRGB(240, 240, 240),
            textSecondary = Color3.fromRGB(180, 180, 200),
            success = Color3.fromRGB(100, 255, 100),
            warning = Color3.fromRGB(255, 200, 100),
            error = Color3.fromRGB(255, 100, 100)
        },
        transparency = 0.12
    },
    
    Light = {
        name = "Light",
        colors = {
            background = Color3.fromRGB(245, 245, 250),
            card = Color3.fromRGB(255, 255, 255),
            primary = Color3.fromRGB(80, 120, 200),
            text = Color3.fromRGB(30, 30, 40),
            textSecondary = Color3.fromRGB(100, 100, 120),
            success = Color3.fromRGB(80, 200, 80),
            warning = Color3.fromRGB(220, 170, 80),
            error = Color3.fromRGB(220, 80, 80)
        },
        transparency = 0.08
    },
    
    Neon = {
        name = "Neon",
        colors = {
            background = Color3.fromRGB(10, 10, 20),
            card = Color3.fromRGB(20, 10, 40),
            primary = Color3.fromRGB(255, 0, 255),
            text = Color3.fromRGB(255, 255, 255),
            textSecondary = Color3.fromRGB(200, 200, 255),
            success = Color3.fromRGB(0, 255, 150),
            warning = Color3.fromRGB(255, 255, 0),
            error = Color3.fromRGB(255, 50, 50)
        },
        transparency = 0.05
    }
}

-- ============================================
-- 📊 نظام FPS Monitor
-- ============================================
local FPSMonitor = {}
FPSMonitor.__index = FPSMonitor

function FPSMonitor.new()
    local self = setmetatable({}, FPSMonitor)
    self.lastTime = tick()
    self.frameCount = 0
    self.currentFPS = 60
    self.samples = {}
    return self
end

function FPSMonitor:update()
    self.frameCount += 1
    local currentTime = tick()
    local elapsed = currentTime - self.lastTime
    
    if elapsed >= 0.5 then
        self.currentFPS = math.floor(self.frameCount / elapsed)
        self.frameCount = 0
        self.lastTime = currentTime
        
        table.insert(self.samples, self.currentFPS)
        if #self.samples > 60 then
            table.remove(self.samples, 1)
        end
    end
    
    return self:getSmoothed()
end

function FPSMonitor:getSmoothed()
    if #self.samples == 0 then return self.currentFPS end
    
    local sum = 0
    for _, fps in ipairs(self.samples) do
        sum += fps
    end
    return math.floor(sum / #self.samples)
end

function FPSMonitor:getColor(fps)
    if fps >= 60 then
        return Color3.fromRGB(100, 255, 100)    -- 🟢
    elseif fps >= 30 then
        return Color3.fromRGB(255, 200, 100)    -- 🟡
    else
        return Color3.fromRGB(255, 100, 100)    -- 🔴
    end
end

-- ============================================
-- ⏰ نظام Time Manager
-- ============================================
local TimeManager = {}
TimeManager.__index = TimeManager

function TimeManager.new()
    local self = setmetatable({}, TimeManager)
    return self
end

function TimeManager:getTime()
    local time = os.date("*t")
    return string.format("%02d:%02d:%02d", time.hour, time.min, time.sec)
end

function TimeManager:getDate()
    local time = os.date("*t")
    return string.format("%d/%d/%d", time.day, time.month, time.year)
end

-- ============================================
-- 👥 نظام Player Tracker
-- ============================================
local PlayerTracker = {}
PlayerTracker.__index = PlayerTracker

function PlayerTracker.new()
    local self = setmetatable({}, PlayerTracker)
    self.players = {}
    return self
end

function PlayerTracker:getPlayerList()
    local list = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            table.insert(list, {
                name = player.Name,
                displayName = player.DisplayName,
                userId = player.UserId
            })
        end
    end
    
    -- ترتيب أبجدي
    table.sort(list, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    
    return list
end

function PlayerTracker:getPlayerCount()
    return #Players:GetPlayers() - 1
end

-- ============================================
-- 🎮 Beautiful HUD الرئيسي
-- ============================================
local BeautifulHUD = {}
BeautifulHUD.__index = BeautifulHUD

function BeautifulHUD.new(config)
    local self = setmetatable({}, BeautifulHUD)
    
    -- الإعدادات الافتراضية
    self.config = {
        theme = config and config.theme or "Dark",
        position = config and config.position or "TopRight",
        showFPS = config and config.showFPS ~= nil and config.showFPS or true,
        showTime = config and config.showTime ~= nil and config.showTime or true,
        showPlayers = config and config.showPlayers ~= nil and config.showPlayers or true,
        transparency = config and config.transparency or 0.15,
        width = config and config.width or 280,
        height = config and config.height or 350,
        draggable = config and config.draggable or true,
        toggleKey = config and config.toggleKey or Enum.KeyCode.F8
    }
    
    -- المتغيرات الداخلية
    self.playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    self.screenGui = nil
    self.mainFrame = nil
    self.isVisible = true
    self.isDragging = false
    
    -- الموديولات
    self.fpsMonitor = FPSMonitor.new()
    self.timeManager = TimeManager.new()
    self.playerTracker = PlayerTracker.new()
    
    return self
end

function BeautifulHUD:init()
    -- إنشاء الواجهة
    self:createUI()
    
    -- إعداد الأحداث
    self:setupEvents()
    
    -- بدء التحديثات
    self:startUpdates()
    
    -- إشعار النجاح
    self:showNotification()
    
    return self
end

function BeautifulHUD:createUI()
    -- إنشاء ScreenGui
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "BeautifulHUD_Full"
    self.screenGui.DisplayOrder = 999
    self.screenGui.IgnoreGuiInset = true
    self.screenGui.ResetOnSpawn = false
    self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- الإناء الرئيسي
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Name = "MainFrame"
    self.mainFrame.Size = UDim2.new(0, self.config.width, 0, self.config.height)
    self.mainFrame.Position = self:getPosition()
    self.mainFrame.BackgroundColor3 = Themes[self.config.theme].colors.background
    self.mainFrame.BackgroundTransparency = self.config.transparency
    self.mainFrame.BorderSizePixel = 0
    
    -- زوايا مستديرة
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.mainFrame
    
    -- ظل جميل
    local stroke = Instance.new("UIStroke")
    stroke.Color = Themes[self.config.theme].colors.primary
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = self.mainFrame
    
    -- تدرج لوني
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Themes[self.config.theme].colors.background),
        ColorSequenceKeypoint.new(1, Themes[self.config.theme].colors.card)
    })
    gradient.Rotation = 45
    gradient.Parent = self.mainFrame
    
    -- بناء المكونات
    self:createHeader()
    self:createInfoSection()
    if self.config.showPlayers then
        self:createPlayersSection()
    end
    
    -- إضافة للشاشة
    self.mainFrame.Parent = self.screenGui
    self.screenGui.Parent = self.playerGui
    
    -- تأثير الظهور
    self:animateIn()
end

function BeautifulHUD:createHeader()
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundTransparency = 1
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "🎮 Beautiful HUD"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Themes[self.config.theme].colors.text
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- خط فاصل
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, -20, 0, 1)
    divider.Position = UDim2.new(0, 10, 1, -1)
    divider.BackgroundColor3 = Themes[self.config.theme].colors.primary
    divider.BackgroundTransparency = 0.5
    divider.BorderSizePixel = 0
    
    -- زر الإغلاق
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.TextColor3 = Themes[self.config.theme].colors.text
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.BorderSizePixel = 0
    
    closeBtn.MouseButton1Click:Connect(function()
        self:toggle()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        self:tween(closeBtn, {TextSize = 18}, 0.2)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        closeBtn.TextColor3 = Themes[self.config.theme].colors.text
        self:tween(closeBtn, {TextSize = 16}, 0.2)
    end)
    
    title.Parent = header
    divider.Parent = header
    closeBtn.Parent = header
    header.Parent = self.mainFrame
end

function BeautifulHUD:createInfoSection()
    local section = Instance.new("Frame")
    section.Name = "InfoSection"
    section.Size = UDim2.new(1, -20, 0, 80)
    section.Position = UDim2.new(0, 10, 40, 10)
    section.BackgroundTransparency = 1
    
    -- شبكة لعرض المعلومات
    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.new(0.48, 0, 0.48, 0)
    grid.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
    grid.FillDirection = Enum.FillDirection.Horizontal
    grid.Parent = section
    
    -- بطاقة FPS
    self.fpsCard = self:createInfoCard("FPS", "60", "⚡")
    self.fpsCard.Parent = section
    
    -- بطاقة الوقت
    self.timeCard = self:createInfoCard("الوقت", "00:00:00", "🕒")
    self.timeCard.Parent = section
    
    -- بطاقة اللاعبين
    if self.config.showPlayers then
        self.playersCard = self:createInfoCard("اللاعبين", "0", "👥")
        self.playersCard.Parent = section
    end
    
    section.Parent = self.mainFrame
end

function BeautifulHUD:createInfoCard(title, value, icon)
    local card = Instance.new("Frame")
    card.Name = title .. "Card"
    card.BackgroundColor3 = Themes[self.config.theme].colors.card
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 5)
    padding.Parent = card
    
    -- الأيقونة
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Text = icon
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 20
    iconLabel.TextColor3 = Themes[self.config.theme].colors.primary
    iconLabel.Size = UDim2.new(0, 30, 0, 30)
    iconLabel.BackgroundTransparency = 1
    
    -- العنوان
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.TextSize = 12
    titleLabel.TextColor3 = Themes[self.config.theme].colors.textSecondary
    titleLabel.Position = UDim2.new(0, 35, 0, 0)
    titleLabel.Size = UDim2.new(1, -35, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- القيمة
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Text = value
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 16
    valueLabel.TextColor3 = Themes[self.config.theme].colors.text
    valueLabel.Position = UDim2.new(0, 35, 0, 20)
    valueLabel.Size = UDim2.new(1, -35, 0, 25)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- تأثيرات التفاعل
    card.MouseEnter:Connect(function()
        self:tween(card, {BackgroundTransparency = 0.2}, 0.2)
    end)
    
    card.MouseLeave:Connect(function()
        self:tween(card, {BackgroundTransparency = 0.3}, 0.2)
    end)
    
    iconLabel.Parent = card
    titleLabel.Parent = card
    valueLabel.Parent = card
    
    return card
end

function BeautifulHUD:createPlayersSection()
    local section = Instance.new("Frame")
    section.Name = "PlayersSection"
    section.Size = UDim2.new(1, -20, 0, 180)
    section.Position = UDim2.new(0, 10, 130, 10)
    section.BackgroundTransparency = 1
    
    -- عنوان القسم
    local title = Instance.new("TextLabel")
    title.Text = "👥 اللاعبين الموجودين (" .. self.playerTracker:getPlayerCount() .. ")"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextColor3 = Themes[self.config.theme].colors.text
    title.Size = UDim2.new(1, 0, 0, 25)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- قائمة اللاعبين
    self.playersList = Instance.new("Frame")
    self.playersList.Name = "PlayersList"
    self.playersList.Size = UDim2.new(1, 0, 1, -30)
    self.playersList.Position = UDim2.new(0, 0, 25, 0)
    self.playersList.BackgroundColor3 = Themes[self.config.theme].colors.card
    self.playersList.BackgroundTransparency = 0.2
    self.playersList.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.playersList
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = self.playersList
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = self.playersList
    
    title.Parent = section
    self.playersList.Parent = section
    section.Parent = self.mainFrame
    
    -- تحديث القائمة
    self:updatePlayersList()
end

function BeautifulHUD:updatePlayersList()
    if not self.playersList then return end
    
    -- مسح القائمة القديمة
    for _, child in ipairs(self.playersList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- الحصول على اللاعبين
    local players = self.playerTracker:getPlayerList()
    
    -- تحديث العداد
    if self.playersCard then
        local valueLabel = self.playersCard:FindFirstChild("Value")
        if valueLabel then
            valueLabel.Text = tostring(#players)
        end
    end
    
    -- إضافة اللاعبين
    for i, player in ipairs(players) do
        if i <= 6 then -- أقصى 6 لاعبين في العرض
            local entry = self:createPlayerEntry(player, i)
            entry.Parent = self.playersList
            
            -- تأثير ظهور متتابع
            task.spawn(function()
                task.wait(i * 0.05)
                self:tween(entry, {BackgroundTransparency = 0.3}, 0.3)
            end)
        end
    end
end

function BeautifulHUD:createPlayerEntry(player, index)
    local entry = Instance.new("Frame")
    entry.Name = "Player_" .. player.userId
    entry.Size = UDim2.new(1, 0, 0, 35)
    entry.BackgroundColor3 = Themes[self.config.theme].colors.card
    entry.BackgroundTransparency = 1 -- للأنيميشن
    entry.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = entry
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 5)
    padding.Parent = entry
    
    -- الرقم التسلسلي
    local number = Instance.new("TextLabel")
    number.Text = "#" .. index
    number.Font = Enum.Font.Gotham
    number.TextSize = 11
    number.TextColor3 = Themes[self.config.theme].colors.textSecondary
    number.Size = UDim2.new(0, 30, 1, 0)
    number.BackgroundTransparency = 1
    
    -- اسم اللاعب
    local name = Instance.new("TextLabel")
    name.Text = Utils.truncateText(player.displayName or player.name, 15)
    name.Font = Enum.Font.Gotham
    name.TextSize = 14
    name.TextColor3 = Themes[self.config.theme].colors.text
    name.Position = UDim2.new(0, 35, 0, 0)
    name.Size = UDim2.new(1, -70, 1, 0)
    name.BackgroundTransparency = 1
    name.TextXAlignment = Enum.TextXAlignment.Left
    
    -- أيقونة
    local icon = Instance.new("TextLabel")
    icon.Text = "👤"
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 16
    icon.TextColor3 = Themes[self.config.theme].colors.primary
    icon.Size = UDim2.new(0, 30, 1, 0)
    icon.Position = UDim2.new(1, -35, 0, 0)
    icon.BackgroundTransparency = 1
    icon.TextXAlignment = Enum.TextXAlignment.Right
    
    -- تأثيرات التفاعل
    entry.MouseEnter:Connect(function()
        self:tween(entry, {
            BackgroundColor3 = Themes[self.config.theme].colors.primary,
            BackgroundTransparency = 0.2
        }, 0.2)
        self:tween(name, {TextColor3 = Color3.new(1, 1, 1)}, 0.2)
    end)
    
    entry.MouseLeave:Connect(function()
        self:tween(entry, {
            BackgroundColor3 = Themes[self.config.theme].colors.card,
            BackgroundTransparency = 0.3
        }, 0.2)
        self:tween(name, {TextColor3 = Themes[self.config.theme].colors.text}, 0.2)
    end)
    
    number.Parent = entry
    name.Parent = entry
    icon.Parent = entry
    
    return entry
end

function BeautifulHUD:getPosition()
    local positions = {
        TopLeft = UDim2.new(0, 15, 0, 15),
        TopRight = UDim2.new(1, -self.config.width - 15, 0, 15),
        BottomLeft = UDim2.new(0, 15, 1, -self.config.height - 15),
        BottomRight = UDim2.new(1, -self.config.width - 15, 1, -self.config.height - 15)
    }
    return positions[self.config.position] or positions.TopRight
end

function BeautifulHUD:tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function BeautifulHUD:animateIn()
    if not self.mainFrame then return end
    
    local startPos = self.mainFrame.Position
    self.mainFrame.Position = startPos - UDim2.new(0, 0, 0.2, 0)
    self.mainFrame.BackgroundTransparency = 1
    
    self:tween(self.mainFrame, {
        Position = startPos,
        BackgroundTransparency = self.config.transparency
    }, 0.5)
end

function BeautifulHUD:setupEvents()
    -- زر الإظهار/الإخفاء
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == self.config.toggleKey then
            self:toggle()
        end
    end)
    
    -- قابلية السحب
    if self.config.draggable then
        local header = self.mainFrame:FindFirstChild("Header")
        if header then
            local isDragging = false
            local dragStart, frameStart
            
            header.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    dragStart = input.Position
                    frameStart = self.mainFrame.Position
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - dragStart
                    self.mainFrame.Position = UDim2.new(
                        frameStart.X.Scale,
                        frameStart.X.Offset + delta.X,
                        frameStart.Y.Scale,
                        frameStart.Y.Offset + delta.Y
                    )
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)
        end
    end
    
    -- تحديث عند تغيير اللاعبين
    Players.PlayerAdded:Connect(function()
        task.wait(0.5)
        self:updatePlayersList()
    end)
    
    Players.PlayerRemoving:Connect(function()
        self:updatePlayersList()
    end)
end

function BeautifulHUD:startUpdates()
    RunService.RenderStepped:Connect(function()
        -- تحديث FPS
        if self.config.showFPS and self.fpsCard then
            local fps = self.fpsMonitor:update()
            local valueLabel = self.fpsCard:FindFirstChild("Value")
            if valueLabel then
                valueLabel.Text = tostring(fps)
                valueLabel.TextColor3 = self.fpsMonitor:getColor(fps)
            end
        end
        
        -- تحديث الوقت
        if self.config.showTime and self.timeCard then
            local valueLabel = self.timeCard:FindFirstChild("Value")
            if valueLabel then
                valueLabel.Text = self.timeManager:getTime()
            end
        end
        
        -- تحديث اللاعبين كل 3 ثواني
        if self.config.showPlayers and tick() % 3 < 0.1 then
            self:updatePlayersList()
        end
    end)
end

function BeautifulHUD:toggle()
    self.isVisible = not self.isVisible
    self.mainFrame.Visible = self.isVisible
    
    if self.isVisible then
        self:animateIn()
    end
end

function BeautifulHUD:setTheme(themeName)
    if Themes[themeName] then
        self.config.theme = themeName
        -- يمكن إضافة منطق تغيير الثيم هنا
    end
end

function BeautifulHUD:showNotification()
    StarterGui:SetCore("SendNotification", {
        Title = "🎮 Beautiful HUD",
        Text = "تم التحميل بنجاح! اضغط F8 للتحكم",
        Duration = 5,
        Icon = "rbxassetid://4483345998"
    })
end

function BeautifulHUD:destroy()
    if self.screenGui then
        self.screenGui:Destroy()
    end
end

-- ============================================
-- 🚀 تشغيل تلقائي عند تحميل السكربت
-- ============================================
print("==========================================")
print("🎮 Beautiful HUD for Roblox")
print("📦 النسخة الكاملة - ملف واحد")
print("✨ بواسطة sd-community1")
print("==========================================")

-- انتظار تحميل اللاعب
if not Players.LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end

-- إنشاء وتشغيل HUD
local hud = BeautifulHUD.new({
    theme = "Dark",
    position = "TopRight",
    showFPS = true,
    showTime = true,
    showPlayers = true,
    transparency = 0.15,
    width = 280,
    height = 350,
    draggable = true,
    toggleKey = Enum.KeyCode.F8
})

hud:init()

-- حفظ للإستخدام الخارجي
_G.BeautifulHUD = hud

print("✅ Beautiful HUD جاهز للاستخدام!")
print("🎯 اضغط F8 لإظهار/إخفاء")
print("==========================================")

return hud
