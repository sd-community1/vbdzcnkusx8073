local TweenService = game:GetService("TweenService")

local Animation = {}

-- مكتبة تأثيرات جاهزة
Animation.Presets = {
    BounceIn = {
        Info = TweenInfo.new(0.6, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
        Properties = {Position = UDim2.new(0.015, 0, 0.015, 0)}
    },
    
    FadeIn = {
        Info = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Properties = {BackgroundTransparency = 0.15}
    },
    
    Pulse = {
        Info = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true, 0),
        Properties = {Size = UDim2.new(0.23, 0, 0.32, 0)}
    },
    
    Shake = {
        Info = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 6, false, 0),
        Properties = {Position = UDim2.new(0.014, 0, 0.016, 0)}
    }
}

function Animation:Tween(object, presetName)
    local preset = self.Presets[presetName]
    if not preset then return end
    
    local tween = TweenService:Create(object, preset.Info, preset.Properties)
    tween:Play()
    return tween
end

-- تأثير اهتزاز عند التحديث
function Animation:ShakeElement(element, intensity)
    local originalPos = element.Position
    
    for i = 1, 3 do
        local offset = intensity * (i/3)
        element.Position = UDim2.new(
            originalPos.X.Scale, 
            originalPos.X.Offset + math.random(-offset, offset),
            originalPos.Y.Scale,
            originalPos.Y.Offset + math.random(-offset, offset)
        )
        wait(0.03)
    end
    
    element.Position = originalPos
end

-- تأثير كتابة نص
function Animation:TypewriterEffect(label, text, speed)
    label.Text = ""
    
    for i = 1, #text do
        label.Text = string.sub(text, 1, i)
        task.wait(speed)
    end
end

return Animation
