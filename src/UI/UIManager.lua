-- ============================================
-- 🎨 UI Manager Module
-- 🖼️ مدير الواجهات وتنظيم العناصر
-- ✨ جزء من Beautiful HUD
-- ============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local UIManager = {}
UIManager.__index = UIManager

-- ============================================
-- 🎯 التهيئة
-- ============================================
function UIManager.new(config)
    local self = setmetatable({}, UIManager)
    
    -- الإعدادات
    self.config = config or {}
    
    -- المتغيرات
    self.playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    self.screenGui = nil
    self.elements = {}
    self.themes = {}
    self.currentTheme = "Dark"
    
    -- التوصيلات
    self.connections = {}
    
    -- الحالة
    self.isInitialized = false
    self.isVisible = true
    
    return self
end

-- ============================================
-- 🏗️ بناء الواجهة
-- ============================================
function UIManager:initialize()
    if self.isInitialized then
        warn("[UIManager] الواجهة مهيئة بالفعل!")
        return
    end
    
    print("[UIManager] جاري تهيئة مدير الواجهة...")
    
    -- إنشاء ScreenGui
    self:createScreenGui()
    
    -- تحميل الثيمات
    self:loadThemes()
    
    -- إنشاء العناصر الأساسية
    self:createBaseElements()
    
    -- إعداد الأحداث
    self:setupEvents()
    
    self.isInitialized = true
    print("[UIManager] ✅ تم التهيئة")
end

function UIManager:createScreenGui()
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "BeautifulHUD_UI"
    self.screenGui.DisplayOrder = 999
    self.screenGui.IgnoreGuiInset = true
    self.screenGui.ResetOnSpawn = false
    self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    self.screenGui.Parent = self.playerGui
end

function UIManager:loadThemes()
    -- الثيمات الأساسية
    self.themes = {
        Dark = {
            colors = {
                background = Color3.fromRGB(20, 20, 30),
                surface = Color3.fromRGB(30, 30, 45),
                primary = Color3.fromRGB(100, 150, 255),
                text = Color3.fromRGB(240, 240, 240),
                textSecondary = Color3.fromRGB(180, 180, 200)
            },
            transparency = 0.15
        },
        
        Light = {
            colors = {
                background = Color3.fromRGB(245, 245, 250),
                surface = Color3.fromRGB(255, 255, 255),
                primary = Color3.fromRGB(80, 120, 200),
                text = Color3.fromRGB(30, 30, 40),
                textSecondary = Color3.fromRGB(100, 100, 120)
            },
            transparency = 0.1
        }
    }
end

function UIManager:createBaseElements()
    -- العناصر الرئيسية
    self.elements = {
        containers = {},
        labels = {},
        buttons = {},
        frames = {}
    }
    
    -- حاوية رئيسية
    self.elements.mainContainer = self:createElement("Frame", {
        Name = "MainContainer",
        Size = UDim2.new(0, self.config.width or 280, 0, self.config.height or 350),
        Position = self:calculatePosition(self.config.position or "TopRight"),
        BackgroundColor3 = self.themes[self.currentTheme].colors.background,
        BackgroundTransparency = self.config.transparency or 0.15,
        BorderSizePixel = 0
    })
    
    -- زوايا مستديرة
    self:createElement("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = self.elements.mainContainer
    })
    
    -- تأثير ظل
    self:createElement("UIStroke", {
        Color = self.themes[self.currentTheme].colors.primary,
        Thickness = 2,
        Transparency = 0.3,
        Parent = self.elements.mainContainer
    })
    
    -- تدرج لوني
    self:createElement("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, self.themes[self.currentTheme].colors.background),
            ColorSequenceKeypoint.new(1, self.themes[self.currentTheme].colors.surface)
        }),
        Rotation = 45,
        Parent = self.elements.mainContainer
    })
    
    -- إضافة للحاوية الرئيسية
    self.elements.mainContainer.Parent = self.screenGui
end

-- ============================================
-- 🛠️ دوال إنشاء العناصر
-- ============================================
function UIManager:createElement(className, properties)
    local element = Instance.new(className)
    
    for property, value in pairs(properties) do
        if property == "Parent" then
            element.Parent = value
        else
            element[property] = value
        end
    end
    
    return element
end

function UIManager:createTextLabel(name, text, size, position, options)
    options = options or {}
    
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Text = text
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.TextColor3 = options.textColor or self.themes[self.currentTheme].colors.text
    label.TextSize = options.textSize or 14
    label.Font = options.font or Enum.Font.Gotham
    label.TextXAlignment = options.xAlignment or Enum.TextXAlignment.Left
    label.TextYAlignment = options.yAlignment or Enum.TextYAlignment.Top
    
    if options.parent then
        label.Parent = options.parent
    end
    
    return label
end

function UIManager:createFrame(name, size, position, options)
    options = options or {}
    
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = options.backgroundColor or self.themes[self.currentTheme].colors.surface
    frame.BackgroundTransparency = options.transparency or 0.3
    frame.BorderSizePixel = 0
    
    -- زوايا مستديرة
    if options.cornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, options.cornerRadius)
        corner.Parent = frame
    end
    
    -- تأثير الظل
    if options.stroke then
        local stroke = Instance.new("UIStroke")
        stroke.Color = options.strokeColor or self.themes[self.currentTheme].colors.primary
        stroke.Thickness = options.strokeThickness or 1
        stroke.Transparency = options.strokeTransparency or 0.5
        stroke.Parent = frame
    end
    
    if options.parent then
        frame.Parent = options.parent
    end
    
    return frame
end

function UIManager:createButton(name, text, size, position, callback, options)
    options = options or {}
    
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = text
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = options.backgroundColor or self.themes[self.currentTheme].colors.primary
    button.BackgroundTransparency = options.transparency or 0.3
    button.TextColor3 = options.textColor or self.themes[self.currentTheme].colors.text
    button.TextSize = options.textSize or 14
    button.Font = options.font or Enum.Font.Gotham
    button.AutoButtonColor = options.autoButtonColor ~= false
    button.BorderSizePixel = 0
    
    -- زوايا مستديرة
    if options.cornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, options.cornerRadius)
        corner.Parent = button
    end
    
    -- تأثيرات التفاعل
    if callback then
        button.MouseButton1Click:Connect(function()
            self:playClickEffect(button)
            callback()
        end)
    end
    
    -- تأثيرات المرور
    if options.hoverEffects ~= false then
        button.MouseEnter:Connect(function()
            self:tween(button, {
                BackgroundTransparency = options.transparency and (options.transparency * 0.5) or 0.15,
                TextColor3 = Color3.new(1, 1, 1)
            }, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            self:tween(button, {
                BackgroundTransparency = options.transparency or 0.3,
                TextColor3 = options.textColor or self.themes[self.currentTheme].colors.text
            }, 0.2)
        end)
    end
    
    if options.parent then
        button.Parent = options.parent
    end
    
    return button
end

-- ============================================
-- 🎨 إدارة الثيمات
-- ============================================
function UIManager:setTheme(themeName)
    if not self.themes[themeName] then
        warn("[UIManager] الثيم غير موجود:", themeName)
        return false
    end
    
    self.currentTheme = themeName
    self:applyTheme()
    return true
end

function UIManager:applyTheme()
    if not self.isInitialized then return end
    
    local theme = self.themes[self.currentTheme]
    
    -- تحديث العناصر الرئيسية
    if self.elements.mainContainer then
        self:tween(self.elements.mainContainer, {
            BackgroundColor3 = theme.colors.background,
            BackgroundTransparency = self.config.transparency or theme.transparency
        }, 0.3)
        
        -- تحديث الظل
        local stroke = self.elements.mainContainer:FindFirstChild("UIStroke")
        if stroke then
            self:tween(stroke, {Color = theme.colors.primary}, 0.3)
        end
    end
    
    print("[UIManager] 🎨 تم تطبيق الثيم:", self.currentTheme)
end

function UIManager:addTheme(name, themeData)
    self.themes[name] = themeData
    print("[UIManager] ✨ تم إضافة ثيم جديد:", name)
end

-- ============================================
-- 🎬 الحركات والتأثيرات
-- ============================================
function UIManager:tween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function UIManager:playClickEffect(button)
    local originalSize = button.Size
    local originalPosition = button.Position
    
    -- تأثير الضغط
    self:tween(button, {
        Size = originalSize - UDim2.new(0.05, 0, 0.05, 0),
        Position = originalPosition + UDim2.new(0.025, 0, 0.025, 0)
    }, 0.1)
    
    task.wait(0.1)
    
    -- العودة للحالة الأصلية
    self:tween(button, {
        Size = originalSize,
        Position = originalPosition
    }, 0.1)
end

function UIManager:shakeElement(element, intensity)
    local originalPosition = element.Position
    intensity = intensity or 5
    
    for i = 1, 3 do
        local offset = intensity * (i/3)
        element.Position = originalPosition + UDim2.new(
            0, math.random(-offset, offset),
            0, math.random(-offset, offset)
        )
        RunService.Heartbeat:Wait()
    end
    
    element.Position = originalPosition
end

function UIManager:fadeIn(element, duration)
    element.Visible = true
    element.BackgroundTransparency = 1
    
    if element:IsA("TextLabel") or element:IsA("TextButton") then
        element.TextTransparency = 1
    end
    
    self:tween(element, {
        BackgroundTransparency = element.BackgroundTransparency,
        TextTransparency = 0
    }, duration or 0.5)
end

function UIManager:fadeOut(element, duration)
    self:tween(element, {
        BackgroundTransparency = 1,
        TextTransparency = 1
    }, duration or 0.5)
    
    task.wait(duration or 0.5)
    element.Visible = false
end

-- ============================================
-- 📍 إدارة المواقع
-- ============================================
function UIManager:calculatePosition(positionName)
    local positions = {
        TopLeft = UDim2.new(0, 15, 0, 15),
        TopRight = UDim2.new(1, -self.config.width - 15, 0, 15),
        BottomLeft = UDim2.new(0, 15, 1, -self.config.height - 15),
        BottomRight = UDim2.new(1, -self.config.width - 15, 1, -self.config.height - 15),
        Center = UDim2.new(0.5, -self.config.width/2, 0.5, -self.config.height/2)
    }
    
    return positions[positionName] or positions.TopRight
end

function UIManager:setPosition(positionName)
    if not self.elements.mainContainer then return end
    
    local newPosition = self:calculatePosition(positionName)
    self:tween(self.elements.mainContainer, {Position = newPosition}, 0.3)
    self.config.position = positionName
    
    print("[UIManager] 📍 تم تغيير الموقع إلى:", positionName)
end

-- ============================================
-- 👁️ إدارة الرؤية
-- ============================================
function UIManager:toggleVisibility()
    self.isVisible = not self.isVisible
    
    if self.elements.mainContainer then
        self.elements.mainContainer.Visible = self.isVisible
        
        if self.isVisible then
            self:animateIn()
        else
            self:animateOut()
        end
    end
    
    return self.isVisible
end

function UIManager:animateIn()
    if not self.elements.mainContainer then return end
    
    local startPos = self.elements.mainContainer.Position
    self.elements.mainContainer.Position = startPos - UDim2.new(0, 0, 0.2, 0)
    self.elements.mainContainer.BackgroundTransparency = 1
    
    self:tween(self.elements.mainContainer, {
        Position = startPos,
        BackgroundTransparency = self.config.transparency or 0.15
    }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function UIManager:animateOut()
    if not self.elements.mainContainer then return end
    
    local endPos = self.elements.mainContainer.Position - UDim2.new(0, 0, 0.2, 0)
    
    self:tween(self.elements.mainContainer, {
        Position = endPos,
        BackgroundTransparency = 1
    }, 0.3)
end

-- ============================================
-- ⚙️ إعداد الأحداث
-- ============================================
function UIManager:setupEvents()
    -- قابلية السحب
    if self.config.draggable and self.elements.mainContainer then
        self:makeDraggable(self.elements.mainContainer)
    end
    
    -- أزرار التحكم
    if self.config.toggleKey then
        self.connections.toggleKey = UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == self.config.toggleKey then
                self:toggleVisibility()
            end
        end)
    end
end

function UIManager:makeDraggable(frame)
    local dragging = false
    local dragStart, frameStart
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            frameStart = frame.Position
        end
    end)
    
    self.connections.dragChanged = UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                frameStart.X.Scale,
                frameStart.X.Offset + delta.X,
                frameStart.Y.Scale,
                frameStart.Y.Offset + delta.Y
            )
        end
    end)
    
    self.connections.dragEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- ============================================
-- 🧹 التنظيف
-- ============================================
function UIManager:destroy()
    -- فصل التوصيلات
    for _, connection in pairs(self.connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    -- تدمير الواجهة
    if self.screenGui then
        self.screenGui:Destroy()
        self.screenGui = nil
    end
    
    -- مسح البيانات
    self.elements = {}
    self.connections = {}
    self.isInitialized = false
    
    print("[UIManager] 🗑️ تم تدمير مدير الواجهة")
end

-- ============================================
-- 🔧 واجهة API عامة
-- ============================================
function UIManager:getElement(name)
    return self.elements[name]
end

function UIManager:show()
    if not self.isVisible then
        self:toggleVisibility()
    end
end

function UIManager:hide()
    if self.isVisible then
        self:toggleVisibility()
    end
end

function UIManager:updateConfig(newConfig)
    for key, value in pairs(newConfig) do
        self.config[key] = value
    end
    
    -- إعادة تطبيق التغييرات
    if self.isInitialized then
        self:applyTheme()
        if newConfig.position then
            self:setPosition(newConfig.position)
        end
    end
end

return UIManager
