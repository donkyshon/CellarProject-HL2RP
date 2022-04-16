if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_deathanim_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

ENT.Model = ("")

function ENT:Initialize()
	if SERVER then
	self:SetHealth( 99999999999 )
	self:SetModel(self.Model)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:StartActivity(ACT_HL2MP_ZOMBIE_SLUMP_IDLE)
	end
end

function ENT:RunBehaviour()
	while ( true ) do
		self:StartActivity(ACT_HL2MP_ZOMBIE_SLUMP_IDLE)
		coroutine.wait( 99999999999 )
	end
end	

function ENT:OnInjured( dmginfo )
	return nil
end