AddCSLuaFile()
ENT.Type = "anim"

ENT.Author			= "Shermann Wolf"
ENT.Contact			= "shermannwolf@gmail.com"
ENT.PrintName		= "Anti-Missile Flare"
ENT.Purpose			= " "
ENT.Instructions			= ""
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Model = "models/sw/avia/bombs/flare.mdl"
ENT.DeployDelay = 10

function ENT:Initialize()

	self:SetModel( self.Model)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )	
	self:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.Owner = self.Owner or self:GetOwner()
	if IsValid(self.Owner) then
		self:SetOwner(self.Owner)
	end
	
	-- if( CLIENT ) then 
		
		-- self:CreateParticleEffect("microplane_explosion", 0 )
	
	-- end 
	self:Fire("Kill","",5 )
	
end

function ENT:Think()
	local p = self:GetPhysicsObject()
	local v = p:GetAngleVelocity()
	local v1 = p:GetVelocity()
	local m = 150
	p:AddAngleVelocity(Vector(25*m,25*m,0))
	p:SetVelocity(Vector(v1.x,v1.y,v1.z))

	for k, v in pairs ( ents.FindInSphere( self.Entity:GetPos(), 40 ) ) do	
		if v:IsPlayer() || v:IsNPC() || v:IsVehicle()then
		local trace = {}						// Make sure theres not a wall in between
		trace.start = self.Entity:GetPos()
		trace.endpos = v:GetPos()			// Trace to the torso
		trace.filter = self.Entity
		local tr = util.TraceLine( trace )				// If the trace hits a living thing then
		end
	end
	
local flare = self:GetPos()
	for k,v in pairs( ents.FindInSphere( self:GetPos(), 2000 ) ) do -- Works for all my homing missiles and default LFS homing missiles
		local targstring = v.Target
		if( IsValid( v ) && IsValid( v.Target ) ) && !string.EndsWith(tostring(targstring), "gtav_cm_flare]") then		
			v.Target = self
			if IsFirstTimePredicted() then
				timer.Simple(2,function() 
					if IsValid(v) then
						v:Detonate()
					end
				end)
			end
		end
		if ( IsValid(v) ) and v:GetClass() == "wac_base_grocket" then 
			v.target = (self)
		end
		if ( IsValid(v) ) and v:GetClass() == "sw_aam" then 
			v.target = (self)
		end
		-- LFS missiles that are actively tracking a target
		if ( IsValid(v) ) and v:GetClass() == "lunasflightschool_missile" and IsValid(v:GetLockOn()) then 
			v:SetLockOn( self )
			if IsFirstTimePredicted() then
				timer.Simple(4,function() 
					if IsValid(v) then
						v:Detonate()
					end
				end)
			end
		end

		--WAC hellfires
		if ( IsValid(v) ) and v:GetClass()  == "wac_hc_rocket" then
			v.target = self
		end
		
		-- Homing Missiles from Drones Rewrite
		if ( IsValid(v) ) and v:GetClass() == "dronesrewrite_rocketbig" then
			v.Enemy = self
			if IsFirstTimePredicted() then
				timer.Simple(1,function() 
					if IsValid(v) then
						v:Boom()
					end
				end)
			end
		end
		
		-- Just your average HL2 Missile
		if ( IsValid(v) ) and v:GetClass() == "rpg_missile" then 
			local d = DamageInfo()
			d:SetDamage( 100 )
			d:SetAttacker(self)
			d:SetDamageType( DMG_MISSILEDEFENSE )
			v:TakeDamageInfo( d )
		end
	end 
	self:NextThink( CurTime() + .2 )
	
end

if CLIENT then 
local emitter = ParticleEmitter(Vector(0, 0, 0))
function ENT:Initialize()
	self.lifetime = RealTime()
	self.cooltime = CurTime()
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	local color = 255 
	local SCALE = .5
	local dlight = DynamicLight( self:EntIndex() )

		--local c = Color( 200+math.random(-5,5), 30+math.random(-5,5), 0, 255 )

		dlight.Pos = self:GetPos()
		dlight.r = 255
		dlight.g = 100
		dlight.b = 100
		dlight.Brightness = math.Rand(0.1,2.9)
		dlight.Decay = 0.1
		dlight.Size = 1024*SCALE
		dlight.DieTime = CurTime() + 0.15

	

	local dist = 0
	if (self.cooltime < CurTime()) then
		local smoke = emitter:Add("effects/smoke_a", self:GetPos() + self:GetForward()*-dist)
		smoke:SetVelocity(self:GetForward()*-10)
		smoke:SetDieTime(math.Rand(0.5,0.85))
		smoke:SetStartAlpha(190)
		smoke:SetEndAlpha(0)
		smoke:SetStartSize(20)
		smoke:SetEndSize(40)
		smoke:SetRoll(math.Rand(180,480))
		smoke:SetRollDelta(math.Rand(-4,2))
		smoke:SetGravity( Vector( 0, math.random(1,90), math.random(151,355) ) )
		smoke:SetColor( 155,155, 155 )
		smoke:SetAirResistance(50)

		local fire = emitter:Add("effects/yellowflare", self:GetPos() + self:GetForward()*-dist)
		fire:SetVelocity(self:GetForward()*-10)
		fire:SetDieTime(math.Rand(.03,.05))
		fire:SetStartAlpha(250)
		fire:SetEndAlpha(250)
		fire:SetStartSize(300)
		fire:SetEndSize(100)
		fire:SetAirResistance(150)
		fire:SetRoll(math.Rand(180,480))
		fire:SetRollDelta(math.Rand(-3,3))
		fire:SetColor(220,150,0)

		self.cooltime = CurTime() + .0001
	end
end

end

function ENT:OnRemove()
end

function ENT:PhysicsUpdate()
end

function ENT:PhysicsCollide()
end