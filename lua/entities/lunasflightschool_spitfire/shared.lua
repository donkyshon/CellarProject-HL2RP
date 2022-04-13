--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Spitfire"
ENT.Author = "Luna"
ENT.Information = "British World War 2 Fighterplane"
ENT.Category = "[LFS]"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/blu/spitfire.mdl"

ENT.AITEAM = 2

ENT.Mass = 2700
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = 0.3

ENT.SeatPos = Vector(29,0,61)
ENT.SeatAng = Angle(0,-90,12)

ENT.WheelMass = 400
ENT.WheelRadius = 10
ENT.WheelPos_L = Vector(80.28,45,11.05)
ENT.WheelPos_R = Vector(80.28,-45,11.05)
ENT.WheelPos_C = Vector(-150.29,0,64)

ENT.IdleRPM = 300
ENT.MaxRPM = 1400
ENT.LimitRPM = 1500

ENT.RotorPos = Vector(175.91,0,75.52)
ENT.WingPos = Vector(80,0,49.84)
ENT.ElevatorPos = Vector(-155.51,0,87.44)
ENT.RudderPos = Vector(-162.48,0,102.96)

ENT.MaxVelocity = 2350

ENT.MaxThrust = 700

ENT.MaxTurnPitch = 300
ENT.MaxTurnYaw = 450
ENT.MaxTurnRoll = 200

ENT.MaxPerfVelocity = 2750

ENT.MaxHealth = 800

ENT.MaxPrimaryAmmo = 2226
ENT.MaxSecondaryAmmo = -1

sound.Add( {
	name = "LFS_SPITFIRE_RPM1",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/spitfire/rpm_1.wav"
} )

sound.Add( {
	name = "LFS_SPITFIRE_RPM2",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/spitfire/rpm_2.wav"
} )

sound.Add( {
	name = "LFS_SPITFIRE_RPM3",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/spitfire/rpm_3.wav"
} )

sound.Add( {
	name = "LFS_SPITFIRE_RPM4",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/spitfire/rpm_4.wav"
} )

sound.Add( {
	name = "LFS_SPITFIRE_DIST",
	channel = CHAN_STATIC,
	volume = 1,
	level = 125,
	sound = "^lfs/spitfire/dist.wav"
} )

sound.Add( {
	name = "SPITFIRE_FIRE_LOOP",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "lfs/spitfire/weapons/wing_loop.wav"
} )

sound.Add( {
	name = "SPITFIRE_FIRE_LASTSHOT",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "lfs/spitfire/weapons/wing_lastshot.wav"
} )

sound.Add( {
	name = "SPITFIRE_FLYBY",
	channel = CHAN_STATIC,
	volume = 1,
	level = 110,
	sound = "lfs/spitfire/flyby.wav"
} )

--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Spitfire"
ENT.Author = "Luna"
ENT.Information = "British World War 2 Fighterplane"
ENT.Category = "[LFS]"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/blu/spitfire.mdl"

ENT.AITEAM = 2

ENT.Mass = 2700
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = 0.3

ENT.SeatPos = Vector(29,0,61)
ENT.SeatAng = Angle(0,-90,12)

ENT.WheelMass = 400
ENT.WheelRadius = 10
ENT.WheelPos_L = Vector(80.28,45,11.05)
ENT.WheelPos_R = Vector(80.28,-45,11.05)
ENT.WheelPos_C = Vector(-150.29,0,64)

ENT.IdleRPM = 300
ENT.MaxRPM = 1400
ENT.LimitRPM = 1500

ENT.RotorPos = Vector(175.91,0,75.52)
ENT.WingPos = Vector(80,0,49.84)
ENT.ElevatorPos = Vector(-155.51,0,87.44)
ENT.RudderPos = Vector(-162.48,0,102.96)

ENT.MaxVelocity = 2350

ENT.MaxThrust = 700

ENT.MaxTurnPitch = 300
ENT.MaxTurnYaw = 450
ENT.MaxTurnRoll = 200

ENT.MaxPerfVelocity = 2750

ENT.MaxHealth = 800

ENT.MaxPrimaryAmmo = 2226
ENT.MaxSecondaryAmmo = -1

sound.Add( {
	name = "LFS_SPITFIRE_RPM1",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/spitfire/rpm_1.wav"
} )

sound.Add( {
	name = "LFS_SPITFIRE_RPM2",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/spitfire/rpm_2.wav"
} )

sound.Add( {
	name = "LFS_SPITFIRE_RPM3",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/spitfire/rpm_3.wav"
} )

sound.Add( {
	name = "LFS_SPITFIRE_RPM4",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/spitfire/rpm_4.wav"
} )

sound.Add( {
	name = "LFS_SPITFIRE_DIST",
	channel = CHAN_STATIC,
	volume = 1,
	level = 125,
	sound = "^lfs/spitfire/dist.wav"
} )

sound.Add( {
	name = "SPITFIRE_FIRE_LOOP",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "lfs/spitfire/weapons/wing_loop.wav"
} )

sound.Add( {
	name = "SPITFIRE_FIRE_LASTSHOT",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "lfs/spitfire/weapons/wing_lastshot.wav"
} )

sound.Add( {
	name = "SPITFIRE_FLYBY",
	channel = CHAN_STATIC,
	volume = 1,
	level = 110,
	sound = "lfs/spitfire/flyby.wav"
} )
