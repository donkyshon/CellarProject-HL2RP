AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		            	 =  false        
ENT.AdminSpawnable		             =  false

ENT.PrintName		                 =  "Mk-118"
ENT.Author			                 =  ""
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/gbombs/cbomb_small.mdl"                      
ENT.Effect                           =  "high_explosive_air"                  
ENT.EffectAir                        =  "high_explosive_air_2"                   
ENT.EffectWater                      =  "water_medium"
ENT.ExplosionSound                   =  "explosions/gbomb_5.mp3"   

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  false
ENT.UseRandomSounds                  =  false
ENT.UseRandomModels                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  500
ENT.PhysForce                        =  50
ENT.ExplosionRadius                  =  50
ENT.SpecialRadius                    =  75
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  98                                 
ENT.MaxDelay                         =  2                                 
ENT.TraceLength                      =  100
ENT.ImpactSpeed                      =  1
ENT.Mass                             =  50
ENT.ArmDelay                         =  0.5
ENT.Timer                            =  0

ENT.Shocktime                        = 1
ENT.GBOWNER                          =  nil 

ENT.DEFAULT_PHYSFORCE                = 255
ENT.DEFAULT_PHYSFORCE_PLYAIR         = 20
ENT.DEFAULT_PHYSFORCE_PLYGROUND      = 1000 
ENT.Decal                            = "scorch_small"

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    self.GBOWNER = ply
    local ent = ents.Create( self.ClassName )
    ent:SetPhysicsAttacker(ply)
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
    ent:Spawn()
    ent:Activate()
	-- ent:SetCustomCollisionCheck(true)
	-- ent:TimedExplosion()
	
    return ent
end

function ENT:TimedExplosion()
	timer.Simple(5,function() 
		if IsValid(self) then 
			self:Explode() 
		end 
	end)
end
AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		            	 =  false        
ENT.AdminSpawnable		             =  false

ENT.PrintName		                 =  "Mk-118"
ENT.Author			                 =  ""
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/gbombs/cbomb_small.mdl"                      
ENT.Effect                           =  "high_explosive_air"                  
ENT.EffectAir                        =  "high_explosive_air_2"                   
ENT.EffectWater                      =  "water_medium"
ENT.ExplosionSound                   =  "explosions/gbomb_5.mp3"   

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  false
ENT.UseRandomSounds                  =  false
ENT.UseRandomModels                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  500
ENT.PhysForce                        =  50
ENT.ExplosionRadius                  =  50
ENT.SpecialRadius                    =  75
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  98                                 
ENT.MaxDelay                         =  2                                 
ENT.TraceLength                      =  100
ENT.ImpactSpeed                      =  1
ENT.Mass                             =  50
ENT.ArmDelay                         =  0.5
ENT.Timer                            =  0

ENT.Shocktime                        = 1
ENT.GBOWNER                          =  nil 

ENT.DEFAULT_PHYSFORCE                = 255
ENT.DEFAULT_PHYSFORCE_PLYAIR         = 20
ENT.DEFAULT_PHYSFORCE_PLYGROUND      = 1000 
ENT.Decal                            = "scorch_small"

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    self.GBOWNER = ply
    local ent = ents.Create( self.ClassName )
    ent:SetPhysicsAttacker(ply)
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
    ent:Spawn()
    ent:Activate()
	-- ent:SetCustomCollisionCheck(true)
	-- ent:TimedExplosion()
	
    return ent
end

function ENT:TimedExplosion()
	timer.Simple(5,function() 
		if IsValid(self) then 
			self:Explode() 
		end 
	end)
end