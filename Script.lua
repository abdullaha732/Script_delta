local ScreenGui = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
TextLabel.Parent = ScreenGui
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Text = "تم اختراقك!"
TextLabel.TextColor3 = Color3.new(1, 0, 0)
TextLabel.TextScaled = true
TextLabel.BackgroundTransparency = 1
