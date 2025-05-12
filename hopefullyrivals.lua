--// Key System
local correctKey = "71f18923566"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Key GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "KeySystem"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "Enter Access Key"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansSemibold
Title.TextSize = 20

local Box = Instance.new("TextBox", Frame)
Box.PlaceholderText = "Enter key here..."
Box.Size = UDim2.new(0.8, 0, 0, 30)
Box.Position = UDim2.new(0.1, 0, 0.45, 0)
Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Box.TextColor3 = Color3.new(1, 1, 1)
Box.Font = Enum.Font.SourceSans
Box.TextSize = 18
Box.ClearTextOnFocus = false

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(0.8, 0, 0, 30)
Button.Position = UDim2.new(0.1, 0, 0.75, 0)
Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Button.Text = "Submit"
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 18

Button.MouseButton1Click:Connect(function()
    if Box.Text == correctKey then
        ScreenGui:Destroy()
        loadMainScript()
    else
        Box.Text = "Invalid key!"
        wait(1)
        Box.Text = ""
    end
end)

--// Main Script (inside function)
function loadMainScript()
getgenv().AimPart = "Head"
getgenv().FOV = 150
getgenv().Smoothness = 2
getgenv().AimKey = Enum.KeyCode.E
getgenv().AimInputType = "KeyCode"
getgenv().MaxDistance = 100
getgenv().AimbotEnabled = false
getgenv().ESPEnabled = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Holding = false

-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Axiiiom/UILIB/refs/heads/main/LIBHE"))()
local Window = Library:CreateWindow("Rivals Hub", Vector2.new(492, 598), Enum.KeyCode.RightControl)
local AimingTab = Window:CreateTab("Aiming")

local AimSection = AimingTab:CreateSector("Aimbot & ESP Settings", "left")

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = getgenv().FOV
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Visible = true

-- ESP storage
local ESPs = {}
function CreateESP(player)
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Transparency = 1
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Visible = false

    local dot = Drawing.new("Circle")
    dot.Radius = 5
    dot.Filled = true
    dot.Color = Color3.fromRGB(255, 0, 0)
    dot.Visible = false

    ESPs[player] = {Box = box, Dot = dot}
end

function RemoveESP(player)
    if ESPs[player] then
        ESPs[player].Box:Remove()
        ESPs[player].Dot:Remove()
        ESPs[player] = nil
    end
end

function GetClosestPlayer()
    local closest = nil
    local shortestDistance = getgenv().FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(getgenv().AimPart) then
            local part = player.Character[getgenv().AimPart]
            local pos, visible = Camera:WorldToViewportPoint(part.Position)
            if visible then
                local distance = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closest = player
                end
            end
        end
    end

    return closest
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then 
        CreateESP(player)
    end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then 
        CreateESP(p)
    end
end)
Players.PlayerRemoving:Connect(RemoveESP)

AimSection:AddToggle("Aimbot Enabled", false, function(state)
    getgenv().AimbotEnabled = state
end)

AimSection:AddToggle("ESP Enabled", false, function(state)
    getgenv().ESPEnabled = state
end)

AimSection:AddSlider("FOV", 50, 150, 500, 1, function(value)
    getgenv().FOV = value
    FOVCircle.Radius = value
end)

AimSection:AddSlider("Smoothness", 1, 2, 10, 1, function(value)
    getgenv().Smoothness = value
end)

AimSection:AddSlider("Max Distance", 50, 100, 500, 1, function(value)
    getgenv().MaxDistance = value
end)

AimSection:AddDropdown("Aim Part", {"Head", "Torso", "HumanoidRootPart"}, "Head", false, function(value)
    getgenv().AimPart = value
end)

AimSection:AddDropdown("Aim Key", {"MouseButton2/Right Click", "E", "Q", "LeftShift"}, "E", false, function(value)
    if value == "MouseButton2/Right Click" then
        getgenv().AimKey = Enum.UserInputType.MouseButton2
        getgenv().AimInputType = "UserInputType"
    elseif value == "E" then
        getgenv().AimKey = Enum.KeyCode.E
        getgenv().AimInputType = "KeyCode"
    elseif value == "Q" then
        getgenv().AimKey = Enum.KeyCode.Q
        getgenv().AimInputType = "KeyCode"
    elseif value == "LeftShift" then
        getgenv().AimKey = Enum.KeyCode.LeftShift
        getgenv().AimInputType = "KeyCode"
    end
end)

local FOVColorToggle = AimSection:AddToggle("FOV Color", false, function() end)
FOVColorToggle:AddColorpicker(Color3.fromRGB(0, 255, 0), function(color)
    FOVCircle.Color = color
end)

local ESPColorToggle = AimSection:AddToggle("ESP Color", false, function() end)
ESPColorToggle:AddColorpicker(Color3.fromRGB(255, 0, 0), function(color)
    for _, esp in pairs(ESPs) do
        esp.Box.Color = color
        esp.Dot.Color = color
    end
end)

AimingTab:CreateConfigSystem("right")

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if getgenv().AimInputType == "KeyCode" and input.KeyCode == getgenv().AimKey then
            Holding = true
        elseif getgenv().AimInputType == "UserInputType" and input.UserInputType == getgenv().AimKey then
            Holding = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if getgenv().AimInputType == "KeyCode" and input.KeyCode == getgenv().AimKey then
            Holding = false
        elseif getgenv().AimInputType == "UserInputType" and input.UserInputType == getgenv().AimKey then
            Holding = false
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = center
    FOVCircle.Visible = getgenv().AimbotEnabled

    if Holding and getgenv().AimbotEnabled then
        local target = GetClosestPlayer()
        if target and target.Character then
            local part = target.Character:FindFirstChild(getgenv().AimPart)
            if part then
                local pos = Camera:WorldToViewportPoint(part.Position)
                local delta = (Vector2.new(pos.X, pos.Y) - center) / getgenv().Smoothness
                pcall(function()
                    mousemoverel(delta.X, delta.Y)
                end)
            end
        end
    end

    for player, esp in pairs(ESPs) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
            local hrp = char.HumanoidRootPart
            local head = char.Head
            local headPos, headVisible = Camera:WorldToViewportPoint(head.Position)
            local hrpPos, hrpVisible = Camera:WorldToViewportPoint(hrp.Position)
            local distance = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (char.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or math.huge

            if headVisible and hrpVisible and distance <= getgenv().MaxDistance and getgenv().ESPEnabled then
                local height = math.clamp((headPos - hrpPos).Y * 2, 2, 400)
                local width = height / 1.5
                esp.Box.Size = Vector2.new(width, height)
                esp.Box.Position = Vector2.new(hrpPos.X - width / 2, hrpPos.Y - height / 2)
                esp.Box.Visible = true
                esp.Dot.Position = Vector2.new(headPos.X, headPos.Y)
                esp.Dot.Visible = true
            else
                esp.Box.Visible = false
                esp.Dot.Visible = false
            end
        else
            esp.Box.Visible = false
            esp.Dot.Visible = false
        end
    end
end)
end
