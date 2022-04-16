AddCSLuaFile()

sound.Add( {
	name = "V1_Startup",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 150,
	pitch = {100},
	sound = "gunsounds/v1.wav"
} )
DEFINE_BASECLASS( "base_rocket" )

ENT.Spawnable		   		=  true
ENT.AdminSpawnable			=  true

ENT.PrintName		  		=  "[ROCKETS]V1"
ENT.Author			  		=  ""
ENT.Contact			  		=  ""
ENT.Category          		=  "Gredwitch's Stuff"

ENT.Model                  	=  "models/gredwitch/bombs/v1.mdl"
ENT.RocketTrail            	=  "fire_jet_01"
ENT.RocketBurnoutTrail     	=  ""
ENT.Effect                 	=  "500lb_ground"
ENT.EffectAir              	=  "500lb_ground"
ENT.EffectWater            	=  "water_torpedo"
ENT.ExplosionSound         	=  "explosions/gbomb_4.mp3" 
ENT.StartSound             	=  "V1_Startup"
ENT.ArmSound               	=  "npc/roller/mine/rmine_blip3.wav"
ENT.ActivationSound        	=  "buttons/button14.wav"
ENT.EngineSound            	=  ""
ENT.StartSoundFollow		=	true

ENT.ExplosionDamage			=	500000
ENT.ExplosionRadius			=	1450
ENT.Mass           			=	2150
ENT.EnginePower    			=	645000
ENT.TNTEquivalent			=	3.4
ENT.FuelBurnoutTime			=	5
ENT.LinearPenetration		=	200
ENT.MaxVelocity				=	300
ENT.Caliber					=	127
ENT.RotationalForce			=	0
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