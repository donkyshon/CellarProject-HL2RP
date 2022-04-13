AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )


ENT.Spawnable		            	 =  false
ENT.AdminSpawnable		             =  false     

ENT.PrintName		                 =  ""        
ENT.Author			                 =  ""      
ENT.Contact			                 =  ""      

ENT.GBOWNER                          =  nil            
ENT.MAX_RANGE                        = 0
ENT.DELAY                            = 0
ENT.SOUND                            = ""
ENT.Burst                            = 0 


sound.Add( {
	name = "anti_grav",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 130,
	pitch = {100, 100},
	sound = "sw/bombs/antigravity.mp3"
} )
function ENT:Initialize()
     if (SERVER) then
		 self.FILTER                           = {}
         self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	     self:SetSolid( SOLID_NONE )
	     self:SetMoveType( MOVETYPE_NONE )
	     self:SetUseType( ONOFF_USE ) 
		 self.Bursts = 0
		 self.CURRENTRANGE = 0
		 self.GBOWNER = self:GetVar("GBOWNER")
		 self.SOUND = self:GetVar("SOUND")
		 self.DEFAULT_PHYSFORCE  = self:GetVar("DEFAULT_PHYSFORCE")
		 self.DEFAULT_PHYSFORCE_PLYAIR  = self:GetVar("DEFAULT_PHYSFORCE_PLYAIR")
	     self.DEFAULT_PHYSFORCE_PLYGROUND = self:GetVar("DEFAULT_PHYSFORCE_PLYGROUND")
		 self:EmitSound("anti_grav")
     end
end

function ENT:Think()		
     if (SERVER) then
     if !self:IsValid() then return end
	 local pos = self:GetPos()
	 for k, v in pairs(ents.FindInSphere(pos,self.MAX_RANGE)) do
		 if (v:IsValid() or v:IsNPC() or v:IsPlayer()) and (v.forcefielded==false or v.forcefielded==nil) then
			 local i = 0
			 while i < v:GetPhysicsObjectCount() do
				phys = v:GetPhysicsObjectNum(i)
				local gravity_equation = (self:GetPos().z+500)-(v:GetPos().z+v:GetVelocity().z)

				

				

				
				if v:IsPlayer() or v:IsNPC() then v:SetVelocity(Vector(0,0,gravity_equation)) else phys:AddVelocity(Vector(0,0,gravity_equation)) end
				
				
					
			i = i + 1
			end
		 end
 	 end
	 self.Bursts = self.Bursts + 1
	 if (self.Bursts >= self.Burst) then
	     self:Remove()
		 self:StopSound("anti_grav")
	 end
	 self:NextThink(CurTime() + self.DELAY)
	 return true
	 end
end
function ENT:OnRemove()
	self:StopSound("anti_grav")
end
function ENT:Draw()
     return false
end