include("shared.lua")

local CurTime = CurTime

function ENT:Think()
	if self:GetNWBool("Fired",false) then
		self.CurAng = self:GetVelocity():Angle()
		self.CurAng.r = CurTime()*360 * self.RotationalForce
		
		self:SetAngles(self.CurAng)
	end
end