--[[
  ⚡ السكربت النهائي للسرعة + القفز + ميزات إضافية ⚡
  تم التحديث والإصلاح مع واجهة تحكم كاملة
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- الإعدادات الأساسية
local guiVisible = true
local superSpeed = 50
local superJump = 100
local espEnabled = false
local noclipEnabled = false

-- تأكد من وجود اللاعب
repeat task.wait() until LocalPlayer.Character

-- واجهة المستخدم المحسنة
local EliteGUI = Instance.new("ScreenGui")
EliteGUI.Name = "EliteHUD_V2"
EliteGUI.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.2, 0, 0.3, 0)
MainFrame.Position = UDim2.new(0.78, 0, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Parent = EliteGUI

-- عناصر التحكم
local Title = Instance.new("TextLabel")
Title.Text = "⚡ SPEED CONTROL ⚡"
Title.TextColor3 = Color3.new(0, 1, 1)
Title.Font = Enum.Font.SciFi
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- سلايدر السرعة
local SpeedSlider = Instance.new("Frame")
SpeedSlider.Size = UDim2.new(0.9, 0, 0.1, 0)
SpeedSlider.Position = UDim2.new(0.05, 0, 0.15, 0)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SpeedSlider.Parent = MainFrame

local SpeedValue = Instance.new("TextLabel")
SpeedValue.Text = "السرعة: "..superSpeed
SpeedValue.TextColor3 = Color3.new(1, 1, 1)
SpeedValue.Font = Enum.Font.Code
SpeedValue.Size = UDim2.new(1, 0, 1, 0)
SpeedValue.BackgroundTransparency = 1
SpeedValue.Parent = SpeedSlider

-- سلايدر القفز
local JumpSlider = Instance.new("Frame")
JumpSlider.Size = UDim2.new(0.9, 0, 0.1, 0)
JumpSlider.Position = UDim2.new(0.05, 0, 0.3, 0)
JumpSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
JumpSlider.Parent = MainFrame

local JumpValue = Instance.new("TextLabel")
JumpValue.Text = "القفز: "..superJump
JumpValue.TextColor3 = Color3.new(1, 1, 1)
JumpValue.Font = Enum.Font.Code
JumpValue.Size = UDim2.new(1, 0, 1, 0)
JumpValue.BackgroundTransparency = 1
JumpValue.Parent = JumpSlider

-- أزرار التحكم
local function CreateButton(text, yPos, toggleVar)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0.12, 0)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.Text = text
    btn.Font = Enum.Font.SciFi
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.BorderColor3 = Color3.fromRGB(100, 100, 100)
    btn.Parent = MainFrame
    
    btn.MouseButton1Click:Connect(function()
        _G[toggleVar] = not _G[toggleVar]
        btn.BorderColor3 = _G[toggleVar] and Color3.new(0, 1, 0) or Color3.fromRGB(100, 100, 100)
    end)
end

CreateButton("تفعيل السرعة", 0.45, "SpeedEnabled")
CreateButton("تفعيل القفز", 0.6, "JumpEnabled")
CreateButton("وضع النوكلب", 0.75, "NoclipEnabled")

-- نظام السرعة المعدل
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if _G.SpeedEnabled then
                humanoid.WalkSpeed = superSpeed
            else
                humanoid.WalkSpeed = 16 -- السرعة العادية
            end
            
            if _G.JumpEnabled then
                humanoid.JumpPower = superJump
            else
                humanoid.JumpPower = 50 -- القفزة العادية
            end
        end
    end
end)

-- نظام النوكلب
local function NoclipLoop()
    if _G.NoclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

RunService.Stepped:Connect(NoclipLoop)

-- تحديث السلايدرات
local function UpdateSliders()
    SpeedValue.Text = "السرعة: "..superSpeed
    JumpValue.Text = "القفز: "..superJump
    
    -- تحريك السلايدر
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                local mousePos = UserInputService:GetMouseLocation()
                local sliderPos = SpeedSlider.AbsolutePosition
                local sliderSize = SpeedSlider.AbsoluteSize
                
                if mousePos.X >= sliderPos.X and mousePos.X <= sliderPos.X + sliderSize.X and
                   mousePos.Y >= sliderPos.Y and mousePos.Y <= sliderPos.Y + sliderSize.Y then
                    local percent = (mousePos.X - sliderPos.X) / sliderSize.X
                    superSpeed = math.floor(16 + (100 - 16) * percent)
                end
                
                sliderPos = JumpSlider.AbsolutePosition
                sliderSize = JumpSlider.AbsoluteSize
                
                if mousePos.X >= sliderPos.X and mousePos.X <= sliderPos.X + sliderSize.X and
                   mousePos.Y >= sliderPos.Y and mousePos.Y <= sliderPos.Y + sliderSize.Y then
                    local percent = (mousePos.X - sliderPos.X) / sliderSize.X
                    superJump = math.floor(50 + (200 - 50) * percent)
                end
            end
        end
    end)
end

UpdateSliders()

-- إخفاء الواجهة
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        guiVisible = not guiVisible
        EliteGUI.Enabled = guiVisible
    end
end)

-- رسالة التفعيل
print("🎮 تم تحميل سكربت التحكم بنجاح | اضغط RightShift لإخفاء الواجهة")
