--[[
 Lontrax Turbo Optimizer v1.0
 Universal GUI: Optimizes FPS, removes textures/skins, runs smoothly even on weak phones.
]]

local Gui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Button1 = Instance.new("TextButton")
local Button2 = Instance.new("TextButton")
local Button3 = Instance.new("TextButton")
local Button4 = Instance.new("TextButton") -- Turbo V2
local Toggle = Instance.new("TextButton")
local neon = Color3.fromRGB(0,255,150)

Gui.Name = "DiddyOptimizer"
Gui.ResetOnSpawn = false
Gui.Parent = game.CoreGui

Main.Name = "Main"
Main.Parent = Gui
Main.BackgroundColor3 = Color3.new(0,0,0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.02,0,0.2,0)
Main.Size = UDim2.new(0, 260, 0, 285) -- Height increased
Main.Active = true
Main.Draggable = true

UICorner.CornerRadius = UDim.new(0,16)
UICorner.Parent = Main

Title.Name = "Title"
Title.Parent = Main
Title.Text = "Lontrax Optimizer"
Title.TextColor3 = neon
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Position = UDim2.new(0,0,0,0)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1

local function createButton(text, yPos)
	local btn = Instance.new("TextButton")
	btn.Parent = Main
	btn.Text = text
	btn.TextColor3 = neon
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, yPos, 0)
	btn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	btn.BorderSizePixel = 0
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 10)
	return btn
end

Button1 = createButton("Turbo Optimization (remove all)", 0.18)
Button2 = createButton("Light Optimization (FPS+)", 0.40)
Button3 = createButton("Restore Graphics", 0.62)
Button4 = createButton("Turbo V2 (realistic textures)", 0.84)

Toggle.Name = "Toggle"
Toggle.Parent = Gui
Toggle.Text = "⚙️"
Toggle.TextSize = 24
Toggle.Size = UDim2.new(0, 40, 0, 40)
Toggle.Position = UDim2.new(0, 10, 0.15, 0)
Toggle.BackgroundColor3 = neon
Toggle.TextColor3 = Color3.new(0,0,0)
Toggle.Active = true
Toggle.Draggable = true
local corner = Instance.new("UICorner", Toggle)
corner.CornerRadius = UDim.new(0, 10)

Toggle.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

-- Functions

local function removeTextures()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Decal") or v:IsA("Texture") then
			v:Destroy()
		elseif v:IsA("MeshPart") or v:IsA("Part") then
			v.Material = Enum.Material.SmoothPlastic
			v.Color = Color3.new(0.3,0.3,0.3)
		end
	end
end

local function optimizeLeve()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Low
	settings().Rendering.ReloadAssets = false
	local lighting = game:GetService("Lighting")
	lighting.GlobalShadows = false
	lighting.FogEnd = math.huge
end

local function turboV2()
	removeTextures()
	optimizeLeve()
	workspace.Terrain.WaterWaveSize = 0
	workspace.Terrain.WaterTransparency = 1
	workspace.Terrain.WaterReflectance = 0
	workspace.Terrain.WaterWaveSpeed = 0
end

local function restore()
	local lighting = game:GetService("Lighting")
	lighting.GlobalShadows = true
	lighting.FogEnd = 1000
	settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
	settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Automatic
	settings().Rendering.ReloadAssets = true

	workspace.Terrain.WaterWaveSize = 0.1
	workspace.Terrain.WaterTransparency = 0.5
	workspace.Terrain.WaterReflectance = 0.05
	workspace.Terrain.WaterWaveSpeed = 10
end

Button1.MouseButton1Click:Connect(function()
	removeTextures()
	optimizeLeve()
end)

Button2.MouseButton1Click:Connect(function()
	optimizeLeve()
end)

Button3.MouseButton1Click:Connect(function()
	restore()
end)

Button4.MouseButton1Click:Connect(function()
	turboV2()
end)
