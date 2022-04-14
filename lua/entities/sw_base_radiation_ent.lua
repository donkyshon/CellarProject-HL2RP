AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )


ENT.Spawnable		            	 =  false
ENT.AdminSpawnable		             =  false     

ENT.PrintName		                 =  "Radiation"        
ENT.Author			                 =  ""      
ENT.Contact			                 =  ""      
          
function ENT:Initialize()
     if (SERVER) then
         self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	     self:SetSolid( SOLID_NONE )
	     self:SetMoveType( MOVETYPE_NONE )
	     self:SetUseType( ONOFF_USE ) 
		 self.Bursts = 0
		 self.GBOWNER = self:GetVar("GBOWNER")
		 self.RadRadius = self:GetVar("Rad_Radius")
		 if self.RadRadius==nil then
			self.RadRadius=500
		 end
		 if self.Burst==nil then
			self.Burst=10
		 end
     end
end

function ENT:Think()
	
	if (SERVER) then
	if !self:IsValid() then return end
	local pos = self:GetPos()
	for k, v in pairs(ents.FindInSphere(pos,self.RadRadius)) do
		if v:IsPlayer() and !v:IsNPC() and v.hazsuited==false then
			local dist = (self:GetPos() - v:GetPos()):Length()
			local relation = math.Clamp((self.RadRadius - dist) / self.RadRadius, 0, 1)
			local dmg = DamageInfo()
			dmg:SetDamage(10*relation)
			dmg:SetDamageType(DMG_RADIATION)
			if self.GBOWNER==nil or !self.GBOWNER:IsValid() then
				self.GBOWNER=table.Random(player.GetAll())
			end
			dmg:SetAttacker(self.GBOWNER)
			v:EmitSound("player/geiger2.wav", 100, 100)
			v:TakeDamageInfo(dmg)
		end
	end
	self.Bursts = self.Bursts + 1
	if (self.Bursts >= self.Burst) then
		self:Remove()
	end
	self:NextThink(CurTime() + math.random(1,2))
	return true
	end
end

function ENT:Draw()
     return true
end
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )


ENT.Spawnable		            	 =  false
ENT.AdminSpawnable		             =  false     

ENT.PrintName		                 =  "Radiation"        
ENT.Author			                 =  ""      
ENT.Contact			                 =  ""      
          
function ENT:Initialize()
     if (SERVER) then
         self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	     self:SetSolid( SOLID_NONE )
	     self:SetMoveType( MOVETYPE_NONE )
	     self:SetUseType( ONOFF_USE ) 
		 self.Bursts = 0
		 self.GBOWNER = self:GetVar("GBOWNER")
		 self.RadRadius = self:GetVar("Rad_Radius")
		 if self.RadRadius==nil then
			self.RadRadius=500
		 end
		 if self.Burst==nil then
			self.Burst=10
		 end
     end
end

function ENT:Think()
	
	if (SERVER) then
	if !self:IsValid() then return end
	local pos = self:GetPos()
	for k, v in pairs(ents.FindInSphere(pos,self.RadRadius)) do
		if v:IsPlayer() and !v:IsNPC() and v.hazsuited==false then
			local dist = (self:GetPos() - v:GetPos()):Length()
			local relation = math.Clamp((self.RadRadius - dist) / self.RadRadius, 0, 1)
			local dmg = DamageInfo()
			dmg:SetDamage(10*relation)
			dmg:SetDamageType(DMG_RADIATION)
			if self.GBOWNER==nil or !self.GBOWNER:IsValid() then
				self.GBOWNER=table.Random(player.GetAll())
			end
			dmg:SetAttacker(self.GBOWNER)
			v:EmitSound("player/geiger2.wav", 100, 100)
			v:TakeDamageInfo(dmg)
		end
	end
	self.Bursts = self.Bursts + 1
	if (self.Bursts >= self.Burst) then
		self:Remove()
	end
	self:NextThink(CurTime() + math.random(1,2))
	return true
	end
end

function ENT:Draw()
     return true
end