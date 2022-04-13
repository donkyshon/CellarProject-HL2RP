AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		            	 =  true         
ENT.AdminSpawnable		             =  true 

ENT.PrintName		                 =  "[BOMBS]SC250"
ENT.Author			                 =  "Gredwitch"
ENT.Contact		                     =  "contact.gredwitch@gmail.com"
ENT.Category                         =  "Gredwitch's Stuff"

ENT.Model                            =  "models/gredwitch/bombs/sc250.mdl"
ENT.Effect                           =  "doi_stuka_explosion"                  
ENT.EffectAir                        =  "doi_stuka_explosion"
ENT.EffectWater                      =  "ins_water_explosion"
ENT.AngEffect						 =	true
ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"            
ENT.ActivationSound                  =  "buttons/button14.wav"

ENT.ExplosionSound                   =  "explosions/doi_stuka_close.wav"
ENT.FarExplosionSound				 =  "explosions/doi_stuka_far.wav"
ENT.DistExplosionSound				 =  "explosions/doi_stuka_dist.wav"

ENT.WaterExplosionSound              =  "explosions/doi_stuka_closewater.wav"
ENT.WaterFarExplosionSound			 =  "explosions/doi_stuka_farwater.wav"
ENT.RSound							 =	0

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  true
ENT.UseRandomSounds                  =  false
ENT.UseRandomModels                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  16000
ENT.PhysForce                        =  500
ENT.ExplosionRadius                  =  1500
ENT.SpecialRadius                    =  1500
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  50
ENT.MaxDelay                         =  0
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  200
ENT.Mass                             =  500
ENT.ArmDelay                         =  0.1   
ENT.Timer                            =  0
ENT.RSound							 =  0
ENT.Shocktime                        =  0
ENT.Decal							 =	"scorch_big"
ENT.GBOWNER                          =  nil             -- don't you fucking touch this.

ENT.Decal                            = "scorch_big"

function ENT:SpawnFunction( ply, tr )
     if ( !tr.Hit ) then return end
     self.GBOWNER = ply
     local ent = ents.Create( self.ClassName )
     ent:SetPhysicsAttacker(ply)
     ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
	 ent:SetAngles(Angle(0,90,0))
     ent:Spawn()
     ent:Activate()

     return ent
end