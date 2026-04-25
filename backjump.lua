
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(Char)
	Character = Char
	Humanoid = Char:WaitForChild("Humanoid")
	Root = Char:WaitForChild("HumanoidRootPart")
end)

local UpwardBoost = 45
local BackwardPush = 10

UserInputService.JumpRequest:Connect(function()
	if Humanoid:GetState() == Enum.HumanoidStateType.Climbing then
		local Look = Root.CFrame.LookVector
		local Backward = -Look.Unit * BackwardPush

		local Velocity = Vector3.new(
			Backward.X,
			math.max(Root.Velocity.Y, 0) + UpwardBoost,
			Backward.Z
		)

		Root.Velocity = Velocity
	end
end)
