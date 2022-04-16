AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

local ExploSnds = {}
ExploSnds[1]                         =  "explosions/gbombs_napalm_1.mp3"
ExploSnds[2]                         =  "explosions/gbombs_napalm_2.mp3"
ExploSnds[3]                         =  "explosions/gbombs_napalm_3.mp3"
ExploSnds[4]                         =  "explosions/gbombs_napalm_4.mp3"


ENT.Spawnable		            	 =  true         
ENT.AdminSpawnable		             =  true 

ENT.PrintName		                 =  "[BOMBS]Mark 77 Napalm"
ENT.Author			                 =  "Gredwitch"
ENT.Contact		                     =  "contact.gredwitch@gmail.com"
ENT.Category                         =  "Gredwitch's Stuff"

ENT.Model                            =  "models/gbombs/napalm.mdl"                      
ENT.Effect                           =  "napalm_explosion"                  
ENT.EffectAir                        =  "napalm_explosion_midair"                   
ENT.EffectWater                      =  "water_medium"
ENT.ExplosionSound                   =  "explosions/gbombs_napalm_1.mp3"
ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"            
ENT.ActivationSound                  =  "buttons/button14.wav"     

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  false
ENT.UseRandomSounds                  =  true
ENT.UseRandomModels                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  750
ENT.PhysForce                        =  750
ENT.ExplosionRadius                  =  950
ENT.SpecialRadius                    =  950
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  20                                  
ENT.MaxDelay                         =  2                                 
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  350
ENT.Mass                             =  340
ENT.ArmDelay                         =  0
ENT.Timer                            =  0

ENT.Decal							 =	"scorch_huge"
ENT.GBOWNER                          =  nil             -- don't you fucking touch this.


function ENT:SpawnFunction( ply, tr )
     if ( !tr.Hit ) then return end
     self.GBOWNER = ply
     local ent = ents.Create( self.ClassName )
     ent:SetPhysicsAttacker(ply)
     ent:SetPos( tr.HitPos + tr.HitNormal * 26 )
     ent:Spawn()
     ent:Activate()

     return ent
end

function ENT:AddOnExplode()
	local ent = ents.Create("base_napalm")
	local pos = self:GetPos()
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()
	ent:SetVar("GBOWNER",self.GBOWNER)
end