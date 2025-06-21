local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "Menu506Code"
gui.ResetOnSpawn = false

-- أصوات
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12222030"
clickSound.Volume = 0.6

local closeSound = Instance.new("Sound", gui)
closeSound.SoundId = "rbxassetid://138087620"
closeSound.Volume = 1

-- زر إظهار/إخفاء
local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0, 180, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleButton.Text = "📂 عرض / إخفاء"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true

-- الإطار الرئيسي
local menuFrame = Instance.new("ScrollingFrame", gui)
menuFrame.Size = UDim2.new(0, 280, 0, 550)
menuFrame.Position = UDim2.new(0, 20, 0, 80)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menuFrame.ScrollBarThickness = 8
menuFrame.CanvasSize = UDim2.new(0, 0, 0, 1100)
menuFrame.Visible = true

-- العنوان
local title = Instance.new("TextLabel", menuFrame)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "🔥 قائمة 506كود 🔥"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- الأزرار والمزايا
local features = {
    {"🕊️ طيران", function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = true end
            char:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0, 100, 0)
        end
    end},

    {"👻 اختفاء", function()
        for _, p in pairs(player.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.Transparency = 1 end
        end
    end},

    {"🦘 قفز عالي", function()
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = 150 end
    end},

    {"🏃‍♂️ سرعة عالية", function()
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 100 end
    end},

    {"🔋 جاذبية صفر", function()
        workspace.Gravity = 0
    end},

    {"💡 إضاءة قوية", function()
        game.Lighting.Brightness = 5
        game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    end},

    {"🌙 الوضع الليلي", function()
        game.Lighting.TimeOfDay = "00:00:00"
        game.Lighting.Brightness = 0.2
        game.Lighting.Ambient = Color3.fromRGB(30, 30, 30)
    end},

    {"🔇 كتم الأصوات", function()
        for _, s in pairs(workspace:GetDescendants()) do
            if s:IsA("Sound") then s.Volume = 0 end
        end
    end},

    {"🔊 إرجاع الأصوات", function()
        for _, s in pairs(workspace:GetDescendants()) do
            if s:IsA("Sound") then s.Volume = 1 end
        end
    end},

    {"🧼 إعادة الظهور", function()
        player:LoadCharacter()
    end},

    {"🧊 تجميد", function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = true end
    end},

    {"🕸️ وضع سبايدرمان", function()
        local part = Instance.new("Part", workspace)
        part.Size = Vector3.new(1,1,1)
        part.Anchored = true
        part.Position = player.Character.HumanoidRootPart.Position + player.Character.HumanoidRootPart.CFrame.LookVector * 50
        part.BrickColor = BrickColor.Red()

        local rope = Instance.new("Beam", part)
        rope.Attachment0 = Instance.new("Attachment", part)
        rope.Attachment1 = Instance.new("Attachment", player.Character.HumanoidRootPart)
        rope.Width0 = 0.2
        rope.Width1 = 0.2
    end},

    {"🧲 جذب اللاعبين", function()
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
            end
        end
    end},

    {"💥 انفجار", function()
        local boom = Instance.new("Explosion", workspace)
        boom.Position = player.Character.HumanoidRootPart.Position
        boom.BlastRadius = 20
        boom.BlastPressure = 500000
    end},

    {"🛡️ درع حماية", function()
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then hum.Health = math.huge end
    end},

    {"🔒 تثبيت السرعة", function()
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then
            hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                hum.WalkSpeed = 100
            end)
            hum.WalkSpeed = 100
        end
    end},

    {"💣 قنبلة مفاجئة", function()
        local bomb = Instance.new("Part", workspace)
        bomb.Position = player.Character.HumanoidRootPart.Position - Vector3.new(0,2,0)
        bomb.Size = Vector3.new(2,2,2)
        bomb.BrickColor = BrickColor.Black()
        bomb.Anchored = true
        wait(1)
        local boom = Instance.new("Explosion", workspace)
        boom.Position = bomb.Position
        bomb:Destroy()
    end},

    {"🚪 خروج نهائي", function()
        closeSound:Play()
        wait(0.5)
        gui:Destroy()
    end}
}

-- توليد الأزرار
for i, feat in ipairs(features) do
    local btn = Instance.new("TextButton", menuFrame)
    btn.Size = UDim2.new(1, -20, 0, 50)
    btn.Position = UDim2.new(0, 10, 0, 60 + (i - 1) * 55)
    btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Text = feat[1]
    
    btn.MouseButton1Click:Connect(function()
        clickSound:Play()
        feat[2]()
    end)
end

-- زر إظهار / إخفاء القائمة
toggleButton.MouseButton1Click:Connect(function()
    clickSound:Play()
    menuFrame.Visible = not menuFrame.Visible
end)
