--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile()

SWEP.Category			= "Other"
SWEP.PrintName		= "[LFS] Missile Launcher"
SWEP.Author			= "Luna"
SWEP.Slot				= 4
SWEP.SlotPos			= 9
SWEP.DrawWeaponInfoBox 	= false
SWEP.BounceWeaponIcon = false

SWEP.Spawnable		= true
SWEP.AdminSpawnable	= false
SWEP.ViewModel		= "models/weapons/c_rpg.mdl"
SWEP.WorldModel		= "models/weapons/w_rocket_launcher.mdl"
SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 53
SWEP.Weight 			= 42
SWEP.AutoSwitchTo 		= true
SWEP.AutoSwitchFrom 	= true
SWEP.HoldType			= "rpg"

SWEP.Primary.ClipSize	= 1
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo		= "RPG_Round"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo		= "none"

function SWEP:SetupDataTables()
	self:NetworkVar( "Entity",0, "ClosestEnt" )
	self:NetworkVar( "Float",0, "ClosestDist" )
	self:NetworkVar( "Bool",0, "IsLocked" )
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	draw.SimpleText( "i", "WeaponIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
end

function SWEP:Initialize()
	self.Weapon:SetHoldType( self.HoldType )
end

function SWEP:Think()
	if CLIENT then return end
	
	self.guided_nextThink = self.guided_nextThink or 0
	self.FindTime = self.FindTime or 0
	self.nextFind = self.nextFind or 0
	
	local curtime = CurTime()
	
	if self.FindTime + 3 < curtime and IsValid( self:GetClosestEnt() ) then
		self.Locked = true
	else
		self.Locked = false
	end
	
	if self.Locked ~= self:GetIsLocked() then
		self:SetIsLocked( self.Locked )
		
		if self.Locked then
			self.LockSND = CreateSound(self.Owner, "lfs/radar_lock.wav")
			self.LockSND:PlayEx( 0.5, 100 )
			
			if self.TrackSND then
				self.TrackSND:Stop()
				self.TrackSND = nil
			end
		else
			if self.LockSND then
				self.LockSND:Stop()
				self.LockSND = nil
			end
		end
	end
	
	if self.nextFind < curtime then
		self.nextFind = curtime + 3
		self.FoundVehicles = {}
		
		for k, v in pairs( simfphys.LFS:PlanesGetAll() ) do
			if v.LFS then
				table.insert( self.FoundVehicles, v )
			end
		end
		
		for k, v in pairs( ents.FindByClass( "wac_hc*" ) ) do
			table.insert( self.FoundVehicles, v )
		end
		
		for k, v in pairs( ents.FindByClass( "wac_pl*" ) ) do
			table.insert( self.FoundVehicles, v )
		end
	end
	
	if self.guided_nextThink < curtime then
		self.guided_nextThink = curtime + 0.25
		self.FoundVehicles = self.FoundVehicles or {}
		
		local AimForward = self.Owner:GetAimVector()
		local startpos = self.Owner:GetShootPos()

		local Vehicles = {}
		local ClosestEnt = NULL
		local ClosestDist = 0
		
		for k, v in pairs( self.FoundVehicles  ) do
			if IsValid( v ) then
				local sub = (v:GetPos() - startpos)
				local toEnt = sub:GetNormalized()
				local dist = sub:Length()
				local Ang = math.acos( math.Clamp( AimForward:Dot( toEnt ) ,-1,1) ) * (180 / math.pi)
				
				if Ang < 30 and dist < 7500 and self:CanSee( v ) then
					table.insert( Vehicles, v )
					
					local stuff = WorldToLocal( v:GetPos(), Angle(0,0,0), startpos, self.Owner:EyeAngles() + Angle(90,0,0) )
					stuff.z = 0
					local dist = stuff:Length()
				
					if not IsValid( ClosestEnt ) then
						ClosestEnt = v
						ClosestDist = dist
					end
					
					if dist < ClosestDist then
						ClosestDist = dist
						if ClosestEnt ~= v then
							ClosestEnt = v
						end
					end
				end
			else
				self.FoundVehicles[k] = nil
			end
		end
		
		if self:GetClosestEnt() ~= ClosestEnt then
			self:SetClosestEnt( ClosestEnt )
			self:SetClosestDist( ClosestDist )
			
			self.FindTime = curtime
			
			if IsValid( ClosestEnt ) then
				self.TrackSND = CreateSound(self.Owner, "lfs/radar_track.wav")
				self.TrackSND:PlayEx( 0, 100 )
				self.TrackSND:ChangeVolume( 0.5, 2 )
			else
				if self.TrackSND then
					self.TrackSND:Stop()
					self.TrackSND = nil
				end
			end
		end
		
		if not IsValid( ClosestEnt ) then
			if self.TrackSND then
				self.TrackSND:Stop()
				self.TrackSND = nil
			end
		end
	end
end

function SWEP:CanSee( entity )
	local pos = entity:GetPos()
	
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = pos,
		filter = function( ent ) 
			if ent == self.Owner then 
				return false
			end
			
			return true
		end
		
	} )
	return (tr.HitPos - pos):Length() < 500
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )	
	
	self:TakePrimaryAmmo( 1 )
	
	self.Owner:ViewPunch( Angle( -10, -5, 0 ) )
	
	if CLIENT then return end
	
	self.Owner:EmitSound("Weapon_RPG.NPC_Single")
	
	local startpos = self.Owner:GetShootPos() + self.Owner:EyeAngles():Right() * 10
	local ent = ents.Create( "lunasflightschool_missile" )
	ent:SetPos( startpos )
	ent:SetAngles( (self.Owner:GetEyeTrace().HitPos - startpos):Angle() )
	ent:SetOwner( self.Owner )
	ent.Attacker = self.Owner
	ent:Spawn()
	ent:Activate()
	
	ent:SetAttacker( self.Owner )
	ent:SetInflictor( self.Owner:GetActiveWeapon() )
	
	local LockOnTarget = self:GetClosestEnt()
	
	if IsValid( LockOnTarget ) and self:GetIsLocked() then
		ent:SetLockOn( LockOnTarget )
	end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return true
end

function SWEP:Reload()
	if self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 then
	
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		self:UnLock()
	end
end

local function DrawCircle( X, Y, radius )
	local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
	
	for a = 0, 360 - segmentdist, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
	end
end

function SWEP:UnLock()
	self:StopSounds()
end

function SWEP:StopSounds()
	if self.TrackSND then
		self.TrackSND:Stop()
		self.TrackSND = nil
	end
	
	if self.LockSND then
		self.LockSND:Stop()
		self.LockSND = nil
	end
	
	self:SetClosestEnt( NULL )
	self:SetClosestDist( 99999999999999 )
	self:SetIsLocked( false )
end

function SWEP:Holster()
	self:StopSounds()
	return true
end

function SWEP:OnDrop()
	self:StopSounds()
end

function SWEP:OwnerChanged()
	self:StopSounds()
end

local NextFind = 0
local AllPlanes = {}
local function PaintPlaneIdentifier( ply )
	if NextFind < CurTime() then
		NextFind = CurTime() + 3
		AllPlanes = simfphys.LFS:PlanesGetAll()
	end

	local MyPos = ply:GetPos()
	local MyTeam = ply:lfsGetAITeam()
	local startpos = ply:GetShootPos()

	for _, v in pairs( AllPlanes ) do
		if IsValid( v ) then
			local rPos = v:LocalToWorld( v:OBBCenter() )

			local Pos = rPos:ToScreen()
			local Dist = (MyPos - rPos):Length()

			if Dist < 13000 then
				if not util.TraceLine( {start = startpos,endpos = rPos,mask = MASK_NPCWORLDSTATIC,} ).Hit then

					local Alpha = math.max(255 - Dist * 0.015,0)
					local Team = v:GetAITEAM()
					local IndicatorColor = Color( 255, 0, 0, Alpha )

					if Team == 0 then
						IndicatorColor = Color( 0, 255, 0, Alpha )
					else
						if Team == 1 or Team == 2 then
							if Team ~= MyTeam and MyTeam ~= 0 then
								IndicatorColor = Color( 255, 0, 0, Alpha )
							else
								IndicatorColor = Color( 0, 127, 255, Alpha )
							end
						end
					end

					simfphys.LFS.HudPaintPlaneIdentifier( Pos.x, Pos.y, IndicatorColor, v )
				end
			end
		end
	end
end

function SWEP:DrawHUD()
	local ply = LocalPlayer()
	
	if ply:InVehicle() then return end

	PaintPlaneIdentifier( ply )

	local ent = self:GetClosestEnt()
	
	if not IsValid( ent ) then return end
	
	local dist = (ent:GetPos() - ply:GetPos()):Length() / 500
	local pos = ent:LocalToWorld( ent:OBBCenter() )
	
	local scr = pos:ToScreen()
	local scrW = ScrW() / 2
	local scrH = ScrH() / 2

	local X = scr.x
	local Y = scr.y
	
	draw.NoTexture()
	if self:GetIsLocked() then
		surface.SetDrawColor( 200, 0, 0, 255 )
	else
		surface.SetDrawColor( 200, 200, 200, 255 )
	end
	
	surface.DrawLine( scrW, scrH, X, Y )

	local Size = self:GetIsLocked() and 30 or 60

	surface.DrawLine( X - Size, Y + Size, X - Size * 0.5, Y + Size )
	surface.DrawLine( X + Size, Y + Size, X + Size * 0.5, Y + Size )

	surface.DrawLine( X - Size, Y + Size, X - Size, Y + Size * 0.5 )
	surface.DrawLine( X - Size, Y - Size, X - Size, Y - Size * 0.5 )

	surface.DrawLine( X + Size, Y + Size, X + Size, Y + Size * 0.5 )
	surface.DrawLine( X + Size, Y - Size, X + Size, Y - Size * 0.5 )

	surface.DrawLine( X - Size, Y - Size, X - Size * 0.5, Y - Size )
	surface.DrawLine( X + Size, Y - Size, X + Size * 0.5, Y - Size )


	X = X + 1
	Y = Y + 1
	surface.SetDrawColor( 0, 0, 0, 100 )
	surface.DrawLine( X - Size, Y + Size, X - Size * 0.5, Y + Size )
	surface.DrawLine( X + Size, Y + Size, X + Size * 0.5, Y + Size )

	surface.DrawLine( X - Size, Y + Size, X - Size, Y + Size * 0.5 )
	surface.DrawLine( X - Size, Y - Size, X - Size, Y - Size * 0.5 )

	surface.DrawLine( X + Size, Y + Size, X + Size, Y + Size * 0.5 )
	surface.DrawLine( X + Size, Y - Size, X + Size, Y - Size * 0.5 )

	surface.DrawLine( X - Size, Y - Size, X - Size * 0.5, Y - Size )
	surface.DrawLine( X + Size, Y - Size, X + Size * 0.5, Y - Size )
end