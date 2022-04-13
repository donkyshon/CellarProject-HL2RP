AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		            	 =  true         
ENT.AdminSpawnable		             =  true 

ENT.PrintName		                 =  "PC-1400"
ENT.Author			                 =  "Shermann Wolf"
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/sw/avia/bombs/pc1400.mdl"                      
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

ENT.ExplosionDamage                  =  38000
ENT.PhysForce                        =  3800
ENT.ExplosionRadius                  =  3800
ENT.SpecialRadius                    =  5700
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  50
ENT.MaxDelay                         =  0                                 
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  200
ENT.Mass                             =  3800
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
                 local ID2 = Parent:LookupAttachment( "muzzle_nose" )
                 local Attachment = Parent:GetAttachment( ID )
                 local Attachment2 = Parent:GetAttachment( ID2 )
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
                     elseif Parent:GetAttachment( ID2 ) then
                         local TargetDir = Attachment2.Ang:Forward()
                         local tr = util.TraceHull( {
                             start = Attachment2.Pos,
                              endpos = (Attachment2.Pos + TargetDir  * 999999),
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
AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		            	 =  true         
ENT.AdminSpawnable		             =  true 

ENT.PrintName		                 =  "PC-1400"
ENT.Author			                 =  "Shermann Wolf"
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/sw/avia/bombs/pc1400.mdl"                      
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

ENT.ExplosionDamage                  =  38000
ENT.PhysForce                        =  3800
ENT.ExplosionRadius                  =  3800
ENT.SpecialRadius                    =  5700
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  50
ENT.MaxDelay                         =  0                                 
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  200
ENT.Mass                             =  3800
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
                 local ID2 = Parent:LookupAttachment( "muzzle_nose" )
                 local Attachment = Parent:GetAttachment( ID )
                 local Attachment2 = Parent:GetAttachment( ID2 )
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
                     elseif Parent:GetAttachment( ID2 ) then
                         local TargetDir = Attachment2.Ang:Forward()
                         local tr = util.TraceHull( {
                             start = Attachment2.Pos,
                              endpos = (Attachment2.Pos + TargetDir  * 999999),
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