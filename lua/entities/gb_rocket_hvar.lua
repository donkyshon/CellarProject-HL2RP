AddCSLuaFile()

DEFINE_BASECLASS( "base_rocket" )

local ExploSnds = {}
ExploSnds[1]                         =  "explosions/doi_panzerschreck_01.wav"
ExploSnds[2]                         =  "explosions/doi_panzerschreck_02.wav"
ExploSnds[3]                         =  "explosions/doi_panzerschreck_03.wav"

local CloseExploSnds = {}
CloseExploSnds[1]                         =  "explosions/doi_panzerschreck_01_close.wav"
CloseExploSnds[2]                         =  "explosions/doi_panzerschreck_02_close.wav"
CloseExploSnds[3]                         =  "explosions/doi_panzerschreck_03_close.wav"

local DistExploSnds = {}
DistExploSnds[1]                         =  "explosions/doi_panzerschreck_01_dist.wav"
DistExploSnds[2]                         =  "explosions/doi_panzerschreck_02_dist.wav"
DistExploSnds[3]                         =  "explosions/doi_panzerschreck_03_dist.wav"

local WaterExploSnds = {}
WaterExploSnds[1]                         =  "explosions/doi_panzerschreck_01_water.wav"
WaterExploSnds[2]                         =  "explosions/doi_panzerschreck_02_water.wav"
WaterExploSnds[3]                         =  "explosions/doi_panzerschreck_03_water.wav"

local CloseWaterExploSnds = {}
CloseWaterExploSnds[1]                         =  "explosions/doi_panzerschreck_01_closewater.wav"
CloseWaterExploSnds[2]                         =  "explosions/doi_panzerschreck_02_closewater.wav"
CloseWaterExploSnds[3]                         =  "explosions/doi_panzerschreck_03_closewater.wav"

ENT.Spawnable		     	=  true
ENT.AdminSpawnable		 	=  true

ENT.PrintName		 		=  "[ROCKETS]HVAR"
ENT.Author			 		=  ""
ENT.Contact			 		=  ""
ENT.Category         		=  "Gredwitch's Stuff"

ENT.Model              		=  "models/gredwitch/bombs/hvar.mdl"
ENT.RocketTrail        		=  "ins_rockettrail"
ENT.RocketBurnoutTrail 		=  "grenadetrail"
ENT.Effect             		=  "500lb_air"
ENT.EffectAir          		=  "500lb_air"
ENT.EffectWater        		=  "ins_water_explosion"  
ENT.StartSound         		=  "gunsounds/rocket2.wav"
ENT.ArmSound           		=  "npc/roller/mine/rmine_blip3.wav"
ENT.ActivationSound    		=  "buttons/button14.wav"
ENT.EngineSound        		=  "RP3_Engine"

ENT.ExplosionSound        	=  table.Random(CloseExploSnds)
ENT.FarExplosionSound		=  table.Random(ExploSnds)
ENT.DistExplosionSound		=  table.Random(DistExploSnds)
ENT.WaterExplosionSound		=  table.Random(CloseWaterExploSnds)
ENT.WaterFarExplosionSound	=  table.Random(WaterExploSnds)

ENT.StartSoundFollow		=	true

ENT.ExplosionDamage			=	12700
ENT.ExplosionRadius			=	500
ENT.Mass           			=	64
ENT.EnginePower    			=	30720
ENT.TNTEquivalent			=	3.4
ENT.FuelBurnoutTime			=	5
ENT.LinearPenetration		=	75
ENT.MaxVelocity				=	420
ENT.Caliber					=	127
ENT.Decal					=	"scorch_big"
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
	self.ExplosionSound	= CloseExploSnds[math.random(#CloseExploSnds)]
	self.FarExplosionSound	= ExploSnds[math.random(#ExploSnds)]
	self.DistExplosionSound	= DistExploSnds[math.random(#DistExploSnds)]
	self.WaterExplosionSound	= CloseWaterExploSnds[math.random(#CloseWaterExploSnds)]
	self.WaterFarExplosionSound	= WaterExploSnds[math.random(#WaterExploSnds)]
end