-- سكربت ESP مع زر قابل للتحريك وزر إغلاق - متوافق مع Delta / iPad

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ESP بيانات
local ESP_COLOR = Color3.new(1, 0, 0)
local ESP_ON = false
local ESPs = {}

-- إنشاء واجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- الإطار الأساسي
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 60)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = screenGui

-- زر تفعيل ESP
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.7, 0, 1, 0)
toggleButton.Position = UDim2.new(0, 0, 0, 0)
toggleButton.Text = "ESP: OFF"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.Parent = mainFrame

-- زر الإغلاق
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.3, 0, 1, 0)
closeButton.Position = UDim2.new(0.7, 0, 0, 0)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.new(1, 0, 0)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeButton.Parent = mainFrame

-- وظيفة تفعيل ESP
local function createESP(player)
	if player == LocalPlayer then return end
	local char = player.Character or player.CharacterAdded:Wait()
	local head = char:WaitForChild("Head")

	local esp = Instance.new("BillboardGui")
	esp.Name = "ESP"
	esp.Size = UDim2.new(0, 200, 0, 30)
	esp.AlwaysOnTop = true
	esp.StudsOffset = Vector3.new(0, 3, 0)
	esp.Adornee = head
	esp.Parent = head

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = ESP_COLOR
	label.TextStrokeTransparency = 0.5
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Text = player.Name
	label.Parent = esp

	ESPs[player] = esp
end

-- إزالة ESP
local function removeESP(player)
	if ESPs[player] then
		ESPs[player]:Destroy()
		ESPs[player] = nil
	end
end

-- تشغيل ESP
local function enableESP()
	ESP_ON = true
	toggleButton.Text = "ESP: ON"
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			createESP(p)
		end
	end
end

-- إيقاف ESP
local function disableESP()
	ESP_ON = false
	toggleButton.Text = "ESP: OFF"
	for p, _ in pairs(ESPs) do
		removeESP(p)
	end
end

-- تبديل الحالة
toggleButton.MouseButton1Click:Connect(function()
	if ESP_ON then
		disableESP()
	else
		enableESP()
	end
end)

-- زر الإغلاق
closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- إزالة ESP عند مغادرة لاعب
Players.PlayerRemoving:Connect(removeESP)

-- إضافة ESP عند دخول لاعب
Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		if ESP_ON then
			createESP(p)
		end
	end)
end)
