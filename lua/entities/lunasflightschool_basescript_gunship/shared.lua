ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "basescript gunship"
ENT.Author = "Luna"
ENT.Information = "Luna's Flight School Gunship Basescript"
ENT.Category = "[LFS]"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.MaxTurnPitch = 50
ENT.MaxTurnYaw = 50
ENT.MaxTurnRoll = 50

ENT.PitchDamping = 1
ENT.YawDamping = 1
ENT.RollDamping = 1

ENT.TurnForcePitch = 500
ENT.TurnForceYaw = 500
ENT.TurnForceRoll = 500

ENT.IdleRPM = 0
ENT.MaxRPM = 100
ENT.LimitRPM = 100

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 100
ENT.MaxThrustVtol = 400

function ENT:IsGunship()
	return true
end
