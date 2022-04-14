if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_boss_zombine", {
	Name = "Zombine SS",
	Class = "nz_boss_zombine",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.FootAngles = 10
ENT.FootAngles2 = 10

ENT.MoveType = 2

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.ModelScale = 1.8 

ENT.Speed = 65
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 10

ENT.health = 2000
ENT.Damage = 45
ENT.HitPerDoor = 5

ENT.PhysForce = 30000
ENT.AttackRange = 65
ENT.InitialAttackRange = 75
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.5

--Model Settings--
ENT.Model = "models/zombie/zombineplayer.mdl"

ENT.WalkAnim = "zombie_cwalk_05"
ENT.AttackAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE 
ENT.IdleAnim = ACT_HL2MP_IDLE_CROUCH_ZOMBIE 

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
	self:SetModelScale( self.ModelScale, 0 )
	self:SetColor( Color( 255, 205, 205, 255 ) )
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Throwing = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(600)
	self.loco:SetDeceleration(600)
	
	--Misc--
	self:Precache()
	self:CreateBullseye()
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
	end
	
end

function ENT:IdleFunction()

	if ( self.NextIdle or 0 ) < CurTime() then
		
		self:StartActivity( self.IdleAnim )
		self:IdleSound()
		
		self.NextIdle = CurTime() + 5	
	end
	
end

function ENT:CustomDeath( dmginfo )
	self:DeathAnimation( "nz_deathanim_zss", self:GetPos(), ACT_HL2MP_WALK_CROUCH_ZOMBIE_05, self.ModelScale )
end

function ENT:ThrowGrenade( velocity )

	local ent = ents.Create("ent_nz_grenade")
	
	if ent:IsValid() and self:IsValid() then
		ent:SetPos(self:EyePos() + Vector(0,0,15) - ( self:GetRight() * 25 ) + ( self:GetForward() * 10 ) )
		ent:Spawn()
		ent:SetOwner( self )
				
		local phys = ent:GetPhysicsObject()
		
		if phys:IsValid() then
		
			local ang = self:EyeAngles()
			ang:RotateAroundAxis(ang:Forward(), math.Rand(-10, 10))
			ang:RotateAroundAxis(ang:Up(), math.Rand(-10, 10))
			phys:SetVelocityInstantaneous(ang:Forward() * math.Rand( velocity, velocity + 300 ))
				
		end
	end
	
end

function ENT:CustomChaseEnemy()

	local enemy = self:GetEnemy()

	if self.Attacking then return end
	
	if self:IsLineOfSightClear( enemy ) then
	
		if self:GetRangeTo( enemy ) > self.InitialAttackRange and self:GetRangeTo( enemy ) < 325 then
		
			if ( self.NextThrow or 0 ) < CurTime() then
	
				self:RestartGesture( ACT_GMOD_GESTURE_ITEM_THROW )
				self.Throwing = true
	
				timer.Simple( 0.6, function()
					if !self:IsValid() then return end
					if self:Health() < 0 then return end
					if self.Attacking then return end
					self:ThrowGrenade( math.random(500, 600) )
					self.Throwing = false
				end)
			
				self.NextThrow = CurTime() + 10	
			end
			
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
	
		self:EmitSound("kevlar/kevlar_hit"..math.random(2)..".wav", 65)
		
		if attacker:IsNPC() then
			dmginfo:ScaleDamage(0.75)
		else
			dmginfo:ScaleDamage(0.65)
		end
	
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

function ENT:EnrageSound()
	local sounds = {}
		sounds[1] = (self.Enrage1)
		sounds[2] = (self.Enrage2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:DeathSound()
end

function ENT:AttackSound()
	local sounds = {}
		sounds[1] = (self.Attack1)
		sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:IdleSound()
	if math.random(1,10) == 1 then
		local sounds = {}
		sounds[1] = (self.Idle1)
		sounds[2] = (self.Idle2)
		sounds[3] = (self.Idle3)
		sounds[4] = (self.Idle4)
		self:EmitSound( sounds[math.random(1,4)] )
	end
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

function ENT:AttackEffect( time, ent, dmg, type )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage( self.Damage, self )
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound( self.HitSound, 90, math.random(80,90) )
				
				local moveAdd=Vector(0,0,350)
					if not ent:IsOnGround() then
						moveAdd=Vector(0,0,0)
					end
				ent:SetVelocity( moveAdd + ( ( self.Enemy:GetPos() - self:GetPos() ):GetNormal() * 150 ) )
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

function ENT:Attack()

	if ( self.NextAttackTimer or 0 ) < CurTime() then	
	
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
			self:AttackSound()
			self.IsAttacking = true
			self:RestartGesture(self.AttackAnim)
		
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
list.Set( "NPC", "nz_boss_zombine", {
	Name = "Zombine SS",
	Class = "nz_boss_zombine",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.FootAngles = 10
ENT.FootAngles2 = 10

ENT.MoveType = 2

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.ModelScale = 1.8 

ENT.Speed = 65
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 10

ENT.health = 2000
ENT.Damage = 45
ENT.HitPerDoor = 5

ENT.PhysForce = 30000
ENT.AttackRange = 65
ENT.InitialAttackRange = 75
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.5

--Model Settings--
ENT.Model = "models/zombie/zombineplayer.mdl"

ENT.WalkAnim = "zombie_cwalk_05"
ENT.AttackAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE 
ENT.IdleAnim = ACT_HL2MP_IDLE_CROUCH_ZOMBIE 

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
	self:SetModelScale( self.ModelScale, 0 )
	self:SetColor( Color( 255, 205, 205, 255 ) )
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Throwing = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(600)
	self.loco:SetDeceleration(600)
	
	--Misc--
	self:Precache()
	self:CreateBullseye()
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
	end
	
end

function ENT:IdleFunction()

	if ( self.NextIdle or 0 ) < CurTime() then
		
		self:StartActivity( self.IdleAnim )
		self:IdleSound()
		
		self.NextIdle = CurTime() + 5	
	end
	
end

function ENT:CustomDeath( dmginfo )
	self:DeathAnimation( "nz_deathanim_zss", self:GetPos(), ACT_HL2MP_WALK_CROUCH_ZOMBIE_05, self.ModelScale )
end

function ENT:ThrowGrenade( velocity )

	local ent = ents.Create("ent_nz_grenade")
	
	if ent:IsValid() and self:IsValid() then
		ent:SetPos(self:EyePos() + Vector(0,0,15) - ( self:GetRight() * 25 ) + ( self:GetForward() * 10 ) )
		ent:Spawn()
		ent:SetOwner( self )
				
		local phys = ent:GetPhysicsObject()
		
		if phys:IsValid() then
		
			local ang = self:EyeAngles()
			ang:RotateAroundAxis(ang:Forward(), math.Rand(-10, 10))
			ang:RotateAroundAxis(ang:Up(), math.Rand(-10, 10))
			phys:SetVelocityInstantaneous(ang:Forward() * math.Rand( velocity, velocity + 300 ))
				
		end
	end
	
end

function ENT:CustomChaseEnemy()

	local enemy = self:GetEnemy()

	if self.Attacking then return end
	
	if self:IsLineOfSightClear( enemy ) then
	
		if self:GetRangeTo( enemy ) > self.InitialAttackRange and self:GetRangeTo( enemy ) < 325 then
		
			if ( self.NextThrow or 0 ) < CurTime() then
	
				self:RestartGesture( ACT_GMOD_GESTURE_ITEM_THROW )
				self.Throwing = true
	
				timer.Simple( 0.6, function()
					if !self:IsValid() then return end
					if self:Health() < 0 then return end
					if self.Attacking then return end
					self:ThrowGrenade( math.random(500, 600) )
					self.Throwing = false
				end)
			
				self.NextThrow = CurTime() + 10	
			end
			
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
	
		self:EmitSound("kevlar/kevlar_hit"..math.random(2)..".wav", 65)
		
		if attacker:IsNPC() then
			dmginfo:ScaleDamage(0.75)
		else
			dmginfo:ScaleDamage(0.65)
		end
	
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

function ENT:EnrageSound()
	local sounds = {}
		sounds[1] = (self.Enrage1)
		sounds[2] = (self.Enrage2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:DeathSound()
end

function ENT:AttackSound()
	local sounds = {}
		sounds[1] = (self.Attack1)
		sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:IdleSound()
	if math.random(1,10) == 1 then
		local sounds = {}
		sounds[1] = (self.Idle1)
		sounds[2] = (self.Idle2)
		sounds[3] = (self.Idle3)
		sounds[4] = (self.Idle4)
		self:EmitSound( sounds[math.random(1,4)] )
	end
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

function ENT:AttackEffect( time, ent, dmg, type )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage( self.Damage, self )
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound( self.HitSound, 90, math.random(80,90) )
				
				local moveAdd=Vector(0,0,350)
					if not ent:IsOnGround() then
						moveAdd=Vector(0,0,0)
					end
				ent:SetVelocity( moveAdd + ( ( self.Enemy:GetPos() - self:GetPos() ):GetNormal() * 150 ) )
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

function ENT:Attack()

	if ( self.NextAttackTimer or 0 ) < CurTime() then	
	
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
			self:AttackSound()
			self.IsAttacking = true
			self:RestartGesture(self.AttackAnim)
		
			self:AttackEffect( 0.9, self.Enemy, self.Damage, 0 )
		
		end
		
		self.NextAttackTimer = CurTime() + self.NextAttack
	end	
		
end