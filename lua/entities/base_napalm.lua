AddCSLuaFile()

ENT.Base							 =	"base_anim"
ENT.Spawnable		            	 =  false
ENT.AdminSpawnable		             =  false     

ENT.PrintName		                 =  "Napalm fire"        
ENT.Author			                 =  ""      
ENT.Contact			                 =  ""      

ENT.GBOWNER                          =  nil            
ENT.DAMAGE_MUL						 = 1
ENT.Radius							 = 1400
ENT.Lifetime						 = 44
ENT.Damage							 = 1,4
ENT.Rate							 = 0.5

hook.Remove("OnEntityCreated", "vFireRemoveDefaultFires")

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/mm1/box.mdl")
		self:SetSolid( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetUseType( ONOFF_USE ) 
		self.Bursts = 0
		self.GBOWNER = self:GetVar("GBOWNER")
	end
	
	function ENT:Think()
		local pos = self:GetPos()
		pos.z = pos.z + self.Radius*0.5 -- don't want to create 2 vectors so
		
		debugoverlay.Sphere(pos,self.Radius,self.Rate)
		
		for k,v in pairs(ents.FindInSphere(pos,self.Radius)) do
			if v:IsPlayer() or v:IsNPC() then
				v:Ignite(10,10)
			else
				local phys = self:GetPhysicsObject()
				
				if phys:IsValid() then
					v:Ignite(10,10)
				end
			end
		end
		
		self.Bursts = self.Bursts + 1
		
		if (self.Bursts >= self.Lifetime) then
			self:Remove()
			return
		end
		
		self:NextThink(CurTime() + self.Rate)
		
		return true
	end
end