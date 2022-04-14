AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		            	 =  true         
ENT.AdminSpawnable		             =  true 

ENT.PrintName		                 =  "Type 97 Model 6"
ENT.Author			                 =  "Shermann Wolf"
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/sw/avia/bombs/type97mod6.mdl"
ENT.Effect                           =  "high_explosive_air"                  
ENT.EffectAir                        =  "high_explosive_air_2"                   
ENT.EffectWater                      =  "water_medium"
ENT.ExplosionSound                   =  "explosions/gbomb_5.mp3"   
ENT.AngEffect						 =	true

ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"
ENT.ActivationSound                  =  "buttons/button14.wav"     

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  true
ENT.UseRandomSounds                  =  true
ENT.UseRandomModels                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  1100
ENT.PhysForce                        =  110
ENT.ExplosionRadius                  =  110
ENT.SpecialRadius                    =  160
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  50
ENT.MaxDelay                         =  0                                 
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  200
ENT.Mass                             =  110
ENT.ArmDelay                         =  0.1   
ENT.Timer                            =  0

ENT.Shocktime                        = 0
ENT.GBOWNER                          =  nil             -- don't you fucking touch this.

ENT.Decal                            = "scorch_medium"


function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
	self.GBOWNER = ply
    local ent = ents.Create( self.ClassName )
	ent:SetPhysicsAttacker(ply)
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
    ent:Spawn()
    ent:Activate()
    return ent
end

AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		            	 =  true         
ENT.AdminSpawnable		             =  true 

ENT.PrintName		                 =  "Type 97 Model 6"
ENT.Author			                 =  "Shermann Wolf"
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/sw/avia/bombs/type97mod6.mdl"
ENT.Effect                           =  "high_explosive_air"                  
ENT.EffectAir                        =  "high_explosive_air_2"                   
ENT.EffectWater                      =  "water_medium"
ENT.ExplosionSound                   =  "explosions/gbomb_5.mp3"   
ENT.AngEffect						 =	true

ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"
ENT.ActivationSound                  =  "buttons/button14.wav"     

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  true
ENT.UseRandomSounds                  =  true
ENT.UseRandomModels                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  1100
ENT.PhysForce                        =  110
ENT.ExplosionRadius                  =  110
ENT.SpecialRadius                    =  160
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  50
ENT.MaxDelay                         =  0                                 
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  200
ENT.Mass                             =  110
ENT.ArmDelay                         =  0.1   
ENT.Timer                            =  0

ENT.Shocktime                        = 0
ENT.GBOWNER                          =  nil             -- don't you fucking touch this.

ENT.Decal                            = "scorch_medium"


function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
	self.GBOWNER = ply
    local ent = ents.Create( self.ClassName )
	ent:SetPhysicsAttacker(ply)
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
    ent:Spawn()
    ent:Activate()
    return ent
end
