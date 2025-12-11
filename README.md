# 🎮 Beautiful HUD for Roblox

واجهة عرض معلومات جميلة ومتطورة لروبلوكس

## ✨ المميزات
- عرض FPS دقيق مع ألوان متغيرة
- ساعة رقمية بتنسيق 24/12 ساعة
- قائمة لاعبين مع صور وأسماء
- تصميم عصري مع تأثيرات مرئية
- نظام ثيمات متعدد
- أداء عالي وخفيف

## 🚀 التثبيت
```lua
-- النسخة الكاملة
local HUD = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/Roblox-Beautiful-HUD/main/loader.lua"))()

HUD:Init({
    theme = "Dark",
    position = "TopLeft",
    showFPS = true,
    showTime = true,
    showPlayers = true
})
