local Player = game.Players.LocalPlayer
local Character = Player.Character
local Backpack = Player.Backpack
local Humanoid = Character:FindFirstChildOfClass("Humanoid")

local GravitySpeed = Instance.new("Tool")
GravitySpeed.TextureId = "rbxassetid://2684924567"
GravitySpeed.Name = "Super coil"
GravitySpeed.ToolTip = "Speed and jump!"
GravitySpeed.Parent = Backpack

local GravitySpeedHandle = Instance.new("Part")
GravitySpeedHandle.Name = "Handle"
GravitySpeedHandle.BrickColor = BrickColor.new("New Yeller")
GravitySpeedHandle.CastShadow = true
GravitySpeedHandle.TopSurface = Enum.SurfaceType.Smooth
GravitySpeedHandle.Transparency = 0
GravitySpeedHandle.Position = Vector3.new(1365.1, 647.5, 40.4)
GravitySpeedHandle.Size = Vector3.new(1, 1.2, 2)
GravitySpeedHandle.Parent = GravitySpeed

local Mesh = Instance.new("FileMesh")
Mesh.MeshId = "rbxassetid://16606212"
Mesh.TextureId = ""
Mesh.Scale = Vector3.new(0.7,0.7,0.7)
Mesh.Parent = GravitySpeedHandle

local Light = Instance.new("PointLight")
Light.Brightness = 15
Light.Color = Color3.fromRGB(255, 255, 0)
Light.Enabled = true
Light.Range = 8
Light.Shadows = false
Light.Archivable = true
Light.Name = "PointLight"
Light.Parent = GravitySpeedHandle

local particle = Instance.new("ParticleEmitter")
particle.Color = ColorSequence.new(Color3.fromRGB(255, 255, 150))
particle.Texture = "rbxassetid://2684924567"
particle.Rate = 20
particle.Lifetime = NumberRange.new(1)
particle.Speed = NumberRange.new(1, 2)
particle.Size = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.4),
	NumberSequenceKeypoint.new(1, 0.1)
})
particle.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.5),
	NumberSequenceKeypoint.new(1, 0.8)
})
particle.LightEmission = 0.7
particle.Parent = GravitySpeedHandle


local GravitySpeedSound1 = Instance.new("Sound")
GravitySpeedSound1.Name = "CoilSound1"
GravitySpeedSound1.SoundId = "rbxassetid://16619553"
GravitySpeedSound1.Volume = 1
GravitySpeedSound1.Looped = false
GravitySpeedSound1.Parent = GravitySpeed

local GravitySpeedSound2 = Instance.new("Sound")
GravitySpeedSound2.Name = "CoilSound2"
GravitySpeedSound2.SoundId = "rbxassetid://99173388"
GravitySpeedSound2.Volume = 1
GravitySpeedSound2.Looped = false
GravitySpeedSound2.Parent = GravitySpeed

local RunService = game:GetService("RunService")
local hadCoil = false

RunService.Heartbeat:Connect(function()
	local gravityCoil = Character:FindFirstChild("Super coil")

	if gravityCoil then
		if not hadCoil then
			hadCoil = true
			GravitySpeedSound1:Play()
			GravitySpeedSound2:Play()
		end

		Humanoid.UseJumpPower = true
		Humanoid.JumpPower = 125
		Humanoid.WalkSpeed = 35
	else
		hadCoil = false
		Humanoid.UseJumpPower = true
		Humanoid.JumpPower = 50
		Humanoid.WalkSpeed = 16
	end
end)
