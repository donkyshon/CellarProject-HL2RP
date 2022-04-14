--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile()

ENT.Type            = "anim"

function ENT:SetupDataTables()
	self:NetworkVar( "Bool",0, "Disabled" )
	self:NetworkVar( "Bool",1, "CleanMissile" )
	self:NetworkVar( "Bool",2, "DirtyMissile" )
	self:NetworkVar( "Entity",0, "Attacker" )
	self:NetworkVar( "Entity",1, "Inflictor" )
	self:NetworkVar( "Entity",2, "LockOn" )
	self:NetworkVar( "Float",0, "StartVelocity" )
end

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )

		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal * 20 )
		ent:Spawn()
		ent:Activate()

		return ent

	end

	function ENT:BlindFire()
		if self:GetDisabled() then return end
		
		local pObj = self:GetPhysicsObject()
		
		if IsValid( pObj ) then
			pObj:SetVelocityInstantaneous( self:GetForward() * (self:GetStartVelocity() + 3000) )
		end
	end
	
	function ENT:FollowTarget( followent )
		local speed = self:GetStartVelocity() + (self:GetDirtyMissile() and 5000 or 3500)
		local turnrate = (self:GetCleanMissile() or self:GetDirtyMissile()) and 60 or 50
		
		local TargetPos = followent:LocalToWorld( followent:OBBCenter() )
		
		if isfunction( followent.GetMissileOffset ) then
			local Value = followent:GetMissileOffset()
			if isvector( Value ) then
				TargetPos = followent:LocalToWorld( Value )
			end
		end
		
		local pos = TargetPos + followent:GetVelocity() * 0.25
		
		local pObj = self:GetPhysicsObject()
		
		if IsValid( pObj ) then
			if not self:GetDisabled() then
				local targetdir = (pos - self:GetPos()):GetNormalized()
				
				local AF = self:WorldToLocalAngles( targetdir:Angle() )
				AF.p = math.Clamp( AF.p * 400,-turnrate,turnrate )
				AF.y = math.Clamp( AF.y * 400,-turnrate,turnrate )
				AF.r = math.Clamp( AF.r * 400,-turnrate,turnrate )
				
				local AVel = pObj:GetAngleVelocity()
				pObj:AddAngleVelocity( Vector(AF.r,AF.p,AF.y) - AVel ) 
				
				pObj:SetVelocityInstantaneous( self:GetForward() * speed )
			end
		end
	end

	function ENT:Initialize()	
		self:SetModel( "models/weapons/w_missile_launch.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:PhysWake()
		local pObj = self:GetPhysicsObject()
		
		if IsValid( pObj ) then
			pObj:EnableGravity( false ) 
			pObj:SetMass( 1 ) 
		end
		
		self.SpawnTime = CurTime()
	end

	function ENT:Think()	
		local curtime = CurTime()
		self:NextThink( curtime )
		
		local Target = self:GetLockOn()
		if IsValid( Target ) then
			self:FollowTarget( Target )
		else
			self:BlindFire()
		end
		
		if self.MarkForRemove then
			self:Detonate()
		end
		
		if self.Explode then
			local Inflictor = self:GetInflictor()
			local Attacker = self:GetAttacker()

			util.BlastDamage( IsValid( Inflictor ) and Inflictor or Entity(0), IsValid( Attacker ) and Attacker or Entity(0), self:GetPos(),250,100)
			
			self:Detonate()
		end
		
		if (self.SpawnTime + 12) < curtime then
			self:Detonate()
		end
		
		return true
	end

	local IsThisSimfphys = {
		["gmod_sent_vehicle_fphysics_base"] = true,
		["gmod_sent_vehicle_fphysics_wheel"] = true,
	}
	
	function ENT:PhysicsCollide( data )
		if self:GetDisabled() then
			self.MarkForRemove = true
		else
			local HitEnt = data.HitEntity
			
			if IsValid( HitEnt ) and not self.Explode then 
				local Class = HitEnt:GetClass():lower()

				if IsThisSimfphys[ Class ] then
					local Pos = self:GetPos()
					
					if Class == "gmod_sent_vehicle_fphysics_wheel" then
						HitEnt = HitEnt:GetBaseEnt()
					end

					local effectdata = EffectData()
						effectdata:SetOrigin( Pos )
						effectdata:SetNormal( -self:GetForward() )
					util.Effect( "manhacksparks", effectdata, true, true )

					local dmginfo = DamageInfo()
						dmginfo:SetDamage( 1000 )
						dmginfo:SetAttacker( IsValid( self:GetAttacker() ) and self:GetAttacker() or self )
						dmginfo:SetDamageType( DMG_DIRECT )
						dmginfo:SetInflictor( self ) 
						dmginfo:SetDamagePosition( Pos ) 
					HitEnt:TakeDamageInfo( dmginfo )
					
					sound.Play( "Missile.ShotDown", Pos, 140)
				end

				if HitEnt.LFS or HitEnt.IdentifiesAsLFS then
					local Pos = self:GetPos()

					local effectdata = EffectData()
						effectdata:SetOrigin( Pos )
						effectdata:SetNormal( -self:GetForward() )
					util.Effect( "manhacksparks", effectdata, true, true )

					local dmginfo = DamageInfo()
						dmginfo:SetDamage( 400 )
						dmginfo:SetAttacker( IsValid( self:GetAttacker() ) and self:GetAttacker() or self )
						dmginfo:SetDamageType( DMG_DIRECT )
						dmginfo:SetInflictor( self ) 
						dmginfo:SetDamagePosition( Pos ) 
					HitEnt:TakeDamageInfo( dmginfo )

					sound.Play( "Missile.ShotDown", Pos, 140)
				end
			end
			
			self.Explode = true
		end
	end

	function ENT:BreakMissile()
		if not self:GetDisabled() then
			self:SetDisabled( true )
			
			local pObj = self:GetPhysicsObject()
			
			if IsValid( pObj ) then
				pObj:EnableGravity( true )
				self:PhysWake()
				self:EmitSound( "Missile.ShotDown" )
			end
		end
	end

	function ENT:Detonate()
		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
		util.Effect( "lfs_missile_explosion", effectdata )

		self:Remove()
	end

	function ENT:OnTakeDamage( dmginfo )	
		if dmginfo:GetDamageType() ~= DMG_AIRBOAT then return end
		
		if self:GetAttacker() == dmginfo:GetAttacker() then return end
		
		self:BreakMissile()
	end
else
	function ENT:Initialize()	
		self.snd = CreateSound(self, "weapons/flaregun/burn.wav")
		self.snd:Play()

		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			effectdata:SetEntity( self )
		util.Effect( "lfs_missile_trail", effectdata )
	end

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:SoundStop()
		if self.snd then
			self.snd:Stop()
		end
	end

	function ENT:Think()
		if self:GetDisabled() then 
			self:SoundStop()
		end

		return true
	end

	function ENT:OnRemove()
		self:SoundStop()
	end
end
--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile()

ENT.Type            = "anim"

function ENT:SetupDataTables()
	self:NetworkVar( "Bool",0, "Disabled" )
	self:NetworkVar( "Bool",1, "CleanMissile" )
	self:NetworkVar( "Bool",2, "DirtyMissile" )
	self:NetworkVar( "Entity",0, "Attacker" )
	self:NetworkVar( "Entity",1, "Inflictor" )
	self:NetworkVar( "Entity",2, "LockOn" )
	self:NetworkVar( "Float",0, "StartVelocity" )
end

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )

		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal * 20 )
		ent:Spawn()
		ent:Activate()

		return ent

	end

	function ENT:BlindFire()
		if self:GetDisabled() then return end
		
		local pObj = self:GetPhysicsObject()
		
		if IsValid( pObj ) then
			pObj:SetVelocityInstantaneous( self:GetForward() * (self:GetStartVelocity() + 3000) )
		end
	end
	
	function ENT:FollowTarget( followent )
		local speed = self:GetStartVelocity() + (self:GetDirtyMissile() and 5000 or 3500)
		local turnrate = (self:GetCleanMissile() or self:GetDirtyMissile()) and 60 or 50
		
		local TargetPos = followent:LocalToWorld( followent:OBBCenter() )
		
		if isfunction( followent.GetMissileOffset ) then
			local Value = followent:GetMissileOffset()
			if isvector( Value ) then
				TargetPos = followent:LocalToWorld( Value )
			end
		end
		
		local pos = TargetPos + followent:GetVelocity() * 0.25
		
		local pObj = self:GetPhysicsObject()
		
		if IsValid( pObj ) then
			if not self:GetDisabled() then
				local targetdir = (pos - self:GetPos()):GetNormalized()
				
				local AF = self:WorldToLocalAngles( targetdir:Angle() )
				AF.p = math.Clamp( AF.p * 400,-turnrate,turnrate )
				AF.y = math.Clamp( AF.y * 400,-turnrate,turnrate )
				AF.r = math.Clamp( AF.r * 400,-turnrate,turnrate )
				
				local AVel = pObj:GetAngleVelocity()
				pObj:AddAngleVelocity( Vector(AF.r,AF.p,AF.y) - AVel ) 
				
				pObj:SetVelocityInstantaneous( self:GetForward() * speed )
			end
		end
	end

	function ENT:Initialize()	
		self:SetModel( "models/weapons/w_missile_launch.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:PhysWake()
		local pObj = self:GetPhysicsObject()
		
		if IsValid( pObj ) then
			pObj:EnableGravity( false ) 
			pObj:SetMass( 1 ) 
		end
		
		self.SpawnTime = CurTime()
	end

	function ENT:Think()	
		local curtime = CurTime()
		self:NextThink( curtime )
		
		local Target = self:GetLockOn()
		if IsValid( Target ) then
			self:FollowTarget( Target )
		else
			self:BlindFire()
		end
		
		if self.MarkForRemove then
			self:Detonate()
		end
		
		if self.Explode then
			local Inflictor = self:GetInflictor()
			local Attacker = self:GetAttacker()

			util.BlastDamage( IsValid( Inflictor ) and Inflictor or Entity(0), IsValid( Attacker ) and Attacker or Entity(0), self:GetPos(),250,100)
			
			self:Detonate()
		end
		
		if (self.SpawnTime + 12) < curtime then
			self:Detonate()
		end
		
		return true
	end

	local IsThisSimfphys = {
		["gmod_sent_vehicle_fphysics_base"] = true,
		["gmod_sent_vehicle_fphysics_wheel"] = true,
	}
	
	function ENT:PhysicsCollide( data )
		if self:GetDisabled() then
			self.MarkForRemove = true
		else
			local HitEnt = data.HitEntity
			
			if IsValid( HitEnt ) and not self.Explode then 
				local Class = HitEnt:GetClass():lower()

				if IsThisSimfphys[ Class ] then
					local Pos = self:GetPos()
					
					if Class == "gmod_sent_vehicle_fphysics_wheel" then
						HitEnt = HitEnt:GetBaseEnt()
					end

					local effectdata = EffectData()
						effectdata:SetOrigin( Pos )
						effectdata:SetNormal( -self:GetForward() )
					util.Effect( "manhacksparks", effectdata, true, true )

					local dmginfo = DamageInfo()
						dmginfo:SetDamage( 1000 )
						dmginfo:SetAttacker( IsValid( self:GetAttacker() ) and self:GetAttacker() or self )
						dmginfo:SetDamageType( DMG_DIRECT )
						dmginfo:SetInflictor( self ) 
						dmginfo:SetDamagePosition( Pos ) 
					HitEnt:TakeDamageInfo( dmginfo )
					
					sound.Play( "Missile.ShotDown", Pos, 140)
				end

				if HitEnt.LFS or HitEnt.IdentifiesAsLFS then
					local Pos = self:GetPos()

					local effectdata = EffectData()
						effectdata:SetOrigin( Pos )
						effectdata:SetNormal( -self:GetForward() )
					util.Effect( "manhacksparks", effectdata, true, true )

					local dmginfo = DamageInfo()
						dmginfo:SetDamage( 400 )
						dmginfo:SetAttacker( IsValid( self:GetAttacker() ) and self:GetAttacker() or self )
						dmginfo:SetDamageType( DMG_DIRECT )
						dmginfo:SetInflictor( self ) 
						dmginfo:SetDamagePosition( Pos ) 
					HitEnt:TakeDamageInfo( dmginfo )

					sound.Play( "Missile.ShotDown", Pos, 140)
				end
			end
			
			self.Explode = true
		end
	end

	function ENT:BreakMissile()
		if not self:GetDisabled() then
			self:SetDisabled( true )
			
			local pObj = self:GetPhysicsObject()
			
			if IsValid( pObj ) then
				pObj:EnableGravity( true )
				self:PhysWake()
				self:EmitSound( "Missile.ShotDown" )
			end
		end
	end

	function ENT:Detonate()
		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
		util.Effect( "lfs_missile_explosion", effectdata )

		self:Remove()
	end

	function ENT:OnTakeDamage( dmginfo )	
		if dmginfo:GetDamageType() ~= DMG_AIRBOAT then return end
		
		if self:GetAttacker() == dmginfo:GetAttacker() then return end
		
		self:BreakMissile()
	end
else
	function ENT:Initialize()	
		self.snd = CreateSound(self, "weapons/flaregun/burn.wav")
		self.snd:Play()

		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			effectdata:SetEntity( self )
		util.Effect( "lfs_missile_trail", effectdata )
	end

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:SoundStop()
		if self.snd then
			self.snd:Stop()
		end
	end

	function ENT:Think()
		if self:GetDisabled() then 
			self:SoundStop()
		end

		return true
	end

	function ENT:OnRemove()
		self:SoundStop()
	end
end