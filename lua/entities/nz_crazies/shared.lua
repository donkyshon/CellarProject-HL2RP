if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_crazies", {
	Name = "Type 1",
	Class = "nz_crazies",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.MoveType = 2

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.Speed = 70
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 0

ENT.health = 100
ENT.Damage = 20

ENT.PhysForce = 15000

ENT.DoorAttackRange = 25
ENT.AttackRange = 53
ENT.InitialAttackRange = 64

ENT.NextAttack = 1.1

--Model Settings--
ENT.Model1 = "models/zombie/infected_01.mdl"
ENT.Model2 = "models/zombie/infected_02.mdl"
ENT.Model3 = "models/zombie/infected_03.mdl"
ENT.Model4 = "models/zombie/infected_04.mdl"
ENT.Model5 = "models/zombie/infected_05.mdl"
ENT.Model6 = "models/zombie/infected_06.mdl"
ENT.Model7 = "models/zombie/infected_07.mdl"
ENT.Model8 = "models/zombie/infected_08.mdl"
ENT.Model9 = "models/zombie/infected_09.mdl"
ENT.Model10 = "models/zombie/infected_10.mdl"
ENT.Model11 = "models/zombie/infected_11.mdl"
ENT.Model12 = "models/zombie/infected_12.mdl"

ENT.WalkAnim = "walk_melee"
ENT.IdleAnim = "idle"

ENT.Status1WalkAnim = "walk_melee"

ENT.Status2RunAnim = "run_all"

ENT.Status3RunAnim = "zombie_run"

ENT.Status1Attack1 = "weapon_attack1"
ENT.Status1Attack2 = "weapon_attack2"
ENT.FastAttack = "fastattack"
ENT.BreakThroughAnim = "breakthrough"

ENT.TransformAnim1 = "releasecrab"

ENT.ChestFlinch1 = "physflinch1"
ENT.ChestFlinch2 = "physflinch2"
ENT.ChestFlinch3 = "physflinch3"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

--Sounds--
ENT.Attack1 = Sound("npc/infected_zombies/rage_at_victim20.wav")
ENT.Attack2 = Sound("npc/infected_zombies/rage_at_victim21.wav")
ENT.Attack3 = Sound("npc/infected_zombies/rage_at_victim22.wav")
ENT.Attack4 = Sound("npc/infected_zombies/rage_at_victim23.wav")
ENT.Attack5 = Sound("npc/infected_zombies/rage_at_victim24.wav")
ENT.Attack6 = Sound("npc/infected_zombies/rage_at_victim25.wav")
ENT.Attack7 = Sound("npc/infected_zombies/rage_at_victim26.wav")
ENT.Attack8 = Sound("npc/infected_zombies/rage_at_victim27.wav")
ENT.Attack9 = Sound("npc/infected_zombies/rage_at_victim28.wav")
ENT.Attack10 = Sound("npc/infected_zombies/rage_at_victim29.wav")
ENT.Attack11 = Sound("npc/infected_zombies/rage_at_victim30.wav")
ENT.Attack12 = Sound("npc/infected_zombies/rage_at_victim31.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Death1 = Sound("npc/infected_zombies/death_17.wav")
ENT.Death2 = Sound("npc/infected_zombies/death_18.wav")
ENT.Death3 = Sound("npc/infected_zombies/death_19.wav")
ENT.Death4 = Sound("npc/infected_zombies/death_20.wav")
ENT.Death5 = Sound("npc/infected_zombies/death_21.wav")
ENT.Death6 = Sound("npc/infected_zombies/death_22.wav")
ENT.Death7 = Sound("npc/infected_zombies/death_23.wav")
ENT.Death8 = Sound("npc/infected_zombies/death_24.wav")
ENT.Death9 = Sound("npc/infected_zombies/death_25.wav")
ENT.Death10 = Sound("npc/infected_zombies/death_26.wav")
ENT.Death11 = Sound("npc/infected_zombies/death_27.wav")
ENT.Death12 = Sound("npc/infected_zombies/death_28.wav")
ENT.Death13 = Sound("npc/infected_zombies/death_29.wav")
ENT.Death14 = Sound("npc/infected_zombies/death_30.wav")
ENT.Death15 = Sound("npc/infected_zombies/death_31.wav")
ENT.Death16 = Sound("npc/infected_zombies/death_32.wav")
ENT.Death17 = Sound("npc/infected_zombies/death_33.wav")
ENT.Death18 = Sound("npc/infected_zombies/death_34.wav")
ENT.Death19 = Sound("npc/infected_zombies/death_35.wav")

ENT.Alert1 = Sound("npc/infected_zombies/rage_at_victim32.wav")
ENT.Alert2 = Sound("npc/infected_zombies/rage_at_victim32.wav")
ENT.Alert3 = Sound("npc/infected_zombies/rage_at_victim33.wav")
ENT.Alert4 = Sound("npc/infected_zombies/rage_at_victim34.wav")
ENT.Alert5 = Sound("npc/infected_zombies/rage_at_victim35.wav")
ENT.Alert6 = Sound("npc/infected_zombies/rage_at_victim36.wav")
ENT.Alert7 = Sound("npc/infected_zombies/rage_at_victim37.wav")

ENT.Idle1 = Sound("npc/infected_zombies/been_shot_1.wav")
ENT.Idle2 = Sound("npc/infected_zombies/been_shot_2.wav")
ENT.Idle3 = Sound("npc/infected_zombies/been_shot_3.wav")
ENT.Idle4 = Sound("npc/infected_zombies/been_shot_4.wav")
ENT.Idle5 = Sound("npc/infected_zombies/been_shot_5.wav")
ENT.Idle6 = Sound("npc/infected_zombies/been_shot_6.wav")
ENT.Idle7 = Sound("npc/infected_zombies/been_shot_7.wav")
ENT.Idle8 = Sound("npc/infected_zombies/been_shot_8.wav")
ENT.Idle9 = Sound("npc/infected_zombies/been_shot_9.wav")
ENT.Idle10 = Sound("npc/infected_zombies/been_shot_10.wav")
ENT.Idle11 = Sound("npc/infected_zombies/been_shot_11.wav")
ENT.Idle12 = Sound("npc/infected_zombies/been_shot_12.wav")
ENT.Idle13 = Sound("npc/infected_zombies/been_shot_13.wav")
ENT.Idle14 = Sound("npc/infected_zombies/been_shot_14.wav")
ENT.Idle15 = Sound("npc/infected_zombies/been_shot_15.wav")
ENT.Idle16 = Sound("npc/infected_zombies/been_shot_16.wav")

ENT.Pain1 = Sound("npc/infected_zombies/pain1.wav")
ENT.Pain2 = Sound("npc/infected_zombies/pain2.wav")
ENT.Pain3 = Sound("npc/infected_zombies/pain3.wav")
ENT.Pain4 = Sound("npc/infected_zombies/pain4.wav")
ENT.Pain5 = Sound("npc/infected_zombies/pain5.wav")
ENT.Pain6 = Sound("npc/infected_zombies/pain6.wav")
ENT.Pain7 = Sound("npc/infected_zombies/pain7.wav")
ENT.Pain8 = Sound("npc/infected_zombies/pain8.wav")
ENT.Pain9 = Sound("npc/infected_zombies/pain9.wav")

ENT.Hit1 = Sound("npc/infected_zombies/hit_punch_01.wav")
ENT.Hit2 = Sound("npc/infected_zombies/hit_punch_02.wav")
ENT.Hit3 = Sound("npc/infected_zombies/hit_punch_03.wav")
ENT.Hit4 = Sound("npc/infected_zombies/hit_punch_04.wav")
ENT.Hit5 = Sound("npc/infected_zombies/hit_punch_05.wav")
ENT.Hit6 = Sound("npc/infected_zombies/hit_punch_06.wav")
ENT.Hit7 = Sound("npc/infected_zombies/hit_punch_07.wav")
ENT.Hit8 = Sound("npc/infected_zombies/hit_punch_08.wav")

ENT.Miss1 = Sound("npc/infected_zombies/claw_miss_1.wav")
ENT.Miss2 = Sound("npc/infected_zombies/claw_miss_2.wav")

function ENT:Precache()
--Models--
util.PrecacheModel(self.Model1)
util.PrecacheModel(self.Model2)
util.PrecacheModel(self.Model3)
util.PrecacheModel(self.Model4)
util.PrecacheModel(self.Model5)
util.PrecacheModel(self.Model6)
util.PrecacheModel(self.Model7)
util.PrecacheModel(self.Model8)
util.PrecacheModel(self.Model9)
util.PrecacheModel(self.Model10)
util.PrecacheModel(self.Model11)
util.PrecacheModel(self.Model12)

--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)
util.PrecacheSound(self.Attack3)
util.PrecacheSound(self.Attack4)
util.PrecacheSound(self.Attack5)
util.PrecacheSound(self.Attack6)
util.PrecacheSound(self.Attack7)
util.PrecacheSound(self.Attack8)
util.PrecacheSound(self.Attack9)
util.PrecacheSound(self.Attack10)
util.PrecacheSound(self.Attack11)
util.PrecacheSound(self.Attack12)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)
util.PrecacheSound(self.Death4)
util.PrecacheSound(self.Death5)
util.PrecacheSound(self.Death6)
util.PrecacheSound(self.Death7)
util.PrecacheSound(self.Death8)
util.PrecacheSound(self.Death9)
util.PrecacheSound(self.Death10)
util.PrecacheSound(self.Death11)
util.PrecacheSound(self.Death12)
util.PrecacheSound(self.Death13)
util.PrecacheSound(self.Death14)
util.PrecacheSound(self.Death15)
util.PrecacheSound(self.Death16)
util.PrecacheSound(self.Death17)
util.PrecacheSound(self.Death18)
util.PrecacheSound(self.Death19)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)
util.PrecacheSound(self.Alert3)
util.PrecacheSound(self.Alert4)
util.PrecacheSound(self.Alert5)
util.PrecacheSound(self.Alert6)
util.PrecacheSound(self.Alert7)

util.PrecacheSound(self.Idle1)
util.PrecacheSound(self.Idle2)
util.PrecacheSound(self.Idle3)
util.PrecacheSound(self.Idle4)
util.PrecacheSound(self.Idle5)
util.PrecacheSound(self.Idle6)
util.PrecacheSound(self.Idle7)
util.PrecacheSound(self.Idle8)
util.PrecacheSound(self.Idle9)
util.PrecacheSound(self.Idle10)	
util.PrecacheSound(self.Idle11)
util.PrecacheSound(self.Idle12)	
	
util.PrecacheSound(self.Pain1)
util.PrecacheSound(self.Pain2)
util.PrecacheSound(self.Pain3)
util.PrecacheSound(self.Pain4)
util.PrecacheSound(self.Pain5)
util.PrecacheSound(self.Pain6)
util.PrecacheSound(self.Pain7)
util.PrecacheSound(self.Pain8)
util.PrecacheSound(self.Pain9)
	
util.PrecacheSound(self.Hit1)
util.PrecacheSound(self.Hit2)
util.PrecacheSound(self.Hit3)
util.PrecacheSound(self.Hit4)
util.PrecacheSound(self.Hit5)
util.PrecacheSound(self.Hit6)
util.PrecacheSound(self.Hit7)
util.PrecacheSound(self.Hit8)

util.PrecacheSound(self.Miss1)
util.PrecacheSound(self.Miss2)
end

function ENT:Initialize()

	if SERVER then

	--Stats--
	local model = math.random(1,12)
	if model == 1 then self:SetModel(self.Model1)
	elseif model == 2 then self:SetModel(self.Model2)
	elseif model == 3 then self:SetModel(self.Model3)
	elseif model == 4 then self:SetModel(self.Model4)
	elseif model == 5 then self:SetModel(self.Model5)
	elseif model == 6 then self:SetModel(self.Model6)
	elseif model == 7 then self:SetModel(self.Model7)
	elseif model == 8 then self:SetModel(self.Model8)
	elseif model == 9 then self:SetModel(self.Model9)
	elseif model == 10 then self:SetModel(self.Model10)
	elseif model == 11 then self:SetModel(self.Model11)
	elseif model == 12 then self:SetModel(self.Model12)
	end
	
	self:SetHealth(self.health)	
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	self.IsMutating = false
	
	self.Status = math.random(1,3)
	self:Mutate( 0 )
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(300)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:Precache()
	self:CreateBullseye()
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
	end
	
end

function ENT:IdleFunction()

	if !self:CheckStatus( 1 ) then return end

	if math.random(1,100) == 1 then
		self:Mutate( 1 )
	else
		self:ResetSequence( self.IdleAnim )
	end
	
end

function ENT:PlayMutateSequence( string, rate, cycle, speed, time )
	self.IsMutating = true
	
	self:ResetSequence( string )
	self:SetCycle( cycle )
	self:SetPlaybackRate( rate )
	self.loco:SetDesiredSpeed( speed )
	
	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		self.IsMutating = false
		
		if self.HasNoEnemy then
			self:ResetSequence( self.IdleAnim )	
		else
			self:ResumeMovementFunctions()
		end
		
	end)
end

function ENT:StatsChange( health, speed, damage, walkanim, walkspeedanimation )

	if self:Health() < 230 then
		self:SetHealth( self:Health() + ( 15 + health ) )
	end
	
	self.Speed = speed
	self.Damage = damage
	self.WalkAnim = walkanim
	self.WalkSpeedAnimation = walkspeedanimation
	
	if self.Status == 3 then
		self.NextAttack = 2
	else
		self.NextAttack = 1.2
	end
	
	self:ResumeMovementFunctions()
	
end

function ENT:Mutate( playsequence )

	if self.Status == 1 then
	
		self:StatsChange( 25, 60, 30, self.Status1WalkAnim, 1 )
		
	elseif self.Status == 2 then
		
		local anim = math.random(1,2)
		if anim == 1 then
			self:StatsChange( 0, 170, 20, self.Status2RunAnim, 0.9 )
		elseif anim == 2 then
			self:StatsChange( 0, 170, 20, self.Status3RunAnim, 0.8 )
		end
		
	elseif self.Status == 3 then
		
		self:StatsChange( 10, 125, 25, self.Status1WalkAnim, 2 )
		
	end
	
	if playsequence == 1 then
		self:EmitSound("player/pl_pain"..math.random(5,7)..".wav", 100)
		self:PlayMutateSequence( self.TransformAnim1, 1, 0, 0, 1.1 )
	end
		
end

function ENT:PlayRandomMutate( chance )

	if math.random(1,chance) == 1 then
		
		if self:GetRangeTo( self.Enemy ) > self.InitialAttackRange then
		
			if self.IsAttacking then return end
			if self.IsFlinching then return end
			
			self.Status = math.random(1,3)
			self:Mutate( 1 )
			
		end
		
	else
	
		self:ResumeMovementFunctions()
	
	end
	
end

function ENT:CheckStatus( attacking )

	if self.Flinching then
		return false
	end
	
	if self.IsMutating then
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
			self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
			self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,55) )	
		end
	
	end

	if dmginfo:IsExplosionDamage() then
		self:MorphRagdoll( dmginfo )
	else
		if self.Flinching or self.IsMutating then
			self:MorphRagdoll( dmginfo )
		else
			self:DeathAnimation( "nz_deathanim_base", self:GetPos(), ACT_HL2MP_WALK_ZOMBIE_01, 1 )
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
			
		if hitgroup == HITGROUP_HEAD then
			self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
		end
			
		if self.IsMutating then 
			dmginfo:ScaleDamage( 0.60 )
		else
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
			else
				if attacker:IsNPC() then
					dmginfo:ScaleDamage(0.90)
				else
					dmginfo:ScaleDamage(0.80)
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
		self:PlayRandomMutate( 5 )
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
	local alertsounds = {}
	alertsounds[1] = (self.Alert1)
	alertsounds[2] = (self.Alert2)
	alertsounds[3] = (self.Alert3)
	alertsounds[4] = (self.Alert4)
	alertsounds[5] = (self.Alert5)
	alertsounds[6] = (self.Alert6)
	alertsounds[7] = (self.Alert7)
	self:EmitSound( alertsounds[math.random(1,7)], math.random(80,95), math.random(70, 105) )
end

function ENT:PainSound()
	if math.random(1,3) == 1 then
		local painsounds = {}
		painsounds[1] = (self.Pain1)
		painsounds[2] = (self.Pain2)
		painsounds[3] = (self.Pain3)
		painsounds[4] = (self.Pain4)
		painsounds[5] = (self.Pain5)
		painsounds[6] = (self.Pain6)
		painsounds[7] = (self.Pain7)
		painsounds[8] = (self.Pain8)
		painsounds[9] = (self.Pain9)
		self:EmitSound( painsounds[math.random(1,9)], math.random(80,95), math.random(70, 105) )
	end
end

function ENT:DeathSound()
	local deathsounds = {}
	deathsounds[1] = (self.Death1)
	deathsounds[2] = (self.Death2)
	deathsounds[3] = (self.Death3)
	deathsounds[4] = (self.Death4)
	deathsounds[5] = (self.Death5)
	deathsounds[6] = (self.Death6)
	deathsounds[7] = (self.Death7)
	deathsounds[8] = (self.Death8)
	deathsounds[9] = (self.Death9)
	deathsounds[10] = (self.Death10)
	deathsounds[11] = (self.Death11)
	deathsounds[12] = (self.Death12)
	deathsounds[13] = (self.Death13)
	deathsounds[14] = (self.Death14)
	deathsounds[15] = (self.Death15)
	deathsounds[16] = (self.Death16)
	deathsounds[17] = (self.Death17)
	deathsounds[18] = (self.Death18)
	deathsounds[19] = (self.Death19)
	self:EmitSound( deathsounds[math.random(1,19)], math.random(80,95), math.random(70, 105) )
end

function ENT:AttackSound()
	local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
	sounds[3] = (self.Attack3)
	sounds[4] = (self.Attack4)
	sounds[5] = (self.Attack5)
	sounds[6] = (self.Attack6)
	sounds[7] = (self.Attack7)
	sounds[8] = (self.Attack8)
	sounds[9] = (self.Attack9)
	sounds[10] = (self.Attack10)
	sounds[11] = (self.Attack11)
	sounds[12] = (self.Attack12)
	self:EmitSound( sounds[math.random(1,12)], math.random(80,95), math.random(70, 105) )
end

function ENT:IdleSound()
	if math.random(1,2) == 1 then
		local sounds = {}
		sounds[1] = (self.Idle1)
		sounds[2] = (self.Idle2)
		sounds[3] = (self.Idle3)
		sounds[4] = (self.Idle4)
		sounds[5] = (self.Idle5)
		sounds[6] = (self.Idle6)
		sounds[7] = (self.Idle7)
		sounds[8] = (self.Idle8)
		sounds[9] = (self.Idle9)
		sounds[10] = (self.Idle10)
		sounds[11] = (self.Idle11)
		sounds[12] = (self.Idle12)
		sounds[13] = (self.Idle13)
		sounds[14] = (self.Idle14)
		sounds[15] = (self.Idle15)
		sounds[16] = (self.Idle16)
		self:EmitSound( sounds[math.random(1,16)] )
	end
end

function ENT:CustomDoorAttack( ent )

	if ( self.NextDoorAttackTimer or 0 ) < CurTime() then

		self:AttackSound()
		self:MutatedAttack( ent, 2 )
		
		self.NextDoorAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then

		self:AttackSound()
		self:MutatedAttack( ent, 1 )
		
		self.NextPropAttackTimer = CurTime() + self.NextAttack
	end
	
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
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,55) )	
				self:EmitSound("npc/infected_zombies/hit_punch_0"..math.random(8)..".wav", math.random(100,125), math.random(85,105))
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
			self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		end
		
	end)
	
	if reset == 1 then
		timer.Simple( time + 0.6, function()
			if !self:IsValid() then return end
			if self:Health() < 0 then return end
			
			if self.Status == 3 then return end
			self.IsAttacking = false
			
			if !self:CheckStatus( 1 ) then return end
			
			self:PlayRandomMutate( 5 )
			
		end)
	end

end

function ENT:BreakThrough( ent, dmg, speed, type )
	self.loco:SetDesiredSpeed( speed )
	
	self:AttackEffect( 0.5, ent, dmg, type, 0 )
	self:AttackEffect( 1.2, ent, dmg, type, 0 )
	
	self:ResetSequence( self.BreakThroughAnim )
	self:SetCycle( 0 )
	self:SetPlaybackRate( 1 )
	
	timer.Simple( 1.7, function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		self.IsAttacking = false
		
		if !self:CheckStatus( 1 ) then return end
		
		self:PlayRandomMutate( 5 )
		
	end)
end
	
function ENT:MutatedAttack( ent, type )
	
	if !self:CheckStatus( 1 ) then return end
	
	if self.Status == 1 then
		
		local anim = math.random(1,2)
		if anim == 1 then
			self:AttackEffect( 0.6, ent, self.Damage, type, 1 )
			self:PlaySequenceAndWait( self.Status1Attack1, 1 )
		elseif anim == 2 then
			self:AttackEffect( 0.6, ent, self.Damage, type, 1 )
			self:PlaySequenceAndWait( self.Status1Attack2, 1 )
		end
		
	elseif self.Status == 2 then

		self:AttackEffect( 0.4, ent, self.Damage, type, 1 )
		self:PlaySequenceAndWait( self.FastAttack, 1 )
		
	elseif self.Status == 3 then
			
		self:BreakThrough( ent, self.Damage - 5, self.Speed / 3, type )
		
	end
	
end

function ENT:Attack()

	if ( self.NextAttackTimer or 0 ) < CurTime() then	
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
			
			if !self:CheckStatus( 1 ) then return end
		
			self.IsAttacking = true
			self:AttackSound()
			
			self:MutatedAttack( self.Enemy, 0 )

		end
		
		self.NextAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:CustomThink()
	if !self:CheckStatus( 1 ) then return end
	if self.Status == 3 then return end
	
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
list.Set( "NPC", "nz_crazies", {
	Name = "Type 1",
	Class = "nz_crazies",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.MoveType = 2

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.Speed = 70
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 0

ENT.health = 100
ENT.Damage = 20

ENT.PhysForce = 15000

ENT.DoorAttackRange = 25
ENT.AttackRange = 53
ENT.InitialAttackRange = 64

ENT.NextAttack = 1.1

--Model Settings--
ENT.Model1 = "models/zombie/infected_01.mdl"
ENT.Model2 = "models/zombie/infected_02.mdl"
ENT.Model3 = "models/zombie/infected_03.mdl"
ENT.Model4 = "models/zombie/infected_04.mdl"
ENT.Model5 = "models/zombie/infected_05.mdl"
ENT.Model6 = "models/zombie/infected_06.mdl"
ENT.Model7 = "models/zombie/infected_07.mdl"
ENT.Model8 = "models/zombie/infected_08.mdl"
ENT.Model9 = "models/zombie/infected_09.mdl"
ENT.Model10 = "models/zombie/infected_10.mdl"
ENT.Model11 = "models/zombie/infected_11.mdl"
ENT.Model12 = "models/zombie/infected_12.mdl"

ENT.WalkAnim = "walk_melee"
ENT.IdleAnim = "idle"

ENT.Status1WalkAnim = "walk_melee"

ENT.Status2RunAnim = "run_all"

ENT.Status3RunAnim = "zombie_run"

ENT.Status1Attack1 = "weapon_attack1"
ENT.Status1Attack2 = "weapon_attack2"
ENT.FastAttack = "fastattack"
ENT.BreakThroughAnim = "breakthrough"

ENT.TransformAnim1 = "releasecrab"

ENT.ChestFlinch1 = "physflinch1"
ENT.ChestFlinch2 = "physflinch2"
ENT.ChestFlinch3 = "physflinch3"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

--Sounds--
ENT.Attack1 = Sound("npc/infected_zombies/rage_at_victim20.wav")
ENT.Attack2 = Sound("npc/infected_zombies/rage_at_victim21.wav")
ENT.Attack3 = Sound("npc/infected_zombies/rage_at_victim22.wav")
ENT.Attack4 = Sound("npc/infected_zombies/rage_at_victim23.wav")
ENT.Attack5 = Sound("npc/infected_zombies/rage_at_victim24.wav")
ENT.Attack6 = Sound("npc/infected_zombies/rage_at_victim25.wav")
ENT.Attack7 = Sound("npc/infected_zombies/rage_at_victim26.wav")
ENT.Attack8 = Sound("npc/infected_zombies/rage_at_victim27.wav")
ENT.Attack9 = Sound("npc/infected_zombies/rage_at_victim28.wav")
ENT.Attack10 = Sound("npc/infected_zombies/rage_at_victim29.wav")
ENT.Attack11 = Sound("npc/infected_zombies/rage_at_victim30.wav")
ENT.Attack12 = Sound("npc/infected_zombies/rage_at_victim31.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Death1 = Sound("npc/infected_zombies/death_17.wav")
ENT.Death2 = Sound("npc/infected_zombies/death_18.wav")
ENT.Death3 = Sound("npc/infected_zombies/death_19.wav")
ENT.Death4 = Sound("npc/infected_zombies/death_20.wav")
ENT.Death5 = Sound("npc/infected_zombies/death_21.wav")
ENT.Death6 = Sound("npc/infected_zombies/death_22.wav")
ENT.Death7 = Sound("npc/infected_zombies/death_23.wav")
ENT.Death8 = Sound("npc/infected_zombies/death_24.wav")
ENT.Death9 = Sound("npc/infected_zombies/death_25.wav")
ENT.Death10 = Sound("npc/infected_zombies/death_26.wav")
ENT.Death11 = Sound("npc/infected_zombies/death_27.wav")
ENT.Death12 = Sound("npc/infected_zombies/death_28.wav")
ENT.Death13 = Sound("npc/infected_zombies/death_29.wav")
ENT.Death14 = Sound("npc/infected_zombies/death_30.wav")
ENT.Death15 = Sound("npc/infected_zombies/death_31.wav")
ENT.Death16 = Sound("npc/infected_zombies/death_32.wav")
ENT.Death17 = Sound("npc/infected_zombies/death_33.wav")
ENT.Death18 = Sound("npc/infected_zombies/death_34.wav")
ENT.Death19 = Sound("npc/infected_zombies/death_35.wav")

ENT.Alert1 = Sound("npc/infected_zombies/rage_at_victim32.wav")
ENT.Alert2 = Sound("npc/infected_zombies/rage_at_victim32.wav")
ENT.Alert3 = Sound("npc/infected_zombies/rage_at_victim33.wav")
ENT.Alert4 = Sound("npc/infected_zombies/rage_at_victim34.wav")
ENT.Alert5 = Sound("npc/infected_zombies/rage_at_victim35.wav")
ENT.Alert6 = Sound("npc/infected_zombies/rage_at_victim36.wav")
ENT.Alert7 = Sound("npc/infected_zombies/rage_at_victim37.wav")

ENT.Idle1 = Sound("npc/infected_zombies/been_shot_1.wav")
ENT.Idle2 = Sound("npc/infected_zombies/been_shot_2.wav")
ENT.Idle3 = Sound("npc/infected_zombies/been_shot_3.wav")
ENT.Idle4 = Sound("npc/infected_zombies/been_shot_4.wav")
ENT.Idle5 = Sound("npc/infected_zombies/been_shot_5.wav")
ENT.Idle6 = Sound("npc/infected_zombies/been_shot_6.wav")
ENT.Idle7 = Sound("npc/infected_zombies/been_shot_7.wav")
ENT.Idle8 = Sound("npc/infected_zombies/been_shot_8.wav")
ENT.Idle9 = Sound("npc/infected_zombies/been_shot_9.wav")
ENT.Idle10 = Sound("npc/infected_zombies/been_shot_10.wav")
ENT.Idle11 = Sound("npc/infected_zombies/been_shot_11.wav")
ENT.Idle12 = Sound("npc/infected_zombies/been_shot_12.wav")
ENT.Idle13 = Sound("npc/infected_zombies/been_shot_13.wav")
ENT.Idle14 = Sound("npc/infected_zombies/been_shot_14.wav")
ENT.Idle15 = Sound("npc/infected_zombies/been_shot_15.wav")
ENT.Idle16 = Sound("npc/infected_zombies/been_shot_16.wav")

ENT.Pain1 = Sound("npc/infected_zombies/pain1.wav")
ENT.Pain2 = Sound("npc/infected_zombies/pain2.wav")
ENT.Pain3 = Sound("npc/infected_zombies/pain3.wav")
ENT.Pain4 = Sound("npc/infected_zombies/pain4.wav")
ENT.Pain5 = Sound("npc/infected_zombies/pain5.wav")
ENT.Pain6 = Sound("npc/infected_zombies/pain6.wav")
ENT.Pain7 = Sound("npc/infected_zombies/pain7.wav")
ENT.Pain8 = Sound("npc/infected_zombies/pain8.wav")
ENT.Pain9 = Sound("npc/infected_zombies/pain9.wav")

ENT.Hit1 = Sound("npc/infected_zombies/hit_punch_01.wav")
ENT.Hit2 = Sound("npc/infected_zombies/hit_punch_02.wav")
ENT.Hit3 = Sound("npc/infected_zombies/hit_punch_03.wav")
ENT.Hit4 = Sound("npc/infected_zombies/hit_punch_04.wav")
ENT.Hit5 = Sound("npc/infected_zombies/hit_punch_05.wav")
ENT.Hit6 = Sound("npc/infected_zombies/hit_punch_06.wav")
ENT.Hit7 = Sound("npc/infected_zombies/hit_punch_07.wav")
ENT.Hit8 = Sound("npc/infected_zombies/hit_punch_08.wav")

ENT.Miss1 = Sound("npc/infected_zombies/claw_miss_1.wav")
ENT.Miss2 = Sound("npc/infected_zombies/claw_miss_2.wav")

function ENT:Precache()
--Models--
util.PrecacheModel(self.Model1)
util.PrecacheModel(self.Model2)
util.PrecacheModel(self.Model3)
util.PrecacheModel(self.Model4)
util.PrecacheModel(self.Model5)
util.PrecacheModel(self.Model6)
util.PrecacheModel(self.Model7)
util.PrecacheModel(self.Model8)
util.PrecacheModel(self.Model9)
util.PrecacheModel(self.Model10)
util.PrecacheModel(self.Model11)
util.PrecacheModel(self.Model12)

--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)
util.PrecacheSound(self.Attack3)
util.PrecacheSound(self.Attack4)
util.PrecacheSound(self.Attack5)
util.PrecacheSound(self.Attack6)
util.PrecacheSound(self.Attack7)
util.PrecacheSound(self.Attack8)
util.PrecacheSound(self.Attack9)
util.PrecacheSound(self.Attack10)
util.PrecacheSound(self.Attack11)
util.PrecacheSound(self.Attack12)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)
util.PrecacheSound(self.Death4)
util.PrecacheSound(self.Death5)
util.PrecacheSound(self.Death6)
util.PrecacheSound(self.Death7)
util.PrecacheSound(self.Death8)
util.PrecacheSound(self.Death9)
util.PrecacheSound(self.Death10)
util.PrecacheSound(self.Death11)
util.PrecacheSound(self.Death12)
util.PrecacheSound(self.Death13)
util.PrecacheSound(self.Death14)
util.PrecacheSound(self.Death15)
util.PrecacheSound(self.Death16)
util.PrecacheSound(self.Death17)
util.PrecacheSound(self.Death18)
util.PrecacheSound(self.Death19)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)
util.PrecacheSound(self.Alert3)
util.PrecacheSound(self.Alert4)
util.PrecacheSound(self.Alert5)
util.PrecacheSound(self.Alert6)
util.PrecacheSound(self.Alert7)

util.PrecacheSound(self.Idle1)
util.PrecacheSound(self.Idle2)
util.PrecacheSound(self.Idle3)
util.PrecacheSound(self.Idle4)
util.PrecacheSound(self.Idle5)
util.PrecacheSound(self.Idle6)
util.PrecacheSound(self.Idle7)
util.PrecacheSound(self.Idle8)
util.PrecacheSound(self.Idle9)
util.PrecacheSound(self.Idle10)	
util.PrecacheSound(self.Idle11)
util.PrecacheSound(self.Idle12)	
	
util.PrecacheSound(self.Pain1)
util.PrecacheSound(self.Pain2)
util.PrecacheSound(self.Pain3)
util.PrecacheSound(self.Pain4)
util.PrecacheSound(self.Pain5)
util.PrecacheSound(self.Pain6)
util.PrecacheSound(self.Pain7)
util.PrecacheSound(self.Pain8)
util.PrecacheSound(self.Pain9)
	
util.PrecacheSound(self.Hit1)
util.PrecacheSound(self.Hit2)
util.PrecacheSound(self.Hit3)
util.PrecacheSound(self.Hit4)
util.PrecacheSound(self.Hit5)
util.PrecacheSound(self.Hit6)
util.PrecacheSound(self.Hit7)
util.PrecacheSound(self.Hit8)

util.PrecacheSound(self.Miss1)
util.PrecacheSound(self.Miss2)
end

function ENT:Initialize()

	if SERVER then

	--Stats--
	local model = math.random(1,12)
	if model == 1 then self:SetModel(self.Model1)
	elseif model == 2 then self:SetModel(self.Model2)
	elseif model == 3 then self:SetModel(self.Model3)
	elseif model == 4 then self:SetModel(self.Model4)
	elseif model == 5 then self:SetModel(self.Model5)
	elseif model == 6 then self:SetModel(self.Model6)
	elseif model == 7 then self:SetModel(self.Model7)
	elseif model == 8 then self:SetModel(self.Model8)
	elseif model == 9 then self:SetModel(self.Model9)
	elseif model == 10 then self:SetModel(self.Model10)
	elseif model == 11 then self:SetModel(self.Model11)
	elseif model == 12 then self:SetModel(self.Model12)
	end
	
	self:SetHealth(self.health)	
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	self.IsMutating = false
	
	self.Status = math.random(1,3)
	self:Mutate( 0 )
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(300)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:Precache()
	self:CreateBullseye()
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
	end
	
end

function ENT:IdleFunction()

	if !self:CheckStatus( 1 ) then return end

	if math.random(1,100) == 1 then
		self:Mutate( 1 )
	else
		self:ResetSequence( self.IdleAnim )
	end
	
end

function ENT:PlayMutateSequence( string, rate, cycle, speed, time )
	self.IsMutating = true
	
	self:ResetSequence( string )
	self:SetCycle( cycle )
	self:SetPlaybackRate( rate )
	self.loco:SetDesiredSpeed( speed )
	
	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		self.IsMutating = false
		
		if self.HasNoEnemy then
			self:ResetSequence( self.IdleAnim )	
		else
			self:ResumeMovementFunctions()
		end
		
	end)
end

function ENT:StatsChange( health, speed, damage, walkanim, walkspeedanimation )

	if self:Health() < 230 then
		self:SetHealth( self:Health() + ( 15 + health ) )
	end
	
	self.Speed = speed
	self.Damage = damage
	self.WalkAnim = walkanim
	self.WalkSpeedAnimation = walkspeedanimation
	
	if self.Status == 3 then
		self.NextAttack = 2
	else
		self.NextAttack = 1.2
	end
	
	self:ResumeMovementFunctions()
	
end

function ENT:Mutate( playsequence )

	if self.Status == 1 then
	
		self:StatsChange( 25, 60, 30, self.Status1WalkAnim, 1 )
		
	elseif self.Status == 2 then
		
		local anim = math.random(1,2)
		if anim == 1 then
			self:StatsChange( 0, 170, 20, self.Status2RunAnim, 0.9 )
		elseif anim == 2 then
			self:StatsChange( 0, 170, 20, self.Status3RunAnim, 0.8 )
		end
		
	elseif self.Status == 3 then
		
		self:StatsChange( 10, 125, 25, self.Status1WalkAnim, 2 )
		
	end
	
	if playsequence == 1 then
		self:EmitSound("player/pl_pain"..math.random(5,7)..".wav", 100)
		self:PlayMutateSequence( self.TransformAnim1, 1, 0, 0, 1.1 )
	end
		
end

function ENT:PlayRandomMutate( chance )

	if math.random(1,chance) == 1 then
		
		if self:GetRangeTo( self.Enemy ) > self.InitialAttackRange then
		
			if self.IsAttacking then return end
			if self.IsFlinching then return end
			
			self.Status = math.random(1,3)
			self:Mutate( 1 )
			
		end
		
	else
	
		self:ResumeMovementFunctions()
	
	end
	
end

function ENT:CheckStatus( attacking )

	if self.Flinching then
		return false
	end
	
	if self.IsMutating then
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
			self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
			self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,55) )	
		end
	
	end

	if dmginfo:IsExplosionDamage() then
		self:MorphRagdoll( dmginfo )
	else
		if self.Flinching or self.IsMutating then
			self:MorphRagdoll( dmginfo )
		else
			self:DeathAnimation( "nz_deathanim_base", self:GetPos(), ACT_HL2MP_WALK_ZOMBIE_01, 1 )
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
			
		if hitgroup == HITGROUP_HEAD then
			self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
		end
			
		if self.IsMutating then 
			dmginfo:ScaleDamage( 0.60 )
		else
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
			else
				if attacker:IsNPC() then
					dmginfo:ScaleDamage(0.90)
				else
					dmginfo:ScaleDamage(0.80)
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
		self:PlayRandomMutate( 5 )
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
	local alertsounds = {}
	alertsounds[1] = (self.Alert1)
	alertsounds[2] = (self.Alert2)
	alertsounds[3] = (self.Alert3)
	alertsounds[4] = (self.Alert4)
	alertsounds[5] = (self.Alert5)
	alertsounds[6] = (self.Alert6)
	alertsounds[7] = (self.Alert7)
	self:EmitSound( alertsounds[math.random(1,7)], math.random(80,95), math.random(70, 105) )
end

function ENT:PainSound()
	if math.random(1,3) == 1 then
		local painsounds = {}
		painsounds[1] = (self.Pain1)
		painsounds[2] = (self.Pain2)
		painsounds[3] = (self.Pain3)
		painsounds[4] = (self.Pain4)
		painsounds[5] = (self.Pain5)
		painsounds[6] = (self.Pain6)
		painsounds[7] = (self.Pain7)
		painsounds[8] = (self.Pain8)
		painsounds[9] = (self.Pain9)
		self:EmitSound( painsounds[math.random(1,9)], math.random(80,95), math.random(70, 105) )
	end
end

function ENT:DeathSound()
	local deathsounds = {}
	deathsounds[1] = (self.Death1)
	deathsounds[2] = (self.Death2)
	deathsounds[3] = (self.Death3)
	deathsounds[4] = (self.Death4)
	deathsounds[5] = (self.Death5)
	deathsounds[6] = (self.Death6)
	deathsounds[7] = (self.Death7)
	deathsounds[8] = (self.Death8)
	deathsounds[9] = (self.Death9)
	deathsounds[10] = (self.Death10)
	deathsounds[11] = (self.Death11)
	deathsounds[12] = (self.Death12)
	deathsounds[13] = (self.Death13)
	deathsounds[14] = (self.Death14)
	deathsounds[15] = (self.Death15)
	deathsounds[16] = (self.Death16)
	deathsounds[17] = (self.Death17)
	deathsounds[18] = (self.Death18)
	deathsounds[19] = (self.Death19)
	self:EmitSound( deathsounds[math.random(1,19)], math.random(80,95), math.random(70, 105) )
end

function ENT:AttackSound()
	local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
	sounds[3] = (self.Attack3)
	sounds[4] = (self.Attack4)
	sounds[5] = (self.Attack5)
	sounds[6] = (self.Attack6)
	sounds[7] = (self.Attack7)
	sounds[8] = (self.Attack8)
	sounds[9] = (self.Attack9)
	sounds[10] = (self.Attack10)
	sounds[11] = (self.Attack11)
	sounds[12] = (self.Attack12)
	self:EmitSound( sounds[math.random(1,12)], math.random(80,95), math.random(70, 105) )
end

function ENT:IdleSound()
	if math.random(1,2) == 1 then
		local sounds = {}
		sounds[1] = (self.Idle1)
		sounds[2] = (self.Idle2)
		sounds[3] = (self.Idle3)
		sounds[4] = (self.Idle4)
		sounds[5] = (self.Idle5)
		sounds[6] = (self.Idle6)
		sounds[7] = (self.Idle7)
		sounds[8] = (self.Idle8)
		sounds[9] = (self.Idle9)
		sounds[10] = (self.Idle10)
		sounds[11] = (self.Idle11)
		sounds[12] = (self.Idle12)
		sounds[13] = (self.Idle13)
		sounds[14] = (self.Idle14)
		sounds[15] = (self.Idle15)
		sounds[16] = (self.Idle16)
		self:EmitSound( sounds[math.random(1,16)] )
	end
end

function ENT:CustomDoorAttack( ent )

	if ( self.NextDoorAttackTimer or 0 ) < CurTime() then

		self:AttackSound()
		self:MutatedAttack( ent, 2 )
		
		self.NextDoorAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then

		self:AttackSound()
		self:MutatedAttack( ent, 1 )
		
		self.NextPropAttackTimer = CurTime() + self.NextAttack
	end
	
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
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,55) )	
				self:EmitSound("npc/infected_zombies/hit_punch_0"..math.random(8)..".wav", math.random(100,125), math.random(85,105))
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
			self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		end
		
	end)
	
	if reset == 1 then
		timer.Simple( time + 0.6, function()
			if !self:IsValid() then return end
			if self:Health() < 0 then return end
			
			if self.Status == 3 then return end
			self.IsAttacking = false
			
			if !self:CheckStatus( 1 ) then return end
			
			self:PlayRandomMutate( 5 )
			
		end)
	end

end

function ENT:BreakThrough( ent, dmg, speed, type )
	self.loco:SetDesiredSpeed( speed )
	
	self:AttackEffect( 0.5, ent, dmg, type, 0 )
	self:AttackEffect( 1.2, ent, dmg, type, 0 )
	
	self:ResetSequence( self.BreakThroughAnim )
	self:SetCycle( 0 )
	self:SetPlaybackRate( 1 )
	
	timer.Simple( 1.7, function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		self.IsAttacking = false
		
		if !self:CheckStatus( 1 ) then return end
		
		self:PlayRandomMutate( 5 )
		
	end)
end
	
function ENT:MutatedAttack( ent, type )
	
	if !self:CheckStatus( 1 ) then return end
	
	if self.Status == 1 then
		
		local anim = math.random(1,2)
		if anim == 1 then
			self:AttackEffect( 0.6, ent, self.Damage, type, 1 )
			self:PlaySequenceAndWait( self.Status1Attack1, 1 )
		elseif anim == 2 then
			self:AttackEffect( 0.6, ent, self.Damage, type, 1 )
			self:PlaySequenceAndWait( self.Status1Attack2, 1 )
		end
		
	elseif self.Status == 2 then

		self:AttackEffect( 0.4, ent, self.Damage, type, 1 )
		self:PlaySequenceAndWait( self.FastAttack, 1 )
		
	elseif self.Status == 3 then
			
		self:BreakThrough( ent, self.Damage - 5, self.Speed / 3, type )
		
	end
	
end

function ENT:Attack()

	if ( self.NextAttackTimer or 0 ) < CurTime() then	
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
			
			if !self:CheckStatus( 1 ) then return end
		
			self.IsAttacking = true
			self:AttackSound()
			
			self:MutatedAttack( self.Enemy, 0 )

		end
		
		self.NextAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:CustomThink()
	if !self:CheckStatus( 1 ) then return end
	if self.Status == 3 then return end
	
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