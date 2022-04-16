--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:CheckEngineState()
	local Active = self:GetRPM() > 0
	
	if Active then
		local RPM = self:GetRPM()
		local LimitRPM = self:GetLimitRPM()
		
		local tPer = RPM / LimitRPM
		
		local CurDist = (LocalPlayer():GetViewEntity():GetPos() - self:GetPos()):Length()
		self.PitchOffset = self.PitchOffset and self.PitchOffset + (math.Clamp((CurDist - self.OldDist) / FrameTime() / 125,-40,20 *  tPer) - self.PitchOffset) * FrameTime() * 5 or 0
		self.OldDist = CurDist
		
		local Pitch = (RPM - self:GetIdleRPM()) / (LimitRPM - self:GetIdleRPM())

		self:CalcEngineSound( RPM, Pitch, -self.PitchOffset )
	end

	if self.oldEnActive ~= Active then
		self.oldEnActive = Active
		self:EngineActiveChanged( Active )
	end
end