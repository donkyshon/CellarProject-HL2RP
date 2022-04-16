AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		            	 =  true         
ENT.AdminSpawnable		             =  true 

ENT.PrintName		                 =  "GBU-24"
ENT.Author			                 =  "Shermann Wolf"
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/sw/avia/bombs/gbu24.mdl"                      
ENT.Effect                           =  "1000lb_explosion"                  
ENT.EffectAir                        =  "1000lb_explosion"                   
ENT.EffectWater                      =  "water_huge"
ENT.ExplosionSound                   =  "explosions/gbomb_2.mp3"
ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"            
ENT.ActivationSound                  =  "buttons/button14.wav"     

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  true
ENT.UseRandomSounds                  =  false
ENT.UseRandomModels                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  20000
ENT.PhysForce                        =  2000
ENT.ExplosionRadius                  =  2000
ENT.SpecialRadius                    =  3000
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  50
ENT.MaxDelay                         =  0                                 
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  200
ENT.Mass                             =  2000
ENT.ArmDelay                         =  0.1   
ENT.Timer                            =  0

ENT.Shocktime                        = 0
ENT.GBOWNER                          =  nil             -- don't you fucking touch this.

ENT.Decal                            = "scorch_x10"


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

function ENT:AddOnThink()
     if self.Armed then
         if self.JDAM then   
             if IsValid(self:GetOwner()) then
                 local Parent = self:GetOwner()
                 local phys = self:GetPhysicsObject()
                 local ID = Parent:LookupAttachment( "view" )
                 local Attachment = Parent:GetAttachment( ID )
                 if Parent:GetAttachment( ID ) then
                     local TargetDir = Attachment.Ang:Forward()
                     local tr = util.TraceHull( {
                         start = Attachment.Pos,
                         endpos = (Attachment.Pos + TargetDir  * 999999),
                         mins = Vector( -1, -1, -1 ),
                         maxs = Vector( 1, 1, 1 ),
                         filter = Parent
                     } )
                     self.target = tr.Entity
                     self.targetOffset = tr.Entity:WorldToLocal(tr.HitPos) 
                     phys:SetVelocity( self:GetVelocity() + self:GetAngles():Forward() * 50 )      
                 end
             end
         end 
     end
 end
 function ENT:Think()
     self:AddOnThink()
 end