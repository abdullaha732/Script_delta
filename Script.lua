--[[
  � سكربت السرعة الذكية للآيباد 🍏
  يدعم شاشات اللمس + لوحة المفاتيح مع ميزات متقدمة
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

-- إعدادات متوافقة مع الآيباد
local guiVisible = true
local superSpeed = 50
local superJump = 100
local noclipEnabled = false
local flyEnabled = false
local speedType = "Normal" -- Normal / Sprint / Turbo

-- إنشاء واجهة تعمل باللمس
local TouchGUI = Instance.new("ScreenGui")
TouchGUI.Name = "iPadHUD"
TouchGUI.DisplayOrder = 999
TouchGUI.Parent = GuiService

-- إطار التحكم الرئيسي
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(0.25, 0, 0.35, 0)
ControlFrame.Position = UDim2.new(0.72, 0, 0.6, 0)
ControlFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ControlFrame.BackgroundTransparency = 0.15
ControlFrame.BorderSizePixel = 0
ControlFrame.Parent = TouchGUI

-- لوحة السرعة
local SpeedPanel = Instance.new("Frame")
SpeedPanel.Size = UDim2.new(0.9, 0, 0.2, 0)
SpeedPanel.Position = UDim2.new(0.05, 0, 0.05, 0)
SpeedPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SpeedPanel.Parent = ControlFrame

local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(0.6, 0, 0.8, 0)
SpeedInput.Position = UDim2.new(0.2, 0, 0.1, 0)
SpeedInput.Text = tostring(superSpeed)
SpeedInput.PlaceholderText = "أدخل السرعة"
SpeedInput.TextColor3 = Color3.new(1, 1, 1)
SpeedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
SpeedInput.Font = Enum.Font.Code
SpeedInput.TextSize = 18
SpeedInput.Parent = SpeedPanel

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Text = "السرعة:"
SpeedLabel.Size = UDim2.new(0.15, 0, 0.8, 0)
SpeedLabel.Position = UDim2.new(0.02, 0, 0.1, 0)
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.Arabic
SpeedLabel.TextSize = 18
SpeedLabel.Parent = SpeedPanel

-- أنواع السرعة
local SpeedTypes = {"عادي", "عدو", "تيربو"}
local SpeedButtons = {}

for i, speed in ipairs(SpeedTypes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.28, 0, 0.15, 0)
    btn.Position = UDim2.new(0.05 + (i-1)*0.31, 0, 0.3, 0)
    btn.Text = speed
    btn.Font = Enum.Font.Arabic
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 50)
    btn.Parent = ControlFrame
    
    btn.MouseButton1Click:Connect(function()
        speedType = SpeedTypes[i]
        for _, button in ipairs(SpeedButtons) do
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        
        -- تعيين السرعة حسب النوع
        if speedType == "عادي" then
            superSpeed = 50
        elseif speedType == "عدو" then
            superSpeed = 75
        else
            superSpeed = 100
        end
        SpeedInput.Text = tostring(superSpeed)
    end)
    
    table.insert(SpeedButtons, btn)
end

-- أزرار التحكم الأساسية
local function CreateTouchButton(text, yPos, toggleVar, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.4, 0, 0.15, 0)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.Text = text
    btn.Font = Enum.Font.Arabic
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = color
    btn.Parent = ControlFrame
    
    btn.MouseButton1Click:Connect(function()
        _G[toggleVar] = not _G[toggleVar]
        btn.BackgroundColor3 = _G[toggleVar] and Color3.fromRGB(0, 100, 0) or color
    end)
    
    return btn
end

local JumpBtn = CreateTouchButton("قفز عالي", 0.5, "JumpEnabled", Color3.fromRGB(80, 40, 120))
local FlyBtn = CreateTouchButton("طيران", 0.7, "FlyEnabled", Color3.fromRGB(120, 40, 80))
local NoclipBtn = CreateTouchButton("نوكلب", 0.5, "NoclipEnabled", Color3.fromRGB(40, 80, 120))

-- نظام السرعة الذكي
SpeedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSpeed = tonumber(SpeedInput.Text)
        if newSpeed and newSpeed >= 16 and newSpeed <= 150 then
            superSpeed = newSpeed
        else
            SpeedInput.Text = tostring(superSpeed)
        end
    end
end)

-- نظام الحركة الأساسي
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- السرعة
            if _G.SpeedEnabled then
                humanoid.WalkSpeed = superSpeed
            else
                humanoid.WalkSpeed = 16
            end
            
            -- القفز
            if _G.JumpEnabled then
                humanoid.JumpPower = superJump
            else
                humanoid.JumpPower = 50
            end
            
            -- الطيران
            if _G.FlyEnabled then
                humanoid:ChangeState(Enum.HumanoidStateType.Flying)
            end
        end
    end
end)

-- نظام النوكلب
RunService.Stepped:Connect(function()
    if _G.NoclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- إخفاء الواجهة باللمس
local HideButton = CreateTouchButton("إخفاء", 0.7, nil, Color3.fromRGB(100, 0, 0))
HideButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    TouchGUI.Enabled = guiVisible
end)

-- دعم لوحة المفاتيح
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        guiVisible = not guiVisible
        TouchGUI.Enabled = guiVisible
    end
end)

-- رسالة التفعيل
print("📱 تم تحميل سكربت الآيباد بنجاح | اضغط على زر الإخفاء أو RightShift") 
