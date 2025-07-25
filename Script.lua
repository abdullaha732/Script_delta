--[[
  🎮 واجهة هاك بلوكس فروت كاملة مع تأثيرات مرئية 🎮
  تصميم عصري يدعم اللمس + لوحة المفاتيح
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- إعدادات الميزات
local Settings = {
    Speed = {Value = 50, Active = false},
    Jump = {Value = 100, Active = false},
    Noclip = {Active = false},
    Fly = {Active = false},
    ESP = {Active = false},
    Hitbox = {Value = 5, Active = false}
}

-- إنشاء الواجهة الرئيسية
local MainGUI = Instance.new("ScreenGui")
MainGUI.Name = "BloxFruitHack"
MainGUI.Parent = game.CoreGui

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.25, 0, 0.4, 0)
MainFrame.Position = UDim2.new(0.7, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGUI

-- تأثير توهج متحرك
local GlowEffect = Instance.new("UIStroke")
GlowEffect.Color = Color3.fromRGB(0, 150, 255)
GlowEffect.Thickness = 2
GlowEffect.Transparency = 0.5
GlowEffect.Parent = MainFrame

coroutine.wrap(function()
    while true do
        for i = 0, 1, 0.01 do
            GlowEffect.Color = Color3.fromHSV(i, 0.8, 1)
            task.wait(0.05)
        end
    end
end)()

-- عنوان الواجهة
local Title = Instance.new("TextLabel")
Title.Text = "🍊 BLOX FRUIT HACK 🍊"
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.Font = Enum.Font.SciFi
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- إنشاء أزرار التحكم
local function CreateButton(text, yPos, settingName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0.12, 0)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.BorderSizePixel = 0
    btn.Parent = MainFrame
    
    local btnGlow = Instance.new("UIStroke")
    btnGlow.Color = Color3.fromRGB(100, 100, 100)
    btnGlow.Thickness = 1
    btnGlow.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Settings[settingName].Active = not Settings[settingName].Active
        btnGlow.Color = Settings[settingName].Active and Color3.new(0, 1, 0) or Color3.fromRGB(100, 100, 100)
        
        -- تأثير النبض عند النقر
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.85, 0, 0.11, 0)}):Play()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.9, 0, 0.12, 0)}):Play()
    end)
    
    return btn
end

-- إنشاء أزرار الميزات
local SpeedBtn = CreateButton("⚡ السرعة السريعة ("..Settings.Speed.Value..")", 0.12, "Speed")
local JumpBtn = CreateButton("🦘 القفز العالي ("..Settings.Jump.Value..")", 0.26, "Jump")
local NoclipBtn = CreateButton("👻 نوكلب", 0.4, "Noclip")
local FlyBtn = CreateButton("✈️ طيران", 0.54, "Fly")
local ESPBtn = CreateButton("👁️ ESP", 0.68, "ESP")
local HitboxBtn = CreateButton("🎯 هيت بوكس ("..Settings.Hitbox.Value..")", 0.82, "Hitbox")

-- نظام التحكم في الميزات
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- السرعة
            humanoid.WalkSpeed = Settings.Speed.Active and Settings.Speed.Value or 16
            
            -- القفز
            humanoid.JumpPower = Settings.Jump.Active and Settings.Jump.Value or 50
            
            -- الطيران
            if Settings.Fly.Active then
                humanoid:ChangeState(Enum.HumanoidStateType.Flying)
            end
        end
    end
end)

-- نظام النوكلب
RunService.Stepped:Connect(function()
    if Settings.Noclip.Active and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- إخفاء/إظهار الواجهة
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- رسالة تفعيل
print("🎮 واجهة هاك بلوكس فروت جاهزة! اضغط RightControl لإخفاء/إظهار الواجهة")
