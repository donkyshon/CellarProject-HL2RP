AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "force_shield_deployer"
ENT.Author = "Trench"
ENT.Purpose = "deploys forceshield from it(Shoots out of players hand)"
ENT.shieldDeployAngleYaw = nil
ENT.deployed = false

PrecacheParticleSystem( "vortigaunt_glow_beam_cp1b" )
PrecacheParticleSystem( "vortigaunt_charge_token_c" )

--Deploys shield when the shield_deployer hits something, removes itself(with some effects on top)
function ENT:PhysicsCollide( data, phys )
    --This basically makes sure that split second double collisions dont result in it spawning multiple shields
    if(self.deployed == false) then
        ParticleEffect("vortigaunt_glow_beam_cp1b", self:GetPos(), self:GetAngles())
        self:Remove()
        if SERVER then 
            local shield = ents.Create("force_shield")
            shield:SetPos(self:GetPos())
            shield:SetAngles(Angle(0,self.shieldDeployAngleYaw - 90,0))
            shield:Spawn()
        end
    end
    self.deployed = true
end

if SERVER then
    function ENT:Initialize()
        self:SetModel( "models/Items/AR2_Grenade.mdl" )
        self:PhysicsInit( SOLID_VPHYSICS )
        self.phys = self:GetPhysicsObject()
        if(self.phys:IsValid())then self.phys:Wake() end --self:PhysWake() also works
        self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        --Effects on spawn below
        self:SetMaterial("models/props_combine/portalball001_sheet")
        ParticleEffectAttach( "vortigaunt_charge_token_c", PATTACH_ABSORIGIN_FOLLOW, self, 1)
        util.SpriteTrail( self, 0, Color(170,255,127), true, 40, 10, .05, .01, "trails/laser" )
    end
end    
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "force_shield_deployer"
ENT.Author = "Trench"
ENT.Purpose = "deploys forceshield from it(Shoots out of players hand)"
ENT.shieldDeployAngleYaw = nil
ENT.deployed = false

PrecacheParticleSystem( "vortigaunt_glow_beam_cp1b" )
PrecacheParticleSystem( "vortigaunt_charge_token_c" )

--Deploys shield when the shield_deployer hits something, removes itself(with some effects on top)
function ENT:PhysicsCollide( data, phys )
    --This basically makes sure that split second double collisions dont result in it spawning multiple shields
    if(self.deployed == false) then
        ParticleEffect("vortigaunt_glow_beam_cp1b", self:GetPos(), self:GetAngles())
        self:Remove()
        if SERVER then 
            local shield = ents.Create("force_shield")
            shield:SetPos(self:GetPos())
            shield:SetAngles(Angle(0,self.shieldDeployAngleYaw - 90,0))
            shield:Spawn()
        end
    end
    self.deployed = true
end

if SERVER then
    function ENT:Initialize()
        self:SetModel( "models/Items/AR2_Grenade.mdl" )
        self:PhysicsInit( SOLID_VPHYSICS )
        self.phys = self:GetPhysicsObject()
        if(self.phys:IsValid())then self.phys:Wake() end --self:PhysWake() also works
        self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        --Effects on spawn below
        self:SetMaterial("models/props_combine/portalball001_sheet")
        ParticleEffectAttach( "vortigaunt_charge_token_c", PATTACH_ABSORIGIN_FOLLOW, self, 1)
        util.SpriteTrail( self, 0, Color(170,255,127), true, 40, 10, .05, .01, "trails/laser" )
    end
end    