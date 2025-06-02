local Running = false
local Frames = {}
local TimeStart = tick()

local Player = game:GetService("Players").LocalPlayer
local getChar = function()
    local Character = Player.Character
    if Character then
        return Character
    else
        Player.CharacterAdded:Wait()
        return getChar()
    end
end


local StartRecord = function()
    Frames = {}
    Running = true
    TimeStart = tick()
    while Running == true do
        game:GetService("RunService").Heartbeat:wait()
        local Character = getChar()
        table.insert(Frames, {
            Character.HumanoidRootPart.CFrame,
            Character.Humanoid:GetState().Value,
            tick() - TimeStart
        })
    end
end

local StopRecord = function()
    Running = false
end

local PlayTAS = function()
    local Character = getChar()
    local TimePlay = tick()
    local FrameCount = #Frames
    local NewFrames = FrameCount
    local OldFrame = 1
    local TASLoop
    TASLoop = game:GetService("RunService").Heartbeat:Connect(function()
        local NewFrames = OldFrame + 60
        local CurrentTime = tick()
        if (CurrentTime - TimePlay) >= Frames[FrameCount][3] then
            TASLoop:Disconnect()
        end
        for i = OldFrame, NewFrames do
            local Frame = Frames[i]
            if Frame[3] <= CurrentTime - TimePlay then
                OldFrame = i
                Character.HumanoidRootPart.CFrame = Frame[1]
                Character.Humanoid:ChangeState(Frame[2])
            end
        end
    end)
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Global TAS",LoadingTitle = "\"its not working pls fix\"",LoadingSubtitle = "by tomato.txt",
   ConfigurationSaving = {Enabled = true,FolderName="tomato.txt",FileName="Global TAS by tomato.txt"},
   Discord = {Enabled = true,Invite="8N2M9fHJqa",RememberJoins=true},KeySystem = false,KeySettings = {Title="",Subtitle="",Note="",FileName="",SaveKey=true,GrabKeyFromSite=false,Key={""}}
})
local Tab = Window:CreateTab("Control", 4483362458)
local Section = Tab:CreateSection("Save")
local Button = Tab:CreateButton({
   Name = "Start recording",
   Callback = StartRecord,
})
local Button = Tab:CreateButton({
   Name = "Stop recording.",
   Callback = StopRecord,
})

local Button = Tab:CreateButton({
   Name = "Play",
   Callback = PlayTAS,
})


local Keybind = Tab:CreateKeybind({
   Name = "Start Recording BIND",
   CurrentKeybind = "",
   HoldToInteract = false,
   Flag = "StartRecord",
   Callback = StartRecord,
})

local Keybind = Tab:CreateKeybind({
   Name = "Stop Recording BIND",
   CurrentKeybind = "",
   HoldToInteract = false,
   Flag = "StopRecord",
   Callback = StopRecord,
})

local Keybind = Tab:CreateKeybind({
   Name = "Play BIND",
   CurrentKeybind = "",
   HoldToInteract = false,
   Flag = "PlayTAS",
   Callback = PlayTAS,
})
