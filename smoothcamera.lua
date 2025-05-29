--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local a=game:GetService("Players")local b=game:GetService("RunService")local c=game:GetService("StarterGui")local d=a.LocalPlayer local e=workspace.CurrentCamera
local f=15.0 local g=10.0 local h=70.0 local i=e.CFrame local j=h local k=0.0 local l=5.0 local m

local function n(o)k=math.clamp(k+o,0,2)end

local function p(q)m=q:WaitForChild("Humanoid")
m.HealthChanged:Connect(function(r)if r<m.MaxHealth then n(0.6)end end)
m.StateChanged:Connect(function(_,s)if s==Enum.HumanoidStateType.Landed then n(0.8)end end)
end

local function t(u)p(u)end

d.CharacterAdded:Connect(t)if d.Character then p(d.Character)end

b.RenderStepped:Connect(function(v)local w=e.CFrame
i=i:Lerp(w,f*v)
if k>0 then
local x=Vector3.new(math.random(-100,100)/100*k,math.random(-100,100)/100*k,math.random(-100,100)/100*k)
i=i*CFrame.new(x)
k=math.max(k-l*v,0)
end
local y=tick()
local z=Vector3.new(math.sin(y*2)*0.05,math.abs(math.cos(y*2))*0.03,0)
i=i*CFrame.new(z)
e.FieldOfView=e.FieldOfView+(j-e.FieldOfView)*g*v
e.CFrame=i
end)

workspace.ChildAdded:Connect(function(_)
if _:IsA("Explosion")then
if (_.Position-e.CFrame.Position).Magnitude<40 then
n(1.2)
end end
end)

local aa={"✅ Smo","oth Cam","era Loa","ded | Cr","edits: ","project","_remorse"}
print(table.concat(aa))
local ab={"proj","ect_re","morse"}local ac={"Smoo","th Cam","era Loa","ded ✅"}
c:SetCore("SendNotification",{Title=table.concat(ab);Text=table.concat(ac);Duration=5})
