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
ENT.MAX_BURSTS                       = 1


function ENT:Initialize()
     if (SERVER) then
		 self.FILTER                           = {}
         self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	     self:SetSolid( SOLID_NONE )
	     self:SetMoveType( MOVETYPE_NONE )
	     self:SetUseType( ONOFF_USE ) 
	     self.MAX_BURSTS = self:GetVar("MAX_BURSTS")
		 self.Bursts = 0
		 self.CURRENTRANGE = 0
		 self.SOUND = self:GetVar("SOUND")
     end
end

function ENT:Think()			
     if (SERVER) then
     if !self:IsValid() then return end
	 local pos = self:GetPos()
	 self.CURRENTRANGE = self.CURRENTRANGE+self.SHOCKWAVE_INCREMENT
	 for k, v in pairs(ents.FindInSphere(pos,self.MAX_RANGE)) do
		 if v:IsValid() or v:IsPlayer() then
			 local i = 0
			 while i < v:GetPhysicsObjectCount() do
				 phys = v:GetPhysicsObjectNum(i)
				 if (v:IsPlayer()) then
					 if !(table.HasValue(self.FILTER,v:SteamID())) then
						net.Start("sw_net_sound_lowsh")
							net.WriteString(self.SOUND)
						net.Send(v)
						local shocktime = self:GetVar("Shocktime")
						util.ScreenShake( v:GetPos(), 5555, 555, shocktime, 500 )
						table.insert(self.FILTER, v:SteamID() )
					 end
				 end
			 i = i + 1
			 end
		 end
 	 end
	 self.Bursts = self.Bursts + 1
	 if (self.Bursts >= self.MAX_BURSTS) then
		 timer.Simple(5, function()
			if self:IsValid() then
				self:Remove()
			end
		 end)
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
ENT.MAX_BURSTS                       = 1


function ENT:Initialize()
     if (SERVER) then
		 self.FILTER                           = {}
         self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	     self:SetSolid( SOLID_NONE )
	     self:SetMoveType( MOVETYPE_NONE )
	     self:SetUseType( ONOFF_USE ) 
	     self.MAX_BURSTS = self:GetVar("MAX_BURSTS")
		 self.Bursts = 0
		 self.CURRENTRANGE = 0
		 self.SOUND = self:GetVar("SOUND")
     end
end

function ENT:Think()			
     if (SERVER) then
     if !self:IsValid() then return end
	 local pos = self:GetPos()
	 self.CURRENTRANGE = self.CURRENTRANGE+self.SHOCKWAVE_INCREMENT
	 for k, v in pairs(ents.FindInSphere(pos,self.MAX_RANGE)) do
		 if v:IsValid() or v:IsPlayer() then
			 local i = 0
			 while i < v:GetPhysicsObjectCount() do
				 phys = v:GetPhysicsObjectNum(i)
				 if (v:IsPlayer()) then
					 if !(table.HasValue(self.FILTER,v:SteamID())) then
						net.Start("sw_net_sound_lowsh")
							net.WriteString(self.SOUND)
						net.Send(v)
						local shocktime = self:GetVar("Shocktime")
						util.ScreenShake( v:GetPos(), 5555, 555, shocktime, 500 )
						table.insert(self.FILTER, v:SteamID() )
					 end
				 end
			 i = i + 1
			 end
		 end
 	 end
	 self.Bursts = self.Bursts + 1
	 if (self.Bursts >= self.MAX_BURSTS) then
		 timer.Simple(5, function()
			if self:IsValid() then
				self:Remove()
			end
		 end)
	 end
	 self:NextThink(CurTime() + self.DELAY)
	 return true
	 end
end

function ENT:Draw()
     return false
end