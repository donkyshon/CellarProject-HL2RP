AddCSLuaFile()

local ExploSnds = {}
ExploSnds[1]     			=	"wac/tank/tank_shell_01.wav"
ExploSnds[2]     			=	"wac/tank/tank_shell_02.wav"
ExploSnds[3]     			=	"wac/tank/tank_shell_03.wav"
ExploSnds[4]     			=	"wac/tank/tank_shell_04.wav"
ExploSnds[5]     			=	"wac/tank/tank_shell_05.wav"

ENT.Spawnable		       	=	false
ENT.AdminSpawnable		   	=	false

ENT.PrintName		      	=	"9M123"
ENT.Author			      	=	""
ENT.Contact			      	=	""
ENT.Category              	=	"SW Bombs"
ENT.Base					=	"base_rocket"

ENT.Model                	=	"models/sw/avia/bombs/9m123.mdl"
ENT.RocketTrail          	=	"rockettrail"
ENT.RocketBurnoutTrail   	=	"grenadetrail"
ENT.Effect                           =  "500lb_air"
ENT.EffectAir                        =  "500lb_air"
ENT.EffectWater          	=  "ins_water_explosion"
ENT.AngEffect						 =	true
ENT.StartSound             	=	"sw/bombs/rocket_start_0"..math.random(1,4)..".wav"
ENT.ArmSound               	=	""
ENT.ActivationSound        	=	"buttons/button14.wav"
ENT.EngineSound				=	"sw/bombs/rocket_idle.mp3"
ENT.StartSoundFollow		=	true


ENT.ExplosionDamage			=	9300
ENT.ExplosionRadius			=	100
ENT.Mass           			=	15
ENT.EnginePower    			=	5000
ENT.TNTEquivalent			=	8
ENT.FuelBurnoutTime			=	1.5
ENT.LinearPenetration		=	1200
ENT.MaxVelocity				=	15000
ENT.Caliber					=	152
ENT.Decal					=	"scorch_big"
ENT.RotationalForce			=	55500

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
                        phys:SetVelocity( self:GetVelocity() + self:GetAngles():Forward() * 450 )      
                   end
              end
         end 
    end
end
function ENT:Think()
    self:AddOnThink()
end
AddCSLuaFile()

local ExploSnds = {}
ExploSnds[1]     			=	"wac/tank/tank_shell_01.wav"
ExploSnds[2]     			=	"wac/tank/tank_shell_02.wav"
ExploSnds[3]     			=	"wac/tank/tank_shell_03.wav"
ExploSnds[4]     			=	"wac/tank/tank_shell_04.wav"
ExploSnds[5]     			=	"wac/tank/tank_shell_05.wav"

ENT.Spawnable		       	=	false
ENT.AdminSpawnable		   	=	false

ENT.PrintName		      	=	"9M123"
ENT.Author			      	=	""
ENT.Contact			      	=	""
ENT.Category              	=	"SW Bombs"
ENT.Base					=	"base_rocket"

ENT.Model                	=	"models/sw/avia/bombs/9m123.mdl"
ENT.RocketTrail          	=	"rockettrail"
ENT.RocketBurnoutTrail   	=	"grenadetrail"
ENT.Effect                           =  "500lb_air"
ENT.EffectAir                        =  "500lb_air"
ENT.EffectWater          	=  "ins_water_explosion"
ENT.AngEffect						 =	true
ENT.StartSound             	=	"sw/bombs/rocket_start_0"..math.random(1,4)..".wav"
ENT.ArmSound               	=	""
ENT.ActivationSound        	=	"buttons/button14.wav"
ENT.EngineSound				=	"sw/bombs/rocket_idle.mp3"
ENT.StartSoundFollow		=	true


ENT.ExplosionDamage			=	9300
ENT.ExplosionRadius			=	100
ENT.Mass           			=	15
ENT.EnginePower    			=	5000
ENT.TNTEquivalent			=	8
ENT.FuelBurnoutTime			=	1.5
ENT.LinearPenetration		=	1200
ENT.MaxVelocity				=	15000
ENT.Caliber					=	152
ENT.Decal					=	"scorch_big"
ENT.RotationalForce			=	55500

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
                        phys:SetVelocity( self:GetVelocity() + self:GetAngles():Forward() * 450 )      
                   end
              end
         end 
    end
end
function ENT:Think()
    self:AddOnThink()
end