local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Panel = {}
Panel.__index = Panel

function Panel.new(settings)
    local self = setmetatable({}, Panel)
    
    self.Settings = settings
    self.Container = nil
    self.Elements = {}
    
    return self
end

function Panel:Create()
    -- إناء رئيسي بتصميم عصري
    self.Container = Instance.new("Frame")
    self.Container.Name = "BeautifulHUD_Panel"
    self.Container.Size = UDim2.new(0.22, 0, 0.3, 0)
    self.Container.Position = UDim2.new(0.015, 0, 0.015, 0)
    self.Container.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    self.Container.BackgroundTransparency = 0.15
    
    -- زوايا مستديرة
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.Container
    
    -- ظل أنيق
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(100, 100, 200)
    shadow.Thickness = 2
    shadow.Transparency = 0.3
    shadow.Parent = self.Container
    
    -- تدرج لوني
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
    })
    gradient.Rotation = 45
    gradient.Parent = self.Container
    
    -- رأس اللوحة
    local header = self:CreateHeader()
    header.Parent = self.Container
    
    -- قسم المعلومات
    local infoSection = self:CreateInfoSection()
    infoSection.Parent = self.Container
    
    -- قسم اللاعبين
    local playersSection = self:CreatePlayersSection()
    playersSection.Parent = self.Container
    
    -- زر التخصيص
    local settingsBtn = self:CreateSettingsButton()
    settingsBtn.Parent = self.Container
    
    self.Container.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- تأثير الظهور
    self:AnimateIn()
end

function Panel:CreateHeader()
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0.12, 0)
    header.BackgroundTransparency = 1
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "🎮 Beautiful HUD"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(200, 200, 255)
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    
    -- خط تحت العنوان
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -20, 0, 1)
    line.Position = UDim2.new(0, 10, 1, 0)
    line.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    line.BorderSizePixel = 0
    
    title.Parent = header
    line.Parent = header
    
    return header
end

function Panel:CreateInfoSection()
    local section = Instance.new("Frame")
    section.Name = "InfoSection"
    section.Size = UDim2.new(1, -20, 0.25, 0)
    section.Position = UDim2.new(0, 10, 0.15, 0)
    section.BackgroundTransparency = 1
    
    -- شبكة لعرض المعلومات
    local layout = Instance.new("UIGridLayout")
    layout.CellSize = UDim2.new(0.48, 0, 1, 0)
    layout.CellPadding = UDim2.new(0.02, 0, 0, 0)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Parent = section
    
    -- بطاقة FPS
    local fpsCard = self:CreateInfoCard("FPS", "144", "⚡")
    fpsCard.Parent = section
    
    -- بطاقة الوقت
    local timeCard = self:CreateInfoCard("الوقت", "12:30:45", "🕒")
    timeCard.Parent = section
    
    self.Elements.FPS = fpsCard:FindFirstChild("Value")
    self.Elements.Time = timeCard:FindFirstChild("Value")
    
    return section
end

function Panel:CreateInfoCard(title, value, icon)
    local card = Instance.new("Frame")
    card.Name = title .. "Card"
    card.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    card.BackgroundTransparency = 0.3
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 8)
    padding.Parent = card
    
    -- الأيقونة
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Text = icon
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 20
    iconLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    iconLabel.Size = UDim2.new(0, 30, 0, 30)
    iconLabel.BackgroundTransparency = 1
    
    -- العنوان
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.TextSize = 12
    titleLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    titleLabel.Position = UDim2.new(0, 35, 0, 0)
    titleLabel.Size = UDim2.new(1, -35, 0, 20)
    titleLabel.BackgroundTransparency = 1
    
    -- القيمة
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Text = value
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 16
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Position = UDim2.new(0, 35, 0, 20)
    valueLabel.Size = UDim2.new(1, -35, 0, 25)
    valueLabel.BackgroundTransparency = 1
    
    iconLabel.Parent = card
    titleLabel.Parent = card
    valueLabel.Parent = card
    
    return card
end

function Panel:UpdateFPS(fps)
    if self.Elements.FPS then
        local color = fps > 60 and Color3.fromRGB(100, 255, 100)
                    or fps > 30 and Color3.fromRGB(255, 200, 100)
                    or Color3.fromRGB(255, 100, 100)
        
        self.Elements.FPS.Text = tostring(math.floor(fps))
        self.Elements.FPS.TextColor3 = color
    end
end

function Panel:UpdateTime(time)
    if self.Elements.Time then
        self.Elements.Time.Text = time
    end
end

function Panel:AnimateIn()
    if self.Container then
        self.Container.Position = UDim2.new(-0.3, 0, 0.015, 0)
        
        local tween = TweenService:Create(
            self.Container,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.015, 0, 0.015, 0)}
        )
        
        tween:Play()
    end
end

return Panel
