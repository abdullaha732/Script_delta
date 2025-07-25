local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- إعدادات متقدمة
local guiVisible = true
local superSpeed = 50
local superJump = 120
local espEnabled = false
local wallhackEnabled = false

-- واجهة فخمة متحركة
local EliteGUI = Instance.new("ScreenGui")
EliteGUI.Name = "EliteHUD"
EliteGUI.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.18, 0, 0.25, 0)
MainFrame.Position = UDim2.new(0.8, 0, 0.02, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Parent = EliteGUI

-- تأثير توهج متحرك
coroutine.wrap(function()
    while true do
        for i = 0, 1, 0.01 do
            MainFrame.BorderColor3 = Color3.fromHSV(i, 0.8, 1)
            task.wait(0.05)
        end
    end
end)()

-- عناصر واجهة متطورة
local Title = Instance.new("TextLabel")
Title.Text = "⚡ ELITE HACK SUITE ⚡"
Title.Size = UDim2.new(1, 0, 0.15, 0)
Title.Font = Enum.Font.SciFi
Title.TextColor3 = Color3.new(0, 1, 1)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local function CreateSlider(name, yPos, minVal, maxVal, defaultVal)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0.12, 0)
    sliderFrame.Position = UDim2.new(0.05, 0, yPos, 0)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sliderFrame.Parent = MainFrame
    
    local sliderName = Instance.new("TextLabel")
    sliderName.Text = name
    sliderName.Size = UDim2.new(1, 0, 0.5, 0)
    sliderName.Font = Enum.Font.Code
    sliderName.TextSize = 12
    sliderName.TextColor3 = Color3.new(1, 1, 1)
    sliderName.BackgroundTransparency = 1
    sliderName.Parent = sliderFrame
    
    local sliderValue = Instance.new("TextLabel")
    sliderValue.Text = defaultVal
    sliderValue.Size = UDim2.new(1, 0, 0.5, 0)
    sliderValue.Position = UDim2.new(0, 0, 0.5, 0)
    sliderValue.Font = Enum.Font.SciFi
    sliderValue.TextColor3 = Color3.new(0, 1, 1)
    sliderValue.BackgroundTransparency = 1
    sliderValue.Parent = sliderFrame
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Parent = sliderFrame
    
    sliderButton.MouseButton1Down:Connect(function()
        local startX = sliderButton.AbsolutePosition.X
        local endX = startX + sliderButton.AbsoluteSize.X
        
        local connection
        connection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = math.clamp((input.Position.X - startX) / (endX - startX), 0, 1)
                local value = math.floor(minVal + (maxVal - minVal) * percent)
                sliderValue.Text = value
                
                if name == "SPEED" then
                    superSpeed = value
                elseif name == "JUMP" then
                    superJump = value
                end
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
end

-- إنشاء سلايدرات التحكم
CreateSlider("SPEED", 0.16, 16, 100, 50)
CreateSlider("JUMP", 0.29, 50, 200, 120)

-- أزرار متطورة
local function CreateEliteButton(text, yPos, toggleVar, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0.12, 0)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.Text = text
    btn.Font = Enum.Font.SciFi
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderColor3 = color
    btn.Parent = MainFrame
    
    btn.MouseButton1Click:Connect(function()
        _G[toggleVar] = not _G[toggleVar]
        btn.BorderColor3 = _G[toggleVar] and Color3.new(0, 1, 0) or color
    end)
    
    return btn
end

local espBtn = CreateEliteButton("ESP", 0.42, "ESPEnabled", Color3.fromRGB(255, 50, 50))
local wallhackBtn = CreateEliteButton("WALLHACK", 0.55, "WallhackEnabled", Color3.fromRGB(50, 50, 255))
local hitboxBtn = CreateEliteButton("HITBOX", 0.68, "HitboxEnabled", Color3.fromRGB(255, 255, 50))

-- نظام الحركات الخارقة
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if _G.SuperSpeed then humanoid.WalkSpeed = superSpeed end
            if _G.SuperJump then humanoid.JumpPower = superJump end
        end
    end
end)

-- نظام ESP متطور
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")
    
    -- مربع ESP
    local espBox = Instance.new("BoxHandleAdornment")
    espBox.Name = "ESPBox"
    espBox.Adornee = head
    espBox.AlwaysOnTop = true
    espBox.ZIndex = 10
    espBox.Size = Vector3.new(2, 2, 2)
    espBox.Transparency = 0.7
    espBox.Color3 = player.TeamColor.Color
    espBox.Parent = head
    
    -- معلومات اللاعب
    local espInfo = Instance.new("BillboardGui")
    espInfo.Name = "ESPInfo"
    espInfo.Size = UDim2.new(0, 200, 0, 60)
    espInfo.AlwaysOnTop = true
    espInfo.Parent = head
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Parent = espInfo
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.new(1, 1, 1)
    distLabel.BackgroundTransparency = 1
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.Parent = espInfo
    
    -- تحديث مستمر
    coroutine.wrap(function()
        while character and character.Parent do
            if _G.ESPEnabled then
                espBox.Visible = true
                espInfo.Enabled = true
                
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude
                distLabel.Text = string.format("%.1fm", dist)
                
                -- تأثير النبض
                espBox.Size = Vector3.new(2.2, 2.2, 2.2)
                TweenService:Create(espBox, TweenInfo.new(0.5), {Size = Vector3.new(2, 2, 2)}):Play()
            else
                espBox.Visible = false
                espInfo.Enabled = false
            end
            task.wait(0.2)
        end
    end)()
end

-- نظام Wallhack
local function UpdateWallhack()
    if not _G.WallhackEnabled then return end
    
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 0.5 and part.Name ~= "HumanoidRootPart" then
            part.LocalTransparencyModifier = 0.7
            part.Material = EnumMaterial.Neon
            part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        end
    end
end

-- نظام Hitbox
local function UpdateHitbox()
    if not _G.HitboxEnabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Size = Vector3.new(5, 5, 5)
                humanoidRootPart.Transparency = 0.8
                humanoidRootPart.Color = Color3.new(1, 0, 0)
            end
        end
    end
end

-- التفعيل التلقائي
Players.PlayerAdded:Connect(CreateESP)
for _, player in ipairs(Players:GetPlayers()) do
    CreateESP(player)
end

-- التحديث المستمر
RunService.Heartbeat:Connect(function()
    if _G.WallhackEnabled then UpdateWallhack() end
    if _G.HitboxEnabled then UpdateHitbox() end
end)

-- إخفاء الواجهة
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        guiVisible = not guiVisible
        EliteGUI.Enabled = guiVisible
    end
end)

-- رسالة التفعيل
print("🔥 ELITE HACK SUITE ACTIVATED | PRESS RIGHT SHIFT TO TOGGLE UI 🔥")

