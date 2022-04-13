-- YOU CAN EDIT AND REUPLOAD THIS FILE. 
-- HOWEVER MAKE SURE TO RENAME THE FOLDER TO AVOID CONFLICTS

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "template script"
ENT.Author = "*your name*"
ENT.Information = ""
ENT.Category = "[LFS] *your category*"

ENT.Spawnable		= false -- set to "true" to make it spawnable
ENT.AdminSpawnable	= false

ENT.MDL = "models/props_interiors/BathTub01a.mdl" -- model forward direction must be facing to X+
--[[
ENT.GibModels = {
	"models/XQM/wingpiece2.mdl",
	"models/XQM/wingpiece2.mdl",
	"models/XQM/jetwing2medium.mdl",
	"models/XQM/jetwing2medium.mdl",
	"models/props_phx/misc/propeller3x_small.mdl",
	"models/props_c17/TrapPropeller_Engine.mdl",
	"models/props_junk/Shoe001a.mdl",
	"models/XQM/jetbody2fuselage.mdl",
	"models/XQM/jettailpiece1medium.mdl",
	"models/XQM/pistontype1huge.mdl",
}
]]

ENT.AITEAM = 1
--[[
TEAMS:
	0 = FRIENDLY TO EVERYONE
	1 = FRIENDLY TO TEAM 1 and 0
	2 = FRIENDLY TO TEAM 2 and 0
	3 = HOSTILE TO EVERYONE
]]

ENT.Mass = 800 -- lower this value if you encounter spazz
ENT.Inertia = Vector(20000,20000,20000) -- you must increase this when you increase mass or it will spazz
ENT.Drag = 1 -- drag is a good air brake but it will make diving speed worse

--ENT.HideDriver = true -- hide the driver?
ENT.SeatPos = Vector(0,5,0)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 300 -- idle rpm. this can be used to tweak the minimum flight speed
ENT.MaxRPM = 2800 -- rpm at 100% throttle
ENT.LimitRPM = 3000 -- max rpm when holding throttle key
ENT.RPMThrottleIncrement = 350 -- how fast the RPM should increase/decrease per second

ENT.RotorPos = Vector(70,5,20) -- make sure you set these correctly or your plane will act wierd.
ENT.WingPos = Vector(50,5,20) -- make sure you set these correctly or your plane will act wierd. Excessive values can cause spazz.
ENT.ElevatorPos = Vector(-150,5,20) -- make sure you set these correctly or your plane will act wierd. Excessive values can cause spazz.
ENT.RudderPos = Vector(-150,5,20) -- make sure you set these correctly or your plane will act wierd. Excessive values can cause spazz.

ENT.MaxVelocity = 1000 -- max theoretical velocity at 0 degree climb
ENT.MaxPerfVelocity = 1500 -- speed in which the plane will have its maximum turning potential

ENT.MaxThrust = 800 -- max power of rotor

ENT.MaxTurnPitch = 600 -- max turning force in pitch, lower this value if you encounter spazz
ENT.MaxTurnYaw = 600 -- max turning force in yaw, lower this value if you encounter spazz
ENT.MaxTurnRoll = 600 -- max turning force in roll, lower this value if you encounter spazz

ENT.MaxHealth = 450
--ENT.MaxShield = 200  -- uncomment this if you want to use deflector shields. Dont use excessive amounts because it regenerates.

--ENT.Stability = 0.7   -- if you uncomment this the plane will always be able to turn at maximum performance. This causes MaxPerfVelocity to get ignored
ENT.MaxStability = 0.7 -- lower this value if you encounter spazz. You can increase this up to 1 to aid turning performance at MaxPerfVelocity-speeds but be careful

--ENT.VerticalTakeoff = true -- move vertically with landing gear out? REQUIRES ENT.Stability
--ENT.VtolAllowInputBelowThrottle = 10 -- number is in % of throttle. Removes the landing gear dependency. Vtol mode will always be active when throttle is below this number. In this mode up movement is done with "Shift" key instead of W
--ENT.MaxThrustVtol = 100 -- amount of vertical thrust

ENT.MaxPrimaryAmmo = 100   -- set to a positive number if you want to use weapons. set to -1 if you dont
ENT.MaxSecondaryAmmo = -1 -- set to a positive number if you want to use weapons. set to -1 if you dont

ENT.MaintenanceTime = 8 -- how many seconds it takes to perform a repair
ENT.MaintenanceRepairAmount = 250 -- how much health to restore

function ENT:AddDataTables() -- use this to add networkvariables instead of ENT:SetupDataTables().
	--[[DO NOT USE SLOTS SMALLER THAN 10]]--
end