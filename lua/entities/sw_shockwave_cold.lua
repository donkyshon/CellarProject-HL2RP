AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )


ENT.Spawnable		            	 =  false
ENT.AdminSpawnable		             =  false     

ENT.PrintName		                 =  ""        
ENT.Author			                 =  ""      
ENT.Contact			                 =  ""      

ENT.GBOWNER                          =  nil            
ENT.MAX_RANGE                        = 0
ENT.SHOCKWAVE_INCREMENT              = 0
ENT.DELAY                            = 0
ENT.SOUND                            = ""

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
		 self.Alpha = 0
		 self.AFFECTED = {}
	     
     end
end
if (CLIENT) then
	local interval = 1
	alpha = 0
	function Cold_Max()
		if (interval <= CurTime()) && (alpha < 255) then
			interval = CurTime() + 0.01
			alpha = alpha + 5
		end
		if !(alpha < 255) then
			alpha = 255
			interval = CurTime() + 0.1
		end
		surface.SetDrawColor(Color(0,148,255, alpha))
		draw.NoTexture()
		surface.DrawRect(0,0,ScrW(),ScrH())
		LocalPlayer():SetAngles(Angle(-90,0,0)) 
		hook.Add( "HUDPaint", "Cold_Max", Cold_Max )
	end
	concommand.Add( "Cold_Max", Cold_Max )
	function ColdNo()
		alpha = 0
		hook.Remove( "HUDPaint", "Cold_Max", Cold_Max )
	end
	concommand.Add( "ColdNo", ColdNo )
end

function ENT:Think(ply)		
     if (SERVER) then
     if !self:IsValid() then return end
	 local pos = self:GetPos()
	 self.CURRENTRANGE = self.CURRENTRANGE+self.SHOCKWAVE_INCREMENT
	 for k, v in pairs(ents.FindInSphere(pos,self.CURRENTRANGE)) do
		 if v:IsValid() or v:IsPlayer() then
			 local i = 0
			 while i < v:GetPhysicsObjectCount() do
				 phys = v:GetPhysicsObjectNum(i)
				 if (phys:IsValid()) then
					 local mass = phys:GetMass()
					 local F_ang = self.DEFAULT_PHYSFORCE
					 local dist = (pos - v:GetPos()):Length()
					 local relation = math.Clamp((self.CURRENTRANGE - dist) / self.CURRENTRANGE, 0, 1)
					 local F_dir = (v:GetPos() - pos):GetNormal() * self.DEFAULT_PHYSFORCE 
					 phys:AddAngleVelocity(Vector(F_ang, F_ang, F_ang) * relation)
					 phys:AddVelocity(F_dir)
				 end
				 if (v:IsPlayer() && v:Alive()) then
					 v:Freeze(true)
					 v:ConCommand("cold_max")
					 v:SetMoveType( MOVETYPE_WALK )				     
					 local mass = phys:GetMass()
					 local F_ang = self.DEFAULT_PHYSFORCE_PLYAIR
					 local dist = (pos - v:GetPos()):Length()
					 local relation = math.Clamp((self.CURRENTRANGE - dist) / self.CURRENTRANGE, 0, 1)
					 local F_dir = (v:GetPos() - pos):GetNormal() * self.DEFAULT_PHYSFORCE_PLYAIR
					 v:SetVelocity( F_dir )		
				 end
			 i = i + 1
			 end
		 end
 	 end
	 self.Bursts = self.Bursts + 1
	 if (self.CURRENTRANGE >= self.MAX_RANGE) then
	     self:Remove()
	 end
	 self:NextThink(CurTime() + self.DELAY)
	 return true
	 end
end

function ENT:Draw()
     return false
end
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )


ENT.Spawnable		            	 =  false
ENT.AdminSpawnable		             =  false     

ENT.PrintName		                 =  ""        
ENT.Author			                 =  ""      
ENT.Contact			                 =  ""      

ENT.GBOWNER                          =  nil            
ENT.MAX_RANGE                        = 0
ENT.SHOCKWAVE_INCREMENT              = 0
ENT.DELAY                            = 0
ENT.SOUND                            = ""

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
		 self.Alpha = 0
		 self.AFFECTED = {}
	     
     end
end
if (CLIENT) then
	local interval = 1
	alpha = 0
	function Cold_Max()
		if (interval <= CurTime()) && (alpha < 255) then
			interval = CurTime() + 0.01
			alpha = alpha + 5
		end
		if !(alpha < 255) then
			alpha = 255
			interval = CurTime() + 0.1
		end
		surface.SetDrawColor(Color(0,148,255, alpha))
		draw.NoTexture()
		surface.DrawRect(0,0,ScrW(),ScrH())
		LocalPlayer():SetAngles(Angle(-90,0,0)) 
		hook.Add( "HUDPaint", "Cold_Max", Cold_Max )
	end
	concommand.Add( "Cold_Max", Cold_Max )
	function ColdNo()
		alpha = 0
		hook.Remove( "HUDPaint", "Cold_Max", Cold_Max )
	end
	concommand.Add( "ColdNo", ColdNo )
end

function ENT:Think(ply)		
     if (SERVER) then
     if !self:IsValid() then return end
	 local pos = self:GetPos()
	 self.CURRENTRANGE = self.CURRENTRANGE+self.SHOCKWAVE_INCREMENT
	 for k, v in pairs(ents.FindInSphere(pos,self.CURRENTRANGE)) do
		 if v:IsValid() or v:IsPlayer() then
			 local i = 0
			 while i < v:GetPhysicsObjectCount() do
				 phys = v:GetPhysicsObjectNum(i)
				 if (phys:IsValid()) then
					 local mass = phys:GetMass()
					 local F_ang = self.DEFAULT_PHYSFORCE
					 local dist = (pos - v:GetPos()):Length()
					 local relation = math.Clamp((self.CURRENTRANGE - dist) / self.CURRENTRANGE, 0, 1)
					 local F_dir = (v:GetPos() - pos):GetNormal() * self.DEFAULT_PHYSFORCE 
					 phys:AddAngleVelocity(Vector(F_ang, F_ang, F_ang) * relation)
					 phys:AddVelocity(F_dir)
				 end
				 if (v:IsPlayer() && v:Alive()) then
					 v:Freeze(true)
					 v:ConCommand("cold_max")
					 v:SetMoveType( MOVETYPE_WALK )				     
					 local mass = phys:GetMass()
					 local F_ang = self.DEFAULT_PHYSFORCE_PLYAIR
					 local dist = (pos - v:GetPos()):Length()
					 local relation = math.Clamp((self.CURRENTRANGE - dist) / self.CURRENTRANGE, 0, 1)
					 local F_dir = (v:GetPos() - pos):GetNormal() * self.DEFAULT_PHYSFORCE_PLYAIR
					 v:SetVelocity( F_dir )		
				 end
			 i = i + 1
			 end
		 end
 	 end
	 self.Bursts = self.Bursts + 1
	 if (self.CURRENTRANGE >= self.MAX_RANGE) then
	     self:Remove()
	 end
	 self:NextThink(CurTime() + self.DELAY)
	 return true
	 end
end

function ENT:Draw()
     return false
end