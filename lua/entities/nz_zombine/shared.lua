if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_zombine", {
	Name = "Zombine",
	Class = "nz_zombine",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.MoveType = 2

ENT.CollisionHeight = 64
ENT.CollisionSide = 9

ENT.Speed = 60
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 20

ENT.health = 350
ENT.Damage = 20
ENT.HitPerDoor = 2

ENT.PhysForce = 10000
ENT.HitPerDoor = 2

ENT.AttackRange = 50
ENT.InitialAttackRange = 55
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.7

--Model Settings--
ENT.Model = "models/zombie/zombineplayer.mdl"

ENT.EnrageAnim = "menu_zombie_01"

ENT.TantrumAnim = "tantrum"
ENT.IdleAnim = ACT_HL2MP_IDLE_ZOMBIE

ENT.AttackPropAnim = "breakthrough"

ENT.GrabAnim = "alyx_zombie_grab"
ENT.GrabFailAnim = "alyx_zombie_grab_exit"
ENT.HoldAnim = "alyx_zombie_grab_pi"

ENT.AttackAnim = "fastattack"

ENT.WalkAnim = "walk"
ENT.WalkAnim1 = "zombie_walk_01"
ENT.WalkAnim2 = "zombie_walk_02"
ENT.WalkAnim3 = "zombie_walk_03"
ENT.WalkAnim4 = "zombie_walk_04"
ENT.WalkAnim5 = "zombie_walk_05"
ENT.WalkAnim6 = "walk_all"

ENT.RageWalkAnim = "run_all"

ENT.ChestFlinch1 = "physflinch1"
ENT.ChestFlinch2 = "physflinch2"
ENT.ChestFlinch3 = "physflinch3"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

--Sounds--
ENT.Attack1 = Sound("npc/zombine/attack1.wav")
ENT.Attack2 = Sound("npc/zombine/attack2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Enrage1 = Sound("npc/zombine/enrage1.wav")
ENT.Enrage2 = Sound("npc/zombine/enrage2.wav")

ENT.Death1 = Sound("npc/zombine/death1.wav")
ENT.Death2 = Sound("npc/zombine/death2.wav")
ENT.Death3 = Sound("npc/zombine/death3.wav")

ENT.Idle1 = Sound("npc/zombine/idle1.wav")
ENT.Idle2 = Sound("npc/zombine/idle2.wav")
ENT.Idle3 = Sound("npc/zombine/idle3.wav")
ENT.Idle4 = Sound("npc/zombine/idle4.wav")

ENT.Pain1 = Sound("npc/zombine/pain1.wav")
ENT.Pain2 = Sound("npc/zombine/pain2.wav")
ENT.Pain3 = Sound("npc/zombine/pain3.wav")

ENT.HitSound = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()

--Models--
util.PrecacheModel(self.Model)
	
--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Enrage1)
util.PrecacheSound(self.Enrage2)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)

util.PrecacheSound(self.Idle1)
util.PrecacheSound(self.Idle2)
util.PrecacheSound(self.Idle3)
util.PrecacheSound(self.Idle4)
	
util.PrecacheSound(self.Pain1)
util.PrecacheSound(self.Pain2)
util.PrecacheSound(self.Pain3)
	
util.PrecacheSound(self.HitSound)
util.PrecacheSound(self.Miss)

end

function ENT:Initialize()

	if SERVER then

	--Stats--
	self:SetModel(self.Model)
	self:SetHealth(self.health)	
	
	local anim = math.random(1,6)
	if anim == 1 then
		self.WalkAnim = self.WalkAnim1
	elseif anim == 2 then
		self.WalkAnim = self.WalkAnim2
	elseif anim == 3 then
		self.WalkAnim = self.WalkAnim3
	elseif anim == 4 then
		self.WalkAnim = self.WalkAnim4
	elseif anim == 5 then
		self.WalkAnim = self.WalkAnim5
	elseif anim == 6 then
		self.WalkAnim = self.WalkAnim6
	end
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	
	self.Enrage = false
	self.EnrageAnimation = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(400)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:Precache()
	self:CreateBullseye()
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
	end
	
end

function ENT:IdleFunction()

	if math.random(1,10) == 1 then
		self:PlaySequenceAndWait( self.TantrumAnim, 1 )
	else
		self:StartActivity( self.IdleAnim )
	end
	
end

function ENT:CustomDeath( dmginfo )

	if dmginfo:IsExplosionDamage() then
		self:MorphRagdoll( dmginfo )
	else
		if self.Flinching then
			self:MorphRagdoll( dmginfo )
		else
			self:DeathAnimation( "nz_deathanim_base", self:GetPos(), ACT_HL2MP_RUN_ZOMBIE, 1 )
		end
	end

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
	
		if attacker:IsNPC() then
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(0.70)
			else
				dmginfo:ScaleDamage(0.60)
			end
		else
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(0.60)
			else
				dmginfo:ScaleDamage(0.50)
			end
		end
		
		if self.Enrage then
			if dmginfo:GetDamage() > 24 then
				self:Flinch( dmginfo, hitgroup )
			end
		else
			if dmginfo:GetDamage() > 18 then
				self:Flinch( dmginfo, hitgroup )
			end
		end
		
		self:EmitSound("kevlar/kevlar_hit"..math.random(2)..".wav", 65)
		
	end
	
	if !dmginfo:IsExplosionDamage() then
		if self:Health() < 200 then
			if self.Enrage then return end
			if !self:CheckStatus() then return end
			self:SetEnrage()
		end
	end
	
end

function ENT:CheckStatus( attacking )

	if self.Flinching then
		return false
	end
	
	if self.EnrageAnimation then
		return false
	end
	
	if attacking != 1 then
		if self.IsAttacking then
			return false
		end
	end
	
	return true

end

function ENT:SetEnrage()

	self.Enrage = true
	self.EnrageAnimation = true
		
	self:ResetSequence( self.EnrageAnim )
	self:SetCycle( 0 )
	self:SetPlaybackRate( 1 )
	self.loco:SetDesiredSpeed( 0 )
	
	self.Speed = 180
	self.Damage = self.Damage + 5
	self.WalkAnim = self.RageWalkAnim
	self.NextAttack = 0.7
	self.AttackRange = self.AttackRange + 5
	
	self.loco:SetAcceleration(500)
	self.loco:SetDeceleration(500)
	
	self:EnrageSound()
	
	timer.Simple( 1.7, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		self.EnrageAnimation = false
		self:ResumeMovementFunctions()
	end)
	
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
		if self.Enrage then self.Flinching = false return end
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
	self:EmitSound("npc/combine_soldier/gear"..math.random(6)..".wav", 65)
end

function ENT:AlertSound()
end

function ENT:PainSound()
	if math.random(1,10) == 1 then
		local sounds = {}
		sounds[1] = (self.Pain1)
		sounds[2] = (self.Pain2)
		sounds[3] = (self.Pain3)
		self:EmitSound( sounds[math.random(1,3)] )
	end
end

function ENT:DeathSound()
	local sounds = {}
		sounds[1] = (self.Death1)
		sounds[2] = (self.Death2)
		sounds[3] = (self.Death3)
		self:EmitSound( sounds[math.random(1,3)] )
end

function ENT:AttackSound()
	local sounds = {}
		sounds[1] = (self.Attack1)
		sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:EnrageSound()
	local sounds = {}
		sounds[1] = (self.Enrage1)
		sounds[2] = (self.Enrage2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:IdleSound()
	local sounds = {}
		sounds[1] = (self.Idle1)
		sounds[2] = (self.Idle2)
		sounds[3] = (self.Idle3)
		sounds[4] = (self.Idle4)
		self:EmitSound( sounds[math.random(1,4)] )
end	

function ENT:CustomDoorAttack( ent )

	if ( self.NextDoorAttackTimer or 0 ) < CurTime() then

		if !self:CheckStatus( 1 ) then return end
		
			self:AttackSound()
			self.IsAttacking = true
		
			if self.Enrage then
				self:MeleeEnrage(2)
			else
				self:BreakThrough( ent, self.Damage, self.Speed / 3, 2, 0 )
			end
		
		self.NextDoorAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then

		if !self:CheckStatus( 1 ) then return end
		
			self:AttackSound()
			self.IsAttacking = true
		
			if self.Enrage then
				self:MeleeEnrage(1)
			else
				self:BreakThrough( ent, self.Damage, self.Speed / 3, 1, 0 )
			end
		
		self.NextPropAttackTimer = CurTime() + self.NextAttack
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
		
		self.IsAttacking = false
		
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

function ENT:MeleeEnrage( type )
	self.loco:SetDesiredSpeed( 0 )
	
	self:AttackEffect( 0.4, self.Enemy, self.Damage, 0, type, 1 )
	self:PlaySequenceAndWait( self.AttackAnim, 1 )
end

function ENT:CustomThink()
	if !self.Enrage then return end
	
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

function ENT:Attack()

	if ( self.NextAttackTimer or 0 ) < CurTime() then	
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
			if !self:CheckStatus( 1 ) then return end
		
			self:AttackSound()
			self.IsAttacking = true
		
			if self.Enrage then
				self:MeleeEnrage(0)
			else
				self:BreakThrough( self.Enemy, self.Damage, self.Speed / 3, 0, 0 )
			end
		end
		
		self.NextAttackTimer = CurTime() + self.NextAttack
	end
	
end
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_zombine", {
	Name = "Zombine",
	Class = "nz_zombine",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.MoveType = 2

ENT.CollisionHeight = 64
ENT.CollisionSide = 9

ENT.Speed = 60
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 20

ENT.health = 350
ENT.Damage = 20
ENT.HitPerDoor = 2

ENT.PhysForce = 10000
ENT.HitPerDoor = 2

ENT.AttackRange = 50
ENT.InitialAttackRange = 55
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.7

--Model Settings--
ENT.Model = "models/zombie/zombineplayer.mdl"

ENT.EnrageAnim = "menu_zombie_01"

ENT.TantrumAnim = "tantrum"
ENT.IdleAnim = ACT_HL2MP_IDLE_ZOMBIE

ENT.AttackPropAnim = "breakthrough"

ENT.GrabAnim = "alyx_zombie_grab"
ENT.GrabFailAnim = "alyx_zombie_grab_exit"
ENT.HoldAnim = "alyx_zombie_grab_pi"

ENT.AttackAnim = "fastattack"

ENT.WalkAnim = "walk"
ENT.WalkAnim1 = "zombie_walk_01"
ENT.WalkAnim2 = "zombie_walk_02"
ENT.WalkAnim3 = "zombie_walk_03"
ENT.WalkAnim4 = "zombie_walk_04"
ENT.WalkAnim5 = "zombie_walk_05"
ENT.WalkAnim6 = "walk_all"

ENT.RageWalkAnim = "run_all"

ENT.ChestFlinch1 = "physflinch1"
ENT.ChestFlinch2 = "physflinch2"
ENT.ChestFlinch3 = "physflinch3"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

--Sounds--
ENT.Attack1 = Sound("npc/zombine/attack1.wav")
ENT.Attack2 = Sound("npc/zombine/attack2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Enrage1 = Sound("npc/zombine/enrage1.wav")
ENT.Enrage2 = Sound("npc/zombine/enrage2.wav")

ENT.Death1 = Sound("npc/zombine/death1.wav")
ENT.Death2 = Sound("npc/zombine/death2.wav")
ENT.Death3 = Sound("npc/zombine/death3.wav")

ENT.Idle1 = Sound("npc/zombine/idle1.wav")
ENT.Idle2 = Sound("npc/zombine/idle2.wav")
ENT.Idle3 = Sound("npc/zombine/idle3.wav")
ENT.Idle4 = Sound("npc/zombine/idle4.wav")

ENT.Pain1 = Sound("npc/zombine/pain1.wav")
ENT.Pain2 = Sound("npc/zombine/pain2.wav")
ENT.Pain3 = Sound("npc/zombine/pain3.wav")

ENT.HitSound = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()

--Models--
util.PrecacheModel(self.Model)
	
--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Enrage1)
util.PrecacheSound(self.Enrage2)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)

util.PrecacheSound(self.Idle1)
util.PrecacheSound(self.Idle2)
util.PrecacheSound(self.Idle3)
util.PrecacheSound(self.Idle4)
	
util.PrecacheSound(self.Pain1)
util.PrecacheSound(self.Pain2)
util.PrecacheSound(self.Pain3)
	
util.PrecacheSound(self.HitSound)
util.PrecacheSound(self.Miss)

end

function ENT:Initialize()

	if SERVER then

	--Stats--
	self:SetModel(self.Model)
	self:SetHealth(self.health)	
	
	local anim = math.random(1,6)
	if anim == 1 then
		self.WalkAnim = self.WalkAnim1
	elseif anim == 2 then
		self.WalkAnim = self.WalkAnim2
	elseif anim == 3 then
		self.WalkAnim = self.WalkAnim3
	elseif anim == 4 then
		self.WalkAnim = self.WalkAnim4
	elseif anim == 5 then
		self.WalkAnim = self.WalkAnim5
	elseif anim == 6 then
		self.WalkAnim = self.WalkAnim6
	end
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	
	self.Enrage = false
	self.EnrageAnimation = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(400)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:Precache()
	self:CreateBullseye()
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
	end
	
end

function ENT:IdleFunction()

	if math.random(1,10) == 1 then
		self:PlaySequenceAndWait( self.TantrumAnim, 1 )
	else
		self:StartActivity( self.IdleAnim )
	end
	
end

function ENT:CustomDeath( dmginfo )

	if dmginfo:IsExplosionDamage() then
		self:MorphRagdoll( dmginfo )
	else
		if self.Flinching then
			self:MorphRagdoll( dmginfo )
		else
			self:DeathAnimation( "nz_deathanim_base", self:GetPos(), ACT_HL2MP_RUN_ZOMBIE, 1 )
		end
	end

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
	
		if attacker:IsNPC() then
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(0.70)
			else
				dmginfo:ScaleDamage(0.60)
			end
		else
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(0.60)
			else
				dmginfo:ScaleDamage(0.50)
			end
		end
		
		if self.Enrage then
			if dmginfo:GetDamage() > 24 then
				self:Flinch( dmginfo, hitgroup )
			end
		else
			if dmginfo:GetDamage() > 18 then
				self:Flinch( dmginfo, hitgroup )
			end
		end
		
		self:EmitSound("kevlar/kevlar_hit"..math.random(2)..".wav", 65)
		
	end
	
	if !dmginfo:IsExplosionDamage() then
		if self:Health() < 200 then
			if self.Enrage then return end
			if !self:CheckStatus() then return end
			self:SetEnrage()
		end
	end
	
end

function ENT:CheckStatus( attacking )

	if self.Flinching then
		return false
	end
	
	if self.EnrageAnimation then
		return false
	end
	
	if attacking != 1 then
		if self.IsAttacking then
			return false
		end
	end
	
	return true

end

function ENT:SetEnrage()

	self.Enrage = true
	self.EnrageAnimation = true
		
	self:ResetSequence( self.EnrageAnim )
	self:SetCycle( 0 )
	self:SetPlaybackRate( 1 )
	self.loco:SetDesiredSpeed( 0 )
	
	self.Speed = 180
	self.Damage = self.Damage + 5
	self.WalkAnim = self.RageWalkAnim
	self.NextAttack = 0.7
	self.AttackRange = self.AttackRange + 5
	
	self.loco:SetAcceleration(500)
	self.loco:SetDeceleration(500)
	
	self:EnrageSound()
	
	timer.Simple( 1.7, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		self.EnrageAnimation = false
		self:ResumeMovementFunctions()
	end)
	
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
		if self.Enrage then self.Flinching = false return end
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
	self:EmitSound("npc/combine_soldier/gear"..math.random(6)..".wav", 65)
end

function ENT:AlertSound()
end

function ENT:PainSound()
	if math.random(1,10) == 1 then
		local sounds = {}
		sounds[1] = (self.Pain1)
		sounds[2] = (self.Pain2)
		sounds[3] = (self.Pain3)
		self:EmitSound( sounds[math.random(1,3)] )
	end
end

function ENT:DeathSound()
	local sounds = {}
		sounds[1] = (self.Death1)
		sounds[2] = (self.Death2)
		sounds[3] = (self.Death3)
		self:EmitSound( sounds[math.random(1,3)] )
end

function ENT:AttackSound()
	local sounds = {}
		sounds[1] = (self.Attack1)
		sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:EnrageSound()
	local sounds = {}
		sounds[1] = (self.Enrage1)
		sounds[2] = (self.Enrage2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:IdleSound()
	local sounds = {}
		sounds[1] = (self.Idle1)
		sounds[2] = (self.Idle2)
		sounds[3] = (self.Idle3)
		sounds[4] = (self.Idle4)
		self:EmitSound( sounds[math.random(1,4)] )
end	

function ENT:CustomDoorAttack( ent )

	if ( self.NextDoorAttackTimer or 0 ) < CurTime() then

		if !self:CheckStatus( 1 ) then return end
		
			self:AttackSound()
			self.IsAttacking = true
		
			if self.Enrage then
				self:MeleeEnrage(2)
			else
				self:BreakThrough( ent, self.Damage, self.Speed / 3, 2, 0 )
			end
		
		self.NextDoorAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then

		if !self:CheckStatus( 1 ) then return end
		
			self:AttackSound()
			self.IsAttacking = true
		
			if self.Enrage then
				self:MeleeEnrage(1)
			else
				self:BreakThrough( ent, self.Damage, self.Speed / 3, 1, 0 )
			end
		
		self.NextPropAttackTimer = CurTime() + self.NextAttack
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
		
		self.IsAttacking = false
		
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

function ENT:MeleeEnrage( type )
	self.loco:SetDesiredSpeed( 0 )
	
	self:AttackEffect( 0.4, self.Enemy, self.Damage, 0, type, 1 )
	self:PlaySequenceAndWait( self.AttackAnim, 1 )
end

function ENT:CustomThink()
	if !self.Enrage then return end
	
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

function ENT:Attack()

	if ( self.NextAttackTimer or 0 ) < CurTime() then	
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
			if !self:CheckStatus( 1 ) then return end
		
			self:AttackSound()
			self.IsAttacking = true
		
			if self.Enrage then
				self:MeleeEnrage(0)
			else
				self:BreakThrough( self.Enemy, self.Damage, self.Speed / 3, 0, 0 )
			end
		end
		
		self.NextAttackTimer = CurTime() + self.NextAttack
	end
	
end