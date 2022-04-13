if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false
ENT.AutomaticFrameAdvance = true 

--Stats--
--Model Settings--
ENT.Model = ("")
ENT.health = 5001

function ENT:Precache()
end

function ENT:Initialize()
	self:SetHealth( self.health )
	self:SetModel(self.Model)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
end

function ENT:BehaveAct()
end

function ENT:Think()
end

function ENT:OnRemove()
end

function ENT:GetEnemy()
end

function ENT:OnStuck()
end

function ENT:OnUnStuck()
end

function ENT:SetEnemy()
end

function ENT:GetDoor()
end

function ENT:MoveToPos( pos, options )
end
	
function ENT:AttackProp()
end

function ENT:UpdateEnemy()
end

function ENT:RunBehaviour()
	while ( true ) do	
	if SERVER then
	
	local anim = math.random(1,4)
	if anim == 1 then
		self:PlaySequenceAndWait( "death_03", 1.2 )
	elseif anim == 2 then
		self:PlaySequenceAndWait( "death_02", 1.2 )
	elseif anim == 3 then
		self:PlaySequenceAndWait( "death_03", 1.2 )
	elseif anim == 4 then
	
		timer.Simple(1.6, function()
			if !self:IsValid() then return end
			if self:Health() < 0 then return end
			self:EmitSound("hits/body_medium_impact_hard"..math.random(6)..".wav", 67, 85)
		end)
	
		timer.Simple(1, function()
			if !self:IsValid() then return end
			if self:Health() < 0 then return end
			self:EmitSound("hits/body_medium_impact_hard"..math.random(6)..".wav", 67, 90)
		end)
	
		self:PlaySequenceAndWait( "death_04", 1.6 )
		
	end
	
	self:TakeDamage( self.health )
	
	coroutine.wait( 0 )
	end
	end
end	

function ENT:OnLeaveGround()
end

function ENT:OnLandOnGround() 
end

function ENT:OnKilled( dmginfo )
	dmginfo:SetDamage(1)
 
	self:MorphRagdoll( dmginfo )
   
end

function ENT:OnInjured( dmginfo )
	if !dmginfo:GetAttacker() == self and !dmginfo:GetInflictor() == self then
		dmginfo:ScaleDamage(0)
	end
end

function ENT:TransformRagdoll( dmginfo )

	if !self:IsValid() then return end
	
	local ragdoll = ents.Create("prop_ragdoll")
		if ragdoll:IsValid() then 
			ragdoll:SetPos(self:GetPos())
			ragdoll:SetModel(self:GetModel())
			ragdoll:SetAngles(self:GetAngles())
			ragdoll:Spawn()
			ragdoll:SetSkin(self:GetSkin())
			ragdoll:SetColor(self:GetColor())
			ragdoll:SetMaterial(self:GetMaterial())
			
			local num = ragdoll:GetPhysicsObjectCount()-1
			local v = self.loco:GetVelocity()	
   
			for i=0, num do
				local bone = ragdoll:GetPhysicsObjectNum(i)

				if IsValid(bone) then
					local bp, ba = self:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
					if bp and ba then
						bone:SetPos(bp)
						bone:SetAngles(ba)
					end
					bone:SetVelocity(v)
				end
	  
			end
			
			local bodygroups = self:GetBodygroup(1)
			ragdoll:SetBodygroup( 1, bodygroups )
			
			ragdoll:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			
		end
	
	SafeRemoveEntity( self )
	
end

function ENT:MorphRagdoll( dmginfo )

	if GetGlobalBool( "nb_use_ragdolls" ) then
		self:TransformRagdoll( dmginfo )
	else
		self:BecomeRagdoll( dmginfo )
	end
	
end
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false
ENT.AutomaticFrameAdvance = true 

--Stats--
--Model Settings--
ENT.Model = ("")
ENT.health = 5001

function ENT:Precache()
end

function ENT:Initialize()
	self:SetHealth( self.health )
	self:SetModel(self.Model)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
end

function ENT:BehaveAct()
end

function ENT:Think()
end

function ENT:OnRemove()
end

function ENT:GetEnemy()
end

function ENT:OnStuck()
end

function ENT:OnUnStuck()
end

function ENT:SetEnemy()
end

function ENT:GetDoor()
end

function ENT:MoveToPos( pos, options )
end
	
function ENT:AttackProp()
end

function ENT:UpdateEnemy()
end

function ENT:RunBehaviour()
	while ( true ) do	
	if SERVER then
	
	local anim = math.random(1,4)
	if anim == 1 then
		self:PlaySequenceAndWait( "death_03", 1.2 )
	elseif anim == 2 then
		self:PlaySequenceAndWait( "death_02", 1.2 )
	elseif anim == 3 then
		self:PlaySequenceAndWait( "death_03", 1.2 )
	elseif anim == 4 then
	
		timer.Simple(1.6, function()
			if !self:IsValid() then return end
			if self:Health() < 0 then return end
			self:EmitSound("hits/body_medium_impact_hard"..math.random(6)..".wav", 67, 85)
		end)
	
		timer.Simple(1, function()
			if !self:IsValid() then return end
			if self:Health() < 0 then return end
			self:EmitSound("hits/body_medium_impact_hard"..math.random(6)..".wav", 67, 90)
		end)
	
		self:PlaySequenceAndWait( "death_04", 1.6 )
		
	end
	
	self:TakeDamage( self.health )
	
	coroutine.wait( 0 )
	end
	end
end	

function ENT:OnLeaveGround()
end

function ENT:OnLandOnGround() 
end

function ENT:OnKilled( dmginfo )
	dmginfo:SetDamage(1)
 
	self:MorphRagdoll( dmginfo )
   
end

function ENT:OnInjured( dmginfo )
	if !dmginfo:GetAttacker() == self and !dmginfo:GetInflictor() == self then
		dmginfo:ScaleDamage(0)
	end
end

function ENT:TransformRagdoll( dmginfo )

	if !self:IsValid() then return end
	
	local ragdoll = ents.Create("prop_ragdoll")
		if ragdoll:IsValid() then 
			ragdoll:SetPos(self:GetPos())
			ragdoll:SetModel(self:GetModel())
			ragdoll:SetAngles(self:GetAngles())
			ragdoll:Spawn()
			ragdoll:SetSkin(self:GetSkin())
			ragdoll:SetColor(self:GetColor())
			ragdoll:SetMaterial(self:GetMaterial())
			
			local num = ragdoll:GetPhysicsObjectCount()-1
			local v = self.loco:GetVelocity()	
   
			for i=0, num do
				local bone = ragdoll:GetPhysicsObjectNum(i)

				if IsValid(bone) then
					local bp, ba = self:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
					if bp and ba then
						bone:SetPos(bp)
						bone:SetAngles(ba)
					end
					bone:SetVelocity(v)
				end
	  
			end
			
			local bodygroups = self:GetBodygroup(1)
			ragdoll:SetBodygroup( 1, bodygroups )
			
			ragdoll:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			
		end
	
	SafeRemoveEntity( self )
	
end

function ENT:MorphRagdoll( dmginfo )

	if GetGlobalBool( "nb_use_ragdolls" ) then
		self:TransformRagdoll( dmginfo )
	else
		self:BecomeRagdoll( dmginfo )
	end
	
end