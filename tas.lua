local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Keybinds = {
    AddSavestate = "One",
    RemoveSavestate = "Two",
    BackSavestate = "Eight",
    GoFrameBack = "Four",
    GoFrameForward = "Five",
    SaveRun = "Six",
    UserPause = "CapsLock",
    CollisionToggler = "C",
    ResetToNormal = "Delete",
    ViewTAS = "Zero"
}

local Savestates = {}
local PlayerInfo = {}
local TimePaused = 0
local Pause = true
local TimePauseHolder
local TimeStart
local FrameCountLabel
local SavestatesCountLabel
local TimeTextLabel
local CapLockPauseLabel
local KeyBindFrame
local HUD
local MainConnectionLoop
local KeybindsConnect
local InputEndConnect
local DiedConnect

local CurrentAnimationState = { Name = "Idle", Weight = 0 }

local function getCurrentCFrame()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return LocalPlayer.Character.HumanoidRootPart.CFrame
    end
    return CFrame.new()
end

local function getCurrentVelocity()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return LocalPlayer.Character.HumanoidRootPart.Velocity
    end
    return Vector3.new()
end

local function getCurrentCameraCFrame()
    return Workspace.CurrentCamera.CFrame
end

local function ReturnPlayerInfo()
    return {
        CFrame = getCurrentCFrame(),
        CameraCFrame = getCurrentCameraCFrame(),
        Velocity = getCurrentVelocity(),
        Animation = CurrentAnimationState,
        Time = tick() - TimeStart - TimePaused,
    }
end

local function UpdateGUIText()
    if SavestatesCountLabel then
        SavestatesCountLabel.Text = "Savestates: " .. #Savestates
    end
    if FrameCountLabel then
        FrameCountLabel.Text = "Frames: " .. #PlayerInfo
    end
end

local function FormatTime(TimeValue)
    local m = math.floor(TimeValue / 60)
    local s = math.floor(TimeValue % 60)
    local ms = math.floor((TimeValue * 1000) % 1000)
    local msStr = tostring(ms)
    local sStr = tostring(s)

    while #msStr < 3 do msStr = '0' .. msStr end
    while #sStr < 2 do sStr = '0' .. sStr end

    return m .. ":" .. sStr .. "." .. msStr
end


local function UpdateTimeGUI()
    if TimeTextLabel then
        local TimePlayed = tick() - TimeStart - TimePaused
        TimeTextLabel.Text = FormatTime(TimePlayed)
    end
end

local function SetCharacterState(InfoState)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character:FindFirstChild("Humanoid") then return end

    local Hum = LocalPlayer.Character.Humanoid
    local RootPart = LocalPlayer.Character.HumanoidRootPart

    RootPart.CFrame = InfoState.CFrame
    RootPart.Velocity = InfoState.Velocity
    Workspace.CurrentCamera.CFrame = InfoState.CameraCFrame

    CurrentAnimationState = InfoState.Animation or { Name = "Idle", Weight = 0 }

    if CurrentAnimationState.Name and Hum then
        local Animator = Hum:FindFirstChildOfClass("Animator")
        if Animator then
             local PlayingTracks = Animator:GetPlayingAnimationTracks()
             for _, track in ipairs(PlayingTracks) do
                 if track.Name == CurrentAnimationState.Name then
                    track:AdjustSpeed(CurrentAnimationState.Weight or 1)
                    track.TimePosition = 0
                    break
                 end
             end
        end
    end
end

local function SetUpGui()
    if HUD then HUD:Destroy() end

    HUD = Instance.new("ScreenGui", CoreGui)
    HUD.Name = "TASRecorderGUI"
    HUD.ResetOnSpawn = false
    HUD.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame", HUD)
    MainFrame.AnchorPoint = Vector2.new(0.5, 1)
    MainFrame.Position = UDim2.new(0.5, 0, 1, -10)
    MainFrame.Size = UDim2.new(0, 250, 0, 100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.BorderColor3 = Color3.fromRGB(200, 200, 200)
    MainFrame.BorderSizePixel = 1

    local UIListLayout = Instance.new("UIListLayout", MainFrame)
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    TimeTextLabel = Instance.new("TextLabel", MainFrame)
    TimeTextLabel.Name = "TimeText"
    TimeTextLabel.LayoutOrder = 1
    TimeTextLabel.Size = UDim2.new(1, -10, 0, 20)
    TimeTextLabel.Position = UDim2.new(0, 5, 0, 5)
    TimeTextLabel.BackgroundTransparency = 1
    TimeTextLabel.Font = Enum.Font.SourceSansBold
    TimeTextLabel.Text = "0:00.000"
    TimeTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TimeTextLabel.TextScaled = true
    TimeTextLabel.TextXAlignment = Enum.TextXAlignment.Left

    SavestatesCountLabel = Instance.new("TextLabel", MainFrame)
    SavestatesCountLabel.Name = "SavestatesCount"
    SavestatesCountLabel.LayoutOrder = 2
    SavestatesCountLabel.Size = UDim2.new(1, -10, 0, 15)
    SavestatesCountLabel.BackgroundTransparency = 1
    SavestatesCountLabel.Font = Enum.Font.SourceSans
    SavestatesCountLabel.Text = "Savestates: 0"
    SavestatesCountLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    SavestatesCountLabel.TextScaled = true
    SavestatesCountLabel.TextXAlignment = Enum.TextXAlignment.Left

    FrameCountLabel = Instance.new("TextLabel", MainFrame)
    FrameCountLabel.Name = "FrameCount"
    FrameCountLabel.LayoutOrder = 3
    FrameCountLabel.Size = UDim2.new(1, -10, 0, 15)
    FrameCountLabel.BackgroundTransparency = 1
    FrameCountLabel.Font = Enum.Font.SourceSans
    FrameCountLabel.Text = "Frames: 0"
    FrameCountLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    FrameCountLabel.TextScaled = true
    FrameCountLabel.TextXAlignment = Enum.TextXAlignment.Left

    local KeybindsButton = Instance.new("TextButton", MainFrame)
    KeybindsButton.Name = "KeybindsButton"
    KeybindsButton.LayoutOrder = 4
    KeybindsButton.Size = UDim2.new(1, -10, 0, 20)
    KeybindsButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    KeybindsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeybindsButton.Text = "Show Keybinds"
    KeybindsButton.Font = Enum.Font.SourceSansBold
    KeybindsButton.TextScaled = true

    KeyBindFrame = Instance.new("Frame", HUD)
    KeyBindFrame.Name = "KeyBindFrame"
    KeyBindFrame.AnchorPoint = Vector2.new(0.5, 1)
    KeyBindFrame.Position = UDim2.new(0.5, 0, 1, -120)
    KeyBindFrame.Size = UDim2.new(0, 250, 0, 200)
    KeyBindFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    KeyBindFrame.BackgroundTransparency = 0.2
    KeyBindFrame.BorderColor3 = Color3.fromRGB(200, 200, 200)
    KeyBindFrame.BorderSizePixel = 1
    KeyBindFrame.Visible = false
    KeyBindFrame.ClipsDescendants = true

    local KeybindListLayout = Instance.new("UIListLayout", KeyBindFrame)
    KeybindListLayout.Padding = UDim.new(0, 2)
    KeybindListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    KeybindListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function CreateKeybindLabel(Key, Action)
        local Label = Instance.new("TextLabel", KeyBindFrame)
        Label.Name = Action .. "Label"
        Label.Size = UDim2.new(1, -10, 0, 15)
        Label.Position = UDim2.new(0, 5, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.SourceSans
        Label.Text = Key .. " : " .. Action
        Label.TextColor3 = Color3.fromRGB(230, 230, 230)
        Label.TextScaled = true
        Label.TextXAlignment = Enum.TextXAlignment.Left
        return Label
    end

    CapLockPauseLabel = CreateKeybindLabel(Keybinds.UserPause, "Pause/Unpause")
    CapLockPauseLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    CreateKeybindLabel(Keybinds.AddSavestate, "Add Savestate")
    CreateKeybindLabel(Keybinds.RemoveSavestate, "Remove Savestate")
    CreateKeybindLabel(Keybinds.BackSavestate, "Go To Last Savestate")
    CreateKeybindLabel(Keybinds.GoFrameBack, "Go Frame Back")
    CreateKeybindLabel(Keybinds.GoFrameForward, "Go Frame Forward")
    CreateKeybindLabel(Keybinds.SaveRun, "Save Run")
    CreateKeybindLabel(Keybinds.CollisionToggler, "Toggle Collision")
    CreateKeybindLabel(Keybinds.ViewTAS, "View TAS")
    CreateKeybindLabel(Keybinds.ResetToNormal, "Stop Recording")


    KeybindsButton.MouseButton1Click:Connect(function()
        KeyBindFrame.Visible = not KeyBindFrame.Visible
        if KeyBindFrame.Visible then
            KeybindsButton.Text = "Hide Keybinds"
        else
            KeybindsButton.Text = "Show Keybinds"
        end
    end)
end

local function UserPauseToggle()
    Pause = not Pause
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Anchored = Pause
    end

    if Pause then
        TimePauseHolder = tick()
        if TimeTextLabel then TimeTextLabel.TextColor3 = Color3.fromRGB(255, 255, 0) end
        if CapLockPauseLabel then
             CapLockPauseLabel.Text = Keybinds.UserPause .. " : Paused"
             CapLockPauseLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        end
    else
        if TimePauseHolder then
            TimePaused = TimePaused + (tick() - TimePauseHolder)
            TimePauseHolder = nil
        end
        if TimeTextLabel then TimeTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255) end
        if CapLockPauseLabel then
             CapLockPauseLabel.Text = Keybinds.UserPause .. " : Unpaused"
             CapLockPauseLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
end

local function AddSavestate()
    table.insert(Savestates, PlayerInfo)
    PlayerInfo = {}
    UpdateGUIText()
end

local function RemoveSavestate()
    if #Savestates > 1 then
        table.remove(Savestates)
        if Savestates[#Savestates] and #Savestates[#Savestates] > 0 then
             local lastFrame = Savestates[#Savestates][#Savestates[#Savestates]]
             PlayerInfo = {}
             Pause = true
             TimePauseHolder = tick()
             TimeStart = tick() - lastFrame.Time
             TimePaused = 0
             SetCharacterState(lastFrame)
             UpdateTimeGUI()
        else
             PlayerInfo = {}
             TimeStart = tick()
             TimePaused = 0
        end
        UpdateGUIText()
    end
end

local function BackSavestate()
     if #Savestates > 0 and Savestates[#Savestates] and #Savestates[#Savestates] > 0 then
        local InfoState = Savestates[#Savestates][#Savestates[#Savestates]]
        PlayerInfo = {}
        Pause = true
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Anchored = true
        end
        TimePauseHolder = tick()
        TimeStart = tick() - InfoState.Time
        TimePaused = 0
        SetCharacterState(InfoState)
        if TimeTextLabel then TimeTextLabel.TextColor3 = Color3.fromRGB(255, 255, 0) end
        if CapLockPauseLabel then
             CapLockPauseLabel.Text = Keybinds.UserPause .. " : Paused"
             CapLockPauseLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        end
        UpdateTimeGUI()
    end
end

local function GoFrameForward()
    if Pause then
        UserPauseToggle()
        RunService.Heartbeat:Wait()
        RunService.Heartbeat:Wait()
        UserPauseToggle()
    end
end

local isFrameForwardHeld = false
local function FrameForwardStart()
    isFrameForwardHeld = true
    GoFrameForward()
    while task.wait(0.05) and isFrameForwardHeld do
        GoFrameForward()
    end
end

local isFrameBackHeld = false
local function GoFrameBack()
    if LocalPlayer.Character then
        local TargetFrameInfo = nil
        if #PlayerInfo > 1 then
            TargetFrameInfo = PlayerInfo[#PlayerInfo - 1]
            PlayerInfo[#PlayerInfo] = nil
        elseif #Savestates > 0 and #Savestates[#Savestates] > 1 then
             TargetFrameInfo = Savestates[#Savestates][#Savestates[#Savestates] - 1]
             Savestates[#Savestates][#Savestates[#Savestates]] = nil
        end

        if TargetFrameInfo then
            if not Pause then UserPauseToggle() end
            TimePauseHolder = tick()
            TimeStart = tick() - TargetFrameInfo.Time
            TimePaused = 0
            SetCharacterState(TargetFrameInfo)
            UpdateTimeGUI()
            UpdateGUIText()
        end
    end
end

local function FrameBackStart()
    isFrameBackHeld = true
    GoFrameBack()
    while task.wait(0.05) and isFrameBackHeld do
        GoFrameBack()
    end
end

local function CollisionToggler()
    local Target = Mouse.Target
    if Target and Target:IsA("BasePart") then
        Target.CanCollide = not Target.CanCollide
        Target.Transparency = Target.CanCollide and 0 or 0.7
    end
end

local function PrepareTasData()
    local FullTAS = {}
    for i = 1, #Savestates do
        for j = 1, #Savestates[i] do
            local Frame = Savestates[i][j]
            local MinFrame = {}
            local cfX, cfY, cfZ, cfR00, cfR01, cfR02, cfR10, cfR11, cfR12, cfR20, cfR21, cfR22 = Frame.CFrame:GetComponents()
            local camX, camY, camZ, camR00, camR01, camR02, camR10, camR11, camR12, camR20, camR21, camR22 = Frame.CameraCFrame:GetComponents()

            MinFrame.CCFrame = {cfX, cfY, cfZ, cfR00, cfR01, cfR02, cfR10, cfR11, cfR12, cfR20, cfR21, cfR22}
            MinFrame.CCameraCFrame = {camX, camY, camZ, camR00, camR01, camR02, camR10, camR11, camR12, camR20, camR21, camR22}
            MinFrame.VVelocity = {Frame.Velocity.X, Frame.Velocity.Y, Frame.Velocity.Z}
            MinFrame.AAnimation = Frame.Animation or {Name="Idle", Weight=0}
            MinFrame.time = Frame.Time

            table.insert(FullTAS, MinFrame)
        end
    end
    return FullTAS
end

local function SaveRun()
    local FullTAS = PrepareTasData()
    if #FullTAS > 0 then
        local MapName = "Generic"
        local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
        GameName = GameName:gsub("[^%w%s]", ""):gsub("%s+", "_")

        local FileName = GameName .. "_" .. MapName .. "_TAS.json"
        local FilePath = "TAS_Recorder/" .. FileName

        local EncodedData = HttpService:JSONEncode(FullTAS)

        if writefile then
            if not isfolder("TAS_Recorder") then
                 makefolder("TAS_Recorder")
            end
            writefile(FilePath, EncodedData)
            print("TAS saved to: " .. FilePath)
        else
            print("File saving is not supported in this environment.")
            print("TAS Data (JSON):")
            print(EncodedData)
        end
    else
        print("No TAS data to save.")
    end
end


local ViewingTAS = false
local function ViewTASPlayback(TAS)
    if ViewingTAS or #TAS == 0 then return end
    ViewingTAS = true
    print("Starting TAS Playback...")

    local StartTime = tick()
    local CurrentFrameIndex = 1
    local PlaybackConnection

    if Pause then UserPauseToggle() end

    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        print("Character not found for playback.")
        ViewingTAS = false
        return
    end
    local RootPart = Character.HumanoidRootPart
    local Hum = Character.Humanoid

    local function StopPlayback()
        if PlaybackConnection then
            PlaybackConnection:Disconnect()
            PlaybackConnection = nil
        end
        RootPart.Anchored = false
        ViewingTAS = false
        print("TAS Playback finished.")
        task.wait()
        UserPauseToggle()
        if not Pause then UserPauseToggle() end
    end

    RootPart.Anchored = false

    PlaybackConnection = RunService.Heartbeat:Connect(function()
        local ElapsedTime = tick() - StartTime
        local TargetFrame = nil

        while CurrentFrameIndex <= #TAS and TAS[CurrentFrameIndex].time <= ElapsedTime do
             TargetFrame = TAS[CurrentFrameIndex]
             CurrentFrameIndex = CurrentFrameIndex + 1
        end

        if TargetFrame then
             local cfData = TargetFrame.CCFrame
             local camData = TargetFrame.CCameraCFrame
             RootPart.CFrame = CFrame.new(cfData[1], cfData[2], cfData[3], cfData[4], cfData[5], cfData[6], cfData[7], cfData[8], cfData[9], cfData[10], cfData[11], cfData[12])
             RootPart.Velocity = Vector3.new(TargetFrame.VVelocity[1], TargetFrame.VVelocity[2], TargetFrame.VVelocity[3])
             Workspace.CurrentCamera.CFrame = CFrame.new(camData[1], camData[2], camData[3], camData[4], camData[5], camData[6], camData[7], camData[8], camData[9], camData[10], camData[11], camData[12])

             local AnimInfo = TargetFrame.AAnimation
             if AnimInfo and Hum then
                 local Animator = Hum:FindFirstChildOfClass("Animator")
                 if Animator then
                    local Track = Animator:FindFirstChild(AnimInfo.Name, true)
                    if Track and Track:IsA("AnimationTrack") then
                        if not Track.IsPlaying then Track:Play() end
                        Track:AdjustSpeed(AnimInfo.Weight or 1)
                    end
                 end
             end
        end

        if CurrentFrameIndex > #TAS then
            StopPlayback()
        end
    end)
end

local function DisconnectAll()
    if MainConnectionLoop then MainConnectionLoop:Disconnect() end
    if KeybindsConnect then KeybindsConnect:Disconnect() end
    if InputEndConnect then InputEndConnect:Disconnect() end
    if DiedConnect then DiedConnect:Disconnect() end
    if HUD then HUD:Destroy() end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
       LocalPlayer.Character.HumanoidRootPart.Anchored = false
    end
    print("TAS Recorder Stopped.")
end

local function Initialize()
    Savestates = {}
    PlayerInfo = {}
    TimePaused = 0
    Pause = true
    TimeStart = tick()
    TimePauseHolder = tick()

    local initialCFrame = getCurrentCFrame()
    local initialCamCFrame = getCurrentCameraCFrame()
    local initialVelocity = getCurrentVelocity()

    table.insert(Savestates, {{
        CFrame = initialCFrame,
        CameraCFrame = initialCamCFrame,
        Velocity = initialVelocity,
        Animation = { Name = "Idle", Weight = 0 },
        Time = 0
    }})

    SetUpGui()

    MainConnectionLoop = RunService.Heartbeat:Connect(function(deltaTime)
        if not Pause then
            UpdateTimeGUI()
            table.insert(PlayerInfo, ReturnPlayerInfo())
            UpdateGUIText()
        end
    end)

    KeybindsConnect = UserInputService.InputBegan:Connect(function(Input, Typing)
        if Typing then return end
        local KeyCode = Input.KeyCode

        if KeyCode == Enum.KeyCode[Keybinds.UserPause] then
            UserPauseToggle()
        elseif KeyCode == Enum.KeyCode[Keybinds.AddSavestate] then
            AddSavestate()
        elseif KeyCode == Enum.KeyCode[Keybinds.RemoveSavestate] then
            RemoveSavestate()
        elseif KeyCode == Enum.KeyCode[Keybinds.BackSavestate] then
            BackSavestate()
        elseif KeyCode == Enum.KeyCode[Keybinds.CollisionToggler] then
            CollisionToggler()
        elseif KeyCode == Enum.KeyCode[Keybinds.SaveRun] then
            SaveRun()
        elseif KeyCode == Enum.KeyCode[Keybinds.GoFrameForward] then
            task.spawn(FrameForwardStart)
        elseif KeyCode == Enum.KeyCode[Keybinds.GoFrameBack] then
             task.spawn(FrameBackStart)
        elseif KeyCode == Enum.KeyCode[Keybinds.ResetToNormal] then
            DisconnectAll()
        elseif KeyCode == Enum.KeyCode[Keybinds.ViewTAS] then
            if not ViewingTAS then
                 local CurrentTASData = PrepareTasData()
                 ViewTASPlayback(CurrentTASData)
            end
        end
    end)

    InputEndConnect = UserInputService.InputEnded:Connect(function(Input, Typing)
        if Typing then return end
        local KeyCode = Input.KeyCode
        if KeyCode == Enum.KeyCode[Keybinds.GoFrameBack] then
            isFrameBackHeld = false
        elseif KeyCode == Enum.KeyCode[Keybinds.GoFrameForward] then
            isFrameForwardHeld = false
        end
    end)

    if LocalPlayer.Character then
       local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
       if Hum then
           DiedConnect = Hum.Died:Connect(function()
               task.wait(0.1)
               if not Pause then UserPauseToggle() end
               print("Character died. Attempting to respawn and go to last savestate.")
               LocalPlayer.CharacterAdded:Wait()
               task.wait(1)
               BackSavestate()
               UserPauseToggle()
               if not Pause then UserPauseToggle() end
           end)
       end
    end

     print("TAS Recorder Initialized.")
     if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Anchored = true
     end
     if TimeTextLabel then TimeTextLabel.TextColor3 = Color3.fromRGB(255, 255, 0) end
     if CapLockPauseLabel then
         CapLockPauseLabel.Text = Keybinds.UserPause .. " : Paused"
         CapLockPauseLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
     end
     UserPauseToggle()
     if not Pause then UserPauseToggle() end
end

Initialize()
