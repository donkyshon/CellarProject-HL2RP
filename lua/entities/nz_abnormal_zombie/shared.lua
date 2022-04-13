if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_abnormal_zombie", {
	Name = "Abnormal Zombie",
	Class = "nz_abnormal_zombie",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.CollisionHeight = 46
ENT.CollisionSide = 7

ENT.FootAngles = 5

ENT.Speed = 65
ENT.FlinchSpeed = 0

ENT.health = 500
ENT.Damage = 30

ENT.PhysForce = 9000
ENT.AttackRange = 54
ENT.InitialAttackRange = 50
ENT.DoorAttackRange = 20

ENT.AttackWaitTime = 0.9
ENT.AttackFinishTime = 0.2

--Model Settings--
ENT.Model = "models/Zombie/poison.mdl"

ENT.AttackAnim = (ACT_MELEE_ATTACK1)

ENT.WalkAnim = (ACT_WALK)
ENT.FlinchAnim = (ACT_SMALL_FLINCH)
ENT.IdleAnim = (ACT_IDLE)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("npc/zombie_poison/pz_warn1.wav")
ENT.Attack2 = Sound("npc/zombie_poison/pz_warn2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Alert1 = Sound("npc/zombie_poison/pz_alert1.wav")
ENT.Alert2 = Sound("npc/zombie_poison/pz_alert2.wav")

ENT.Death1 = Sound("npc/zombie_poison/pz_die1.wav")
ENT.Death2 = Sound("npc/zombie_poison/pz_die2.wav")

ENT.Pain1 = Sound("npc/zombie_poison/pz_pain1.wav")
ENT.Pain2 = Sound("npc/zombie_poison/pz_pain2.wav")
ENT.Pain3 = Sound("npc/zombie_poison/pz_pain3.wav")

ENT.HitSound = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()

--Models--
util.PrecacheModel(self.Model)
	
--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
	
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
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(200)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:Precache()
	self:CreateBullseye( 30 )
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
	end
	
end

function ENT:IdleFunction()

	if ( self.NextIdleFunction or 0 ) < CurTime() then
	
		self:StartActivity( self.IdleAnim )
	
		self.NextIdleFunction = CurTime() + 3
	end
	
end

function ENT:CheckStatus( attacking )

	if self.Flinching then
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
			self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,35) )
		end
	
	end

	self:MorphRagdoll( dmginfo )
end

function ENT:Flinch()
	
	if ( self.NextFlinch or 0 ) < CurTime() then
	
		if !self:CheckValid( self ) then return end
		if self.Flinching then return end
	
		self:StartActivity( self.FlinchAnim )	
		self:SetPlaybackRate( 0.6 )
		self.loco:SetDesiredSpeed( self.FlinchSpeed )
	
		self.Flinching = true
		self:PainSound()
	
		timer.Simple(0.9, function() 
			if !self:IsValid() then return end
			if self:Health() < 0 then return end
	
			self.loco:SetDesiredSpeed( self.Speed )	
			self:StartActivity(self.WalkAnim)
	
			self.Flinching = false
		end)
		
		self.NextFlinch = CurTime() + 2	
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
				dmginfo:ScaleDamage(3)
			else
				dmginfo:ScaleDamage(2)
			end
		else
			if attacker:IsNPC() then
				dmginfo:ScaleDamage(0.50)
			else
				dmginfo:ScaleDamage(0.40)
			end
		end
		
		if dmginfo:GetDamage() > 10 then
			self:Flinch()
		end
		
	end

end

function ENT:FootSteps()
	self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
	
	timer.Simple(0.5, function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if self.IsAttacking then return end
		self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
	end)
end

function ENT:AlertSound()
	local sounds = {}
		sounds[1] = (self.Alert1)
		sounds[2] = (self.Alert2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:PainSound()
	if self.Flinching then
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
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:AttackSound()
	local sounds = {}
		sounds[1] = (self.Attack1)
		sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:IdleSound()
end

function ENT:BleedEffect( ent )

	if self:CheckValid( ent ) then
	
		ent:TakeDamage(10, self)	
		ent:EmitSound("player/pl_pain"..math.random(5,7)..".wav", 70)
		
		if !ent:IsNPC() then
			ent:ViewPunch(Angle(math.random(-1, 1)*5, math.random(-1, 1)*5, math.random(-1, 1)*5))
		end
	
		self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,5) )
	else
		ent.IsBleeding = false
	end
	
end

function ENT:Bleed( ent )

	if ent.IsBleeding then return end
	ent.IsBleeding = true
	
	timer.Simple(2, function() 
		ent.IsBleeding = false
	end)
	
	timer.Simple(2, function() 
		if ent:IsValid() and ent:Health() > 0 then
			if self:IsValid() and self:Health() > 0 then
				self:BleedEffect( ent )
			end
		end
	end)
	
end

function ENT:CustomDoorAttack( ent )

	if ( self.NextDoorAttackTimer or 0 ) < CurTime() then

		self:AttackSound()
		self:StartActivity(self.AttackAnim)  
	
		self:AttackEffect( 0.9, ent, self.Damage, 2 )
	
		self.NextDoorAttackTimer = CurTime() + self.NextAttack
	end
	
end
	
function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then

		self:AttackSound()
		self:StartActivity(self.AttackAnim)  
	
		self:AttackEffect( 0.9, ent, self.Damage, 1 )
	
		self.NextPropAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:AttackEffect( time, ent, dmg, type )

	self.loco:SetDesiredSpeed( 0 )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		if !self:CheckStatus( 1 ) then return end
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage( self.Damage, self )
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound( self.HitSound )
				self:Bleed( ent )
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
		if !self:CheckStatus( 1 ) then return end
		
		self.IsAttacking = false
		self:ResumeMovementFunctions()
	end)

end

function ENT:Attack()

	if ( self.NextAttackTimer or 0 ) < CurTime() then	
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
			self:AttackSound()
			self.IsAttacking = true
			self:StartActivity(self.AttackAnim)
		
			self:AttackEffect( 0.9, self.Enemy, self.Damage, 0 )
		
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
list.Set( "NPC", "nz_abnormal_zombie", {
	Name = "Abnormal Zombie",
	Class = "nz_abnormal_zombie",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.CollisionHeight = 46
ENT.CollisionSide = 7

ENT.FootAngles = 5

ENT.Speed = 65
ENT.FlinchSpeed = 0

ENT.health = 500
ENT.Damage = 30

ENT.PhysForce = 9000
ENT.AttackRange = 54
ENT.InitialAttackRange = 50
ENT.DoorAttackRange = 20

ENT.AttackWaitTime = 0.9
ENT.AttackFinishTime = 0.2

--Model Settings--
ENT.Model = "models/Zombie/poison.mdl"

ENT.AttackAnim = (ACT_MELEE_ATTACK1)

ENT.WalkAnim = (ACT_WALK)
ENT.FlinchAnim = (ACT_SMALL_FLINCH)
ENT.IdleAnim = (ACT_IDLE)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("npc/zombie_poison/pz_warn1.wav")
ENT.Attack2 = Sound("npc/zombie_poison/pz_warn2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Alert1 = Sound("npc/zombie_poison/pz_alert1.wav")
ENT.Alert2 = Sound("npc/zombie_poison/pz_alert2.wav")

ENT.Death1 = Sound("npc/zombie_poison/pz_die1.wav")
ENT.Death2 = Sound("npc/zombie_poison/pz_die2.wav")

ENT.Pain1 = Sound("npc/zombie_poison/pz_pain1.wav")
ENT.Pain2 = Sound("npc/zombie_poison/pz_pain2.wav")
ENT.Pain3 = Sound("npc/zombie_poison/pz_pain3.wav")

ENT.HitSound = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()

--Models--
util.PrecacheModel(self.Model)
	
--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
	
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
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(200)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:Precache()
	self:CreateBullseye( 30 )
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
	end
	
end

function ENT:IdleFunction()

	if ( self.NextIdleFunction or 0 ) < CurTime() then
	
		self:StartActivity( self.IdleAnim )
	
		self.NextIdleFunction = CurTime() + 3
	end
	
end

function ENT:CheckStatus( attacking )

	if self.Flinching then
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
			self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,35) )
		end
	
	end

	self:MorphRagdoll( dmginfo )
end

function ENT:Flinch()
	
	if ( self.NextFlinch or 0 ) < CurTime() then
	
		if !self:CheckValid( self ) then return end
		if self.Flinching then return end
	
		self:StartActivity( self.FlinchAnim )	
		self:SetPlaybackRate( 0.6 )
		self.loco:SetDesiredSpeed( self.FlinchSpeed )
	
		self.Flinching = true
		self:PainSound()
	
		timer.Simple(0.9, function() 
			if !self:IsValid() then return end
			if self:Health() < 0 then return end
	
			self.loco:SetDesiredSpeed( self.Speed )	
			self:StartActivity(self.WalkAnim)
	
			self.Flinching = false
		end)
		
		self.NextFlinch = CurTime() + 2	
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
				dmginfo:ScaleDamage(3)
			else
				dmginfo:ScaleDamage(2)
			end
		else
			if attacker:IsNPC() then
				dmginfo:ScaleDamage(0.50)
			else
				dmginfo:ScaleDamage(0.40)
			end
		end
		
		if dmginfo:GetDamage() > 10 then
			self:Flinch()
		end
		
	end

end

function ENT:FootSteps()
	self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
	
	timer.Simple(0.5, function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if self.IsAttacking then return end
		self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
	end)
end

function ENT:AlertSound()
	local sounds = {}
		sounds[1] = (self.Alert1)
		sounds[2] = (self.Alert2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:PainSound()
	if self.Flinching then
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
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:AttackSound()
	local sounds = {}
		sounds[1] = (self.Attack1)
		sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:IdleSound()
end

function ENT:BleedEffect( ent )

	if self:CheckValid( ent ) then
	
		ent:TakeDamage(10, self)	
		ent:EmitSound("player/pl_pain"..math.random(5,7)..".wav", 70)
		
		if !ent:IsNPC() then
			ent:ViewPunch(Angle(math.random(-1, 1)*5, math.random(-1, 1)*5, math.random(-1, 1)*5))
		end
	
		self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,5) )
	else
		ent.IsBleeding = false
	end
	
end

function ENT:Bleed( ent )

	if ent.IsBleeding then return end
	ent.IsBleeding = true
	
	timer.Simple(2, function() 
		ent.IsBleeding = false
	end)
	
	timer.Simple(2, function() 
		if ent:IsValid() and ent:Health() > 0 then
			if self:IsValid() and self:Health() > 0 then
				self:BleedEffect( ent )
			end
		end
	end)
	
end

function ENT:CustomDoorAttack( ent )

	if ( self.NextDoorAttackTimer or 0 ) < CurTime() then

		self:AttackSound()
		self:StartActivity(self.AttackAnim)  
	
		self:AttackEffect( 0.9, ent, self.Damage, 2 )
	
		self.NextDoorAttackTimer = CurTime() + self.NextAttack
	end
	
end
	
function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then

		self:AttackSound()
		self:StartActivity(self.AttackAnim)  
	
		self:AttackEffect( 0.9, ent, self.Damage, 1 )
	
		self.NextPropAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:AttackEffect( time, ent, dmg, type )

	self.loco:SetDesiredSpeed( 0 )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		if !self:CheckStatus( 1 ) then return end
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage( self.Damage, self )
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound( self.HitSound )
				self:Bleed( ent )
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
		if !self:CheckStatus( 1 ) then return end
		
		self.IsAttacking = false
		self:ResumeMovementFunctions()
	end)

end

function ENT:Attack()

	if ( self.NextAttackTimer or 0 ) < CurTime() then	
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
			self:AttackSound()
			self.IsAttacking = true
			self:StartActivity(self.AttackAnim)
		
			self:AttackEffect( 0.9, self.Enemy, self.Damage, 0 )
		
		end
		
		self.NextAttackTimer = CurTime() + self.NextAttack
	end	
		
end