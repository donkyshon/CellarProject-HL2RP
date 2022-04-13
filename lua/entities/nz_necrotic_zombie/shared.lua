if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_necrotic_zombie", {
	Name = "Necrotic Zombie",
	Class = "nz_necrotic_zombie",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.Speed = 85
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 40

ENT.health = 200
ENT.Damage = 10

ENT.PhysForce = 13000
ENT.AttackRange = 60
ENT.DoorAttackRange = 25

ENT.NextAttack = 2

--Model Settings--
ENT.Model = "models/player/zombie_fast.mdl"

ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL)

ENT.WalkAnim = (ACT_HL2MP_WALK_ZOMBIE_06)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Death1 = Sound("npc/zombie/zombie_die1.wav")
ENT.Death2 = Sound("npc/zombie/zombie_die2.wav")
ENT.Death3 = Sound("npc/zombie/zombie_die3.wav")

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
	
util.PrecacheSound(self.HitSound)
util.PrecacheSound(self.Miss)

end

function ENT:Initialize()

	if SERVER then

	--Stats--
	self:SetModel(self.Model)
	self:SetHealth(self.health)	
	
	self:SetColor(Color(205,255,205))
	self:SetModelScale( 1.1, 0 )
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(100)
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
	
		if hitgroup == HITGROUP_HEAD then
			if attacker:IsNPC() then
				if dmginfo:GetDamageType() == DMG_BUCKSHOT then
					dmginfo:ScaleDamage(3)
				else
					dmginfo:ScaleDamage(2)
				end
			else
				if dmginfo:GetDamageType() == DMG_BUCKSHOT then
					dmginfo:ScaleDamage(2)
				else
					dmginfo:ScaleDamage(1)
				end
			end
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
		
		if dmginfo:GetDamage() > 8 then
			self:EjectBlood( dmginfo, math.random(2,3), 4 )
		end
		
	end

end

ENT.nxtEjectBlood = 0
function ENT:EjectBlood( dmginfo, amount, reduction )
	
	if !self.nxtEjectBlood then self.nxtEjectBlood = 0 end
    if CurTime() < self.nxtEjectBlood then return end

    self.nxtEjectBlood = CurTime() + 2
	
	dmginfo:SubtractDamage( reduction )
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 92, math.Rand(85, 95))
			
	for i=1,amount do
		local flesh = ents.Create("nz_projectile_necrotic") 
		if flesh:IsValid() then
			flesh:SetPos( dmginfo:GetDamagePosition() )
			flesh:SetOwner( self )
			flesh:Spawn()
	
			local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-205, 205))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-205, 205))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand( 360, 490 ))
			end
		end	
	end
	
end

function ENT:FootSteps()
	self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
end

function ENT:AlertSound()
end

function ENT:PainSound()
end

function ENT:DeathSound()
	self:EmitSound("npc/barnacle/barnacle_digesting2.wav")
end

function ENT:AttackSound()
end

function ENT:IdleSound()
end

function ENT:IdleSounds()
end

function ENT:BleedEffect( ent )

	if self:CheckValid( ent ) then
	
		self:NecroticDamage( ent, 10, dmginfo )
		ent:EmitSound("player/pl_pain"..math.random(5,7)..".wav", 70)
		
		if !ent:IsNPC() then
		ent:ViewPunch(Angle(math.random(-1, 1)*5, math.random(-1, 1)*5, math.random(-1, 1)*5))
		end
	
		self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
		
	else
		ent.IsBleeding = false
	end
	
end

function ENT:Bleed( ent )

	if ent.IsBleeding then return end
	ent.IsBleeding = true
	
	timer.Simple(6, function() 
		ent.IsBleeding = false
	end)
	
	timer.Simple(2, function() 
		if ent:IsValid() and ent:Health() > 0 then
			if self:IsValid() and self:Health() > 0 then
				self:BleedEffect( ent )
			end
		end
	end)
	
	timer.Simple(4, function() 
		if ent:IsValid() and ent:Health() > 0 then
			if self:IsValid() and self:Health() > 0 then
				self:BleedEffect( ent )
			end
		end
	end)
	
	timer.Simple(6, function() 
		if ent:IsValid() and ent:Health() > 0 then
			if self:IsValid() and self:Health() > 0 then
				self:BleedEffect( ent )
			end
		end
	end)
	
end

function ENT:NecroticDamage( ent, damage, dmginfo )
	local necrotic = DamageInfo()
	necrotic:SetDamageType(DMG_ACID)
	
	ent:TakeDamageInfo(necrotic, self)
	ent:TakeDamage(damage, self)	
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
			
			self:NecroticDamage( ent, dmg, dmginfo )	
			
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
	
	timer.Simple( time + 0.1, function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		self.IsAttacking = false
	end)

end

function ENT:Attack()

	if ( self.NextAttackTimer or 0 ) < CurTime() then	
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
			self:AttackSound()
	
			self:RestartGesture(self.AttackAnim)
			self:AttackEffect( 0.9, self.Enemy, self.Damage, 0 )
		
		end
		
		self.NextAttackTimer = CurTime() + self.NextAttack
	end	
		
end