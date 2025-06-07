--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local E_FLING_FORCE = 70
local E_UPWARD_FORCE = 50
local E_FLING_DURATION = 0.4
local E_SPIN_SPEED = 60

local F_FLING_FORCE = 100
local F_FLING_DURATION = 0.35
local F_SPIN_SPEED = 50

local Q_FLING_FORCE = 60
local Q_UPWARD_FORCE = 40
local Q_FLING_DURATION = 0.45
local Q_SPIN_SPEED = 45

local R_FLING_FORCE = 50
local R_UPWARD_FORCE = 80
local R_FLING_DURATION = 0.5
local R_SPIN_SPEED = 70

local function createGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player.PlayerGui
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 150)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.Parent = screenGui

    local function createLabel(text, yPos)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Position = UDim2.new(0, 0, 0, yPos)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Text = text
        label.TextSize = 16
        label.Font = Enum.Font.SourceSansBold
        label.Parent = frame
    end

    createLabel("E: main fling", 0)
    createLabel("F: super fling", 30)
    createLabel("Q: left fling", 60)
    createLabel("R: up fling", 90)
end

local function flingPlayerE()
    if humanoid.Health > 0 then
        local forwardDirection = humanoidRootPart.CFrame.LookVector
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = (forwardDirection * E_FLING_FORCE) + Vector3.new(0, E_UPWARD_FORCE, 0)
        bodyVelocity.Parent = humanoidRootPart
        
        local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngularVelocity.AngularVelocity = Vector3.new(
            math.random(-E_SPIN_SPEED, E_SPIN_SPEED),
            math.random(-E_SPIN_SPEED, E_SPIN_SPEED),
            math.random(-E_SPIN_SPEED, E_SPIN_SPEED)
        )
        bodyAngularVelocity.Parent = humanoidRootPart
        
        game:GetService("Debris"):AddItem(bodyVelocity, E_FLING_DURATION)
        game:GetService("Debris"):AddItem(bodyAngularVelocity, E_FLING_DURATION)
    end
end

local function flingPlayerF()
    if humanoid.Health > 0 then
        local forwardDirection = humanoidRootPart.CFrame.LookVector
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
        bodyVelocity.Velocity = forwardDirection * F_FLING_FORCE
        bodyVelocity.Parent = humanoidRootPart
        
        local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.MaxTorque = Vector3.new(math.huge, 0, 0)
        bodyAngularVelocity.AngularVelocity = Vector3.new(F_SPIN_SPEED, 0, 0)
        bodyAngularVelocity.Parent = humanoidRootPart
        
        game:GetService("Debris"):AddItem(bodyVelocity, F_FLING_DURATION)
        game:GetService("Debris"):AddItem(bodyAngularVelocity, F_FLING_DURATION)
    end
end

local function flingPlayerQ()
    if humanoid.Health > 0 then
        local leftDirection = -humanoidRootPart.CFrame.RightVector
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = (leftDirection * Q_FLING_FORCE) + Vector3.new(0, Q_UPWARD_FORCE, 0)
        bodyVelocity.Parent = humanoidRootPart
        
        local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.MaxTorque = Vector3.new(0, 0, math.huge)
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, Q_SPIN_SPEED)
        bodyAngularVelocity.Parent = humanoidRootPart
        
        game:GetService("Debris"):AddItem(bodyVelocity, Q_FLING_DURATION)
        game:GetService("Debris"):AddItem(bodyAngularVelocity, Q_FLING_DURATION)
    end
end

local function flingPlayerR()
    if humanoid.Health > 0 then
        local forwardDirection = humanoidRootPart.CFrame.LookVector
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = (forwardDirection * R_FLING_FORCE) + Vector3.new(0, R_UPWARD_FORCE, 0)
        bodyVelocity.Parent = humanoidRootPart
        
        local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngularVelocity.AngularVelocity = Vector3.new(
            math.random(-R_SPIN_SPEED, R_SPIN_SPEED),
            math.random(-R_SPIN_SPEED, R_SPIN_SPEED),
            math.random(-R_SPIN_SPEED, R_SPIN_SPEED)
        )
        bodyAngularVelocity.Parent = humanoidRootPart
        
        game:GetService("Debris"):AddItem(bodyVelocity, R_FLING_DURATION)
        game:GetService("Debris"):AddItem(bodyAngularVelocity, R_FLING_DURATION)
    end
end

createGui()

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.E then
            flingPlayerE()
        elseif input.KeyCode == Enum.KeyCode.F then
            flingPlayerF()
        elseif input.KeyCode == Enum.KeyCode.Q then
            flingPlayerQ()
        elseif input.KeyCode == Enum.KeyCode.R then
            flingPlayerR()
        end
    end
end)

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    createGui()
end)
