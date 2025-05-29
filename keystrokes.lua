
-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")

-- UI Elements
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeystrokeUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.4
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.77, 0, 0.15, 0)
Frame.Size = UDim2.new(0, 170, 0, 170)
Frame.Active = true  -- for dragging

local UICorner = Instance.new("UICorner")
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = Frame
UIStroke.Thickness = 3
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Animate Neon RGB Stroke
local function animateStroke()
	local hue = 0
	while true do
		UIStroke.Color = Color3.fromHSV(hue, 1, 1)
		hue = (hue + 0.01) % 1
		task.wait(0.05)
	end
end
task.spawn(animateStroke)

-- Game Name Detection
local gameNameLabel = Instance.new("TextLabel")
gameNameLabel.Parent = Frame
gameNameLabel.Size = UDim2.new(1, 0, 0, 20)
gameNameLabel.Position = UDim2.new(0, 0, -0.15, 0)
gameNameLabel.BackgroundTransparency = 1
gameNameLabel.Font = Enum.Font.SourceSans
gameNameLabel.TextScaled = true
gameNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gameNameLabel.Text = "Loading game name..."

task.spawn(function()
	local success, info = pcall(function()
		return MarketplaceService:GetProductInfo(game.PlaceId)
	end)
	if success and info then
		gameNameLabel.Text = info.Name
	else
		gameNameLabel.Text = "Unknown Game"
	end
end)

-- Key Definitions
local keys = {
	{Name = "W", KeyCode = Enum.KeyCode.W, Position = UDim2.new(0.364, 0, 0.04, 0)},
	{Name = "A", KeyCode = Enum.KeyCode.A, Position = UDim2.new(0.035, 0, 0.364, 0)},
	{Name = "S", KeyCode = Enum.KeyCode.S, Position = UDim2.new(0.364, 0, 0.364, 0)},
	{Name = "D", KeyCode = Enum.KeyCode.D, Position = UDim2.new(0.688, 0, 0.364, 0)},
	{Name = "LMB", InputType = Enum.UserInputType.MouseButton1, Position = UDim2.new(0.035, 0, 0.664, 0), Size = UDim2.new(0, 78, 0, 25)},
	{Name = "RMB", InputType = Enum.UserInputType.MouseButton2, Position = UDim2.new(0.494, 0, 0.664, 0), Size = UDim2.new(0, 78, 0, 25)},
	{Name = "Spacebar", KeyCode = Enum.KeyCode.Space, Position = UDim2.new(0.035, 0, 0.852, 0), Size = UDim2.new(0, 156, 0, 25)}
}

-- Key Buttons
local buttons = {}
for _, keyData in pairs(keys) do
	local keyButton = Instance.new("TextButton")
	local buttonUICorner = Instance.new("UICorner")
	
	keyButton.Name = keyData.Name
	keyButton.Parent = Frame
	keyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	keyButton.BackgroundTransparency = 0.5
	keyButton.BorderSizePixel = 0
	keyButton.Position = keyData.Position
	keyButton.Size = keyData.Size or UDim2.new(0, 45, 0, 45)
	keyButton.Font = Enum.Font.GothamBold
	keyButton.Text = keyData.Name
	keyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	keyButton.TextSize = 20
	keyButton.TextWrapped = true
	keyButton.AutoButtonColor = false
	
	buttonUICorner.Parent = keyButton
	buttons[keyData.Name] = keyButton
end

-- Long Press / Long Click Detection
local longPressThreshold = 0.01
local keyPressTimes = {}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	for _, keyData in pairs(keys) do
		if (keyData.KeyCode and input.KeyCode == keyData.KeyCode) or 
		   (keyData.InputType and input.UserInputType == keyData.InputType) then
			local button = buttons[keyData.Name]
			if button then
				keyPressTimes[keyData.Name] = tick()
				task.spawn(function()
					task.wait(longPressThreshold)
					if keyPressTimes[keyData.Name] then
						TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 255, 255)}):Play()
					end
				end)
			end
		end
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	for _, keyData in pairs(keys) do
		if (keyData.KeyCode and input.KeyCode == keyData.KeyCode) or 
		   (keyData.InputType and input.UserInputType == keyData.InputType) then
			local button = buttons[keyData.Name]
			if button and keyPressTimes[keyData.Name] then
				local pressDuration = tick() - keyPressTimes[keyData.Name]
				keyPressTimes[keyData.Name] = nil
				if pressDuration < longPressThreshold then
					TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
					task.wait(0.1)
					TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
				else
					TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
				end
			end
		end
	end
end)

-- Draggify GUI Functionality for Main Frame
local dragging, dragStart, startPos
Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
