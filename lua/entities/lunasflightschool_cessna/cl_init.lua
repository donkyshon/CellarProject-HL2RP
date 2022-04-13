--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end
	
	self.nextEFX = self.nextEFX or 0
	
	local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	if self.nextEFX < CurTime() then
		self.nextEFX = CurTime() + 0.05 + (1 - THR) / 10

		local effectdata = EffectData()
			effectdata:SetOrigin( Vector(65.04,-14.93,19.46) )
			effectdata:SetAngles( Angle(145,-90,0) )
			effectdata:SetMagnitude( math.Clamp(THR,0.2,1) ) 
			effectdata:SetEntity( self )
		util.Effect( "lfs_exhaust", effectdata )

	end
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )

	Pitch = self:HandlePropellerSND( Pitch, RPM )

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
		self.DIST:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0,1) )
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

		self.DIST = CreateSound( self, "LFS_CESSNA_DIST" )
		self.DIST:PlayEx(0,0)

		self:AddPropellerSND( 110 )
	else
		self:SoundStop()
	end
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
	
	self:ManipulateBoneAngles( 3, Angle( 0,self.smRoll,0) )
	self:ManipulateBoneAngles( 4, Angle( 0,-self.smRoll,0) )
	
	self:ManipulateBoneAngles( 6, Angle( 0,-self.smPitch,0) )
	
	self:ManipulateBoneAngles( 5, Angle( self.smYaw,0,0 ) )
end

function ENT:AnimRotor()
	local RPM = self:GetRPM()
	local PhysRot = RPM < 700
	self.RPM = self.RPM and (self.RPM + RPM * FrameTime() * (PhysRot and 3 or 1)) or 0
	
	local Rot = Angle(0,0,self.RPM)
	Rot:Normalize() 
	self:ManipulateBoneAngles( 7, Rot )
	
	self:SetBodygroup( 1, PhysRot and 0 or 1 ) 
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()
	self.SMLG = self.SMLG and self.SMLG + (30 *  (1 - self:GetLGear()) - self.SMLG) * FrameTime() * 8 or 0
	
	self:ManipulateBoneAngles( 1, Angle( 0,30 - self.SMLG,0) )
	self:ManipulateBoneAngles( 2, Angle( 0,30 - self.SMLG,0) )
end

--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end
	
	self.nextEFX = self.nextEFX or 0
	
	local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	if self.nextEFX < CurTime() then
		self.nextEFX = CurTime() + 0.05 + (1 - THR) / 10

		local effectdata = EffectData()
			effectdata:SetOrigin( Vector(65.04,-14.93,19.46) )
			effectdata:SetAngles( Angle(145,-90,0) )
			effectdata:SetMagnitude( math.Clamp(THR,0.2,1) ) 
			effectdata:SetEntity( self )
		util.Effect( "lfs_exhaust", effectdata )

	end
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )

	Pitch = self:HandlePropellerSND( Pitch, RPM )

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
		self.DIST:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0,1) )
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

		self.DIST = CreateSound( self, "LFS_CESSNA_DIST" )
		self.DIST:PlayEx(0,0)

		self:AddPropellerSND( 110 )
	else
		self:SoundStop()
	end
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
	
	self:ManipulateBoneAngles( 3, Angle( 0,self.smRoll,0) )
	self:ManipulateBoneAngles( 4, Angle( 0,-self.smRoll,0) )
	
	self:ManipulateBoneAngles( 6, Angle( 0,-self.smPitch,0) )
	
	self:ManipulateBoneAngles( 5, Angle( self.smYaw,0,0 ) )
end

function ENT:AnimRotor()
	local RPM = self:GetRPM()
	local PhysRot = RPM < 700
	self.RPM = self.RPM and (self.RPM + RPM * FrameTime() * (PhysRot and 3 or 1)) or 0
	
	local Rot = Angle(0,0,self.RPM)
	Rot:Normalize() 
	self:ManipulateBoneAngles( 7, Rot )
	
	self:SetBodygroup( 1, PhysRot and 0 or 1 ) 
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()
	self.SMLG = self.SMLG and self.SMLG + (30 *  (1 - self:GetLGear()) - self.SMLG) * FrameTime() * 8 or 0
	
	self:ManipulateBoneAngles( 1, Angle( 0,30 - self.SMLG,0) )
	self:ManipulateBoneAngles( 2, Angle( 0,30 - self.SMLG,0) )
end
