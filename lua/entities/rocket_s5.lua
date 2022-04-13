AddCSLuaFile()

local ExploSnds = {}
ExploSnds[1]     			=	"wac/tank/tank_shell_01.wav"
ExploSnds[2]     			=	"wac/tank/tank_shell_02.wav"
ExploSnds[3]     			=	"wac/tank/tank_shell_03.wav"
ExploSnds[4]     			=	"wac/tank/tank_shell_04.wav"
ExploSnds[5]     			=	"wac/tank/tank_shell_05.wav"

ENT.Spawnable		       	=	true
ENT.AdminSpawnable		   	=	true

ENT.PrintName		      	=	"S-5"
ENT.Author			      	=	""
ENT.Contact			      	=	""
ENT.Category              	=	"SW Bombs"
ENT.Base					=	"base_rocket"

ENT.Model                	=	"models/sw/avia/bombs/s5.mdl"
ENT.RocketTrail          	=	"rockettrail"
ENT.RocketBurnoutTrail   	=	"grenadetrail"
ENT.Effect                           =  "500lb_air"
ENT.EffectAir                        =  "500lb_air"
ENT.EffectWater                      =  "ins_water_explosion"
ENT.AngEffect						 =	true
ENT.StartSound             	=	"sw/bombs/rocket_start_0"..math.random(1,4)..".wav"
ENT.ArmSound               	=	""
ENT.ActivationSound        	=	"buttons/button14.wav"
ENT.EngineSound				=	"sw/bombs/rocket_idle.mp3"
ENT.StartSoundFollow		=	true


ENT.ExplosionDamage			=	5728
ENT.ExplosionRadius			=	500
ENT.Mass           			=	6
ENT.EnginePower    			=	5000
ENT.TNTEquivalent			=	572.8
ENT.FuelBurnoutTime			=	0.35
ENT.LinearPenetration		=	150
ENT.MaxVelocity				=	9999999
ENT.Caliber					=	50
ENT.Decal					=	"scorch_big"

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