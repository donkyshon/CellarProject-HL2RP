--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:ExhaustFX()
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	Pitch = self:HandlePropellerSND( Pitch, RPM, 0.7,0.95,0.05,0.2 )

	local Low = 500
	local Mid = 700
	local High = 950
	
	if self.RPM1 then
		self.RPM1:ChangePitch( math.Clamp(100 + Pitch * 300 + Doppler,0,255) * 0.8 )
		self.RPM1:ChangeVolume( RPM < Low and 1 or 0, 1.5 )
	end
	
	if self.RPM2 then
		self.RPM2:ChangePitch(  math.Clamp(50 + Pitch * 320 + Doppler,0,255) * 0.8 )
		self.RPM2:ChangeVolume( (RPM >= Low and RPM < Mid) and 1 or 0, 1.5 )
	end
	
	if self.RPM3 then
		self.RPM3:ChangePitch(  math.Clamp(75 + Pitch * 110 + Doppler,0,255) * 0.8 )
		self.RPM3:ChangeVolume( (RPM >= Mid and RPM < High) and 1 or 0, 1.5 )
	end
	
	if self.RPM4 then
		self.RPM4:ChangePitch(  math.Clamp(90 + Pitch * 50 + Doppler,0,255) * 0.8 )
		self.RPM4:ChangeVolume( RPM >= High and 1 or 0, 1.5 )
	end
	
	if self.DIST then
		self.DIST:ChangePitch(  math.Clamp(math.Clamp( 50 + Pitch * 60, 50,255) + Doppler,0,255) )
		self.DIST:ChangeVolume( math.Clamp( -1 + Pitch * 8, 0,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.RPM1 = CreateSound( self, "LFS_CESSNA_RPM1" )
		self.RPM1:PlayEx(0,0)
		
		self.RPM2 = CreateSound( self, "LFS_CESSNA_RPM2" )
		self.RPM2:PlayEx(0,0)
		
		self.RPM3 = CreateSound( self, "LFS_CESSNA_RPM3" )
		self.RPM3:PlayEx(0,0)
		
		self.RPM4 = CreateSound( self, "LFS_CESSNA_RPM4" )
		self.RPM4:PlayEx(0,0)
		
		self.DIST = CreateSound( self, "LFS_SPITFIRE_DIST" )
		self.DIST:PlayEx(0,0)

		self:AddPropellerSND( 80 )
	else
		self:SoundStop()
	end
end

function ENT:PlayFlybySND()
	self:EmitSound( "SPITFIRE_FLYBY" )
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
	if self.RPM1 then
		self.RPM1:Stop()
	end
	if self.RPM2 then
		self.RPM2:Stop()
	end
	if self.RPM3 then
		self.RPM3:Stop()
	end
	if self.RPM4 then
		self.RPM4:Stop()
	end
	if self.DIST then
		self.DIST:Stop()
	end
	self:RemovePropellerSND()
end

function ENT:AnimFins()
	local FT = FrameTime() * 10
	local Pitch = self:GetRotPitch()
	local Yaw = self:GetRotYaw()
	local Roll = -self:GetRotRoll()
	self.smPitch = self.smPitch and self.smPitch + (Pitch - self.smPitch) * FT or 0
	self.smYaw = self.smYaw and self.smYaw + (Yaw - self.smYaw) * FT or 0
	self.smRoll = self.smRoll and self.smRoll + (Roll - self.smRoll) * FT or 0
	
	self:ManipulateBoneAngles( 10, Angle( self.smRoll,0,0) )
	self:ManipulateBoneAngles( 11, Angle( self.smRoll,0,0) )
	
	self:ManipulateBoneAngles( 12, Angle( 0,0,self.smPitch) )
	
	self:ManipulateBoneAngles( 38, Angle( self.smYaw,0,0 ) )
end

function ENT:AnimRotor()
	local RPM = self:GetRPM()
	local PhysRot = RPM < 700
	self.RPM = self.RPM and (self.RPM + RPM * FrameTime() * (PhysRot and 3 or 1)) or 0
	
	local Rot = Angle(self.RPM,0,0)
	Rot:Normalize() 
	
	self:ManipulateBoneAngles( 39, Rot )
	
	self:SetBodygroup( 12, PhysRot and 1 or 0 ) 
end

function ENT:AnimCabin()
	local bOn = self:GetActive()
	
	local TVal = bOn and 0 or 1
	
	local Speed = FrameTime() * 4
	
	self.SMcOpen = self.SMcOpen and self.SMcOpen + math.Clamp(TVal - self.SMcOpen,-Speed,Speed) or 0
	
	self:ManipulateBonePosition( 40, Vector( 0,0,-self.SMcOpen * 32) ) 
end

function ENT:AnimLandingGear()
	self.SMLG = self.SMLG and self.SMLG + ((1 - self:GetLGear()) - self.SMLG) * FrameTime() * 8 or 0
	self.SMRG = self.SMRG and self.SMRG + ((1 - self:GetRGear()) - self.SMRG) * FrameTime() * 8 or 0
	
	local gExp = self.SMRG ^ 15
	
	self:ManipulateBoneAngles( 13, Angle( -30 + 30 * self.SMRG,0,0) )
	self:ManipulateBoneAngles( 14, Angle( 30 - 30 * self.SMRG,0,0) )
	
	self:ManipulateBoneAngles( 42, Angle( 3.5,88,24.5) * self.SMRG )
	self:ManipulateBoneAngles( 45, Angle( 0,-90,2.8) * gExp )
	
	self:ManipulateBoneAngles( 43, Angle( -3.5,-88,24.5) * self.SMLG )
	self:ManipulateBoneAngles( 44, Angle( 0,90,2.8) * (self.SMLG ^ 15) )
	
	self:ManipulateBoneAngles( 47, Angle( -5.5,90,-16) * gExp )
	self:ManipulateBoneAngles( 48, Angle( 5,-90,-16) * gExp )
	
	self:ManipulateBoneAngles( 46, Angle( 0,0,160) * self.SMRG )
end

