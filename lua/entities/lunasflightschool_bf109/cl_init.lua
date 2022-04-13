--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetRotorPos() - self:GetForward() * 50 )
		util.Effect( "lfs_blacksmoke", effectdata )
	end
end

function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end
	
	self.nextEFX = self.nextEFX or 0
	
	local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	if self.nextEFX < CurTime() then
		self.nextEFX = CurTime() + 0.05 + (1 - THR) / 10
		
		local Pos = {
			Vector(129.28,17.85,68.91),
			Vector(122.79,17.88,69.14),
			Vector(114.7,18.9,69.11),
			Vector(107.43,19.74,68.82),
			Vector(99.56,20.28,69.05),
			Vector(91.97,20.31,68.9),
		}
		
		for _, v in pairs(Pos) do 
			if math.random(0,1) == 1 then
				local effectdata = EffectData()
					effectdata:SetOrigin( v )
					effectdata:SetAngles( Angle(-90,-20,0) )
					effectdata:SetMagnitude( math.Clamp(THR,0.2,1) ) 
					effectdata:SetEntity( self )
				util.Effect( "lfs_exhaust", effectdata )
			end
			
			if math.random(0,1) == 1 then
				local vr = v
				vr.y = -v.y
				
				local effectdata = EffectData()
					effectdata:SetOrigin( vr )
					effectdata:SetAngles( Angle(-90,20,0) )
					effectdata:SetMagnitude( math.Clamp(THR,0.2,1) ) 
					effectdata:SetEntity( self )
				util.Effect( "lfs_exhaust", effectdata )
			end
		end
	end
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	Pitch = self:HandlePropellerSND( Pitch, RPM, 0.7,0.95,0.1,0.4 )

	local Low = 500
	local Mid = 700
	local High = 950

	if self.RPM1 then
		self.RPM1:ChangePitch( math.Clamp(100 + Pitch * 300 + Doppler,0,255) )
		self.RPM1:ChangeVolume( RPM < Low and 1 or 0, 1.5 )
	end
	
	if self.RPM2 then
		self.RPM2:ChangePitch(  math.Clamp(20 + Pitch * 270 + Doppler,0,255) )
		self.RPM2:ChangeVolume( (RPM >= Low and RPM < Mid) and 1 or 0, 1.5)
	end
	
	if self.RPM3 then
		self.RPM3:ChangePitch(  math.Clamp(60 + Pitch * 110 + Doppler,0,255) )
		self.RPM3:ChangeVolume( (RPM >= Mid and RPM < High) and 1 or 0, 1.5)
	end
	
	if self.RPM4 then
		self.RPM4:ChangePitch(  math.Clamp(75 + Pitch * 50 + Doppler,0,255) )
		self.RPM4:ChangeVolume( RPM >= High and 1 or 0, 1.5) 
	end
	
	if self.DIST then
		self.DIST:ChangePitch(  math.Clamp(math.Clamp(  50 + Pitch * 60, 50,255) + Doppler,0,255) )
		self.DIST:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.RPM1 = CreateSound( self, "LFS_BF109_RPM1" )
		self.RPM1:PlayEx(0,0)
		
		self.RPM2 = CreateSound( self, "LFS_BF109_RPM2" )
		self.RPM2:PlayEx(0,0)
		
		self.RPM3 = CreateSound( self, "LFS_BF109_RPM3" )
		self.RPM3:PlayEx(0,0)
		
		self.RPM4 = CreateSound( self, "LFS_BF109_RPM4" )
		self.RPM4:PlayEx(0,0)
		
		self.DIST = CreateSound( self, "LFS_BF109_DIST" )
		self.DIST:PlayEx(0,0)

		self:AddPropellerSND()
	else
		self:SoundStop()
	end
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
	
	self:ManipulateBoneAngles( 1, Angle( self.smRoll,0,0) )
	self:ManipulateBoneAngles( 2, Angle( self.smRoll,0,0) )
	
	self:ManipulateBoneAngles( 6, Angle( 0,0,self.smPitch) )
	
	self:ManipulateBoneAngles( 7, Angle( self.smYaw,0,0 ) )
end

function ENT:AnimRotor()
	local RPM = self:GetRPM()
	local PhysRot = RPM < 700
	self.RPM = self.RPM and (self.RPM + RPM * FrameTime() * (PhysRot and 3 or 1)) or 0
	
	local Rot = Angle( self.RPM,0,0)
	Rot:Normalize() 
	self:ManipulateBoneAngles( 10, -Rot )
	
	self:SetBodygroup( 14, PhysRot and 1 or 0 ) 
end

function ENT:AnimCabin()
	local bOn = self:GetActive()
	
	local TVal = bOn and 0 or 1
	
	local Speed = FrameTime() * 4
	
	self.SMcOpen = self.SMcOpen and self.SMcOpen + math.Clamp(TVal - self.SMcOpen,-Speed,Speed) or 0
	
	self:ManipulateBoneAngles( 5 , Angle( -self.SMcOpen * 80,0,0) )
end

function ENT:AnimLandingGear()
	self.SMLG = self.SMLG and self.SMLG + (80 *  self:GetLGear() - self.SMLG) * FrameTime() * 8 or 0
	self.SMRG = self.SMRG and self.SMRG + (80 *  self:GetRGear() - self.SMRG) * FrameTime() * 8 or 0
	
	self:ManipulateBoneAngles( 8, Angle( self.SMLG,0,0 ) )
	
	self:ManipulateBoneAngles( 9, Angle( -self.SMRG,0,0 ) )
	
	self:ManipulateBoneAngles( 3, Angle( -self.SMRG / 2,0,0) )
	self:ManipulateBoneAngles( 4, Angle( self.SMRG / 2,0,0) )
end

function ENT:PlayFlybySND()
	self:EmitSound( "BF109_FLYBY" )
end

--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetRotorPos() - self:GetForward() * 50 )
		util.Effect( "lfs_blacksmoke", effectdata )
	end
end

function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end
	
	self.nextEFX = self.nextEFX or 0
	
	local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	if self.nextEFX < CurTime() then
		self.nextEFX = CurTime() + 0.05 + (1 - THR) / 10
		
		local Pos = {
			Vector(129.28,17.85,68.91),
			Vector(122.79,17.88,69.14),
			Vector(114.7,18.9,69.11),
			Vector(107.43,19.74,68.82),
			Vector(99.56,20.28,69.05),
			Vector(91.97,20.31,68.9),
		}
		
		for _, v in pairs(Pos) do 
			if math.random(0,1) == 1 then
				local effectdata = EffectData()
					effectdata:SetOrigin( v )
					effectdata:SetAngles( Angle(-90,-20,0) )
					effectdata:SetMagnitude( math.Clamp(THR,0.2,1) ) 
					effectdata:SetEntity( self )
				util.Effect( "lfs_exhaust", effectdata )
			end
			
			if math.random(0,1) == 1 then
				local vr = v
				vr.y = -v.y
				
				local effectdata = EffectData()
					effectdata:SetOrigin( vr )
					effectdata:SetAngles( Angle(-90,20,0) )
					effectdata:SetMagnitude( math.Clamp(THR,0.2,1) ) 
					effectdata:SetEntity( self )
				util.Effect( "lfs_exhaust", effectdata )
			end
		end
	end
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	Pitch = self:HandlePropellerSND( Pitch, RPM, 0.7,0.95,0.1,0.4 )

	local Low = 500
	local Mid = 700
	local High = 950

	if self.RPM1 then
		self.RPM1:ChangePitch( math.Clamp(100 + Pitch * 300 + Doppler,0,255) )
		self.RPM1:ChangeVolume( RPM < Low and 1 or 0, 1.5 )
	end
	
	if self.RPM2 then
		self.RPM2:ChangePitch(  math.Clamp(20 + Pitch * 270 + Doppler,0,255) )
		self.RPM2:ChangeVolume( (RPM >= Low and RPM < Mid) and 1 or 0, 1.5)
	end
	
	if self.RPM3 then
		self.RPM3:ChangePitch(  math.Clamp(60 + Pitch * 110 + Doppler,0,255) )
		self.RPM3:ChangeVolume( (RPM >= Mid and RPM < High) and 1 or 0, 1.5)
	end
	
	if self.RPM4 then
		self.RPM4:ChangePitch(  math.Clamp(75 + Pitch * 50 + Doppler,0,255) )
		self.RPM4:ChangeVolume( RPM >= High and 1 or 0, 1.5) 
	end
	
	if self.DIST then
		self.DIST:ChangePitch(  math.Clamp(math.Clamp(  50 + Pitch * 60, 50,255) + Doppler,0,255) )
		self.DIST:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.RPM1 = CreateSound( self, "LFS_BF109_RPM1" )
		self.RPM1:PlayEx(0,0)
		
		self.RPM2 = CreateSound( self, "LFS_BF109_RPM2" )
		self.RPM2:PlayEx(0,0)
		
		self.RPM3 = CreateSound( self, "LFS_BF109_RPM3" )
		self.RPM3:PlayEx(0,0)
		
		self.RPM4 = CreateSound( self, "LFS_BF109_RPM4" )
		self.RPM4:PlayEx(0,0)
		
		self.DIST = CreateSound( self, "LFS_BF109_DIST" )
		self.DIST:PlayEx(0,0)

		self:AddPropellerSND()
	else
		self:SoundStop()
	end
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
	
	self:ManipulateBoneAngles( 1, Angle( self.smRoll,0,0) )
	self:ManipulateBoneAngles( 2, Angle( self.smRoll,0,0) )
	
	self:ManipulateBoneAngles( 6, Angle( 0,0,self.smPitch) )
	
	self:ManipulateBoneAngles( 7, Angle( self.smYaw,0,0 ) )
end

function ENT:AnimRotor()
	local RPM = self:GetRPM()
	local PhysRot = RPM < 700
	self.RPM = self.RPM and (self.RPM + RPM * FrameTime() * (PhysRot and 3 or 1)) or 0
	
	local Rot = Angle( self.RPM,0,0)
	Rot:Normalize() 
	self:ManipulateBoneAngles( 10, -Rot )
	
	self:SetBodygroup( 14, PhysRot and 1 or 0 ) 
end

function ENT:AnimCabin()
	local bOn = self:GetActive()
	
	local TVal = bOn and 0 or 1
	
	local Speed = FrameTime() * 4
	
	self.SMcOpen = self.SMcOpen and self.SMcOpen + math.Clamp(TVal - self.SMcOpen,-Speed,Speed) or 0
	
	self:ManipulateBoneAngles( 5 , Angle( -self.SMcOpen * 80,0,0) )
end

function ENT:AnimLandingGear()
	self.SMLG = self.SMLG and self.SMLG + (80 *  self:GetLGear() - self.SMLG) * FrameTime() * 8 or 0
	self.SMRG = self.SMRG and self.SMRG + (80 *  self:GetRGear() - self.SMRG) * FrameTime() * 8 or 0
	
	self:ManipulateBoneAngles( 8, Angle( self.SMLG,0,0 ) )
	
	self:ManipulateBoneAngles( 9, Angle( -self.SMRG,0,0 ) )
	
	self:ManipulateBoneAngles( 3, Angle( -self.SMRG / 2,0,0) )
	self:ManipulateBoneAngles( 4, Angle( self.SMRG / 2,0,0) )
end

function ENT:PlayFlybySND()
	self:EmitSound( "BF109_FLYBY" )
end
