-- سكربت Muscle Legends فاخر مع اسم عبدالله
-- يعمل في LocalScript داخل StarterPlayerScripts

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- إنشاء واجهة فاخرة
local gui = Instance.new("ScreenGui")
gui.Name = "AbdullahMLHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- إطار رئيسي بزجاج مع تأثيرات
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.35, 0, 0.7, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- تأثير زجاجي
local glassEffect = Instance.new("ImageLabel")
glassEffect.Name = "GlassEffect"
glassEffect.Size = UDim2.new(1, 0, 1, 0)
glassEffect.Image = "rbxassetid://8992230431"
glassEffect.ScaleType = Enum.ScaleType.Tile
glassEffect.TileSize = UDim2.new(0, 200, 0, 200)
glassEffect.BackgroundTransparency = 1
glassEffect.ImageTransparency = 0.9
glassEffect.ImageColor3 = Color3.fromRGB(0, 150, 255)
glassEffect.ZIndex = 2
glassEffect.Parent = mainFrame

-- شريط عنوان أنيق
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0.12, 0)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 3
titleBar.Parent = mainFrame

-- تأثير توهج للشريط
local titleGlow = Instance.new("ImageLabel")
titleGlow.Name = "TitleGlow"
titleGlow.Image = "rbxassetid://8992230431"
titleGlow.Size = UDim2.new(1, 0, 2, 0)
titleGlow.Position = UDim2.new(0, 0, -0.5, 0)
titleGlow.BackgroundTransparency = 1
titleGlow.ImageColor3 = Color3.fromRGB(255, 120, 0)
titleGlow.ImageTransparency = 0.7
titleGlow.ScaleType = Enum.ScaleType.Tile
titleGlow.TileSize = UDim2.new(0, 100, 0, 100)
titleGlow.ZIndex = 2
titleGlow.Parent = titleBar

-- عنوان مخصص باسم عبدالله
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "عبدالله | MUSCLE LEGENDS"
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Position = UDim2.new(0.1, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 4
title.Parent = titleBar

-- زر إغلاق فاخر
local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0.1, 0, 1, 0)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.Image = "rbxassetid://3926305904"
closeButton.ImageRectOffset = Vector2.new(284, 4)
closeButton.ImageRectSize = Vector2.new(24, 24)
closeButton.BackgroundTransparency = 1
closeButton.ZIndex = 4
closeButton.Parent = titleBar

-- منطقة التبويبات المتحركة
local tabsFrame = Instance.new("Frame")
tabsFrame.Name = "TabsFrame"
tabsFrame.Size = UDim2.new(1, 0, 0.1, 0)
tabsFrame.Position = UDim2.new(0, 0, 0.12, 0)
tabsFrame.BackgroundTransparency = 1
tabsFrame.ZIndex = 3
tabsFrame.Parent = mainFrame

-- إنشاء تبويبات متحركة
local tabs = {
    {Name = "الزراعة", Icon = "🌾"},
    {Name = "الإحصائيات", Icon = "📊"},
    {Name = "الانتقال", Icon = "🚀"},
    {Name = "الإعدادات", Icon = "⚙️"}
}

local tabButtons = {}
for i, tab in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tab.Name .. "Tab"
    tabButton.Size = UDim2.new(0.25, 0, 1, 0)
    tabButton.Position = UDim2.new(0.25 * (i - 1), 0, 0, 0)
    tabButton.Text = tab.Icon .. " " .. tab.Name
    tabButton.TextColor3 = i == 1 and Color3.new(1, 1, 1) or Color3.new(0.8, 0.8, 0.8)
    tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(40, 40, 80)
    tabButton.BackgroundTransparency = i == 1 and 0.3 or 0.7
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 16
    tabButton.ZIndex = 4
    
    -- تأثير عند التحويم
    tabButton.MouseEnter:Connect(function()
        if currentTab ~= tab.Name then
            game:GetService("TweenService"):Create(
                tabButton,
                TweenInfo.new(0.2),
                {BackgroundTransparency = 0.5, TextColor3 = Color3.new(1, 1, 1)}
            ):Play()
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if currentTab ~= tab.Name then
            game:GetService("TweenService"):Create(
                tabButton,
                TweenInfo.new(0.2),
                {BackgroundTransparency = 0.7, TextColor3 = Color3.new(0.8, 0.8, 0.8)}
            ):Play()
        end
    end)
    
    tabButton.Parent = tabsFrame
    table.insert(tabButtons, tabButton)
end

-- منطقة المحتوى
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 0.78, 0)
contentFrame.Position = UDim2.new(0, 0, 0.22, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- زر التفعيل الرئيسي (فاخر)
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.12, 0, 0.08, 0)
toggleButton.Position = UDim2.new(0.01, 0, 0.01, 0)
toggleButton.Image = "rbxassetid://3926307971"
toggleButton.ImageRectOffset = Vector2.new(364, 284)
toggleButton.ImageRectSize = Vector2.new(36, 36)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
toggleButton.BackgroundTransparency = 0.3
toggleButton.ZIndex = 10
toggleButton.Parent = gui

-- إضافة توهج للزر
local toggleGlow = Instance.new("ImageLabel")
toggleGlow.Name = "ToggleGlow"
toggleGlow.Image = "rbxassetid://4896581286"
toggleGlow.Size = UDim2.new(1.5, 0, 1.5, 0)
toggleGlow.Position = UDim2.new(-0.25, 0, -0.25, 0)
toggleGlow.BackgroundTransparency = 1
toggleGlow.ImageColor3 = Color3.fromRGB(255, 100, 0)
toggleGlow.ImageTransparency = 0.8
toggleGlow.ZIndex = 9
toggleGlow.Parent = toggleButton

mainFrame.Parent = gui

-- متغيرات التحكم
local isMenuOpen = true
local currentTab = "الزراعة"
local isDragging = false
local dragStartPos, frameStartPos

-- وظائف التبويبات
local function showTab(tabName)
    currentTab = tabName
    
    -- تحديث أزرار التبويبات
    for _, button in ipairs(tabButtons) do
        local isSelected = button.Text:find(tabName)
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.3),
            {
                BackgroundTransparency = isSelected and 0.3 or 0.7,
                TextColor3 = isSelected and Color3.new(1, 1, 1) or Color3.new(0.8, 0.8, 0.8),
                BackgroundColor3 = isSelected and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(40, 40, 80)
            }
        ):Play()
    end
    
    -- هنا يمكنك إضافة محتوى كل تبويب
    print("تم التبديل إلى تبويب: " .. tabName)
end

-- وظائف الحركة والسحب
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        frameStartPos = mainFrame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local dragDelta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        mainFrame.Position = UDim2.new(
            frameStartPos.X.Scale, 
            frameStartPos.X.Offset + dragDelta.X,
            frameStartPos.Y.Scale,
            frameStartPos.Y.Offset + dragDelta.Y
        )
    end
end)

-- أحداث الأزرار
closeButton.MouseButton1Click:Connect(function()
    isMenuOpen = false
    game:GetService("TweenService"):Create(
        mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0)}
    ):Play()
    toggleButton.ImageRectOffset = Vector2.new(364, 284)
end)

toggleButton.MouseButton1Click:Connect(function()
    isMenuOpen = not isMenuOpen
    if isMenuOpen then
        mainFrame.Visible = true
        game:GetService("TweenService"):Create(
            mainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
            {Size = UDim2.new(0.35, 0, 0.7, 0)}
        ):Play()
        toggleButton.ImageRectOffset = Vector2.new(404, 284)
    else
        game:GetService("TweenService"):Create(
            mainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Size = UDim2.new(0, 0, 0, 0)}
        ):Play()
        toggleButton.ImageRectOffset = Vector2.new(364, 284)
    end
end)

for _, button in ipairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        local tabName = button.Text:gsub("[^%a%d%p%s]", ""):match("%s(.+)")
        showTab(tabName)
    end)
end

-- إظهار التبويب الأول عند البدء
showTab("الزراعة")

-- تكييف مع الشاشة
local function onViewportSizeChange()
    local viewportSize = Workspace.CurrentCamera.ViewportSize
    if viewportSize.Y < 800 then
        mainFrame.Size = UDim2.new(0.4, 0, 0.8, 0)
        title.TextSize = 18
        for _, button in ipairs(tabButtons) do
            button.TextSize = 14
        end
    end
end

Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChange)
onViewportSizeChange()

-- تأثيرات إضافية
RunService.Heartbeat:Connect(function()
    -- تأثير توهج متحرك
    toggleGlow.ImageTransparency = 0.7 + math.sin(tick() * 3) * 0.1
    
    -- تأثير اهتزاز بسيط للأزرار عند التحويم
    for _, button in ipairs(tabButtons) do
        if button:IsMouseOver() and currentTab ~= button.Text:gsub("[^%a%d%p%s]", ""):match("%s(.+)") then
            button.Rotation = math.sin(tick() * 10) * 1
        else
            button.Rotation = 0
        end
    end
end)

-- تنظيف السكربت عند إعادة التحميل
game:BindToClose(function()
    gui:Destroy()
end)
