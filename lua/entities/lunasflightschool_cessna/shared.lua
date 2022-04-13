--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Cessna 172"
ENT.Author = "Luna"
ENT.Information = "Small and Unarmed Civilian Airplane"
ENT.Category = "[LFS]"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/blu/cessna.mdl"

ENT.AITEAM = 0

ENT.Mass = 1000
ENT.Inertia = Vector(25000,25000,25000)
ENT.Drag = 0.5

ENT.SeatPos = Vector(5,8,38)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 300
ENT.MaxRPM = 1500
ENT.LimitRPM = 1500

ENT.RotorPos = Vector(50,0,47.28)
ENT.WingPos = Vector(-11.84,0,80.37)
ENT.ElevatorPos = Vector(-197.93,0,59.39)
ENT.RudderPos = Vector(-212.54,0,89.75)

ENT.WheelAutoRetract = true
ENT.WheelMass = 150
ENT.WheelRadius = 12
ENT.WheelPos_C = Vector(53.3,0,5)
ENT.WheelPos_L = Vector(-14.1,50.8,8.7)
ENT.WheelPos_R = Vector(-14.1,-50.8,8.7)

ENT.MaxVelocity = 2000

ENT.MaxThrust = 400

ENT.MaxTurnPitch = 300
ENT.MaxTurnYaw = 300
ENT.MaxTurnRoll = 200

ENT.MaxPerfVelocity = 2500

ENT.MaxHealth = 250

ENT.MaxStability = 0.7

ENT.MaxPrimaryAmmo = -1
ENT.MaxSecondaryAmmo = -1

sound.Add( {
	name = "LFS_CESSNA_RPM1",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "^lfs/cessna/rpm_1.wav"
} )

sound.Add( {
	name = "LFS_CESSNA_RPM2",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "^lfs/cessna/rpm_2.wav"
} )

sound.Add( {
	name = "LFS_CESSNA_RPM3",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "^lfs/cessna/rpm_3.wav"
} )

sound.Add( {
	name = "LFS_CESSNA_RPM4",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "^lfs/cessna/rpm_4.wav"
} )

sound.Add( {
	name = "LFS_CESSNA_DIST",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	sound = "^lfs/cessna/dist.wav"
} )
