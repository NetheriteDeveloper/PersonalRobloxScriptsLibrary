-- Decompiled with the Synapse X Luau decompiler.

local l__LocalPlayer__1 = game:GetService("Players").LocalPlayer;
local v2 = l__LocalPlayer__1.Character or l__LocalPlayer__1.CharacterAdded:Wait();
local l__HumanoidRootPart__3 = v2:WaitForChild("HumanoidRootPart");
local v4 = Instance.new("BodyVelocity");
v4.Parent = l__HumanoidRootPart__3;
local u1 = nil;
local l__Humanoid__2 = v2:WaitForChild("Humanoid");
local u3 = false;
canjump = 10;
local function u4()
    u1 = l__Humanoid__2:GetState();
    if u1 ~= Enum.HumanoidStateType.Freefall then
        v4.MaxForce = Vector3.new(0, 0, 0);
        v4.Velocity = l__HumanoidRootPart__3.Velocity;
        u3 = false;
        return;
    end;
    v4.MaxForce = Vector3.new(5000, 0, 5000);
    if not u3 then
        v4.Velocity = v4.Velocity * 1.25;
        u3 = true;
    end;
    v4.Velocity = v4.Velocity + l__Humanoid__2.MoveDirection * 1;
end;
game:GetService("RunService").RenderStepped:Connect(function()
    u4();
    canjump = math.clamp(canjump - 1, 0, 10);
end);
l__Humanoid__2.UseJumpPower = true;
game:GetService("UserInputService").JumpRequest:Connect(function()
    if canjump == 0 then
        l__Humanoid__2.JumpPower = 40;
    else
        l__Humanoid__2.JumpPower = 0;
    end;
    canjump = 10;
end);
l__Humanoid__2.Died:Connect(function()
    v4:Destroy();
end);



--------------------- Mobile fixer ---------------------------

game:GetService("RunService").RenderStepped:Connect(function()
    if canjump == 10 then
        l__Humanoid__2.JumpPower = 40;
    end
end)
