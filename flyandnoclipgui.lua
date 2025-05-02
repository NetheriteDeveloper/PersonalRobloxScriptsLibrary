--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Full working fly script with custom GUI style and draggable panel

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local noclip = false
local speeds = {25, 50, 100, 200}
local speedIndex = 2
local currentSpeed = speeds[speedIndex]

local keys = {W=false, A=false, S=false, D=false, Up=false, Down=false}
local char, root
local bodyVel = Instance.new("BodyVelocity")
bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
bodyVel.P = 1000

local function updateCharacter()
    char = player.Character or player.CharacterAdded:Wait()
    root = char:WaitForChild("HumanoidRootPart")
end
updateCharacter()

local function createGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "FlyControlPanel"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 200, 0, 200)
    panel.Position = UDim2.new(0, 30, 0, 120)
    panel.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.Draggable = true
    panel.Active = true
    panel.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = panel

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = panel

    local function makeButton(text)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 160, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 20
        btn.Text = text
        btn.AutoButtonColor = false

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

        local hover = Instance.new("UIStroke")
        hover.Thickness = 0
        hover.Color = Color3.fromRGB(255, 255, 255)
        hover.Parent = btn

        btn.MouseEnter:Connect(function() hover.Thickness = 1 end)
        btn.MouseLeave:Connect(function() hover.Thickness = 0 end)

        return btn
    end

    local toggleBtn = makeButton("×")
    toggleBtn.Size = UDim2.new(0, 30, 0, 30)
    toggleBtn.TextSize = 22
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggleBtn.Parent = panel

    local flyBtn = makeButton("Fly")
    flyBtn.Parent = panel

    local noclipBtn = makeButton("Noclip: Off")
    noclipBtn.Parent = panel

    local speedBtn = makeButton("Speed: 50")
    speedBtn.Parent = panel

    return panel, toggleBtn, flyBtn, noclipBtn, speedBtn
end

local panel, toggleBtn, flyBtn, noclipBtn, speedBtn = createGUI()

local collapsed = false
toggleBtn.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    for _, child in ipairs(panel:GetChildren()) do
        if child:IsA("TextButton") and child ~= toggleBtn then
            child.Visible = not collapsed
        end
    end
    panel.Size = collapsed and UDim2.new(0, 60, 0, 40) or UDim2.new(0, 200, 0, 200)
    toggleBtn.Text = collapsed and "+" or "×"
end)

flyBtn.MouseButton1Click:Connect(function()
    if not root then return end
    flying = not flying
    flyBtn.Text = flying and "Unfly" or "Fly"
    bodyVel.Parent = flying and root or nil
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = "Noclip: " .. (noclip and "On" or "Off")
end)

speedBtn.MouseButton1Click:Connect(function()
    speedIndex = speedIndex % #speeds + 1
    currentSpeed = speeds[speedIndex]
    speedBtn.Text = "Speed: " .. currentSpeed
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local k = input.KeyCode
    if k == Enum.KeyCode.W then keys.W = true
    elseif k == Enum.KeyCode.A then keys.A = true
    elseif k == Enum.KeyCode.S then keys.S = true
    elseif k == Enum.KeyCode.D then keys.D = true
    elseif k == Enum.KeyCode.Space then keys.Up = true
    elseif k == Enum.KeyCode.LeftShift then keys.Down = true end
end)

UIS.InputEnded:Connect(function(input)
    local k = input.KeyCode
    if k == Enum.KeyCode.W then keys.W = false
    elseif k == Enum.KeyCode.A then keys.A = false
    elseif k == Enum.KeyCode.S then keys.S = false
    elseif k == Enum.KeyCode.D then keys.D = false
    elseif k == Enum.KeyCode.Space then keys.Up = false
    elseif k == Enum.KeyCode.LeftShift then keys.Down = false end
end)

RunService.RenderStepped:Connect(function()
    if flying and root then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if keys.W then dir += cam.CFrame.LookVector end
        if keys.S then dir -= cam.CFrame.LookVector end
        if keys.A then dir -= cam.CFrame.RightVector end
        if keys.D then dir += cam.CFrame.RightVector end
        if keys.Up then dir += Vector3.new(0, 1, 0) end
        if keys.Down then dir -= Vector3.new(0, 1, 0) end
        bodyVel.Velocity = dir.Magnitude > 0 and dir.Unit * currentSpeed or Vector3.zero
    end

    if noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

player.CharacterAdded:Connect(function()
    updateCharacter()
    flying = false
    bodyVel.Parent = nil
    flyBtn.Text = "Fly"

    if noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
