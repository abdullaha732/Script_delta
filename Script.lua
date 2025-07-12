local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "HackStealthReal"

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.35, 0, 0.3, 0)
frame.Size = UDim2.new(0, 400, 0, 350)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Text = "🖤 [ REAL HACK MENU ]"
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.Code
title.TextSize = 28

-- زر التخفي + نوكليب
local stealthBtn = Instance.new("TextButton", frame)
stealthBtn.Text = ">> ENABLE STEALTH + NOCLIP <<"
stealthBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
stealthBtn.Size = UDim2.new(0.8, 0, 0.12, 0)
stealthBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
stealthBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
stealthBtn.Font = Enum.Font.Code
stealthBtn.TextSize = 18
stealthBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
stealthBtn.BorderSizePixel = 1

local stealthEnabled = false

-- زر ESP
local espBtn = Instance.new("TextButton", frame)
espBtn.Text = ">> ENABLE ESP <<"
espBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
espBtn.Size = UDim2.new(0.8, 0, 0.12, 0)
espBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
espBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
espBtn.Font = Enum.Font.Code
espBtn.TextSize = 18
espBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
espBtn.BorderSizePixel = 1

local espEnabled = false

-- زر السرعة
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Text = ">> ENABLE SPEED <<"
speedBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
speedBtn.Size = UDim2.new(0.8, 0, 0.12, 0)
speedBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
speedBtn.Font = Enum.Font.Code
speedBtn.TextSize = 18
speedBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
speedBtn.BorderSizePixel = 1

local speedEnabled = false
local normalSpeed = humanoid.WalkSpeed
local boostedSpeed = 100

-- NOCLIP FUNCTION
runService.Stepped:Connect(function()
	if stealthEnabled then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	else
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end)

stealthBtn.MouseButton1Click:Connect(function()
	stealthEnabled = not stealthEnabled
	stealthBtn.Text = stealthEnabled and ">> DISABLE STEALTH + NOCLIP <<" or ">> ENABLE STEALTH + NOCLIP <<"

	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = stealthEnabled and 1 or 0
			if part:FindFirstChildOfClass("Decal") then
				part:FindFirstChildOfClass("Decal").Transparency = stealthEnabled and 1 or 0
			end
		elseif part:IsA("Accessory") then
			if part:FindFirstChild("Handle") then
				part.Handle.Transparency = stealthEnabled and 1 or 0
			end
		end
	end

	humanoidRootPart.CanCollide = not stealthEnabled
end)

-- ESP FUNCTION
local function createESP(targetPlayer)
	if targetPlayer == player then return end
	local char = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
	local head = char:WaitForChild("Head")
	local esp = Instance.new("BillboardGui", head)
	esp.Name = "ESP"
	esp.Adornee = head
	esp.Size = UDim2.new(0, 100, 0, 40)
	esp.AlwaysOnTop = true

	local label = Instance.new("TextLabel", esp)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 0, 0)
	label.TextStrokeTransparency = 0
	label.Text = targetPlayer.Name
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = espEnabled and ">> DISABLE ESP <<" or ">> ENABLE ESP <<"

	if espEnabled then
		for _, p in pairs(players:GetPlayers()) do
			createESP(p)
		end
		players.PlayerAdded:Connect(function(p)
			p.CharacterAdded:Connect(function()
				createESP(p)
			end)
		end)
	else
		for _, p in pairs(players:GetPlayers()) do
			if p.Character and p.Character:FindFirstChild("Head") then
				local esp = p.Character.Head:FindFirstChild("ESP")
				if esp then esp:Destroy() end
			end
		end
	end
end)

-- SPEED FUNCTION
speedBtn.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedBtn.Text = speedEnabled and ">> DISABLE SPEED <<" or ">> ENABLE SPEED <<"

	humanoid.WalkSpeed = speedEnabled and boostedSpeed or normalSpeed
end)
