if not wac then return end

AddCSLuaFile("shared.lua")
ENT.Base = "wac_pod_base"
ENT.Type = "anim"
ENT.model = "models/doi/ty_missile.mdl"
ENT.PrintName = "Gredwitch's Rockets"
ENT.Author = "Gredwitch"
ENT.Category = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Ammo = 1
ENT.FireRate = 220
ENT.Sequential = true
ENT.TkAmmo = 1
ENT.Kind = "gb_rocket_hydra"
sound.Add( {
	name = "fire",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 120,
	pitch = { 100 },
	sound = "HelicopterVehicle/MissileShoot.mp3"--"gunsounds/rocket.wav"
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
	ammovar=GetConVar("gred_sv_default_wac_munitions"):GetInt()
	oldrockets = GetConVar("gred_sv_oldrockets"):GetInt()
end


function ENT:fireRocket(pos, ang)
	if !self:takeAmmo(self.TkAmmo) then return end
	if oldrockets >= 1 then
		local rocket = ents.Create("wac_base_grocket")
		rocket:SetPos(self:LocalToWorld(pos))
		rocket:SetAngles(ang)
		rocket:SetModel ( self.model )
		rocket.model = self.model
		rocket.Owner = self:getAttacker()
		rocket.Damage = math.random (250,400)
		rocket.Radius = 700
		rocket.Speed = 600
		rocket.Drag = Vector(0,1,1)
		rocket.TrailLength = 140
		rocket.Scale = 20
		rocket.SmokeDens = math.random(1,3)
		rocket.Launcher = self.aircraft
		rocket:Spawn()
		rocket:Activate()
		rocket:StartRocket()
		local ph = rocket:GetPhysicsObject()
		if ph:IsValid() then
			ph:SetVelocity(self:GetVelocity())
			ph:AddAngleVelocity(Vector(30,0,0))
		end
		self:EmitSound( "fire" )
	elseif ammovar >= 1 then
		local rocket = ents.Create("wac_hc_rocket")
		rocket:SetPos(self:LocalToWorld(pos))
		rocket:SetAngles(ang)
		rocket.Owner = self.seat:GetDriver() or self.aircraft
		rocket.Damage = 150
		rocket.Radius = 200
		rocket.Speed = 750
		rocket.Drag = Vector(0,1,1)
		rocket.TrailLength = 200
		rocket.Scale = 15
		rocket.SmokeDens = 1
		rocket.Launcher = self.aircraft
		rocket:Spawn()
		rocket:Activate()
		rocket:StartRocket()
		local ph = rocket:GetPhysicsObject()
		if ph:IsValid() then
			ph:SetVelocity(self:GetVelocity())
			ph:AddAngleVelocity(Vector(30,0,0))
		end
		self:EmitSound("firehydra")
	
	else
		local rocket = ents.Create( self.Kind )
		rocket:SetPos(self:LocalToWorld(pos))
		rocket:SetAngles(ang)
		rocket.Owner = self:getAttacker()
		rocket.IsOnPlane = true
		rocket.SmartLaunch = false
		rocket:Spawn()
		for _,e in pairs(self.aircraft.entities) do
			if IsValid(e) then
				constraint.NoCollide(e,rocket,0,0)
			end
		end
		constraint.NoCollide(self.aircraft,rocket,0,0)
		rocket:Activate()
		rocket:Launch()
		local ph = rocket:GetPhysicsObject()
		if ph:IsValid() then
			ph:AddVelocity(self:GetVelocity())
			ph:AddAngleVelocity(Vector(30,0,0))
		end
	end
	-- print(self.aircraft:GetClass())
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

function ENT:drawCrosshair()
	surface.SetDrawColor(255,255,255,150)
	local center = {x=ScrW()/2, y=ScrH()/2}
	surface.DrawLine(center.x+20, center.y, center.x+40, center.y)
	surface.DrawLine(center.x-40, center.y, center.x-20, center.y)
	surface.DrawLine(center.x, center.y+20, center.x, center.y+40)
	surface.DrawLine(center.x, center.y-40, center.x, center.y-20)
	surface.DrawOutlinedRect(center.x-20, center.y-20, 40, 40)
	surface.DrawOutlinedRect(center.x-21, center.y-21, 42, 42)
end