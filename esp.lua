--// Script

loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Wall-Hack/main/Resources/Scripts/Main.lua"))()

--// Variables

local Environment = getgenv().WallHack

--// Script / Global Settings

Environment.Settings.Enabled = true
Environment.Settings.TeamCheck = false
Environment.Settings.AliveCheck = true

--// Visuals Settings

Environment.Visuals.ESPSettings.Enabled = true
Environment.Visuals.TracersSettings.Enabled = true
Environment.Visuals.BoxSettings.Enabled = true
Environment.Visuals.HeadDotSettings.Enabled = true

--// Crosshair

Environment.Crosshair.CrosshairSettings.Enabled = true
