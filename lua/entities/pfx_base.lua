--          CAT -> PPE: [Fire, Smoke, Weather, Tech, Nature, Cosmic, Other]
--          ENT -> PFX:[~]
AddCSLuaFile()
ENT.Author       = "The man who can even beat E1M1 on Nightmare on Nokia 3310 Java port and this person really thinks that nothing is easier than to beat E1M1 on Nighmare on Nokia 3310 Java port but he just hasn't tried to run Crysis on the calculator yet."
ENT.Type         = "anim"
ENT.Base         = "base_anim"
ENT.PrintName    = "Base"
ENT.Category     = "Particle Effects"
ENT.Spawnable    = false
ENT.AdminOnly    = false
ENT.pfxname      = "[*]pfx_test"
if SERVER then
    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
        self:SetNoDraw(true) 
        self:SetSkin(1)      
		self:DrawShadow(false)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        ParticleEffectAttach(self.pfxname, 1, self, 1)
    end
end