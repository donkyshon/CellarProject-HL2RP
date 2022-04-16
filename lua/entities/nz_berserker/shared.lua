if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_berserker", {
	Name = "Berserker",
	Class = "nz_berserker",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.ModelScale = 1.2

ENT.Speed = 155
ENT.WalkSpeedAnimation = 0.9
ENT.FlinchSpeed = 20

ENT.health = 1000
ENT.Damage = 35
ENT.HitPerDoor = 10

ENT.PhysForce = 20000
ENT.AttackRange = 65
ENT.InitialAttackRange = 80
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.3

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

ENT.AttackAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL 

ENT.IdleAnim = ACT_HL2MP_RUN_ZOMBIE_FAST
ENT.TantrumAnim = "tantrum"

ENT.WalkAnim = ACT_HL2MP_RUN_CHARGING

ENT.ChestFlinch1 = "physflinch1"
ENT.ChestFlinch2 = "physflinch2"
ENT.ChestFlinch3 = "physflinch3"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"

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
	
	self:SetModelScale( self.ModelScale, 0 )
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	--self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	self.FakeDeath = false
	self.Flinching = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(400)
	self.loco:SetDeceleration(800)
	
	--Misc--
	self:Precache()
	self:CreateBullseye()
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
	self:ManipulateBoneScale(self:LookupBone("ValveBiped.Bip01_R_Forearm"), Vector(1.5, 1.5, 1.5))
	self:ManipulateBoneScale(self:LookupBone("ValveBiped.Bip01_L_Forearm"), Vector(1.5, 1.5, 1.5))
	
	self:ManipulateBoneScale(self:LookupBone("ValveBiped.Bip01_R_Upperarm"), Vector(1.5, 1.5, 1.5))
	self:ManipulateBoneScale(self:LookupBone("ValveBiped.Bip01_L_Upperarm"), Vector(1.5, 1.5, 1.5))
	
	end
	
end

function ENT:CheckStatus()

	if self.Flinching then
		return false
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
	
	self:DeathAnimation( "nz_deathanim_berserker", self:GetPos(), ACT_HL2MP_RUN_ZOMBIE, self.ModelScale )

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
				dmginfo:ScaleDamage(4)
			else
				dmginfo:ScaleDamage(3)
			end
		end
	elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
		if attacker:IsNPC() then
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(0.50)
			else
				dmginfo:ScaleDamage(0.40)
			end
		else
			if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(0.40)
			else
				dmginfo:ScaleDamage(0.30)
			end
		end
	else
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
	end
		
		if dmginfo:GetDamage() > 45 then
			self:Flinch( dmginfo, hitgroup )
		end
		
	end
		
	if dmginfo:IsExplosionDamage() then
		self:Flinch( dmginfo )
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
	
		if !hitgroup then
	
			local anim = math.random(1,2)
			if anim == 1 then
				self:PlayFlinchSequence( self.RLegFlinch, 1, 0, 0, 1.6 )
			elseif anim == 2 then
				self:PlayFlinchSequence( self.LLegFlinch, 1, 0, 0, 2.5 )
			end
	
		else
	
			if hitgroup == HITGROUP_HEAD then
				self:PlayFlinchSequence( self.HeadFlinch, 1, 0, 0, 0.7 )
				self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
			elseif hitgroup == HITGROUP_LEFTLEG then
				self:PlayFlinchSequence( self.LLegFlinch, 1, 0, 0, 2.5 )
			elseif hitgroup == HITGROUP_RIGHTLEG then
				self:PlayFlinchSequence( self.RLegFlinch, 1, 0, 0, 1.6 )
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
		self:EmitSound( sounds[math.random(1,6)], 88, math.random(80,90) )
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
		self:EmitSound( sounds[math.random(1,6)], 88, math.random(80,90) )
end

function ENT:AttackSound()
	local sounds = {}
		sounds[1] = (self.Attack1)
		sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)], 88, math.random(80,90) )
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
		self:EmitSound( sounds[math.random(1,8)], 88, math.random(80,90) )
end

function ENT:CustomDoorAttack( ent )

	if ( self.NextDoorAttackTimer or 0 ) < CurTime() then

		self:RestartGesture( self.AttackAnim )
		self:AttackEffect( 1, ent, self.Damage, 2, 0 )
	
		self.NextDoorAttackTimer = CurTime() + self.NextAttack
	end
	
end
	
function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then
	
		self:RestartGesture( self.AttackAnim )
		self:AttackEffect( 1, ent, self.Damage, 1, 0 )
	
		self.NextPropAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:AttackEffect( time, ent, dmg, type, reset )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		if !self:CheckStatus() then return end
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage(dmg, self)	
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound("npc/zombie/claw_strike"..math.random(2)..".wav", 77, math.random(60, 70))
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
		
		timer.Simple( time + 0.6, function()
			if !self:IsValid() then return end
			if self:Health() < 0 then return end
			if !self:CheckStatus() then return end
			self.IsAttacking = false
		end)

end

function ENT:Attack()

	if ( self.NextAttackTimer or 0 ) < CurTime() then	
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
			if !self:CheckStatus() then return end
			
			self.IsAttacking = true
			self:AttackSound()
			
			self:RestartGesture( self.AttackAnim )
			self:AttackEffect( 1, self.Enemy, self.Damage, 0, 0 )
		
		end
		
		self.NextAttackTimer = CurTime() + self.NextAttack
	end	
		
end

function ENT:CustomChaseEnemy()

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