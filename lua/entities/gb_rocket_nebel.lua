AddCSLuaFile()

DEFINE_BASECLASS( "base_rocket" )

local ExploSnds = {}
ExploSnds[1]                         =  "explosions/doi_generic_01.wav"
ExploSnds[2]                         =  "explosions/doi_generic_02.wav"
ExploSnds[3]                         =  "explosions/doi_generic_03.wav"
ExploSnds[4]                         =  "explosions/doi_generic_04.wav"

local CloseExploSnds = {}
CloseExploSnds[1]                         =  "explosions/doi_generic_01_close.wav"
CloseExploSnds[2]                         =  "explosions/doi_generic_02_close.wav"
CloseExploSnds[3]                         =  "explosions/doi_generic_03_close.wav"
CloseExploSnds[4]                         =  "explosions/doi_generic_04_close.wav"

local DistExploSnds = {}
DistExploSnds[1]                         =  "explosions/doi_generic_01_dist.wav"
DistExploSnds[2]                         =  "explosions/doi_generic_02_dist.wav"
DistExploSnds[3]                         =  "explosions/doi_generic_03_dist.wav"
DistExploSnds[4]                         =  "explosions/doi_generic_04_dist.wav"

local WaterExploSnds = {}
WaterExploSnds[1]                         =  "explosions/doi_generic_01_water.wav"
WaterExploSnds[2]                         =  "explosions/doi_generic_02_water.wav"
WaterExploSnds[3]                         =  "explosions/doi_generic_03_water.wav"
WaterExploSnds[4]                         =  "explosions/doi_generic_04_water.wav"

local CloseWaterExploSnds = {}
CloseWaterExploSnds[1]                         =  "explosions/doi_generic_02_closewater.wav"
CloseWaterExploSnds[2]                         =  "explosions/doi_generic_02_closewater.wav"
CloseWaterExploSnds[3]                         =  "explosions/doi_generic_03_closewater.wav"
CloseWaterExploSnds[4]                         =  "explosions/doi_generic_04_closewater.wav"

ENT.Spawnable		        =  true         
ENT.AdminSpawnable		    =  true 

ENT.PrintName		        =  "[ROCKETS]Nebelwerfer Rocket"
ENT.Author			        =  ""
ENT.Contact			        =  ""
ENT.Category                =  "Gredwitch's Stuff"

ENT.Model                	=  "models/gbombs/nebelwerfer_rocket.mdl"
ENT.RocketTrail          	=  "rockettrail"
ENT.RocketBurnoutTrail   	=  "grenadetrail"
ENT.Effect               	=  "gred_highcal_rocket_explosion"
ENT.EffectAir            	=  "gred_highcal_rocket_explosion"
ENT.EffectWater          	=  "ins_water_explosion"
ENT.AngEffect			 	=   true

ENT.ExplosionSound          =  table.Random(CloseExploSnds)
ENT.FarExplosionSound		=  table.Random(ExploSnds)
ENT.DistExplosionSound		=  table.Random(DistExploSnds)
ENT.WaterExplosionSound		=  table.Random(CloseWaterExploSnds)
ENT.WaterFarExplosionSound	=  table.Random(WaterExploSnds)

ENT.RSound					=	0

ENT.StartSound              =  "Nebelwerfer_Fire"
ENT.ArmSound                =  ""
ENT.ActivationSound         =  ""
ENT.EngineSound             =  "RP3_Engine"
ENT.StartSoundFollow		=	true

ENT.ExplosionDamage			=	15000
ENT.ExplosionRadius			=	500
ENT.Mass           			=	31.8
ENT.EnginePower    			=	10875
ENT.TNTEquivalent			=	2.5
ENT.FuelBurnoutTime			=	5
ENT.LinearPenetration		=	42
ENT.MaxVelocity				=	342
ENT.Caliber					=	158
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