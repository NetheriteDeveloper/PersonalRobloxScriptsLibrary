--Keybind is C


--[[ SETTINGS ]]
local rotateCharacter = true         -- Face target with your body
local unlockZoom = true              -- Remove camera zoom limits
local legitMode = false              -- Slight randomness to aim (look legit)
local usePrediction = false          -- Predict enemy position
local predictionOffset = 2           -- Units ahead of enemy to predict
local forceMouseLock = false          -- Constantly force mouse to center

--[[ LIBRARIES ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local camLockEnabled = false
local targetPlayer = nil

-- Unlock zoom if requested
if unlockZoom then
	pcall(function()
		localPlayer.CameraMaxZoomDistance = 999
		localPlayer.CameraMinZoomDistance = 0.5
	end)
end

-- Get closest player to lock onto
local function getClosestPlayer()
	local shortest = math.huge
	local closest = nil
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			local hum = player.Character:FindFirstChild("Humanoid")
			if hrp and hum and hum.Health > 0 then
				local myHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				if myHRP then
					local dist = (hrp.Position - myHRP.Position).Magnitude
					if dist < shortest then
						shortest = dist
						closest = hrp
					end
				end
			end
		end
	end
	return closest
end

-- Listen for keybind (C)
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.C then
		camLockEnabled = not camLockEnabled
		if not camLockEnabled then
			targetPlayer = nil
			local char = localPlayer.Character
			if char and char:FindFirstChild("Humanoid") then
				char.Humanoid.AutoRotate = true
			end
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		end
	end
end)

-- Camlock loop
RunService.RenderStepped:Connect(function()
	if not camLockEnabled then return end

	-- Force lock center if setting is enabled
	if forceMouseLock and UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	end

	targetPlayer = getClosestPlayer()
	if not targetPlayer then return end

	local char = localPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChild("Humanoid")
	if not hrp or not humanoid then return end

	humanoid.AutoRotate = not rotateCharacter and true or false

	local aimPosition = targetPlayer.Position

	-- Apply prediction
	if usePrediction then
		local rootVel = targetPlayer.Velocity
		aimPosition = aimPosition + (rootVel.Unit * predictionOffset)
	end

	-- Apply legitMode randomness
	if legitMode then
		local offset = Vector3.new(
			math.random(-3, 3) / 100,
			math.random(-3, 3) / 100,
			math.random(-3, 3) / 100
		)
		aimPosition = aimPosition + offset
	end

	-- Lock camera
	camera.CFrame = CFrame.new(camera.CFrame.Position, aimPosition)

	-- Optional body rotation
	if rotateCharacter then
		local direction = (aimPosition - hrp.Position).Unit
		hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(direction.X, 0, direction.Z))
	end
end)
