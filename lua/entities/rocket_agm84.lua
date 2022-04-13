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

ENT.PrintName		 		=  "AGM-84"
ENT.Author			 		=  ""
ENT.Contact			 		=  ""
ENT.Category         		=  "SW Bombs"

ENT.Model              		=  "models/sw/avia/bombs/agm84.mdl"
ENT.RocketTrail        		=  "ins_rockettrail"
ENT.RocketBurnoutTrail 		=  "ins_rockettrail"
ENT.Effect                           =  "cloudmaker_ground"             
ENT.EffectAir                        =  "cloudmaker_ground"
ENT.EffectWater                      =  "water_huge"
ENT.AngEffect						 =	true
ENT.StartSound         		=  "sw/bombs/rocket_start_0"..math.random(1,4)..".wav"
ENT.ArmSound           		=  "npc/roller/mine/rmine_blip3.wav"
ENT.ActivationSound    		=  "buttons/button14.wav"
ENT.EngineSound        		=  "sw/bombs/rocket_idle.wav"

ENT.ExplosionSound        	=  table.Random(CloseExploSnds)
ENT.FarExplosionSound		=  table.Random(ExploSnds)
ENT.DistExplosionSound		=  table.Random(DistExploSnds)
ENT.WaterExplosionSound		=  table.Random(CloseWaterExploSnds)
ENT.WaterFarExplosionSound	=  table.Random(WaterExploSnds)

ENT.StartSoundFollow		=	true

ENT.ExplosionDamage                  =  22350 
ENT.ExplosionRadius                  =  2000
ENT.Mass           			=	520
ENT.EnginePower    			=	55000
ENT.TNTEquivalent			=	63.5
ENT.FuelBurnoutTime			=   60
ENT.LinearPenetration		=	10000
ENT.MaxVelocity				=	9999999
ENT.Caliber					=	250
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
	self.ExplosionSound	= CloseExploSnds[math.random(#CloseExploSnds)]
	self.FarExplosionSound	= ExploSnds[math.random(#ExploSnds)]
	self.DistExplosionSound	= DistExploSnds[math.random(#DistExploSnds)]
	self.WaterExplosionSound	= CloseWaterExploSnds[math.random(#CloseWaterExploSnds)]
	self.WaterFarExplosionSound	= WaterExploSnds[math.random(#WaterExploSnds)]
end