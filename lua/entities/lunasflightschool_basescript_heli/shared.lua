--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "basescript helicopter"
ENT.Author = "Luna"
ENT.Information = "Luna's Flight School Helicopter Basescript"
ENT.Category = "[LFS]"

ENT.Spawnable		= false
ENT.AdminSpawnable  = false

ENT.IdleRPM = 400
ENT.MaxRPM = 3000
ENT.LimitRPM = 3000

ENT.MaxThrustHeli = 10
ENT.MaxTurnPitchHeli = 60
ENT.MaxTurnYawHeli = 60
ENT.MaxTurnRollHeli = 60
ENT.ThrustEfficiencyHeli = 0.7

ENT.RotorAngle = Angle(0,0,0)
ENT.RotorRadius = 150

ENT.DontPushMePlease = true

function ENT:GetMaxTurnSpeedHeli()
	return  {p = self.MaxTurnPitchHeli, y = self.MaxTurnYawHeli, r = self.MaxTurnRollHeli }
end

function ENT:GetMaxThrustHeli()
	return self.MaxThrustHeli
end

function ENT:GetThrustEfficiency()
	self.ThrustEfficiencyHeli = self.ThrustEfficiencyHeli or 0.7
	return math.Clamp( self.ThrustEfficiencyHeli ,0.1 ,1 )
end

function ENT:GetRotorAngle()
	return self:LocalToWorldAngles( self.RotorAngle )
end

function ENT:GetRotorRadius()
	return self.RotorRadius
end

function ENT:IsHelicopter()
	return true
end
