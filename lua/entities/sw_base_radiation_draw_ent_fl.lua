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
		 self.Plylist={}
		 self.EntList={}
		 if self.RadRadius==nil then
			self.RadRadius=500
		 end	 
     end
end

function ENT:Think()
	if (CLIENT) then
		function Radiation()
			local tex = surface.GetTextureID("hud/radiation")
			surface.SetTexture(tex)
			surface.SetDrawColor( 255, 255, 255, LocalPlayer():GetNWFloat("rad_relation", 0)*255 );		
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
			hook.Remove( "HUDPaint", "Radiation", Radiation)
		end
		hook.Add( "HUDPaint", "Radiation", Radiation)
	end
	if (SERVER) then
	if !self:IsValid() then return end
	if self.radowner:IsValid() then 
		self.pos = string.Explode( " ", tostring(self.radowner:GetPos()) )
		self:SetPos(Vector(self.pos[1],self.pos[2],self.pos[3]))
		local pos = self:GetPos()
		self.TotalList={}
		for k, v in pairs(ents.FindInSphere(pos,self.RadRadius)) do
			if v:IsPlayer() and !v:IsNPC() and v.hazsuited==false then
				local dist = (self:GetPos() - v:GetPos()):Length()
				local relation = math.Clamp((self.RadRadius - dist) / self.RadRadius, 0, 1)
				v:SetNWFloat("rad_relation", relation  )
				v:SetNWFloat("Affected", 1  )
				table.insert(self.Plylist,v)
				table.insert(self.TotalList, v )

			end
		end

		for k, v in pairs(self.TotalList) do
			if v:IsValid() then 
				if !table.HasValue(self.EntList,v) then
						if v:IsPlayer() then
							table.insert(self.EntList, v )
						end
				end
			end
		end
		for index, entlist_ply in pairs(self.EntList) do
			if !table.HasValue(self.TotalList, entlist_ply ) then
				if entlist_ply:IsValid() then
					table.remove(self.EntList, index)
					entlist_ply:SetNWFloat("rad_relation", 0  )
				end
			end
		end
	else
		self:Remove()
	end
	self:NextThink(CurTime() + 0.01)
	return true
	end
end
function ENT:OnRemove()
	if (CLIENT) then
		if (LocalPlayer():GetNWFloat("Affected")) then
		end
	end
	if (SERVER) then
		for k, v in pairs(self.Plylist) do
			if v:IsValid() then
				if v:GetNWFloat("Affected", 0  ) then
					v:SetNWFloat("Affected", 0  )
					v:SetNWFloat("rad_relation", 0  )
				end
			end
		end
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
		 self.Plylist={}
		 self.EntList={}
		 if self.RadRadius==nil then
			self.RadRadius=500
		 end	 
     end
end

function ENT:Think()
	if (CLIENT) then
		function Radiation()
			local tex = surface.GetTextureID("hud/radiation")
			surface.SetTexture(tex)
			surface.SetDrawColor( 255, 255, 255, LocalPlayer():GetNWFloat("rad_relation", 0)*255 );		
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
			hook.Remove( "HUDPaint", "Radiation", Radiation)
		end
		hook.Add( "HUDPaint", "Radiation", Radiation)
	end
	if (SERVER) then
	if !self:IsValid() then return end
	if self.radowner:IsValid() then 
		self.pos = string.Explode( " ", tostring(self.radowner:GetPos()) )
		self:SetPos(Vector(self.pos[1],self.pos[2],self.pos[3]))
		local pos = self:GetPos()
		self.TotalList={}
		for k, v in pairs(ents.FindInSphere(pos,self.RadRadius)) do
			if v:IsPlayer() and !v:IsNPC() and v.hazsuited==false then
				local dist = (self:GetPos() - v:GetPos()):Length()
				local relation = math.Clamp((self.RadRadius - dist) / self.RadRadius, 0, 1)
				v:SetNWFloat("rad_relation", relation  )
				v:SetNWFloat("Affected", 1  )
				table.insert(self.Plylist,v)
				table.insert(self.TotalList, v )

			end
		end

		for k, v in pairs(self.TotalList) do
			if v:IsValid() then 
				if !table.HasValue(self.EntList,v) then
						if v:IsPlayer() then
							table.insert(self.EntList, v )
						end
				end
			end
		end
		for index, entlist_ply in pairs(self.EntList) do
			if !table.HasValue(self.TotalList, entlist_ply ) then
				if entlist_ply:IsValid() then
					table.remove(self.EntList, index)
					entlist_ply:SetNWFloat("rad_relation", 0  )
				end
			end
		end
	else
		self:Remove()
	end
	self:NextThink(CurTime() + 0.01)
	return true
	end
end
function ENT:OnRemove()
	if (CLIENT) then
		if (LocalPlayer():GetNWFloat("Affected")) then
		end
	end
	if (SERVER) then
		for k, v in pairs(self.Plylist) do
			if v:IsValid() then
				if v:GetNWFloat("Affected", 0  ) then
					v:SetNWFloat("Affected", 0  )
					v:SetNWFloat("rad_relation", 0  )
				end
			end
		end
	end
end
function ENT:Draw()
     return true
end