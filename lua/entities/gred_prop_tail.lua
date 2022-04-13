AddCSLuaFile()
ENT.Type 							= "anim"
ENT.Spawnable		            	=	false
ENT.AdminSpawnable		            =	false

ENT.PrintName		                =	"[EMP]Base shield"
ENT.Author			                =	"Gredwitch"
ENT.Contact			                =	"contact.gredwitch@gmail.com"
ENT.Category                        =	"Gredwitch's Stuff"
ENT.Model                         	=	""
ENT.NextUse							=	0
ENT.Mass							=	100

ENT.TailPos							= Vector(-173.242,0,15.6829)
ENT.RotorPos						= Vector(-362.91,33.177,106.752)
ENT.TailHP							= 1000
ENT.RotorHP							= 300
ENT.Editable						= true

function ENT:SetupDataTables()
	self:NetworkVar("Float",0, "TailHP", { KeyName = "TailHP", Edit = { type = "Float", order = 0,min = 0, max = self.TailHP, category = "Health"} } )
	self:NetworkVar("Float",1, "RotorHP", { KeyName = "RotorHP", Edit = { type = "Float", order = 0,min = 0, max = self.RotorHP, category = "Health"} } )
	
	self:SetTailHP(self.TailHP)
	self:SetRotorHP(self.RotorHP)
end

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )
		if (  !tr.Hit ) then return end
		local SpawnPos = tr.HitPos + tr.HitNormal
		local ent = ents.Create(ClassName)
		ent:SetPos(SpawnPos)
		ent:Spawn()
		ent:Activate()
		return ent
	end

	function ENT:Initialize()
		self:SetModel(self.Model)
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.phys = self:GetPhysicsObject()
		if IsValid(self.phys) then
			if self.Mass then self.phys:SetMass(self.Mass) end
			self.phys:Wake()
		end
	end
	
	function ENT:Think()
		local ct = CurTime()
		if self.RotorDestroyed then
			self.TailEffectTime = nil
			self:SetRotorHP(0)
		end
		if self.TailDestroyed then
			self.TailEffectTime = nil
			self.TailSmokeEffectTime = self.TailSmokeEffectTime or 0
			if self.TailSmokeEffectTime < ct then
				local effectdata = EffectData()
				effectdata:SetOrigin(self:LocalToWorld(self.TailPos))
				util.Effect("lfs_blacksmoke",effectdata)
				self.TailSmokeEffectTime = ct + 0.1
			end
			self:SetTailHP(0)
		end
		if self.EffectTime then
			if self.EffectTime < ct then
				local effect = EffectData()
				effect:SetOrigin(self:LocalToWorld(self.TailPos))
				effect:SetNormal(self:GetForward())
				util.Effect("ManhackSparks",effect)
				self.EffectTime = ct + math.random(0.1,0.3)
			end
		end
		if self.TailEffectTime then
			if self.TailEffectTime < ct then
				local effect = EffectData()
				effect:SetOrigin(self:LocalToWorld(self.RotorPos))
				effect:SetNormal(-self:GetRight())
				util.Effect("ManhackSparks",effect)
				self.TailEffectTime = ct + math.random(0.1,0.3)
			end
		end
		if self:GetRotorHP() > 80 then self.TailEffectTime = nil end
		
		self:NextThink(ct + 0.1)
	end
	
	function ENT:PhysicsCollide(data,col)
		if data.Speed > 600 and (!data.HitEntity:IsPlayer() and !data.HitEntity:IsNPC()) then
			local dmg = DamageInfo()
			dmg:SetDamage(data.Speed * 0.5)
			self:TakeDamageInfo(dmg)
		end
	end

	function ENT:OnTakeDamage(dmg)
		local dist = self.RotorPos:Distance(self:WorldToLocal(dmg:GetDamagePosition()))
		local damage = dmg:GetDamage()
		if dist < 60 then
			local Owner = self:GetOwner()
			local OwnerValid = IsValid(Owner)
			local rotorHP = self:GetRotorHP()
			self:SetRotorHP(rotorHP - damage)
			rotorHP = rotorHP - damage
			
			if rotorHP < 100 then
				if OwnerValid then
					Owner.TailRotorDownLevel = 1
					Owner.MaxYaw = 0
					self.TailEffectTime = self.TailEffectTime or CurTime()
					if !self.SoundPlayed then
						if Owner.CRASHSND then Owner:StopSound(Owner.CRASHSND) end
						Owner.CRASHSND = "HELICOPTER_CRASHING_"..math.random(1,10)
						Owner:EmitSound(Owner.CRASHSND)
						self.SoundPlayed = true
					end
				end
				if rotorHP <= 0 then
					if OwnerValid then
						if Owner.CRASHSND then Owner:StopSound(Owner.CRASHSND) end
						Owner.MaxYaw = 0
						Owner.TailRotorDownLevel = 2
						Owner.MaxTurnYawHeli = 0
					end
					self.TailEffectTime = nil
					self.RotorDestroyed = true
					if !self.InfoSent then
						self.InfoSent = true
						net.Start("gred_apache_rotor_destroyed")
							net.WriteEntity(self)
						net.Broadcast()
					end
				else
					self.TailRotorDestroyed = false
					self.SoundPlayed = false
				end
			else
				self.TailEffectTime = nil
			end
		else
			if not self.TailDestroyed then
				local Owner = self:GetOwner()
				local OwnerValid = IsValid(Owner)
				local tailHP = self:GetTailHP()
				self:SetTailHP(tailHP - damage)
				tailHP = tailHP - damage
				if tailHP <= 0 then
					if OwnerValid then
						if IsValid(Owner.wheel_C) then
							Owner.wheel_C:Remove()
						end
						if IsValid(Owner.wheel_C_master) then
							Owner.wheel_C_master:Remove()
						end
						if Owner:GetEngineActive() then
							if Owner.CRASHSND then Owner:StopSound(Owner.CRASHSND) end
							Owner.CRASHSND = "HELICOPTER_CRASHING_"..math.random(1,10)
							Owner:EmitSound(Owner.CRASHSND)
						end
						Owner.TailRotorDownLevel = 2
						Owner.MaxTurnYawHeli = 0
						Owner.TailDestroyed = true
						Owner.Tail = nil
					end
					
					self.EffectTime = CurTime()
					timer.Simple(3,function()
						if IsValid(self) then self.EffectTime = nil end
					end)
					
					net.Start("gred_apache_tail_destroyed")
						net.WriteEntity(Owner)
						net.WriteEntity(self)
					net.Broadcast()
					
					self:EmitSound("LFS_PART_DESTROYED_0"..math.random(1,3))
					self.TailDestroyed = true
					self:SetOwner(nil)
					if IsValid(self.phys) then
						self.phys:SetMass(2000)
						self.phys:EnableGravity(true)
						self.phys:EnableDrag(true)
					end
					constraint.RemoveAll(self)
				end
			end
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end