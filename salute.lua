local plr = game:GetService("Players").LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:FindFirstChild("Humanoid") or char:WaitForChild("Humanoid")
local anim = hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator")
local pack = plr:FindFirstChild("Backpack") or plr:WaitForChild("Backpack")
if workspace:FindFirstChild("Heil") then
	workspace:FindFirstChild("Heil"):Destroy()
end
local function getmodel()
	return hum.RigType == Enum.HumanoidRigType.R6 and "R6"
end
local function Notify(Title, Text, Duration)
	game:GetService('StarterGui'):SetCore('SendNotification', {
        Title = Title,
        Text = Text or '',
        Duration = Duration}
    )
end	
Notify("skidded by gpjc", "Salute on them!", 4)
local animation = Instance.new("Animation")
animation.Name = "Heil"
animation.Parent = workspace
animation.AnimationId = getmodel() == "R6" and "rbxassetid://186904307"
local tool = Instance.new("Tool")
tool.Name = ""
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
		animtrack:AdjustSpeed(0.1)
		animtrack.TimePosition = (infinite)
		task.wait(0.3)
		while doing and animtrack and animtrack.TimePosition < 0.6 do
			task.wait(1)
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
