ENT.Type 				= "anim"
ENT.Base 				= "base_entity"
ENT.PrintName 			= "ATGM"
ENT.Author 				= ""
ENT.Information 		= ""

ENT.Spawnable 			= true


AddCSLuaFile()

ENT.Model = "models/weapons/w_missile_closed.mdl"
ENT.FuseTime = 15
ENT.ArmTime = 0.15
ENT.Ticks = 0

if SERVER then

function ENT:Initialize()
    self:SetModel( self.Model )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
    self:DrawShadow( true )

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:SetBuoyancyRatio(0)
        phys:EnableGravity( false )
    end

    self.MotorSound = CreateSound( self, "weapons/rpg/rocket1.wav")
    self.MotorSound:Play()
end

function ENT:OnRemove()
    self.MotorSound:Stop()
end

end

local images_muzzle = {"effects/muzzleflash1", "effects/muzzleflash2", "effects/muzzleflash3", "effects/muzzleflash4"}

local function TableRandomChoice(tbl)
    return tbl[math.random(#tbl)]
end

function ENT:Think()
    if CLIENT then
        if self.Ticks % 10 == 0 then
            local emitter = ParticleEmitter(self:GetPos())

            if !self:IsValid() or self:WaterLevel() > 2 then return end

            local smoke = emitter:Add("particle/particle_smokegrenade", self:GetPos())
            smoke:SetVelocity( VectorRand() * 25 )
            smoke:SetGravity( Vector(math.Rand(-5,5), math.Rand(-5,5), math.Rand(-20, -25)) )
            smoke:SetDieTime( math.Rand(2.0, 2.5) )
            smoke:SetStartAlpha( 255 )
            smoke:SetEndAlpha( 0 )
            smoke:SetStartSize( 0 )
            smoke:SetEndSize( 125 )
            smoke:SetRoll( math.Rand(-180, 180) )
            smoke:SetRollDelta( math.Rand(-0.2,0.2) )
            smoke:SetColor( 20, 20, 20 )
            smoke:SetAirResistance( 5 )
            smoke:SetPos( self:GetPos() )
            smoke:SetLighting( false )
            emitter:Finish()
        end

        local emitter = ParticleEmitter(self:GetPos())

        local fire = emitter:Add(TableRandomChoice(images_muzzle), self:GetPos())
        fire:SetVelocity(self:GetAngles():Forward() * -1000)
        fire:SetDieTime(0.5)
        fire:SetStartAlpha(255)
        fire:SetEndAlpha(0)
        fire:SetStartSize(32)
        fire:SetEndSize(0)
        fire:SetRoll( math.Rand(-180, 180) )
        fire:SetColor(255, 255, 255)
        fire:SetPos(self:GetPos())

        emitter:Finish()

        self.Ticks = self.Ticks + 1
    end
end

function ENT:Detonate()
    if !self:IsValid() then return end
    local effectdata = EffectData()
        effectdata:SetOrigin( self:GetPos() )

    if self:WaterLevel() >= 1 then
        util.Effect( "WaterSurfaceExplosion", effectdata )
    else
        util.Effect( "Explosion", effectdata)
    end

    local attacker = self

    if self.Owner:IsValid() then
        attacker = self.Owner
    end

    util.BlastDamage(self, attacker, self:GetPos(), 256, 40)
    self:FireBullets({
        Attacker = attacker,
        Damage = 3000,
        Tracer = 1,
        Distance = 400,
        Dir = self:GetAngles():Forward(),
        Src = self:GetPos(),
        IgnoreEntity = self,
        Callback = function(att, tr, dmg)
            util.Decal("Scorch", tr.StartPos, tr.HitPos - (tr.HitNormal * 64), self)

            dmg:SetDamageType(DMG_BLAST)
        end
    })

    self:Remove()
end

function ENT:PhysicsCollide(colData, collider)
    self:Detonate()
end

function ENT:Draw()
    self:DrawModel()
end