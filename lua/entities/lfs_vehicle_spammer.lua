--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "AI Vehicle Spammer"
ENT.Author = "Luna"
ENT.Information = "AI Vehicle Spawner. Spammer in the hands of a Minge."
ENT.Category = "[LFS]"

ENT.Spawnable		= true
ENT.AdminOnly		= true
ENT.Editable = true

function ENT:SetupDataTables()
	local AllSents = scripted_ents.GetList() 
	local SpawnOptions = {}

	for _, v in pairs( AllSents ) do
		if v and istable( v.t ) then
			if v.t.Spawnable then
				if v.t.Base and string.StartWith( v.t.Base:lower(), "lunasflightschool_basescript" ) then
					if v.t.Category and v.t.PrintName then
						local nicename = v.t.Category.." - "..v.t.PrintName
						if not table.HasValue( SpawnOptions, nicename ) then
							SpawnOptions[nicename] = v.t.ClassName
						end
					end
				end
			end
		end
	end

	self:NetworkVar( "String",0, "Type",	{ KeyName = "Vehicle Type",Edit = { type = "Combo",	order = 1,values = SpawnOptions,category = "Vehicle-Options"} } )
	self:NetworkVar( "Int",3, "TeamOverride", { KeyName = "AI Team", Edit = { type = "Int", order = 4,min = -1, max = 3, category = "Vehicle-Options"} } )
	self:NetworkVar( "Int",4, "RespawnTime", { KeyName = "spawntime", Edit = { type = "Int", order = 5,min = 1, max = 120, category = "Vehicle-Options"} } )
	self:NetworkVar( "Int",5, "Amount", { KeyName = "amount", Edit = { type = "Int", order = 6,min = 1, max = 10, category = "Vehicle-Options"} } )
	self:NetworkVar( "Int",6, "SpawnWithSkin", { KeyName = "spawnwithskin", Edit = { type = "Int", order = 8,min = 0, max = 16, category = "Vehicle-Options"} } )
	self:NetworkVar( "Int",7, "SpawnWithHealth", { KeyName = "spawnwithhealth", Edit = { type = "Int", order = 9,min = 0, max = 50000, category = "Vehicle-Options"} } )
	self:NetworkVar( "Int",8, "SpawnWithShield", { KeyName = "spawnwithshield", Edit = { type = "Int", order = 10,min = 0, max = 50000, category = "Vehicle-Options"} } )

	self:NetworkVar( "Int",9, "UseHealth", { KeyName = "maxhealth", Edit = { type = "Int", order = 21,min = 0, max = 50000, category = "Spawner-Options"} } )
	self:NetworkVar( "Int",10, "SelfDestructAfterAmount", { KeyName = "selfdestructafteramount", Edit = { type = "Int", order = 22,min = 0, max = 100, category = "Spawner-Options"} } )
	self:NetworkVar( "Bool",2, "MasterSwitch" )

	if SERVER then
		self:NetworkVarNotify( "Type", self.OnTypeChanged )
		self:NetworkVarNotify( "UseHealth", self.OnUseHealthChanged )

		self:SetRespawnTime( 2 )
		self:SetAmount( 1 )
		self:SetSelfDestructAfterAmount( 0 )
		self:SetSpawnWithHealth( 0 )
		self:SetSpawnWithShield( 0 )
		self:SetTeamOverride( -1 )
	end
end

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )

		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent.dOwnerEntLFS = ply
		ent:SetPos( tr.HitPos + tr.HitNormal * 1 )
		ent:Spawn()
		ent:Activate()

		return ent

	end

	function ENT:GetHP()
		return isnumber( self.CurHP ) and self.CurHP or 0
	end

	function ENT:SetHP( value )
		self.CurHP = value
	end

	function ENT:OnUseHealthChanged( name, old, new)
		if new == old then return end

		self:SetHP( new )
	end

	function ENT:OnTakeDamage( dmginfo )
		self:TakePhysicsDamage( dmginfo )

		if self:GetUseHealth() <= 0 then return end

		local Damage = dmginfo:GetDamage()
		local CurHealth = self:GetHP()
		local NewHealth = math.Clamp( CurHealth - Damage , 0, self:GetUseHealth() )

		self:SetHP( NewHealth )

		if NewHealth <= 0 then
			if not self.MarkForRemove then
				self.MarkForRemove =  true
	
				for i = -5, 5 do
					local Pos = self:LocalToWorld( Vector(0,i * 100,10)  )

					timer.Simple( math.Rand(0,1), function()
						local effectdata = EffectData()
							effectdata:SetOrigin( Pos )
						util.Effect( "lfs_explosion_nodebris", effectdata )
					end)
				end
			end
		end
	end

	function ENT:Initialize()	
		self:SetModel( "models/props_phx/huge/road_medium.mdl" )
		
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )

		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		
		self.NextSpawn = 0
	end

	function ENT:Use( ply )
		if not IsValid( ply ) then return end

		if not IsValid( self.Defusor ) then
			self.Defusor = ply
			self.DefuseTime = CurTime()
		end
	end
	
	function ENT:Think()
		if IsValid( self.Defusor ) and isnumber( self.DefuseTime ) then
			if self.Defusor:KeyDown( IN_USE ) then
				if CurTime() - self.DefuseTime > 1 then
					self:SetMasterSwitch( not self:GetMasterSwitch() )

					for k, v in pairs( ents.FindByClass( "lfs_vehicle_spammer" ) ) do
						if v ~= self and IsValid( v ) then
							v:SetMasterSwitch( self:GetMasterSwitch() )
						end
					end

					if self:GetMasterSwitch() then
						self.Defusor:PrintMessage( HUD_PRINTTALK, "ALL AI-Spawners Enabled")
					else
						self.Defusor:PrintMessage( HUD_PRINTTALK, "ALL AI-Spawners Disabled")
					end

					self.Defusor = nil
				end
			else
				self:SetMasterSwitch( not self:GetMasterSwitch() )

				if self:GetMasterSwitch() then
					self.Defusor:PrintMessage( HUD_PRINTTALK, "AI-Spawner Enabled")
				else
					self.Defusor:PrintMessage( HUD_PRINTTALK, "AI-Spawner Disabled")
				end

				self.Defusor = nil
			end
		end

		if self.MarkForRemove then
			self:Remove()

			return
		end

		if not self:GetMasterSwitch() then return end

		self.spawnedvehicles = self.spawnedvehicles or {}
		
		if self.ShouldSpawn then
			if self.NextSpawn < CurTime() then
				
				self.ShouldSpawn = false
				
				local pos = self:LocalToWorld( Vector( 0, 500, 150 ) )
				local ang = self:LocalToWorldAngles( Angle( 0, -90, 0 ) )
				
				local Type = self:GetType()
				
				if Type ~= "" then
					local spawnedvehicle = ents.Create( Type )
					
					if IsValid( spawnedvehicle ) then
						spawnedvehicle:SetPos( pos )
						spawnedvehicle:SetAngles( ang )
						spawnedvehicle:Spawn()
						spawnedvehicle:Activate()
						spawnedvehicle:SetAI( true )
						spawnedvehicle:SetSkin( self:GetSpawnWithSkin() )

						if self:GetTeamOverride() >= 0 then
							spawnedvehicle:SetAITEAM( self:GetTeamOverride() )
						end

						if self:GetSpawnWithHealth() > 0 then
							spawnedvehicle.MaxHealth = self:GetSpawnWithHealth()
							spawnedvehicle:SetHP( self:GetSpawnWithHealth() )
						end

						if self:GetSpawnWithShield() > 0 then
							spawnedvehicle.MaxShield = self:GetSpawnWithShield()
							spawnedvehicle:SetShield( self:GetSpawnWithShield() )
						end

						if not spawnedvehicle.DontPushMePlease then
							local PhysObj = spawnedvehicle:GetPhysicsObject()
							
							if IsValid( PhysObj ) then
								PhysObj:SetVelocityInstantaneous( self:GetRight() * 1000 )
							end
						end

						table.insert( self.spawnedvehicles, spawnedvehicle )

						if self:GetSelfDestructAfterAmount() > 0 then
							self.RemoverCount = isnumber( self.RemoverCount ) and self.RemoverCount + 1 or 1

							if self.RemoverCount >= self:GetSelfDestructAfterAmount() then
								self:Remove()
							end
						end
					end
				end
			end
		else
			local AmountSpawned = 0
			for k,v in pairs( self.spawnedvehicles ) do
				if IsValid( v ) then
					AmountSpawned = AmountSpawned + 1
				else
					self.spawnedvehicles[k] = nil
				end
			end
			
			if AmountSpawned < self:GetAmount() then
				self.ShouldSpawn = true
				self.NextSpawn = CurTime() + self:GetRespawnTime()
			end
		end
		
		self:NextThink( CurTime() )
		
		return true
	end
end

if CLIENT then
	local mat = Material( "sprites/light_glow02_add" )
	
	function ENT:Draw()
		self:DrawModel()

		self.NextStep = self.NextStep or 0
		if self.NextStep < CurTime() then
			self.NextStep = CurTime() + 0.15

			self.PX = self.PX and self.PX + 125 or 0
			if self.PX > 1000 then self.PX = 0 end
		end

		if not self:GetMasterSwitch() then
			render.SetMaterial( mat )
			render.DrawSprite( self:LocalToWorld( Vector(125,500 - self.PX,10) ), 32, 32, Color( 255, 255, 255, 255) )
			render.DrawSprite( self:LocalToWorld( Vector(-125,500 - self.PX,10) ), 32, 32, Color( 255, 255, 255, 255) )
			
			render.DrawSprite( self:LocalToWorld( Vector(125,500 - self.PX,10) ), 130, 130, Color( 255, 0, 0, 255) )
			render.DrawSprite( self:LocalToWorld( Vector(-125,500 - self.PX,10) ), 130, 130, Color( 255, 0, 0, 255) )
			
			return
		end

		if self:GetType() ~= "" then return end

		render.SetMaterial( mat )
		render.DrawSprite( self:LocalToWorld( Vector(125,500 - self.PX,10) ), 32, 32, Color( 255, 255, 255, 255) )
		render.DrawSprite( self:LocalToWorld( Vector(-125,500 - self.PX,10) ), 32, 32, Color( 255, 255, 255, 255) )
		
		render.DrawSprite( self:LocalToWorld( Vector(125,500 - self.PX,10) ), 130, 130, Color( 0, 127, 255, 255) )
		render.DrawSprite( self:LocalToWorld( Vector(-125,500 - self.PX,10) ), 130, 130, Color( 0, 127, 255, 255) )
	end

	local TutorialDone = false

	hook.Add( "HUDPaint", "!!!!!!!11111lfsvehiclespammer_tutorial", function()
		if TutorialDone then return end

		local ply = LocalPlayer()

		if ply:InVehicle() then return end

		local trace = ply:GetEyeTrace()
		local Dist = (ply:GetShootPos() - trace.HitPos):Length()

		if Dist > 800 then return end

		local Ent = trace.Entity

		if not IsValid( Ent ) then return end

		if Ent:GetClass() == "lfs_vehicle_spammer" then
			local pos = Ent:GetPos()
			local scr = pos:ToScreen()
			local Alpha = 255

			if Ent:GetType() == "" then
				draw.SimpleText( "Hold C => Right Click on me => Edit Properties => Choose a Type", "LFS_FONT", scr.x, scr.y - 10, Color(255,255,255,Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				if not Ent:GetMasterSwitch() then
					local Key = input.LookupBinding( "+use" )
					if not isstring( Key ) then Key = "+use is not bound to a key" end

					draw.SimpleText( "Now press ["..Key.."] to enable!", "LFS_FONT", scr.x, scr.y - 10, Color(255,255,255,Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					draw.SimpleText( "or hold ["..Key.."] to enable globally!", "LFS_FONT", scr.x, scr.y + 10, Color(255,255,255,Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				else
					TutorialDone = true
				end
			end
		end
	end )
end