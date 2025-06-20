-- سكربت Muscle Legends مع إصلاح مشكلة الأزرار
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "AbdullahMLHub"
gui.Parent = player:WaitForChild("PlayerGui")

-- الإطار الرئيسي
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
mainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Parent = gui

-- شريط العنوان
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0.1, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "عبدالله | Muscle Legends"
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Position = UDim2.new(0.1, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = titleBar

-- زر الإغلاق
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.1, 0, 1, 0)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundTransparency = 1
closeButton.Parent = titleBar

-- منطقة المحتوى
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 0.9, 0)
contentFrame.Position = UDim2.new(0, 0, 0.1, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- زر الزراعة التلقائية
local autoFarmBtn = Instance.new("TextButton")
autoFarmBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
autoFarmBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
autoFarmBtn.Text = "تفعيل الزراعة التلقائية"
autoFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
autoFarmBtn.TextColor3 = Color3.new(1, 1, 1)
autoFarmBtn.Font = Enum.Font.GothamBold
autoFarmBtn.Parent = contentFrame

-- زر تعديل الإحصائيات
local statsBtn = Instance.new("TextButton")
statsBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
statsBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
statsBtn.Text = "تعديل الإحصائيات"
statsBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
statsBtn.TextColor3 = Color3.new(1, 1, 1)
statsBtn.Font = Enum.Font.GothamBold
statsBtn.Parent = contentFrame

-- زر الانتقال السريع
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
teleportBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
teleportBtn.Text = "الانتقال السريع"
teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.Parent = contentFrame

-- زر التفعيل الرئيسي
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.15, 0, 0.08, 0)
toggleBtn.Position = UDim2.new(0.01, 0, 0.01, 0)
toggleBtn.Text = "فتح القائمة"
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = gui

-- متغيرات التحكم
local isMenuOpen = true
local isAutoFarmOn = false
local isStatsHackOn = false

-- وظائف الأزرار
local function toggleMenu()
    isMenuOpen = not isMenuOpen
    mainFrame.Visible = isMenuOpen
    toggleBtn.Text = isMenuOpen and "إغلاق القائمة" or "فتح القائمة"
end

local function toggleAutoFarm()
    isAutoFarmOn = not isAutoFarmOn
    autoFarmBtn.Text = isAutoFarmOn and "إيقاف الزراعة" or "تفعيل الزراعة"
    print("الزراعة التلقائية: " .. (isAutoFarmOn and "مفعّلة" or "معطلة"))
end

local function toggleStatsHack()
    isStatsHackOn = not isStatsHackOn
    statsBtn.Text = isStatsHackOn and "إيقاف التعديل" or "تعديل الإحصائيات"
    print("تعديل الإحصائيات: " .. (isStatsHackOn and "مفعّل" or "معطّل"))
end

-- ربط الأحداث
closeButton.MouseButton1Click:Connect(function()
    toggleMenu()
end)

toggleBtn.MouseButton1Click:Connect(function()
    toggleMenu()
end)

autoFarmBtn.MouseButton1Click:Connect(function()
    toggleAutoFarm()
end)

statsBtn.MouseButton1Click:Connect(function()
    toggleStatsHack()
end)

teleportBtn.MouseButton1Click:Connect(function()
    print("تم الضغط على زر الانتقال السريع")
    -- يمكنك إضافة وظيفة الانتقال هنا
end)

-- التأكد من أن القائمة مرئية عند البدء
mainFrame.Visible = true
toggleBtn.Text = "إغلاق القائمة"
