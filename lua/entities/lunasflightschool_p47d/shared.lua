--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "P-47D"
ENT.Author = "Luna"
ENT.Information = "American World War 2 Fighterplane"
ENT.Category = "[LFS]"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/p-47 (fly).mdl"

ENT.AITEAM = 2

ENT.Mass = 3000
ENT.Inertia = Vector(260000,260000,260000)
ENT.Drag = -40

ENT.SeatPos = Vector(40,0,91)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 200
ENT.MaxRPM = 2000
ENT.LimitRPM = 2200

ENT.RotorPos = Vector(226.46,0,80.33)
ENT.WingPos = Vector(83.87,0,70.78)
ENT.ElevatorPos = Vector(-226.05,0,96.32)
ENT.RudderPos = Vector(-229.69,0,152.93)


ENT.WheelMass = 400
ENT.WheelRadius = 18
ENT.WheelPos_L = Vector(115.22,104.53,4.87)
ENT.WheelPos_R =  Vector(115.22,-104.53,4.87)
ENT.WheelPos_C = Vector(-161.67,0,63)
 
ENT.MaxVelocity = 2400

ENT.MaxThrust = 850

ENT.MaxStability = 0.7

ENT.MaxTurnPitch = 360
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 300

ENT.MaxPerfVelocity = 3200

ENT.MaxHealth = 800

ENT.MaxPrimaryAmmo = 1200
ENT.MaxSecondaryAmmo = 10

ENT.MISSILEMDL = "models/damik/p-47d thunderbolt/hvar rocket.mdl"
ENT.MISSILES = {
	[1] = { Vector(92.16,-194.69,62.98), Vector(92.16,194.69,62.98) },
	[2] = { Vector(92.63,-178.76,61.32), Vector(92.63,178.76,61.32) },
	[3] = { Vector(93.54,-163.72,59.4), Vector(93.54,163.72,59.4)  },
	[4] = { Vector(93.96,-132.84,55.58), Vector(93.96,132.84,55.58) },
	[5] = { Vector(94,-118.52,53.9), Vector(94,118.52,53.9) },
}
