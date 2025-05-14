local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Create the GUI button
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FloatToolGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.8, 0)
button.Text = "Get Float Tool"
button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.Parent = screenGui

-- Button Click: Create and equip the tool
button.MouseButton1Click:Connect(function()
    -- Create the tool and give it to the player
    local tool = Instance.new("Tool")
    tool.Name = "FloatTool"
    tool.RequiresHandle = true
    tool.Parent = player.Backpack

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(2, 1, 2)
    handle.BrickColor = BrickColor.new("Lime green")
    handle.Material = Enum.Material.Neon
    handle.CanCollide = true
    handle.Anchored = false
    handle.Parent = tool

    -- Float logic
    local hovering = false
    local bodyGyro = nil
    local bodyVelocity = nil

    -- When the tool is equipped
    tool.Equipped:Connect(function()
        -- Set up a click event for hovering
        tool.Activated:Connect(function()
            local char = player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            if not hovering then
                -- Freeze in place (hovering)
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                bodyVelocity.Parent = root

                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.D = 500
                bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bodyGyro.CFrame = root.CFrame
                bodyGyro.Parent = root

                hovering = true
            else
                -- Unfreeze (stop hovering)
                if bodyVelocity then bodyVelocity:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
                hovering = false
            end
        end)
    end)
end)
