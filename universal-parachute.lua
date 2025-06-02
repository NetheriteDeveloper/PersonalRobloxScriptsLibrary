--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local parachute = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
parachute.Name = "Parachute"
parachute.TextureId = "rbxassetid://12092573037"
parachute.CanBeDropped = false
parachute.RequiresHandle = true

local handle = Instance.new("Part", parachute)
handle.Name = "Handle"
handle.Size = Vector3.new(0.05, 0.05, 0.05)  
handle.Color = Color3.fromRGB(0, 0, 0) 
handle.Anchored = false
handle.CanCollide = false

local velocity = Instance.new("BodyVelocity", handle)
velocity.MaxForce = Vector3.new(0, 99999, 0) 
velocity.Velocity = Vector3.new(0, -10, 0)  

local sphere = nil  

parachute.Equipped:Connect(function()
    sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.new(2, 1, 2) 
    sphere.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)  
    sphere.Anchored = false  
    sphere.CanCollide = false  
    sphere.BrickColor = BrickColor.new(Color3.fromRGB(0, 0, 0))  
    
    sphere.Material = Enum.Material.SmoothPlastic
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Sphere
    mesh.Scale = Vector3.new(4, 2, 4)  
    mesh.Parent = sphere
    
    sphere.Parent = game.Workspace

    velocity.Parent = handle

    game:GetService("RunService").Heartbeat:Connect(function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
            local currentVelocity = humanoidRootPart.Velocity

            velocity.Velocity = Vector3.new(0, -10, 0)  
        end
    end)
end)

parachute.Unequipped:Connect(function()
    if sphere then
        sphere:Destroy()
    end

    local bodyVelocity = handle:FindFirstChild("BodyVelocity")
    if bodyVelocity then
        bodyVelocity.Parent = nil  
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if sphere and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        sphere.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    end
end)
