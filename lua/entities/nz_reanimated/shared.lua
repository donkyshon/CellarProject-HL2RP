if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_reanimated", {
	Name = "Re-Animated",
	Class = "nz_reanimated",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.MoveType = 2

ENT.CollisionHeight = 68
ENT.CollisionSide = 7

ENT.Speed = 50
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 20

ENT.health = 140
ENT.Damage = 15

ENT.PhysForce = 10000
ENT.HitPerDoor = 2

ENT.AttackRange = 50
ENT.InitialAttackRange = 55
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.3

--Model Settings--
ENT.Model = "models/zombie/reanimated.mdl"

ENT.SleepAnim = "slump_a"
ENT.RiseAnim = "slumprise_a"

ENT.SleepAnim1 = "slump_a"
ENT.SleepAnim2 = "slump_b"

ENT.RiseAnim1 = "slumprise_a2"
ENT.RiseAnim2 = "slumprise_a"
ENT.RiseAnim3 = "slumprise_b"

ENT.TantrumAnim = "tantrum"

ENT.AttackPropAnim = "breakthrough"

ENT.AttackAnim1 = "swatleftlow"
ENT.AttackAnim2 = "swatleftmid"
ENT.AttackAnim3 = "swatrightlow"
ENT.AttackAnim4 = "swatrightmid"

ENT.WalkAnim = "walk"
ENT.WalkAnim1 = "walk"
ENT.WalkAnim2 = "walk2"
ENT.WalkAnim3 = "walk3"
ENT.WalkAnim4 = "walk4"

ENT.ChestFlinch1 = "physflinch1"
ENT.ChestFlinch2 = "physflinch2"
ENT.ChestFlinch3 = "physflinch3"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

--Sounds--
ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Death1 = Sound("npc/zombie/zombie_die1.wav")
ENT.Death2 = Sound("npc/zombie/zombie_die2.wav")
ENT.Death3 = Sound("npc/zombie/zombie_die3.wav")

ENT.Pain1 = Sound("npc/zombie/zombie_pain1.wav")
ENT.Pain2 = Sound("npc/zombie/zombie_pain2.wav")
ENT.Pain3 = Sound("npc/zombie/zombie_pain3.wav")
ENT.Pain4 = Sound("npc/zombie/zombie_pain4.wav")
ENT.Pain5 = Sound("npc/zombie/zombie_pain5.wav")

ENT.HitSound = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()

--Models--
util.PrecacheModel(self.Model)
	
--Sounds--	

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)
	
util.PrecacheSound(self.Pain1)
util.PrecacheSound(self.Pain2)
util.PrecacheSound(self.Pain3)
util.PrecacheSound(self.Pain4)	
util.PrecacheSound(self.Pain5)
	
util.PrecacheSound(self.HitSound)
util.PrecacheSound(self.Miss)

end

function ENT:Initialize()

	if SERVER then

	--Stats--
	self:SetModel(self.Model)
	self:SetHealth(self.health)	
	
	local anim = math.random(1,4)
	if anim == 1 then
		self.WalkAnim = self.WalkAnim1
	elseif anim == 2 then
		self.WalkAnim = self.WalkAnim2
	elseif anim == 3 then
		self.WalkAnim = self.WalkAnim3
	elseif anim == 4 then
		self.WalkAnim = self.WalkAnim4
	end
	
	local sleepanim = math.random(1,3)
	if sleepanim == 1 then
		self.SetSleepAnim = self.SleepAnim
		self.SetRiseAnim = self.RiseAnim
	elseif sleepanim == 2 then
		self.SetSleepAnim = self.SleepAnim2
		self.SetRiseAnim = self.RiseAnim3
	elseif sleepanim == 3 then
		self.SetSleepAnim = self.SleepAnim
		self.SetRiseAnim = self.RiseAnim1
	end
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	self.Entrance = true
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(200)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:Precache()
	self:CreateBullseye()
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
	end
	
end

function ENT:CheckStatus( attacking )

	if self.Flinching then
		return false
	end
	
	if self.Entrance then
		return false
	end
	
	if attacking != 1 then
		if self.IsAttacking then
			return false
		end
	end
	
	return true

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
			self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,55) )	
		end

	end
	
	self:MorphRagdoll( dmginfo )
	
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
				dmginfo:ScaleDamage(9)
				else
				dmginfo:ScaleDamage(8)
				end
			else
				if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(7)
				else
				dmginfo:ScaleDamage(6)
				end
			end
			self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
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
		self:ResumeMovementFunctions()
		self.Flinching = false
	end)
end

function ENT:Flinch( dmginfo, hitgroup )
	
	if ( self.NextFlinch or 0 ) < CurTime() then
	
		if !self:CheckValid( self ) then return end
		if !self:CheckStatus( 1 ) then return end
	
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
			if math.random(1,3) == 1 then
				self:PlayFlinchSequence( self.ChestFlinch1, 1, 0, 0, 0.5 )
			elseif math.random(1,3) == 2 then
				self:PlayFlinchSequence( self.ChestFlinch2, 1, 0, 0, 0.6 )
			elseif math.random(1,3) == 3 then
				self:PlayFlinchSequence( self.ChestFlinch3, 1, 0, 0, 0.6 )
			end
		end
		
		self.NextFlinch = CurTime() + 2	
	end	
		
end

function ENT:FootSteps()
	self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
end

function ENT:AlertSound()
end

function ENT:PainSound()
	if math.random(1,3) == 1 then
		local sounds = {}
		sounds[1] = (self.Pain1)
		sounds[2] = (self.Pain2)
		sounds[3] = (self.Pain3)
		sounds[4] = (self.Pain4)
		sounds[5] = (self.Pain5)
		self:EmitSound( sounds[math.random(1,5)] )
	end
end

function ENT:DeathSound()
	if !self.FakeDeath then
		local sounds = {}
		sounds[1] = (self.Death1)
		sounds[2] = (self.Death2)
		sounds[3] = (self.Death3)
		self:EmitSound( sounds[math.random(1,3)] )
	end
end

function ENT:AttackSound()
end

function ENT:IdleSound()
end

function ENT:IdleFunction()

	if self.Entrance then
		self:PlaySequenceAndWait( self.SetSleepAnim, 1 )
	else
	
		if math.random(1,5) == 1 then
			self:ResetSequence( self.TantrumAnim )
		else
			self:StartActivity( ACT_IDLE )
		end
				
	end

end

function ENT:RunBehaviour()

	while ( true ) do
	if self:HaveEnemy() then
	
		if self.Entrance then 
			self:PlaySequenceAndWait( self.SetRiseAnim, 1 )
			self.Entrance = false
		end
	
		local enemy = self:GetEnemy()
	
		pos = enemy:GetPos()
		
		if ( pos ) then
			
			if enemy:Health() > 0 and enemy:IsValid() then
			
				self.HasNoEnemy = false
			
				if self:CheckStatus() then
					self:MovementFunctions( self.MoveType, self.WalkAnim, self.Speed, self.WalkSpeedAnimation )
				end
			
				local opts = {	lookahead = 300,
					tolerance = 20,
					draw = false,
					maxage = 1,
					repath = 1	}
				self:ChaseEnemy( pos, opts )		
				
			end
			
		end
		
	else
	
		self.HasNoEnemy = true
		
		self:IdleFunction()
		
	end
		coroutine.yield()
	end
end

function ENT:CustomDoorAttack( ent )

	if ( self.NextDoorAttackTimer or 0 ) < CurTime() then

		self:AttackSound()
	
		self:BreakThrough( ent, self.Damage + 10, self.Speed - 20, 2 )
	
		self.NextDoorAttackTimer = CurTime() + self.NextAttack + 0.5
	end
	
end
	
function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then
	
		self:AttackSound()
	
		self:BreakThrough( ent, self.Damage + 10, self.Speed - 20, 1 )
	
		self.NextPropAttackTimer = CurTime() + self.NextAttack + 0.5
	end
	
end

function ENT:BreakThrough( ent, dmg, speed, type )
	self.loco:SetDesiredSpeed( speed )
	
	self:AttackEffect( 0.5, ent, dmg, type, 0 )
	self:AttackEffect( 1.2, ent, dmg, type, 0 )
	
	self:ResetSequence( self.AttackPropAnim )
	self:SetCycle( 0 )
	self:SetPlaybackRate( 1 )
	
	timer.Simple( 1.7, function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckStatus( 1 ) then return end
		self:ResumeMovementFunctions()
	end)
end

function ENT:AttackEffect( time, ent, dmg, type, reset )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		if !self:CheckStatus( 1 ) then return end
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage(dmg, self)	
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound(self.HitSound)
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
		self:EmitSound(self.Miss)
		end
		
	end)
		
	if reset == 1 then
		timer.Simple( time + 0.6, function()
			if !self:IsValid() then return end
			if self:Health() < 0 then return end
			if !self:CheckStatus( 1 ) then return end
			self.IsAttacking = false
			self:ResumeMovementFunctions()
		end)
	end

end

function ENT:Melee()
	local attack = math.random(1,4)
	if attack == 1 then
		self:AttackEffect( 0.7, self.Enemy, self.Damage + 10, 0, 1 )
		self:PlaySequenceAndWait( self.AttackAnim1, 1 )
	elseif attack == 2 then
		self:AttackEffect( 0.5, self.Enemy, self.Damage, 0, 1 )
		self:PlaySequenceAndWait( self.AttackAnim2, 1 )
	elseif attack == 3 then
		self:AttackEffect( 0.7, self.Enemy, self.Damage + 10, 0, 1 )
		self:PlaySequenceAndWait( self.AttackAnim3, 1 )
	elseif attack == 4 then
		self:AttackEffect( 0.5, self.Enemy, self.Damage, 0, 1 )
		self:PlaySequenceAndWait( self.AttackAnim4, 1 )
	end	
end

function ENT:Attack()

	if ( self.NextAttackTimer or 0 ) < CurTime() then	
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
			if !self:CheckStatus( 1 ) then return end
		
			self:AttackSound()
			self.IsAttacking = true
		
			self:Melee()
		
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