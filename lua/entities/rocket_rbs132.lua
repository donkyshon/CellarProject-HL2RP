AddCSLuaFile()

local ExploSnds = {}
ExploSnds[1]     			=	"wac/tank/tank_shell_01.wav"
ExploSnds[2]     			=	"wac/tank/tank_shell_02.wav"
ExploSnds[3]     			=	"wac/tank/tank_shell_03.wav"
ExploSnds[4]     			=	"wac/tank/tank_shell_04.wav"
ExploSnds[5]     			=	"wac/tank/tank_shell_05.wav"

ENT.Spawnable		       	=	true
ENT.AdminSpawnable		   	=	true

ENT.PrintName		      	=	"RBS-132"
ENT.Author			      	=	""
ENT.Contact			      	=	""
ENT.Category              	=	"SW Bombs"
ENT.Base					=	"base_rocket"

ENT.Model                	=	"models/sw/avia/bombs/rbs132.mdl"
ENT.RocketTrail          	=	"ins_rockettrail"
ENT.RocketBurnoutTrail   	=	"grenadetrail"
ENT.Effect                           =  "doi_artillery_explosion"
ENT.EffectAir                        =  "doi_artillery_explosion"
ENT.EffectWater                      =  "ins_water_explosion"
ENT.AngEffect						 =	true
ENT.StartSound             	=	"sw/bombs/rocket_start_0"..math.random(1,4)..".wav"
ENT.ArmSound               	=	""
ENT.ActivationSound        	=	"buttons/button14.wav"
ENT.EngineSound				=	"sw/bombs/rocket_idle.mp3"
ENT.StartSoundFollow		=	true


ENT.ExplosionDamage			=	6500
ENT.ExplosionRadius			=	100
ENT.Mass           			=	14
ENT.EnginePower    			=	25000
ENT.TNTEquivalent			=	0.65
ENT.FuelBurnoutTime			=	50
ENT.LinearPenetration		=	750
ENT.MaxVelocity				=	9999999
ENT.Caliber					=	132
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