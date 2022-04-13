--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")
function ENT:LFSHudPaint( X, Y, data ) -- driver only
	draw.SimpleText( "FUEL", "LFS_FONT", 10, 135, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( self:GetFuel(), "LFS_FONT", 120, 135, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end
function ENT:Draw()
	local mat = Material( "sprites/light_glow02_add" )
	self:DrawModel()
	
	if self:GetEngineActive() then
		local Alpha = math.abs( math.cos( CurTime() * 4 ) ) * 70
		
		render.SetMaterial( mat )
		render.DrawSprite( self:LocalToWorld( Vector(58,-200,100) ), Alpha, Alpha, Color( 0, 255, 0, 255) )
		render.DrawSprite( self:LocalToWorld( Vector(58,200,100) ), Alpha, Alpha, Color( 255, 0, 0, 255) )
	end
	
	if not self:GetEngineActive() then return end
end
function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > 700 then return end
	if HP < 700 and HP > 550 then
		if self:WaterLevel() > 0 then return end
    	self.nextDFX = self.nextDFX or 0
	        if self.nextDFX < CurTime() then
		    self.nextDFX = CurTime() + 0.05
		    local Size = 150
	        local Pos = self:LocalToWorld( Vector(105,0,60) )
		    local effectdata = EffectData()
		    effectdata:SetOrigin( Pos )
	        util.Effect( "lfs_blacksmoke", effectdata )
		end
	elseif HP < 550 then
		if self:WaterLevel() > 0 then return end
		self.nextDFX = self.nextDFX or 0
		    if self.nextDFX < CurTime() then
		    self.nextDFX = CurTime() + 0.05
			local effectdata = EffectData()
				effectdata:SetEntity( self )
				effectdata:SetScale( 0.25 )
			util.Effect( "i153_engine_firetrail", effectdata )
		end
	end
end
function ENT:ExhaustFX()
end
function ENT:Initialize()
	self.snd = {}
end
function ENT:CalcEngineSound( RPM, Pitch, Doppler )
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
		self.RPM1 = CreateSound( self, "ENGINE_RPM1" )
		self.RPM1:PlayEx(0,0)
		
		self.RPM2 = CreateSound( self, "ENGINE_RPM2" )
		self.RPM2:PlayEx(0,0)
		
		self.RPM3 = CreateSound( self, "ENGINE_RPM3" )
		self.RPM3:PlayEx(0,0)
		
		self.RPM4 = CreateSound( self, "ENGINE_RPM4" )
		self.RPM4:PlayEx(0,0)
		
		self.DIST = CreateSound( self, "LFS_CESSNA_DIST" )
		self.DIST:PlayEx(0,0)
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
end

function ENT:AnimFins()
	local FT = FrameTime() * 10
	local Pitch = self:GetRotPitch()
	local Yaw = self:GetRotYaw()
	local Roll = -self:GetRotRoll()
	self.smPitch = self.smPitch and self.smPitch + (Pitch - self.smPitch) * FT or 0
	self.smYaw = self.smYaw and self.smYaw + (Yaw - self.smYaw) * FT or 0
	self.smRoll = self.smRoll and self.smRoll + (Roll - self.smRoll) * FT or 0

	self:ManipulateBoneAngles( 4, Angle( 0,0,-self.smRoll) )
	self:ManipulateBoneAngles( 3, Angle( 0,0,self.smRoll) )
	self:ManipulateBoneAngles( 2, Angle( 0,0,self.smPitch) )

	self:ManipulateBoneAngles( 1, Angle( 0,self.smYaw,0 ) )
end

function ENT:AnimRotor()
	local RPM = self:GetRPM()
	local PhysRot = RPM < 700
	self.RPM = self.RPM and (self.RPM + RPM * FrameTime() * (PhysRot and 3 or 1)) or 0
	
	local Rot = Angle(self.RPM,0,0)
	Rot:Normalize() 
	
	self:ManipulateBoneAngles( 11, Rot*2 )
end

function ENT:AnimLandingGear()
	self.SMLG = self.SMLG and self.SMLG + ((1 - self:GetLGear()) - self.SMLG) * FrameTime() * 3 or 0
	self.SMRG = self.SMRG and self.SMRG + ((1 - self:GetRGear()) - self.SMRG) * FrameTime() * 8 or 0
	self.SMCG = self.SMCG and self.SMCG + (1 *  self:GetRGear() - self.SMCG) * FrameTime() * 15 or 2
	
	local gExp = self.SMRG ^ 15
	local gExp2 = self.SMRG ^ 8
	local gExp3 = self.SMCG ^ 0.3
	local gExp4 = self.SMCG ^ 0.4

	self:ManipulateBoneAngles( 5, Angle( -30,0,90) * gExp3 )
	self:ManipulateBoneAngles( 8, Angle( 30,0,90) * gExp3 )
	self:ManipulateBoneAngles( 6, Angle( -90,-35,0) * gExp3 )
	self:ManipulateBoneAngles( 9, Angle( 90,35,0) * gExp3 )
	self:ManipulateBoneAngles( 7, Angle( 90,0,0) * gExp3 )
	self:ManipulateBoneAngles( 10, Angle( -90,0,0) * gExp3 )
end

