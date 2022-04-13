AddCSLuaFile()

DEFINE_BASECLASS( "base_rocket" )

ENT.Spawnable		     	=  true
ENT.AdminSpawnable		 	=  true

ENT.PrintName		 		=  "AGM-158"
ENT.Author			 		=  "Shermann Wolf"
ENT.Contact			 		=  "shermannwolf@gmail.com"
ENT.Category         		=  "SW Bombs"

ENT.Model              		=  "models/sw/avia/bombs/agm158.mdl"
ENT.RocketTrail        		=  "fire_jet_01"
ENT.RocketBurnoutTrail 		=  "grenadetrail"
ENT.Effect                  =  "1000lb_explosion"                  
ENT.EffectAir               =  "1000lb_explosion"                   
ENT.EffectWater             =  "water_huge"
ENT.ArmSound                =  "npc/roller/mine/rmine_blip3.wav"            
ENT.ActivationSound         =  "buttons/button14.wav"     
ENT.StartSound         		=  "sw/bombs/rocket_start_0"..math.random(1,4)..".wav"
ENT.EngineSound        		=  "sw/bombs/rocket_idle.mp3"
ENT.ExplosionSound        	=  "sw/bombs/exp2.mp3"
ENT.StartSoundFollow		=	true

ENT.ExplosionDamage                  =  40000 
ENT.ExplosionRadius                  =  4000
ENT.SpecialRadius                    =  6000
ENT.Mass           			=	2000
ENT.EnginePower    			=	900020
ENT.TNTEquivalent			=	100
ENT.FuelBurnoutTime			=	60
ENT.LinearPenetration		=	250
ENT.MaxVelocity				=	999999
ENT.Caliber					=	127
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