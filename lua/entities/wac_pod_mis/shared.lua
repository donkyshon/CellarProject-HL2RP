if not wac then return end

ENT.Base				= "wac_pod_base"
ENT.Type				= "anim"
ENT.PrintName			= "Grediwtch's Guided Missiles"
ENT.Author				= "Gredwitch"
ENT.Category			= ""
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.Ammo				= 4
ENT.FireRate			= 60
ENT.Sequential			= true
ENT.MaxRange			= 35400
ENT.model				= "models/doi/ty_missile.mdl"
ENT.TkAmmo 				= 1
ENT.Kind				= "gb_rocket_hydra"
ENT.FaF					= false
sound.Add( {
	name = "fire",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = "gunsounds/fh2_rocket_3p.wav"
} )
sound.Add( {
	name = "firehydra",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = "helicoptervehicle/missileshoot.mp3"
} )

function ENT:Initialize()
	self:base("wac_pod_base").Initialize(self)
	self.baseThink = self:base("wac_pod_base").Think
	if !self.FaF then self.MaxRange = 10000 end
	ammovar=GetConVar("gred_sv_default_wac_munitions"):GetInt()
end


function ENT:SetupDataTables()
	self:base("wac_pod_base").SetupDataTables(self)
	self:NetworkVar("Entity", 0, "Target")
	self:NetworkVar("Vector", 0, "TargetOffset")
end

function ENT:canFire()
	if self.FaF then return self.FaF
	else return IsValid(self:GetTarget()) end
end


function ENT:fireRocket(pos, ang)
	if !self:takeAmmo(self.TkAmmo) then return end
	if ammovar >= 1 then
		local rocket = ents.Create("wac_hc_rocket")
		rocket:SetPos(self:LocalToWorld(pos))
		rocket:SetAngles(ang)
		rocket.Owner = self:getAttacker()
		rocket.Damage = 150
		rocket.Radius = 200
		rocket.Speed = 500
		rocket.Drag = Vector(0,1,1)
		rocket.TrailLength = 200
		rocket.Scale = 15
		rocket.SmokeDens = 1
		rocket.Launcher = self.aircraft
		rocket.target = self:GetTarget()
		rocket.targetOffset = self:GetTargetOffset()
		rocket.calcTarget = function(r)
			--[[
			if !IsValid(r.target) then
				return r:GetPos() + r:GetForward()*100
			else
				return r.target:LocalToWorld(r.targetOffset)
			end]]
			if !self.FaF then
				if !IsValid(r.target) then
					return r:GetPos() + r:GetForward()*100
				else
					return r.target:LocalToWorld(r.targetOffset)
				end
			else
				r.hellfire = true
				return r.target:LocalToWorld(r.targetOffset)
			end
		end
		rocket:Spawn()
		rocket:Activate()
		rocket:StartRocket()
		local ph = rocket:GetPhysicsObject()
		if ph:IsValid() then
			ph:SetVelocity(self:GetVelocity())
			ph:AddAngleVelocity(Vector(30,0,0))
		end
		-- self:StopSound("firehydra")
		self:EmitSound("firehydra")
	else
		local rocket = ents.Create("wac_base_grocket")
		rocket:SetModel ( self.model )
		rocket:SetPos(self:LocalToWorld(pos))
		rocket:SetAngles(ang)
		rocket.Owner = self:getAttacker()
		rocket.Damage = 1000
		rocket.Radius = 400
		rocket.Speed = 70
		rocket.Drag = Vector(0,1,1)
		rocket.TrailLength = 200
		rocket.Scale = 15
		rocket.SmokeDens = 1
		rocket.Launcher = self.aircraft
		rocket.target = self:GetTarget()
		rocket.targetOffset = self:GetTargetOffset()
		rocket.calcTarget = function(r)
			if !self.FaF then
				if !IsValid(r.target) then
					return r:GetPos() + r:GetForward()*100
				else
					return r.target:LocalToWorld(r.targetOffset)
				end
			else
				r.hellfire = true
				return r.target:LocalToWorld(r.targetOffset)
			end
		end
		rocket:Spawn()
		rocket:Activate()
		rocket:StartRocket()
		local ph = rocket:GetPhysicsObject()
		if ph:IsValid() then
			ph:SetVelocity(self:GetVelocity())
			ph:AddAngleVelocity(Vector(30,0,0))
		end
		-- self:StopSound("fire")
		self:EmitSound("fire")
	end
	for _,e in pairs(self.aircraft.entities) do
		if IsValid(e) then
			constraint.NoCollide(e,b,0,0)
		end
	end
	constraint.NoCollide(self.aircraft,b,0,0)
end


function ENT:fire()
	if self.Sequential then
		self.currentPod = self.currentPod or 1
		self:fireRocket(self.Pods[self.currentPod], self:GetAngles())
		self.currentPod = (self.currentPod == #self.Pods and 1 or self.currentPod + 1)
	else
		for _, pos in pairs(self.Pods) do
			self:fireRocket(pos, self:GetAngles())
		end
	end
end


if SERVER then

	function ENT:Think()
		local ang = self.aircraft:getCameraAngles()
		if ang then
			local pos = self.aircraft:LocalToWorld(self.aircraft.Camera.pos)
			local dir = ang:Forward()
			local tr = util.QuickTrace(pos+dir*20, dir*self.MaxRange, {self,self.aircraft})
			if self.FaF then
				if tr.HitSky then return
				elseif tr.Hit then
					self:SetTarget(tr.Entity)
					self:SetTargetOffset(tr.Entity:WorldToLocal(tr.HitPos))
				end
			elseif !self.FaF then
				if tr.Hit and !tr.HitWorld then
					self:SetTarget(tr.Entity)
					self:SetTargetOffset(tr.Entity:WorldToLocal(tr.HitPos))
				else
					self:SetTarget(nil)
				end
			end
		end
		return self:baseThink()
	end

end


function ENT:drawCrosshair()
	surface.SetDrawColor(255,255,255,150)
	local center = {x=ScrW()/2, y=ScrH()/2}
	if IsValid(self:GetTarget()) then
		local pos = self:GetTarget():LocalToWorld(self:GetTargetOffset()):ToScreen()
		pos = {
			x = math.Clamp(pos.x-center.x+math.Rand(-1,1), -20, 20)+center.x,
			y = math.Clamp(pos.y-center.y+math.Rand(-1,1), -20, 20)+center.y
		}
		surface.DrawLine(center.x-20, pos.y, center.x+20, pos.y)
		surface.DrawLine(pos.x, center.y-20, pos.x, center.y+20)
	else
		surface.DrawLine(center.x+20, center.y, center.x+40, center.y)
		surface.DrawLine(center.x-40, center.y, center.x-20, center.y)
		surface.DrawLine(center.x, center.y+20, center.x, center.y+40)
		surface.DrawLine(center.x, center.y-40, center.x, center.y-20)
	end
	surface.DrawOutlinedRect(center.x-20, center.y-20, 40, 40)
	surface.DrawOutlinedRect(center.x-21, center.y-21, 42, 42)
	if self.FaF then
		draw.Text({
			text = (
				self:GetNextShot() <= CurTime() and self:GetAmmo() > 0
				and (IsValid(self:GetTarget()) and "LOCK" or "READY")
				or "MSL NOT READY"
					
			),
			font = "HudHintTextLarge",
			pos = {center.x, center.y+45},
			color = Color(255, 255, 255, 150),
			xalign = TEXT_ALIGN_CENTER
		})
	else
		draw.Text({
			text = (
				self:GetNextShot() <= CurTime() and self:GetAmmo() > 0
				and (IsValid(self:GetTarget()) and "LOCK" or "NO LOCK")
				or "MSL NOT READY"
					
			),
			font = "HudHintTextLarge",
			pos = {center.x, center.y+45},
			color = Color(255, 255, 255, 150),
			xalign = TEXT_ALIGN_CENTER
		})
	end
end