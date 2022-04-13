--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
end

function ENT:Initialize()
end

function ENT:LFSCalcViewFirstPerson( view, ply )
	return view
end

function ENT:LFSCalcViewThirdPerson( view, ply )
	return view
end

function ENT:LFSHudPaintPlaneIdentifier( X, Y, In_Col, target_ent )
	simfphys.LFS.HudPaintPlaneIdentifier( X, Y, In_Col, target_ent )
end

function ENT:LFSHudPaintInfoText( X, Y, speed, alt, AmmoPrimary, AmmoSecondary, Throttle )
	local Col = Throttle <= 100 and Color(255,255,255,255) or Color(255,0,0,255)

	draw.SimpleText( "THR", "LFS_FONT", 10, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( Throttle.."%" , "LFS_FONT", 120, 10, Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	draw.SimpleText( "IAS", "LFS_FONT", 10, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( speed.."km/h", "LFS_FONT", 120, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	draw.SimpleText( "ALT", "LFS_FONT", 10, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( alt.."m" , "LFS_FONT", 120, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	if self:GetMaxAmmoPrimary() > -1 then
		draw.SimpleText( "PRI", "LFS_FONT", 10, 85, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( AmmoPrimary, "LFS_FONT", 120, 85, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end

	if self:GetMaxAmmoSecondary() > -1 then
		draw.SimpleText( "SEC", "LFS_FONT", 10, 110, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( AmmoSecondary, "LFS_FONT", 120, 110, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end
end

function ENT:LFSHudPaintInfoLine( HitPlane, HitPilot, LFS_TIME_NOTIFY, Dir, Len, FREELOOK )
	surface.SetDrawColor( 255, 255, 255, 100 )
	if Len > 34 then
		local FailStart = LFS_TIME_NOTIFY > CurTime()
		if FailStart then
			surface.SetDrawColor( 255, 0, 0, math.abs( math.cos( CurTime() * 10 ) ) * 255 )
		end
		
		if not FREELOOK or FailStart then
			surface.DrawLine( HitPlane.x + Dir.x * 10, HitPlane.y + Dir.y * 10, HitPilot.x - Dir.x * 34, HitPilot.y- Dir.y * 34 )
			
			-- shadow
			surface.SetDrawColor( 0, 0, 0, 50 )
			surface.DrawLine( HitPlane.x + Dir.x * 10 + 1, HitPlane.y + Dir.y * 10 + 1, HitPilot.x - Dir.x * 34+ 1, HitPilot.y- Dir.y * 34 + 1 )
		end
	end
end

function ENT:LFSHudPaintCrosshair( HitPlane, HitPilot )
	surface.SetDrawColor( 255, 255, 255, 255 )
	simfphys.LFS.DrawCircle( HitPlane.x, HitPlane.y, 10 )
	surface.DrawLine( HitPlane.x + 10, HitPlane.y, HitPlane.x + 20, HitPlane.y ) 
	surface.DrawLine( HitPlane.x - 10, HitPlane.y, HitPlane.x - 20, HitPlane.y ) 
	surface.DrawLine( HitPlane.x, HitPlane.y + 10, HitPlane.x, HitPlane.y + 20 ) 
	surface.DrawLine( HitPlane.x, HitPlane.y - 10, HitPlane.x, HitPlane.y - 20 ) 
	simfphys.LFS.DrawCircle( HitPilot.x, HitPilot.y, 34 )
	
	-- shadow
	surface.SetDrawColor( 0, 0, 0, 80 )
	simfphys.LFS.DrawCircle( HitPlane.x + 1, HitPlane.y + 1, 10 )
	surface.DrawLine( HitPlane.x + 11, HitPlane.y + 1, HitPlane.x + 21, HitPlane.y + 1 ) 
	surface.DrawLine( HitPlane.x - 9, HitPlane.y + 1, HitPlane.x - 16, HitPlane.y + 1 ) 
	surface.DrawLine( HitPlane.x + 1, HitPlane.y + 11, HitPlane.x + 1, HitPlane.y + 21 ) 
	surface.DrawLine( HitPlane.x + 1, HitPlane.y - 19, HitPlane.x + 1, HitPlane.y - 16 ) 
	simfphys.LFS.DrawCircle( HitPilot.x + 1, HitPilot.y + 1, 34 )

	self:LFSPaintHitMarker( HitPlane )
end

function ENT:LFSPaintHitMarker( scr )
	local aV = math.sin( math.rad( math.sin( math.rad( math.max(((self:GetHitMarker() - CurTime()) / 0.15) * 90,0) ) ) * 90 ) )
	if aV > 0.01 then
		local Start = 15 + (1 - aV ^ 2) * 40
		local dst = 10

		surface.SetDrawColor( 255, 255, 0, 255 )
		surface.DrawLine( scr.x + Start, scr.y + Start, scr.x + Start, scr.y + Start - dst )
		surface.DrawLine( scr.x + Start, scr.y + Start, scr.x + Start - dst, scr.y + Start )

		surface.DrawLine( scr.x + Start, scr.y - Start, scr.x + Start, scr.y - Start + dst )
		surface.DrawLine( scr.x + Start, scr.y - Start, scr.x + Start - dst, scr.y - Start )

		surface.DrawLine( scr.x - Start, scr.y + Start, scr.x - Start, scr.y + Start - dst )
		surface.DrawLine( scr.x - Start, scr.y + Start, scr.x - Start + dst, scr.y + Start )

		surface.DrawLine( scr.x - Start, scr.y - Start, scr.x - Start, scr.y - Start + dst )
		surface.DrawLine( scr.x - Start, scr.y - Start, scr.x - Start + dst, scr.y - Start )
	end

	local aV = math.sin( math.rad( math.sin( math.rad( math.max(((self:GetKillMarker() - CurTime()) / 0.2) * 90,0) ) ) * 90 ) )
	if aV > 0.01 then
		surface.SetDrawColor( 255, 255, 255, 15 * (aV ^ 4) )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )

		local Start = 10 + aV * 40
		local End = 20 + aV * 45
		surface.SetDrawColor( 255, 0, 0, 255 )
		surface.DrawLine( scr.x + Start, scr.y + Start, scr.x + End, scr.y + End )
		surface.DrawLine( scr.x - Start, scr.y + Start, scr.x - End, scr.y + End ) 
		surface.DrawLine( scr.x + Start, scr.y - Start, scr.x + End, scr.y - End )
		surface.DrawLine( scr.x - Start, scr.y - Start, scr.x - End, scr.y - End ) 

		draw.NoTexture()
		surface.DrawTexturedRectRotated( scr.x + Start, scr.y + Start, 5, 20, 45 )
		surface.DrawTexturedRectRotated( scr.x - Start, scr.y + Start, 20, 5, 45 )
		surface.DrawTexturedRectRotated(  scr.x + Start, scr.y - Start, 20, 5, 45 )
		surface.DrawTexturedRectRotated( scr.x - Start, scr.y - Start, 5, 20, 45 )
	end
end

function ENT:HitMarker( LastHitMarker )
	self.LastHitMarker = LastHitMarker

	local ply = LocalPlayer()
	ply:EmitSound( table.Random( {"physics/metal/metal_sheet_impact_bullet2.wav","physics/metal/metal_sheet_impact_hard2.wav","physics/metal/metal_sheet_impact_hard6.wav",} ), 140, 140, 0.3, CHAN_ITEM2 )
end

function ENT:GetHitMarker()
	return self.LastHitMarker or 0
end

function ENT:KillMarker( LastKillMarker )
	self.LastKillMarker = LastKillMarker

	local ply = LocalPlayer()

	util.ScreenShake( ply:GetPos(), 4, 2, 2, 50000 )

	ply:EmitSound( table.Random( {"lfs/plane_preexp1.ogg","lfs/plane_preexp3.ogg"} ), 140, 100, 0.5, CHAN_WEAPON )

	ply:EmitSound( "physics/metal/metal_solid_impact_bullet4.wav", 140, 255, 0.3, CHAN_VOICE )
end

function ENT:GetKillMarker()
	return self.LastKillMarker or 0
end

local matHealth = Material( "lfs_repairmode_health.png" )
local matAmmo = Material( "lfs_repairmode_ammo.png" )

function ENT:LFSRepairInfo(ScrW, ScrH, IsRepair, Progress, ShowRepair)
	local X = ScrW * 0.5
	local Y = ScrH - 45

	if ShowRepair then
		simfphys.LFS.DrawArc( X, Y,25,3,0,360,5,Color(0,0,0,50),true)
		simfphys.LFS.DrawArc( X, Y,25,3,270,270+360*Progress,1,Color(255,255,255,255),true)

		if IsRepair then
			surface.SetMaterial( matHealth )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.DrawTexturedRect( X - 15, Y - 15, 30, 30 )

			simfphys.LFS.DrawArc( X, Y,20,3,0,360,5,Color(0,0,0,50),true)
			simfphys.LFS.DrawArc( X, Y,20,3,270,270+360*(self:GetHP()/self:GetMaxHP()),1,Color(255,255,255,255),true)
		else
			surface.SetMaterial( matAmmo )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.DrawTexturedRect( X - 15, Y - 15, 30, 30 )
		end
	end
end

function ENT:LFSHudPaintRollIndicator( HitPlane, Enabled )
	if not Enabled then return end
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	local Roll = self:GetAngles().roll
	
	local X = math.cos( math.rad( Roll ) )
	local Y = math.sin( math.rad( Roll ) )
	
	surface.DrawLine( HitPlane.x + X * 50, HitPlane.y + Y * 50, HitPlane.x + X * 125, HitPlane.y + Y * 125 ) 
	surface.DrawLine( HitPlane.x - X * 50, HitPlane.y - Y * 50, HitPlane.x - X * 125, HitPlane.y - Y * 125 ) 
	
	surface.DrawLine( HitPlane.x + 125, HitPlane.y, HitPlane.x + 130, HitPlane.y + 5 ) 
	surface.DrawLine( HitPlane.x + 125, HitPlane.y, HitPlane.x + 130, HitPlane.y - 5 ) 
	surface.DrawLine( HitPlane.x - 125, HitPlane.y, HitPlane.x - 130, HitPlane.y + 5 ) 
	surface.DrawLine( HitPlane.x - 125, HitPlane.y, HitPlane.x - 130, HitPlane.y - 5 ) 
	
	surface.SetDrawColor( 0, 0, 0, 80 )
	surface.DrawLine( HitPlane.x + X * 50 + 1, HitPlane.y + Y * 50 + 1, HitPlane.x + X * 125 + 1, HitPlane.y + Y * 125 + 1 ) 
	surface.DrawLine( HitPlane.x - X * 50 + 1, HitPlane.y - Y * 50 + 1, HitPlane.x - X * 125 + 1, HitPlane.y - Y * 125 + 1 ) 
	
	surface.DrawLine( HitPlane.x + 126, HitPlane.y + 1, HitPlane.x + 131, HitPlane.y + 6 ) 
	surface.DrawLine( HitPlane.x + 126, HitPlane.y + 1, HitPlane.x + 131, HitPlane.y - 4 ) 
	surface.DrawLine( HitPlane.x - 126, HitPlane.y + 1, HitPlane.x - 129, HitPlane.y + 6 ) 
	surface.DrawLine( HitPlane.x - 126, HitPlane.y + 1, HitPlane.x - 129, HitPlane.y - 4 ) 
end

function ENT:LFSHudPaint( X, Y, data, ply )
end

function ENT:LFSHudPaintPassenger( X, Y, ply )
	self:LFSPaintHitMarker( {x = X * 0.5, y = Y * 0.5} )
end

function ENT:Think()
	self:AnimCabin()
	self:AnimLandingGear()
	self:AnimRotor()
	self:AnimFins()
	
	self:CheckEngineState()
	
	self:ExhaustFX()
	self:DamageFX()
end

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP <= 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetRotorPos() - self:GetForward() * 50 )
		util.Effect( "lfs_blacksmoke", effectdata )
	end
end

function ENT:ExhaustFX()
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
end

function ENT:EngineActiveChanged( bActive )
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
end

function ENT:HandlePropellerSND( InputPitch, RPM, LoadStart, AddStart, RPMAdd, RPMSub )
	AddStart = AddStart or 0.8
	RPMAdd = RPMAdd or 0.25
	RPMSub = RPMSub or 0.4
	LoadStart =  LoadStart or 0.6

	local MaxRPM = self:GetLimitRPM()
	local PropFade = (RPM / MaxRPM) ^ 5
	local Vel = self:GetVelocity():Length()
	local MaxVel = self:GetMaxVelocity()

	local Add = math.min( math.max(Vel - MaxVel * AddStart,0) / 300, 1 )
	local Load = math.max( math.min(Vel, (MaxVel-Vel) / (MaxVel - MaxVel * LoadStart),1), 0) ^ 2

	local Pitch = math.Clamp(InputPitch + (-Load * RPMSub + Add * RPMAdd) * PropFade,0,2.55)

	if self.PROPELLER_A then
		self.PROPELLER_A:ChangeVolume( Load * PropFade )
	end

	if self.PROPELLER_B then
		self.PROPELLER_B:ChangeVolume( Add  * PropFade )
	end

	return Pitch
end

function ENT:RemovePropellerSND()
	if self.PROPELLER_A then
		self.PROPELLER_A:Stop()
	end
	if self.PROPELLER_B then
		self.PROPELLER_B:Stop()
	end
end

function ENT:AddPropellerSND( Pitch )
	Pitch = Pitch or 100

	self.PROPELLER_A = CreateSound( self, "LFS_PROPELLER" )
	self.PROPELLER_A:PlayEx(0,Pitch)

	self.PROPELLER_B = CreateSound( self, "LFS_PROPELLER_STRAIN" )
	self.PROPELLER_B:PlayEx(0,Pitch)
end

function ENT:CheckEngineState()
	local Active = self:GetEngineActive()
	
	if Active then
		local RPM = self:GetRPM()
		local LimitRPM = self:GetLimitRPM()

		local ply = LocalPlayer()
		local Time = CurTime()

		if (self.NextSound_flyby or 0) < Time then
			self.NextSound_flyby = Time + 0.1

			local Vel = self:GetVelocity()

			local ToPlayer = (ply:GetPos() - self:GetPos()):GetNormalized()
			local VelDir = Vel:GetNormalized()

			local Approaching = math.deg( math.acos( math.Clamp( ToPlayer:Dot( VelDir ) ,-1,1) ) ) < 80

			if Approaching ~= self.OldApproaching then
				self.OldApproaching = Approaching

				if not Approaching then
					if Vel:Length() > self:GetMaxVelocity() * 0.6 and self:GetThrottlePercent() > 50 then
						if ply:lfsGetPlane() ~= self then
							local Dist = (ply:GetPos() - self:GetPos()):Length()

							if Dist < 3000 then
								self:PlayFlybySND()
							end
						end
					end
				end
			end
		end

		local tPer = RPM / LimitRPM

		local CurDist = (ply:GetViewEntity():GetPos() - self:GetPos()):Length()
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

function ENT:PlayFlybySND()
end

function ENT:AnimFins()
end

function ENT:AnimRotor()
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()
end

function ENT:GetCrosshairFilterEnts()
	if not istable( self.CrosshairFilterEnts ) then
		self.CrosshairFilterEnts = {self}
		
		-- lets ask the server to build the filter for us because it has access to constraint.GetAllConstrainedEntities() 
		net.Start( "lfs_player_request_filter" )
			net.WriteEntity( self )
		net.SendToServer()
	end

	return self.CrosshairFilterEnts
end
