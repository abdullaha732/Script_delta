
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESP_COLOR = Color3.new(1, 0, 0)
local ESP_ON = false
local ESPs = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 110)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.7, 0, 0, 40)
toggleButton.Position = UDim2.new(0, 0, 0, 0)
toggleButton.Text = "ESP: OFF"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.3, 0, 0, 40)
closeButton.Position = UDim2.new(0.7, 0, 0, 0)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.new(1, 0, 0)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeButton.Parent = mainFrame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -10, 0, 50)
searchBox.Position = UDim2.new(0, 5, 0, 55)
searchBox.PlaceholderText = "اكتب اسم لاعب (أو أول حرفين)..."
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.TextScaled = true
searchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
searchBox.ClearTextOnFocus = false
searchBox.Font = Enum.Font.GothamBold
searchBox.Parent = mainFrame

-- متغير لتخزين اللاعب المتتبع (إن وجد)
local followedPlayer = nil
local originalCameraType = Camera.CameraType
local originalCameraSubject = Camera.CameraSubject

local function createESP(player)
	if ESPs[player] then return end
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

local function removeESP(player)
	if ESPs[player] then
		ESPs[player]:Destroy()
		ESPs[player] = nil
	end
end

local function updateESP()
	local searchText = searchBox.Text:lower()
	followedPlayer = nil

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local nameLower = player.Name:lower()
			local match = searchText == "" or string.sub(nameLower, 1, #searchText) == searchText
			if ESP_ON and match then
				if not ESPs[player] then
					createESP(player)
				end
				-- تعيين اللاعب المتتبع لو وجد تطابق كامل (اسم كامل)
				if nameLower == searchText then
					followedPlayer = player
				end
			else
				removeESP(player)
			end
		end
	end

	-- تحديث الكاميرا
	if followedPlayer and followedPlayer.Character and followedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		Camera.CameraSubject = followedPlayer.Character.Humanoid
		Camera.CameraType = Enum.CameraType.Custom
	else
		-- إعادة الكاميرا لوضعها الأصلي
		Camera.CameraSubject = originalCameraSubject
		Camera.CameraType = originalCameraType
	end
end

local function enableESP()
	ESP_ON = true
	toggleButton.Text = "ESP: ON"
	updateESP()
end

local function disableESP()
	ESP_ON = false
	toggleButton.Text = "ESP: OFF"
	for p, _ in pairs(ESPs) do
		removeESP(p)
	end
	-- إعادة الكاميرا لوضعها الأصلي
	Camera.CameraSubject = originalCameraSubject
	Camera.CameraType = originalCameraType
end

toggleButton.MouseButton1Click:Connect(function()
	if ESP_ON then
		disableESP()
	else
		enableESP()
	end
end)

closeButton.MouseButton1Click:Connect(function()
	disableESP()
	screenGui:Destroy()
end)

searchBox:GetPropertyChangedSignal("Text"):Connect(updateESP)

Players.PlayerRemoving:Connect(removeESP)

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		if ESP_ON then
			updateESP()
		end
	end)
end)
