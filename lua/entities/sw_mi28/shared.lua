--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_heli" )

ENT.PrintName = "[LFS] MI-28NM"
ENT.Author = "Shermann Wolf"
ENT.Information = ""
ENT.Category = "SW Aircraft Plant"

ENT.Spawnable		= true

ENT.MDL = "models/sw/avia/mi28/mi28.mdl"

ENT.AITEAM = 2

ENT.Mass = 10000
ENT.Inertia = Vector(4000,4000,4000)
ENT.Drag = 1

ENT.SeatPos = Vector(160,3,88)
ENT.SeatAng = Angle(0,-90,0)

ENT.RotorPos = Vector(100,0,170)
ENT.RotorRadius = 320

ENT.MaxThrustHeli = 15
ENT.MaxTurnPitchHeli = 30
ENT.MaxTurnYawHeli = 400
ENT.MaxTurnRollHeli = 40

ENT.ThrustEfficiencyHeli = 3

ENT.MaxHealth = 1500

ENT.Loadouts = 11
ENT.MaxPrimaryAmmo = 80
ENT.MaxSecondaryAmmo = 16
ENT.MaxTertiaryAmmo = 250
ENT.MaxFuel = 1400
ENT.MaxFlares = 60
ENT.FLIRmodes = 2
ENT.Weapons = 1
ENT.Zoommodes = 2

ENT.ROCKETS = {
	[1] = Vector(70,72,58), 
	[2] = Vector(70,-67,58),
	[3] = Vector(70,100,58),
	[4] = Vector(70,-95,58),
}
ENT.BOMBS = {
	[1] = Vector(70,72,60), 
	[2] = Vector(70,-67,60),
	[3] = Vector(70,100,60),
	[4] = Vector(70,-95,60),
}

function ENT:AddDataTables()
	self:NetworkVar( "Int",11, "Loadout", { KeyName = "loadout", Edit = { type = "Int", order = 1,min = 0, max = self.Loadouts, category = "Weapons"} } )
	self:NetworkVar( "Int",12, "Base", { KeyName = "base", Edit = { type = "Int", order = 1,min = 0, max = self.Bases, category = "Weapons"} } )
	self:NetworkVar( "Int",13, "Fuel", { KeyName = "fuel", Edit = { type = "Int", order = 5,min = 0, max = self.MaxFuel, category = "Misc"} } )
	self:SetFuel( self.MaxFuel )
	self:NetworkVar( "Int",14, "Flares", { KeyName = "flares", Edit = { type = "Int", order = 5,min = 0, max = self.MaxFlares, category = "Weapons"} } )
	self:SetFlares( self.MaxFlares )
	self:NetworkVar( "Int",15, "AmmoTertiary", { KeyName = "tertiaryammo", Edit = { type = "Int", order = 5,min = 0, max = self.MaxTertiaryAmmo, category = "Weapons"} } )
	self:SetAmmoTertiary( self.MaxTertiaryAmmo )
	self:NetworkVar( "Int",16, "FLIR", { KeyName = "flir", Edit = { type = "Int", order = 5,min = 0, max = self.FLIRmodes, category = "Misc"} } )
	self:NetworkVar( "Int",17, "Weapon", { KeyName = "weapon", Edit = { type = "Int", order = 5,min = 0, max = self.Weapons, category = "Weapons"} } )
	self:NetworkVar( "Int",18, "Zoom", { KeyName = "zoom", Edit = { type = "Int", order = 5,min = 0, max = self.Zoommodes, category = "Misc"} } )
	self:NetworkVar( "Bool",19, "Hover",{ KeyName = "hover",	Edit = { type = "Boolean",	order = 1,	category = "Misc"} } )
end

sound.Add( {
	name = "ENGINE_IDLE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 110,
	sound = "mi28/engine_idle.wav"
} )
sound.Add( {
	name = "ENGINE_RUN",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 90,
	sound = "mi28/engine_run.wav"
} )
sound.Add( {
	name = "EXHAUST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 50,
	sound = "mi28/exhaust.wav"
} )
sound.Add( {
	name = "BANK",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 80,
	sound = "mi28/bank.wav"
} )
sound.Add( {
	name = "DAMAGE",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	sound = "mi28/damage.wav"
} )
sound.Add( {
	name = "DAMAGE_2",
	channel = CHAN_STATIC,
	volume = 1,
	level = 80,
	sound = "mi28/damage_2.wav"
} )
sound.Add( {
	name = "BEEP",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	sound = "mi28/beep.wav"
} )
sound.Add( 	{
	name = "OUT_OF_ROCKETS",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "mi28/out_of_rockets.wav"
} )
sound.Add( 	{
	name = "RELOAD_ROCKETS",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "mi28/rocket_reload.wav"
} )
sound.Add( 	{
	name = "RELOAD",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "mi28/reload.wav"
} )
sound.Add( 	{
	name = "OUT_OF_AMMO",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "mi28/out_of_ammo.wav"
} )
sound.Add( 	{
	name = "2A42_LOOP",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "mi28/2a42_loop.wav"
} )
sound.Add( 	{
	name = "2A42_LASTSHOT",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "mi28/2a42_lastshot.wav"
} )