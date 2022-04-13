if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_grabber", {
	Name = "Type 3",
	Class = "nz_grabber",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.MoveType = 2

ENT.CollisionHeight = 66
ENT.CollisionSide = 7

ENT.Speed = 70
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 20

ENT.health = 100
ENT.Damage = 15

ENT.PhysForce = 10000
ENT.AttackRange = 50
ENT.InitialAttackRange = 55
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.6

--Model Settings--
ENT.Model1 = "models/zombie/grabber_01.mdl"
ENT.Model2 = "models/zombie/grabber_02.mdl"
ENT.Model3 = "models/zombie/grabber_03.mdl"
ENT.Model4 = "models/zombie/grabber_04.mdl"
ENT.Model5 = "models/zombie/grabber_05.mdl"
ENT.Model6 = "models/zombie/grabber_06.mdl"
ENT.Model7 = "models/zombie/grabber_07.mdl"
ENT.Model8 = "models/zombie/grabber_08.mdl"
ENT.Model9 = "models/zombie/grabber_09.mdl"
ENT.Model10 = "models/zombie/grabber_10.mdl"

ENT.IdleAnim = ACT_HL2MP_IDLE_ZOMBIE
ENT.TantrumAnim = "tantrum"

ENT.AttackPropAnim = "breakthrough"

ENT.GrabAnim = "alyx_zombie_grab"
ENT.GrabFailAnim = "alyx_zombie_grab_exit"
ENT.HoldAnim = "alyx_zombie_grab_pi"

ENT.AttackAnim1 = "swatleftlow"
ENT.AttackAnim2 = "swatleftmid"
ENT.AttackAnim3 = "swatrightlow"
ENT.AttackAnim4 = "swatrightmid"

ENT.WalkAnim = "walk"
ENT.WalkAnim1 = "zombie_walk_01"
ENT.WalkAnim2 = "zombie_walk_02"
ENT.WalkAnim3 = "zombie_walk_03"
ENT.WalkAnim4 = "zombie_walk_04"
ENT.WalkAnim5 = "zombie_walk_05"

ENT.ChestFlinch1 = "physflinch1"
ENT.ChestFlinch2 = "physflinch2"
ENT.ChestFlinch3 = "physflinch3"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

--Sounds--
ENT.Attack1 = Sound("npc/infected/zo_attack1.wav")
ENT.Attack2 = Sound("npc/infected/zo_attack2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Alert1 = Sound("npc/infected/zombie_alert1.wav")
ENT.Alert2 = Sound("npc/infected/zombie_alert2.wav")
ENT.Alert3 = Sound("npc/infected/zombie_alert3.wav")
ENT.Alert4 = Sound("npc/infected/zombie_alert4.wav")

ENT.Death1 = Sound("npc/infected/zombie_die1.wav")
ENT.Death2 = Sound("npc/infected/zombie_die2.wav")
ENT.Death3 = Sound("npc/infected/zombie_die3.wav")
ENT.Death4 = Sound("npc/infected/zombie_die4.wav")
ENT.Death5 = Sound("npc/infected/zombie_die5.wav")
ENT.Death6 = Sound("npc/infected/zombie_die6.wav")

ENT.Idle1 = Sound("npc/infected/zombie_voice_idle1.wav")
ENT.Idle2 = Sound("npc/infected/zombie_voice_idle2.wav")
ENT.Idle3 = Sound("npc/infected/zombie_voice_idle3.wav")
ENT.Idle4 = Sound("npc/infected/zombie_voice_idle4.wav")
ENT.Idle5 = Sound("npc/infected/zombie_voice_idle5.wav")
ENT.Idle6 = Sound("npc/infected/zombie_voice_idle6.wav")
ENT.Idle7 = Sound("npc/infected/zombie_voice_idle7.wav")
ENT.Idle8 = Sound("npc/infected/zombie_voice_idle8.wav")

ENT.Pain1 = Sound("npc/infected/zombie_pain1.wav")
ENT.Pain2 = Sound("npc/infected/zombie_pain2.wav")
ENT.Pain3 = Sound("npc/infected/zombie_pain3.wav")
ENT.Pain4 = Sound("npc/infected/zombie_pain4.wav")
ENT.Pain5 = Sound("npc/infected/zombie_pain5.wav")
ENT.Pain6 = Sound("npc/infected/zombie_pain6.wav")

ENT.HitSound = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()

--Models--
util.PrecacheModel(self.Model)
util.PrecacheModel(self.Model2)
util.PrecacheModel(self.Model3)	
	
--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)
util.PrecacheSound(self.Death4)
util.PrecacheSound(self.Death5)
util.PrecacheSound(self.Death6)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)
util.PrecacheSound(self.Alert3)
util.PrecacheSound(self.Alert4)

util.PrecacheSound(self.Idle1)
util.PrecacheSound(self.Idle2)
util.PrecacheSound(self.Idle3)
util.PrecacheSound(self.Idle4)
util.PrecacheSound(self.Idle5)
util.PrecacheSound(self.Idle6)	
util.PrecacheSound(self.Idle7)
util.PrecacheSound(self.Idle8)
	
util.PrecacheSound(self.Pain1)
util.PrecacheSound(self.Pain2)
util.PrecacheSound(self.Pain3)
util.PrecacheSound(self.Pain4)	
util.PrecacheSound(self.Pain5)
util.PrecacheSound(self.Pain6)
	
util.PrecacheSound(self.HitSound)
util.PrecacheSound(self.Miss)

end

function ENT:Initialize()

	if SERVER then

	--Stats--
	self:SetHealth(self.health)	
	
	local model = math.random(1,10)
	if model == 1 then 
		self:SetModel(self.Model1)
	elseif model == 2 then 
		self:SetModel(self.Model2)
	elseif model == 3 then 
		self:SetModel(self.Model3)
	elseif model == 4 then 
		self:SetModel(self.Model4)
	elseif model == 5 then 
		self:SetModel(self.Model5)
	elseif model == 6 then 
		self:SetModel(self.Model6)
	elseif model == 7 then 
		self:SetModel(self.Model7)
	elseif model == 8 then 
		self:SetModel(self.Model8)
	elseif model == 9 then 
		self:SetModel(self.Model9)
	elseif model == 10 then 
		self:SetModel(self.Model10)
	end
	
	local anim = math.random(1,5)
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
	end
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	self.FakeDeath = false
	self.IsGrabbing = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(200)
	self.loco:SetDeceleration(900)
	
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

	if math.random(1,10) == 1 then
		self:PlaySequenceAndWait( self.TantrumAnim, 1 )
	else
		self:StartActivity( self.IdleAnim )
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

function ENT:FootSteps()
	self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
end

function ENT:AlertSound()
end

function ENT:AlertSound()
	local sounds = {}
		sounds[1] = (self.Alert1)
		sounds[2] = (self.Alert2)
		sounds[3] = (self.Alert3)
		sounds[4] = (self.Alert4)
		self:EmitSound( sounds[math.random(1,4)] )
end

function ENT:PainSound()
	if math.random(1,3) == 1 then
	local sounds = {}
		sounds[1] = (self.Pain1)
		sounds[2] = (self.Pain2)
		sounds[3] = (self.Pain3)
		sounds[4] = (self.Pain4)
		sounds[5] = (self.Pain5)
		sounds[6] = (self.Pain6)
		self:EmitSound( sounds[math.random(1,6)] )
	end
end

function ENT:DeathSound()
	local sounds = {}
		sounds[1] = (self.Death1)
		sounds[2] = (self.Death2)
		sounds[3] = (self.Death3)
		sounds[4] = (self.Death4)
		sounds[5] = (self.Death5)
		sounds[6] = (self.Death6)
		self:EmitSound( sounds[math.random(1,6)] )
end

function ENT:AttackSound()
	local sounds = {}
		sounds[1] = (self.Attack1)
		sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:IdleSound()
	local sounds = {}
		sounds[1] = (self.Idle1)
		sounds[2] = (self.Idle2)
		sounds[3] = (self.Idle3)
		sounds[4] = (self.Idle4)
		sounds[5] = (self.Idle5)
		sounds[6] = (self.Idle6)
		sounds[7] = (self.Idle7)
		sounds[8] = (self.Idle8)
		self:EmitSound( sounds[math.random(1,8)] )
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
		
		self.IsAttacking = false
		
		if self.Flinching then return end
	
		self:ResumeMovementFunctions()
		
	end)
end

function ENT:AttackEffect( time, ent, dmg, type, reset )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		if self.Flinching then return end
		
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
			if self.Flinching then return end
			self.IsAttacking = false
			self:ResumeMovementFunctions()
		end)
	end

end

function ENT:BleedEffect( ent )

	if self:CheckValid( ent ) then
	
		ent:TakeDamage(5, self)	
		ent:EmitSound("player/pl_pain"..math.random(5,7)..".wav", 70)
		
		if !ent:IsNPC() then
			ent:ViewPunch(Angle(math.random(-1, 1)*5, math.random(-1, 1)*5, math.random(-1, 1)*5))
		end
		
	else
		ent.IsBleeding = false
	end
	
end

function ENT:Bleed( ent )

	if ent.IsBleeding then return end
	
	ent.IsBleeding = true
	
	ent:TakeDamage( 5, self )
	
	timer.Simple(2, function() 
		ent.IsBleeding = false
	end)
	
	timer.Simple(0.5, function() 
		if ent:IsValid() and ent:Health() > 0 then
			if self:IsValid() and self:Health() > 0 then
				self:BleedEffect( ent )
			end
		end
	end)
	
	timer.Simple(1, function() 
		if ent:IsValid() and ent:Health() > 0 then
			if self:IsValid() and self:Health() > 0 then
				self:BleedEffect( ent )
			end
		end
	end)
	
	timer.Simple(1.5, function() 
		if ent:IsValid() and ent:Health() > 0 then
			if self:IsValid() and self:Health() > 0 then
				self:BleedEffect( ent )
			end
		end
	end)
	
end

function ENT:Slow( time, ent )

	if !ent.Slowed then
		local walk = ent:GetWalkSpeed()
		local run = ent:GetRunSpeed()
		ent.Slowed = true
			
		ent:SetWalkSpeed( 1 )
		ent:SetRunSpeed( 1 )		
					
		timer.Simple( time, function()
			ent.Slowed = false
			
			if !ent:IsValid() then return end
			if ent:Health() < 0 then return end
			
			ent:SetWalkSpeed( walk )
			ent:SetRunSpeed( run )
		end)
	end
	
end

function ENT:PlaySequence( string, cycle, rate, speed, time )
	self:ResetSequence( string )
	self:SetCycle( cycle )
	self:SetPlaybackRate( rate )
	self.loco:SetDesiredSpeed( speed )
end

function ENT:Grab( ent )
	if ent.Grabbed then return end
	
	self.IsGrabbing = true
	self:PlaySequence( self.GrabAnim, 0, 1, self.Speed - 20 )
	
	timer.Simple( 1.3, function() -- initial grab
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if self:GetRangeTo( ent ) < 40 then -- if the target is still in range then grab
			
			ent.Grabbed = true
			self:ResetSequence( self.HoldAnim )
			self:SetCycle( 0 )
			self:SetPlaybackRate( 1 )
			self:Slow( 2, ent )
			self:Bleed( ent )
			
			self:EmitSound( self.HitSound, 77 )
			ent:ViewPunch( Angle( math.random( 1,5 ), math.random( 1,5 ), math.random( 1,5 ) ) )
			
			timer.Simple( 2, function() -- duration of the grab
				ent.Grabbed = false
				if !self:IsValid() then return end
				if self:Health() < 0 then return end	
				
				self.IsGrabbing = false
				self.IsAttacking = false
				self:ResumeMovementFunctions()
			end)
			
		else -- if the target isn't in range then just resume coroutine
			self.IsGrabbing = false
			self.IsAttacking = false
			self:ResumeMovementFunctions()
		end
			
	end)
	
end

function ENT:Melee()
	self:AttackSound()
	self.IsAttacking = true

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
		
			if !self:CheckStatus() then return end
		
			if self.Enemy:IsNPC() then
				self:Melee()
			elseif self.Enemy:IsPlayer() then
				if self.Enemy.Grabbed then
					self:Melee()
				else
					self:Grab( self.Enemy )
				end
			end
			
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