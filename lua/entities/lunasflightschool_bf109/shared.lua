--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "BF 109"
ENT.Author = "Luna"
ENT.Information = "German World War 2 Fighterplane"
ENT.Category = "[LFS]"

ENT.Spawnable		= true
ENT.AdminSpawnable  = false

ENT.MDL = "models/blu/bf109.mdl"

ENT.AITEAM = 1

ENT.Mass = 2700
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = -17

ENT.SeatPos = Vector(32,0,67.5)
ENT.SeatAng = Angle(0,-90,0)

ENT.WheelMass = 400
ENT.WheelRadius = 13
ENT.WheelPos_L = Vector(78.12,55,15.16)
ENT.WheelPos_R = Vector(78.12,-55,15.16)
ENT.WheelPos_C = Vector(-146.61,0,76)

ENT.IdleRPM = 250
ENT.MaxRPM = 1200
ENT.LimitRPM = 1500

ENT.RotorPos = Vector(170,0,75)
ENT.WingPos = Vector(80,0,0)
ENT.ElevatorPos = Vector(-152.7,0,108.15)
ENT.RudderPos = Vector(-184.56,0,104.15)

ENT.MaxVelocity = 2400

ENT.MaxThrust = 750

ENT.MaxTurnPitch = 300
ENT.MaxTurnYaw = 450
ENT.MaxTurnRoll = 200

ENT.MaxPerfVelocity = 3000

ENT.MaxHealth = 800

ENT.MaxPrimaryAmmo = 2000
ENT.MaxSecondaryAmmo = 200

sound.Add( {
	name = "LFS_BF109_RPM1",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/bf109/rpm_1.wav"
} )

sound.Add( {
	name = "LFS_BF109_RPM2",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/bf109/rpm_2.wav"
} )

sound.Add( {
	name = "LFS_BF109_RPM3",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/bf109/rpm_3.wav"
} )

sound.Add( {
	name = "LFS_BF109_RPM4",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/bf109/rpm_4.wav"
} )

sound.Add( {
	name = "LFS_BF109_DIST",
	channel = CHAN_STATIC,
	volume = 1,
	level = 125,
	sound = "^lfs/bf109/dist.wav"
} )

sound.Add( {
	name = "BF109_FIRE_LOOP",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "lfs/bf109/weapons/nose_loop.wav"
} )

sound.Add( {
	name = "BF109_FIRE_LASTSHOT",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "lfs/bf109/weapons/nose_lastshot.wav"
} )

sound.Add( {
	name = "BF109_FIRE2_LOOP",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 90,
	sound = "lfs/bf109/weapons/wing_loop.wav"
} )

sound.Add( {
	name = "BF109_FIRE2_LASTSHOT",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 90,
	sound = "lfs/bf109/weapons/wing_lastshot.wav"
} )

sound.Add( {
	name = "BF109_FLYBY",
	channel = CHAN_STATIC,
	volume = 1,
	level = 110,
	sound = "lfs/bf109/flyby.wav"
} )
--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "BF 109"
ENT.Author = "Luna"
ENT.Information = "German World War 2 Fighterplane"
ENT.Category = "[LFS]"

ENT.Spawnable		= true
ENT.AdminSpawnable  = false

ENT.MDL = "models/blu/bf109.mdl"

ENT.AITEAM = 1

ENT.Mass = 2700
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = -17

ENT.SeatPos = Vector(32,0,67.5)
ENT.SeatAng = Angle(0,-90,0)

ENT.WheelMass = 400
ENT.WheelRadius = 13
ENT.WheelPos_L = Vector(78.12,55,15.16)
ENT.WheelPos_R = Vector(78.12,-55,15.16)
ENT.WheelPos_C = Vector(-146.61,0,76)

ENT.IdleRPM = 250
ENT.MaxRPM = 1200
ENT.LimitRPM = 1500

ENT.RotorPos = Vector(170,0,75)
ENT.WingPos = Vector(80,0,0)
ENT.ElevatorPos = Vector(-152.7,0,108.15)
ENT.RudderPos = Vector(-184.56,0,104.15)

ENT.MaxVelocity = 2400

ENT.MaxThrust = 750

ENT.MaxTurnPitch = 300
ENT.MaxTurnYaw = 450
ENT.MaxTurnRoll = 200

ENT.MaxPerfVelocity = 3000

ENT.MaxHealth = 800

ENT.MaxPrimaryAmmo = 2000
ENT.MaxSecondaryAmmo = 200

sound.Add( {
	name = "LFS_BF109_RPM1",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/bf109/rpm_1.wav"
} )

sound.Add( {
	name = "LFS_BF109_RPM2",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/bf109/rpm_2.wav"
} )

sound.Add( {
	name = "LFS_BF109_RPM3",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/bf109/rpm_3.wav"
} )

sound.Add( {
	name = "LFS_BF109_RPM4",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "^lfs/bf109/rpm_4.wav"
} )

sound.Add( {
	name = "LFS_BF109_DIST",
	channel = CHAN_STATIC,
	volume = 1,
	level = 125,
	sound = "^lfs/bf109/dist.wav"
} )

sound.Add( {
	name = "BF109_FIRE_LOOP",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "lfs/bf109/weapons/nose_loop.wav"
} )

sound.Add( {
	name = "BF109_FIRE_LASTSHOT",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "lfs/bf109/weapons/nose_lastshot.wav"
} )

sound.Add( {
	name = "BF109_FIRE2_LOOP",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 90,
	sound = "lfs/bf109/weapons/wing_loop.wav"
} )

sound.Add( {
	name = "BF109_FIRE2_LASTSHOT",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 90,
	sound = "lfs/bf109/weapons/wing_lastshot.wav"
} )

sound.Add( {
	name = "BF109_FLYBY",
	channel = CHAN_STATIC,
	volume = 1,
	level = 110,
	sound = "lfs/bf109/flyby.wav"
} )