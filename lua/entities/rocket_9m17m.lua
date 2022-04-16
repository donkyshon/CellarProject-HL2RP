AddCSLuaFile()

local ExploSnds = {}
ExploSnds[1]     			=	"wac/tank/tank_shell_01.wav"
ExploSnds[2]     			=	"wac/tank/tank_shell_02.wav"
ExploSnds[3]     			=	"wac/tank/tank_shell_03.wav"
ExploSnds[4]     			=	"wac/tank/tank_shell_04.wav"
ExploSnds[5]     			=	"wac/tank/tank_shell_05.wav"

ENT.Spawnable		       	=	false
ENT.AdminSpawnable		   	=	false

ENT.PrintName		      	=	"9M17M"
ENT.Author			      	=	""
ENT.Contact			      	=	""
ENT.Category              	=	"SW Bombs"
ENT.Base					=	"base_rocket"

ENT.Model                	=	"models/sw/avia/bombs/9m17m.mdl"
ENT.RocketTrail          	=	"rockettrail"
ENT.RocketBurnoutTrail   	=	"grenadetrail"
ENT.Effect                           =  "500lb_air"
ENT.EffectAir                        =  "500lb_air"
ENT.EffectWater          	=  "ins_water_explosion"
ENT.AngEffect						 =	true
ENT.StartSound             	=	"sw/bombs/rocket_start_0"..math.random(1,4)..".wav"
ENT.ArmSound               	=	""
ENT.ActivationSound        	=	"buttons/button14.wav"
ENT.EngineSound				=	"sw/bombs/rocket_idle.wav"
ENT.StartSoundFollow		=	true


ENT.ExplosionDamage			=	3600
ENT.ExplosionRadius			=	500
ENT.Mass           			=	25
ENT.EnginePower    			=	1000
ENT.TNTEquivalent			=	4.3
ENT.FuelBurnoutTime			=	5
ENT.LinearPenetration		=	650
ENT.MaxVelocity				=	1000
ENT.Caliber					=	130
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

function ENT:DoPreInit()
	self.ExplosionSound = ExploSnds[math.random(#ExploSnds)]
end

function ENT:AddOnThink()
    if self.Armed then
        if self.JDAM then   
            if IsValid(self:GetOwner()) then
                local Parent = self:GetOwner()
                local phys = self:GetPhysicsObject()
                local ID = Parent:LookupAttachment( "view" )
                local ID2 = Parent:LookupAttachment( "muzzle" )
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
                        phys:SetVelocity( self:GetVelocity() + self:GetAngles():Forward() * 450 )      
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
                        phys:SetVelocity( self:GetVelocity() + self:GetAngles():Forward() * 450 )      
                   end
              end
         end 
    end
end
function ENT:Think()
    self:AddOnThink()
end