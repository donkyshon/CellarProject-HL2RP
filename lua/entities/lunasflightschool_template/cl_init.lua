-- YOU CAN EDIT AND REUPLOAD THIS FILE. 
-- HOWEVER MAKE SURE TO RENAME THE FOLDER TO AVOID CONFLICTS

include("shared.lua")

function ENT:LFSCalcViewFirstPerson( view, ply ) -- modify first person camera view here
	--[[
	if ply == self:GetDriver() then
		-- driver view
	elseif ply == self:GetGunner() then
		-- gunner view
	else
		-- everyone elses view
	end
	]]--
	
	return view
end

function ENT:LFSCalcViewThirdPerson( view, ply ) -- modify third person camera view here
	return view
end

function ENT:LFSHudPaint( X, Y, data, ply ) -- driver only
end

function ENT:LFSHudPaintPassenger( X, Y, ply ) -- all except driver
end

--[[
function ENT:LFSHudPaintPlaneIdentifier( X, Y, In_Col ) -- plane team-identifier info box
	surface.SetDrawColor( In_Col.r, In_Col.g, In_Col.b, In_Col.a )
	
	local Size = 60
	
	surface.DrawLine( X - Size, Y + Size, X + Size, Y + Size )
	surface.DrawLine( X - Size, Y - Size, X - Size, Y + Size )
	surface.DrawLine( X + Size, Y - Size, X + Size, Y + Size )
	surface.DrawLine( X - Size, Y - Size, X + Size, Y - Size )
end
]]--

--[[
function ENT:LFSHudPaintInfoText( X, Y, speed, alt, AmmoPrimary, AmmoSecondary, Throttle ) -- the hud text on the top left of your screen
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
]]--

--[[
function ENT:LFSHudPaintInfoLine( HitPlane, HitPilot, LFS_TIME_NOTIFY, Dir, Len, FREELOOK ) -- the line that connects the two crosshair-circles
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
]]--

--[[
function ENT:LFSHudPaintCrosshair( HitPlane, HitPilot ) -- crosshair
	surface.SetDrawColor( 255, 255, 255, 255 )
	simfphys.LFS.DrawCircle( HitPlane.x, HitPlane.y, 10 ) -- draw's a circle where the plane is looking at
	surface.DrawLine( HitPlane.x + 10, HitPlane.y, HitPlane.x + 20, HitPlane.y ) 
	surface.DrawLine( HitPlane.x - 10, HitPlane.y, HitPlane.x - 20, HitPlane.y ) 
	surface.DrawLine( HitPlane.x, HitPlane.y + 10, HitPlane.x, HitPlane.y + 20 ) 
	surface.DrawLine( HitPlane.x, HitPlane.y - 10, HitPlane.x, HitPlane.y - 20 ) 
	simfphys.LFS.DrawCircle( HitPilot.x, HitPilot.y, 34 ) -- draw's a circle where the pilot is looking at
	
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
]]--

--[[
function ENT:LFSHudPaintRollIndicator( HitPlane, Enabled ) -- roll indicator
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
]]--

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp( 60 + Pitch * 40 + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( Pitch, 0.5,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "vehicles/airboat/fan_blade_fullthrottle_loop1.wav" )
		self.ENG:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
	
	if IsValid( self.TheRotor ) then -- if we have an rotor
		self.TheRotor:Remove() -- remove it
	end
end

function ENT:SoundStop()
	if self.ENG then
		self.ENG:Stop()
	end
end

function ENT:AnimFins()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end

function ENT:AnimRotor()
	if not IsValid( self.TheRotor ) then -- spawn the rotor for all clients that dont have one
		local Rotor = ents.CreateClientProp()
		Rotor:SetPos( self:GetRotorPos() )
		Rotor:SetAngles( self:LocalToWorldAngles( Angle(90,0,0) ) )
		Rotor:SetModel( "models/XQM/propeller1big.mdl" )
		Rotor:SetParent( self )
		Rotor:Spawn()
		
		self.TheRotor = Rotor
	end
	
	local RPM = self:GetRPM() * 2 -- spin twice as fast
	self.RPM = self.RPM and (self.RPM + RPM * FrameTime()) or 0
	
	local Rot = Angle(0,0,-self.RPM)
	Rot:Normalize() 
	
	self.TheRotor:SetAngles( self:LocalToWorldAngles( Rot ) )
end

function ENT:PlayFlybySND()
	--[[ play a flyby sound here ]]--
end

function ENT:AnimCabin()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end

function ENT:AnimLandingGear()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end

function ENT:ExhaustFX()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end
