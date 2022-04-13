if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_elite_zombine", {
	Name = "Elite Zombine",
	Class = "nz_elite_zombine",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.FootAngles = 5
ENT.FootAngles2 = 6

ENT.MoveType = 2

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.ModelScale = 1.5 

ENT.Speed = 75
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 10

ENT.health = 1500
ENT.Damage = 30
ENT.HitPerDoor = 5

ENT.PhysForce = 30000
ENT.AttackRange = 60
ENT.InitialAttackRange = 70
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.5

--Model Settings--
ENT.Model = "models/zombie/zombineplayer.mdl"

ENT.WalkAnim = "zombie_walk_05"
ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

ENT.ThrowAnim = (ACT_GMOD_GESTURE_ITEM_THROW)
ENT.ThrowAnim2 = (ACT_GMOD_GESTURE_ITEM_GIVE)

ENT.EnrageAnim = "releasecrab"

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

ENT.Alert1 = Sound("npc/zombie/zombie_alert1.wav")
ENT.Alert2 = Sound("npc/zombie/zombie_alert2.wav")
ENT.Alert3 = Sound("npc/zombie/zombie_alert3.wav")

ENT.Death1 = Sound("npc/zombie/zombie_die1.wav")
ENT.Death2 = Sound("npc/zombie/zombie_die2.wav")
ENT.Death3 = Sound("npc/zombie/zombie_die3.wav")

ENT.Flinch1 = Sound("npc/zombie/zombie_voice_idle10.wav")
ENT.Flinch2 = Sound("npc/zombie/zombie_voice_idle11.wav")
ENT.Flinch3 = Sound("npc/zombie/zombie_voice_idle12.wav")

ENT.Idle1 = Sound("npc/infected/zombie_voice_idle1.wav")
ENT.Idle2 = Sound("npc/infected/zombie_voice_idle2.wav")
ENT.Idle3 = Sound("npc/infected/zombie_voice_idle3.wav")
ENT.Idle4 = Sound("npc/infected/zombie_voice_idle4.wav")
ENT.Idle5 = Sound("npc/infected/zombie_voice_idle5.wav")
ENT.Idle6 = Sound("npc/infected/zombie_voice_idle6.wav")
ENT.Idle7 = Sound("npc/infected/zombie_voice_idle7.wav")
ENT.Idle8 = Sound("npc/infected/zombie_voice_idle8.wav")
ENT.Idle9 = Sound("npc/infected/zombie_voice_idle9.wav")

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
util.PrecacheSound(self.Alert3)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)

util.PrecacheSound(self.Flinch1)
util.PrecacheSound(self.Flinch2)
util.PrecacheSound(self.Flinch3)

util.PrecacheSound(self.Idle1)
util.PrecacheSound(self.Idle2)
util.PrecacheSound(self.Idle3)
util.PrecacheSound(self.Idle4)
util.PrecacheSound(self.Idle5)
util.PrecacheSound(self.Idle6)
util.PrecacheSound(self.Idle7)
util.PrecacheSound(self.Idle8)
util.PrecacheSound(self.Idle9)
	
util.PrecacheSound(self.HitSound)
util.PrecacheSound(self.Miss)

end

function ENT:Initialize()

	if SERVER then

	--Stats--
	self:SetModel(self.Model)
	self:SetHealth(self.health)	
	
	self:SetModelScale( self.ModelScale,0 ) 
	self:SetMaterial("models/Combine_Soldier/zombineelite_ssheet_zombie")
	self.Armor = 800
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Throwing = false
	self.ArmorBroken = false
	self.Enraged = false
	self.Flinching = false
	self.HoldingProp = false
	self.Burning = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(600)
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
	
	if attacking != 1 then
		if self.IsAttacking then
			return false
		end
	end
	
	return true

end

function ENT:DeathAnimation( anim, pos, activity, scale )
	local zombie = ents.Create( anim )
	if !self:IsValid() then return end
	
	if zombie:IsValid() then 
		zombie:SetPos( pos )
		zombie:SetModel(self:GetModel())
		zombie:SetAngles(self:GetAngles())
		zombie:Spawn()	
		zombie:SetSkin(self:GetSkin())
		zombie:SetColor(self:GetColor())
		zombie:SetMaterial(self:GetMaterial())
		zombie:SetModelScale( scale, 0 )
			
		zombie:StartActivity( activity )
		
		if self.Burning then
			zombie:Ignite( 4 )
			zombie.Burning = true
		end
		
		SafeRemoveEntity( self )
	end
end

function ENT:CustomDeath( dmginfo )
	self:DeathAnimation( "nz_deathanim_elite", self:GetPos(), ACT_HL2MP_RUN_ZOMBIE, self.ModelScale )
end

function ENT:ArmorVisual( pos )

	local effectdata = EffectData()
		effectdata:SetStart( pos ) 
		effectdata:SetOrigin( pos )
		effectdata:SetScale( 1 )
		util.Effect( "StunStickImpact", effectdata )

end

function ENT:ArmorEffect( dmginfo )

	self:EmitSound("hits/armor_hit.wav")
	
	self:ArmorVisual( dmginfo:GetDamagePosition() )

	local attacker = dmginfo:GetAttacker()
	local armorlost = dmginfo:GetDamage() / 2
		self.Armor = self.Armor - armorlost
		
		if attacker:IsNPC() then
			dmginfo:ScaleDamage( 0.50 )
		else
			dmginfo:ScaleDamage( 0.40 )
		end
		
end

function ENT:BreakArmor()

	if self.ArmorBroken then return end

	self.ArmorBroken = true
	self:EmitSound( "physics/metal/metal_box_break"..math.random(1,2)..".wav", 70, math.random( 90,95 ) )
	
	self:ArmorVisual( self:GetPos() + Vector( 0, 0, 40 ) )
	
end

function ENT:CheckArmor()

	if self.Armor < 0 then
		self:BreakArmor()
		return false
	end

	return true

end

function ENT:CustomThink()
	
	if ( self.NextCheck or 0 ) < CurTime() then
		
		if !self.Bullseye:IsValid() then return end
		
		if self.Bullseye:IsOnFire() then
			self:Ignite( math.huge )
		end
		
		if self:IsOnFire() then
			if self.Flinching then return end
			self:OnIgnite()
		else
			if self.Burning then
				self:Ignite( math.huge )
			end
		end
		
		self.NextCheck = CurTime() + 0.5
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
	
		if self:CheckArmor() then
			self:ArmorEffect( dmginfo )
		else
			dmginfo:ScaleDamage( 0.80 )
		end
		
		if dmginfo:GetDamage() > 40 then
			self:Flinch( dmginfo, hitgroup )
		end
		
	end

	if dmginfo:IsExplosionDamage() then
		self:Flinch( dmginfo )
	end
	
	if self:CheckOnFire( dmginfo ) then
		self:Ignite( math.huge )
	end
	
end

function ENT:OnIgnite()
	
	if self.Burning then return end
	if !self:CheckStatus( 1 ) then return end
	
	self.Flinching = true
	self.Burning = true
	
	self:PlayFlinchSequence( self.EnrageAnim, 0.8, 0, 0, 1 )
	
	self:EnrageSound()
	
	timer.Simple( 0.8, function()
		if !self:CheckValid( self ) then return end
		self.Enraged = true
		self.Speed = self.Speed / 2
		self.Damage = self.Damage +	10
		self.WalkSpeedAnimation = 0.9
	end)
	
end

function ENT:CheckOnFire( dmginfo )

	local dmgtype = dmginfo:GetDamageType()
	if dmgtype == DMG_DIRECT then
		return true
	elseif dmgtype == DMG_BLAST then
		return true
	end
	
	return false
	
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

	local players = player.GetAll()
	
	for _,v in pairs( players ) do
			
		if self:GetRangeTo( v ) < 200 then	
			
			v:ViewPunch( Angle(math.random(-1, 3), math.random(-1, 3), math.random(-1, 5) ) )
		
		end
		
	end
		
	self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav", 70, math.random(75,85))
	self:EmitSound("npc/combine_soldier/gear"..math.random(6)..".wav", 65)
	
end

function ENT:AlertSound()
	local sounds = {}
		sounds[1] = (self.Alert1)
		sounds[2] = (self.Alert2)
		sounds[3] = (self.Alert3)
		self:EmitSound( sounds[math.random(1,3)], 95, math.random(60,75) )
end

function ENT:PainSound()
end

function ENT:EnrageSound()
	local sounds = {}
		sounds[1] = (self.Flinch1)
		sounds[2] = (self.Flinch2)
		sounds[3] = (self.Flinch3)
		self:EmitSound( sounds[math.random(1,3)], 85, math.random(60,75) )
end

function ENT:DeathSound()
	local sounds = {}
		sounds[1] = (self.Death1)
		sounds[2] = (self.Death2)
		sounds[3] = (self.Death3)
		self:EmitSound( sounds[math.random(1,3)], 85, math.random(60,75) )
end

function ENT:AttackSound()
	local sounds = {}
		sounds[1] = (self.Attack1)
		sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)], 85, math.random(60,75) )
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
		self:EmitSound( sounds[math.random(1,8)], 85, math.random(60,75) )
end
	
function ENT:ThrowFakeProp()

	local object = self.FakeObject
	local phys = object:GetPhysicsObject()
	local force = self:CheckMass( phys )
	
	if !object:IsValid() then return end
	
	if force == nil then return end
	
	phys:ApplyForceCenter( self:GetForward():GetNormalized() * force + Vector(0, 0, 2) )
	
	self:EmitSound( "npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95) )
	
end
	
function ENT:CheckMass( object )
	
	if object:GetMass() < 75 then
	
		return 60000
		
	elseif object:GetMass() < 175 and object:GetMass() > 75 then
	
		return 80000
		
	elseif object:GetMass() < 300 and object:GetMass() > 175 then
	
		return 250000
		
	elseif object:GetMass() < 500 and object:GetMass() > 300 then
	
		return 500000
		
	elseif object:GetMass() < 700 and object:GetMass() > 500 then
	
		return 600000
		
	elseif object:GetMass() < 1000 and object:GetMass() > 700 then
	
		return 700000
		
	elseif object:GetMass() < 1600 and object:GetMass() > 1000 then
	
		return 800000
		
	end
	
	return nil
	
end
	
function ENT:CreateFakeProp( ent )

	local fakeprop = ents.Create("ent_fakeprop")
		fakeprop:SetModel( ent:GetModel() )
		fakeprop:SetPos( ent:GetPos() )
		fakeprop:SetMaterial( ent:GetMaterial() )
		fakeprop:SetSkin( ent:GetSkin() )
		fakeprop:Spawn()
		
		fakeprop:SetOwner( self )
		
		self.FakeObject = fakeprop
		
	local phys = fakeprop:GetPhysicsObject()
		if ( phys != nil && phys != NULL && phys:IsValid() ) then
			phys:EnableMotion( true )
			phys:EnableGravity( true )
			phys:Wake()
		end
		
	SafeRemoveEntity( ent )
	
	if self.Flinching then
		SafeRemoveEntity( fakeprop )
	end
	
end
	
function ENT:ParentProp( ent, parent )

	ent:SetParent( parent )
	
	ent:Fire("setparentattachment", "Anim_Attachment_LH", 0.01)

	self.HoldingProp = true
	
end
	
function ENT:CheckProp( ent )

	local phys = ent:GetPhysicsObject()
	
		if ( phys != nil && phys != NULL && phys:IsValid() ) then
		
			if phys:IsMotionEnabled() and phys:GetSurfaceArea() < 60000 and phys:GetMass() < 3025 then
				
				return true
			
			end
			
		end	
		
	return false
		
end
	
function ENT:PropMelee( ent )
	self:AttackSound()
	self:RestartGesture(self.AttackAnim)  
	self:AttackEffect( 0.9, ent, self.Damage, 2 )
end
	
function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then

		if self.HoldingProp then
			self:PropMelee( ent )
		else
		
			if self:CheckProp( ent ) then
				if !self:CheckStatus( 1 ) then return end
				
				self:AttackSound()
				self:RestartGesture(self.AttackAnim)
		
				timer.Simple( 0.9, function()
					if !self:IsValid() then return end
					if self:Health() < 0 then return end
					if !self:CheckStatus( 1 ) then return end
					self:ParentProp( ent, self )
				end)
			
				timer.Simple( 2, function()
					if !self:IsValid() then return end
					if self:Health() < 0 then return end
					if !self:CheckStatus( 1 ) then return end
				
					local attack = math.random(1,2)
				
					if attack == 1 then
						self:RestartGesture( self.ThrowAnim )
					elseif attack == 2 then
						self:RestartGesture( self.ThrowAnim2 )
					end
				
					self:AttackSound()
				
				end)
			
				timer.Simple( 2.6, function()
					if !self:IsValid() then return end
					if self:Health() < 0 then return end
					
					self.HoldingProp = false
					
					if !self:CheckStatus( 1 ) then return end
				
					self:CreateFakeProp( ent )
					self:ThrowFakeProp()
				end)
		
			else
				self:PropMelee( ent )
			end
			
		end
	
		self.NextPropAttackTimer = CurTime() + self.NextAttack + 0.5
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

function ENT:AttackEffect( time, ent, dmg, type )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		if !self:CheckStatus( 1 ) then return end
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage( self.Damage, self )
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound( self.HitSound, 90, math.random(80,90) )
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
			self:EmitSound(self.Miss, 80, 65 )
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
			if !self:CheckStatus( 1 ) then return end
		
			self:AttackSound()
			self.IsAttacking = true
			self:RestartGesture(self.AttackAnim)
		
			self:AttackEffect( 0.9, self.Enemy, self.Damage, 0 )
		
		end
		
		self.NextAttackTimer = CurTime() + self.NextAttack
	end	
		
end