if not wac then return end

ENT.Base 			= "wac_pod_base"
ENT.Type 			= "anim"
ENT.PrintName 		= ""
ENT.Author 			= "Gredwitch"
ENT.Category 		= "Gredwitch's Stuff"
ENT.Contact 		= ""
ENT.Purpose 		= ""
ENT.Instructions 	= "end my life"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false
ENT.Name 			= "Gredwitch's MG"
ENT.Ammo 			= 425
ENT.FireRate 		= 9999
ENT.Force 			= 200
ENT.ShootAng 		= Angle(0,0,0)
ENT.TkAmmo 			= 1
ENT.TracerColor 	= "Red"
ENT.BulletType 		= "wac_base_12mm"
ENT.Brrt 			= 0
ENT.Sounds = {
	shoot = "",
	stop = "",
}
function ENT:SetupDataTables()
	self:base("wac_pod_base").SetupDataTables(self)
	self:NetworkVar( "Vector", 0, "ShootPos" );
	self:NetworkVar( "Angle", 1, "ShootAng" );
end
local tracers = 0 
local num = 0
local SERVER = SERVER
local ammovar
function ENT:Initialize()
	self:base("wac_pod_base").Initialize(self)
	
	self.TracerConvar = GetConVar("gred_sv_tracers"):GetInt()
	ammovar = GetConVar("gred_sv_default_wac_munitions"):GetInt()
	self.TracerConvar = GetConVar("gred_sv_tracers"):GetInt()
	if self.BulletType == "wac_base_7mm" then
		num = 0.5
	elseif self.BulletType == "wac_base_12mm" then
		num = 1
	elseif self.BulletType == "wac_base_20mm" then
		num = 1.4
	elseif self.BulletType == "wac_base_30mm" then
		num = 3
	end
	self.TracerColor = string.lower(self.TracerColor)
	if SERVER then
		self.FILTER = {self,self.aircraft}
		for k,v in pairs(self.aircraft.entities) do
			table.insert(self.FILTER,v)
		end
	end
end

function ENT:fireBullet(pos)
	if !self:takeAmmo(self.TkAmmo) or !SERVER then return end
	local ang = self.aircraft:GetAngles()
	if ammovar >= 1 then
		local bullet = {}
		bullet.Num = 1
		bullet.Src = self.aircraft:LocalToWorld(pos)
		bullet.Dir = self:GetForward()
		bullet.Spread = Vector(0.015,0.015,0)
		bullet.Tracer = 0
		bullet.Force = 5
		bullet.Damage = 20
		bullet.Attacker = self:getAttacker()
		self.aircraft:FireBullets(bullet)
	else
		local pos2=self.aircraft:LocalToWorld(pos+Vector(self.aircraft:GetVelocity():Length()*0.6,0,0))
		ang:Add(Angle(axis,axis,0) + Angle(math.Rand(-num,num), math.Rand(-num,num), math.Rand(-num,num)))
		gred.CreateBullet(self:getAttacker(),pos2,ang,self.BulletType,self.FILTER,nil,false,self:UpdateTracers())
	end
	local effectdata = EffectData()
	effectdata:SetOrigin(self:LocalToWorld(pos))
	effectdata:SetAngles(ang)
	effectdata:SetEntity(self)
	util.Effect("gred_particle_aircraft_muzzle",effectdata)
end

function ENT:UpdateTracers()
	tracers = tracers + 1
	if tracers >= self.TracerConvar then
		tracers = 0
		return self.TracerColor
	else
		return false
	end
end

function ENT:fire()
	if !self.shooting then
		self.shooting = true
		self.sounds.shoot:SetSoundLevel(100)
		self.sounds.stop:SetSoundLevel(100)
		self.sounds.stop:Stop()
		self.sounds.shoot:Play()
	end
	if self.Sequential then
		self.currentPod = self.currentPod or 1
		self:fireBullet(self.Pods[self.currentPod], self:GetAngles())
		self.currentPod = (self.currentPod == #self.Pods and 1 or self.currentPod + 1)
	else
	    for _, v in pairs(self.Pods) do
	    	self:fireBullet(v)
	    end
    	self:SetNextShot(self:GetLastShot() + 60/self.FireRate)
    end
end

function ENT:stop()
	if self.shooting then
		self.sounds.shoot:Stop()
		self.sounds.stop:Play()
		self.shooting = false
		if self.Brrt == 1 then
			timer.Create("gred_brrt",2.5, 1,function() self.aircraft:EmitSound("wac/a10/brrt_0"..math.random(1,4)..".wav",0,100, 1, CHAN_AUTO) end)
			self:CallOnRemove(("StopBrrt"), function() timer.Remove("gred_brrt") end)
		end
	end
end
function ENT:drawCrosshair()
	surface.SetDrawColor(255,255,255,150)
	local center = {x=ScrW()/2, y=ScrH()/2}
	surface.DrawLine(center.x+10, center.y, center.x+30, center.y)
	surface.DrawLine(center.x-30, center.y, center.x-10, center.y)
	surface.DrawLine(center.x, center.y+10, center.x, center.y+30)
	surface.DrawLine(center.x, center.y-30, center.x, center.y-10)
	surface.DrawOutlinedRect(center.x-10, center.y-10, 20, 20)
	surface.DrawOutlinedRect(center.x-11, center.y-11, 22, 22)
end