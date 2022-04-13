local angle_yaw_90 = Angle(0,90)
local angle_zero = Angle()
local vector_zero = Vector()

local Vector = Vector
local Angle = Angle

local ENTITY = FindMetaTable("Entity")
local GetPhysicsObject = ENTITY.GetPhysicsObject
local GetNWInt = ENTITY.GetNWInt
local SetNWBool = ENTITY.SetNWBool
local GetRight = ENTITY.GetRight
local GetUp = ENTITY.GetUp
local GetForward = ENTITY.GetForward
local SetPoseParameter = ENTITY.SetPoseParameter
local SetParent = ENTITY.SetParent
local SetAngles = ENTITY.SetAngles
local GetAngles = ENTITY.GetAngles
local SetPos = ENTITY.SetPos
local GetPos = ENTITY.GetPos
local EnityWorldToLocal = ENTITY.WorldToLocal
local EntityLocalToWorld = ENTITY.LocalToWorld
local LocalToWorldAngles = ENTITY.LocalToWorldAngles
local WorldToLocalAngles = ENTITY.WorldToLocalAngles
local GetAttachment = ENTITY.GetAttachment
local SetNWVector = ENTITY.SetNWVector
local SetNWString = ENTITY.SetNWString
local SetNWFloat = ENTITY.SetNWFloat
local SetNWInt = ENTITY.SetNWInt
local GetNWBool = ENTITY.GetNWBool
local GetNWInt = ENTITY.GetNWInt
local GetNWFloat = ENTITY.GetNWFloat
local GetNWVector = ENTITY.GetNWVector
local GetNWString = ENTITY.GetNWString
local GetClass = ENTITY.GetClass
local GetSurfaceMaterial = ENTITY.GetSurfaceMaterial
local RemoveCallOnRemove = ENTITY.RemoveCallOnRemove
local CallOnRemove = ENTITY.CallOnRemove
local GetPoseParameter = ENTITY.GetPoseParameter
local SetCollisionGroup = ENTITY.SetCollisionGroup
local TakeDamageInfo = ENTITY.TakeDamageInfo
local GetEyeAngles = ENTITY.EyeAngles
local GetParent = ENTITY.GetParent
local Ignite = ENTITY.Ignite

local VECTOR = FindMetaTable("Vector")
local LengthSqr = VECTOR.LengthSqr
local DistToSqr = VECTOR.DistToSqr

local PHYSOBJ = FindMetaTable("PhysObj")
local PhysGetVelocity = PHYSOBJ.GetVelocity
local GetAngleVelocity = PHYSOBJ.GetAngleVelocity
local ApplyForceOffset = PHYSOBJ.ApplyForceOffset
local ApplyTorqueCenter = PHYSOBJ.ApplyTorqueCenter
local ApplyForceCenter = PHYSOBJ.ApplyForceCenter
local GetMass = PHYSOBJ.GetMass

local PLAYER = FindMetaTable("Player")
local SetEyeAngles = PLAYER.SetEyeAngles
local GetSteamID = PLAYER.SteamID
local GetInfoNum = PLAYER.GetInfoNum
local KeyDown = PLAYER.KeyDown
local Ping = PLAYER.Ping

local ANGLE = FindMetaTable("Angle")
local Normalize = ANGLE.Normalize
local Forward = ANGLE.Forward

local CSoundPatch = FindMetaTable("CSoundPatch")
local CreateSound = CreateSound
local IsPlaying = CSoundPatch.IsPlaying
local ChangePitch = CSoundPatch.ChangePitch
local ChangeVolume = CSoundPatch.ChangeVolume
local GetVolume = CSoundPatch.GetVolume

local CTakeDamageInfo = FindMetaTable("CTakeDamageInfo")
local DamageInfo = DamageInfo
local SetAttacker = CTakeDamageInfo.SetAttacker
local SetInflictor = CTakeDamageInfo.SetInflictor
local SetDamageType = CTakeDamageInfo.SetDamageType
local SetDamage = CTakeDamageInfo.SetDamage

local netStart = net.Start
local netBroadcast = net.Broadcast
local netSend = net.Send
local netWriteEntity = net.WriteEntity
local netWriteInt = net.WriteInt
local netWriteUInt = net.WriteUInt

local TraceHull = util.TraceHull
local QuickTrace = util.QuickTrace
local GetSurfacePropName = util.GetSurfacePropName

local Round = math.Round
local Clamp = math.Clamp
local Rand = math.Rand
local ApproachAngle = math.ApproachAngle

local abs = math.abs
local max = math.max
local floor = math.floor
local random = math.random
local ceil = math.ceil
local sqrt = math.sqrt

local lower = string.lower

local LocalToWorld = LocalToWorld
local WorldToLocal = WorldToLocal
local pairs = pairs
local next = next
local CurTime = CurTime

local BadFlamethrowerClasses = {
	["prop_vehicle_prisoner_pod"] = true,
	["gmod_sent_vehicle_fphysics_attachment"] = true,
	["info_player_start"] = true,
	["info_particle_system"] = true,
	["phys_spring"] = true,
	["physgun_beam"] = true,
	["predicted_viewmodel"] = true,
	["entityflame"] = true,
	-- "gmod_sent_vehicle_fphysics_wheel" = true,
}
local BadDamageTypes = {
	[DMG_GENERIC] = true,
	[DMG_CRUSH] = true,
	[DMG_BULLET] = true,
	[DMG_SLASH] = true,
	[DMG_BURN] = true,
}
local ShellClass = {
	["wac_base_grocket"] = true,
	["base_shell"] = true,
	["base_rocket"] = true,
	["hvap_swep_rocket_barrage_he"] = true,
	["hvap_swep_rocket_barrage_smoke"] = true,
	["hvap_swep_rocket_bazooka_he"] = true,
	["hvap_swep_rocket_bazooka_heat"] = true,
	["hvap_swep_rocket_bazooka_wp"] = true,
	["hvap_swep_rocket_faust_heat"] = true,
	["hvap_swep_rocket_shrek_heat"] = true,
}
local SmokeSnds = { -- to clean
	"gred_emp/nebelwerfer/artillery_strike_smoke_close_01.wav",
	"gred_emp/nebelwerfer/artillery_strike_smoke_close_02.wav",
	"gred_emp/nebelwerfer/artillery_strike_smoke_close_03.wav",
	"gred_emp/nebelwerfer/artillery_strike_smoke_close_04.wav",
}

local tr_flame_tab = {}
local tr_wheel_tab = {}


gred.TankCanShootCannon = function(vehicle,seat,ply,ct,SeatTab,WeaponTab,SeatID,SeatSlotTab,SlotID,HatchID)
	return ct > SeatSlotTab.NextShot and SeatSlotTab.ShellTypes[SeatSlotTab.CurShellID] > 0 and ((vehicle.gred_sv_simfphys_manualreloadsystem and !WeaponTab.AutoLoader) and SeatSlotTab.IsLoaded or true) and (SeatTab.RequiresHatch and SeatTab.RequiresHatch[HatchID] or (!SeatTab.RequiresHatch and HatchID == 0)) and ((vehicle.gred_sv_simfphys_moduledamagesystem and WeaponTab.GunBreachModuleID) and GetNWInt(vehicle,"ModuleHealth_GunBreach_"..WeaponTab.GunBreachModuleID,100) > 0 or !(vehicle.gred_sv_simfphys_moduledamagesystem and WeaponTab.GunBreachModuleID)),(SeatTab.RequiresHatch and SeatTab.RequiresHatch[HatchID] or (!SeatTab.RequiresHatch and HatchID == 0))
end

gred.TankCanShootMG = function(vehicle,seat,ply,ct,SeatTab,WeaponTab,SeatID,SeatSlotTab,SlotID,HatchID)
	return ct > SeatSlotTab.NextShot and SeatSlotTab.Ammo > 0 and (SeatTab.RequiresHatch and SeatTab.RequiresHatch[HatchID] or (!SeatTab.RequiresHatch and HatchID == 0)) and !SeatSlotTab.IsReloading and ((vehicle.gred_sv_simfphys_moduledamagesystem and WeaponTab.ModuleID) and GetNWInt(vehicle,"ModuleHealth_MG_"..WeaponTab.ModuleID,100) > 0 or !(vehicle.gred_sv_simfphys_moduledamagesystem and WeaponTab.ModuleID)),(SeatSlotTab.Ammo < 1 and ct < SeatSlotTab.NextShot) or SeatSlotTab.Ammo > 0 and (SeatTab.RequiresHatch and SeatTab.RequiresHatch[HatchID] or (!SeatTab.RequiresHatch and HatchID == 0))
end

gred.TankCanShootFlamethrower = function(vehicle,seat,ply,ct,SeatTab,WeaponTab,SeatID,SeatSlotTab,SlotID,HatchID)
	return (SeatTab.RequiresHatch and SeatTab.RequiresHatch[HatchID] or (!SeatTab.RequiresHatch and HatchID == 0)),(SeatTab.RequiresHatch and SeatTab.RequiresHatch[HatchID] or (!SeatTab.RequiresHatch and HatchID == 0))
end

local pi = math.pi*20

gred.TankGetSharedRandom = function(SeatID,vehicle,CurrentMuzzle,componement,min,max)
	return util.SharedRandom(SeatID..vehicle.CachedSpawnList..componement.."_"..CurrentMuzzle,min,max,math.Round(CurTime()*pi,1))
end

gred.TankGetRandomSpreadAngle = function(SeatID,vehicle,WeaponTab,CurrentMuzzle)
	local spread = WeaponTab.Spread
	spread = Angle(gred.TankGetSharedRandom(SeatID,vehicle,CurrentMuzzle,1,spread,-spread),gred.TankGetSharedRandom(SeatID,vehicle,CurrentMuzzle,2,spread,-spread),gred.TankGetSharedRandom(SeatID,vehicle,CurrentMuzzle,3,spread,-spread))
	
	return spread
end
