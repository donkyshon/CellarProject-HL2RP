AddCSLuaFile()

local ExploSnds = {}
ExploSnds[1]     			=	"wac/tank/tank_shell_01.wav"
ExploSnds[2]     			=	"wac/tank/tank_shell_02.wav"
ExploSnds[3]     			=	"wac/tank/tank_shell_03.wav"
ExploSnds[4]     			=	"wac/tank/tank_shell_04.wav"
ExploSnds[5]     			=	"wac/tank/tank_shell_05.wav"

ENT.Spawnable		       	=	true
ENT.AdminSpawnable		   	=	true

ENT.PrintName		      	=	"Vyihr"
ENT.Author			      	=	""
ENT.Contact			      	=	""
ENT.Category              	=	"SW Bombs"
ENT.Base					=	"base_rocket"

ENT.Model                	=	"models/sw/avia/bombs/vyihr.mdl"
ENT.RocketTrail          	=	"rockettrail"
ENT.RocketBurnoutTrail   	=	"grenadetrail"
ENT.Effect               	=  "500lb_air"
ENT.EffectAir            	=  "500lb_air"
ENT.EffectWater          	=  "ins_water_explosion"
ENT.AngEffect						 =	true
ENT.StartSound             	=	"sw/bombs/rocket_start_0"..math.random(1,4)..".wav"
ENT.ArmSound               	=	""
ENT.ActivationSound        	=	"buttons/button14.wav"
ENT.EngineSound				=	"sw/bombs/rocket_idle.mp3"
ENT.StartSoundFollow		=	true


ENT.ExplosionDamage			=	4300
ENT.ExplosionRadius			=	100
ENT.Mass           			=	15
ENT.EnginePower    			=	5000
ENT.TNTEquivalent			=	3.4
ENT.FuelBurnoutTime			=	1.5
ENT.LinearPenetration		=	800
ENT.MaxVelocity				=	15000
ENT.Caliber					=	140
ENT.Decal					=	"scorch_big"
ENT.RotationalForce			=	555500

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