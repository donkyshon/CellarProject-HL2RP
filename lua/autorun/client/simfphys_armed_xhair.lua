-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT

CreateClientConVar( "cl_simfphys_crosshair", "1", true, false )

local ShowHud = false
cvars.AddChangeCallback( "cl_simfphys_hud", function( convar, oldValue, newValue ) ShowHud = tonumber( newValue )~=0 end)
ShowHud = GetConVar( "cl_simfphys_hud" ):GetBool()

local show_crosshair = false
local Hudmph = false
local Hudreal = false

cvars.AddChangeCallback( "cl_simfphys_crosshair", function( convar, oldValue, newValue ) show_crosshair = tonumber( newValue )~=0 end)
cvars.AddChangeCallback( "cl_simfphys_hudmph", function( convar, oldValue, newValue ) Hudmph = tonumber( newValue )~=0 end)
cvars.AddChangeCallback( "cl_simfphys_hudrealspeed", function( convar, oldValue, newValue ) Hudreal = tonumber( newValue )~=0 end)

Hudmph = GetConVar( "cl_simfphys_hudmph" ):GetBool()
Hudreal = GetConVar( "cl_simfphys_hudrealspeed" ):GetBool()
show_crosshair = GetConVar( "cl_simfphys_crosshair" ):GetBool()

local xhair = Material( "sprites/hud/v_crosshair1" )
local zoom_mat = Material( "vgui/zoom" )

local function DrawCircle( X, Y, radius )
	local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
	
	for a = 0, 360, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
		
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
	end
end

surface.CreateFont( "SIMFPHYS_ARMED_HUDFONT", {
	font = "Verdana",
	extended = false,
	size = 20,
	weight = 2000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

hook.Add( "HUDShouldDraw", "simfphys_armed_xhair", function( name )
	
	if name ~= "CHudZoom" then return end
		
	local ply = LocalPlayer()
	
	if not ply.GetSimfphys then return end
	
	local Ent = ply:GetSimfphys()
	
	if not IsValid( Ent ) then return end

	local veh = ply:GetVehicle()
	
	if not IsValid( veh ) then return end
	
	if not veh:GetNWBool( "HasCrosshair", false ) then return end
	
	return false
end )

local function traceAndDrawCrosshair( startpos, endpos, vehicle, pod )
	local trace = util.TraceLine( {
		start = startpos,
		endpos = endpos,
		filter = function( e )
			local class = not e:GetClass():StartWith( "gmod_sent_vehicle_fphysics_wheel" )
			local collide = class and e ~= vehicle
			
			return collide
		end
	} )

	local hitpos = trace.HitPos
	
	local scr = hitpos:ToScreen()

	local Type = pod:GetNWInt( "CrosshairType", 0 )

	surface.SetDrawColor( 240, 200, 0, 255 ) 

	local velocity = vehicle:GetVelocity():Length()
	local mph = Hudreal and math.Round(velocity * 0.0568182,0) or math.Round(velocity * 0.0568182 * 0.75,0)
	local kmh = Hudreal and math.Round(velocity * 0.09144,0) or math.Round(velocity * 0.09144 * 0.75,0)
	local printspeed = Hudmph and tostring(mph).."mph" or tostring(kmh).."km/h"
	
	if Type == 0 then
		surface.SetMaterial( xhair )
		surface.DrawTexturedRect( scr.x - 17,scr.y - 17, 34, 34)
		
		if vehicle:GetNWBool( "simfphys_NoRacingHud", false ) and ShowHud then
			local fuel = vehicle:GetFuel() / vehicle:GetMaxFuel()
			local Cruise = vehicle:GetIsCruiseModeOn() and " (cruise)" or ""
			draw.SimpleText( "THR", "SIMFPHYS_ARMED_HUDFONT", 10, 10, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( math.Round(vehicle:GetThrottle() * 100).."%"..Cruise , "SIMFPHYS_ARMED_HUDFONT", 120, 10, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			
			draw.SimpleText( "SPD", "SIMFPHYS_ARMED_HUDFONT", 10, 35, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( printspeed, "SIMFPHYS_ARMED_HUDFONT", 120, 35, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			
			draw.SimpleText( "FUEL", "SIMFPHYS_ARMED_HUDFONT", 10, 60, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( math.Round(vehicle:GetFuel()).."/"..vehicle:GetMaxFuel().."L", "SIMFPHYS_ARMED_HUDFONT", 120, 60, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			
			local Mode = vehicle:GetNWString( "WeaponMode", "-nowpn" )
			if Mode ~= "-nowpn" then
				draw.SimpleText( "WPN", "SIMFPHYS_ARMED_HUDFONT", 10, 85, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( Mode, "SIMFPHYS_ARMED_HUDFONT", 120, 85, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				
				local Ammo = vehicle:GetNWInt( "CurWPNAmmo", -1 )
				
				if Ammo >= 0 then
					draw.SimpleText( "AMMO", "SIMFPHYS_ARMED_HUDFONT", 10, 110, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
					draw.SimpleText( Ammo, "SIMFPHYS_ARMED_HUDFONT", 120, 110, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				end
			end
		end
		
	elseif Type == 1 then
		local X = scr.x
		local Y = scr.y
		
		local Scale = 0.75
		
		local scrW = ScrW() / 2
		local scrH = ScrH() / 2
		local Z = scrW * Scale
		
		local rOuter = scrW * 0.03 * Scale
		
		DrawCircle( X, Y, rOuter )

		surface.SetDrawColor( 240, 200, 0, 50 ) 
		
		local Yaw = vehicle:GetPoseParameter( "turret_yaw" ) * 360 - 90
		
		local dX = math.cos( math.rad( -Yaw ) )
		local dY = math.sin( math.rad( -Yaw ) )
		local len = scrH * 0.04
		
		DrawCircle( scrW, scrH * 1.85, len )
		surface.DrawLine( scrW + dX * len, scrH * 1.85 + dY * len, scrW + dX * len * 3, scrH * 1.85 + dY * len * 3 )
		
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW - len * 1.25, scrH * 1.85 + len * 2 )
		surface.DrawLine( scrW + len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 - len * 2 )
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 + len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
		
	elseif Type == 2 then
		local X = scr.x
		local Y = scr.y
		
		local Scale = 0.75
		
		local scrW = ScrW() / 2
		local scrH = ScrH() / 2
		local Z = scrW * Scale
		
		local safemode =  vehicle:GetNWBool( "TurretSafeMode", true )
		
		if not safemode then
			surface.SetDrawColor( 240, 200, 0, 180 )
		else
			local alpha = math.abs( math.cos( CurTime() * 3 ) )
			
			local Key = input.LookupBinding( "+walk" )
			if not isstring( Key ) then Key = "[+walk is not bound to a key]" end
			
			draw.SimpleText( "press "..Key.." to activate turret!", "simfphysfont", scrW, ScrH() - scrH * 0.04, Color( 255, 235, 0, 255 * alpha ), 1, 1)
		
			surface.SetDrawColor( 240, 200, 0, 50 ) 
		end
		
		local rOuter = scrW * 0.03 * Scale
		local rInner = scrW * 0.005 * Scale

		if vehicle:GetNWBool( "SpecialCam_Loader", false ) then
			surface.DrawLine( X, Y + rInner, X, Y + Z * 0.15)

			surface.DrawLine( X, Y + Z * 0.025, X - Z * 0.01, Y + Z * 0.025)
			
			surface.DrawLine( X, Y + Z * 0.05, X - Z * 0.015, Y + Z * 0.05)
			draw.SimpleText( "1", "simfphysfont", X - Z * 0.02, Y + Z * 0.05 , Color( 240, 200, 0, 180 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			surface.DrawLine( X, Y + Z * 0.075, X - Z * 0.01, Y + Z * 0.075)
			
			surface.DrawLine( X, Y + Z * 0.1, X - Z * 0.015, Y + Z * 0.1)
			draw.SimpleText( "2", "simfphysfont", X - Z * 0.02, Y + Z * 0.1 , Color( 240, 200, 0, 180 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			surface.DrawLine( X, Y + Z * 0.125, X - Z * 0.01, Y + Z * 0.125)
			
			surface.DrawLine( X + rInner, Y - rInner, X + rOuter, Y - rOuter )
			surface.DrawLine( X - rInner, Y - rInner, X - rOuter, Y - rOuter )

			local LoaderTime = vehicle:GetNWFloat( "SpecialCam_LoaderTime", 0 )
			local FireNext = math.max(vehicle:GetNWFloat( "SpecialCam_LoaderNext", 0 ) - CurTime(),0)
			
			local CProgress = ((LoaderTime - FireNext) / LoaderTime)
			
			local pL1 = scrH * 0.25
			local pL2 = scrH * 0.23
			local pL3 = scrH * 0.24
			
			for i = 0, 355, 5 do
				local angCos = math.cos( math.rad( i ) )
				local angSin = math.sin( math.rad( i ) )
				
				if i > (CProgress * 360) then
					pL2 = pL3
					surface.SetDrawColor( 255, 0, 0, 255 )
				end
				
				local pX1 = angCos * pL1
				local pY1 = angSin * pL1
				
				local pX2 = angCos * pL2
				local pY2 = angSin * pL2
				
				surface.DrawLine( X + pX1, Y + pY1, X + pX2, Y + pY2 )
				surface.DrawLine( X + pX1, Y + pY1, X + pX2, Y + pY2 )
			end
			
			if vehicle:GetNWBool( "simfphys_NoHud", false ) and ShowHud then
				local fuel = vehicle:GetFuel() / vehicle:GetMaxFuel()
				local Cruise = vehicle:GetIsCruiseModeOn() and " (cruise)" or ""
				draw.SimpleText( "THR", "SIMFPHYS_ARMED_HUDFONT", 10, 10, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( math.Round(vehicle:GetThrottle() * 100).."%"..Cruise , "SIMFPHYS_ARMED_HUDFONT", 120, 10, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				
				draw.SimpleText( "SPD", "SIMFPHYS_ARMED_HUDFONT", 10, 35, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText(  printspeed, "SIMFPHYS_ARMED_HUDFONT", 120, 35, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				
				draw.SimpleText( "FUEL", "SIMFPHYS_ARMED_HUDFONT", 10, 60, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( math.Round(vehicle:GetFuel()).."/"..vehicle:GetMaxFuel().."L", "SIMFPHYS_ARMED_HUDFONT", 120, 60, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
		else
			DrawCircle( X, Y, rOuter )
			DrawCircle( X, Y, rInner )

			surface.DrawLine( X + rOuter, Y, X + rOuter * 2, Y )
			surface.DrawLine( X - rOuter, Y, X - rOuter * 2, Y )
			surface.DrawLine( X, Y + rOuter, X, Y + rOuter * 2 )
			surface.DrawLine( X, Y - rOuter, X, Y - rOuter * 2)

			surface.DrawLine( X + Z * 0.3, Y - Z * 0.35, X + Z * 0.6, Y - Z * 0.35 )
			surface.DrawLine( X + Z * 0.6, Y - Z * 0.35, X + Z * 0.7, Y - Z * 0.25 )
			surface.DrawLine( X - Z * 0.3, Y - Z * 0.35, X - Z * 0.6, Y - Z * 0.35 )
			surface.DrawLine( X - Z * 0.6, Y - Z * 0.35, X - Z * 0.7, Y - Z * 0.25 )

			surface.DrawLine( X + Z * 0.3, Y + Z * 0.35, X + Z * 0.6, Y + Z * 0.35 )
			surface.DrawLine( X + Z * 0.6, Y + Z * 0.35, X + Z * 0.7, Y + Z * 0.25 )
			surface.DrawLine( X - Z * 0.3, Y + Z * 0.35, X - Z * 0.6, Y + Z * 0.35 )
			surface.DrawLine( X - Z * 0.6, Y + Z * 0.35, X - Z * 0.7, Y + Z * 0.25 )
		end
		
		if not safemode then
			surface.SetDrawColor( 240, 200, 0, 180 )
		else
			surface.SetDrawColor( 240, 200, 0, 50 ) 
		end
		
		local Yaw = vehicle:GetPoseParameter( "turret_yaw" ) * 360 - 90
		
		local dX = math.cos( math.rad( -Yaw ) )
		local dY = math.sin( math.rad( -Yaw ) )
		local len = scrH * 0.04
		
		DrawCircle( scrW, scrH * 1.85, len )
		surface.DrawLine( scrW + dX * len, scrH * 1.85 + dY * len, scrW + dX * len * 3, scrH * 1.85 + dY * len * 3 )
		
		surface.SetDrawColor( 240, 200, 0, 180 )
		
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW - len * 1.25, scrH * 1.85 + len * 2 )
		surface.DrawLine( scrW + len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 - len * 2 )
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 + len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
		
	elseif Type == 3 then
		surface.SetMaterial( xhair )
		surface.DrawTexturedRect( scr.x - 17,scr.y - 17, 34, 34)
		
		local scrW = ScrW() / 2
		local scrH = ScrH() / 2
		
		local Yaw = vehicle:GetPoseParameter( "turret_yaw" ) * 360 - 90
		
		local dX = math.cos( math.rad( -Yaw ) )
		local dY = math.sin( math.rad( -Yaw ) )
		local len = scrH * 0.04
		
		DrawCircle( scrW, scrH * 1.85, len )
		surface.DrawLine( scrW + dX * len, scrH * 1.85 + dY * len, scrW + dX * len * 3, scrH * 1.85 + dY * len * 3 )
		
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW - len * 1.25, scrH * 1.85 + len * 2 )
		surface.DrawLine( scrW + len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 - len * 2 )
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 + len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
		
		if vehicle:GetNWBool( "simfphys_NoRacingHud", false ) and ShowHud then
			local fuel = vehicle:GetFuel() / vehicle:GetMaxFuel()
			local Cruise = vehicle:GetIsCruiseModeOn() and " (cruise)" or ""
			draw.SimpleText( "THR", "SIMFPHYS_ARMED_HUDFONT", 10, 10, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( math.Round(vehicle:GetThrottle() * 100).."%"..Cruise , "SIMFPHYS_ARMED_HUDFONT", 120, 10, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			
			draw.SimpleText( "SPD", "SIMFPHYS_ARMED_HUDFONT", 10, 35, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText(  printspeed, "SIMFPHYS_ARMED_HUDFONT", 120, 35, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			
			draw.SimpleText( "FUEL", "SIMFPHYS_ARMED_HUDFONT", 10, 60, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( math.Round(vehicle:GetFuel()).."/"..vehicle:GetMaxFuel().."L", "SIMFPHYS_ARMED_HUDFONT", 120, 60, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			
			local Mode = vehicle:GetNWString( "WeaponMode", "-nowpn" )
			if Mode ~= "-nowpn" then
				draw.SimpleText( "WPN", "SIMFPHYS_ARMED_HUDFONT", 10, 85, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( Mode, "SIMFPHYS_ARMED_HUDFONT", 120, 85, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				
				local Ammo = vehicle:GetNWInt( "CurWPNAmmo", -1 )
				
				if Ammo >= 0 then
					draw.SimpleText( "AMMO", "SIMFPHYS_ARMED_HUDFONT", 10, 110, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
					draw.SimpleText( Ammo, "SIMFPHYS_ARMED_HUDFONT", 120, 110, Color( 255, 235, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				end
			end
		end
		
	elseif Type == 4 then
		local X = scr.x
		local Y = scr.y

		local Scale = 0.75

		local scrW = ScrW() / 2
		local scrH = ScrH() / 2
		local Z = scrW * Scale

		local safemode =  vehicle:GetNWBool( "TurretSafeMode", true )

		if not safemode then
			surface.SetDrawColor( 20, 255, 20, 180 )
		else
			local alpha = math.abs( math.cos( CurTime() * 3 ) )
			
			local Key = input.LookupBinding( "+walk" )
			if not isstring( Key ) then Key = "[+walk is not bound to a key]" end
			
			draw.SimpleText( "press "..Key.." to activate turret!", "simfphysfont", scrW, ScrH() - scrH * 0.04, Color( 20, 255, 20, 255 * alpha ), 1, 1)

			surface.SetDrawColor( 20, 255, 20, 50 ) 
		end

		local rOuter = scrW * 0.03 * Scale
		local rInner = scrW * 0.005 * Scale

		if vehicle:GetNWBool( "SpecialCam_Loader", false ) then
			surface.DrawLine( X, Y + rInner, X, Y + Z * 0.15)

			surface.DrawLine( X, Y + Z * 0.025, X - Z * 0.01, Y + Z * 0.025)
			
			surface.DrawLine( X, Y + Z * 0.05, X - Z * 0.015, Y + Z * 0.05)
			draw.SimpleText( "1", "simfphysfont", X - Z * 0.02, Y + Z * 0.05 , Color( 20, 255, 20, 180 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			surface.DrawLine( X, Y + Z * 0.075, X - Z * 0.01, Y + Z * 0.075)
			
			surface.DrawLine( X, Y + Z * 0.1, X - Z * 0.015, Y + Z * 0.1)
			draw.SimpleText( "2", "simfphysfont", X - Z * 0.02, Y + Z * 0.1 , Color( 20, 255, 20, 180 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			surface.DrawLine( X, Y + Z * 0.125, X - Z * 0.01, Y + Z * 0.125)
			
			surface.DrawLine( X + rInner, Y - rInner, X + rOuter, Y - rOuter )
			surface.DrawLine( X - rInner, Y - rInner, X - rOuter, Y - rOuter )

			local LoaderTime = vehicle:GetNWFloat( "SpecialCam_LoaderTime", 0 )
			local FireNext = math.max(vehicle:GetNWFloat( "SpecialCam_LoaderNext", 0 ) - CurTime(),0)
			
			local CProgress = ((LoaderTime - FireNext) / LoaderTime)
			
			local pL1 = scrH * 0.25
			local pL2 = scrH * 0.23
			local pL3 = scrH * 0.24
			
			for i = 0, 355, 5 do
				local angCos = math.cos( math.rad( i ) )
				local angSin = math.sin( math.rad( i ) )
				
				if i > (CProgress * 360) then
					pL2 = pL3
					surface.SetDrawColor( 255, 0, 0, 255 )
				end
				
				local pX1 = angCos * pL1
				local pY1 = angSin * pL1
				
				local pX2 = angCos * pL2
				local pY2 = angSin * pL2
				
				surface.DrawLine( X + pX1, Y + pY1, X + pX2, Y + pY2 )
				surface.DrawLine( X + pX1, Y + pY1, X + pX2, Y + pY2 )
			end
			
			if vehicle:GetNWBool( "simfphys_NoHud", false ) and ShowHud then
				local fuel = vehicle:GetFuel() / vehicle:GetMaxFuel()
				local Cruise = vehicle:GetIsCruiseModeOn() and " (cruise)" or ""
				draw.SimpleText( "THR", "SIMFPHYS_ARMED_HUDFONT", 10, 10, Color( 20, 255, 20, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( math.Round(vehicle:GetThrottle() * 100).."%"..Cruise , "SIMFPHYS_ARMED_HUDFONT", 120, 10, Color( 20, 255, 20, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				
				draw.SimpleText( "SPD", "SIMFPHYS_ARMED_HUDFONT", 10, 35, Color( 20, 255, 20, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( printspeed, "SIMFPHYS_ARMED_HUDFONT", 120, 35, Color( 20, 255, 20, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				
				draw.SimpleText( "FUEL", "SIMFPHYS_ARMED_HUDFONT", 10, 60, Color( 20, 255, 20, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( math.Round(vehicle:GetFuel()).."/"..vehicle:GetMaxFuel().."L", "SIMFPHYS_ARMED_HUDFONT", 120, 60, Color( 20, 255, 20, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
		else
			DrawCircle( X, Y, rOuter )
			DrawCircle( X, Y, rInner )

			surface.DrawLine( X + rOuter, Y, X + rOuter * 2, Y )
			surface.DrawLine( X - rOuter, Y, X - rOuter * 2, Y )
			surface.DrawLine( X, Y + rOuter, X, Y + rOuter * 2 )
			surface.DrawLine( X, Y - rOuter, X, Y - rOuter * 2)

			surface.DrawLine( X + Z * 0.3, Y - Z * 0.35, X + Z * 0.6, Y - Z * 0.35 )
			surface.DrawLine( X + Z * 0.6, Y - Z * 0.35, X + Z * 0.7, Y - Z * 0.25 )
			surface.DrawLine( X - Z * 0.3, Y - Z * 0.35, X - Z * 0.6, Y - Z * 0.35 )
			surface.DrawLine( X - Z * 0.6, Y - Z * 0.35, X - Z * 0.7, Y - Z * 0.25 )

			surface.DrawLine( X + Z * 0.3, Y + Z * 0.35, X + Z * 0.6, Y + Z * 0.35 )
			surface.DrawLine( X + Z * 0.6, Y + Z * 0.35, X + Z * 0.7, Y + Z * 0.25 )
			surface.DrawLine( X - Z * 0.3, Y + Z * 0.35, X - Z * 0.6, Y + Z * 0.35 )
			surface.DrawLine( X - Z * 0.6, Y + Z * 0.35, X - Z * 0.7, Y + Z * 0.25 )
		end

		if not safemode then
			surface.SetDrawColor( 20, 255, 20, 180 )
		else
			surface.SetDrawColor( 20, 255, 20, 50 ) 
		end

		local Yaw = vehicle:GetPoseParameter( "cannon_aim_yaw" ) * 360 - 90

		local dX = math.cos( math.rad( -Yaw ) )
		local dY = math.sin( math.rad( -Yaw ) )
		local len = scrH * 0.04

		DrawCircle( scrW, scrH * 1.85, len )
		surface.DrawLine( scrW + dX * len, scrH * 1.85 + dY * len, scrW + dX * len * 3, scrH * 1.85 + dY * len * 3 )

		surface.SetDrawColor( 20, 255, 20, 180 )

		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW - len * 1.25, scrH * 1.85 + len * 2 )
		surface.DrawLine( scrW + len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 - len * 2 )
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 + len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
		
	elseif Type == 5 then
		local X = scr.x
		local Y = scr.y
		
		local Scale = 0.75
		
		local scrW = ScrW() / 2
		local scrH = ScrH() / 2
		local Z = scrW * Scale
		
		local rOuter = scrW * 0.03 * Scale
		local rInner = scrW * 0.005 * Scale
		
		surface.SetDrawColor( 20, 255, 20, 255 )
		
		DrawCircle( X, Y, rOuter )

		surface.SetDrawColor( 20, 255, 20, 50 )
		
		local Yaw = vehicle:GetPoseParameter( "cannon_aim_yaw" ) * 360 - 90
		
		local dX = math.cos( math.rad( -Yaw ) )
		local dY = math.sin( math.rad( -Yaw ) )
		local len = scrH * 0.04
		
		DrawCircle( scrW, scrH * 1.85, len )
		surface.DrawLine( scrW + dX * len, scrH * 1.85 + dY * len, scrW + dX * len * 3, scrH * 1.85 + dY * len * 3 )
		
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW - len * 1.25, scrH * 1.85 + len * 2 )
		surface.DrawLine( scrW + len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 - len * 2 )
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 + len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
	end
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	draw.NoTexture()
end

local function MixDirection( ang, direction )

	local Dir = ang:Forward()
	
	-- placeholder code
	if direction.x == -1 then
		Dir = -ang:Forward()
		
	elseif direction.y == 1 then
		Dir = ang:Right()
		
	elseif direction.y == -1 then
		Dir = -ang:Right()
		
	elseif direction.z == 1 then
		Dir = ang:Up()
		
	elseif direction.z == -1 then
		Dir = -ang:Up()
	end
	
	return Dir
end

hook.Add( "HUDPaint", "simfphys_crosshair", function()
	
	if not show_crosshair then return end
	
	local ply = LocalPlayer()
	local veh = ply:GetVehicle()
	
	if not IsValid( veh ) then return end
	
	local HasCrosshair = veh:GetNWBool( "HasCrosshair" ) 
	
	if not HasCrosshair then return end
	
	local vehicle = ply.GetSimfphys and ply:GetSimfphys() or veh.vehiclebase
	
	if not IsValid( vehicle ) then return end
	
	if ply:GetViewEntity() ~= ply then return end
	
	local ID = vehicle:LookupAttachment( veh:GetNWString( "Attachment" ) )
	if ID == 0 then return end
	
	local Attachment = vehicle:GetAttachment( ID )
	
	local startpos = Attachment.Pos
	local endpos = startpos + MixDirection( Attachment.Ang, veh:GetNWVector( "Direction" ) ) * 999999
	
	if veh:GetNWBool( "CalcCenterPos" ) then
		local attach_l = vehicle:LookupAttachment( veh:GetNWString( "Start_Left" ) )
		local attach_r = vehicle:LookupAttachment( veh:GetNWString( "Start_Right" ) )
		
		if attach_l > 0 and attach_r > 0 then
			local pos1 = vehicle:GetAttachment( attach_l ).Pos
			local pos2 = vehicle:GetAttachment( attach_r ).Pos
			
			startpos = (pos1 + pos2) / 2
			
			traceAndDrawCrosshair( startpos, endpos, vehicle, veh )
		end
		return
	end
	
	traceAndDrawCrosshair( startpos, endpos, vehicle, veh )
end )
