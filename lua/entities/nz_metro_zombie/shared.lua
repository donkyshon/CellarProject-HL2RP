if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_metro_zombie", {
	Name = "Infested Metro Cop",
	Class = "nz_metro_zombie",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.MoveType = 2

ENT.FootAngles = 5

ENT.CollisionHeight = 66
ENT.CollisionSide = 11

ENT.Speed = 50
ENT.WalkSpeedAnimation = 1.6
ENT.FlinchSpeed = 0

ENT.health = 165
ENT.Damage = 25

ENT.PhysForce = 25000
ENT.AttackRange = 40
ENT.InitialAttackRange = 55
ENT.DoorAttackRange = 25

ENT.NextAttack = 2

--Model Settings--
ENT.Model = "models/cpassic/cpassic.mdl"

ENT.GrabAnim = "enter_choke"
ENT.GrabFailAnim = "choke_miss"
ENT.HoldAnim = "choke_eat"

ENT.AttackAnim1 = "attacka"
ENT.AttackAnim2 = "attackb"
ENT.AttackAnim3 = "attackc"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

--Sounds--
ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.HitSound = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()

--Sounds--	

util.PrecacheSound(self.HitSound)
util.PrecacheSound(self.Miss)

end

function ENT:Animations()

	self.WalkAnims = { "walk1", "walk2", "walk3", "walk4", "walk5", "walk6", "walk7", "walk8", "walk9", "walk10" }
	self.IdleAnimations =  { "idle01", "idle02", "idle03", "idle04" }
	
	self.WalkAnim = ( table.Random( self.WalkAnims ) )
	self.IdleAnim = ( table.Random( self.IdleAnimations ) )
	
	if self.WalkAnim == "walk8" then
	
		self.Speed = self.Speed - 10
		
	end

end

function ENT:Initialize()

	if SERVER then

	--Stats--
	self:SetHealth(self.health)	
	
	self:SetModel( self.Model )
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	self.FakeDeath = false
	self.IsGrabbing = false
	self.Stumbling = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(200)
	self.loco:SetDeceleration(900)
	
	self:Animations()
	
	--Misc--
	self:Precache()
	self:CreateBullseye()
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
	end
	
end

function ENT:CheckStatus()
	
	if self.Flinching then
		return false
	end
	
	if self.IsGrabbing then
		return false
	end
	
	return true
	
end

function ENT:IdleFunction()

	if ( self.NextIdleFunction or 0 ) < CurTime() then

		if math.random(1,5) == 1 then
			self:IdleSound()
		end
		
		self:ResetSequence( self.IdleAnim )
	
		self.NextIdleFunction = CurTime() + 4
	end
	
end

function ENT:CustomDeath( dmginfo )

	if ( dmginfo:IsBulletDamage() ) then

	local attacker = dmginfo:GetAttacker()
        // hack: get hitgroup
	local trace = {}
	trace.start = attacker:GetShootPos()
		
	trace.endpos = trace.start + ( ( dmginfo:GetDamagePosition() - trace.start ) * 2 )  
	trace.mask = MASK_SHOT
	trace.filter = attacker
		
	local tr = util.TraceLine( trace )
	hitgroup = tr.HitGroup
	
		if hitgroup == HITGROUP_HEAD then
			self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,65) )	
		end
	
	end

	self:MorphRagdoll( dmginfo )

end

function ENT:ArmorVisual( pos )

	local effectdata = EffectData()
		effectdata:SetStart( pos ) 
		effectdata:SetOrigin( pos )
		effectdata:SetScale( 1 )
		util.Effect( "StunStickImpact", effectdata )
		
end

function ENT:CustomInjure( dmginfo )
	
	if ( dmginfo:IsBulletDamage() ) then

	local attacker = dmginfo:GetAttacker()
        // hack: get hitgroup
	local trace = {}
	trace.start = attacker:GetShootPos()
		
	trace.endpos = trace.start + ( ( dmginfo:GetDamagePosition() - trace.start ) * 2 )  
	trace.mask = MASK_SHOT
	trace.filter = attacker
		
	local tr = util.TraceLine( trace )
	hitgroup = tr.HitGroup
	
	if hitgroup == HITGROUP_HEAD then
		if attacker:IsNPC() then
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(3)
			else
				dmginfo:ScaleDamage(2)
			end
		else
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(4)
			else
				dmginfo:ScaleDamage(3)
			end
		end
		
		self:ArmorVisual( dmginfo:GetDamagePosition() )
		self:EmitSound("hits/armor_hit.wav")
		
	else
		if attacker:IsNPC() then
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(0.80)
			else
				dmginfo:ScaleDamage(0.70)
			end
		else
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(0.70)
			else
				dmginfo:ScaleDamage(0.60)
			end
		end
	end
		
		if dmginfo:GetDamage() > 14 then
			self:Flinch( dmginfo, hitgroup )
		end
		
	end
	
end

function ENT:PlayFlinchSequence( string, rate, cycle, speed, time )
	self.Flinching = true

	self:ResetSequence( string )
	self:SetCycle( cycle )
	self:SetPlaybackRate( rate )
	self.loco:SetDesiredSpeed( speed )
	
	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		self.loco:SetAcceleration(200)
		self:ResumeMovementFunctions()
		self.Flinching = false
		self.Stumbling = false
	end)
end

function ENT:CustomChaseEnemy()

	if self.Stumbling then
		self:BackUp( self.StumbleType )
	end
	
end
	
function ENT:BackUp( type )
	
	local enemy = self:GetEnemy()
	while( self.Stumbling ) do
		
		if type == 1 then
			local back = self:GetPos() + self:GetAngles():Forward() * -778
			self.loco:Approach(back, 100)
		elseif type == 2 then
			local back = self:GetPos() + self:GetAngles():Forward() * 778
			self.loco:Approach(back, 100)	
		end
			
		coroutine.wait(0.05)
	end
	
	coroutine.yield()
end	

function ENT:Flinch( dmginfo, hitgroup )
	
	if ( self.NextFlinch or 0 ) < CurTime() then
	
		if !self:CheckValid( self ) then return end
		if !self:CheckStatus() then return end
	
		if hitgroup == HITGROUP_HEAD then
			self:PlayFlinchSequence( self.HeadFlinch, 1, 0, 0, 0.7 )
		elseif hitgroup == HITGROUP_LEFTLEG then
			self:PlayFlinchSequence( self.LLegFlinch, 1, 0, 0, 2.5 )
		elseif hitgroup == HITGROUP_RIGHTLEG then
			self:PlayFlinchSequence( self.RLegFlinch, 1, 0, 0, 1.6 )
		elseif hitgroup == HITGROUP_LEFTARM then
			self:PlayFlinchSequence( self.LArmFlinch, 1, 0, 0, 0.7 )
		elseif hitgroup == HITGROUP_RIGHTARM then
			self:PlayFlinchSequence( self.RArmFlinch, 1, 0, 0, 0.7 )
		elseif hitgroup == HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH then
			
			local enemy = dmginfo:GetAttacker()
			
			if enemy:IsValid() then
				if enemy:IsPlayer() then
				
					local enemyforward = enemy:GetForward()
					local forward = self:GetForward() 
					
					if enemyforward:Distance( forward ) < 1 then
						self:PlayFlinchSequence( "shovereactbehind", 1, 0, self.Speed -  25, 1.6 )
						self.loco:SetAcceleration(1000)
						self.Stumbling = true
						self.StumbleType = 2
					else
						self:PlayFlinchSequence( "shovereact", 1, 0, self.Speed - 25, 1.6 )
						self.loco:SetAcceleration(1000)
						self.Stumbling = true
						self.StumbleType = 1
					end
				
				end
			end
			
		end
		
		self.NextFlinch = CurTime() + 3	
	end	
	
end

function ENT:FootSteps()
	self:EmitSound("npc/metropolice/gear"..math.random(6)..".wav", 65)
end

function ENT:AlertSound()
end

function ENT:AlertSound()

end

function ENT:PainSound()
	if math.random(1,3) == 1 then
	
	end
end

function ENT:DeathSound()

end

function ENT:AttackSound()

end

function ENT:IdleSound()

end

function ENT:CustomDoorAttack( ent )

	if ( self.NextDoorAttackTimer or 0 ) < CurTime() then
	
		if !self:CheckStatus() then return end
	
		self:AttackSound()
	
		self:Melee( ent, 2 )
		
		self.NextDoorAttackTimer = CurTime() + self.NextAttack
	end
	
end
	
function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then

		if !self:CheckStatus() then return end
	
		self:AttackSound()
	
		self:Melee( ent, 1 )
	
		self.NextPropAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:AttackEffect( time, ent, dmg, type )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		if !self:CheckStatus() then return end
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage( self.Damage, self )
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound( self.HitSound )
			end
			
			if ent:IsPlayer() then
				ent:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
			end
			
			if type == 1 then
				local phys = ent:GetPhysicsObject()
				if (phys != nil && phys != NULL && phys:IsValid() ) then
					phys:ApplyForceCenter(self:GetForward():GetNormalized()*(self.PhysForce) + Vector(0, 0, 2))
					ent:EmitSound(self.DoorBreak)
				end
			elseif type == 2 then
				if ent != NULL and ent.Hitsleft != nil then
					if ent.Hitsleft > 0 then
						ent.Hitsleft = ent.Hitsleft - self.HitPerDoor	
						ent:EmitSound(self.DoorBreak)
					end
				end
			end
							
		else	
			self:EmitSound( self.Miss )
		end
		
	end)

end

function ENT:Melee( ent, type )

	local attack = math.random(1,3)
	if attack == 1 then
		self:AttackEffect( 0.8, ent, self.Damage, type )
		self:PlaySequenceAndWait( self.AttackAnim1, 1 )
	elseif attack == 2 then
		self:AttackEffect( 0.7, ent, self.Damage - 10, type )
		self:AttackEffect( 1.2, ent, self.Damage - 10, type )
		self:PlaySequenceAndWait( self.AttackAnim2, 1 )
	elseif attack == 3 then
		self:AttackEffect( 0.8, ent, self.Damage - 10, type )
		self:AttackEffect( 1.6, ent, self.Damage - 10, type )
		self:PlaySequenceAndWait( self.AttackAnim3, 1 )
	end
	
	self.IsAttacking = false
	self:ResumeMovementFunctions()
	
end

function ENT:Attack()
		
	if ( self.NextAttackTimer or 0 ) < CurTime() then	
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
			if !self:CheckStatus() then return end
			
			self:AttackSound()
			self.IsAttacking = true
	
			self:Melee( self.Enemy, 0 )
			
		end
		
		self.NextAttackTimer = CurTime() + self.NextAttack
	end	
	
end

function ENT:CustomThink()
	
	local enemy = self:GetEnemy()
		
	if enemy and enemy:IsValid() and enemy:Health() > 0 then
		if self.IsAttacking then
			if (GetConVarNumber("nb_stop") == 0) then
				self.loco:FaceTowards( self.Enemy:GetPos() )
			end
		end
	else
		self.IsAttacking = false
	end
	
end
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_metro_zombie", {
	Name = "Infested Metro Cop",
	Class = "nz_metro_zombie",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.MoveType = 2

ENT.FootAngles = 5

ENT.CollisionHeight = 66
ENT.CollisionSide = 11

ENT.Speed = 50
ENT.WalkSpeedAnimation = 1.6
ENT.FlinchSpeed = 0

ENT.health = 165
ENT.Damage = 25

ENT.PhysForce = 25000
ENT.AttackRange = 40
ENT.InitialAttackRange = 55
ENT.DoorAttackRange = 25

ENT.NextAttack = 2

--Model Settings--
ENT.Model = "models/cpassic/cpassic.mdl"

ENT.GrabAnim = "enter_choke"
ENT.GrabFailAnim = "choke_miss"
ENT.HoldAnim = "choke_eat"

ENT.AttackAnim1 = "attacka"
ENT.AttackAnim2 = "attackb"
ENT.AttackAnim3 = "attackc"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

--Sounds--
ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.HitSound = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()

--Sounds--	

util.PrecacheSound(self.HitSound)
util.PrecacheSound(self.Miss)

end

function ENT:Animations()

	self.WalkAnims = { "walk1", "walk2", "walk3", "walk4", "walk5", "walk6", "walk7", "walk8", "walk9", "walk10" }
	self.IdleAnimations =  { "idle01", "idle02", "idle03", "idle04" }
	
	self.WalkAnim = ( table.Random( self.WalkAnims ) )
	self.IdleAnim = ( table.Random( self.IdleAnimations ) )
	
	if self.WalkAnim == "walk8" then
	
		self.Speed = self.Speed - 10
		
	end

end

function ENT:Initialize()

	if SERVER then

	--Stats--
	self:SetHealth(self.health)	
	
	self:SetModel( self.Model )
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	self.FakeDeath = false
	self.IsGrabbing = false
	self.Stumbling = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(200)
	self.loco:SetDeceleration(900)
	
	self:Animations()
	
	--Misc--
	self:Precache()
	self:CreateBullseye()
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
	end
	
end

function ENT:CheckStatus()
	
	if self.Flinching then
		return false
	end
	
	if self.IsGrabbing then
		return false
	end
	
	return true
	
end

function ENT:IdleFunction()

	if ( self.NextIdleFunction or 0 ) < CurTime() then

		if math.random(1,5) == 1 then
			self:IdleSound()
		end
		
		self:ResetSequence( self.IdleAnim )
	
		self.NextIdleFunction = CurTime() + 4
	end
	
end

function ENT:CustomDeath( dmginfo )

	if ( dmginfo:IsBulletDamage() ) then

	local attacker = dmginfo:GetAttacker()
        // hack: get hitgroup
	local trace = {}
	trace.start = attacker:GetShootPos()
		
	trace.endpos = trace.start + ( ( dmginfo:GetDamagePosition() - trace.start ) * 2 )  
	trace.mask = MASK_SHOT
	trace.filter = attacker
		
	local tr = util.TraceLine( trace )
	hitgroup = tr.HitGroup
	
		if hitgroup == HITGROUP_HEAD then
			self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,65) )	
		end
	
	end

	self:MorphRagdoll( dmginfo )

end

function ENT:ArmorVisual( pos )

	local effectdata = EffectData()
		effectdata:SetStart( pos ) 
		effectdata:SetOrigin( pos )
		effectdata:SetScale( 1 )
		util.Effect( "StunStickImpact", effectdata )
		
end

function ENT:CustomInjure( dmginfo )
	
	if ( dmginfo:IsBulletDamage() ) then

	local attacker = dmginfo:GetAttacker()
        // hack: get hitgroup
	local trace = {}
	trace.start = attacker:GetShootPos()
		
	trace.endpos = trace.start + ( ( dmginfo:GetDamagePosition() - trace.start ) * 2 )  
	trace.mask = MASK_SHOT
	trace.filter = attacker
		
	local tr = util.TraceLine( trace )
	hitgroup = tr.HitGroup
	
	if hitgroup == HITGROUP_HEAD then
		if attacker:IsNPC() then
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(3)
			else
				dmginfo:ScaleDamage(2)
			end
		else
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(4)
			else
				dmginfo:ScaleDamage(3)
			end
		end
		
		self:ArmorVisual( dmginfo:GetDamagePosition() )
		self:EmitSound("hits/armor_hit.wav")
		
	else
		if attacker:IsNPC() then
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(0.80)
			else
				dmginfo:ScaleDamage(0.70)
			end
		else
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(0.70)
			else
				dmginfo:ScaleDamage(0.60)
			end
		end
	end
		
		if dmginfo:GetDamage() > 14 then
			self:Flinch( dmginfo, hitgroup )
		end
		
	end
	
end

function ENT:PlayFlinchSequence( string, rate, cycle, speed, time )
	self.Flinching = true

	self:ResetSequence( string )
	self:SetCycle( cycle )
	self:SetPlaybackRate( rate )
	self.loco:SetDesiredSpeed( speed )
	
	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		self.loco:SetAcceleration(200)
		self:ResumeMovementFunctions()
		self.Flinching = false
		self.Stumbling = false
	end)
end

function ENT:CustomChaseEnemy()

	if self.Stumbling then
		self:BackUp( self.StumbleType )
	end
	
end
	
function ENT:BackUp( type )
	
	local enemy = self:GetEnemy()
	while( self.Stumbling ) do
		
		if type == 1 then
			local back = self:GetPos() + self:GetAngles():Forward() * -778
			self.loco:Approach(back, 100)
		elseif type == 2 then
			local back = self:GetPos() + self:GetAngles():Forward() * 778
			self.loco:Approach(back, 100)	
		end
			
		coroutine.wait(0.05)
	end
	
	coroutine.yield()
end	

function ENT:Flinch( dmginfo, hitgroup )
	
	if ( self.NextFlinch or 0 ) < CurTime() then
	
		if !self:CheckValid( self ) then return end
		if !self:CheckStatus() then return end
	
		if hitgroup == HITGROUP_HEAD then
			self:PlayFlinchSequence( self.HeadFlinch, 1, 0, 0, 0.7 )
		elseif hitgroup == HITGROUP_LEFTLEG then
			self:PlayFlinchSequence( self.LLegFlinch, 1, 0, 0, 2.5 )
		elseif hitgroup == HITGROUP_RIGHTLEG then
			self:PlayFlinchSequence( self.RLegFlinch, 1, 0, 0, 1.6 )
		elseif hitgroup == HITGROUP_LEFTARM then
			self:PlayFlinchSequence( self.LArmFlinch, 1, 0, 0, 0.7 )
		elseif hitgroup == HITGROUP_RIGHTARM then
			self:PlayFlinchSequence( self.RArmFlinch, 1, 0, 0, 0.7 )
		elseif hitgroup == HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH then
			
			local enemy = dmginfo:GetAttacker()
			
			if enemy:IsValid() then
				if enemy:IsPlayer() then
				
					local enemyforward = enemy:GetForward()
					local forward = self:GetForward() 
					
					if enemyforward:Distance( forward ) < 1 then
						self:PlayFlinchSequence( "shovereactbehind", 1, 0, self.Speed -  25, 1.6 )
						self.loco:SetAcceleration(1000)
						self.Stumbling = true
						self.StumbleType = 2
					else
						self:PlayFlinchSequence( "shovereact", 1, 0, self.Speed - 25, 1.6 )
						self.loco:SetAcceleration(1000)
						self.Stumbling = true
						self.StumbleType = 1
					end
				
				end
			end
			
		end
		
		self.NextFlinch = CurTime() + 3	
	end	
	
end

function ENT:FootSteps()
	self:EmitSound("npc/metropolice/gear"..math.random(6)..".wav", 65)
end

function ENT:AlertSound()
end

function ENT:AlertSound()

end

function ENT:PainSound()
	if math.random(1,3) == 1 then
	
	end
end

function ENT:DeathSound()

end

function ENT:AttackSound()

end

function ENT:IdleSound()

end

function ENT:CustomDoorAttack( ent )

	if ( self.NextDoorAttackTimer or 0 ) < CurTime() then
	
		if !self:CheckStatus() then return end
	
		self:AttackSound()
	
		self:Melee( ent, 2 )
		
		self.NextDoorAttackTimer = CurTime() + self.NextAttack
	end
	
end
	
function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then

		if !self:CheckStatus() then return end
	
		self:AttackSound()
	
		self:Melee( ent, 1 )
	
		self.NextPropAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:AttackEffect( time, ent, dmg, type )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		if !self:CheckStatus() then return end
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage( self.Damage, self )
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound( self.HitSound )
			end
			
			if ent:IsPlayer() then
				ent:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
			end
			
			if type == 1 then
				local phys = ent:GetPhysicsObject()
				if (phys != nil && phys != NULL && phys:IsValid() ) then
					phys:ApplyForceCenter(self:GetForward():GetNormalized()*(self.PhysForce) + Vector(0, 0, 2))
					ent:EmitSound(self.DoorBreak)
				end
			elseif type == 2 then
				if ent != NULL and ent.Hitsleft != nil then
					if ent.Hitsleft > 0 then
						ent.Hitsleft = ent.Hitsleft - self.HitPerDoor	
						ent:EmitSound(self.DoorBreak)
					end
				end
			end
							
		else	
			self:EmitSound( self.Miss )
		end
		
	end)

end

function ENT:Melee( ent, type )

	local attack = math.random(1,3)
	if attack == 1 then
		self:AttackEffect( 0.8, ent, self.Damage, type )
		self:PlaySequenceAndWait( self.AttackAnim1, 1 )
	elseif attack == 2 then
		self:AttackEffect( 0.7, ent, self.Damage - 10, type )
		self:AttackEffect( 1.2, ent, self.Damage - 10, type )
		self:PlaySequenceAndWait( self.AttackAnim2, 1 )
	elseif attack == 3 then
		self:AttackEffect( 0.8, ent, self.Damage - 10, type )
		self:AttackEffect( 1.6, ent, self.Damage - 10, type )
		self:PlaySequenceAndWait( self.AttackAnim3, 1 )
	end
	
	self.IsAttacking = false
	self:ResumeMovementFunctions()
	
end

function ENT:Attack()
		
	if ( self.NextAttackTimer or 0 ) < CurTime() then	
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
			if !self:CheckStatus() then return end
			
			self:AttackSound()
			self.IsAttacking = true
	
			self:Melee( self.Enemy, 0 )
			
		end
		
		self.NextAttackTimer = CurTime() + self.NextAttack
	end	
	
end

function ENT:CustomThink()
	
	local enemy = self:GetEnemy()
		
	if enemy and enemy:IsValid() and enemy:Health() > 0 then
		if self.IsAttacking then
			if (GetConVarNumber("nb_stop") == 0) then
				self.loco:FaceTowards( self.Enemy:GetPos() )
			end
		end
	else
		self.IsAttacking = false
	end
	
end