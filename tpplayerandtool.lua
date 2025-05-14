--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Layanan
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- TOOL: TP TOOL (teleport klik mouse)
local tpTool = Instance.new("Tool")
tpTool.Name = "TP Tool"
tpTool.RequiresHandle = false
tpTool.CanBeDropped = false
tpTool.Parent = LocalPlayer.Backpack

tpTool.Activated:Connect(function()
    local mouse = LocalPlayer:GetMouse()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if character and mouse then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

-- TOOL: TP PLAYER TOOL
local tpPlayerTool = Instance.new("Tool")
tpPlayerTool.Name = "TP Player Tool"
tpPlayerTool.RequiresHandle = false
tpPlayerTool.CanBeDropped = false
tpPlayerTool.Parent = LocalPlayer.Backpack

-- UI Function
local uiInstance = nil

local function createTPPlayerUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TPPlayerUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = game.CoreGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 250, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    title.Text = "Teleport to Player"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = mainFrame

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Position = UDim2.new(0, 0, 0, 30)
    scrollingFrame.Size = UDim2.new(1, 0, 1, -30)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.Parent = mainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = scrollingFrame

    local function updatePlayers()
        for _, child in ipairs(scrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.Text = plr.Name
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.Font = Enum.Font.SourceSans
                btn.TextSize = 16
                btn.Parent = scrollingFrame

                btn.MouseButton1Click:Connect(function()
                    local targetChar = plr.Character
                    local myChar = LocalPlayer.Character
                    if targetChar and myChar then
                        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                        if targetRoot and myRoot then
                            myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
                        end
                    end
                end)
            end
        end
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end

    updatePlayers()
    Players.PlayerAdded:Connect(updatePlayers)
    Players.PlayerRemoving:Connect(updatePlayers)

    return screenGui
end

-- Tool Events
tpPlayerTool.Equipped:Connect(function()
    if not uiInstance then
        uiInstance = createTPPlayerUI()
    else
        uiInstance.Enabled = true
    end
end)

tpPlayerTool.Unequipped:Connect(function()
    if uiInstance then
        uiInstance.Enabled = false
    end
end)
