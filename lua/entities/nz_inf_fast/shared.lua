if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_inf_fast", {
	Name = "Fast Infected",
	Class = "nz_inf_fast",
	Category = "Infected Z"
} )

--Stats--
ENT.MoveType = 2

ENT.FootAngles = 5

ENT.CollisionHeight = 66
ENT.CollisionSide = 11

ENT.Speed = 200
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 0

ENT.health = 100
ENT.Damage = 20

ENT.PhysForce = 25000
ENT.AttackRange = 40
ENT.InitialAttackRange = 55
ENT.DoorAttackRange = 25

ENT.NextAttack = 2

--Model Settings--
ENT.Model = ""

ENT.MaleModel1 = "models/bloocobalt/infected_citizens/male_01.mdl"
ENT.MaleModel2 = "models/bloocobalt/infected_citizens/male_02.mdl"
ENT.MaleModel3 = "models/bloocobalt/infected_citizens/male_03.mdl"
ENT.MaleModel4 = "models/bloocobalt/infected_citizens/male_04.mdl"
ENT.MaleModel5 = "models/bloocobalt/infected_citizens/male_05.mdl"
ENT.MaleModel6 = "models/bloocobalt/infected_citizens/male_06.mdl"
ENT.MaleModel7 = "models/bloocobalt/infected_citizens/male_07.mdl"
ENT.MaleModel8 = "models/bloocobalt/infected_citizens/male_08.mdl"
ENT.MaleModel9 = "models/bloocobalt/infected_citizens/male_09.mdl"
ENT.MaleModel10 = "models/bloocobalt/infected_citizens/male_10.mdl"

ENT.FemaleModel1 = "models/bloocobalt/infected_citizens/female_01.mdl"
ENT.FemaleModel2 = "models/bloocobalt/infected_citizens/female_02.mdl"
ENT.FemaleModel3 = "models/bloocobalt/infected_citizens/female_03.mdl"
ENT.FemaleModel4 = "models/bloocobalt/infected_citizens/female_04.mdl"
ENT.FemaleModel5 = "models/bloocobalt/infected_citizens/female_06.mdl"
ENT.FemaleModel6 = "models/bloocobalt/infected_citizens/female_07.mdl"

ENT.BeanieModel1 = "models/bloocobalt/infected_citizens/female_02_b.mdl"
ENT.BeanieModel2 = "models/bloocobalt/infected_citizens/female_03_b.mdl"
ENT.BeanieModel3 = "models/bloocobalt/infected_citizens/female_04_b.mdl"
ENT.BeanieModel4 = "models/bloocobalt/infected_citizens/female_06_b.mdl"
ENT.BeanieModel5 = "models/bloocobalt/infected_citizens/female_07_b.mdl"

ENT.GrabAnim = "enter_choke"
ENT.GrabFailAnim = "choke_miss"
ENT.HoldAnim = "choke_eat"

ENT.AttackAnim1 = "attacka"
ENT.AttackAnim2 = "attackb"
ENT.AttackAnim3 = "attackc"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

--Sounds--
ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

function ENT:Precache()

--Sounds--	


end

function ENT:Animations()

	self.WalkAnims = { "run" }
	self.IdleAnimations =  { "idle01", "idle02", "idle03", "idle04" }
	
	self.WalkAnim = ( table.Random( self.WalkAnims ) )
	self.IdleAnim = ( table.Random( self.IdleAnimations ) )

end

function ENT:Switch( type )

	if type == 1 then
	
		self.FemaleModels = { self.FemaleModel1, self.FemaleModel2, self.FemaleModel3, self.FemaleModel4, self.FemaleModel5, self.FemaleModel6 }
		self.BeanieModels = { self.BeanieModel1, self.BeanieModel2, self.BeanieModel3, self.BeanieModel4, self.BeanieModel5 }
		
		if math.random(1,3) == 1 then
		
			self:SetModel( table.Random( self.BeanieModels ) )
			
			self:SetBodygroup( 1, math.random(0,11) )
			self:SetBodygroup( 2, math.random(0,7) )
			self:SetBodygroup( 3, math.random(0,1) )
			self:SetBodygroup( 4, math.random(0,2) )
			
		else
		
			self:SetModel( table.Random( self.FemaleModels ) )
			
			self:SetBodygroup( 1, math.random(0,11) )
			self:SetBodygroup( 2, math.random(0,7) )
			self:SetBodygroup( 3, math.random(0,2) )
			
		end
		
	else
	
		self.MaleModels = { self.MaleModel1, self.MaleModel2, self.MaleModel3, self.MaleModel4, self.MaleModel5, self.MaleModel6, self.MaleModel7, self.MaleModel8, self.MaleModel9, self.MaleModel10 }

		self:SetModel( table.Random( self.MaleModels ) )
		
		self:SetBodygroup( 1, math.random(0,10) )
		self:SetBodygroup( 2, math.random(0,5) )
		self:SetBodygroup( 3, math.random(0,2) )
		self:SetBodygroup( 4, math.random(0,2) )
		
	end
	
	self:SetSkin( math.random(0,11) )
	
end

function ENT:Initialize()

	if SERVER then

	--Stats--
	self:SetHealth(self.health)	
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	self.FakeDeath = false
	self.IsGrabbing = false
	self.Stumbling = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(200)
	self.loco:SetDeceleration(400)
	
	self:Switch( math.random(1,3) )
	self:Animations()
	
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

	if ( self.NextIdleFunction or 0 ) < CurTime() then

		if math.random(1,5) == 1 then
			self:IdleSound()
		end
		
		self:ResetSequence( self.IdleAnim )
	
		self.NextIdleFunction = CurTime() + 4
	end
	
end

function ENT:TransformRagdoll( dmginfo )
	
	if !self:IsValid() then return end
	
	local ragdoll = ents.Create("prop_ragdoll")
		if ragdoll:IsValid() then 
			ragdoll:SetPos(self:GetPos())
			ragdoll:SetModel(self:GetModel())
			ragdoll:SetAngles(self:GetAngles())
			ragdoll:Spawn()
			ragdoll:SetSkin(self:GetSkin())
			ragdoll:SetColor(self:GetColor())
			ragdoll:SetMaterial(self:GetMaterial())
			
			local num = ragdoll:GetPhysicsObjectCount()-1
			local v = self.loco:GetVelocity()	
   
			for i=0, num do
				local bone = ragdoll:GetPhysicsObjectNum(i)

				if IsValid(bone) then
					local bp, ba = self:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
					if bp and ba then
						bone:SetPos(bp)
						bone:SetAngles(ba)
					end
					bone:SetVelocity(v)
				end
	  
			end
			
			ragdoll:SetBodygroup( 1, self:GetBodygroup(1) )
			ragdoll:SetBodygroup( 2, self:GetBodygroup(2) )
			ragdoll:SetBodygroup( 3, self:GetBodygroup(3) )
			ragdoll:SetBodygroup( 4, self:GetBodygroup(4) )
			ragdoll:SetBodygroup( 5, self:GetBodygroup(5) )
			ragdoll:SetBodygroup( 6, self:GetBodygroup(6) )
			
			ragdoll:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			
		end
	
	SafeRemoveEntity( self )
	
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
			self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,65) )	
		end
	
	end

	self:TransformRagdoll( dmginfo )

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
		self.loco:SetDeceleration(400)
		self:ResumeMovementFunctions()
		self.Flinching = false
		self.Stumbling = false
	end)
end

function ENT:CustomChaseEnemy()

	if self.Stumbling then
		self:BackUp( self.StumbleType )
	end
	
end
	
function ENT:BackUp( type )
	
	local enemy = self:GetEnemy()
	while( self.Stumbling ) do
		
		if type == 1 then
			local back = self:GetPos() + self:GetAngles():Forward() * -778
			self.loco:Approach(back, 100)
		elseif type == 2 then
			local back = self:GetPos() + self:GetAngles():Forward() * 778
			self.loco:Approach(back, 100)	
		end
			
		coroutine.wait(0.05)
	end
	
	coroutine.yield()
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
			
			local enemy = dmginfo:GetAttacker()
			
			if enemy:IsValid() then
				if enemy:IsPlayer() then
				
					local enemyforward = enemy:GetForward()
					local forward = self:GetForward() 
					
					if enemyforward:Distance( forward ) < 1 then
						self:PlayFlinchSequence( "shovereactbehind", 1, 0, 30, 1.6 )
						self.loco:SetDeceleration(1000)
						self.Stumbling = true
						self.StumbleType = 2
					else
						self:PlayFlinchSequence( "shovereact", 1, 0, 30, 1.6 )
						self.loco:SetDeceleration(1000)
						self.Stumbling = true
						self.StumbleType = 1
					end
				
				end
			end
			
		end
		
		self.NextFlinch = CurTime() + 3	
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
	
	end
end

function ENT:DeathSound()

end

function ENT:AttackSound()

end

function ENT:IdleSound()

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
					self:EmitSound(self.DoorBreak, 77)
				end
			elseif type == 2 then
				if ent != NULL and ent.Hitsleft != nil then
					if ent.Hitsleft > 0 then
						ent.Hitsleft = ent.Hitsleft - self.HitPerDoor	
						self:EmitSound(self.DoorBreak, 77)
					end
				end
			end
							
		else	
			self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		end
		
	end)

end

function ENT:BleedEffect( ent )

	if self:CheckValid( ent ) then
	
		ent:TakeDamage(15, self)	
		self:EmitSound("bite/bite"..math.random(1,5)..".wav", 70)
		
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

	timer.Simple(1, function() 
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
	
	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		self:ResumeMovementFunctions()
		self.IsGrabbing = false
		self.IsAttacking = false
	end)
end

function ENT:Grab( ent )
	if ent.Grabbed then return end
	
	timer.Simple( 0.6, function() -- initial grab
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if self:GetRangeTo( ent ) < 30 then -- if the target is still in range then grab
			
			ent.Grabbed = true
			
			self:PlaySequence( self.HoldAnim, 0, 0.8, 0, 2 )
			
			self:Slow( 2, ent )
			self:Bleed( ent )
			
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
			self:PlaySequence( self.GrabFailAnim, 0, 1, 0, 0.3 )
		end
			
	end)
	
	self.IsGrabbing = true
	self.IsAttacking = true
	self:PlaySequenceAndWait( self.GrabAnim, 0.7 )
	
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
		
			if self.Enemy:IsNPC() then
				self:Melee( self.Enemy, 0 )
			elseif self.Enemy:IsPlayer() then
				if self.Enemy.Grabbed then
					self:Melee( self.Enemy, 0 )
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
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_inf_fast", {
	Name = "Fast Infected",
	Class = "nz_inf_fast",
	Category = "Infected Z"
} )

--Stats--
ENT.MoveType = 2

ENT.FootAngles = 5

ENT.CollisionHeight = 66
ENT.CollisionSide = 11

ENT.Speed = 200
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 0

ENT.health = 100
ENT.Damage = 20

ENT.PhysForce = 25000
ENT.AttackRange = 40
ENT.InitialAttackRange = 55
ENT.DoorAttackRange = 25

ENT.NextAttack = 2

--Model Settings--
ENT.Model = ""

ENT.MaleModel1 = "models/bloocobalt/infected_citizens/male_01.mdl"
ENT.MaleModel2 = "models/bloocobalt/infected_citizens/male_02.mdl"
ENT.MaleModel3 = "models/bloocobalt/infected_citizens/male_03.mdl"
ENT.MaleModel4 = "models/bloocobalt/infected_citizens/male_04.mdl"
ENT.MaleModel5 = "models/bloocobalt/infected_citizens/male_05.mdl"
ENT.MaleModel6 = "models/bloocobalt/infected_citizens/male_06.mdl"
ENT.MaleModel7 = "models/bloocobalt/infected_citizens/male_07.mdl"
ENT.MaleModel8 = "models/bloocobalt/infected_citizens/male_08.mdl"
ENT.MaleModel9 = "models/bloocobalt/infected_citizens/male_09.mdl"
ENT.MaleModel10 = "models/bloocobalt/infected_citizens/male_10.mdl"

ENT.FemaleModel1 = "models/bloocobalt/infected_citizens/female_01.mdl"
ENT.FemaleModel2 = "models/bloocobalt/infected_citizens/female_02.mdl"
ENT.FemaleModel3 = "models/bloocobalt/infected_citizens/female_03.mdl"
ENT.FemaleModel4 = "models/bloocobalt/infected_citizens/female_04.mdl"
ENT.FemaleModel5 = "models/bloocobalt/infected_citizens/female_06.mdl"
ENT.FemaleModel6 = "models/bloocobalt/infected_citizens/female_07.mdl"

ENT.BeanieModel1 = "models/bloocobalt/infected_citizens/female_02_b.mdl"
ENT.BeanieModel2 = "models/bloocobalt/infected_citizens/female_03_b.mdl"
ENT.BeanieModel3 = "models/bloocobalt/infected_citizens/female_04_b.mdl"
ENT.BeanieModel4 = "models/bloocobalt/infected_citizens/female_06_b.mdl"
ENT.BeanieModel5 = "models/bloocobalt/infected_citizens/female_07_b.mdl"

ENT.GrabAnim = "enter_choke"
ENT.GrabFailAnim = "choke_miss"
ENT.HoldAnim = "choke_eat"

ENT.AttackAnim1 = "attacka"
ENT.AttackAnim2 = "attackb"
ENT.AttackAnim3 = "attackc"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

--Sounds--
ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

function ENT:Precache()

--Sounds--	


end

function ENT:Animations()

	self.WalkAnims = { "run" }
	self.IdleAnimations =  { "idle01", "idle02", "idle03", "idle04" }
	
	self.WalkAnim = ( table.Random( self.WalkAnims ) )
	self.IdleAnim = ( table.Random( self.IdleAnimations ) )

end

function ENT:Switch( type )

	if type == 1 then
	
		self.FemaleModels = { self.FemaleModel1, self.FemaleModel2, self.FemaleModel3, self.FemaleModel4, self.FemaleModel5, self.FemaleModel6 }
		self.BeanieModels = { self.BeanieModel1, self.BeanieModel2, self.BeanieModel3, self.BeanieModel4, self.BeanieModel5 }
		
		if math.random(1,3) == 1 then
		
			self:SetModel( table.Random( self.BeanieModels ) )
			
			self:SetBodygroup( 1, math.random(0,11) )
			self:SetBodygroup( 2, math.random(0,7) )
			self:SetBodygroup( 3, math.random(0,1) )
			self:SetBodygroup( 4, math.random(0,2) )
			
		else
		
			self:SetModel( table.Random( self.FemaleModels ) )
			
			self:SetBodygroup( 1, math.random(0,11) )
			self:SetBodygroup( 2, math.random(0,7) )
			self:SetBodygroup( 3, math.random(0,2) )
			
		end
		
	else
	
		self.MaleModels = { self.MaleModel1, self.MaleModel2, self.MaleModel3, self.MaleModel4, self.MaleModel5, self.MaleModel6, self.MaleModel7, self.MaleModel8, self.MaleModel9, self.MaleModel10 }

		self:SetModel( table.Random( self.MaleModels ) )
		
		self:SetBodygroup( 1, math.random(0,10) )
		self:SetBodygroup( 2, math.random(0,5) )
		self:SetBodygroup( 3, math.random(0,2) )
		self:SetBodygroup( 4, math.random(0,2) )
		
	end
	
	self:SetSkin( math.random(0,11) )
	
end

function ENT:Initialize()

	if SERVER then

	--Stats--
	self:SetHealth(self.health)	
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	self.FakeDeath = false
	self.IsGrabbing = false
	self.Stumbling = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(200)
	self.loco:SetDeceleration(400)
	
	self:Switch( math.random(1,3) )
	self:Animations()
	
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

	if ( self.NextIdleFunction or 0 ) < CurTime() then

		if math.random(1,5) == 1 then
			self:IdleSound()
		end
		
		self:ResetSequence( self.IdleAnim )
	
		self.NextIdleFunction = CurTime() + 4
	end
	
end

function ENT:TransformRagdoll( dmginfo )
	
	if !self:IsValid() then return end
	
	local ragdoll = ents.Create("prop_ragdoll")
		if ragdoll:IsValid() then 
			ragdoll:SetPos(self:GetPos())
			ragdoll:SetModel(self:GetModel())
			ragdoll:SetAngles(self:GetAngles())
			ragdoll:Spawn()
			ragdoll:SetSkin(self:GetSkin())
			ragdoll:SetColor(self:GetColor())
			ragdoll:SetMaterial(self:GetMaterial())
			
			local num = ragdoll:GetPhysicsObjectCount()-1
			local v = self.loco:GetVelocity()	
   
			for i=0, num do
				local bone = ragdoll:GetPhysicsObjectNum(i)

				if IsValid(bone) then
					local bp, ba = self:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
					if bp and ba then
						bone:SetPos(bp)
						bone:SetAngles(ba)
					end
					bone:SetVelocity(v)
				end
	  
			end
			
			ragdoll:SetBodygroup( 1, self:GetBodygroup(1) )
			ragdoll:SetBodygroup( 2, self:GetBodygroup(2) )
			ragdoll:SetBodygroup( 3, self:GetBodygroup(3) )
			ragdoll:SetBodygroup( 4, self:GetBodygroup(4) )
			ragdoll:SetBodygroup( 5, self:GetBodygroup(5) )
			ragdoll:SetBodygroup( 6, self:GetBodygroup(6) )
			
			ragdoll:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			
		end
	
	SafeRemoveEntity( self )
	
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
			self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,65) )	
		end
	
	end

	self:TransformRagdoll( dmginfo )

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
		self.loco:SetDeceleration(400)
		self:ResumeMovementFunctions()
		self.Flinching = false
		self.Stumbling = false
	end)
end

function ENT:CustomChaseEnemy()

	if self.Stumbling then
		self:BackUp( self.StumbleType )
	end
	
end
	
function ENT:BackUp( type )
	
	local enemy = self:GetEnemy()
	while( self.Stumbling ) do
		
		if type == 1 then
			local back = self:GetPos() + self:GetAngles():Forward() * -778
			self.loco:Approach(back, 100)
		elseif type == 2 then
			local back = self:GetPos() + self:GetAngles():Forward() * 778
			self.loco:Approach(back, 100)	
		end
			
		coroutine.wait(0.05)
	end
	
	coroutine.yield()
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
			
			local enemy = dmginfo:GetAttacker()
			
			if enemy:IsValid() then
				if enemy:IsPlayer() then
				
					local enemyforward = enemy:GetForward()
					local forward = self:GetForward() 
					
					if enemyforward:Distance( forward ) < 1 then
						self:PlayFlinchSequence( "shovereactbehind", 1, 0, 30, 1.6 )
						self.loco:SetDeceleration(1000)
						self.Stumbling = true
						self.StumbleType = 2
					else
						self:PlayFlinchSequence( "shovereact", 1, 0, 30, 1.6 )
						self.loco:SetDeceleration(1000)
						self.Stumbling = true
						self.StumbleType = 1
					end
				
				end
			end
			
		end
		
		self.NextFlinch = CurTime() + 3	
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
	
	end
end

function ENT:DeathSound()

end

function ENT:AttackSound()

end

function ENT:IdleSound()

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
					self:EmitSound(self.DoorBreak, 77)
				end
			elseif type == 2 then
				if ent != NULL and ent.Hitsleft != nil then
					if ent.Hitsleft > 0 then
						ent.Hitsleft = ent.Hitsleft - self.HitPerDoor	
						self:EmitSound(self.DoorBreak, 77)
					end
				end
			end
							
		else	
			self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		end
		
	end)

end

function ENT:BleedEffect( ent )

	if self:CheckValid( ent ) then
	
		ent:TakeDamage(15, self)	
		self:EmitSound("bite/bite"..math.random(1,5)..".wav", 70)
		
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

	timer.Simple(1, function() 
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
	
	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		self:ResumeMovementFunctions()
		self.IsGrabbing = false
		self.IsAttacking = false
	end)
end

function ENT:Grab( ent )
	if ent.Grabbed then return end
	
	timer.Simple( 0.6, function() -- initial grab
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if self:GetRangeTo( ent ) < 30 then -- if the target is still in range then grab
			
			ent.Grabbed = true
			
			self:PlaySequence( self.HoldAnim, 0, 0.8, 0, 2 )
			
			self:Slow( 2, ent )
			self:Bleed( ent )
			
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
			self:PlaySequence( self.GrabFailAnim, 0, 1, 0, 0.3 )
		end
			
	end)
	
	self.IsGrabbing = true
	self.IsAttacking = true
	self:PlaySequenceAndWait( self.GrabAnim, 0.7 )
	
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
		
			if self.Enemy:IsNPC() then
				self:Melee( self.Enemy, 0 )
			elseif self.Enemy:IsPlayer() then
				if self.Enemy.Grabbed then
					self:Melee( self.Enemy, 0 )
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