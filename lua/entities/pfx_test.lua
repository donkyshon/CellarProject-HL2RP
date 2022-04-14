-- CAT** PlaceableFX::[Fire, Smoke, Weather, Tech, Nature, Other]
-- ENT** PFX:[*]
AddCSLuaFile()     
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "light_test"
ENT.Author			= "npc_teslacybertruck_driver"
ENT.Information		= ""
ENT.Category		= "PPE: Dev"
ENT.Spawnable		= false
ENT.AdminOnly		= false
if SERVER then
    function ENT:Initialize()
	    self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	    self:SetNoDraw(true)
	    self:DrawShadow(false)
	    self:PhysicsInit( SOLID_VPHYSICS )
	    self:SetMoveType( MOVETYPE_VPHYSICS )
	    self:SetSolid( SOLID_VPHYSICS )
        ParticleEffectAttach( "[~]light_test", 1, self, 1 )
    end
end



-- CAT** PlaceableFX::[Fire, Smoke, Weather, Tech, Nature, Other]
-- ENT** PFX:[*]
AddCSLuaFile()     
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "light_test"
ENT.Author			= "npc_teslacybertruck_driver"
ENT.Information		= ""
ENT.Category		= "PPE: Dev"
ENT.Spawnable		= false
ENT.AdminOnly		= false
if SERVER then
    function ENT:Initialize()
	    self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	    self:SetNoDraw(true)
	    self:DrawShadow(false)
	    self:PhysicsInit( SOLID_VPHYSICS )
	    self:SetMoveType( MOVETYPE_VPHYSICS )
	    self:SetSolid( SOLID_VPHYSICS )
        ParticleEffectAttach( "[~]light_test", 1, self, 1 )
    end
end


