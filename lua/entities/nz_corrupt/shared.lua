if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_corrupt", {
	Name = "Type 2",
	Class = "nz_corrupt",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.Speed = 70
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 0

ENT.health = 200
ENT.Damage = 10

ENT.PhysForce = 15000
ENT.AttackRange = 55
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.5

--Model Settings--
ENT.Model = "models/corrupt/zombie_01.mdl"
ENT.Model2 = "models/corrupt/zombie_02.mdl"
ENT.Model3 = "models/corrupt/zombie_03.mdl"

ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

ENT.ThrowAnim = (ACT_GMOD_GESTURE_ITEM_THROW)
ENT.ThrowAnim2 = (ACT_GMOD_GESTURE_ITEM_GIVE)

ENT.WalkAnim = (ACT_HL2MP_WALK_ZOMBIE_01)
ENT.WalkAnim2 = (ACT_HL2MP_WALK_ZOMBIE_03)

ENT.FlinchAnim = (ACT_HL2MP_ZOMBIE_SLUMP_RISE)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("npc/infected/zo_attack1.wav")
ENT.Attack2 = Sound("npc/infected/zo_attack2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Alert1 = Sound("npc/infected/zombie_alert1.wav")
ENT.Alert2 = Sound("npc/infected/zombie_alert2.wav")
ENT.Alert3 = Sound("npc/infected/zombie_alert3.wav")
ENT.Alert4 = Sound("npc/infected/zombie_alert4.wav")

ENT.Death1 = Sound("npc/zombie/zombie_die1.wav")
ENT.Death2 = Sound("npc/zombie/zombie_die2.wav")
ENT.Death3 = Sound("npc/zombie/zombie_die3.wav")

ENT.Idle1 = Sound("npc/infected/zombie_voice_idle1.wav")
ENT.Idle2 = Sound("npc/infected/zombie_voice_idle2.wav")
ENT.Idle3 = Sound("npc/infected/zombie_voice_idle3.wav")
ENT.Idle4 = Sound("npc/infected/zombie_voice_idle4.wav")
ENT.Idle5 = Sound("npc/infected/zombie_voice_idle5.wav")
ENT.Idle6 = Sound("npc/infected/zombie_voice_idle6.wav")
ENT.Idle7 = Sound("npc/infected/zombie_voice_idle7.wav")
ENT.Idle8 = Sound("npc/infected/zombie_voice_idle8.wav")

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
util.PrecacheModel(self.Model2)
util.PrecacheModel(self.Model3)	
	
--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)
util.PrecacheSound(self.Alert3)
util.PrecacheSound(self.Alert4)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)

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
	
util.PrecacheSound(self.HitSound)
util.PrecacheSound(self.Miss)

end

function ENT:Initialize()

	if SERVER then

	--Stats--
	local model = math.random(1,3)
	if model == 1 then self:SetModel(self.Model)
	elseif model == 2 then self:SetModel(self.Model2)
	elseif model == 3 then self:SetModel(self.Model3)
	end
	
	local anim = math.random(1,4)
	if anim == 1 then
	self.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_01
	elseif anim == 2 then
	self.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_02
	elseif anim == 3 then
	self.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_03
	elseif anim == 4 then
	self.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_04
	elseif anim == 5 then
	self.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_04
	end

	self:SetHealth(self.health)	
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(400)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:Precache()
	self:CreateBullseye()
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
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
			
		if hitgroup == HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH then
		
			if attacker:IsNPC() then
				dmginfo:ScaleDamage(0.60)
			else
				dmginfo:ScaleDamage(0.50)
			end
		
			self:EjectBlood( dmginfo, 1, math.random(3,5) )
			
		elseif hitgroup == HITGROUP_HEAD then
		
			if attacker:IsNPC() then
				dmginfo:ScaleDamage(6)
			else
				dmginfo:ScaleDamage(5)
			end
			
		end
		
	end
	
end

function ENT:HealSound( time )
	timer.Simple( time, function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 92, math.Rand(85, 95))
		self:StartActivity(ACT_HL2MP_WALK_ZOMBIE_06)
	end)
end

function ENT:EjectBlood( dmginfo, amount, reduction )
	
	if ( self.NextEject or 0 ) < CurTime() then
	
		self:SetHealth( self:Health() + reduction )
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(85, 95))	
			
		for i=1,amount do
			local flesh = ents.Create("nz_projectile_blood") 
				if flesh:IsValid() then
					flesh:SetPos( self:GetPos() + Vector(0,0,30) )
					flesh:SetOwner(self)
					flesh:Spawn()
	
					local phys = flesh:GetPhysicsObject()
					if phys:IsValid() then
						local ang = self:EyeAngles()
						ang:RotateAroundAxis(ang:Forward(), math.Rand(-205, 205))
						ang:RotateAroundAxis(ang:Up(), math.Rand(-205, 205))
						phys:SetVelocityInstantaneous(ang:Forward() * math.Rand( 260, 360 ))
					end
				end
					
			end
		
		self.NextEject = CurTime() + 1	
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
		self:EmitSound( sounds[math.random(1,5)], 90, math.random(80,90) )
	end
end

function ENT:DeathSound()
	local sounds = {}
		sounds[1] = (self.Death1)
		sounds[2] = (self.Death2)
		sounds[3] = (self.Death3)
		self:EmitSound( sounds[math.random(1,3)], 90, math.random(80,90) )
end

function ENT:AttackSound()
	local sounds = {}
		sounds[1] = (self.Attack1)
		sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)], 90, math.random(80,90) )
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

function ENT:CustomChaseEnemy()
end

function ENT:CustomWander()
	self:StartActivity(ACT_IDLE)
end

function ENT:CustomDoorAttack( ent )

	if ( self.NextDoorAttackTimer or 0 ) < CurTime() then

		self:AttackSound()
		self:RestartGesture(self.AttackAnim)  
	
		self:AttackEffect( 0.9, ent, self.Damage, 2 )
	
		self.NextDoorAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then

		self:AttackSound()
		self:RestartGesture(self.AttackAnim)  
	
		self:AttackEffect( 0.9, ent, self.Damage, 1 )
	
		self.NextPropAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:RangeAttack( ent )
	
	if !self:CheckStatus() then return end

	local anim = math.random(1,2)
	if anim == 1 then self:RestartGesture( self.ThrowAnim )
	elseif anim == 2 then self:RestartGesture( self.ThrowAnim2 )
	end
	
	self.loco:SetDesiredSpeed( self.Speed - 30 )
	
	timer.Simple( 0.8, function()
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	if !self:CheckStatus() then return end
	
	self.loco:SetDesiredSpeed( self.Speed )
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(85, 95))	
	
	local flesh = ents.Create("nz_projectile_blood") 
		if flesh:IsValid() then
		flesh:SetPos( self:GetPos() + Vector(0,5,50) )
		flesh:SetOwner(self)
		flesh:Spawn()
	
			local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
			local ang = self:EyeAngles()
			ang:RotateAroundAxis(ang:Forward(), math.Rand(-10, 10))
			ang:RotateAroundAxis(ang:Up(), math.Rand(-10, 10))
			phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(525, 790))
			end
		end
		
	end)
	
end

function ENT:Corrupt( ent )

	if !self:CheckStatus() then return end

	timer.Simple( 2.2, function()
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	if !self:CheckValid( ent ) then return end
	if !self:CheckStatus() then return end
	
	for i=1,2 do
	local flesh = ents.Create("nz_projectile_blood") 
		if flesh:IsValid() then
		flesh:SetPos( ent:GetPos() + Vector(0,0,50) )
		flesh:SetOwner(self)
		flesh:Spawn()
		
			local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
			local ang = self:EyeAngles()
			ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
			ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
			phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(525, 790))
			end
		end
	end
	
	self:BleedVisual( 0.4, self:GetPos() + Vector(0,0,50) )
	
	ent:TakeDamage( 5, self )
	ent:EmitSound("player/pl_pain"..math.random(5,7)..".wav", 70)
	
	end)	

end

function ENT:AttackEffect( time, ent, dmg, type )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		if !self:CheckStatus() then return end	
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage(dmg, self)	
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound(self.HitSound)
				self:Corrupt( ent )
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
		self.IsAttacking = false
	end)

end

function ENT:MeleeAttack( ent )

	if !self:CheckStatus() then return end

	self:RestartGesture( self.AttackAnim )
	
	self:AttackEffect( 0.9, self.Enemy, self.Damage, 0 )
	
end

function ENT:Attack()
		
	if ( self.NextAttackTimer or 0 ) < CurTime() then	
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
			if !self:CheckStatus() then return end	
		
			self:AttackSound()
		
			local attack = math.random(1,2)
			if attack == 1 then self:MeleeAttack( self.Enemy )
			elseif attack == 2 then self:RangeAttack( self.Enemy )
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
list.Set( "NPC", "nz_corrupt", {
	Name = "Type 2",
	Class = "nz_corrupt",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.Speed = 70
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 0

ENT.health = 200
ENT.Damage = 10

ENT.PhysForce = 15000
ENT.AttackRange = 55
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.5

--Model Settings--
ENT.Model = "models/corrupt/zombie_01.mdl"
ENT.Model2 = "models/corrupt/zombie_02.mdl"
ENT.Model3 = "models/corrupt/zombie_03.mdl"

ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

ENT.ThrowAnim = (ACT_GMOD_GESTURE_ITEM_THROW)
ENT.ThrowAnim2 = (ACT_GMOD_GESTURE_ITEM_GIVE)

ENT.WalkAnim = (ACT_HL2MP_WALK_ZOMBIE_01)
ENT.WalkAnim2 = (ACT_HL2MP_WALK_ZOMBIE_03)

ENT.FlinchAnim = (ACT_HL2MP_ZOMBIE_SLUMP_RISE)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("npc/infected/zo_attack1.wav")
ENT.Attack2 = Sound("npc/infected/zo_attack2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Alert1 = Sound("npc/infected/zombie_alert1.wav")
ENT.Alert2 = Sound("npc/infected/zombie_alert2.wav")
ENT.Alert3 = Sound("npc/infected/zombie_alert3.wav")
ENT.Alert4 = Sound("npc/infected/zombie_alert4.wav")

ENT.Death1 = Sound("npc/zombie/zombie_die1.wav")
ENT.Death2 = Sound("npc/zombie/zombie_die2.wav")
ENT.Death3 = Sound("npc/zombie/zombie_die3.wav")

ENT.Idle1 = Sound("npc/infected/zombie_voice_idle1.wav")
ENT.Idle2 = Sound("npc/infected/zombie_voice_idle2.wav")
ENT.Idle3 = Sound("npc/infected/zombie_voice_idle3.wav")
ENT.Idle4 = Sound("npc/infected/zombie_voice_idle4.wav")
ENT.Idle5 = Sound("npc/infected/zombie_voice_idle5.wav")
ENT.Idle6 = Sound("npc/infected/zombie_voice_idle6.wav")
ENT.Idle7 = Sound("npc/infected/zombie_voice_idle7.wav")
ENT.Idle8 = Sound("npc/infected/zombie_voice_idle8.wav")

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
util.PrecacheModel(self.Model2)
util.PrecacheModel(self.Model3)	
	
--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)
util.PrecacheSound(self.Alert3)
util.PrecacheSound(self.Alert4)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)

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
	
util.PrecacheSound(self.HitSound)
util.PrecacheSound(self.Miss)

end

function ENT:Initialize()

	if SERVER then

	--Stats--
	local model = math.random(1,3)
	if model == 1 then self:SetModel(self.Model)
	elseif model == 2 then self:SetModel(self.Model2)
	elseif model == 3 then self:SetModel(self.Model3)
	end
	
	local anim = math.random(1,4)
	if anim == 1 then
	self.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_01
	elseif anim == 2 then
	self.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_02
	elseif anim == 3 then
	self.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_03
	elseif anim == 4 then
	self.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_04
	elseif anim == 5 then
	self.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_04
	end

	self:SetHealth(self.health)	
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(400)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:Precache()
	self:CreateBullseye()
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
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
			
		if hitgroup == HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH then
		
			if attacker:IsNPC() then
				dmginfo:ScaleDamage(0.60)
			else
				dmginfo:ScaleDamage(0.50)
			end
		
			self:EjectBlood( dmginfo, 1, math.random(3,5) )
			
		elseif hitgroup == HITGROUP_HEAD then
		
			if attacker:IsNPC() then
				dmginfo:ScaleDamage(6)
			else
				dmginfo:ScaleDamage(5)
			end
			
		end
		
	end
	
end

function ENT:HealSound( time )
	timer.Simple( time, function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 92, math.Rand(85, 95))
		self:StartActivity(ACT_HL2MP_WALK_ZOMBIE_06)
	end)
end

function ENT:EjectBlood( dmginfo, amount, reduction )
	
	if ( self.NextEject or 0 ) < CurTime() then
	
		self:SetHealth( self:Health() + reduction )
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(85, 95))	
			
		for i=1,amount do
			local flesh = ents.Create("nz_projectile_blood") 
				if flesh:IsValid() then
					flesh:SetPos( self:GetPos() + Vector(0,0,30) )
					flesh:SetOwner(self)
					flesh:Spawn()
	
					local phys = flesh:GetPhysicsObject()
					if phys:IsValid() then
						local ang = self:EyeAngles()
						ang:RotateAroundAxis(ang:Forward(), math.Rand(-205, 205))
						ang:RotateAroundAxis(ang:Up(), math.Rand(-205, 205))
						phys:SetVelocityInstantaneous(ang:Forward() * math.Rand( 260, 360 ))
					end
				end
					
			end
		
		self.NextEject = CurTime() + 1	
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
		self:EmitSound( sounds[math.random(1,5)], 90, math.random(80,90) )
	end
end

function ENT:DeathSound()
	local sounds = {}
		sounds[1] = (self.Death1)
		sounds[2] = (self.Death2)
		sounds[3] = (self.Death3)
		self:EmitSound( sounds[math.random(1,3)], 90, math.random(80,90) )
end

function ENT:AttackSound()
	local sounds = {}
		sounds[1] = (self.Attack1)
		sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)], 90, math.random(80,90) )
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

function ENT:CustomChaseEnemy()
end

function ENT:CustomWander()
	self:StartActivity(ACT_IDLE)
end

function ENT:CustomDoorAttack( ent )

	if ( self.NextDoorAttackTimer or 0 ) < CurTime() then

		self:AttackSound()
		self:RestartGesture(self.AttackAnim)  
	
		self:AttackEffect( 0.9, ent, self.Damage, 2 )
	
		self.NextDoorAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then

		self:AttackSound()
		self:RestartGesture(self.AttackAnim)  
	
		self:AttackEffect( 0.9, ent, self.Damage, 1 )
	
		self.NextPropAttackTimer = CurTime() + self.NextAttack
	end
	
end

function ENT:RangeAttack( ent )
	
	if !self:CheckStatus() then return end

	local anim = math.random(1,2)
	if anim == 1 then self:RestartGesture( self.ThrowAnim )
	elseif anim == 2 then self:RestartGesture( self.ThrowAnim2 )
	end
	
	self.loco:SetDesiredSpeed( self.Speed - 30 )
	
	timer.Simple( 0.8, function()
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	if !self:CheckStatus() then return end
	
	self.loco:SetDesiredSpeed( self.Speed )
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(85, 95))	
	
	local flesh = ents.Create("nz_projectile_blood") 
		if flesh:IsValid() then
		flesh:SetPos( self:GetPos() + Vector(0,5,50) )
		flesh:SetOwner(self)
		flesh:Spawn()
	
			local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
			local ang = self:EyeAngles()
			ang:RotateAroundAxis(ang:Forward(), math.Rand(-10, 10))
			ang:RotateAroundAxis(ang:Up(), math.Rand(-10, 10))
			phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(525, 790))
			end
		end
		
	end)
	
end

function ENT:Corrupt( ent )

	if !self:CheckStatus() then return end

	timer.Simple( 2.2, function()
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	if !self:CheckValid( ent ) then return end
	if !self:CheckStatus() then return end
	
	for i=1,2 do
	local flesh = ents.Create("nz_projectile_blood") 
		if flesh:IsValid() then
		flesh:SetPos( ent:GetPos() + Vector(0,0,50) )
		flesh:SetOwner(self)
		flesh:Spawn()
		
			local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
			local ang = self:EyeAngles()
			ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
			ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
			phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(525, 790))
			end
		end
	end
	
	self:BleedVisual( 0.4, self:GetPos() + Vector(0,0,50) )
	
	ent:TakeDamage( 5, self )
	ent:EmitSound("player/pl_pain"..math.random(5,7)..".wav", 70)
	
	end)	

end

function ENT:AttackEffect( time, ent, dmg, type )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		if !self:CheckStatus() then return end	
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage(dmg, self)	
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound(self.HitSound)
				self:Corrupt( ent )
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
		self.IsAttacking = false
	end)

end

function ENT:MeleeAttack( ent )

	if !self:CheckStatus() then return end

	self:RestartGesture( self.AttackAnim )
	
	self:AttackEffect( 0.9, self.Enemy, self.Damage, 0 )
	
end

function ENT:Attack()
		
	if ( self.NextAttackTimer or 0 ) < CurTime() then	
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
			if !self:CheckStatus() then return end	
		
			self:AttackSound()
		
			local attack = math.random(1,2)
			if attack == 1 then self:MeleeAttack( self.Enemy )
			elseif attack == 2 then self:RangeAttack( self.Enemy )
			end
		
		end
		
		self.NextAttackTimer = CurTime() + self.NextAttack
	end		
		
end