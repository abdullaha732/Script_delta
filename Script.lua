local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local noclip = false
local invisible = false
local fast = false
local normalSpeed = humanoid.WalkSpeed

-- سرعة ثابتة 100
local insaneSpeed = 100

-- متغير لتتبع حالة الإختفاء
local isCurrentlyInvisible = false

-- وظيفة لجعل الشخصية غير مرئية بالكامل
local function makeInvisible()
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CastShadow = false
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 1
        elseif part:IsA("Accessory") then
            part.Handle.Transparency = 1
        end
    end
    
    -- إخفاء الاسم والعلامات
    humanoid.NameDisplayDistance = 0
    humanoid.HealthDisplayDistance = 0
    
    -- إخفاء تأثيرات الحركة
    if char:FindFirstChild("Animate") then
        char.Animate:Destroy()
    end
    
    -- إخفاء الفيزياء
    if char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Transparency = 1
    end
    
    isCurrentlyInvisible = true
end

-- وظيفة لجعل الشخصية مرئية
local function makeVisible()
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
            part.CastShadow = true
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 0
        elseif part:IsA("Accessory") then
            part.Handle.Transparency = 0
        end
    end
    
    -- إظهار الاسم والعلامات
    humanoid.NameDisplayDistance = 100
    humanoid.HealthDisplayDistance = 100
    
    isCurrentlyInvisible = false
end

-- التحقق من الشخصية الجديدة عند الموت
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = char:WaitForChild("Humanoid")
    
    -- إعادة تطبيق الإختفاء إذا كان مفعلاً
    if invisible then
        humanoid.Died:Connect(function()
            -- عند الموت، ننتظر حتى يتم إعادة توليد الشخصية
            player.CharacterAdded:Wait()
            if invisible then
                makeInvisible()
            end
        end)
        
        makeInvisible()
    end
    
    -- إعادة تطبيق السرعة إذا كانت مفعّلة
    if fast then
        humanoid.WalkSpeed = insaneSpeed
    else
        humanoid.WalkSpeed = normalSpeed
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- الحفاظ على حالة الإختفاء
    if invisible and not isCurrentlyInvisible and char then
        makeInvisible()
    elseif not invisible and isCurrentlyInvisible and char then
        makeVisible()
    end
end)

-- إنشاء واجهة المستخدم
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "HackGui"

local frame = Instance.new("Frame", screenGui)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Text = "🌀 Hacks Menu"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 30)

local noclipBtn = Instance.new("TextButton", frame)
noclipBtn.Size = UDim2.new(0.9, 0, 0, 40)
noclipBtn.Position = UDim2.new(0.05, 0, 0, 40)
noclipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noclipBtn.TextColor3 = Color3.new(1,1,1)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.Font = Enum.Font.Gotham
noclipBtn.TextSize = 14

local invisBtn = Instance.new("TextButton", frame)
invisBtn.Size = UDim2.new(0.9, 0, 0, 40)
invisBtn.Position = UDim2.new(0.05, 0, 0, 90)
invisBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
invisBtn.TextColor3 = Color3.new(1,1,1)
invisBtn.Text = "Invisible: OFF"
invisBtn.Font = Enum.Font.Gotham
invisBtn.TextSize = 14

local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(0.9, 0, 0, 40)
speedBtn.Position = UDim2.new(0.05, 0, 0, 140)
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBtn.TextColor3 = Color3.new(1,1,1)
speedBtn.Text = "Speed: OFF"
speedBtn.Font = Enum.Font.Gotham
speedBtn.TextSize = 14

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = "Noclip: "..(noclip and "ON" or "OFF")
    noclipBtn.BackgroundColor3 = noclip and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
end)

invisBtn.MouseButton1Click:Connect(function()
    invisible = not invisible
    invisBtn.Text = "Invisible: "..(invisible and "ON" or "OFF")
    invisBtn.BackgroundColor3 = invisible and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
    
    if invisible then
        makeInvisible()
    else
        makeVisible()
    end
end)

speedBtn.MouseButton1Click:Connect(function()
    fast = not fast
    speedBtn.Text = "Speed: "..(fast and "ON" or "OFF")
    speedBtn.BackgroundColor3 = fast and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
    if fast then
        humanoid.WalkSpeed = insaneSpeed
    else
        humanoid.WalkSpeed = normalSpeed
    end
end)
