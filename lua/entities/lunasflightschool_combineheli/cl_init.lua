--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:LFSCalcViewFirstPerson( view, ply )
	return view
end

function ENT:LFSCalcViewThirdPerson( view, ply )
	return view
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	local THR = RPM / self:GetLimitRPM()
	
	if self.ENG then
		self.ENG:ChangePitch( math.Clamp( math.min(RPM / self:GetIdleRPM(),1) * 100+ Doppler + THR * 20,0,255) )
		self.ENG:ChangeVolume( math.Clamp(THR,0.8,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "NPC_AttackHelicopter.Rotors" )
		self.ENG:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
	if self.ENG then
		self.ENG:Stop()
	end
end

function ENT:AnimFins()
	self.sm_pp_rudder = self.sm_pp_rudder and (self.sm_pp_rudder + ((self:GetRotRoll() + self:GetRotYaw()) * 100 - self.sm_pp_rudder) * FrameTime() * 10) or 0
	self:SetPoseParameter("rudder", self.sm_pp_rudder)
	self:InvalidateBoneCache() 
end

function ENT:AnimRotor()
	local RotorBlown = self:GetRotorDestroyed()

	if RotorBlown ~= self.wasRotorBlown then
		self.wasRotorBlown = RotorBlown
		
		if RotorBlown then
			self:DrawShadow( false ) 
		end
	end
	
	if RotorBlown then
		local normal = -self:LocalToWorldAngles( Angle(15,0,0) ):Up()
		local position = normal:Dot( self:LocalToWorld( Vector(0,0,45) ) )
		self:SetRenderClipPlaneEnabled( true )
		self:SetRenderClipPlane( normal, position )
	end
	
	local RPM = math.min(self:GetRPM() * 5,self:GetMaxRPM())
	self.RPM = self.RPM and (self.RPM + RPM * FrameTime() * 0.5) or 0
	
	local Rot1 = Angle( -self.RPM,0,0)
	Rot1:Normalize() 
	
	local Rot2 = Angle(0,0,self.RPM)
	Rot2:Normalize() 
	
	self:ManipulateBoneAngles( 2, Rot1 )
	
	self:ManipulateBoneAngles( 5, Rot2 )
	self:ManipulateBoneAngles( 3, Rot2 )
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()
end

function ENT:ExhaustFX()
end
