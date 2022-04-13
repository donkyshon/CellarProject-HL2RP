--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_heli" )

ENT.PrintName = "Rebel Helicopter"
ENT.Author = "Luna"
ENT.Information = "Transport Helicopter as seen in Half Life 2 Episode 2"
ENT.Category = "[LFS]"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/blu/helicopter.mdl"

ENT.AITEAM = 2

ENT.Mass = 6000
ENT.Inertia = Vector(10000,10000,10000)
ENT.Drag = 1

ENT.SeatPos = Vector(85,-20,-7)
ENT.SeatAng = Angle(0,-90,10)

ENT.MaxThrustHeli = 7
ENT.MaxTurnPitchHeli = 20
ENT.MaxTurnYawHeli = 40
ENT.MaxTurnRollHeli = 50

ENT.ThrustEfficiencyHeli = 0.9

ENT.RotorPos = Vector(0,0,100)
ENT.RotorAngle = Angle(2,0,0)
ENT.RotorRadius = 380

ENT.MaxHealth = 3500

ENT.MaxPrimaryAmmo = -1
ENT.MaxSecondaryAmmo = -1

sound.Add( {
	name = "rebel_heli",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "^lfs/hl3helicopter/loop.wav"
} )
