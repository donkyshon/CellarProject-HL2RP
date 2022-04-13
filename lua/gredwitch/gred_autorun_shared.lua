
local util = util
local pairs = pairs
local table = table
local istable = istable
local IsInWorld = util.IsInWorld
local TraceLine = util.TraceLine
local QuickTrace = util.QuickTrace
local Effect = util.Effect
local MASK_ALL = MASK_ALL
local game = game
local gameAddParticles = game.AddParticles
local gameAddDecal = game.AddDecal
local PrecacheParticleSystem = PrecacheParticleSystem
local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
local CreateConVar = CreateConVar
local CreateClientConVar = CreateClientConVar
local tableinsert = table.insert
local IsValid = IsValid
local DMG_BLAST = DMG_BLAST
local CLIENT = CLIENT

local CAL_TABLE = {
	["wac_base_7mm"] = 1,
	["wac_base_12mm"] = 2,
	["wac_base_20mm"] = 3,
	["wac_base_30mm"] = 4,
	["wac_base_40mm"] = 5,
}


GRED_TANK_FRONT = 0
GRED_TANK_LEFT = 1
GRED_TANK_RIGHT = 2
GRED_TANK_REAR = 3

GRED_TANK_NONE = 0
GRED_TANK_TOP = 1
GRED_TANK_BOTTOM = 2 

gred = gred or {}
gred.AllNPCs = {}
gred.CVars = gred.CVars or {}
gred.Calibre = {}
gred.Particles = gred.Particles or {}
tableinsert(gred.Calibre,"wac_base_7mm")
tableinsert(gred.Calibre,"wac_base_12mm")
tableinsert(gred.Calibre,"wac_base_20mm")
tableinsert(gred.Calibre,"wac_base_30mm")
tableinsert(gred.Calibre,"wac_base_40mm")

gred.Mats = {
	default_silent			=	-1,
	floatingstandable		=	-1,
	no_decal				=	-1,
	
	boulder 				=	1,
	concrete				=	1,
	default					=	1,
	item					=	1,
	concrete_block			=	1,
	plaster					=	1,
	pottery					=	1,
	
	dirt					=	2,
			
	alienflesh				=	3,
	antlion					=	3,
	armorflesh				=	3,
	bloodyflesh				=	3,
	player					=	3,
	flesh					=	3,
	player_control_clip		=	3,
	zombieflesh				=	3,

	glass					=	4,
	ice						=	4,
	glassbottle				=	4,
	combine_glass			=	4,
		
	canister				=	5,
	chain					=	5,
	chainlink				=	5,
	combine_metal			=	5,
	crowbar					=	5,
	floating_metal_barrel	=	5,
	grenade					=	5,
	metal					=	5,
	metal_barrel			=	5,
	metal_bouncy			=	5,
	metal_Box				=	5,
	metal_seafloorcar		=	5,
	metalgrate				=	5,
	metalpanel				=	5,
	metalvent				=	5,
	metalvehicle			=	5,
	paintcan				=	5,
	roller					=	5,
	slipperymetal			=	5,
	solidmetal				=	5,
	strider					=	5,
	popcan					=	5,
	weapon					=	5,
		
	quicksand				=	6,
	sand					=	6,
	slipperyslime			=	6,
	antlionsand				=	6,
	
	snow					=	7,
		
	foliage					=	8,
	
	wood					=	9,
	wood_box				=	9,
	wood_crate 				=	9,
	wood_furniture			=	9,
	wood_lowDensity 		=	9,
	ladder 					=	9,
	wood_plank				=	9,
	wood_panel				=	9,
	wood_polid				=	9,
		
	grass					=	10,
	
	tile					=	11,
	ceiling_tile			=	11,
	
	plastic_barrel			=	12,
	plastic_barrel_buoyant	=	12,
	Plastic_Box				=	12,
	plastic					=	12,
	
	baserock 				=	13,
	rock					=	13,
	
	gravel					=	14,
	
	mud						=	15,
	
	watermelon				=	16,
		
	asphalt 				=	17,
	
	cardbaord 				=	18,
		
	rubber 					=	19,
	rubbertire 				=	19,
	slidingrubbertire 		=	19,
	slidingrubbertire_front =	19,
	slidingrubbertire_rear 	=	19,
	jeeptire 				=	19,
	brakingrubbertire 		=	19,
	
	carpet 					=	20,
	brakingrubbertire 		=	20,
	
	brick					=	21,
		
	foliage					=	22,
	
	paper 					=	23,
	papercup 				=	23,
		
	computer				=	24,
}

gred.MatsStr = {
	[1] = "concrete",
	[2] = "dirt",
	[4] = "glass",
	[5] = "metal",
	[6] = "sand",
	[7] = "snow",
	[8] = "leaves",
	[9] = "wood",
	[10] = "grass",
	[11] = "tile",
	[12] = "plastic",
	[13] = "rock",
	[14] = "gravel",
	[15] = "mud",
	[16] = "fruit",
	[17] = "asphalt",
	[18] = "cardboard",
	[19] = "rubber",
	[20] = "carpet",
	[21] = "brick",
	[22] = "leaves",
	[23] = "paper",
	[24] = "computer",
}

gred.CVars["gred_sv_12mm_he_impact"] 						= CreateConVar("gred_sv_12mm_he_impact"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_7mm_he_impact"] 						= CreateConVar("gred_sv_7mm_he_impact"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_tracers"] 								= CreateConVar("gred_sv_tracers"								,  "5"  , GRED_SVAR)
gred.CVars["gred_sv_bullet_dmg"] 							= CreateConVar("gred_sv_bullet_dmg"								,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_bullet_radius"] 						= CreateConVar("gred_sv_bullet_radius"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_override_hab"] 							= CreateConVar("gred_sv_override_hab"							,  "0"  , GRED_SVAR)

gred.CVars["gred_sv_easyuse"] 								= CreateConVar("gred_sv_easyuse"								,  "1"  , GRED_SVAR) 
gred.CVars["gred_sv_fragility"] 							= CreateConVar("gred_sv_fragility"								,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shockwave_unfreeze"] 					= CreateConVar("gred_sv_shockwave_unfreeze"						,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_soundspeed_divider"] 					= CreateConVar("gred_sv_soundspeed_divider"						,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_arti_spawnaltitude"] 					= CreateConVar("gred_sv_arti_spawnaltitude"						, "1000", GRED_SVAR)
gred.CVars["gred_sv_spawnable_bombs"] 						= CreateConVar("gred_sv_spawnable_bombs"						,  "1"  , GRED_SVAR)

gred.CVars["gred_sv_minricochetangle"] 						= CreateConVar("gred_sv_minricochetangle"						, "70"  , GRED_SVAR)
-- gred.CVars["gred_sv_shell_speed_multiplier"] 				= CreateConVar("gred_sv_shell_speed_multiplier"					,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shell_ap_damagemultiplier"]				= CreateConVar("gred_sv_shell_ap_damagemultiplier"				,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shell_apcr_damagemultiplier"]			= CreateConVar("gred_sv_shell_apcr_damagemultiplier"			,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shell_heat_damagemultiplier"]			= CreateConVar("gred_sv_shell_heat_damagemultiplier"			,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shell_he_damagemultiplier"]				= CreateConVar("gred_sv_shell_he_damagemultiplier"				,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shell_ap_lowpen_system"] 				= CreateConVar("gred_sv_shell_ap_lowpen_system"					,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shell_he_damage"] 						= CreateConVar("gred_sv_shell_he_damage"						,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_shell_gp_he_damagemultiplier"] 			= CreateConVar("gred_sv_shell_gp_he_damagemultiplier"			,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shell_enable_killcam"] 					= CreateConVar("gred_sv_shell_enable_killcam"					,  "1"  , GRED_SVAR)

-- gred.CVars["gred_sv_simfphys_bullet_dmg_tanks"] 			= CreateConVar("gred_sv_simfphys_bullet_dmg_tanks"				,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_arcade"] 						= CreateConVar("gred_sv_simfphys_arcade"						,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_infinite_ammo"] 				= CreateConVar("gred_sv_simfphys_infinite_ammo"					,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_spawnwithoutammo"] 			= CreateConVar("gred_sv_simfphys_spawnwithoutammo"				,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_enablecrosshair"] 				= CreateConVar("gred_sv_simfphys_enablecrosshair"				,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_lesswheels"] 					= CreateConVar("gred_sv_simfphys_lesswheels"					,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_turnrate_multplier"] 			= CreateConVar("gred_sv_simfphys_turnrate_multplier"			,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_health_multplier"] 			= CreateConVar("gred_sv_simfphys_health_multplier"				,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_testsuspensions"] 				= CreateConVar("gred_sv_simfphys_testsuspensions"				,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_suspension_rate"] 				= CreateConVar("gred_sv_simfphys_suspension_rate"				,  "0.1", GRED_SVAR)
gred.CVars["gred_sv_simfphys_forcefirstperson"] 			= CreateConVar("gred_sv_simfphys_forcefirstperson"				,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_manualreloadsystem"] 			= CreateConVar("gred_sv_simfphys_manualreloadsystem"			,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_forcesynchronouselevation"] 	= CreateConVar("gred_sv_simfphys_forcesynchronouselevation"		,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_moduledamagesystem"] 			= CreateConVar("gred_sv_simfphys_moduledamagesystem"			,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_realisticarmour"] 				= CreateConVar("gred_sv_simfphys_realisticarmour"				,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_smokereloadtime"] 				= CreateConVar("gred_sv_simfphys_smokereloadtime"				, "120" , GRED_SVAR)
gred.CVars["gred_sv_simfphys_traverse_speed_multiplier"] 	= CreateConVar("gred_sv_simfphys_traverse_speed_multiplier"		,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_elevation_speed_multiplier"] 	= CreateConVar("gred_sv_simfphys_elevation_speed_multiplier"	,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_infinite_mg_ammo"] 			= CreateConVar("gred_sv_simfphys_infinite_mg_ammo"				,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_disable_viewmodels"] 			= CreateConVar("gred_sv_simfphys_disable_viewmodels"			,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_vfire_thrower"] 				= CreateConVar("gred_sv_simfphys_vfire_thrower"					,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_reload_speed_multiplier"] 		= CreateConVar("gred_sv_simfphys_reload_speed_multiplier"		,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_camera_tankgunnersight"] 		= CreateConVar("gred_sv_simfphys_camera_tankgunnersight"		,  "1"  , GRED_SVAR)

gred.CVars["gred_jets_speed"] 								= CreateConVar("gred_jets_speed"								,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_oldrockets"] 							= CreateConVar("gred_sv_oldrockets"								,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_wac_heli_spin_chance"] 					= CreateConVar("gred_sv_wac_heli_spin_chance"					,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_wac_bombs"] 							= CreateConVar("gred_sv_wac_bombs"								,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_wac_radio"] 							= CreateConVar("gred_sv_wac_radio"								,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_wac_explosion_water"] 					= CreateConVar("gred_sv_wac_explosion_water"					,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_default_wac_munitions"] 				= CreateConVar("gred_sv_default_wac_munitions"					,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_wac_explosion"] 						= CreateConVar("gred_sv_wac_explosion"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_wac_heli_spin"] 						= CreateConVar("gred_sv_wac_heli_spin"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_wac_override"] 							= CreateConVar("gred_sv_wac_override"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_healthslider"] 							= CreateConVar("gred_sv_healthslider"							, "100" , GRED_SVAR)
gred.CVars["gred_sv_enablehealth"] 							= CreateConVar("gred_sv_enablehealth"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_enableenginehealth"] 					= CreateConVar("gred_sv_enableenginehealth"						,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_fire_effect"] 							= CreateConVar("gred_sv_fire_effect"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_multiple_fire_effects"] 				= CreateConVar("gred_sv_multiple_fire_effects"					,  "1"  , GRED_SVAR)

gred.CVars["gred_sv_lfs_healthmultiplier"] 					= CreateConVar("gred_sv_lfs_healthmultiplier"					,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_lfs_healthmultiplier_all"] 				= CreateConVar("gred_sv_lfs_healthmultiplier_all"				,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_lfs_godmode"] 							= CreateConVar("gred_sv_lfs_godmode"							,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_lfs_infinite_ammo"] 					= CreateConVar("gred_sv_lfs_infinite_ammo"						,  "0"  , GRED_SVAR)

gred.CVars["gred_sv_isdedicated"] 							= CreateConVar("gred_sv_isdedicated"							,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_resourceprecache"] 						= CreateConVar("gred_sv_resourceprecache"						,  "0"  , GRED_SVAR)

gred.ActiveSimfphysVehicles = gred.ActiveSimfphysVehicles or {}
gred.simfphys = gred.simfphys or {}

gred.CalTable = {
	["wac_base_7mm"] = {
		Speed = 1500,
		Damage = 40,
		RadiusMul = 1,
		Explodeable = false,
		ID = 1,
	},
	["wac_base_12mm"] = {
		Speed = 1300,
		Damage = 60,
		RadiusMul = 1,
		Explodeable = false,
		ID = 2,
	},
	["wac_base_20mm"] = {
		Speed = 950,
		Damage = 80,
		RadiusMul = 2,
		Explodeable = true,
		ID = 3,
	},
	["wac_base_30mm"] = {
		Speed = 830,
		Damage = 100,
		RadiusMul = 3,
		Explodeable = true,
		ID = 4,
	},
	["wac_base_40mm"] = {
		Speed = 680,
		Damage = 120,
		RadiusMul = 4,
		Explodeable = true,
		ID = 5,
	},
}



gred.Precache = function()
	gameAddDecal( "scorch_small",		"decals/scorch_small" )
	gameAddDecal( "scorch_medium",		"decals/scorch_medium" )
	gameAddDecal( "scorch_big",			"decals/scorch_big" )
	gameAddDecal( "scorch_huge",		"decals/scorch_huge" )
	gameAddDecal( "scorch_gigantic",	"decals/scorch_gigantic" )
	gameAddDecal( "scorch_x10",			"decals/scorch_x10" )
	
	gameAddParticles( "particles/doi_explosion_fx.pcf")
	gameAddParticles( "particles/doi_explosion_fx_b.pcf")
	gameAddParticles( "particles/doi_explosion_fx_c.pcf")
	gameAddParticles( "particles/doi_explosion_fx_grenade.pcf")
	gameAddParticles( "particles/doi_explosion_fx_new.pcf")
	gameAddParticles( "particles/doi_impact_fx.pcf" )
	gameAddParticles( "particles/doi_weapon_fx.pcf" )

	gameAddParticles( "particles/gb_water.pcf")
	gameAddParticles( "particles/gb5_100lb.pcf")
	gameAddParticles( "particles/gb5_500lb.pcf")
	gameAddParticles( "particles/gb5_1000lb.pcf")
	gameAddParticles( "particles/gb5_jdam.pcf")
	gameAddParticles( "particles/gb5_large_explosion.pcf")
	gameAddParticles( "particles/gb5_napalm.pcf")
	gameAddParticles( "particles/gb5_light_bomb.pcf")
	gameAddParticles( "particles/gb5_high_explosive_2.pcf")
	gameAddParticles( "particles/gb5_high_explosive.pcf")
	gameAddParticles( "particles/gb5_fireboom.pcf")
	gameAddParticles( "particles/neuro_tank_ap.pcf")

	gameAddParticles( "particles/ins_rockettrail.pcf")
	gameAddParticles( "particles/ammo_cache_ins.pcf")
	gameAddParticles( "particles/doi_rockettrail.pcf")
	gameAddParticles( "particles/mnb_flamethrower.pcf")
	gameAddParticles( "particles/impact_fx_ins.pcf" )
	gameAddParticles( "particles/environment_fx.pcf")
	gameAddParticles( "particles/water_impact.pcf")
	gameAddParticles( "particles/explosion_fx_ins.pcf")
	gameAddParticles( "particles/weapon_fx_tracers.pcf" )
	gameAddParticles( "particles/weapon_fx_ins.pcf" )

	gameAddParticles( "particles/gred_particles.pcf" )
	gameAddParticles( "particles/fire_01.pcf" )
	gameAddParticles( "particles/doi_explosions_smoke.pcf" )
	gameAddParticles( "particles/explosion_fx_ins_b.pcf" )
	gameAddParticles( "particles/ins_smokegrenade.pcf" )
	gameAddParticles( "particles/ww1_gas.pcf" )
	-- gameAddParticles( "particles/world_fx_ins.pcf" )

	-- Precaching main particles
	tableinsert(gred.Particles,"gred_20mm")
	tableinsert(gred.Particles,"gred_20mm_airburst")
	tableinsert(gred.Particles,"gred_40mm")
	tableinsert(gred.Particles,"gred_40mm_airburst")
	tableinsert(gred.Particles,"30cal_impact")
	tableinsert(gred.Particles,"fire_large_01")
	tableinsert(gred.Particles,"30cal_impact")
	tableinsert(gred.Particles,"doi_gunrun_impact")
	tableinsert(gred.Particles,"doi_artillery_explosion")
	tableinsert(gred.Particles,"doi_stuka_explosion")
	tableinsert(gred.Particles,"gred_mortar_explosion")
	tableinsert(gred.Particles,"gred_50mm")
	tableinsert(gred.Particles,"ins_rpg_explosion")
	tableinsert(gred.Particles,"ins_water_explosion")
	tableinsert(gred.Particles,"fireboom_explosion_midair")
	tableinsert(gred.Particles,"doi_petrol_explosion")

	tableinsert(gred.Particles,"doi_impact_water")
	tableinsert(gred.Particles,"ins_impact_water")
	tableinsert(gred.Particles,"water_small")
	tableinsert(gred.Particles,"water_medium")
	tableinsert(gred.Particles,"water_huge")

	tableinsert(gred.Particles,"muzzleflash_sparks_variant_6")
	tableinsert(gred.Particles,"muzzleflash_1p_glow")
	tableinsert(gred.Particles,"muzzleflash_m590_1p_core")
	tableinsert(gred.Particles,"muzzleflash_smoke_small_variant_1")
	for i = 0,1 do
		if i == 1 then pcfD = "ins_" else pcfD = "doi_" end
		tableinsert(gred.Particles,""..pcfD.."impact_concrete")
		tableinsert(gred.Particles,""..pcfD.."impact_dirt")
		tableinsert(gred.Particles,""..pcfD.."impact_glass")
		tableinsert(gred.Particles,""..pcfD.."impact_metal")
		tableinsert(gred.Particles,""..pcfD.."impact_sand")
		tableinsert(gred.Particles,""..pcfD.."impact_snow")
		tableinsert(gred.Particles,""..pcfD.."impact_leaves")
		tableinsert(gred.Particles,""..pcfD.."impact_wood")
		tableinsert(gred.Particles,""..pcfD.."impact_grass")
		tableinsert(gred.Particles,""..pcfD.."impact_tile")
		tableinsert(gred.Particles,""..pcfD.."impact_plastic")
		tableinsert(gred.Particles,""..pcfD.."impact_rock")
		tableinsert(gred.Particles,""..pcfD.."impact_gravel")
		tableinsert(gred.Particles,""..pcfD.."impact_mud")
		tableinsert(gred.Particles,""..pcfD.."impact_fruit")
		tableinsert(gred.Particles,""..pcfD.."impact_asphalt")
		tableinsert(gred.Particles,""..pcfD.."impact_cardboard")
		tableinsert(gred.Particles,""..pcfD.."impact_rubber")
		tableinsert(gred.Particles,""..pcfD.."impact_carpet")
		tableinsert(gred.Particles,""..pcfD.."impact_brick")
		tableinsert(gred.Particles,""..pcfD.."impact_leaves")
		tableinsert(gred.Particles,""..pcfD.."impact_paper")
		tableinsert(gred.Particles,""..pcfD.."impact_computer")
	end

	tableinsert(gred.Particles,"high_explosive_main_2")
	tableinsert(gred.Particles,"high_explosive_air_2")
	tableinsert(gred.Particles,"water_torpedo")
	tableinsert(gred.Particles,"high_explosive_air")
	tableinsert(gred.Particles,"napalm_explosion")
	tableinsert(gred.Particles,"napalm_explosion_midair")
	tableinsert(gred.Particles,"cloudmaker_ground")
	tableinsert(gred.Particles,"1000lb_explosion")
	tableinsert(gred.Particles,"500lb_air")
	tableinsert(gred.Particles,"100lb_air")
	tableinsert(gred.Particles,"500lb_ground")
	tableinsert(gred.Particles,"rockettrail")
	tableinsert(gred.Particles,"grenadetrail")
	tableinsert(gred.Particles,"gred_ap_impact")
	tableinsert(gred.Particles,"doi_mortar_explosion")
	tableinsert(gred.Particles,"doi_wparty_explosion")
	tableinsert(gred.Particles,"doi_smoke_artillery")
	tableinsert(gred.Particles,"doi_ceilingDust_large")
	tableinsert(gred.Particles,"m203_smokegrenade")
	tableinsert(gred.Particles,"doi_GASarty_explosion")
	tableinsert(gred.Particles,"doi_compb_explosion")
	tableinsert(gred.Particles,"doi_wpgrenade_explosion")
	tableinsert(gred.Particles,"ins_c4_explosion")
	tableinsert(gred.Particles,"doi_artillery_explosion_OLD")
	tableinsert(gred.Particles,"gred_highcal_rocket_explosion")

	tableinsert(gred.Particles,"muzzleflash_bar_3p")
	tableinsert(gred.Particles,"muzzleflash_garand_3p")
	tableinsert(gred.Particles,"muzzleflash_mg42_3p")
	tableinsert(gred.Particles,"ins_weapon_at4_frontblast")
	tableinsert(gred.Particles,"ins_weapon_rpg_backblast")
	tableinsert(gred.Particles,"ins_weapon_rpg_dust")
	tableinsert(gred.Particles,"gred_arti_muzzle_blast")
	tableinsert(gred.Particles,"gred_mortar_explosion_smoke_ground")
	tableinsert(gred.Particles,"weapon_muzzle_smoke")
	tableinsert(gred.Particles,"ins_ammo_explosionOLD")
	tableinsert(gred.Particles,"gred_ap_impact")
	tableinsert(gred.Particles,"AP_impact_wall")
	tableinsert(gred.Particles,"ins_m203_explosion")
	tableinsert(gred.Particles,"ins_weapon_rpg_frontblast")
	tableinsert(gred.Particles,"gred_arti_muzzle_blast_alt")
	tableinsert(gred.Particles,"doi_wprocket_explosion")
	tableinsert(gred.Particles,"gred_tracers_red_7mm")
	tableinsert(gred.Particles,"gred_tracers_green_7mm")
	tableinsert(gred.Particles,"gred_tracers_white_7mm")
	tableinsert(gred.Particles,"gred_tracers_yellow_7mm")
	tableinsert(gred.Particles,"gred_tracers_red_12mm")
	tableinsert(gred.Particles,"gred_tracers_green_12mm")
	tableinsert(gred.Particles,"gred_tracers_white_12mm")
	tableinsert(gred.Particles,"gred_tracers_yellow_12mm")
	tableinsert(gred.Particles,"gred_tracers_red_20mm")
	tableinsert(gred.Particles,"gred_tracers_green_20mm")
	tableinsert(gred.Particles,"gred_tracers_white_20mm")
	tableinsert(gred.Particles,"gred_tracers_yellow_20mm")
	tableinsert(gred.Particles,"gred_tracers_red_30mm")
	tableinsert(gred.Particles,"gred_tracers_green_30mm")
	tableinsert(gred.Particles,"gred_tracers_white_30mm")
	tableinsert(gred.Particles,"gred_tracers_yellow_30mm")
	tableinsert(gred.Particles,"gred_tracers_red_40mm")
	tableinsert(gred.Particles,"gred_tracers_green_40mm")
	tableinsert(gred.Particles,"gred_tracers_white_40mm")
	tableinsert(gred.Particles,"gred_tracers_yellow_40mm")
	tableinsert(gred.Particles,"flame_jet")
	tableinsert(gred.Particles,"doi_flak88_explosion")
	tableinsert(gred.Particles,"flamethrower_long")
	tableinsert(gred.Particles,"ap_impact_dirt")
	for k,v in pairs(gred.Particles) do PrecacheParticleSystem(v) end
end

gred.PrecacheResources = function()
	local filecount = 0
	local foldercount = 0
	local utilPrecacheModel = util.PrecacheModel
	local precache = function( dir, flst ) -- .mdl file list precahcer
		for _, _f in ipairs( flst ) do
			utilPrecacheModel( dir.."/".._f )
			filecount = filecount + 1
		end
	end

	findDir = function( parent, direcotry, foot ) -- internal shit
		local flst, a = file.Find( parent.."/"..direcotry.."/"..foot, "GAME" )
		local b, dirs = file.Find( parent.."/"..direcotry.."/*", "GAME" )
		for k,v in ipairs(dirs) do
			findDir(parent.."/"..direcotry,v,foot)
			foldercount = foldercount + 1
		end
		precache( parent.."/"..direcotry, flst )
	end
	timer.Simple(1,function()
		findDir( "models", "gredwitch", "*.mdl" )

		print("[GREDWITCH'S BASE] Precached "..filecount.." files in "..foldercount.." folders.")
	end)
end

gred.PrintBones = function(ent)
    for i = 0,ent:GetBoneCount() - 1 do
        print(i,ent:GetBoneName(i))
    end
end

gred.PrintPoseParams = function(ent)
	for i = 0,ent:GetNumPoseParameters() - 1 do
		local min,max = ent:GetPoseParameterRange(i)
		print(i,ent:GetPoseParameterName(i).." ("..min.." / "..max..")")
	end
end


local function AddHABAmmoTypes()
	if not hab then return end
	if not hab.Module.PhysBullet then return end
	
	local HAB_COLOR_RED 	= HAB_COLOR_RED or Color( 255, 0, 0, 255 )
	local HAB_COLOR_GREEN 	= HAB_COLOR_GREEN or Color( 0, 255, 0, 255 )
	local HAB_COLOR_YELLOW 	= HAB_COLOR_YELLOW or Color( 255, 255, 0, 255 )
	local Types = {}
	local hab_colors = {
		["red"] = HAB_COLOR_RED,
		["green"] = HAB_COLOR_GREEN,
		["white"] = color_white,
		["yellow"] = HAB_COLOR_YELLOW,
		[""] = HAB_COLOR_RED,
	}
	
	for k,v in pairs(hab_colors) do
		Types["wac_base_7mm"..k] = {
			name = "wac_base_7mm"..k,
			
			tracer = k == "" and nil or true,
			dmgtype = DMG_BULLET,
			plydmg = 15,
			npcdmg = 15,

			force = 32,
			minsplash = 0,
			maxsplash = 0,

			maxcarry = 1000,
			flags = 0,

			Velocity = 853,
			Color = v,
			EffectSize = 1,
			HullSize = 0,
			Penetration = 7,

			BlastDamage = 5,
			BlastDamageType = DMG_BLAST,
			BlastDamageRadius = 7,

			BalisticsType = HAB_BULLET_MODEL_G7,
			Fused = false,
			Proximity = false,
			Radius = 0,
			TimeToLive = 10,
			TracerTimeToLive = 10,

			Caliber = 7.62,
			Mass = 9.2,

			Number = 1,

			BulletType = HAB_BULLET_APHE
		}
		
		Types["wac_base_12mm"..k] = {
			name = "wac_base_12mm"..k,

			tracer = k == "" and nil or true,
			dmgtype = DMG_BULLET,
			plydmg = 25,
			npcdmg = 25,

			force = 66,
			minsplash = 0,
			maxsplash = 0,

			maxcarry = 1000,
			flags = 0,

			Velocity = 820,
			Color = HAB_COLOR_GREEN,
			EffectSize = 1,
			HullSize = 0,
			Penetration = 24,

			BlastDamage = 16,
			BlastDamageType = DMG_BLAST,
			BlastDamageRadius = 12,

			BalisticsType = HAB_BULLET_MODEL_G7,
			Fused = false,
			Proximity = false,
			Radius = 0,
			TimeToLive = 10,
			TracerTimeToLive = 10,

			Caliber = 12.7,
			Mass = 50,

			Number = 1,

			BulletType = HAB_BULLET_APHE
		}
		
		Types["wac_base_20mm"..k] = {
			name = "wac_base_20mm"..k,
			
			tracer = k == "" and nil or true,
			dmgtype = DMG_BULLET,
			plydmg = 30,
			npcdmg = 30,

			force = 80,
			minsplash = 0,
			maxsplash = 0,

			maxcarry = 1000,
			flags = 0,

			Velocity = 1030,
			Color = HAB_COLOR_RED,
			EffectSize = 2,
			HullSize = 0,
			Penetration = 13,

			BlastDamage = 45,
			BlastDamageType = DMG_BLAST,
			BlastDamageRadius = 30,

			BalisticsType = HAB_BULLET_MODEL_G7,
			Fused = true,
			Proximity = false,
			Radius = 0,
			TimeToLive = 8,
			TracerTimeToLive = 8,

			Caliber = 20,
			Mass = 10.2,

			Number = 1,

			BulletType = HAB_BULLET_APHE
		}
		
		Types["wac_base_30mm"..k] = {
			name = "wac_base_30mm"..k,
			
			tracer = k == "" and nil or true,
			dmgtype = DMG_BULLET,
			plydmg = 42,
			npcdmg = 42,

			force = 80,
			minsplash = 0,
			maxsplash = 0,

			maxcarry = 1000,
			flags = 0,

			Velocity = 960,
			Color = HAB_COLOR_RED,
			EffectSize = 3,
			HullSize = 0,
			Penetration = 15,

			BlastDamage = 50,
			BlastDamageType = DMG_BLAST,
			BlastDamageRadius = 50,

			BalisticsType = HAB_BULLET_MODEL_G7,
			Fused = true,
			Proximity = false,
			Radius = 0,
			TimeToLive = 8,
			TracerTimeToLive = 8,

			Caliber = 30,
			Mass = 38.9,

			Number = 1,

			BulletType = HAB_BULLET_HE
		}
		
		Types["wac_base_40mm"..k] = {
			name = "wac_base_40mm"..k,
			
			tracer = k == "" and nil or true,
			dmgtype = DMG_BULLET,
			plydmg = 58,
			npcdmg = 58,

			force = 120,
			minsplash = 0,
			maxsplash = 0,

			maxcarry = 1000,
			flags = 0,

			Velocity = 690,
			Color = HAB_COLOR_RED,
			EffectSize = 4,
			HullSize = 0,
			Penetration = 5,

			BlastDamage = 48,
			BlastDamageType = DMG_BLAST,
			BlastDamageRadius = 60,

			BalisticsType = HAB_BULLET_MODEL_G1,
			Fused = true,
			Proximity = false,
			Radius = 0,
			TimeToLive = 8,
			TracerTimeToLive = 8,

			Caliber = 37,
			Mass = 30,

			Number = 1,

			BulletType = HAB_BULLET_HE
		}
		
	end
	
	for k, v in pairs(Types) do
		hab.Module.PhysBullet.AddAmmoType(v)
	end
	
	return false
end

-- hook.Remove("PhysBulletOnAddAmmoTypes","gred_add_hab_ammotypes")
-- hook.Add("PhysBulletOnAddAmmoTypes","gred_add_hab_ammotypes",AddHABAmmoTypes)

local nextRefil = 0.5
hook.Add("OnEntityCreated","gred_ent_override",function(ent)
	if ent:IsNPC() then
		table.insert(gred.AllNPCs,ent)
		return
	end
	timer.Simple(FrameTime(),function()
		if !IsValid(ent) then return end
		-----------------------------------
		
		if ent.isWacAircraft then
			if gred.CVars["gred_sv_wac_override"]:GetBool() then
			-- if ent.Base == "wac_hc_base" then
				
				ent.Engines = 1
				ent.Sounds.Radio = ""
				ent.Sounds.crashsnd = ""
				ent.Sounds.bipsnd = "crash/bip_loop.wav"
				
				-- SHARED.LUA
				ent.addSounds = function(self)
					self.sounds = {}
					self.Sounds.crashsnd = "crash/crash_"..math.random(1,10)..".ogg" --ADDED BY THE GREDWITCH
					for name, value in pairs(self.Sounds) do
						if name != "BaseClass" then
							sound.Add({
								name = "wac."..self.ClassName.."."..name,
								channel = CHAN_STATIC,
								soundlevel = (name == "Blades" or name == "Engine") and 200 or 100,
								sound = value
							})
							self.sounds[name] = CreateSound(self, "wac."..self.ClassName.."."..name)
							if name == "Blades" then
								self.sounds[name]:SetSoundLevel(120)
							elseif name == "Engine" then
								self.sounds[name]:SetSoundLevel(110)
							elseif name == "Radio" and value != "" then --ADDED BY THE GREDWITCH (start)
								self.sounds[name]:SetSoundLevel(60)
							elseif name == "crashsnd" then
								self.sounds[name]:SetSoundLevel(120)
							elseif name == "bipsnd" then
								self.sounds[name]:SetSoundLevel(80) --ADDED BY THE GREDWITCH (end)
							end
						end
					end
				end
				
				if SERVER then -- INIT.LUA
					ent.addStuff = function(self)
						local HealthsliderVAR = gred.CVars["gred_sv_healthslider"]:GetInt()
						local HealthEnable = gred.CVars["gred_sv_enablehealth"]:GetInt()
						local EngineHealthEnable = gred.CVars["gred_sv_enableenginehealth"]:GetInt()
						local Healthslider = 100
						if HealthEnable == 1 and EngineHealthEnable == 1 then
							
							if HealthsliderVAR == nil or HealthsliderVAR <= 0 then 
								Healthslider = 100
							else 
								Healthslider = HealthsliderVAR
							end
							
							self.engineHealth = self.Engines*Healthslider
							self.EngineHealth = self.Engines*Healthslider
							
						elseif HealthEnable == 1 and EngineHealthEnable == 0 then
						
							if HealthsliderVAR == nil or HealthsliderVAR <= 0 then 
								Healthslider = 100
							else 
								Healthslider = HealthsliderVAR
							end
							
							self.Engines = 1
							self.engineHealth = Healthslider
							self.EngineHealth = Healthslider
						end
					end
					
					ent.GredExplode = function(self,speed,pos)
						if self.blewup then return end
						self.blewup = true
						local lasta=(self.LastDamageTaken<CurTime()+6 and self.LastAttacker or self.Entity)
						for k, p in pairs(self.passengers) do
							if p and p:IsValid() then
								p:TakeDamage(speed,lasta,self.Entity)
							end
						end
						self:TakeDamage(self.engineHealth)
						if gred.CVars["gred_sv_wac_explosion"]:GetInt() <= 0 then return end
						local radius = self:BoundingRadius()
						local hitang = Angle(0,self:GetAngles().y+90,0)
						
						gred.CreateSound(pos,false,"explosions/fuel_depot_explode_close.wav","explosions/fuel_depot_explode_dist.wav","explosions/fuel_depot_explode_far.wav")
						
						self:Remove()
						if radius <= 300 then
							local effectdata = EffectData()
							effectdata:SetOrigin(pos)
							effectdata:SetAngles(hitang)
							effectdata:SetFlags(1)
							effectdata:SetSurfaceProp(1)
							Effect("gred_particle_wac_explosion",effectdata)
							radius = 600
						elseif radius <= 500 then
							local effectdata = EffectData()
							effectdata:SetOrigin(pos)
							effectdata:SetAngles(hitang)
							effectdata:SetFlags(5)
							effectdata:SetSurfaceProp(1)
							Effect("gred_particle_wac_explosion",effectdata)
							
							radius = 800
						elseif radius <= 2000 then
							local effectdata = EffectData()
							effectdata:SetOrigin(pos)
							effectdata:SetAngles(hitang)
							effectdata:SetFlags(9)
							effectdata:SetSurfaceProp(1)
							Effect("gred_particle_wac_explosion",effectdata)
							radius = 1000
						end
						gred.CreateExplosion(pos,radius,1000,self.Decal,self.TraceLength,self.GBOWNER,self,self.DEFAULT_PHYSFORCE,self.DEFAULT_PHYSFORCE_PLYGROUND,self.DEFAULT_PHYSFORCE_PLYAIR)
					end
					 
					ent.PhysicsCollide = function(self,cdat, phys)
						timer.Simple(0,function()
							if wac.aircraft.cvars.nodamage:GetBool() then
								return
							end
							if cdat.DeltaTime > 0.5 then
								local mass = cdat.HitObject:GetMass()
								if cdat.HitEntity:GetClass() == "worldspawn" then
									mass = 5000
								end
								local dmg = (cdat.Speed*cdat.Speed*math.Clamp(mass, 0, 5000))/10000000
								if !dmg or dmg < 1 then return end
								self:TakeDamage(dmg*15)
								if dmg > 2 then
									self.Entity:EmitSound("vehicles/v8/vehicle_impact_heavy"..math.random(1,4)..".wav")
									local lasta=(self.LastDamageTaken<CurTime()+6 and self.LastAttacker or self.Entity)
									for k, p in pairs(self.passengers) do
										if p and p:IsValid() then
											p:TakeDamage(dmg/5, lasta, self.Entity)
										end
									end
								end
							end
							-- ADDED BY THE GREDWITCH
							if (cdat.Speed > 1000 and !self.ShouldRotate) 
							or (cdat.Speed > 100 and self.ShouldRotate and !cdat.HitEntity.isWacRotor) 
							and (!cdat.HitEntity:IsPlayer() and!cdat.HitEntity:IsNPC() and !string.StartWith(cdat.HitEntity:GetClass(),"vfire")) then
								self:GredExplode(cdat.speed,cdat.HitPos)
							end
						end)
					end
				
					ent.Think = function(self)
						self:base("wac_hc_base").Think(self)
						-- START ADDED BY THE GREDWITCH
						if self.sounds.Radio then
							if self.active and gred.CVars["gred_sv_wac_radio"]:GetBool() then
								self.sounds.Radio:Play()
							else
								self.sounds.Radio:Stop()
							end
						end
						if self:WaterLevel() >= 2 and gred.CVars["gred_sv_wac_explosion_water"]:GetBool() and !self.hascrashed then
							local pos = self:GetPos()
							local trdat   = {}
							trdat.start   = pos+Vector(0,0,4000)
							trdat.endpos  = pos
							trdat.filter  = self
							trdat.mask    = MASK_WATER + CONTENTS_TRANSLUCENT
							
							local tr = util.TraceLine(trdat)
							
							if tr.Hit then
								local ang = Angle(-90,0,0)
								local radius = self:BoundingRadius()
								local water = "ins_water_explosion"
								if radius <= 600 then
									local effectdata = EffectData()
									effectdata:SetOrigin(pos)
									effectdata:SetAngles(ang)
									effectdata:SetSurfaceProp(2)
									effectdata:SetFlags(1)
									Effect("gred_particle_wac_explosion",effectdata)
								else
									local effectdata = EffectData()
									effectdata:SetOrigin(pos)
									effectdata:SetAngles(ang)
									effectdata:SetSurfaceProp(2)
									effectdata:SetFlags(2)
									Effect("gred_particle_wac_explosion",effectdata)
								end
								
								gred.CreateSound(pos,false,"/explosions/aircraft_water_close.wav","/explosions/aircraft_water_dist.wav","/explosions/aircraft_water_far.wav")
								
								local lasta=(self.LastDamageTaken<CurTime()+6 and self.LastAttacker or self.Entity)
								if istable(self.passengers) then
									for k, p in pairs(self.passengers) do
										if p and p:IsValid() then
											p:TakeDamage(p:Health() + 20, lasta, self.Entity)
										end
									end
								end
								self.hascrashed = true
								self:Remove()
							end
						end
						
						if self.ShouldRotate and self.backRotor and self.topRotor and self.Base != "wac_pl_base" and !self.disabled
						and self.rotorRpm > 0.2 and gred.CVars["gred_sv_wac_heli_spin"]:GetBool() then
							local p = self:GetPhysicsObject()
							if p and IsValid(p) then
								if !self.sounds.crashsnd:IsPlaying() then
									self.sounds.crashsnd:Play()
								end
								self.sounds.bipsnd:Play()
								local m = p:GetMass()
								local v = p:GetAngleVelocity()
								local v1 = p:GetVelocity()
								-- if p:GetVelocity().z > -300 then
									-- p:AddVelocity(Vector(0,0,2*(m/1200)*-(15*self.rotorRpm)))
								-- end
								p:SetVelocity(Vector(v1.x,v1.y,-300))--2*(m/1200)*-(15*self.rotorRpm)))
								m = m/200
								if v.z < 150 then
									p:AddAngleVelocity(Vector(0,0,3*m))
								end
								if v.y > -50 then
									p:AddAngleVelocity(Vector(0,-10-m,0))
								end
								self:SetHover(true)
								self.controls.throttle = 0
								for k,v in pairs (self.wheels) do
									if !v.ph then
										v.ph = function(ent,data) 
											v.GredHitGround = true	
										end
										v:AddCallback("PhysicsCollide",v.ph)
									end
									if v.GredHitGround then
										self:GredExplode(500,self:GetPos())
									end
								end
							end
						else
							if !self.topRotor and self.sounds.crashsnd then
								self.sounds.crashsnd:Stop()
							end
						end
						
						-- END ADDED BY THE GREDWITCH
					end
					
					ent.GredIsOnGround = function(self,v)
						local p = v:GetPos()
						return util.QuickTrace(p,p-Vector(0,0,1)).Hit
					end
					
					ent.DamageEngine = function(self,amt)
						if wac.aircraft.cvars.nodamage:GetBool() then
							return
						end
						if self.disabled then return end
						self.engineHealth = self.engineHealth - amt

						if self.engineHealth < 80  then
							if !self.sounds.MinorAlarm:IsPlaying() then
								self.sounds.MinorAlarm:Play()
							end
							if !self.Smoke and self.engineHealth>0 then
								self.Smoke = self:CreateSmoke()
							end
							if self.engineHealth < 50 then
								if !self.sounds.LowHealth:IsPlaying() then
									self.sounds.LowHealth:Play()
								end
								f = math.random(0,gred.CVars["gred_sv_wac_heli_spin_chance"]:GetInt())
								if !self.ShouldRotate and f == 0 then
									self.OldGredUP = self:GetUp()
									self.ShouldRotate = true
								end
								
								
								if self.engineHealth < 20 and !self.EngineFire then
									local fire = ents.Create("env_fire")
									fire:SetPos(self:LocalToWorld(self.FirePos))
									fire:Spawn()
									fire:SetParent(self.Entity)
									if gred.CVars["gred_sv_fire_effect"]:GetBool() then
										ParticleEffectAttach("fire_large_01", 1, fire, 0)
										if (gred.CVars["gred_sv_multiple_fire_effects"]:GetBool()) then
											if self.OtherRotors then 
												for i = 1,3 do
													if not self.OtherRotors[i] then return end
													ParticleEffectAttach("fire_large_01", 1, self.OtherRotors[i], 0)
												end
											end
											if self.OtherRotor then ParticleEffectAttach("fire_large_01", 1, self.OtherRotor, 0) end
											if self.rotor2 then ParticleEffectAttach("fire_large_01", 1, self.rotor2, 0) end
											if self.topRotor2 then ParticleEffectAttach("fire_large_01", 1, self.topRotor2, 0) end
										end
									elseif gred.CVars["gred_sv_fire_effect"]:GetInt() <= 0 then
										if gred.CVars["gred_sv_multiple_fire_effects"]:GetBool() then
											if self.OtherRotors then
												for i = 1,3 do
													if not self.OtherRotors[i] then return end
													local fire = ents.Create("env_fire_trail")
													fire:SetPos(self:LocalToWorld(self.OtherRotorPos[i]))
													fire:Spawn()
													fire:SetParent(self.Entity)
												end
											else
												if self.OtherRotor then local pos = self:LocalToWorld(self.OtherRotorPos) end
												if self.rotor2 then local pos = self:LocalToWorld(self.rotorPos2) end
												if self.topRotor2 then local pos = self:LocalToWorld(self.TopRotor2.pos) end
												if pos then
													local fire = ents.Create("env_fire_trail")
													fire:SetPos(pos)
													fire:Spawn()
													fire:SetParent(self.Entity)
												end
											end
										end
									end
									self.sounds.LowHealth:Play()
									self.EngineFire = fire
								end
								if self.engineHealth < 10 and (!self.ShouldRotate or !self.blewup) then 
									self.engineDead = true 
									self:setEngine(false) 
								end

								if self.engineHealth < 0 and !self.disabled and (!self.ShouldRotate or !self.blewup) then
									self.disabled = true
									self.engineRpm = 0
									self.rotorRpm = 0
									local lasta=(self.LastDamageTaken<CurTime()+6 and self.LastAttacker or self.Entity)
									for k, p in pairs(self.passengers) do
										if p and p:IsValid() then
											p:TakeDamage(p:Health() + 20, lasta, self.Entity)
										end
									end

									for k,v in pairs(self.seats) do
										v:Remove()
									end
									self.passengers={}
									self:StopAllSounds()

									self:setVar("rotorRpm", 0)
									self:setVar("engineRpm", 0)
									self:setVar("up", 0)

									self.IgnoreDamage = false
									--[[ this affects the base class
										for name, vec in pairs(self.Aerodynamics.Rotation) do
											vec = VectorRand()*100
										end
										for name, vec in pairs(self.Aerodynamics.Lift) do
											vec = VectorRand()
										end
										self.Aerodynamics.Rail = Vector(0.5, 0.5, 0.5)
									]]
									local effectdata = EffectData()
									effectdata:SetStart(self.Entity:GetPos())
									effectdata:SetOrigin(self.Entity:GetPos())
									effectdata:SetScale(1)
									Effect("Explosion", effectdata)
									Effect("HelicopterMegaBomb", effectdata)
									Effect("cball_explode", effectdata)
									util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 300, 300)
									self:setEngine(false)
									if self.Smoke then
										self.Smoke:Remove()
										self.Smoke=nil
									end
									if self.RotorWash then
										self.RotorWash:Remove()
										self.RotorWash=nil
									end
									if self:WaterLevel() >= 1 and gred.CVars["gred_sv_wac_explosion_water"]:GetBool() then
										local pos = self:GetPos()
										local trdat   = {}
										trdat.start   = pos+Vector(0,0,4000)
										trdat.endpos  = pos
										trdat.filter  = self
										trdat.mask    = MASK_WATER + CONTENTS_TRANSLUCENT
											 
										local tr = util.TraceLine(trdat)
							
										if tr.Hit then
											local ang = Angle(-90,0,0)
											local radius = self:BoundingRadius()
											local water = "ins_water_explosion"
											if radius <= 600 then
												local effectdata = EffectData()
												effectdata:SetOrigin(tr.HitPos)
												effectdata:SetAngles(ang)
												effectdata:SetSurfaceProp(2)
												effectdata:SetFlags(1)
												Effect("gred_particle_wac_explosion",effectdata)
											else
												local effectdata = EffectData()
												effectdata:SetOrigin(tr.HitPos)
												effectdata:SetAngles(ang)
												effectdata:SetSurfaceProp(2)
												effectdata:SetFlags(2)
												Effect("gred_particle_wac_explosion",effectdata)
											end
											self.hascrashed = true
											self:Remove()
										end
									end
									--[[self:SetNWBool("locked", true)
									timer.Simple( 0.1, function() self:Remove() end)--]]
								end
							end
						end
						if self.Smoke then
							local rcol = math.Clamp(self.engineHealth*3.4, 0, 170)
							self.Smoke:SetKeyValue("rendercolor", rcol.." "..rcol.." "..rcol)
						end
						self:SetNWFloat("health", self.engineHealth)
					end
				end
				
				if CLIENT then -- CL_INIT.LUA
					ent.receiveInput = function(self,name, value, seat)
						if name == "FreeView" then
							local player = LocalPlayer()
							if value > 0.5 then
								-- ADDED BY GREDWITCH
								if self.Camera and seat == self.Camera.seat and seat != 1 then
									if !player:GetVehicle().useCamerazoom then player:GetVehicle().useCamerazoom = 0 end
									player:GetVehicle().useCamerazoom = player:GetVehicle().useCamerazoom + 1
									if player:GetVehicle().useCamerazoom > 3 then player:GetVehicle().useCamerazoom = 0 end
								else -- END
									player.wac.viewFree = true
								end -- ADDED BY GREDWITCH
							else
								if self.Camera and seat == self.Camera.seat and seat != 1 then
								else
									player.wac.viewFree = false
									player.wac_air_resetview = true
								end
							end
						elseif name == "Camera" then
							local player = LocalPlayer()
							if value > 0.5 then
								player:GetVehicle().useCamera = !player:GetVehicle().useCamera
								if self.Camera and seat == self.Camera.seat then player:GetVehicle().useCamerazoom = 0 end -- ADDED BY GREDWITCH
							end
						end
					end
					
					ent.viewCalcCamera = function(self,k, p, view)
						view.origin = self.camera:LocalToWorld(self.Camera.viewPos)
						view.angles = self.camera:GetAngles()
						
						-- ADDED BY GREDWITCH
						local zoom = p:GetVehicle().useCamerazoom
						if zoom then
							if zoom >= 1 then
								view.fov = view.fov - zoom*20
							end
						end	
						for k, t in pairs(self.Seats) do
							if k != "BaseClass" and self:getWeapon(k) then
								if self:getWeapon(k).HasLastShot then
									if self:getWeapon(k):GetIsShooting() then
										local ang = view.angles
										view.angles = view.angles + Angle(0,0,math.random(-2,2))
										timer.Simple(0.02,function() if IsValid(self) then
											view.angles = ang
											end
										end)
									end
								end
							end
						end
						-- END
						if self.viewTarget then
							self.viewTarget.angles = p:GetAimVector():Angle() - self:GetAngles()
						end
						self.viewPos = nil
						p.wac.lagAngles = Angle(0, 0, 0)
						p.wac.lagAccel = Vector(0, 0, 0)
						p.wac.lagAccelDelta = Vector(0, 0, 0)
						return view
					end
				end
				
				ent:addSounds()
			end
		elseif ent.LFS then
			if ent.Author == "Gredwitch" or gred.CVars["gred_sv_lfs_healthmultiplier_all"]:GetBool() and ent.MaxHealth then
				ent.MaxHealth = ent.MaxHealth * gred.CVars["gred_sv_lfs_healthmultiplier"]:GetFloat()
				ent.OldSetupDataTables = ent.SetupDataTables
				ent.SetupDataTables = function()
					if ent.DataSet then return end
					ent.DataSet = true
					ent:OldSetupDataTables()
					ent:NetworkVar( "Float",6, "HP", { KeyName = "health", Edit = { type = "Float", order = 2,min = 0, max = ent.MaxHealth, category = "Misc"} } )
				end
				ent:SetupDataTables()
				
				ent:SetHP(ent.MaxHealth)
			end
			if gred.CVars["gred_sv_lfs_godmode"]:GetBool() then
				ent.Explode = function() return end
				ent.OnTakeDamage = function() return end
				ent.CheckRotorClearance = function() return end
				ent.nextDFX = 999999999999
			end
			if !CLIENT then
				if gred.CVars["gred_sv_lfs_infinite_ammo"]:GetBool() then
					local oldthink = ent.Think
					ent.Think = function(self)
						if nextRefil < CurTime() then
							if self.MaxPrimaryAmmo != -1 and self.SetAmmoPrimary then
								self:SetAmmoPrimary(self.MaxPrimaryAmmo)
							end
							if self.MaxSecondaryAmmo != -1 and self.SetAmmoSecondary then
								self:SetAmmoSecondary(self.MaxSecondaryAmmo)
							end
							if self.SetAmmoMGFF then
								self:SetAmmoMGFF(self.AmmoMGFF)
							end
							if self.SetAmmoCannon then
								self:SetAmmoCannon(self.AmmoCannon)
							end
						end
						return oldthink(self)
					end
				end
			end
		-- elseif ent.IsSimfphyscar then
			-- ent.CachedSpawnList = ent:GetSpawn_List()
			-- if gred.simfphys[ent.CachedSpawnList] then
				-- local k = table.insert(gred.ActiveSimfphysVehicles,ent)
				-- ent:CallOnRemove("RemoveFromVehicleTable",function(ent)
					-- table.remove(gred.ActiveSimfphysVehicles,k)
				-- end)
			-- end
		else
			if !CLIENT then
				if ent.ClassName == "wac_hc_rocket" then
					ent.Initialize = function(self)
						math.randomseed(CurTime())
						self.Entity:SetModel("models/weltensturm/wac/rockets/rocket01.mdl")
						self.Entity:PhysicsInit(SOLID_VPHYSICS)
						self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
						self.Entity:SetSolid(SOLID_VPHYSICS)
						self.phys = self.Entity:GetPhysicsObject()
						if (self.phys:IsValid()) then
							self.phys:SetMass(400)
							self.phys:EnableGravity(false)
							self.phys:EnableCollisions(true)
							self.phys:EnableDrag(false)
							self.phys:Wake()
						end
						self.sound = CreateSound(self.Entity, "WAC/rocket_idle.wav")
						self.matType = MAT_DIRT
						self.hitAngle = Angle(270, 0, 0)
						if self.calcTarget then
							self.Speed = 70
						else
							self.Speed = 100
						end
					end
				elseif ent.ClassName == "gred_prop_part" or ent.ClassName == "gred_prop_tail" then
					if gred.CVars["gred_sv_lfs_godmode"]:GetBool() then
						ent.OnTakeDamage = function() return end
					end
				end
			end
		end
	end)
end)

hook.Add("EntityRemoved","gred_ent_removed",function(ent)
	if ent:IsNPC() then
		table.RemoveByValue(gred.AllNPCs,ent)
		return
	end
end)




local function OverrideSimfphys()
	local ENT = scripted_ents.Get("gmod_sent_vehicle_fphysics_base")
	
	if not ENT then return end
	
	ENT.Gred_OldThink = ENT.Gred_OldThink or ENT.Think
	
	if SERVER then
		ENT.Gred_OldInit = ENT.Gred_OldInit or ENT.Initialize
		
		function ENT:Initialize()
			self:Gred_OldInit()
			
			timer.Simple(0,function()
				if !IsValid(self) then return end 
				
				self.CachedSpawnList = self:GetSpawn_List()
				
				if gred.simfphys[self.CachedSpawnList] then
					gred.InitializeSimfphys(self)
					
					local k = table.insert(gred.ActiveSimfphysVehicles,self)
					
					self:CallOnRemove("RemoveFromVehicleTable",function(ent)
						table.remove(gred.ActiveSimfphysVehicles,k)
					end)
				end
			end)
		end
	else
		ENT.Gred_OldManageSounds = ENT.Gred_OldManageSounds or ENT.ManageSounds
		ENT.VolumeMul = 0.3
		
		function ENT:ManageSounds(Active,Throttle,LimitRPM)
			self:Gred_OldManageSounds(Active,Throttle,LimitRPM)
			
			local ply = LocalPlayer()
			
			if ply:GetSimfphys() == self and self.LocalPlayerActiveSeat and gred.PlayerIsInsideVehicle(ply,self,self.LocalPlayerActiveSeat,self.LocalPlayerActiveSeatID) then
				if self.Idle then
					self.Idle:ChangeVolume(self.Idle:GetVolume() * self.VolumeMul)
				end
				
				if self.LowRPM then
					self.LowRPM:ChangeVolume(self.LowRPM:GetVolume() * self.VolumeMul)
				end
				
				if self.HighRPM then
					self.HighRPM:ChangeVolume(self.HighRPM:GetVolume() * self.VolumeMul)
				end
			end
		end
		
		function ENT:Think()
			self.Think = self.Gred_OldThink
			
			self.CachedSpawnList = self:GetSpawn_List()
			
			if gred.simfphys[self.CachedSpawnList] then
				gred.InitializeSimfphys(self)
				
				local k = table.insert(gred.ActiveSimfphysVehicles,self)
				
				self:CallOnRemove("RemoveFromVehicleTable",function(ent)
					table.remove(gred.ActiveSimfphysVehicles,k)
				end)
			end
			
			self:Gred_OldThink()
		end
	end
	
	scripted_ents.Register(ENT,"gmod_sent_vehicle_fphysics_base")
end

hook.Add("PostGamemodeLoaded","gred_simfphys_PostGamemodeLoaded",OverrideSimfphys)

OverrideSimfphys()

if SERVER then
	gred.CVars.gred_sv_isdedicated:SetBool(game.IsDedicated())
end