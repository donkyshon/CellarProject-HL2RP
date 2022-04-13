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

function ENT:Initialize()
     if (SERVER) then
		 self.FILTER                           = {}
         self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	     self:SetSolid( SOLID_NONE )
	     self:SetMoveType( MOVETYPE_NONE )
	     self:SetUseType( ONOFF_USE ) 
		 self.Bursts = 0
		 self.GBOWNER = self:GetVar("GBOWNER")
		 self.SOUND = self:GetVar("SOUND")
		 self.CURRENTRANGE = 15000
		 self.DEFAULT_PHYSFORCE  = 1522
		 self.DEFAULT_PHYSFORCE_PLYAIR  = 1522
	     self.DEFAULT_PHYSFORCE_PLYGROUND = 1522

     end
end

function ENT:Think(ply)		
     if (SERVER) then
     if !self:IsValid() then return end
	 pos = self:GetPos()
	 for k, v in pairs(ents.FindInSphere(self:GetPos(),15000)) do
		 if (v:IsValid() or v:IsPlayer()) and (v.forcefielded==false or v.forcefielded==nil) then
			 local i = 0
			 while i < v:GetPhysicsObjectCount() do
				 phys = v:GetPhysicsObjectNum(i)
				 if (phys:IsValid()) then
					 local mass = phys:GetMass()
					 local F_ang = self.DEFAULT_PHYSFORCE
					 local dist = (pos - v:GetPos()):Length()
			
					 local relation = math.Clamp((self.CURRENTRANGE - dist) / self.CURRENTRANGE, 0, 1)
					 local F_dir = (v:GetPos() - pos):GetNormal() * self.DEFAULT_PHYSFORCE 			 
					 local f_vel = string.Explode( " ", tostring(F_dir) )
					 if self.Bursts == nil then
						 local x = tonumber(f_vel[1])*math.sin(1)
						 local y = tonumber(f_vel[2])*math.sin(1)
						 local z = tonumber(f_vel[3])*math.sin(1)
						 phys:AddVelocity(Vector(x,y,z))
					 else	 
						 local x = tonumber(f_vel[1])*math.sin(self.Bursts/4)
						 local y = tonumber(f_vel[2])*math.sin(self.Bursts/4)
						 local z = tonumber(f_vel[3])*math.sin(self.Bursts/4)
						 phys:AddVelocity(Vector(x,y,z))
					 end
					 phys:AddAngleVelocity(Vector(F_ang, F_ang, F_ang) * relation)
			

					 if(GetConVar("gb5_shockwave_unfreeze"):GetInt() >= 1) then
						 phys:Wake()
						 phys:EnableMotion(true)
						 constraint.RemoveAll(v)
					 end
				 end
				 
				 if (v:IsPlayer() && !v:IsOnGround()) then				
					 v:SetMoveType( MOVETYPE_WALK )
					 local mass = phys:GetMass()
					 local F_ang = self.DEFAULT_PHYSFORCE_PLYAIR
					 local dist = (pos - v:GetPos()):Length()
					 local relation = math.Clamp((15000 - dist) / 15000, 0, 1)
					 local F_dir = (v:GetPos() - pos):GetNormal() * self.DEFAULT_PHYSFORCE_PLYAIR
					
					 f_vel = string.Explode( " ", tostring(F_dir) )
					 
					 if self.Bursts == nil then
						 local x = tonumber(f_vel[1])*math.sin(1)
						 local y = tonumber(f_vel[2])*math.sin(1)
						 local z = tonumber(f_vel[3])*math.sin(1)
						 v:SetVelocity( Vector(x,y,z))
					 else	 
						 local x = tonumber(f_vel[1])*math.sin(self.Bursts/4)
						 local y = tonumber(f_vel[2])*math.sin(self.Bursts/4)
						 local z = tonumber(f_vel[3])*math.sin(self.Bursts/4)
						 v:SetVelocity( Vector(x,y,z))
					 end
				 end

				 if (v:IsPlayer()) and v:IsOnGround() then

					 v:SetMoveType( MOVETYPE_WALK )
					 local pos = self:GetPos()
					 local mass = phys:GetMass()
					 local F_ang = self.DEFAULT_PHYSFORCE_PLYGROUND
					 local dist = (pos - v:GetPos()):Length()
					 local relation = math.Clamp((15000 - dist) / 15000, 0, 1)
					 local F_dir = (v:GetPos() - pos):GetNormal() * self.DEFAULT_PHYSFORCE_PLYGROUND	 
	
					 local f_vel = string.Explode( " ", tostring(F_dir) )
					 
					 if self.Bursts == nil then
						 local x = tonumber(f_vel[1])*math.sin(1)
						 local y = tonumber(f_vel[2])*math.sin(1)
						 local z = tonumber(f_vel[3])*math.sin(1)
						 v:SetVelocity( Vector(x,y,z))
					 else	 
						 local x = tonumber(f_vel[1])*math.sin(self.Bursts/4)
						 local y = tonumber(f_vel[2])*math.sin(self.Bursts/4)
						 local z = tonumber(f_vel[3])*math.sin(self.Bursts/4)
						 v:SetVelocity( Vector(x,y,z))
					 end

					 
				 end
			 i = i + 1
			 end
		 end
 	 end
	 self.Bursts = self.Bursts + 1

	 if (self.Bursts >= 300) then
	     self:Remove()
	 end
	 self:NextThink(CurTime() + 0.1)
	 return true
	 end
end

function ENT:Draw()
     return false
end