if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_deathanim_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false
ENT.AutomaticFrameAdvance = true 

function ENT:Initialize()
	self:SetHealth( self.health )
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	
	self:ManipulateBoneScale(self:LookupBone("ValveBiped.Bip01_R_Forearm"), Vector(1.5, 1.5, 1.5))
	self:ManipulateBoneScale(self:LookupBone("ValveBiped.Bip01_L_Forearm"), Vector(1.5, 1.5, 1.5))
	
	self:ManipulateBoneScale(self:LookupBone("ValveBiped.Bip01_R_Upperarm"), Vector(1.5, 1.5, 1.5))
	self:ManipulateBoneScale(self:LookupBone("ValveBiped.Bip01_L_Upperarm"), Vector(1.5, 1.5, 1.5))
end

function ENT:GroundShake( time, viewshake, pos )
	timer.Simple(time, function()
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	
	self:EmitSound("hits/body_medium_impact_hard"..math.random(6)..".wav", 67, 90)
	
	local asd = ents.FindInSphere(self:GetPos(), pos)
		for _,v in pairs(asd) do
		
			if (v:IsPlayer()) then
		
				v:ViewPunch(Angle(math.random(-3, viewshake), math.random(-3, viewshake), math.random(-3, viewshake + 1)))
		
			end
		end
	
	end)
end

function ENT:RunBehaviour()
	while ( true ) do	
	if SERVER then
	
	self:GroundShake( 1.3, 5, 200 )
	self:GroundShake( 2, 7, 200 )
	
	self:PlaySequenceAndWait( "death_04", 1.4 ) 
	
	local zombie = ents.Create("nz_deathanim_fakebody")
		if not ( self:IsValid() ) then return end
		zombie:SetPos( self:GetPos() + ( self:GetForward() * 65 ) )
		zombie:SetAngles(self:GetAngles())
		zombie:Spawn()
		zombie:SetModelScale( self:GetModelScale(), 0)
		zombie:SetModel( self:GetModel() )
		zombie:SetSkin(self:GetSkin())
		zombie:SetColor(self:GetColor())
		zombie:SetMaterial(self:GetMaterial())
		zombie:StartActivity( ACT_HL2MP_ZOMBIE_SLUMP_IDLE )
		SafeRemoveEntity( self )
	
		zombie:ManipulateBoneScale(zombie:LookupBone("ValveBiped.Bip01_R_Forearm"), Vector(1.5, 1.5, 1.5))
		zombie:ManipulateBoneScale(zombie:LookupBone("ValveBiped.Bip01_L_Forearm"), Vector(1.5, 1.5, 1.5))
	
		zombie:ManipulateBoneScale(zombie:LookupBone("ValveBiped.Bip01_R_Upperarm"), Vector(1.5, 1.5, 1.5))
		zombie:ManipulateBoneScale(zombie:LookupBone("ValveBiped.Bip01_L_Upperarm"), Vector(1.5, 1.5, 1.5))
	
	coroutine.wait( 0 )
	end
	end
end	