--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:LFSCalcViewFirstPerson( view, ply )
	if ply == self:GetDriver() or ply == self:GetGunner() then return view end -- dont change view if the player is pilot or copilot
	
	local Pod = ply:GetVehicle()
	
	if not IsValid( Pod ) then return view end
	
	local radius = 800
	
	local TargetOrigin = self:LocalToWorld( Vector(0,0,50) ) - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
	local WallOffset = 4

	local tr = util.TraceHull( {
		start = view.origin,
		endpos = TargetOrigin,
		filter = function( e )
			local c = e:GetClass()
			local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS
			
			return collide
		end,
		mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
		maxs = Vector( WallOffset, WallOffset, WallOffset ),
	} )
	
	view.origin = tr.HitPos
	
	if tr.Hit and not tr.StartSolid then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end
	
	return view
end

function ENT:LFSCalcViewThirdPerson( view, ply )
	return self:LFSCalcViewFirstPerson( view, ply ) -- lets call the first person camera function so we dont have to do the same code twice. This will force the same view for both first and thirdperson
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	local THR = RPM / self:GetLimitRPM()
	
	if self.ENG then
		self.ENG:ChangePitch( math.Clamp(math.min(RPM / self:GetIdleRPM(),1) * 100 + Doppler + THR * 20,0,255) )
		self.ENG:ChangeVolume( math.Clamp(THR,0.8,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "rebel_heli" )
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
end

function ENT:AnimRotor()
	local RotorBlown = self:GetRotorDestroyed()
	
	if not RotorBlown then
		local RPM = self:GetRPM()
		local PhysRot = RPM < 700
		self.RPM = self.RPM and (self.RPM + RPM * FrameTime() * (PhysRot and 3 or 0.5)) or 0
		
		self:SetBodygroup( 1, PhysRot and 0 or 1 ) 
		self:SetBodygroup( 2, PhysRot and 0 or 1 ) 
		
		self:SetPoseParameter("rotor_spin", self.RPM )
		self:InvalidateBoneCache()
	end
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()
end

function ENT:ExhaustFX()
end
