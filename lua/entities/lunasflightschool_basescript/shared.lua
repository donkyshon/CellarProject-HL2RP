--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"

ENT.PrintName = "basescript"
ENT.Author = "Luna"
ENT.Information = "Luna's Flight School Plane Basescript"
ENT.Category = "[LFS]"

ENT.Spawnable		= false
ENT.AdminSpawnable  = false

ENT.AutomaticFrameAdvance = true
ENT.RenderGroup = RENDERGROUP_BOTH 

ENT.Editable = true

ENT.LFS = true

ENT.MDL = "error.mdl"

ENT.AITEAM = 0

ENT.Mass = 2000
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = 0

ENT.SeatPos = Vector(32,0,67.5)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 300
ENT.MaxRPM = 1200
ENT.LimitRPM = 2000

ENT.RotorPos = Vector(80,0,0)
ENT.WingPos = Vector(40,0,0)
ENT.ElevatorPos = Vector(-40,0,0)
ENT.RudderPos = Vector(-40,0,15)

ENT.MaxVelocity = 2500

ENT.MaxThrust = 500

ENT.MaxTurnPitch = 300
ENT.MaxTurnYaw = 300
ENT.MaxTurnRoll = 300

ENT.MaxPerfVelocity = 2600

ENT.MaxHealth = 1000
ENT.MaxShield = 0

ENT.MaxPrimaryAmmo = -1
ENT.MaxSecondaryAmmo = -1

ENT.MaintenanceTime = 8
ENT.MaintenanceRepairAmount = 250

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Driver" )
	self:NetworkVar( "Entity",1, "DriverSeat" )
	self:NetworkVar( "Entity",2, "Gunner" )
	self:NetworkVar( "Entity",3, "GunnerSeat" )
	
	self:NetworkVar( "Bool",0, "Active" )
	self:NetworkVar( "Bool",1, "EngineActive" )
	self:NetworkVar( "Bool",2, "AI",	{ KeyName = "aicontrolled",	Edit = { type = "Boolean",	order = 1,	category = "AI"} } )
	self:NetworkVar( "Bool",3, "IsGroundTouching" )
	self:NetworkVar( "Bool",4, "RotorDestroyed" )
	self:NetworkVar( "Bool",5, "lfsLockedStatus" )
	
	self:NetworkVar( "Int",2, "AITEAM", { KeyName = "aiteam", Edit = { type = "Int", order = 2,min = 0, max = 3, category = "AI"} } )
	
	self:NetworkVar( "Float",0, "LGear" )
	self:NetworkVar( "Float",1, "RGear" )
	self:NetworkVar( "Float",2, "RPM" )
	self:NetworkVar( "Float",3, "RotPitch" )
	self:NetworkVar( "Float",4, "RotYaw" )
	self:NetworkVar( "Float",5, "RotRoll" )
	self:NetworkVar( "Float",6, "HP", { KeyName = "health", Edit = { type = "Float", order = 2,min = 0, max = self.MaxHealth, category = "Misc"} } )
	self:NetworkVar( "Float",7, "Shield" )
	self:NetworkVar( "Float",8, "MaintenanceProgress" )

	self:NetworkVar( "Int",0, "AmmoPrimary", { KeyName = "primaryammo", Edit = { type = "Int", order = 3,min = 0, max = self.MaxPrimaryAmmo, category = "Weapons"} } )
	self:NetworkVar( "Int",1, "AmmoSecondary", { KeyName = "secondaryammo", Edit = { type = "Int", order = 4,min = 0, max = self.MaxSecondaryAmmo, category = "Weapons"} } )

	self:AddDataTables()

	if SERVER then
		self:NetworkVarNotify( "AI", self.OnToggleAI )
		
		self:SetAITEAM( self.AITEAM )
		self:SetHP( self.MaxHealth )
		self:SetShield( self.MaxShield )
		self:ReloadWeapon()
	end
end

function ENT:AddDataTables()
end

function ENT:GetMaxShield()
	return isnumber( self.MaxShield ) and self.MaxShield or 0
end

function ENT:GetShieldPercent()
	return self:GetShield() / self:GetMaxShield()
end

function ENT:GetMaxAmmoPrimary()
	return self.MaxPrimaryAmmo
end

function ENT:GetMaxAmmoSecondary()
	return self.MaxSecondaryAmmo
end

function ENT:GetMaxHP()
	return self.MaxHealth
end

function ENT:GetIdleRPM()
	return self.IdleRPM
end

function ENT:GetMaxRPM()
	return self.MaxRPM
end

function ENT:GetLimitRPM()
	return self.LimitRPM
end

function ENT:GetMaxVelocity()
	return self.MaxVelocity
end

function ENT:GetMaxTurnSpeed()
	return  {p = self.MaxTurnPitch, y = self.MaxTurnYaw, r = self.MaxTurnRoll }
end

function ENT:GetMaxPerfVelocity()
	return self.MaxPerfVelocity
end

function ENT:GetMaxThrust()
	return self.MaxThrust
end

function ENT:GetThrustVtol()
	self.MaxThrustVtol = isnumber( self.MaxThrustVtol ) and self.MaxThrustVtol or self:GetMaxThrust() * 0.15
	
	return self.MaxThrustVtol
end

function ENT:GetRotorPos()
	return self:LocalToWorld( self.RotorPos )
end

function ENT:GetWingPos()
	return self:LocalToWorld( self.WingPos )
end

function ENT:GetWingUp()
	return self:GetUp()
end

function ENT:GetElevatorUp()
	return self:GetUp()
end

function ENT:GetRudderUp()
	return self:GetRight()
end

function ENT:GetElevatorPos()
	return self:LocalToWorld( self.ElevatorPos )
end

function ENT:GetRudderPos()
	return self:LocalToWorld( self.RudderPos )
end

function ENT:GetMaxStability()
	self.MaxStability = self.MaxStability or 1
	
	return self.MaxStability
end

function ENT:GetThrottlePercent()
	local IdleRPM = self:GetIdleRPM()
	local MaxRPM = self:GetMaxRPM()
	
	return math.max( math.Round(((self:GetRPM() - IdleRPM) / (MaxRPM - IdleRPM)) * 100,0) ,0)
end

function ENT:IsGunship()
	return false
end

function ENT:IsSpaceShip()
	return isnumber( self.Stability )
end

function ENT:IsHelicopter()
	return false
end

function ENT:GetRepairMode()
	return self:GetHP() < self.MaxHealth 
end

function ENT:GetAmmoMode()
	return (self:GetAmmoPrimary() ~= self:GetMaxAmmoPrimary()) or (self:GetAmmoSecondary() ~= self:GetMaxAmmoSecondary())
end

function ENT:GetPassengerSeats()
	if not istable( self.pSeats ) then
		self.pSeats = {}
		
		local DriverSeat = self:GetDriverSeat()

		for _, v in pairs( self:GetChildren() ) do
			if v ~= DriverSeat and v:GetClass():lower() == "prop_vehicle_prisoner_pod" then
				table.insert( self.pSeats, v )
			end
		end
	end
	
	return self.pSeats
end

sound.Add( {
	name = "LFS_PLANE_EXPLOSION",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	pitch = {75, 120},
	sound = {"^lfs/plane_explosion1.wav","^lfs/plane_explosion2.wav","^lfs/plane_explosion3.wav"}
} )

sound.Add( {
	name = "LFS_PLANE_KNOCKOUT",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = 100,
	sound = {"lfs/plane_preexp1.ogg","lfs/plane_preexp2.ogg","lfs/plane_preexp3.ogg"}
} )

sound.Add( {
	name = "LFS_PROPELLER",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 80,
	sound = "^lfs/cessna/propeller.wav"
} )

sound.Add( {
	name = "LFS_PROPELLER_STRAIN",
	channel = CHAN_VOICE2,
	volume = 1.0,
	level = 80,
	sound = "^lfs/cessna/propeller_strain.wav"
} )