--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Maintenance Station"
ENT.Author = "Luna"
ENT.Information = "Repairs Vehicles"
ENT.Category = "[LFS]"

ENT.Spawnable		= true
ENT.AdminOnly		= false

ENT.FoundVehicles = {}

function ENT:SetupDataTables()
end

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )

		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal * 1 )
		ent:Spawn()
		ent:Activate()

		return ent

	end

	function ENT:OnTakeDamage( dmginfo )
		self:TakePhysicsDamage( dmginfo )
	end

	function ENT:Initialize()	
		self:SetModel( "models/props_vehicles/generatortrailer01.mdl" )
		
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )

		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	end

	function ENT:Use( ply )
	end
	
	function ENT:Think()
		self:NextThink( CurTime() + 0.5 )

		local Dist = 600
		local Pos =  self:LocalToWorld( Vector(0,0,200) )

		local FoundVehicles = {}
		for _, v in pairs( ents.FindInSphere( Pos, Dist ) ) do
			if not IsValid( v ) or not v.LFS then continue end

			if not v.MaintenanceStart then
				if v:GetRepairMode() or v:GetAmmoMode() then
					table.insert( FoundVehicles, v )
				end
			end
		end

		for _, v in ipairs( FoundVehicles ) do
			local id = v:EntIndex()

			if not self.FoundVehicles[ id ] then
				v:StartMaintenance()
				self.FoundVehicles[ id ] = true
			end
		end

		for id, _ in pairs( self.FoundVehicles ) do
			local v = Entity( id )

			if not IsValid( v ) then
				self.FoundVehicles[ id ] = nil

				continue
			else
				local pos = v:GetPos()
				if not v.MaintenanceStart then
					self.FoundVehicles[ id ] = nil
				end
			end
		end

		return true
	end
end

if CLIENT then
	local RING = Material( "effects/select_ring" )

	local AMMO = Material( "lfs_repairmode_ammo.png" )
	local HEALTH = Material( "lfs_repairmode_health.png" )

	function ENT:Draw()
		self:DrawModel()

		local ply = LocalPlayer()

		render.SetColorMaterial()

		if IsValid( ply:lfsGetPlane() ) then
			cam.Start3D2D( self:LocalToWorld( Vector(-25,0,150) ), Angle(0,ply:EyeAngles().y - 90,90), 0.75 )
				local Col =  Color(255,255,255,255)
				surface.SetDrawColor( Col.r, Col.g, Col.b, 255)
				surface.SetMaterial( AMMO )
				surface.DrawTexturedRectRotated( -64, 0, 128, 128, 0 )
				surface.SetMaterial( HEALTH )
				surface.DrawTexturedRectRotated( 64, 0, 128, 128, 0 )
			cam.End3D2D()

			local pos = self:GetPos()
			local radius = 500
			local Dist = (ply:GetPos() - pos):Length()

			if (self.NextPing or 0) < CurTime() then
				self.NextPing = CurTime() + 3
				self.WaveScale = 1
				self:EmitSound( "npc/combine_gunship/ping_search.wav",90,80, 0.25 )
			end

			if (self.WaveScale or 0) > 0 then
				self.WaveScale = math.max( self.WaveScale - FrameTime(), 0 )
				local InvScale = 1 - self.WaveScale
		
				cam.Start3D2D( self:GetPos() + Vector(0,0,10), self:LocalToWorldAngles( Angle(0,-90,0) ), 1 )
					local Col =  Color(255,255,255,255)
					surface.SetDrawColor( Col.r, Col.g, Col.b, 10 * self.WaveScale )
					surface.SetMaterial( RING )
					surface.DrawTexturedRectRotated( 0, 0, radius * 2.3 * InvScale, radius * 2.3 * InvScale, 0 )

					InvScale = InvScale * InvScale
					surface.DrawTexturedRectRotated( 0, 0, radius * 2.3 * InvScale, radius * 2.3 * InvScale, 0 )
				cam.End3D2D()
			end
		end
	end
end