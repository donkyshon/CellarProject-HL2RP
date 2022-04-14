local patternCurve = {
    {0,0},
    {0,0},
    {0,0},
    {25,0},
}

do
	function PointOnCubicBezier(cp, t )
	    local   ax, bx, cx
	    local   tSquared, tCubed

	    cx = 3.0 * (cp[2][1] - cp[1][1])
	    bx = 3.0 * (cp[1][1] - cp[2][1]) - cx
	    ax = cp[4][1] - cp[1][1] - cx - bx
	 
	    tSquared = t * t
	    tCubed = tSquared * t

	    return (ax * tCubed) + (bx * tSquared) + (cx * t) + cp[1][1]
	end
end

matproxy.Add({
	name = "ShieldX", 
	init = function(self, mat, values)
		self.ResultTo = values.resultvar
		self.value = 0
	end,
	bind = function(self, mat, ent)
		if ent.pulseShield then
			self.value = 0
			ent.pulseShield = false
		end
		
		if self.value != 1 then
			self.value = Lerp(FrameTime() * 2.75, self.value, 1)

			mat:SetInt(self.ResultTo, PointOnCubicBezier(patternCurve, self.value))
		end
	end 
})

local function LoadShield()
	if IsValid(shield_5254) then
		shield_5254:Remove()
		shield_5254 = nil
	end

	shield_5254 = ClientsideModel(Model("models/cellar/shieldfield.mdl"), RENDERGROUP_BOTH)
	shield_5254:SetNoDraw(true)

	hook.Add("PostPlayerDraw" , "shieldX", function(ply)
		if ply:GetNWBool("shieldx") then
			local pos = ply:GetBonePosition(0)
					

			shield_5254:SetPos(pos)
			shield_5254:SetRenderOrigin(pos)
			shield_5254:SetupBones()
			shield_5254:DrawModel()
			shield_5254:SetRenderOrigin()
		end
	end)

	net.Receive("ShieldX", function()
		shield_5254.pulseShield = true
	end)
end

if !file.Exists("shieldx.dat", "DATA") then
	http.Fetch("http://raw.githubusercontent.com/SchwarzKruppzo/schwarzkruppzo.github.io/master/shieldx.dat", function(b)
		if b then
			file.Write("shieldx.dat", b)
			game.MountGMA("data/shieldx.dat")
			LoadShield()
		end
	end)
else
	game.MountGMA("data/shieldx.dat")
	LoadShield()
end
local patternCurve = {
    {0,0},
    {0,0},
    {0,0},
    {25,0},
}

do
	function PointOnCubicBezier(cp, t )
	    local   ax, bx, cx
	    local   tSquared, tCubed

	    cx = 3.0 * (cp[2][1] - cp[1][1])
	    bx = 3.0 * (cp[1][1] - cp[2][1]) - cx
	    ax = cp[4][1] - cp[1][1] - cx - bx
	 
	    tSquared = t * t
	    tCubed = tSquared * t

	    return (ax * tCubed) + (bx * tSquared) + (cx * t) + cp[1][1]
	end
end

matproxy.Add({
	name = "ShieldX", 
	init = function(self, mat, values)
		self.ResultTo = values.resultvar
		self.value = 0
	end,
	bind = function(self, mat, ent)
		if ent.pulseShield then
			self.value = 0
			ent.pulseShield = false
		end
		
		if self.value != 1 then
			self.value = Lerp(FrameTime() * 2.75, self.value, 1)

			mat:SetInt(self.ResultTo, PointOnCubicBezier(patternCurve, self.value))
		end
	end 
})

local function LoadShield()
	if IsValid(shield_5254) then
		shield_5254:Remove()
		shield_5254 = nil
	end

	shield_5254 = ClientsideModel(Model("models/cellar/shieldfield.mdl"), RENDERGROUP_BOTH)
	shield_5254:SetNoDraw(true)

	hook.Add("PostPlayerDraw" , "shieldX", function(ply)
		if ply:GetNWBool("shieldx") then
			local pos = ply:GetBonePosition(0)
					

			shield_5254:SetPos(pos)
			shield_5254:SetRenderOrigin(pos)
			shield_5254:SetupBones()
			shield_5254:DrawModel()
			shield_5254:SetRenderOrigin()
		end
	end)

	net.Receive("ShieldX", function()
		shield_5254.pulseShield = true
	end)
end

if !file.Exists("shieldx.dat", "DATA") then
	http.Fetch("http://raw.githubusercontent.com/SchwarzKruppzo/schwarzkruppzo.github.io/master/shieldx.dat", function(b)
		if b then
			file.Write("shieldx.dat", b)
			game.MountGMA("data/shieldx.dat")
			LoadShield()
		end
	end)
else
	game.MountGMA("data/shieldx.dat")
	LoadShield()
end