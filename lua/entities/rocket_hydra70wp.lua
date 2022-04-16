AddCSLuaFile()

DEFINE_BASECLASS( "base_rocket" )

local ExploSnds = {}
ExploSnds[1]						 =  "sw/bombs/detonate_wp_dist_01.wav"
ExploSnds[2]						 =  "sw/bombs/detonate_wp_dist_02.wav"
ExploSnds[3]						 =  "sw/bombs/detonate_wp_dist_03.wav"
                                     
local CloseExploSnds = {}            
CloseExploSnds[1]					 =  "sw/bombs/detonate_wp_01.wav"
CloseExploSnds[2]					 =  "sw/bombs/detonate_wp_02.wav"
CloseExploSnds[3]					 =  "sw/bombs/detonate_wp_03.wav"
                                     
local DistExploSnds = {}             
DistExploSnds[1]					 =  "sw/bombs/detonate_wp_far_dist_01.wav"
DistExploSnds[2]					 =  "sw/bombs/detonate_wp_far_dist_02.wav"
DistExploSnds[3]					 =  "sw/bombs/detonate_wp_far_dist_03.wav"

ENT.Spawnable		            	 =  false
ENT.AdminSpawnable		             =  true 

AddCSLuaFile()

ENT.Spawnable		       	=	true
ENT.AdminSpawnable		   	=	true

ENT.PrintName		      	=	"Hydra 70 (WP)"
ENT.Author			      	=	""
ENT.Contact			      	=	""
ENT.Category              	=	"SW Bombs"
ENT.Base					=	"base_rocket"

ENT.Model                  		     =  "models/sw/avia/bombs/hydra70.mdl"
ENT.RocketTrail          	=	"ins_rockettrail"
ENT.RocketBurnoutTrail   	=	"grenadetrail"
ENT.RocketTrail                      =  "ins_rockettrail"
ENT.RocketBurnoutTrail               =  "grenadetrail"
ENT.Effect                           =  "doi_wprocket_explosion"
ENT.EffectAir                        =  "doi_wprocket_explosion"
ENT.EffectWater                      =  "doi_wprocket_explosion" 

ENT.StartSound             	=	"helicoptervehicle/missileshoot.mp3"
ENT.ArmSound               	=	""
ENT.ActivationSound        	=	"buttons/button14.wav"
ENT.EngineSound				=	"Hydra_Engine"
ENT.StartSoundFollow		=	true
ENT.AngEffect		=	true

ENT.ExplosionDamage			=	100
ENT.ExplosionRadius			=	200
ENT.Mass           			=	4
ENT.EnginePower    			=	2800
ENT.FuelBurnoutTime			=	5
ENT.LinearPenetration		=	10
ENT.MaxVelocity				=	9999999
ENT.Caliber					=	70
ENT.ShellType				=	"WP"
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
	self.ExplosionSound = CloseExploSnds[math.random(#CloseExploSnds)]
	self.FarExplosionSound = ExploSnds[math.random(#ExploSnds)]
	self.DistExplosionSound = DistExploSnds[math.random(#DistExploSnds)]
end

function ENT:AddOnExplode()
	local ent = ents.Create("base_napalm")
	local pos = self:GetPos()
	ent:SetPos(pos)
	ent.Radius	 = 450
	ent.Rate  	 = 1
	ent.Lifetime = 17
	ent:Spawn()
	ent:Activate()
	ent:SetVar("GBOWNER",self.GBOWNER)
end