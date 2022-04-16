AddCSLuaFile()

DEFINE_BASECLASS( "base_rocket" )

ENT.Spawnable		     	=  false
ENT.AdminSpawnable		 	=  false

ENT.PrintName		 		=  "Storm Shadow"
ENT.Author			 		=  "Shermann Wolf"
ENT.Contact			 		=  "shermannwolf@gmail.com"
ENT.Category         		=  "SW Bombs"

ENT.Model              		=  "models/sw/avia/bombs/scalp.mdl"
ENT.RocketTrail        		=  "fire_jet_01"
ENT.RocketBurnoutTrail 		=  "grenadetrail"
ENT.Effect                           =  "cloudmaker_ground"             
ENT.EffectAir                        =  "cloudmaker_ground"
ENT.EffectWater                      =  "water_huge"
ENT.ArmSound                =  "npc/roller/mine/rmine_blip3.wav"            
ENT.ActivationSound         =  "buttons/button14.wav"     
ENT.StartSound         		=  "sw/bombs/rocket_start_0"..math.random(1,4)..".wav"
ENT.EngineSound        		=  "sw/bombs/rocket_idle.mp3"
ENT.ExplosionSound        	=  "sw/bombs/exp2.mp3"
ENT.StartSoundFollow		=	true

ENT.ExplosionDamage                  =  10000
ENT.PhysForce                        =  1000
ENT.ExplosionRadius                  =  1000
ENT.SpecialRadius                    =  1500
ENT.Mass           			=	15
ENT.EnginePower    			=	1500
ENT.TNTEquivalent			=	100
ENT.FuelBurnoutTime			=	60
ENT.LinearPenetration		=	250
ENT.MaxVelocity				=	15000
ENT.Caliber					=	127
ENT.RotationalForce			=	0
ENT.Decal					=	"scorch_x10"
-- ENT.RotationalForce			=	500
function ENT:SpawnFunction( ply, tr )
    if (!tr.Hit) then return end
	
    local ent = ents.Create(self.ClassName)
	ent:SetPhysicsAttacker(ply)
	ent.GBOWNER = ply
    ent:SetPos(tr.HitPos + tr.HitNormal * 16) 
    ent:Spawn()
    ent:Activate()
	
    return ent
end
function ENT:Use(ply)
	if not gred.CVars["gred_sv_easyuse"]:GetBool() or self.Fired then return end
	self:SetBodygroup(0,1)
	self.Owner = ply
	self:EmitSound(self.ActivationSound)
	self:Launch()
end