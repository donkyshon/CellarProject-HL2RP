AddCSLuaFile()
ENT.Type 							= "anim"
ENT.Spawnable		            	=	false
ENT.AdminSpawnable		            =	false

ENT.PrintName		                =	"[OTHERS]Shell casing"
ENT.Author			                =	"Gredwitch"
ENT.Contact			                =	"contact.gredwitch@gmail.com"
ENT.Category                        =	"Gredwitch's Stuff"
ENT.Model                         	=	"models/gredwitch/bombs/75mm_shell.mdl"
ENT.HasBodyGroups					=	true
ENT.BodyGroupA						=	0
ENT.BodyGroupB						=	0
ENT.Mass							=	70

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
		
		self:SetAngles(self:GetAngles()+Angle(math.random(5,-5),math.random(5,-5),math.random(5,-5)))
		self:SetBodygroup(self.BodyGroupA,self.BodyGroupB)
		
		local phys = self.Entity:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(self.Mass)
			phys:AddVelocity(self:GetForward()*math.random(80,100))
			phys:AddVelocity(self:GetUp()*math.random(150,200))
			phys:Wake()
		end
		
		local TimeToRemove = gred.CVars.gred_sv_shell_remove_time and gred.CVars.gred_sv_shell_remove_time:GetInt() or 20
		
		if TimeToRemove > 0 then
			timer.Simple(TimeToRemove,function() if IsValid(self) then self:Remove() end end)
		end
	end
	
	function ENT:PhysicsCollide(data,physobj)
		if data.Speed > 200 then
			self:EmitSound("gred_emp/common/cannon_shell_drop_0"..math.random(1,7)..".wav",80,100,1,CHAN_AUTO)
		end
	end
end

