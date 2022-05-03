
ENT.Type           		= "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_heli" )

ENT.PrintName 			= "[LFS]AH-64D Apache"
ENT.Author 				= "Gredwitch"
ENT.Information 		= ""
ENT.Category 			= "Gredwitch's Stuff"

ENT.Spawnable			= true -- set to "true" to make it spawnable
ENT.AdminSpawnable		= false

ENT.MDL 				= "models/gredwitch/ah64_lfs/ah64.mdl" -- model forward direction must be facing to X+

ENT.WheelMass 		= 	75 -- wheel mass is 1 when the landing gear is retracted
ENT.WheelRadius 	= 	13
ENT.WheelPos_L 		= 	Vector(39.0481,40.099,-39.6518)
ENT.WheelPos_R 		= 	Vector(39.0481,-40.099,-39.6518)
ENT.WheelPos_C 		= 	Vector(-379.772,0,-6.06341)

ENT.AITEAM 				= 2

ENT.Mass 				= 3000
ENT.Inertia 			= Vector(5000,5000,5000)
ENT.Drag 				= 0

ENT.SeatPos 			= Vector(58.1396,0,25)
ENT.SeatAng 			= Angle(0,-90,0)

ENT.MaxThrustHeli 		= 7 -- 10
ENT.MaxTurnPitchHeli 	= 50
ENT.MaxTurnYawHeli 		= 80
ENT.MaxTurnRollHeli 	= 90
ENT.ThrustEfficiencyHeli= 0.7

ENT.RotorPos 			= Vector(0,0,118.5)
ENT.RotorAngle 			= Angle(0,0,0)
ENT.RotorRadius 		= 275

ENT.MaxHealth 			= 8000

ENT.MaxPrimaryAmmo 		= -1
ENT.MaxSecondaryAmmo 	= -1
ENT.Max30mm		 		= 1200
ENT.MaxHellfires		= 16
ENT.MaxHydras			= 76
ENT.MaxStingers			= 4

ENT.HYDRA_ENT			= "gb_rocket_hydra"
ENT.HYDRAWP_ENT			= "gb_rocket_hydraWP"
ENT.HELLFIRE_ENT		= "wac_base_grocket"
ENT.HELLFIRE_MODEL		= "models/gredwitch/ah64_lfs/hellfire.mdl"
ENT.HYDRA_MODEL			= "models/gredwitch/ah64_lfs/hydra70.mdl"
ENT.STINGER_ENT			= "gb_rocket_hydra"

ENT.Weaponery 			= {}

ENT.Weaponery.L1		= {
						Hydra = false,
						HydraPos = {
							[1] = Vector(22.5504,61.0976,1.33275),
							[2] = Vector(20.9536,64.3436,1.33275),
							[3] = Vector(22.5997,67.2331,1.33275),
							[4] = Vector(22.3276,59.5936,-1.1894),
							[5] = Vector(22.3516,62.5876,-1.18578),
							[6] = Vector(22.3775,65.8027,-1.18189),
							[7] = Vector(22.401,68.7231,-1.17836),
							[8] = Vector(22.1002,58.2485,-3.83854),
							[9] = Vector(22.124277,61.242523,-3.834924),
							[10] = Vector(22.150112,64.457703,-3.831032),
							[11] = Vector(22.173588,67.378021,-3.827513),
							[12] = Vector(22.197573,70.3622,-3.823897),
							[13] = Vector(21.879713,59.646435,-6.72163),
							[14] = Vector(21.903772,62.64043,-6.718009),
							[15] = Vector(21.929617,65.855614,-6.714118),
							[16] = Vector(21.953096,68.775932,-6.710591),
							[17] = Vector(21.697382,61.136478,-9.289761),
							[18] = Vector(21.723225,64.351646,-9.285884),
							[19] = Vector(21.746685,67.27198,-9.282345),
						},
						HellfirePos = {
							[1] = Vector(12.6111,57.8289,-6.19918),
							[2] = Vector(12.6696,70.7126,-6.21086),
							[3] = Vector(11.6239,58.8943,-19.0621),
							[4] = Vector(11.6728,69.6812,-19.0719),
						},
}

ENT.Camera = {
	Pos = Vector(185.604,0,0),
	Model = "models/mm1/box.mdl",
	LaserPos = Vector(7.916,14.759608,5.309458),
	ViewPos = Vector(7.916,-3,5.08986),
	-- BonePos = Vector(185.612,1.02489,0.529156),
}

ENT.GRED_APACHE_NEXTPRESS = {
	["lfs_controls_heli_camera"] = 0,
	["lfs_controls_heli_camera_zoom_in"] = 0,
	["lfs_controls_heli_camera_zoom_out"] = 0,
	["lfs_controls_heli_camera_point"] = 0,
	["lfs_controls_heli_camera_flir"] = 0,
}

ENT.ControlInput = {
	
	["ToggleCamera"] = false,
	["ZoomInCamera"] = false,
	["ZoomOutCamera"] = false,
	["LockCamera"] = false,
	["CameraFLIR"] = false,
	
}

ENT.Weaponery.L2		= {
						Hydra = false,
						HydraPos = {},
						HellfirePos = {},
}

ENT.Weaponery.R1		= {
						Hydra = false,
						HydraPos = {},
						HellfirePos = {},
}
ENT.Weaponery.R2		= {
						Hydra = false,
						HydraPos = {},
						HellfirePos = {},
}

-- Dynamically generating the other stuff cuz I'm lazy af

for k,v in pairs(ENT.Weaponery.L1.HydraPos) do
	ENT.Weaponery.L2.HydraPos[k] = Vector(v.x,v.y+30.891397,v.z)
	ENT.Weaponery.R1.HydraPos[k] = Vector(v.x,-v.y,v.z)
	ENT.Weaponery.R2.HydraPos[k] = Vector(v.x,-v.y-30.891397,v.z)
end
for k,v in pairs(ENT.Weaponery.L1.HellfirePos) do
	ENT.Weaponery.L2.HellfirePos[k] = Vector(v.x,v.y+30.7733,v.z)
	ENT.Weaponery.R1.HellfirePos[k] = Vector(v.x,-v.y,v.z)
	ENT.Weaponery.R2.HellfirePos[k] = Vector(v.x,-v.y-30.7733,v.z)
end
ENT.NextScan = 0

function ENT:AddDataTables()
	self:NetworkVar( "Int",11, "Left1Pod", { KeyName = "L1", Edit = { type = "Int", order = 5,min = 0, max = 3, category = "Weapons"} } )
	self:NetworkVar( "Int",12, "Left2Pod", { KeyName = "L2", Edit = { type = "Int", order = 5,min = 0, max = 3, category = "Weapons"} } )
	self:NetworkVar( "Int",13, "Right1Pod", { KeyName = "R1", Edit = { type = "Int", order = 5,min = 0, max = 3, category = "Weapons"} } )
	self:NetworkVar( "Int",14, "Right2Pod", { KeyName = "R2", Edit = { type = "Int", order = 5,min = 0, max = 3, category = "Weapons"} } )
	self:NetworkVar( "Int",15, "Hellfires", { KeyName = "Hellfires", Edit = { type = "Int", order = 3,min = 0, max = self.MaxHellfires, category = "Weapons"} } )
	self:NetworkVar( "Int",16, "Hydras", { KeyName = "Hydras", Edit = { type = "Int", order = 3,min = 0, max = self.MaxHydras, category = "Weapons"} } )
	-- self:NetworkVar( "Int",17, "Stingers", { KeyName = "Stingers", Edit = { type = "Int", order = 3,min = 0, max = self.MaxStingers, category = "Weapons"} } )
	self:NetworkVar( "Int",18, "30mm", { KeyName = "30mm", Edit = { type = "Int", order = 3,min = 0, max = self.Max30mm, category = "Weapons"} } )
	
	self:NetworkVar( "Bool",11,"FIRING_30MM")	
	-- self:NetworkVar( "Bool",12,"EnableStingers",{ KeyName = "EnableStingers", Edit = { type = "Boolean", order = 3, category = "Weapons"} } )
	
	self:NetworkVar( "Bool",13,"IsLocked" )
	
	self:NetworkVar( "Entity",11, "ClosestEnt" )
	self:NetworkVar( "Float",11, "ClosestDist" )
	
	
	if SERVER then
		self:SetLeft1Pod(math.random(0,3))
		self:SetLeft2Pod(math.random(0,3))
		self:SetRight1Pod(math.random(0,3))
		self:SetRight2Pod(math.random(0,3))
		-- self:SetEnableStingers(math.random(0,1) == 1)
		self:SetHellfires(0)
		self:SetHydras(0)
		-- self:SetStingers(0)
		self:Set30mm(self.Max30mm)
	end
end

function ENT:GetTail()
	if SERVER then
		net.Start("gred_apache_tail")
			net.WriteEntity(self)
			net.WriteEntity(self.Tail)
		net.Broadcast()
	end
end

--[[ Boeing AH-64D Apache by Gredwitch
Original port by damik, remodelled by Gredwitch
Features :
- Animated and HD cockpit
- Realistic M230 30mm gun
- Realistic depression, elevation and traverse angles
- Realistic sounds
- Loadout system : choose what you want to carry between AGM-114 Hellfires and HE (High Explosive) or WP (White Phosphorus - https://en.wikipedia.org/wiki/White_phosphorus_munitions ) Hydras 70
- Realistic camera mode
- Sounds change in camera mode
- FLIR for camera mode
- Destructible tail
- Helicopter can't yaw when the tail rotor is destroyed
- Helicopter falls back when the tail is destroyed
- Helicopter spins when the rotor is damaged
- Working bot mode
- Camera screens (disable them by pasting this in the console : gred_cl_lfs_apache_enable_screens 0)
- LODs
- White Phosphorus Hydras
STUFF I GOTTA ADD
- Stingers
]]
