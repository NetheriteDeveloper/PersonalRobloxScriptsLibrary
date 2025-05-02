--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Generated using RoadToGlory's Converter v1.1 (RoadToGlory#9879)

-- Instances:

local Converted = {
	["_ScreenGui"] = Instance.new("ScreenGui");
	["_TextLabel"] = Instance.new("TextLabel");
	["_LocalScript"] = Instance.new("LocalScript");
	["_UIStroke"] = Instance.new("UIStroke");
}

-- Properties:

Converted["_ScreenGui"].Parent = game:GetService("CoreGui")

Converted["_TextLabel"].Font = Enum.Font.FredokaOne
Converted["_TextLabel"].Text = "FPS"
Converted["_TextLabel"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel"].TextScaled = true
Converted["_TextLabel"].TextSize = 14
Converted["_TextLabel"].TextWrapped = true
Converted["_TextLabel"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel"].BackgroundTransparency = 1
Converted["_TextLabel"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel"].BorderSizePixel = 0
Converted["_TextLabel"].Position = UDim2.new(0, 0, 0.958333313, 0)
Converted["_TextLabel"].Size = UDim2.new(0.200000003, 0, 0.0405797213, 0)
Converted["_TextLabel"].Parent = Converted["_ScreenGui"]

Converted["_UIStroke"].Parent = Converted["_TextLabel"]

-- Fake Module Scripts:

local fake_module_scripts = {}


-- Fake Local Scripts:

local function HCYOEG_fake_script() -- Fake Script: StarterGui.ScreenGui.TextLabel.LocalScript
    local script = Instance.new("LocalScript")
    script.Name = "LocalScript"
    script.Parent = Converted["_TextLabel"]
    local req = require
    local require = function(obj)
        local fake = fake_module_scripts[obj]
        if fake then
            return fake()
        end
        return req(obj)
    end

	local RunService = game:GetService("RunService")
	local textLabel = script.Parent
	
	local fps = 0
	local frameCount = 0
	local lastTime = tick()
	
	RunService.Heartbeat:Connect(function()
	    frameCount += 1
	    local currentTime = tick()
	    
	    if currentTime - lastTime >= 1 then
	        fps = frameCount
	        frameCount = 0
	        lastTime = currentTime
	        textLabel.Text = string.format("FPS: %.1f", fps)
	    end
	end)
	
	
end

coroutine.wrap(HCYOEG_fake_script)()
