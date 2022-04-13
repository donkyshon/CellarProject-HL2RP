
ENT.Spawnable		    =	false
ENT.AdminSpawnable		=	false

ENT.PrintName		    =	"[BOMBS]Base bomb"
ENT.Author			    =	"Gredwitch"
ENT.Contact			    =	"contact.gredwitch@gmail.com"
ENT.Category            =	"Gredwitch's Stuff"
ENT.Base 				=	"base_bomb"
ENT.IsRocket			=	true

ENT.RocketTrail         =	""
ENT.RocketBurnoutTrail  =	""
	
ENT.StartSound          =	""
ENT.EngineSound         =	"Missile.Ignite"

ENT.SmartLaunch         =	false
ENT.EnginePower         =	0 -- in newtons
ENT.FuelBurnoutTime     =	0
ENT.IgnitionDelay       =	0
ENT.MaxVelocity         =	0 -- in m/s
ENT.ImpactSpeed         =	200
ENT.RotationalForce     =	500 -- angular velocity
ENT.Drag				=	1

ENT.Caliber				=	0
ENT.ShellType			=	"HE"
ENT.TNTEquivalent		=	0 -- in kg
ENT.ExplosiveMass		=	0 -- in kg
ENT.CoreMass			=	0 -- in kg
ENT.DamageAdd			=	0

ENT.RicochetWhitelist = {
	["LeftTrack"] = true,
	["RightTrack"] = true,
}

ENT.RICOCHET_ANGLES = {
	["APCBC"] = {
		[1] = 48,
		[2] = 63,
		[3] = 71,
	},
	["APDS"] = {
		[1] = 75,
		[2] = 78,
		[3] = 80,
	},
	["APFSDS"] = {
		[1] = 78,
		[2] = 80,
		[3] = 81,
	},
	["HEATFS"] = {
		[1] = 65,
		[2] = 72,
		[3] = 77,
	},
	["HEAT"] = {
		[1] = 62,
		[2] = 69,
		[3] = 73,
	},
	["HE"] = {
		[1] = 79,
		[2] = 80,
		[3] = 81,
	},
	["AP"] = {
		[1] = 47,
		[2] = 60,
		[3] = 65,
	},
	["APCR"] = {
		[1] = 66,
		[2] = 70,
		[3] = 72,
	},
}
ENT.RICOCHET_ANGLES.APHE = ENT.RICOCHET_ANGLES.AP
ENT.RICOCHET_ANGLES.APBC = ENT.RICOCHET_ANGLES.APCBC
ENT.RICOCHET_ANGLES.APC = ENT.RICOCHET_ANGLES.APCBC
ENT.RICOCHET_ANGLES.APHECBC = ENT.RICOCHET_ANGLES.APCBC
ENT.RICOCHET_ANGLES.APHEBC = ENT.RICOCHET_ANGLES.APBC

ENT.IS_AP = {
	["AP"] = true,
	["APC"] = true,
	["APBC"] = true,
	["APCBC"] = true,
	
	["APHE"] = true,
	["APHEBC"] = true,
	["APHECBC"] = true,
	
	["APCR"] = true,
	["APDS"] = true,
	["APFSDS"] = true,
}

ENT.IS_APHE = {
	["APHE"] = true,
	["APHEBC"] = true,
	["APHECBC"] = true,
}

ENT.IS_APCR = {
	["APCR"] = true,
	["APDS"] = true,
	["APFSDS"] = true,
}

ENT.IS_HEAT = {
	["HEAT"] = true,
	["HEATFS"] = true,
}

ENT.IS_HE = {
	["HE"] = true,
	["HESH"] = true,
}

ENT.IS_CAPPED = {
	["APHECBC"] = true,
	["APCBC"] = true,
	["APC"] = true,
}

gred = gred or {}
gred.IS_AP = ENT.IS_AP
gred.IS_APHE = ENT.IS_APHE
gred.IS_APCR = ENT.IS_APCR
gred.IS_HEAT = ENT.IS_HEAT

ENT.SLOPE_MULTIPLIERS = { -- https://docs.google.com/spreadsheets/d/e/2PACX-1vTtcFbCkmSUgVO4MIjy0QsehaJ0Fn00pL7HE1x7utLO04rkHmimeGtcc1i92s4u1HgV2wV6TAaP0AVj/pubhtml?gid=0&single=true
	["APBC"] = {
		[10] = {
			["a"] = 1.039,
			["b"] = 0.01555,
		},
		[15] = {
			["a"] = 1.055,
			["b"] = 0.02315,
		},
		[20] = {
			["a"] = 1.077,
			["b"] = 0.03448,
		},
		[25] = {
			["a"] = 1.108,
			["b"] = 0.05134,
		},
		[30] = {
			["a"] = 1.155,
			["b"] = 0.0771,
		},
		[35] = {
			["a"] = 1.217,
			["b"] = 0.11384,
		},
		[40] = {
			["a"] = 1.313,
			["b"] = 0.16952,
		},
		[45] = {
			["a"] = 1.441,
			["b"] = 0.24604,
		},
		[50] = {
			["a"] = 1.682,
			["b"] = 0.3791,
		},
		[55] = {
			["a"] = 2.11,
			["b"] = 0.056444,
		},
		[60] = {
			["a"] = 3.497,
			["b"] = 1.07411,
		},
		[65] = {
			["a"] = 5.335,
			["b"] = 1.46188,
		},
		[70] = {
			["a"] = 9.477,
			["b"] = 1.8152,
		},
		[75] = {
			["a"] = 20.22,
			["b"] = 2.19155,
		},
		[80] = {
			["a"] = 56.2,
			["b"] = 2.5621,
		},
		[85] = {
			["a"] = 221.3,
			["b"] = 2.93265,
		},
	},
	["APCBC"] = {
		[10] = {
			["a"] = 1.0243,
			["b"] = 0.0225,
		},
		[15] = {
			["a"] = 1.0532,
			["b"] = 0.0327,
		},
		[20] = {
			["a"] = 1.1039,
			["b"] = 0.0454,
		},
		[25] = {
			["a"] = 1.1741,
			["b"] = 0.0549,
		},
		[30] = {
			["a"] = 1.2667,
			["b"] = 0.0655,
		},
		[35] = {
			["a"] = 1.3925,
			["b"] = 0.0993,
		},
		[40] = {
			["a"] = 1.5642,
			["b"] = 0.1388,
		},
		[45] = {
			["a"] = 1.7933,
			["b"] = 0.1655,
		},
		[50] = {
			["a"] = 2.1053,
			["b"] = 0.2035,
		},
		[55] = {
			["a"] = 2.5368,
			["b"] = 0.2427,
		},
		[60] = {
			["a"] = 3.0796,
			["b"] = 0.245,
		},
		[65] = {
			["a"] = 4.0041,
			["b"] = 0.3354,
		},
		[70] = {
			["a"] = 5.0803,
			["b"] = 0.3478,
		},
		[75] = {
			["a"] = 6.67445,
			["b"] = 0.3831,
		},
		[80] = {
			["a"] = 9.0598,
			["b"] = 0.4131,
		},
		[85] = {
			["a"] = 12.8207,
			["b"] = 0.455,
		},
	},
	["AP"] = {
		[10] = {
			["a"] = 0.98297,
			["b"] = 0.0637,
		},
		[15] = {
			["a"] = 1.00066,
			["b"] = 0.0969,
		},
		[20] = {
			["a"] = 1.0361,
			["b"] = 0.13561,
		},
		[25] = {
			["a"] = 1.1116,
			["b"] = 0.16164,
		},
		[30] = {
			["a"] = 1.2195,
			["b"] = 0.19702,
		},
		[35] = {
			["a"] = 1.3771,
			["b"] = 0.22456,
		},
		[40] = {
			["a"] = 1.6263,
			["b"] = 0.26313,
		},
		[45] = {
			["a"] = 2.0033,
			["b"] = 0.34171,
		},
		[50] = {
			["a"] = 2.6447,
			["b"] = 0.57353,
		},
		[55] = {
			["a"] = 3.231,
			["b"] = 0.69075,
		},
		[60] = {
			["a"] = 4.0708,
			["b"] = 0.81826,
		},
		[65] = {
			["a"] = 6.2655,
			["b"] = 0.9192,
		},
		[70] = {
			["a"] = 8.6492,
			["b"] = 1.00539,
		},
		[75] = {
			["a"] = 13.7512,
			["b"] = 1.074,
		},
		[80] = {
			["a"] = 21.8713,
			["b"] = 1.17973,
		},
		[85] = {
			["a"] = 34.4862,
			["b"] = 1.28631,
		},
	},
}
ENT.SLOPE_MULTIPLIERS.APHE = ENT.SLOPE_MULTIPLIERS.AP
ENT.SLOPE_MULTIPLIERS.APCR = ENT.SLOPE_MULTIPLIERS.AP
ENT.SLOPE_MULTIPLIERS.APC = ENT.SLOPE_MULTIPLIERS.APCBC
ENT.SLOPE_MULTIPLIERS.APHECBC = ENT.SLOPE_MULTIPLIERS.APCBC
ENT.SLOPE_MULTIPLIERS.APHEBC = ENT.SLOPE_MULTIPLIERS.APBC

gred.SLOPE_MULTIPLIERS = {}

for k,v in pairs(ENT.SLOPE_MULTIPLIERS) do
	gred.SLOPE_MULTIPLIERS[k] = v
end

-- ew

sound.Add( {
	name = "RP3_Engine",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	pitch = {100},
	sound = "gunsounds/rpg_rocket_loop.wav"
} )

sound.Add( {
	name = "Hydra_Engine",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	pitch = {100},
	sound = "wac/rocket_idle.wav"
} )

sound.Add( {
	name = "V1_Engine",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	pitch = {100},
	sound = "gunsounds/v1_loop.wav"
} )

sound.Add( {
	name = "Nebelwerfer_Fire",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	pitch = {80,140},
	sound = "gunsounds/nebelwerfer_rocket.wav"
} )
