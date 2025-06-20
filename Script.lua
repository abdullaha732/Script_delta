-- سكربت ESP لعرض اللاعبين خلف الجدران (لون أحمر)
-- يعمل هذا السكربت في LocalScript داخل StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- إعدادات السكربت
local ESP_SETTINGS = {
    Color = Color3.new(1, 0, 0), -- اللون الأحمر
    Thickness = 1.5, -- سمك الخط
    Transparency = 0.7, -- شفافية المربعات
    FontSize = 18, -- حجم الخط
    ShowDistance = true, -- إظهار المسافة
    ShowName = true, -- إظهار الأسماء
    ShowHealth = true, -- إظهار الصحة
    MaxDistance = 1000, -- أقصى مسافة للعرض (درجات)
    RefreshRate = 0.1 -- معدل التحديث (ثواني)
}

-- جدول لتخزين بيانات ESP لكل لاعب
local espData = {}

-- وظيفة إنشاء ESP للاعب
local function createESP(targetPlayer)
    local character = targetPlayer.Character
    if not character then return end
    
    -- إنشاء مجلد لتخزين عناصر ESP
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESP_" .. targetPlayer.Name
    espFolder.Parent = camera
    
    -- إنشاء خطوط للمربع المحيط
    local lines = {
        top = Instance.new("LineHandleAdornment"),
        bottom = Instance.new("LineHandleAdornment"),
        left = Instance.new("LineHandleAdornment"),
        right = Instance.new("LineHandleAdornment"),
        front = Instance.new("LineHandleAdornment"),
        back = Instance.new("LineHandleAdornment")
    }
    
    for _, line in pairs(lines) do
        line.Color3 = ESP_SETTINGS.Color
        line.Thickness = ESP_SETTINGS.Thickness
        line.Transparency = ESP_SETTINGS.Transparency
        line.AlwaysOnTop = true
        line.ZIndex = 5
        line.Adornee = character
        line.Parent = espFolder
    end
    
    -- إنشاء نص لاسم اللاعب
    local nameTag = Instance.new("BillboardGui")
    nameTag.Name = "NameTag"
    nameTag.Size = UDim2.new(0, 200, 0, 50)
    nameTag.AlwaysOnTop = true
    nameTag.StudsOffset = Vector3.new(0, 3.5, 0)
    nameTag.Adornee = character:WaitForChild("Head")
    nameTag.Parent = espFolder
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Label"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = ESP_SETTINGS.Color
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = ESP_SETTINGS.FontSize
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = targetPlayer.Name
    nameLabel.Parent = nameTag
    
    -- إنشاء نص للمسافة والصحة
    local infoTag = Instance.new("BillboardGui")
    infoTag.Name = "InfoTag"
    infoTag.Size = UDim2.new(0, 200, 0, 50)
    infoTag.AlwaysOnTop = true
    infoTag.StudsOffset = Vector3.new(0, 2.5, 0)
    infoTag.Adornee = character:WaitForChild("Head")
    infoTag.Parent = espFolder
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "Label"
    infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.new(1, 1, 1)
    infoLabel.TextStrokeTransparency = 0
    infoLabel.TextSize = ESP_SETTINGS.FontSize - 2
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Parent = infoTag
    
    -- تخزين البيانات
    espData[targetPlayer] = {
        folder = espFolder,
        lines = lines,
        nameTag = nameTag,
        infoTag = infoTag,
        character = character
    }
end

-- وظيفة تحديث ESP
local function updateESP()
    for targetPlayer, data in pairs(espData) do
        if not data.character or not data.character.Parent then
            if data.folder then
                data.folder:Destroy()
            end
            espData[targetPlayer] = nil
            continue
        end
        
        local character = data.character
        local humanoid = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not head or not rootPart then continue end
        
        -- حساب حجم المربع المحيط
        local cf = rootPart.CFrame
        local size = character:GetExtentsSize() * 1.2
        
        -- تحديث خطوط المربع المحيط
        local lines = data.lines
        lines.top.Length = size.X
        lines.top.CFrame = cf * CFrame.new(0, size.Y/2, 0) * CFrame.Angles(0, math.rad(90), 0)
        
        lines.bottom.Length = size.X
        lines.bottom.CFrame = cf * CFrame.new(0, -size.Y/2, 0) * CFrame.Angles(0, math.rad(90), 0)
        
        lines.left.Length = size.Y
        lines.left.CFrame = cf * CFrame.new(-size.X/2, 0, 0) * CFrame.Angles(0, 0, math.rad(90))
        
        lines.right.Length = size.Y
        lines.right.CFrame = cf * CFrame.new(size.X/2, 0, 0) * CFrame.Angles(0, 0, math.rad(90))
        
        lines.front.Length = size.Z
        lines.front.CFrame = cf * CFrame.new(0, 0, size.Z/2) * CFrame.Angles(math.rad(90), 0, 0)
        
        lines.back.Length = size.Z
        lines.back.CFrame = cf * CFrame.new(0, 0, -size.Z/2) * CFrame.Angles(math.rad(90), 0, 0)
        
        -- تحديث معلومات اللاعب
        local distance = (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) 
                        and (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude 
                        or 0
        
        local infoText = ""
        if ESP_SETTINGS.ShowDistance then
            infoText = "المسافة: " .. math.floor(distance) .. "m"
        end
        
        if ESP_SETTINGS.ShowHealth and humanoid then
            local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
            infoText = infoText .. (infoText ~= "" and " | " or "") .. "الصحة: " .. healthPercent .. "%"
        end
        
        if data.infoTag and data.infoTag:FindFirstChild("Label") then
            data.infoTag.Label.Text = infoText
        end
        
        -- إخفاء ESP إذا كانت المسافة كبيرة
        local shouldShow = distance <= ESP_SETTINGS.MaxDistance
        data.folder.Enabled = shouldShow
        
        -- تغيير اللون حسب الصحة
        if humanoid then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local healthColor = ESP_SETTINGS.Color
            
            if healthPercent < 0.3 then
                healthColor = Color3.new(1, 0, 0) -- أحمر
            elseif healthPercent < 0.6 then
                healthColor = Color3.new(1, 1, 0) -- أصفر
            else
                healthColor = ESP_SETTINGS.Color -- اللون الأساسي
            end
            
            for _, line in pairs(lines) do
                line.Color3 = healthColor
            end
            
            if data.nameTag and data.nameTag:FindFirstChild("Label") then
                data.nameTag.Label.TextColor3 = healthColor
            end
        end
    end
end

-- وظيفة إزالة ESP عند مغادرة اللاعب
local function removeESP(targetPlayer)
    if espData[targetPlayer] and espData[targetPlayer].folder then
        espData[targetPlayer].folder:Destroy()
        espData[targetPlayer] = nil
    end
end

-- تهيئة ESP للاعبين الحاليين
for _, targetPlayer in ipairs(Players:GetPlayers()) do
    if targetPlayer ~= player then
        createESP(targetPlayer)
    end
end

-- إضافة ESP للاعبين الجدد
Players.PlayerAdded:Connect(function(targetPlayer)
    if targetPlayer ~= player then
        targetPlayer.CharacterAdded:Connect(function()
            createESP(targetPlayer)
        end)
    end
end)

-- إزالة ESP للاعبين المترجلين
Players.PlayerRemoving:Connect(function(targetPlayer)
    removeESP(targetPlayer)
end)

-- تحديث ESP بانتظام
while true do
    updateESP()
    wait(ESP_SETTINGS.RefreshRate)
end

-- تنظيف ESP عند إعادة التحميل
game:BindToClose(function()
    for targetPlayer, data in pairs(espData) do
        if data.folder then
            data.folder:Destroy()
        end
    end
    espData = {}
end)
