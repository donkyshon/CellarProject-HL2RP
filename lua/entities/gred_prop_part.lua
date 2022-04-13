AddCSLuaFile()
ENT.Type 							= "anim"
ENT.Spawnable		            	=	false
ENT.AdminSpawnable		            =	false

ENT.PrintName		                =	"[OTHERS]Plane part"
ENT.Author			                =	"Gredwitch"
ENT.Contact			                =	"contact.gredwitch@gmail.com"
ENT.Category                        =	"Gredwitch's Stuff"
ENT.Model                         	=	""
ENT.BaseEntity						=	nil
ENT.Mass							=	250

ENT.MaxHealth 						=	300
ENT.CurHealth 						=	ENT.Health
ENT.ForceToDestroy					=	1000

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
		-- self:SetMoveType(MOVETYPE_VPHYSICS)
		-- self.Entity:SetMoveType(MOVETYPE_NONE)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.phys = self:GetPhysicsObject()
		if IsValid(self.phys) then
			if self.Mass then self.phys:SetMass(self.Mass) end
			self.phys:Wake()
		end
	end
	
	function ENT:PhysicsCollide(data,collider)
		-- if data.Speed > 600 then
		-- print(data.Speed)
		-- if collider:GetEntity().ClassName != "gred_prop_part" then
			if data.Speed > self.ForceToDestroy and self.LOADED then -- and (collider:GetMass() > 50) then
				self.CurHealth = 0
				local dmg = DamageInfo()
				dmg:SetDamage(data.Speed/2)
				self:TakeDamageInfo(dmg)
			end
		-- end
	end
	function ENT:Think()
		if self.LOADED then
			-- if not self.DONE then
				-- PrintTable(constraint.GetTable(self))
			-- end
			-- if self.PartName == "wing_l" then
				-- print(self.PartName, self.CurHealth, self.MaxHealth)
			-- end
			-- self:SetMoveType(MOVETYPE_VPHYSICS)
			-- self.DONE = true
		end
	end
end
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end

function ENT:OnTakeDamage(dmg)
	self.CurHealth = self.CurHealth - dmg:GetDamage()
end