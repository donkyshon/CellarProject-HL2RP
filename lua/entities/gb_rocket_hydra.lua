AddCSLuaFile()

local ExploSnds = {}
ExploSnds[1]     			=	"wac/tank/tank_shell_01.wav"
ExploSnds[2]     			=	"wac/tank/tank_shell_02.wav"
ExploSnds[3]     			=	"wac/tank/tank_shell_03.wav"
ExploSnds[4]     			=	"wac/tank/tank_shell_04.wav"
ExploSnds[5]     			=	"wac/tank/tank_shell_05.wav"

ENT.Spawnable		       	=	true
ENT.AdminSpawnable		   	=	true

ENT.PrintName		      	=	"[ROCKETS]M247 Hydra 70"
ENT.Author			      	=	""
ENT.Contact			      	=	""
ENT.Category              	=	"Gredwitch's Stuff"
ENT.Base					=	"base_rocket"

ENT.Model                	=	"models/weltensturm/wac/rockets/rocket01.mdl"
ENT.RocketTrail          	=	"ins_rockettrail"
ENT.RocketBurnoutTrail   	=	"grenadetrail"
ENT.Effect               	=	"high_explosive_air"
ENT.EffectAir            	=	"high_explosive_air"
ENT.EffectWater          	=	"water_torpedo"

ENT.StartSound             	=	"helicoptervehicle/missileshoot.mp3"
ENT.ArmSound               	=	""
ENT.ActivationSound        	=	"buttons/button14.wav"
ENT.EngineSound				=	"Hydra_Engine"
ENT.StartSoundFollow		=	true

ENT.ExplosionDamage			=	7000
ENT.ExplosionRadius			=	200
ENT.Mass           			=	4
ENT.EnginePower    			=	2800 -- 6290
ENT.TNTEquivalent			=	0.91
ENT.FuelBurnoutTime			=	5
ENT.LinearPenetration		=	200
ENT.MaxVelocity				=	723
ENT.Caliber					=	70
ENT.ShellType				=	"HEAT"
-- ENT.RotationalForce			=	500

function ENT:SpawnFunction( ply, tr )
    if (!tr.Hit) then return end
	
    local ent = ents.Create(self.ClassName)
	ent:SetPhysicsAttacker(ply)
	ent.Owner = ply
    ent:SetPos(tr.HitPos + tr.HitNormal * 16) 
    ent:Spawn()
    ent:Activate()
	
    return ent
end

function ENT:DoPreInit()
	self.ExplosionSound = ExploSnds[math.random(#ExploSnds)]
end