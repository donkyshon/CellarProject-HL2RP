if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

local nb_use_ragdolls = GetGlobalBool("nb_use_ragdolls")
local nb_npc = GetConVar("nb_npc")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")
local nb_attackprop = GetConVar("nb_attackprop")
local nb_targetmethod = GetConVar("nb_targetmethod")
local nb_ignoreteam = GetConVar("nb_ignoreteam")

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminOnly   = false

--Stats--
ENT.FootAngles = 5
ENT.FootAngles2 = 5

ENT.UseFootSteps = 1
ENT.MoveType = 1

ENT.Bone1 = "ValveBiped.Bip01_R_Foot"
ENT.Bone2 = "ValveBiped.Bip01_L_Foot"

ENT.SearchRadius = 2000
ENT.LoseTargetDist = 4000

ENT.Speed = 0
ENT.WalkSpeedAnimation = 0
ENT.FlinchSpeed = 0

ENT.Health = 0
ENT.Damage = 0

ENT.PhysForce = 15000
ENT.AttackRange = 60
ENT.InitialAttackRange = 90

ENT.HitPerDoor = 1
ENT.DoorAttackRange = 25

ENT.AttackWaitTime = 0
ENT.AttackFinishTime = 0

ENT.NextAttack = 1.3

ENT.FallDamage = 0

--Model Settings--
ENT.Model = ""

ENT.AttackAnim = (NONE)

ENT.WalkAnim = (NONE)

ENT.FlinchAnim = (NONE)
ENT.FallAnim = (NONE)

ENT.AttackDoorAnim = (NONE)

--Sounds--
ENT.Attack1 = Sound("")
ENT.Attack2 = Sound("")

ENT.DoorBreak = Sound("")

ENT.Death1 = Sound("")
ENT.Death2 = Sound("")
ENT.Death3 = Sound("")

ENT.Fall1 = Sound("")
ENT.Fall2 = Sound("")

ENT.Idle1 = Sound("")
ENT.Idle2 = Sound("")
ENT.Idle3 = Sound("")
ENT.Idle4 = Sound("")

ENT.Pain1 = Sound("")
ENT.Pain2 = Sound("")
ENT.Pain3 = Sound("")

ENT.Hit = Sound("")
ENT.Miss = Sound("")

function ENT:Precache()
end

function ENT:Initialize()
end

function ENT:CollisionSetup( collisionside, collisionheight, collisiongroup )
	self:SetCollisionGroup( collisiongroup )
	self:SetCollisionBounds( Vector(-collisionside,-collisionside,0), Vector(collisionside,collisionside,collisionheight) )
	self:PhysicsInitShadow(true, false)
	self.NEXTBOT = true
end

function ENT:CreateBullseye( height )
	local bullseye = ents.Create("npc_bullseye")
	bullseye:SetPos( self:GetPos() + Vector(0,0,height or 50) )
	bullseye:SetAngles( self:GetAngles() )
	bullseye:SetParent( self )
	bullseye:SetSolid( SOLID_NONE )
	bullseye:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )

	bullseye:SetOwner( self )
	bullseye:Spawn()
	bullseye:Activate()
	bullseye:SetHealth( 9999999 )

	self.Bullseye = bullseye
end

function ENT:CreateRelationShip()
	if ( self.RelationTimer or 0 ) < CurTime() then

		local bullseye = self.Bullseye

		if !self:CheckValid( bullseye ) then
			SafeRemoveEntity( bullseye )
		return end

		self.LastPos = self:GetPos( )

		local ents = ents.GetAll()
		table.Add(ents)

		for _,v in pairs(ents) do

			if v:GetClass() != self and v:GetClass() != "npc_bullseye" and v:GetClass() != "npc_grenade_frag" and v:IsNPC() then
				if nb_npc:GetInt() == 1 then
					v:AddEntityRelationship( bullseye, 1, 10 )
				else
					v:AddEntityRelationship( bullseye, 3, 10 )
				end
			end

		end

		self.RelationTimer = CurTime() + 2
	end
end

function ENT:CustomThink()
end

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16

	if util.PointContents( tr.HitPos ) == CONTENTS_EMPTY then

	local ent = ents.Create( Class )
		ent:SetPos( SpawnPos )
		ent:Spawn()

	end

	return ent

end

function ENT:FaceTowards( ent )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )

	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
end

function ENT:Think()
	if not SERVER then return end
	if !IsValid(self) then return end

	if nb_npc:GetInt() == 1 then
		self:CreateRelationShip()
	else
	
	end

	self:CustomThink()

	-- Step System --
	if self.UseFootSteps == 1 then
		if !self.nxtThink then self.nxtThink = 0 end
		if CurTime() < self.nxtThink then return end

		self.nxtThink = CurTime() + 0.025

	-- First Step
        local bones = self:LookupBone(self.Bone1)

        local pos, ang = self:GetBonePosition(bones)

        local tr = {}
        tr.start = pos
        tr.endpos = tr.start - ang:Right()* self.FootAngles + ang:Forward()* self.FootAngles2
        tr.filter = self
        tr = util.TraceLine(tr)

        if tr.Hit && !self.FeetOnGround then
			self:FootSteps()
        end

        self.FeetOnGround = tr.Hit

	-- Second Step
		local bones2 = self:LookupBone(self.Bone2)

        local pos2, ang2 = self:GetBonePosition(bones2)

        local tr = {}
        tr.start = pos2
        tr.endpos = tr.start - ang2:Right()* self.FootAngles + ang2:Forward()* self.FootAngles2
        tr.filter = self
        tr = util.TraceLine(tr)

        if tr.Hit && !self.FeetOnGround2 then
					self:FootSteps()
        end

        self.FeetOnGround2 = tr.Hit
	end
end

function ENT:Attack()
end

function ENT:TransformRagdoll( dmginfo )

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

function ENT:MorphRagdoll( dmginfo )

	if ( nb_use_ragdolls == true ) then
		self:TransformRagdoll( dmginfo )
	else
		self:BecomeRagdoll( dmginfo )
	end
	
end

function ENT:CustomDeath( dmginfo )
	self:MorphRagdoll( dmginfo )
end

function ENT:CustomInjure( dmginfo )
end

function ENT:FootSteps()
end

function ENT:AlertSound()
end

function ENT:PainSound()
end

function ENT:DeathSound()
end

function ENT:AttackSound()
end

function ENT:IdleSound()
end

function ENT:IdleSounds()
	if self.Enemy then
		if math.random(1,3) == 1 then
			self:IdleSound()
		end
	else
		if math.random(1,18) == 1 then
			self:IdleSound()
		end
	end
end

function ENT:CheckValid( ent )
	if !ent then
		return false
	end

	if !self:IsValid() then
		return false
	end

	if self:Health() < 0 then
		return false
	end

	if !ent:IsValid() then
		return false
	end

	if ent:Health() < 0 then
		return false
	end

	return true
end

function ENT:CheckStatus()
	return true
end

function ENT:ResumeMovementFunctions()
	self:MovementFunctions( self.MoveType, self.WalkAnim, self.Speed, self.WalkSpeedAnimation )
end

function ENT:IdleFunction()
	self:MovementFunctions( 1, ACT_HL2MP_WALK_ZOMBIE_01, 0, 0 )
end

function ENT:MovementFunctions( type, act, speed, playbackrate )
	if type == 1 then
		self:StartActivity( act )
		self:SetPoseParameter("move_x", playbackrate )
	else
		self:ResetSequence( act )
		self:SetPlaybackRate( playbackrate )
		self:SetPoseParameter("move_x", playbackrate )
	end

	self.loco:SetDesiredSpeed( speed )
end

function ENT:SpawnIn()
	local nav = navmesh.GetNearestNavArea(self:GetPos())
	
	if !self:IsInWorld() or !IsValid(nav) or nav:GetClosestPointOnArea(self:GetPos()):DistToSqr(self:GetPos()) >= 100000 then 
		ErrorNoHalt("Nextbot ["..self:GetClass().."] spawned too far away from a navmesh!")
		SafeRemoveEntity(self)
	end 
	
	self:OnSpawn()
end

function ENT:OnSpawn()
	
end

function ENT:RunBehaviour()

	self:SpawnIn()

	while ( true ) do
	if self:HaveEnemy() then
		
		local enemy = self:GetEnemy()

		pos = enemy:GetPos()

		if ( pos ) then

			if enemy:Health() > 0 and enemy:IsValid() then

				self.HasNoEnemy = false

				if self:CheckStatus() then
					self:MovementFunctions( self.MoveType, self.WalkAnim, self.Speed, self.WalkSpeedAnimation )
				end
				
				self:ChaseEnemy()

			end

		end

	else

		self.HasNoEnemy = true

		self:IdleFunction()

	end
		coroutine.yield()
	end
end

function ENT:CheckRangeToEnemy()
	if ( self.CheckTimer or 0 ) < CurTime() then
	local enemy = self:GetEnemy()

	if self:GetEnemy() then

		if nb_npc:GetInt() == 1 then
			if !enemy:IsValid() then return end
			if ( enemy:IsNPC() and enemy:Health() > 0 ) or ( enemy:IsPlayer() and enemy:Alive() ) then
				if self:GetRangeTo( enemy ) < self.InitialAttackRange then
					self:Attack()
				end
			end
		else
			if ( enemy:IsPlayer() and enemy:Alive() ) then
				if self:GetRangeTo( enemy ) < self.InitialAttackRange then
					self:Attack()
				end
			end
		end

	end

		self.CheckTimer = CurTime() + 1
	end
end

function ENT:ChaseEnemy( options )

	local enemy = self:GetEnemy()
	local pos = enemy:GetPos()
	
	local options = options or {}
	
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if (  !path:IsValid() ) then return "failed" end
	
	while ( path:IsValid() and self:HaveEnemy() ) do

		if ( path:GetAge() > 1 ) then	
			path:Compute( self, self:GetEnemy():GetPos() )
		end

		path:Update( self )	
		
		--path:Draw()
		
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		if enemy and enemy:IsValid() and enemy:Health() > 0 then
			if !self.IsAttacking then
				if self:GetRangeTo( enemy ) < 600 then
					if math.random( 1,500 ) == 5 then
						self:IdleSounds()
					end
				end
			end
		end

		if ai_ignoreplayers:GetInt() == 1 then
			if enemy:IsPlayer() then
				self:FindEnemy()
				self:BehaveStart()
			return end
		end

		self:CustomChaseEnemy()
		self:CheckRangeToEnemy()

		if nb_attackprop:GetInt() == 1 then
			if enemy and enemy:IsValid() and enemy:Health() > 0 then
				if self:GetRangeTo( enemy ) < 25 or self:AttackObject() then
				elseif self:GetRangeTo( enemy ) < 25 or self:AttackDoor() then
				end
			end
		end

		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, self:GetEnemy():GetPos() ) end
		end

		coroutine.yield()
	end
	return "ok"
end

function ENT:GetDoor(ent)

	local doors = {}
	doors[1] = "models/props_c17/door01_left.mdl"
	doors[2] = "models/props_c17/door02_double.mdl"
	doors[3] = "models/props_c17/door03_left.mdl"
	doors[4] = "models/props_doors/door01_dynamic.mdl"
	doors[5] = "models/props_doors/door03_slotted_left.mdl"
	doors[6] = "models/props_interiors/elevatorshaft_door01a.mdl"
	doors[7] = "models/props_interiors/elevatorshaft_door01b.mdl"
	doors[8] = "models/props_silo/silo_door01_static.mdl"
	doors[9] = "models/props_wasteland/prison_celldoor001b.mdl"
	doors[10] = "models/props_wasteland/prison_celldoor001a.mdl"

	doors[11] = "models/props_radiostation/radio_metaldoor01.mdl"
	doors[12] = "models/props_radiostation/radio_metaldoor01a.mdl"
	doors[13] = "models/props_radiostation/radio_metaldoor01b.mdl"
	doors[14] = "models/props_radiostation/radio_metaldoor01c.mdl"


	for k,v in pairs( doors ) do
		if !IsValid( ent ) then break end
		if ent:GetModel() == v and string.find(ent:GetClass(), "door") then
			return "door"
		end
	end

end

function ENT:AttackDoor()

	local door = ents.FindInSphere(self:GetPos(),25)
		if door then
			for i = 1, #door do
				local v = door[i]
					if self:GetDoor( v ) == "door" then

					if v.Hitsleft == nil then
						v.Hitsleft = 10
					end

					if v != NULL and v.Hitsleft > 0 then

						if (self:GetRangeTo(v) < (self.DoorAttackRange)) then

							if self.loco:GetVelocity( Vector( 0,0,0 ) ) then
								self:SetPoseParameter( "move_x", 0 )
							else
								self:SetPoseParameter( "move_x", self.WalkSpeedAnimation )
							end

							self:CustomDoorAttack( v )

						end

					end

					if v != NULL and v.Hitsleft < 1 then

						local door = ents.Create("prop_physics")
						if door then
						door:SetModel(v:GetModel())
						door:SetPos(v:GetPos())
						door:SetAngles(v:GetAngles())
						door:Spawn()
						door.FalseProp = true
						door:EmitSound("Wood_Plank.Break")

						local phys = door:GetPhysicsObject()
						if (phys != nil && phys != NULL && phys:IsValid()) then
						phys:ApplyForceCenter(self:GetForward():GetNormalized()*20000 + Vector(0, 0, 2))
						end

						door:SetSkin(v:GetSkin())
						door:SetColor(v:GetColor())
						door:SetMaterial(v:GetMaterial())

						SafeRemoveEntity( v )

						end

						self:BehaveStart()

					end
				end
			end
		end
end

function ENT:CustomChaseEnemy()

end

function ENT:CustomDoorAttack( ent )
end


function ENT:CustomPropAttack( ent )
end

function ENT:CheckProp( ent )
	if !ent:IsValid() then return end

	if ent:GetPhysicsObject():GetVolume() < 2600 then
		if (phys != nil && phys != NULL && phys:IsValid() ) then
		
		if ent:GetModel() == "models/props_debris/wood_board06a.mdl" or ent:GetModel() == "models/props_debris/wood_board05a.mdl" or ent:GetModel() == "models/props_debris/wood_board05a.mdl" then
			return true
		elseif ent:GetModel() == "models/props_debris/wood_board05a.mdl" or ent:GetModel() == "models/props_debris/wood_board04a.mdl" or ent:GetModel() == "models/props_debris/wood_board03a.mdl" then
			return true
		elseif ent:GetModel() == "models/props_debris/wood_board07a.mdl" or ent:GetModel() == "models/props_debris/wood_board02a.mdl" then
			return true
		end

		end
		return false
	end

	if ent:GetPhysicsObject():GetVolume() > 500000 then
		return false
	end
	
	print( ent:GetPhysicsObject():GetVolume() )
	return true
end

function ENT:AttackObject()
	local entstoattack = ents.FindInSphere(self:GetPos(), 25)
	for _,v in pairs(entstoattack) do

		if ( v:GetClass() == "func_breakable" || v:GetClass() == "func_physbox" || v:GetClass() == "prop_physics_multiplayer" || v:GetClass() == "prop_physics" ) then
		if v.FalseProp then return end
		if !self:CheckProp( v ) then return end

		self:CustomPropAttack( v )

			return true
		end
	end
	return false
end

function ENT:OnIgnite()
end

function ENT:OnKilled( damageInfo )
	self:CustomDeath( damageInfo )
	self:DeathSound()
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

		SafeRemoveEntity( self )
	end
end

function ENT:BleedVisual( time, pos, dmginfo )
	local bleed = ents.Create("info_particle_system")
	bleed:SetKeyValue("effect_name", "blood_impact_red_01")
	bleed:SetPos( pos )
	bleed:Spawn()
	bleed:Activate()
	bleed:Fire("Start", "", 0)
	bleed:Fire("Kill", "", time)
end

function ENT:InjureCheck( attacker1, attacker2 )
	if ai_ignoreplayers:GetInt() == 1 and attacker1 then
		return false
	end

	if ai_ignoreplayers:GetInt() == 1 and nb_npc:GetInt() == 0 and ( attacker1 or attacker2 ) then
		return false
	end

	if nb_npc:GetInt() == 0 and attacker2 then
		return false
	end

	return true
end

function ENT:OnInjured( dmginfo )

	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	local player = attacker:IsPlayer()
	local npc = attacker:IsNPC()

	if self.HasNoEnemy then
		if self:IsValid() and self:Health() > 0 then
			if ( player or npc ) then
				if self:GetRangeTo( attacker ) < 1000 then
					if self:InjureCheck( player, npc ) then
						self:SetEnemy( attacker )
					end
				else
					if self:InjureCheck( player, npc ) then
						self:FaceTowards( attacker )
						self.SearchRadius = self.SearchRadius + 500
					end
				end
			end
		end
	else
		if ( self.NextEnemyHit or 0 ) < CurTime() then
			if self:IsValid() and self:Health() > 0 then
				if ( player or npc ) then

					if !self.Enemy then return end
					if !self.Enemy:IsValid() then return end
					if self.Enemy:Health() < 0 then return end
				
					if self:GetRangeTo( self.Enemy ) > 150 then
				
						if self:GetRangeTo( attacker ) > self:GetRangeTo( self.Enemy ) then
							if self:InjureCheck( player, npc ) then
								self:SetEnemy( attacker )
								self.NextEnemyHit = CurTime() + 4
							end
						end
					
					end
					
				end
			end
		end
	end

	if self.nxtPainSound then
		self:PainSound( dmginfo )
	end

	self:CustomInjure( dmginfo )

	if dmginfo:IsExplosionDamage() then

		local explosion = dmginfo:GetInflictor():GetOwner()
		if explosion:IsValid() then
			if explosion:IsPlayer() or explosion:IsNPC() then

				dmginfo:ScaleDamage( 5 )

				if math.random(1,2) == 1 then
					self:Ignite( 10, 60 )
				end

			end
		end

	end

end

function ENT:BuddyKilled( victim, dmginfo )

	local attacker = dmginfo:GetAttacker()
	if self:GetRangeTo( attacker ) < 500 then
		self:SetEnemy( attacker )
	elseif self:GetRangeTo( victim ) < 1000 then
		self.SearchRadius = self.SearchRadius + 500
		self:FaceTowards( victim )
		self.loco:Approach( victim:GetPos(), 100)
	end

end

function ENT:OnOtherKilled( victim, dmginfo )

	if self.HasNoEnemy then
		if victim:GetClass("nazi_zombie_*", "npc_nextbot_*", "mob_zombie_*", "nz_*") and victim != self then

			if nb_npc:GetInt() == 1 then
				if dmginfo:GetAttacker():IsNPC() or dmginfo:GetAttacker():IsPlayer() then
					self:BuddyKilled( victim, dmginfo )
				end
			elseif ai_ignoreplayer:GetInt() == 1 then
				if dmginfo:GetAttacker():IsNPC() then
					self:BuddyKilled( victim, dmginfo )
				end
			else
				if dmginfo:GetAttacker():IsPlayer() then
					self:BuddyKilled( victim, dmginfo )
				end
			end

		end
	end

end

function ENT:GetEnemy()
	return self.Enemy
end

function ENT:SetEnemy( ent )

	self.Enemy = ent

	if ent != nil then
		if !ent:IsValid() then return end
		if ent:Health() < 0 then return end

		self:AlertSound()
	end

end

function ENT:CheckEnemyClass()

end

function ENT:SearchForEnemy( ents )

	for k,v in pairs( ents ) do

		if nb_targetmethod:GetInt() == 1 then
	
			if self:IsLineOfSightClear( v ) then 
			
			else
		
				return end
		
		end
		
		if nb_npc:GetInt() == 1 then

			local enemy = math.random(1,2)

			if enemy == 1 then
				if v:IsPlayer() and v:Alive() then
					if ai_ignoreplayers:GetInt() == 0 then
						if v:Team() != nb_ignoreteam:GetInt() then
							self:SetEnemy( v )
							return true
						end
					end
				else
					if v:IsNPC() and v != self and !string.find(v:GetClass(), "npc_nextbot_*") and !string.find(v:GetClass(), "npc_bullseye") and !string.find(v:GetClass(), "npc_grenade_frag") and !string.find(v:GetClass(), "animprop_generic") then
						self:SetEnemy( v )
						return true
					end
				end
			else
				if v:IsNPC() and v != self and !string.find(v:GetClass(), "npc_nextbot_*") and !string.find(v:GetClass(), "npc_bullseye") and !string.find(v:GetClass(), "npc_grenade_frag") and !string.find(v:GetClass(), "animprop_generic") then
					self:SetEnemy( v )
					return true
				end
			end

		else

			if v:IsPlayer() and v:Alive() then
				if ai_ignoreplayers:GetInt() == 0 then
					if v:Team() != ignoreteam then
						self:SetEnemy( v )
						return true
					end
				end
			end

		end

	end

	self:SetEnemy( nil )
	return false
	
end

function ENT:FindEnemy()

	if nb_targetmethod:GetInt() == 1 then
		self:SearchForEnemy( ents.FindInCone( self:GetPos(), self:GetForward() * self.SearchRadius, self.SearchRadius, 155 ) )
	else
	
		local players = player.GetAll()
		local npcs = ents.FindByClass("npc_*")

		local entities = {}

		if players != nil then
			table.Add( entities, players )
		end

		if npcs != nil then
			table.Add( entities, npcs )
		end
		
		self:SearchForEnemy( entities )

	end

end

function ENT:HaveEnemy()

	local enemy = self:GetEnemy()

	if ( enemy and IsValid( enemy ) ) then
		if ( enemy:IsPlayer() and !enemy:Alive() ) then
			return self:FindEnemy()
		elseif ( enemy:IsNPC() and enemy:Health() < 0 ) then
			return self:FindEnemy()
	end

		return true
	else
		return self:FindEnemy()
	end
end