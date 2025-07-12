local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "HackStealthReal"

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.35, 0, 0.3, 0)
frame.Size = UDim2.new(0, 400, 0, 250)
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

local btn = Instance.new("TextButton", frame)
btn.Text = ">> ENABLE STEALTH + NOCLIP <<"
btn.Position = UDim2.new(0.1, 0, 0.5, 0)
btn.Size = UDim2.new(0.8, 0, 0.2, 0)
btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btn.TextColor3 = Color3.fromRGB(0, 255, 0)
btn.Font = Enum.Font.Code
btn.TextSize = 18
btn.BorderColor3 = Color3.fromRGB(0, 255, 0)
btn.BorderSizePixel = 1

local enabled = false

-- NOCLIP FUNCTION
runService.Stepped:Connect(function()
	if enabled then
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

btn.MouseButton1Click:Connect(function()
	enabled = not enabled
	btn.Text = enabled and ">> DISABLE STEALTH + NOCLIP <<" or ">> ENABLE STEALTH + NOCLIP <<"

	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = enabled and 1 or 0
			if part:FindFirstChildOfClass("Decal") then
				part:FindFirstChildOfClass("Decal").Transparency = enabled and 1 or 0
			end
		elseif part:IsA("Accessory") then
			if part:FindFirstChild("Handle") then
				part.Handle.Transparency = enabled and 1 or 0
			end
		end
	end

	-- أهم خطوة: خلي HumanoidRootPart يمر من الجدران + حركة حقيقية
	if enabled then
		humanoidRootPart.CanCollide = false
	else
		humanoidRootPart.CanCollide = true
	end
end)
