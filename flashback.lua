--- [[ Simple Time Rewind ]] ---
-- CLICK R TO BEGIN

local me = game.Players.LocalPlayer
local mouse = me:GetMouse()
local char = me.Character
local hum = char:FindFirstChild('Humanoid')
local hd = char:FindFirstChild('Head')
local ts = char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
local ra = char:FindFirstChild('Right Arm') or char:FindFirstChild('RightUpperArm')
local la = char:FindFirstChild('Left Arm') or char:FindFirstChild('LeftUpperArm')
local rl = char:FindFirstChild('Right Leg') or char:FindFirstChild('RightUpperLeg')
local ll = char:FindFirstChild('Left Leg') or char:FindFirstChild('LeftUpperLeg')
local root = char:FindFirstChild('HumanoidRootPart')
local rj = root:FindFirstChild('RootJoint')
local rs = ts:FindFirstChild('Right Shoulder')
local ls = ts:FindFirstChild('Left Shoulder')
local rh = ts:FindFirstChild('Right Hip')
local lh = ts:FindFirstChild('Left Hip')
local nk = ts:FindFirstChild('Neck')
local anim = char:FindFirstChild('Animate')
local base = workspace:FindFirstChild('Baseplate') or workspace:FindFirstChild('Base')
local cantimerewind = true
local cooldown = false
local selfrewind = true
local cc = workspace.CurrentCamera
local cos = math.cos
local sin = math.sin
local rad = math.rad
local rand = math.random
local cfn = CFrame.new
local cfa = CFrame.Angles
local v3 = Vector3.new
local str = string
local past = {}
local lastpast = {}
local sine = 0
local rewind = Instance.new('Sound', hd)
local onrewind = Instance.new('Sound', workspace.CurrentCamera)
onrewind.Looped = true
onrewind.Volume = 10
onrewind.SoundId = 'rbxassetid://2061143306'
rewind.SoundId = 'rbxassetid://864569342'
rewind.Name = 'trewind'
rewind.Volume = 1
rewind.PlaybackSpeed = 1.25
hum.WalkSpeed = 23
effects = Instance.new('Folder', char)
effects.Name = 'Effects'
print([[
	-- // Moves
	R - Rewind
	]])

ArtificialHB = Instance.new('BindableEvent', script)
ArtificialHB.Name = 'Heartbeat'
script:WaitForChild('Heartbeat')

frame = 1 / 60
tf = 0
allowframeloss = false
tossremainder = false
lastframe = tick()
script.Heartbeat:Fire()

game:GetService('RunService').Heartbeat:connect(function(s, p)
	tf = tf + s
	if tf >= frame then
		if allowframeloss then
			script.Heartbeat:Fire()
			lastframe = tick()
		else
			for i = 1, math.floor(tf / frame) do
				script.Heartbeat:Fire()
			end
			lastframe = tick()
		end
		if tossremainder then
			tf = 0
		else
			tf = tf - frame * math.floor(tf / frame)
		end
	end
end)

function swait(t)
	if t == 0 or t == nil then
		script.Heartbeat.Event:Wait()
	else
		for i = 0, t do
			script.Heartbeat.Event:Wait()
		end
	end
end

function sound(id, parent, vol, pitch, timepos)
	local s = Instance.new('Sound')
	s.Parent = parent
	s.SoundId = id
	s.Volume = vol
	s.PlaybackSpeed = pitch
	s.TimePosition = timepos
	s:Play()
	game.Debris:AddItem(s, s.PlaybackSpeed + 5)
end

function camshake(duration, intensity)
	coroutine.wrap(function()
		for i = 0, duration*60 do
			hum.CameraOffset = v3(rand(-(intensity*10),(intensity*10))/10, rand(-(intensity*10),(intensity*10))/10, rand(-(intensity*10), (intensity*10))/10)
			swait()
		end
		hum.CameraOffset = v3(0, 0, 0)
	end)()
end

function readyrewind()
	cantimerewind = false
	cooldown = true
	onrewind:Play()
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA('BasePart') then
			local lastpos = v.CFrame
			table.insert(past, {part = v, change = lastpos})
		end
		if v.Parent then
			local lastparent2 = v.Parent
			table.insert(lastpast, {part2 = v, change4 = lastparent2})
		end
		if v:IsA('Camera') then
			local lastcam = v.CFrame
			table.insert(past, {cam = v, change3 = lastcam})
		end
		if v:IsA('Sound') then
			if v ~= rewind then
				local lastsongpos = v.TimePosition
				table.insert(past, {sound = v, pchange = lastsongpos})
			end
		end
		if v:IsA('Humanoid') then
			local lasthp = v.Health
			local always = lasthp
			table.insert(past, {health = v, hchange = lasthp})
		end
	end
	newpast = workspace.DescendantAdded:Connect(function(v)
		if v:IsA('BasePart') then
			local lastpos = v.CFrame
			local lastparent = v.Parent
			table.insert(past, {part = v, change = lastpos, change4 = lastparent})
		end
		if v.Parent then
			local lastparent2 = v.Parent
			table.insert(lastpast, {part2 = v, change4 = lastparent2})
		end
		if v:IsA('Camera') then
			local lastcampos = v.CFrame
			table.insert(past, {cam = v, change3 = lastcampos})
		end
		if v:IsA('Sound') then
			if v ~= rewind then
				local lastsongpos = v.TimePosition
				table.insert(past, {sound = v, pchange = lastsongpos})
			end
		end
		if v:IsA('Humanoid') then
			local lasthp = v.Health
			local always = lasthp
			table.insert(past, {health = v, hchange = lasthp})
		end
	end)
end

function timerewind()
	if cooldown then
	rewind:Play()
	sine = 0
	onrewind:Stop()
	coroutine.wrap(function()
	local cce = Instance.new('ColorCorrectionEffect', game.Lighting)
	local blur = Instance.new('BlurEffect', game.Lighting)
	local effect2 = Instance.new('Part', effects)
	local effect3 = Instance.new('Part', effects)
	effect3.Shape = 'Ball'
	effect3.Material = 'ForceField'
	effect3.Anchored = true
	effect3.CanCollide = false
	effect3.Name = 'eff3'
	effect3.BrickColor = BrickColor.new('Really red')
	effect3.Size = v3(30, 30, 30)
	effect3.Transparency = 0
	effect2.CastShadow = false
	effect2.Shape = 'Ball'
	effect2.BrickColor = BrickColor.new('Bright red')
	effect2.Material = 'ForceField'
	effect2.Name = 'eff2'
	effect2.Anchored = true
	effect2.CanCollide = false
	effect2.Size = v3(50, 50, 50)
	effect2.Transparency = 0
	cantimerewind = true
	for i,v in pairs(past) do
		pcall(function()
			v.part.CFrame = v.change
		end)
		pcall(function()
		   	v.cam.CFrame = v.change3
		end)
		pcall(function()
			v.sound.TimePosition = v.pchange
		end)
		pcall(function()
			v.health.Health = v.hchange
		end)
	end
	for i,v in pairs(lastpast) do
		pcall(function()
			v.part2.Parent = v.change4
		end)
	end
	pcall(function()
		newpast:Disconnect()
	end)
	coroutine.wrap(function()
		for i = 1, 1000 do
			effect2.CFrame = ts.CFrame
			effect3.CFrame = ts.CFrame
			blur.Size = v3(blur.Size, 0, 0):lerp(v3(0, 0, 0), .010).X
			cce.TintColor = cce.TintColor:lerp(Color3.fromRGB(255, 0, 0), 0.050)
			effect2.Transparency = effect2.Transparency + 0.020
			effect3.Transparency = effect3.Transparency + 0.020
			effect2.Size = effect2.Size:lerp(v3(0, 0, 0), 0.050)
			effect3.Size = effect3.Size:lerp(v3(0, 0, 0), 0.030)
			if effect2.Transparency >= 1 then
				effect2:Destroy()
			end
			if effect3.Transparency >= 1 then
				effect3:Destroy()
			end
			swait()
		end
	end)()
	wait(1)
	blur:Destroy()
	cce:Destroy()
	end)()
	wait(1.5) -- cooldown
	past = {}
	cooldown = false
	end
end

mouse.KeyDown:connect(function(key)
	if str.lower(key) == 'r' and cantimerewind and cooldown == false then
		readyrewind()
	elseif str.lower(key) == 'r' and cantimerewind == false and cooldown then
		timerewind()
	end
end)
