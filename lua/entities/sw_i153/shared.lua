--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "[LFS] I-153"
ENT.Author = "Shermann Wolf"
ENT.Information = "Soviet World War 2 Fighterplane"
ENT.Category = "SW Aircraft Plant"

ENT.Spawnable		= true
ENT.AdminSpawnable		= true

ENT.MDL = "models/sw/avia/i153/i153.mdl"

ENT.AITEAM = 2

ENT.Mass = 1000
ENT.Inertia = Vector(26000,26000,26000)
ENT.Drag = -40
ENT.SeatPos = Vector(0,0,55)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 0
ENT.MaxRPM = 1300
ENT.LimitRPM = 1300

ENT.RotorPos = Vector(150,0,67.5)
ENT.WingPos = Vector(83.87,0,54.28)
ENT.ElevatorPos = Vector(-120,0,93.5)
ENT.RudderPos = Vector(-120,0,93.5)


ENT.WheelMass = 150
ENT.WheelRadius = 17
ENT.WheelPos_C = Vector(-100,0,45)
ENT.WheelPos_L = Vector(70,35,0)
ENT.WheelPos_R =  Vector(70,-35,0)
 
ENT.MaxVelocity = 2000

ENT.MaxThrust = 500

ENT.MaxStability = 0.9

ENT.MaxTurnPitch = 560
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 300

ENT.MaxPerfVelocity = 2000

ENT.MaxHealth = 1100

ENT.MaxPrimaryAmmo = 2470
ENT.MaxSecondaryAmmo = 8
ENT.MaintenanceTime = 15
ENT.MaintenanceRepairAmount = 1100

ENT.Loadouts = 2
ENT.Bases = 1
ENT.MaxFuel = 800

ENT.ROCKETS = {
	[1] = Vector(35,88,30),
	[2] = Vector(35,-88,30),
	[3] = Vector(35,93.8,30),
	[4] = Vector(35,-93.8,30),
	[5] = Vector(35,99.5,30.5),
	[6] = Vector(35,-99.5,30.5),
	[7] = Vector(35,105.5,31),
	[8] = Vector(35,-105.5,31),
}

ENT.BOMBS = {
	[1] = Vector(35,88,30),
	[2] = Vector(35,-88,30),
	[3] = Vector(35,105,30),
	[4] = Vector(35,-105,30),
}

function ENT:AddDataTables()
	self:NetworkVar( "Int",11, "Loadout", { KeyName = "loadout", Edit = { type = "Int", order = 1,min = 0, max = self.Loadouts, category = "Weapons"} } )
	self:NetworkVar( "Int",12, "Base", { KeyName = "base", Edit = { type = "Int", order = 1,min = 0, max = self.Bases, category = "Weapons"} } )
	self:NetworkVar( "Int",13, "Fuel", { KeyName = "fuel", Edit = { type = "Int", order = 5,min = 0, max = self.MaxFuel, category = "Misc"} } )
	self:SetFuel( self.MaxFuel )
end
sound.Add( 	{
	name = "BOMB_DROP",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/bomb_drop.wav"
} )
sound.Add( 	{
	name = "RELOAD_BOMBS",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/reload_bombs.wav"
} )
sound.Add( 	{
	name = "SHKAS_LOOP",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/shkas_loop.wav"
} )
sound.Add( 	{
	name = "SHKAS_LASTSHOT",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/shkas_lastshot.wav"
} )
sound.Add( {
	name = "ENGINE_RPM1",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/engine_rpm1.wav"
} )
sound.Add( {
	name = "ENGINE_RPM2",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/engine_rpm2.wav"
} )
sound.Add( {
	name = "ENGINE_RPM3",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/engine_rpm3.wav"
} )
sound.Add( {
	name = "ENGINE_RPM4",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/engine_rpm4.wav"
} )
sound.Add( {
	name = "ENGINE_START",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/engine_start.wav"
} )
sound.Add( {
	name = "ENGINE_STOP",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/engine_stop.wav"
} )
sound.Add( {
	name = "GEAR",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/gear.wav"
} )
sound.Add( 	{
	name = "OUT_OF_ROCKETS",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/out_of_bombs.wav"
} )
sound.Add( 	{
	name = "OUT_OF_AMMO",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/out_of_ammo.wav"
} )
sound.Add( 	{
	name = "RELOAD",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/reload.wav"
} )
sound.Add( 	{
	name = "ROCKET_RELOAD",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/rocket_reload.wav"
} )
--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "[LFS] I-153"
ENT.Author = "Shermann Wolf"
ENT.Information = "Soviet World War 2 Fighterplane"
ENT.Category = "SW Aircraft Plant"

ENT.Spawnable		= true
ENT.AdminSpawnable		= true

ENT.MDL = "models/sw/avia/i153/i153.mdl"

ENT.AITEAM = 2

ENT.Mass = 1000
ENT.Inertia = Vector(26000,26000,26000)
ENT.Drag = -40
ENT.SeatPos = Vector(0,0,55)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 0
ENT.MaxRPM = 1300
ENT.LimitRPM = 1300

ENT.RotorPos = Vector(150,0,67.5)
ENT.WingPos = Vector(83.87,0,54.28)
ENT.ElevatorPos = Vector(-120,0,93.5)
ENT.RudderPos = Vector(-120,0,93.5)


ENT.WheelMass = 150
ENT.WheelRadius = 17
ENT.WheelPos_C = Vector(-100,0,45)
ENT.WheelPos_L = Vector(70,35,0)
ENT.WheelPos_R =  Vector(70,-35,0)
 
ENT.MaxVelocity = 2000

ENT.MaxThrust = 500

ENT.MaxStability = 0.9

ENT.MaxTurnPitch = 560
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 300

ENT.MaxPerfVelocity = 2000

ENT.MaxHealth = 1100

ENT.MaxPrimaryAmmo = 2470
ENT.MaxSecondaryAmmo = 8
ENT.MaintenanceTime = 15
ENT.MaintenanceRepairAmount = 1100

ENT.Loadouts = 2
ENT.Bases = 1
ENT.MaxFuel = 800

ENT.ROCKETS = {
	[1] = Vector(35,88,30),
	[2] = Vector(35,-88,30),
	[3] = Vector(35,93.8,30),
	[4] = Vector(35,-93.8,30),
	[5] = Vector(35,99.5,30.5),
	[6] = Vector(35,-99.5,30.5),
	[7] = Vector(35,105.5,31),
	[8] = Vector(35,-105.5,31),
}

ENT.BOMBS = {
	[1] = Vector(35,88,30),
	[2] = Vector(35,-88,30),
	[3] = Vector(35,105,30),
	[4] = Vector(35,-105,30),
}

function ENT:AddDataTables()
	self:NetworkVar( "Int",11, "Loadout", { KeyName = "loadout", Edit = { type = "Int", order = 1,min = 0, max = self.Loadouts, category = "Weapons"} } )
	self:NetworkVar( "Int",12, "Base", { KeyName = "base", Edit = { type = "Int", order = 1,min = 0, max = self.Bases, category = "Weapons"} } )
	self:NetworkVar( "Int",13, "Fuel", { KeyName = "fuel", Edit = { type = "Int", order = 5,min = 0, max = self.MaxFuel, category = "Misc"} } )
	self:SetFuel( self.MaxFuel )
end
sound.Add( 	{
	name = "BOMB_DROP",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/bomb_drop.wav"
} )
sound.Add( 	{
	name = "RELOAD_BOMBS",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/reload_bombs.wav"
} )
sound.Add( 	{
	name = "SHKAS_LOOP",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/shkas_loop.wav"
} )
sound.Add( 	{
	name = "SHKAS_LASTSHOT",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/shkas_lastshot.wav"
} )
sound.Add( {
	name = "ENGINE_RPM1",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/engine_rpm1.wav"
} )
sound.Add( {
	name = "ENGINE_RPM2",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/engine_rpm2.wav"
} )
sound.Add( {
	name = "ENGINE_RPM3",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/engine_rpm3.wav"
} )
sound.Add( {
	name = "ENGINE_RPM4",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/engine_rpm4.wav"
} )
sound.Add( {
	name = "ENGINE_START",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/engine_start.wav"
} )
sound.Add( {
	name = "ENGINE_STOP",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/engine_stop.wav"
} )
sound.Add( {
	name = "GEAR",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "i153/gear.wav"
} )
sound.Add( 	{
	name = "OUT_OF_ROCKETS",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/out_of_bombs.wav"
} )
sound.Add( 	{
	name = "OUT_OF_AMMO",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/out_of_ammo.wav"
} )
sound.Add( 	{
	name = "RELOAD",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/reload.wav"
} )
sound.Add( 	{
	name = "ROCKET_RELOAD",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "i153/rocket_reload.wav"
} )