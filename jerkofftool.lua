local plr = game:GetService("Players").LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:FindFirstChild("Humanoid") or char:WaitForChild("Humanoid")
local anim = hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator")
local pack = plr:FindFirstChild("Backpack") or plr:WaitForChild("Backpack")

if workspace:FindFirstChild("aaa") then
	workspace:FindFirstChild("aaa"):Destroy()
end

local function getmodel()
	return hum.RigType == Enum.HumanoidRigType.R15 and "R15" or "R6"
end

local function Notify(Title, Text, Duration)
	game:GetService('StarterGui'):SetCore('SendNotification', {
        Title = Title,
        Text = Text or '',
        Duration = Duration}
    )
end	

Notify("script made by estredella", "fuck niggers", 20)

local animation = Instance.new("Animation")
animation.Name = "aaa"
animation.Parent = workspace

animation.AnimationId = getmodel() == "R15" and "rbxassetid://698251653" or "rbxassetid://72042024"

local tool = Instance.new("Tool")
tool.Name = "Jerk"
tool.RequiresHandle = false
tool.Parent = pack

local doing = false
local animtrack = nil

tool.Equipped:Connect(function()
	doing = true
	while doing do
		if not animtrack then
			animtrack = anim:LoadAnimation(animation)
		end

		animtrack:Play()
		animtrack:AdjustSpeed(0.7)
		animtrack.TimePosition = 0.6

		task.wait(0.1)
		while doing and animtrack and animtrack.TimePosition < 0.7 do
			task.wait(0.05)
		end

		if animtrack then
			animtrack:Stop()
			animtrack:Destroy()
			animtrack = nil
		end
	end
end)

tool.Unequipped:Connect(function()
	doing = false
	if animtrack then
		animtrack:Stop()
		animtrack:Destroy()
		animtrack = nil
	end
end)

hum.Died:Connect(function()
	doing = false
	if animtrack then
		animtrack:Stop()
		animtrack:Destroy()
		animtrack = nil
	end
end)
