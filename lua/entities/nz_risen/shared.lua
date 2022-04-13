if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_risen", {
	Name = "Risen",
	Class = "nz_risen",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.MoveType = 2

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.Speed = 155
ENT.WalkSpeedAnimation = 1

ENT.health = 100
ENT.Damage = 20

ENT.PhysForce = 15000
ENT.AttackRange = 50
ENT.InitialAttackRange = 60
ENT.DoorAttackRange = 25

ENT.NextAttack = 0.5

--Model Settings--
ENT.Model = "models/freshdead/freshdead_01.mdl"
ENT.Model2 = "models/freshdead/freshdead_02.mdl"
ENT.Model3 = "models/freshdead/freshdead_03.mdl"
ENT.Model4 = "models/freshdead/freshdead_04.mdl"
ENT.Model5 = "models/freshdead/freshdead_05.mdl"
ENT.Model6 = "models/freshdead/freshdead_06.mdl"
ENT.Model7 = "models/freshdead/freshdead_07.mdl"

ENT.AttackAnim1 = "attacka"
ENT.AttackAnim2 = "attackb"
ENT.AttackAnim3 = "attackc"

ENT.IdleAnim = "idle01"
ENT.IdleAnim2 = "idle02"
ENT.IdleAnim3 = "idle03"
ENT.IdleAnim4 = "idle04"

ENT.ChestFlinch1 = "physflinch1"
ENT.ChestFlinch2 = "physflinch2"
ENT.ChestFlinch3 = "physflinch3"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

--Sounds--
ENT.Attack1 = Sound("npc/freshdead/male/attack1.wav")
ENT.Attack2 = Sound("npc/freshdead/male/attack2.wav")
ENT.Attack3 = Sound("npc/freshdead/male/attack3.wav")
ENT.Attack4 = Sound("npc/freshdead/male/attack4.wav")

ENT.FemaleAttack1 = Sound("npc/freshdead/Female/attack1.wav")
ENT.FemaleAttack2 = Sound("npc/freshdead/Female/attack2.wav")
ENT.FemaleAttack3 = Sound("npc/freshdead/Female/attack3.wav")
ENT.FemaleAttack4 = Sound("npc/freshdead/Female/attack4.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Death1 = Sound("npc/freshdead/male/death1.wav")
ENT.Death2 = Sound("npc/freshdead/male/death2.wav")
ENT.Death3 = Sound("npc/freshdead/male/death3.wav")
ENT.Death4 = Sound("npc/freshdead/male/death4.wav")

ENT.FemaleDeath1 = Sound("npc/freshdead/Female/death1.wav")
ENT.FemaleDeath2 = Sound("npc/freshdead/Female/death2.wav")
ENT.FemaleDeath3 = Sound("npc/freshdead/Female/death3.wav")
ENT.FemaleDeath4 = Sound("npc/freshdead/Female/death4.wav")

ENT.Alert1 = Sound("npc/freshdead/male/alert1.wav")
ENT.Alert2 = Sound("npc/freshdead/male/alert2.wav")
ENT.Alert3 = Sound("npc/freshdead/male/alert3.wav")
ENT.Alert4 = Sound("npc/freshdead/male/alert4.wav")

ENT.FemaleAlert1 = Sound("npc/freshdead/Female/alert1.wav")
ENT.FemaleAlert2 = Sound("npc/freshdead/Female/alert2.wav")
ENT.FemaleAlert3 = Sound("npc/freshdead/Female/alert3.wav")
ENT.FemaleAlert4 = Sound("npc/freshdead/Female/alert4.wav")

ENT.Flinch1 = Sound("npc/freshdead/male/flinch1.wav")
ENT.Flinch2 = Sound("npc/freshdead/male/flinch2.wav")
ENT.Flinch3 = Sound("npc/freshdead/male/flinch3.wav")

ENT.FemaleFlinch1 = Sound("npc/freshdead/Female/flinch1.wav")
ENT.FemaleFlinch2 = Sound("npc/freshdead/Female/flinch2.wav")
ENT.FemaleFlinch3 = Sound("npc/freshdead/Female/flinch3.wav")

ENT.Idle1 = Sound("npc/freshdead/male/alert_no_enemy1.wav")
ENT.Idle2 = Sound("npc/freshdead/male/alert_no_enemy2.wav")
ENT.Idle3 = Sound("npc/freshdead/male/pain2.wav")
ENT.Idle4 = Sound("npc/freshdead/male/pain4.wav")

ENT.FemaleIdle1 = Sound("npc/freshdead/Female/alert_no_enemy1.wav")
ENT.FemaleIdle2 = Sound("npc/freshdead/Female/alert_no_enemy2.wav")
ENT.FemaleIdle3 = Sound("npc/freshdead/Female/pain2.wav")
ENT.FemaleIdle4 = Sound("npc/freshdead/Female/pain4.wav")

ENT.Pain1 = Sound("npc/freshdead/male/pain1.wav")
ENT.Pain2 = Sound("npc/freshdead/male/pain2.wav")
ENT.Pain3 = Sound("npc/freshdead/male/pain3.wav")
ENT.Pain4 = Sound("npc/freshdead/male/pain4.wav")

ENT.FemalePain1 = Sound("npc/freshdead/Female/pain1.wav")
ENT.FemalePain2 = Sound("npc/freshdead/Female/pain2.wav")
ENT.FemalePain3 = Sound("npc/freshdead/Female/pain3.wav")
ENT.FemalePain4 = Sound("npc/freshdead/Female/pain4.wav")

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
util.PrecacheModel(self.Model)
util.PrecacheModel(self.Model2)
util.PrecacheModel(self.Model3)
util.PrecacheModel(self.Model4)
util.PrecacheModel(self.Model5)
util.PrecacheModel(self.Model6)
util.PrecacheModel(self.Model7)

--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)
util.PrecacheSound(self.Attack3)
util.PrecacheSound(self.Attack4)

util.PrecacheSound(self.FemaleAttack1)
util.PrecacheSound(self.FemaleAttack2)
util.PrecacheSound(self.FemaleAttack3)
util.PrecacheSound(self.FemaleAttack4)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.FemaleDeath1)
util.PrecacheSound(self.FemaleDeath2)
util.PrecacheSound(self.FemaleDeath3)
util.PrecacheSound(self.FemaleDeath4)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)
util.PrecacheSound(self.Death4)

util.PrecacheSound(self.FemaleDeath1)
util.PrecacheSound(self.FemaleDeath2)
util.PrecacheSound(self.FemaleDeath3)
util.PrecacheSound(self.FemaleDeath4)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)
util.PrecacheSound(self.Alert3)
util.PrecacheSound(self.Alert4)

util.PrecacheSound(self.FemaleAlert1)
util.PrecacheSound(self.FemaleAlert2)
util.PrecacheSound(self.FemaleAlert3)
util.PrecacheSound(self.FemaleAlert4)

util.PrecacheSound(self.Flinch1)
util.PrecacheSound(self.Flinch2)
util.PrecacheSound(self.Flinch3)

util.PrecacheSound(self.FemaleFlinch1)
util.PrecacheSound(self.FemaleFlinch2)
util.PrecacheSound(self.FemaleFlinch3)

util.PrecacheSound(self.Idle1)
util.PrecacheSound(self.Idle2)
util.PrecacheSound(self.Idle3)
util.PrecacheSound(self.Idle4)
	
util.PrecacheSound(self.FemaleIdle1)
util.PrecacheSound(self.FemaleIdle2)
util.PrecacheSound(self.FemaleIdle3)
util.PrecacheSound(self.FemaleIdle4)	
	
util.PrecacheSound(self.Pain1)
util.PrecacheSound(self.Pain2)
util.PrecacheSound(self.Pain3)
util.PrecacheSound(self.Pain4)
	
util.PrecacheSound(self.FemalePain1)
util.PrecacheSound(self.FemalePain2)
util.PrecacheSound(self.FemalePain3)
util.PrecacheSound(self.FemalePain4)	
	
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
	self:Switch()
	self:SetModel(self.Model)
	self:SetHealth(self.health)	
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(400)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:Precache()
	self:CreateBullseye()
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )

	end
	
end

function ENT:SwitchToFemale( model )
	self.WalkAnim = ( table.Random(self.Anims) )
	self.Model = model
	
	self.Death1 = self.FemaleDeath1
	self.Death2 = self.FemaleDeath2
	self.Death3 = self.FemaleDeath3
	self.Death4 = self.FemaleDeath4
	
	self.Alert1 = self.FemaleAlert1
	self.Alert2 = self.FemaleAlert2
	self.Alert3 = self.FemaleAlert3
	self.Alert4 = self.FemaleAlert4
	
	self.Idle1 = self.FemaleIdle1
	self.Idle2 = self.FemaleIdle2
	self.Idle3 = self.FemaleIdle3
	self.Idle4 = self.FemaleIdle4
	
	self.Attack1 = self.FemaleAttack1
	self.Attack2 = self.FemaleAttack2
	self.Attack3 = self.FemaleAttack3
	self.Attack4 = self.FemaleAttack4
	
	self.Flinch1 = self.FemaleFlinch1
	self.Flinch2 = self.FemaleFlinch2
	self.Flinch3 = self.FemaleFlinch3
	
	self.Pain1 = self.FemalePain1
	self.Pain2 = self.FemalePain2
	self.Pain3 = self.FemalePain3
	self.Pain4 = self.FemalePain4
	
	self.Damage = math.random(12,14)
	self.Speed = math.random(145, 165)
end

function ENT:SwitchToMale( model )
	self.WalkAnim = ( table.Random(self.Anims) )
	self.Model = model
	
	self.Damage = math.random(18,20)
	self.Speed = math.random(135, 145)
end

function ENT:Switch()
	self.Anims = { "walk", "run", "run_all" }

	local model = math.random(1,7)
	if model == 1 then
		self:SwitchToMale( self.Model )
	elseif model == 2 then
		self:SwitchToMale( self.Model2 )
	elseif model == 3 then
		self:SwitchToMale( self.Model3 )
	elseif model == 4 then
		self:SwitchToMale( self.Model4 )
	elseif model == 5 then
		self:SwitchToFemale( self.Model5 )
	elseif model == 6 then
		self:SwitchToFemale( self.Model6 )
	elseif model == 7 then
		self:SwitchToFemale( self.Model7 )
	end
	
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
			self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
			self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,55) )
		end
	
	end

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

function ENT:CheckStatus()

	if self.Flinching then
		return false
	end
	
	return true

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
				dmginfo:ScaleDamage(6)
			else
				dmginfo:ScaleDamage(5)
			end
		else
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(5)
			else
				dmginfo:ScaleDamage(4)
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

function ENT:FootSteps()
	self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
end

function ENT:AlertSound()
	local alertsounds = {}
	alertsounds[1] = (self.Alert1)
	alertsounds[2] = (self.Alert2)
	alertsounds[3] = (self.Alert3)
	alertsounds[4] = (self.Alert4)
	self:EmitSound( alertsounds[math.random(1,4)], math.random(80,95), math.random(70, 105) )
end

function ENT:PainSound()
	if math.random(1,3) == 1 then
		local painsounds = {}
		painsounds[1] = (self.Pain1)
		painsounds[2] = (self.Pain2)
		painsounds[3] = (self.Pain3)
		painsounds[4] = (self.Pain4)
		self:EmitSound( painsounds[math.random(1,4)], math.random(80,95), math.random(70, 105) )
	end
end

function ENT:DeathSound()
	local deathsounds = {}
	deathsounds[1] = (self.Death1)
	deathsounds[2] = (self.Death2)
	deathsounds[3] = (self.Death3)
	deathsounds[4] = (self.Death4)
	self:EmitSound( deathsounds[math.random(1,4)], math.random(80,95), math.random(70, 105) )
end

function ENT:AttackSound()
	local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
	sounds[3] = (self.Attack3)
	sounds[4] = (self.Attack4)
	self:EmitSound( sounds[math.random(1,4)], math.random(80,95), math.random(70, 105) )
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