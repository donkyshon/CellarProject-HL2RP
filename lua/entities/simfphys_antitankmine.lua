AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName		= "Anti Tank Mine"
ENT.Author		= "Blu"
ENT.Information		= "destroys tanks when they run over it"
ENT.Category		= "simfphys"

ENT.Spawnable       = false
ENT.AdminSpawnable  = false

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )

		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent.Attacker = ply
		ent:SetPos( tr.HitPos + tr.HitNormal )
		ent:Spawn()
		ent:Activate()

		return ent

	end

	function ENT:Initialize()	
		self:SetModel( "models/blu/mine.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON  )
	end
	
	function ENT:Use( ply )
		if not IsValid( self.Defusor ) then
			self.Defusor = ply
			self.DefuseTime = CurTime()
			
			self:EmitSound( "weapons/357/357_reload4.wav" )
			
			ply:PrintMessage( HUD_PRINTTALK, "defusing...")
		end
	end
	
	function ENT:SetAttacker( ent )
		self.Attacker = ent
	end
	
	function ENT:Explode()
		if self.IsExploded then return end
		
		self.IsExploded = true
		
		local Pos = self:GetPos()
		local Attacker = IsValid( self.Attacker ) and self.Attacker or self
		
		util.BlastDamage( self, Attacker, Pos, 100, 500 )
		
		local effectdata = EffectData()
			effectdata:SetOrigin( Pos )
		util.Effect( "simfphys_tankweapon_explosion_micro", effectdata, true, true )
		
		if IsValid( self.Target ) then
			local effectdata = EffectData()
				effectdata:SetOrigin( Pos )
				effectdata:SetNormal( Vector(0,0,1) )
			util.Effect( "manhacksparks", effectdata, true, true )

			local dmginfo = DamageInfo()
				dmginfo:SetDamage( 3000 )
				dmginfo:SetAttacker( Attacker )
				dmginfo:SetDamageType( DMG_DIRECT )
				dmginfo:SetInflictor( self ) 
				dmginfo:SetDamagePosition( Pos ) 
			self.Target:TakeDamageInfo( dmginfo )
			
			sound.Play( "doors/vent_open3.wav", Pos, 140)
		end

		self:Remove()
	end

	function ENT:Think()	
		local curtime = CurTime()
		
		local PhysObj = self:GetPhysicsObject()
		if self.Thrown and IsValid( PhysObj ) then
			if self:GetVelocity():Length() <= 10 and PhysObj:GetAngleVelocity():Length() <= 10 then
				self.Thrown = false
			end
		end
		
		if self.MarkedForDestruction then 
			self:Explode()
		end
		
		if IsValid( self.Defusor ) and isnumber( self.DefuseTime ) then
			if self.Defusor:KeyDown( IN_USE ) and (self:GetPos() - self.Defusor:GetPos()):Length() < 100 then
				if curtime - self.DefuseTime > 2 then
					sound.Play( "weapons/357/357_reload3.wav", self:GetPos() )
					
					local Mine = ents.Create( "weapon_simmines" ) 
					Mine:SetPos( self.Defusor:GetShootPos() )
					--Mine:SetAngles( self:GetAngles() )
					Mine:Spawn()
					Mine:Activate()
					
					self.Defusor:PrintMessage( HUD_PRINTTALK, "...defused")
					
					if self.Defusor:HasWeapon( "weapon_simmines" )  then
						self.Defusor:SelectWeapon( "weapon_simmines" )
					end
					
					self:Remove()
				end
			else
				self.Defusor:PrintMessage( HUD_PRINTTALK, "...cancelled")
				self.Defusor = nil
				self:EmitSound( "weapons/357/357_reload1.wav" )
			end
		end
	
		self:NextThink( curtime )
		
		return true
	end

	function ENT:OnRemove()
	end

	function ENT:PhysicsCollide( data, physobj )
		if self.MarkedForDestruction then return end
		
		local HitEnt = data.HitEntity
		
		if not IsValid( HitEnt ) or HitEnt:IsWorld() then 
			if ( data.Speed > 60 && data.DeltaTime > 0.1 ) then
				self:EmitSound( "weapon.ImpactHard" )
			end
			
			return
		end
		
		if HitEnt:GetMoveType() == MOVETYPE_VPHYSICS and not self.Thrown then

			local PhysObj = HitEnt:GetPhysicsObject()

			if IsValid( PhysObj ) then
				if PhysObj:IsMotionEnabled() then
				
					local Class = HitEnt:GetClass():lower()

					if Class ~= "simfphys_antitankmine" then
						self.MarkedForDestruction = true

						if Class == "gmod_sent_vehicle_fphysics_wheel" then
							self.Target = HitEnt:GetBaseEnt()
						else
							self.Target = HitEnt
						end
					end
				end
			end
		else
			if ( data.Speed > 60 && data.DeltaTime > 0.1 ) then
				self:EmitSound( "weapon.ImpactHard" )
			end
		end
	end

	function ENT:OnTakeDamage( dmginfo )
		--self:Explode()
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName		= "Anti Tank Mine"
ENT.Author		= "Blu"
ENT.Information		= "destroys tanks when they run over it"
ENT.Category		= "simfphys"

ENT.Spawnable       = false
ENT.AdminSpawnable  = false

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )

		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent.Attacker = ply
		ent:SetPos( tr.HitPos + tr.HitNormal )
		ent:Spawn()
		ent:Activate()

		return ent

	end

	function ENT:Initialize()	
		self:SetModel( "models/blu/mine.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON  )
	end
	
	function ENT:Use( ply )
		if not IsValid( self.Defusor ) then
			self.Defusor = ply
			self.DefuseTime = CurTime()
			
			self:EmitSound( "weapons/357/357_reload4.wav" )
			
			ply:PrintMessage( HUD_PRINTTALK, "defusing...")
		end
	end
	
	function ENT:SetAttacker( ent )
		self.Attacker = ent
	end
	
	function ENT:Explode()
		if self.IsExploded then return end
		
		self.IsExploded = true
		
		local Pos = self:GetPos()
		local Attacker = IsValid( self.Attacker ) and self.Attacker or self
		
		util.BlastDamage( self, Attacker, Pos, 100, 500 )
		
		local effectdata = EffectData()
			effectdata:SetOrigin( Pos )
		util.Effect( "simfphys_tankweapon_explosion_micro", effectdata, true, true )
		
		if IsValid( self.Target ) then
			local effectdata = EffectData()
				effectdata:SetOrigin( Pos )
				effectdata:SetNormal( Vector(0,0,1) )
			util.Effect( "manhacksparks", effectdata, true, true )

			local dmginfo = DamageInfo()
				dmginfo:SetDamage( 3000 )
				dmginfo:SetAttacker( Attacker )
				dmginfo:SetDamageType( DMG_DIRECT )
				dmginfo:SetInflictor( self ) 
				dmginfo:SetDamagePosition( Pos ) 
			self.Target:TakeDamageInfo( dmginfo )
			
			sound.Play( "doors/vent_open3.wav", Pos, 140)
		end

		self:Remove()
	end

	function ENT:Think()	
		local curtime = CurTime()
		
		local PhysObj = self:GetPhysicsObject()
		if self.Thrown and IsValid( PhysObj ) then
			if self:GetVelocity():Length() <= 10 and PhysObj:GetAngleVelocity():Length() <= 10 then
				self.Thrown = false
			end
		end
		
		if self.MarkedForDestruction then 
			self:Explode()
		end
		
		if IsValid( self.Defusor ) and isnumber( self.DefuseTime ) then
			if self.Defusor:KeyDown( IN_USE ) and (self:GetPos() - self.Defusor:GetPos()):Length() < 100 then
				if curtime - self.DefuseTime > 2 then
					sound.Play( "weapons/357/357_reload3.wav", self:GetPos() )
					
					local Mine = ents.Create( "weapon_simmines" ) 
					Mine:SetPos( self.Defusor:GetShootPos() )
					--Mine:SetAngles( self:GetAngles() )
					Mine:Spawn()
					Mine:Activate()
					
					self.Defusor:PrintMessage( HUD_PRINTTALK, "...defused")
					
					if self.Defusor:HasWeapon( "weapon_simmines" )  then
						self.Defusor:SelectWeapon( "weapon_simmines" )
					end
					
					self:Remove()
				end
			else
				self.Defusor:PrintMessage( HUD_PRINTTALK, "...cancelled")
				self.Defusor = nil
				self:EmitSound( "weapons/357/357_reload1.wav" )
			end
		end
	
		self:NextThink( curtime )
		
		return true
	end

	function ENT:OnRemove()
	end

	function ENT:PhysicsCollide( data, physobj )
		if self.MarkedForDestruction then return end
		
		local HitEnt = data.HitEntity
		
		if not IsValid( HitEnt ) or HitEnt:IsWorld() then 
			if ( data.Speed > 60 && data.DeltaTime > 0.1 ) then
				self:EmitSound( "weapon.ImpactHard" )
			end
			
			return
		end
		
		if HitEnt:GetMoveType() == MOVETYPE_VPHYSICS and not self.Thrown then

			local PhysObj = HitEnt:GetPhysicsObject()

			if IsValid( PhysObj ) then
				if PhysObj:IsMotionEnabled() then
				
					local Class = HitEnt:GetClass():lower()

					if Class ~= "simfphys_antitankmine" then
						self.MarkedForDestruction = true

						if Class == "gmod_sent_vehicle_fphysics_wheel" then
							self.Target = HitEnt:GetBaseEnt()
						else
							self.Target = HitEnt
						end
					end
				end
			end
		else
			if ( data.Speed > 60 && data.DeltaTime > 0.1 ) then
				self:EmitSound( "weapon.ImpactHard" )
			end
		end
	end

	function ENT:OnTakeDamage( dmginfo )
		--self:Explode()
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end