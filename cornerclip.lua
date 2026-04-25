local rs=game:GetService("RunService")
local ps=game:GetService("Players")
local lp=ps.LocalPlayer

local en={}
en.tpdirs={
	Vector3.new(1,0,0),
	Vector3.new(-1,0,0),
	Vector3.new(0,0,1),
	Vector3.new(0,0,-1)
}
en.rotreq=math.pi*.9
en.cornerdist=.7
en.lastlook=Vector3.new(0,0,1)

local function getchar()
	return lp.Character
end

function en.getrotspeed(rp)
	local lv=rp.CFrame.LookVector
	return math.acos(math.clamp(lv:Dot(en.lastlook),-1,1))
end

function en.getcorners(cf,sz)
	local t={}
	for x=-1,1,2 do
		for y=-1,1,2 do
			for z=-1,1,2 do
				local c=Vector3.new(x,y,z)*.5
				t[#t+1]=cf:PointToWorldSpace(c*sz)
			end
		end
	end
	return t
end

function en.getworldup(p)
	local wu=Vector3.new(0,1,0)
	local lu=p.CFrame:VectorToObjectSpace(wu)
	local f={
		Vector3.new(1,0,0),Vector3.new(-1,0,0),
		Vector3.new(0,1,0),Vector3.new(0,-1,0),
		Vector3.new(0,0,1),Vector3.new(0,0,-1)
	}
	table.sort(f,function(a,b)
		return math.acos(math.clamp(a:Dot(lu),-1,1))<math.acos(math.clamp(b:Dot(lu),-1,1))
	end)
	return f[1]
end

function en.crossvec(p,up)
	local g=math.pi*.5
	local v={p.CFrame.RightVector,p.CFrame.UpVector,p.CFrame.LookVector}
	table.sort(v,function(a,b)
		return math.abs(g-math.acos(math.clamp(a:Dot(up),-1,1)))
			<math.abs(g-math.acos(math.clamp(b:Dot(up),-1,1)))
	end)
	return v[1]
end

function en.worldpart(p)
	local up=en.getworldup(p)
	local upw=p.CFrame:VectorToWorldSpace(up)
	local rw=en.crossvec(p,upw)
	local cf=CFrame.fromMatrix(p.Position,rw,upw)

	local rr=p.CFrame:VectorToObjectSpace(cf.RightVector)
	local ur=p.CFrame:VectorToObjectSpace(cf.UpVector)
	local lr=p.CFrame:VectorToObjectSpace(cf.LookVector)

	local sz=Vector3.zero
	sz+= (p.Size*rr).Magnitude*Vector3.new(1,0,0)
	sz+= (p.Size*ur).Magnitude*Vector3.new(0,1,0)
	sz+= (p.Size*lr).Magnitude*Vector3.new(0,0,1)

	sz=Vector3.new(math.abs(sz.X),math.abs(sz.Y),math.abs(sz.Z))
	return cf,sz
end

function en.touchcorner(cf,sz,pos)
	local c=en.getcorners(cf,sz)
	table.sort(c,function(a,b)
		return (a-pos).Magnitude<(b-pos).Magnitude
	end)
	local d=c[1]-pos
	d=Vector3.new(d.X,0,d.Z)
	return d.Magnitude<en.cornerdist
end

function en.inside(cf,sz,pos)
	local rp=cf:PointToObjectSpace(pos)/sz
	return math.abs(rp.X)+math.abs(rp.Y)+math.abs(rp.Z)<1.5
end

function en.closestdir(dir)
	table.sort(en.tpdirs,function(a,b)
		return math.acos(math.clamp(a:Dot(dir),-1,1))
			<math.acos(math.clamp(b:Dot(dir),-1,1))
	end)
	return en.tpdirs[1]
end

function en.tpout(rp,cf,sz,pos)
	local rel=cf:PointToObjectSpace(pos)/sz
	local dir=Vector3.new(rel.X,0,rel.Z).Unit
	local tdir=en.closestdir(dir)
	tdir=Vector3.new(0,1,0):Cross(tdir)

	local dist=(sz*tdir).Magnitude
	local wdir=cf:VectorToWorldSpace(tdir)

	if rel.X<0 then dist*=-1 end
	if rel.Z<0 then dist*=-1 end
	if rel.X>0 and rel.Z<0 and tdir.X<0 then dist*=-1 end
	if rel.X<0 and rel.Z>0 and tdir.X>0 then dist*=-1 end
	if rel.X<0 and rel.Z<0 and tdir.X<0 then dist*=-1 end
	if rel.X>0 and rel.Z>0 and tdir.X>0 then dist*=-1 end

	rp.CFrame+=wdir.Unit*dist
end

function en.check(rp)
	if en.getrotspeed(rp)<en.rotreq then return end
	rp.CanCollide=true
	local corners=en.getcorners(rp.CFrame,rp.Size)
	for _,p in ipairs(rp:GetTouchingParts()) do
		if not rp:CanCollideWith(p) then continue end
		if p.Shape==Enum.PartType.Ball or p.Shape==Enum.PartType.Cylinder then continue end
		local cf,sz=en.worldpart(p)
		if not en.touchcorner(cf,sz,rp.Position) then continue end
		for _,pos in ipairs(corners) do
			if en.inside(cf,sz,pos) then
				en.tpout(rp,cf,sz,pos)
				return
			end
		end
	end
end

rs.Heartbeat:Connect(function()
	local c=getchar()
	if not c or not c.Parent then return end
	local rp=c:FindFirstChild("HumanoidRootPart")
	if not rp then return end
	en.check(rp)
	en.lastlook=rp.CFrame.LookVector
end)

local c=getchar()
if c then
	local rp=c:FindFirstChild("HumanoidRootPart")
	if rp then rp.Touched:Connect(function() end) end
end

lp.CharacterAdded:Connect(function(c)
	local rp=c:WaitForChild("HumanoidRootPart")
	rp.Touched:Connect(function() end)
	en.lastlook=Vector3.new(0,0,1)
end)
print("executed")
