AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

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
ENT.AdminSpawnable		             =  false

ENT.PrintName		                 =  "BLU-77"
ENT.Author			                 =  ""
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/gbombs/cbomb_small.mdl"                      
ENT.Effect                           =  "doi_wprocket_explosion"
ENT.EffectAir                        =  "doi_wprocket_explosion"
ENT.EffectWater                      =  "doi_wprocket_explosion" 

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  true
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  true
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
ENT.Decal                            = "scorch_medium"

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

function ENT:DoPreInit()
	self.ExplosionSound = CloseExploSnds[math.random(#CloseExploSnds)]
	self.FarExplosionSound = ExploSnds[math.random(#ExploSnds)]
	self.DistExplosionSound = DistExploSnds[math.random(#DistExploSnds)]
end

function ENT:TimedExplosion()
	timer.Simple(5,function() 
		if IsValid(self) then 
			self:Explode() 
		end 
	end)
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
AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

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
ENT.AdminSpawnable		             =  false

ENT.PrintName		                 =  "BLU-77"
ENT.Author			                 =  ""
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/gbombs/cbomb_small.mdl"                      
ENT.Effect                           =  "doi_wprocket_explosion"
ENT.EffectAir                        =  "doi_wprocket_explosion"
ENT.EffectWater                      =  "doi_wprocket_explosion" 

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  true
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  true
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
ENT.Decal                            = "scorch_medium"

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

function ENT:DoPreInit()
	self.ExplosionSound = CloseExploSnds[math.random(#CloseExploSnds)]
	self.FarExplosionSound = ExploSnds[math.random(#ExploSnds)]
	self.DistExplosionSound = DistExploSnds[math.random(#DistExploSnds)]
end

function ENT:TimedExplosion()
	timer.Simple(5,function() 
		if IsValid(self) then 
			self:Explode() 
		end 
	end)
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