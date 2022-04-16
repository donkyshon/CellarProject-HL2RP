--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")
local VisibleTime = 0
local smVisible = 0
local VisibleTime2 = 0
local smVisible2 = 0
local zoom_mat = Material( "vgui/zoom" )
local function IsMultipleofTen(num)
	local explode = string.Explode("", num)
	local numofchar = table.Count(explode)

	if explode[numofchar] == "0" then
		return true
	end

	return false
end
local function DrawCircle( X, Y, radius ) -- handy draw circle function. I should make this a global function at some point
	local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
	
	for a = 0, 360, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
	end
end

--Camera
function ENT:GunCamera( view, ply )
	local ZoomView = self:GetZoom()
	if ply == self:GetGunner() then
		local Zoom = ply:lfsGetInput("CAMERA")
		
		if self.oldZoom ~= Zoom then
			self.oldZoom = Zoom
			if Zoom then
				self.ToggledView = not self.ToggledView
			else
				self.curZoom = 90
			end
		end
		if self.ToggledView then
			local ID = self:LookupAttachment( "view" )
			local Attachment = self:GetAttachment( ID )

			if Attachment then
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
			else
				view.origin = self:LocalToWorld( Vector(344.11,0,-62) )
			end
			
			if ZoomView == 0 then
				view.fov = self.curZoom
			elseif ZoomView == 1 then
				view.fov = 50
			elseif ZoomView == 2 then
				view.fov = 20
			end
		end
	end
	
	if self.oldToggledView ~= self.ToggledView then
		self.oldToggledView = self.ToggledView
		
		if self.ToggledView then
			surface.PlaySound("weapons/sniper/sniper_zoomin.wav")
		else
			surface.PlaySound("weapons/sniper/sniper_zoomout.wav")
		end
	end
	
	return view
end
function ENT:LFSCalcViewFirstPerson( view, ply )
	if ply ~= self:GetDriver() and ply ~= self:GetGunner() then
		view.angles = ply:GetVehicle():LocalToWorldAngles( ply:EyeAngles() )
	end
	
	return self:GunCamera( view, ply )
end
function ENT:LFSCalcViewThirdPerson( view, ply )
	return self:GunCamera( view, ply )
end
function ENT:LFSHudPaintPassenger( X, Y, ply )
	if ply ~= self:GetGunner() then return end
	local vel = self:GetVelocity():Length()
		
	local Throttle = self:GetThrottlePercent()

	local speed = math.Round(vel * 0.09144,0)

	local ZPos = math.Round( self:GetPos().z,0)
	if (ZPos + simfphys.LFS.AltitudeMinZ)< 0 then simfphys.LFS.AltitudeMinZ = math.abs(ZPos) end
	local alt = math.Round( (self:GetPos().z + simfphys.LFS.AltitudeMinZ) * 0.0254,0)
	local UsingGunCam = self.ToggledView
	
	local HitPlane = Vector(X*0.5,Y*0.5,0)

	local ID = self:LookupAttachment( "view" )
	local Attachment = self:GetAttachment( ID )

	if Attachment then
		-- for the crosshair to be accurate CLIENT aiming code has to be exactly the same as SERVER aiming code
		
		local Dir = ply:EyeAngles():Forward()
		local TargetDir = Attachment.Ang:Forward()
		local Forward = self:LocalToWorldAngles( Angle(20,0,0) ):Forward()
		local AimDirToForwardDir = math.deg( math.acos( math.Clamp( Forward:Dot( Dir ) ,-1,1) ) )
		if AimDirToForwardDir < 0 then
			TargetDir = Dir
		end
		
		local Trace = util.TraceLine( {
			start = Attachment.Pos,
			endpos = (Attachment.Pos + TargetDir  * 50000),
			filter = self
		} )
		
		local pToScreen = Trace.HitPos:ToScreen()
		
		HitPlane = Vector(pToScreen.x,pToScreen.y,0)
	end
	
	local Time = CurTime()
	
	if self:GetAmmoSecondary() ~= self.OldAmmoSecondary then
		self.OldAmmoSecondary = self:GetAmmoSecondary()
		VisibleTime = Time + 2
	end
	
	local Visible = VisibleTime > Time
	smVisible = smVisible + ((Visible and 1 or 0) - smVisible) * FrameTime() * 10
	
	local wobl = ((VisibleTime - 1.9 > Time) and  self:GetAmmoSecondary() > 0) and math.cos( Time * 300 ) * 6 or 0
	
	local vD = 10 + (10 + wobl)
	local vD2 = 15 + (15 + wobl)
	surface.SetDrawColor( Color(255,255,255,255) )
	surface.DrawLine( HitPlane.x + vD, HitPlane.y, HitPlane.x + vD2, HitPlane.y ) 
	surface.DrawLine( HitPlane.x - vD, HitPlane.y, HitPlane.x - vD2, HitPlane.y ) 
	surface.DrawLine( HitPlane.x, HitPlane.y + vD, HitPlane.x, HitPlane.y + vD2 ) 
	surface.DrawLine( HitPlane.x, HitPlane.y - vD, HitPlane.x, HitPlane.y - vD2 ) 

	local ID2 = self:LookupAttachment( "muzzle" )
    local Attachment2 = self:GetAttachment( ID2 )

    if Attachment2 then
        -- for the crosshair to be accurate CLIENT aiming code has to be exactly the same as SERVER aiming code
    
        local Dir2 = ply:EyeAngles():Forward()
        local TargetDir2 = Attachment2.Ang:Forward()
        local Forward2 = self:LocalToWorldAngles( Angle(20,0,0) ):Forward()
        local AimDirToForwardDir2 = math.deg( math.acos( math.Clamp( Forward2:Dot( Dir2) ,-1,1) ) )
        if AimDirToForwardDir2 < 0 then
            TargetDir2 = Dir2
        end
    
        local Trace2 = util.TraceLine( {
            start = Attachment2.Pos,
            endpos = (Attachment.Pos + TargetDir2  * 50000),
            filter = self
        } )
    
        local pToScreen2 = Trace2.HitPos:ToScreen()
    
        HitPlane = Vector(pToScreen2.x,pToScreen2.y,0)
    end
    local Time2 = CurTime()

    if self:GetAmmoTertiary() ~= self.OldAmmoTertiary2 then
        self.OldAmmoTertiary2 = self:GetAmmoTertiary()
        VisibleTime2 = Time2 + 2
    end

    local Visible2 = VisibleTime2 > Time2
    smVisible2 = smVisible2 + ((Visible2 and 1 or 0) - smVisible2) * FrameTime() * 10

    local wobl2 = ((VisibleTime2 - 1.9 > Time2) and  self:GetAmmoTertiary() > 0) and math.cos( Time2 * 300 ) * 6 or 0

    local vD2 = 2 + (2 + wobl2)
    local vD3 = 10 + (10 + wobl2)
    surface.SetDrawColor( Color(255,255,255,255) )
	DrawCircle( HitPlane.x, HitPlane.y,5+vD2,5+vD2) 

	if not UsingGunCam then return end
	
	local X = ScrW() * 0.5
	local Y = ScrH() * 0.5
	
	self.curZoom = self.curZoom or 90
	
	local Scale = (2.5 - self.curZoom / 70)
	
	local R = X * 0.2 * Scale
	local Gunner = self:GetGunner()
	local FLIR = self:GetFLIR()
	local Weapon = self:GetWeapon()
	if FLIR == 2 then
		cam.Start3D()
		for k,v in pairs(ents.GetAll()) do
			if(v:IsNPC()) or (v:IsPlayer() and v:Alive()) or (v:IsVehicle() and !IsValid(v:GetParent())) then
				if !v:IsEffectActive(EF_NODRAW) then
					render.SuppressEngineLighting(false)
					render.SetColorModulation(0,0,0)
					render.MaterialOverride("flir/black_hot_alive")
					render.SetBlend(100)
					v:DrawModel()
					render.SuppressEngineLighting(false)
				end
			else
				if !v:IsEffectActive(EF_NODRAW) then
					if IsValid(v) then
						render.SuppressEngineLighting(true)
						render.SetColorModulation(0,0,0)
						render.MaterialOverride("flir/black_hot_alive")
						render.SetBlend(100)
						v:DrawModel()
						render.SuppressEngineLighting(true)
					end
				end
			end
		end
		DrawColorModify({
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0.75,
			["$pp_colour_contrast" ] = 0.75,
			["$pp_colour_colour" ] = 0,
			["$pp_colour_mulr" ] = 0,
			["$pp_colour_mulg" ] = 0,
			["$pp_colour_mulb" ] = 0,
		})
		cam.End3D()
		local scrw, scrh = ScrW(), ScrH()
		local scale = scrh / 900
		local Speed = 10
		local TickDist = 2
		local EyeAngle = LocalPlayer():EyeAngles().y * Speed
		local planeang = self:GetAngles().y * Speed
		local addline, addline2, ticklenght, ticky, numx = 0,0,0,0,0
		local ismul = false
		local degreecount = 0
		render.SetScissorRect( 450 * scale, 23 * scale , 1150 * scale, 80 * scale, true ) -- Set our scissor area so the ticks don't leave the boarder
		surface.SetDrawColor(Color(0,0,0,255))
		draw.SimpleText("^","LFS_FONT", 790 * scale, 65 * scale,Color(0,0,0,255))
		draw.SimpleText("180","LFS_FONT",EyeAngle + 789 * scale, 25 * scale, Color(0,0,0,255))
		surface.DrawRect( 450 * scale, 25 * scale, 2 * scale, 50 * scale ) --left frame
		surface.DrawRect( 1149 * scale, 25 * scale, 2 * scale, 50 * scale ) --right frame
	
	
		for i = 1, 36 * Speed do
			degreecount = i == 1 and 180 or degreecount -- Esentally translates to if i == 1 then degreecount = 180 else degreecount = degreecount
			addline = math.Round(addline + 10 / (Speed / TickDist))
			ismul = IsMultipleofTen(tostring(math.abs(addline)))
			if ismul then
				degreecount = degreecount >= 350 and 0 or degreecount +  10 -- Esentally translates to if degreecount >= 350 then degreecount == 0 else degreecount == degreecount + 10
				numx = degreecount >= 100 and 789 or degreecount >= 10 and 793 or 797
				draw.SimpleText(degreecount,"LFS_FONT",EyeAngle + numx * scale + addline * Speed, 25 * scale, Color(0,0,0,255))
				ticklenght = 30
				ticky = 45
			else
				ticklenght = 20
				ticky = 55
			end
	
			surface.DrawRect( EyeAngle + (800 * scale) + addline * Speed, ticky * scale, 2, ticklenght )
		end
	
		addline = 0
	
		for i = 1, 36 * Speed do
			degreecount = i == 1 and 180 or degreecount
			addline = math.Round(addline - 10 / (Speed / TickDist))
			Alpha = 255
			ismul = IsMultipleofTen(tostring(math.abs(addline)))
			if ismul then
				degreecount = degreecount <= 0 and 350 or degreecount -  10
				numx = degreecount >= 100 and 789 or degreecount >= 10 and 793 or 797
				draw.SimpleText(degreecount,"LFS_FONT",EyeAngle + numx * scale + addline * Speed, 25 * scale, Color(0,0,0,255))
				ticklenght = 30
				ticky = 45
			else
				ticklenght = 20
				ticky = 55
			end
	
			surface.DrawRect( EyeAngle + (800 * scale) + addline * Speed, ticky * scale, 2, ticklenght )
		end
	
		render.SetScissorRect( 0, 0, 0, 0, false )

		draw.SimpleText( "FLIR: ON", "LFS_FONT", X-40, Y-225, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		surface.SetDrawColor( Color(0,0,0,255) )
		surface.SetMaterial(zoom_mat ) 
		surface.DrawTexturedRectRotated( X + X * 0.5, Y * 0.5, X, Y, 0 )
		surface.DrawTexturedRectRotated( X + X * 0.5, Y + Y * 0.5, Y, X, 270 )
		surface.DrawTexturedRectRotated( X * 0.5, Y * 0.5, Y, X, 90 )
		surface.DrawTexturedRectRotated( X * 0.5, Y + Y * 0.5, X, Y, 180 )
	
		surface.SetDrawColor( Color(0,0,0,255) )
		surface.DrawRect( X, Y-120, 5, 80 )--Cross up
		surface.DrawRect( X, Y+40, 5, 80 )--Cross down
		surface.DrawRect( X-120, Y, 80, 5 )--Cross left
		surface.DrawRect( X+40, Y, 80, 5 )--Cross right
	
		surface.DrawRect( X-120, Y-120, 5, 80 )--Corner top left down
		surface.DrawRect( X-120, Y-120, 80, 5 )--Corner top left rght
		
		surface.DrawRect( X+45, Y+120, 80,5 )--Corner bottom right left
		surface.DrawRect( X+120, Y+45, 5,80 )--Corner bottom right up
	
		surface.DrawRect( X-120, Y+120, 80,5 )--Corner bottom left right
		surface.DrawRect( X-120, Y+45, 5,80 )--Corner bottom left up
	
		surface.DrawRect( X+45, Y-120, 80,5 )--Corner top right left
		surface.DrawRect( X+120, Y-120, 5,80 )--Corner top right donw
	
		draw.SimpleText( "THR", "LFS_FONT", X-80, Y-150, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( Throttle.."%" , "LFS_FONT", X+50, Y-150, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "IAS", "LFS_FONT", X+180, Y-10, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( speed, "LFS_FONT",X+180, Y-25, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "km/h", "LFS_FONT", X+160, Y+5, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "ALT", "LFS_FONT", X-200,Y-10, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( alt , "LFS_FONT", X-200,Y-25, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "m", "LFS_FONT", X-200,Y+5, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "MISSILE", "LFS_FONT", X+85, Y+135, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( self:GetAmmoSecondary(), "LFS_FONT", X+105, Y+150, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "CANNON", "LFS_FONT", X-35, Y+135, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( self:GetAmmoTertiary(), "LFS_FONT", X-15, Y+150,Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "FLARES", "LFS_FONT", X-30, Y-185, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( self:GetFlares(), "LFS_FONT", X-10, Y-200, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "FUEL", "LFS_FONT", X-20, Y+185, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( self:GetFuel(), "LFS_FONT", X-20, Y+200, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	elseif FLIR == 1 then
		cam.Start3D()
		for k,v in pairs(ents.GetAll()) do
			if(v:IsNPC()) or (v:IsPlayer() and v:Alive()) or (v:IsVehicle() and !IsValid(v:GetParent())) then
				if !v:IsEffectActive(EF_NODRAW) then
					render.SuppressEngineLighting(false)
					render.SetColorModulation(255,255,255)
					render.MaterialOverride("flir/white_hot_alive")
					render.SetBlend(100)
					v:DrawModel()
					render.SuppressEngineLighting(false)
				end
			else
				if !v:IsEffectActive(EF_NODRAW) then
					if IsValid(v) then
						render.SuppressEngineLighting(true)
						render.SetColorModulation(255,255,255)
						render.MaterialOverride("flir/white_hot_alive")
						render.SetBlend(100)
						v:DrawModel()
						render.SuppressEngineLighting(true)
					end
				end
			end
		end
		DrawColorModify({
			[ "$pp_colour_addr" ] 		= 0,
			[ "$pp_colour_addg" ] 		= 0,
			[ "$pp_colour_addb" ] 		= 0,
			[ "$pp_colour_brightness" ] 	= -0.1,
			[ "$pp_colour_contrast" ] 	= 1,
			[ "$pp_colour_colour" ] 	= 0,
			[ "$pp_colour_mulr" ] 		= 0,
			[ "$pp_colour_mulg" ] 		= 0,
			[ "$pp_colour_mulb" ] 		= 0,
		})
		cam.End3D()
		
		local scrw, scrh = ScrW(), ScrH()
		local scale = scrh / 900
		local Speed = 10
		local TickDist = 2
		local EyeAngle = LocalPlayer():EyeAngles().y * Speed
		local planeang = self:GetAngles().y * Speed
		local addline, addline2, ticklenght, ticky, numx = 0,0,0,0,0
		local ismul = false
		local degreecount = 0
		render.SetScissorRect( 450 * scale, 23 * scale , 1150 * scale, 80 * scale, true ) -- Set our scissor area so the ticks don't leave the boarder
		surface.SetDrawColor(Color(255,255,255,255))
		draw.SimpleText("^","LFS_FONT", 790 * scale, 65 * scale,Color(255,255,255,255))
		draw.SimpleText("180","LFS_FONT",EyeAngle + 789 * scale, 25 * scale, Color(255,255,255,255))
		surface.DrawRect( 450 * scale, 25 * scale, 2 * scale, 50 * scale ) --left frame
		surface.DrawRect( 1149 * scale, 25 * scale, 2 * scale, 50 * scale ) --right frame
	
	
		for i = 1, 36 * Speed do
			degreecount = i == 1 and 180 or degreecount -- Esentally translates to if i == 1 then degreecount = 180 else degreecount = degreecount
			addline = math.Round(addline + 10 / (Speed / TickDist))
			ismul = IsMultipleofTen(tostring(math.abs(addline)))
			if ismul then
				degreecount = degreecount >= 350 and 0 or degreecount +  10 -- Esentally translates to if degreecount >= 350 then degreecount == 0 else degreecount == degreecount + 10
				numx = degreecount >= 100 and 789 or degreecount >= 10 and 793 or 797
				draw.SimpleText(degreecount,"LFS_FONT",EyeAngle + numx * scale + addline * Speed, 25 * scale, Color(255,255,255,255))
				ticklenght = 30
				ticky = 45
			else
				ticklenght = 20
				ticky = 55
			end
	
			surface.DrawRect( EyeAngle + (800 * scale) + addline * Speed, ticky * scale, 2, ticklenght )
		end
	
		addline = 0
	
		for i = 1, 36 * Speed do
			degreecount = i == 1 and 180 or degreecount
			addline = math.Round(addline - 10 / (Speed / TickDist))
			Alpha = 255
			ismul = IsMultipleofTen(tostring(math.abs(addline)))
			if ismul then
				degreecount = degreecount <= 0 and 350 or degreecount -  10
				numx = degreecount >= 100 and 789 or degreecount >= 10 and 793 or 797
				draw.SimpleText(degreecount,"LFS_FONT",EyeAngle + numx * scale + addline * Speed, 25 * scale, Color(255,255,255,255))
				ticklenght = 30
				ticky = 45
			else
				ticklenght = 20
				ticky = 55
			end
	
			surface.DrawRect( EyeAngle + (800 * scale) + addline * Speed, ticky * scale, 2, ticklenght )
		end
	
		render.SetScissorRect( 0, 0, 0, 0, false )

		draw.SimpleText( "FLIR: ON", "LFS_FONT", X-40, Y-225, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		surface.SetDrawColor( Color(125,125,125,255) )
		surface.SetMaterial(zoom_mat ) 
		surface.DrawTexturedRectRotated( X + X * 0.5, Y * 0.5, X, Y, 0 )
		surface.DrawTexturedRectRotated( X + X * 0.5, Y + Y * 0.5, Y, X, 270 )
		surface.DrawTexturedRectRotated( X * 0.5, Y * 0.5, Y, X, 90 )
		surface.DrawTexturedRectRotated( X * 0.5, Y + Y * 0.5, X, Y, 180 )
	
		surface.SetDrawColor( Color(225,225,255,255) )
		surface.DrawRect( X, Y-120, 5, 80 )--Cross up
		surface.DrawRect( X, Y+40, 5, 80 )--Cross down
		surface.DrawRect( X-120, Y, 80, 5 )--Cross left
		surface.DrawRect( X+40, Y, 80, 5 )--Cross right
	
		surface.DrawRect( X-120, Y-120, 5, 80 )--Corner top left down
		surface.DrawRect( X-120, Y-120, 80, 5 )--Corner top left rght
		
		surface.DrawRect( X+45, Y+120, 80,5 )--Corner bottom right left
		surface.DrawRect( X+120, Y+45, 5,80 )--Corner bottom right up
	
		surface.DrawRect( X-120, Y+120, 80,5 )--Corner bottom left right
		surface.DrawRect( X-120, Y+45, 5,80 )--Corner bottom left up
	
		surface.DrawRect( X+45, Y-120, 80,5 )--Corner top right left
		surface.DrawRect( X+120, Y-120, 5,80 )--Corner top right donw
	
		draw.SimpleText( "THR", "LFS_FONT", X-80, Y-150, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( Throttle.."%" , "LFS_FONT", X+50, Y-150, Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "IAS", "LFS_FONT", X+180, Y-10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( speed, "LFS_FONT",X+180, Y-25, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "km/h", "LFS_FONT", X+160, Y+5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "ALT", "LFS_FONT", X-200,Y-10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( alt , "LFS_FONT", X-200,Y-25, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "m", "LFS_FONT", X-200,Y+5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "MISSILE", "LFS_FONT", X+85, Y+135, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( self:GetAmmoSecondary(), "LFS_FONT", X+105, Y+150, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

		draw.SimpleText( "CANNON", "LFS_FONT", X-35, Y+135, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( self:GetAmmoTertiary(), "LFS_FONT", X-15, Y+150, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "FLARES", "LFS_FONT", X-30, Y-185, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( self:GetFlares(), "LFS_FONT", X-10, Y-200, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "FUEL", "LFS_FONT", X-20, Y+185, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( self:GetFuel(), "LFS_FONT", X-20, Y+200, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	elseif FLIR == 0 then
		DrawColorModify({
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast" ] = 1,
			["$pp_colour_colour" ] = 1,
			["$pp_colour_mulr" ] = 0,
			["$pp_colour_mulg" ] = 0,
			["$pp_colour_mulb" ] = 0,
		})

		local scrw, scrh = ScrW(), ScrH()
		local scale = scrh / 900
		local Speed = 10
		local TickDist = 2
		local EyeAngle = LocalPlayer():EyeAngles().y * Speed
		local planeang = self:GetAngles().y * Speed
		local addline, addline2, ticklenght, ticky, numx = 0,0,0,0,0
		local ismul = false
		local degreecount = 0
		render.SetScissorRect( 450 * scale, 23 * scale , 1150 * scale, 80 * scale, true ) -- Set our scissor area so the ticks don't leave the boarder
		surface.SetDrawColor(Color(255,255,255,255))
		draw.SimpleText("^","LFS_FONT", 790 * scale, 65 * scale,Color(255,255,255,255))
		draw.SimpleText("180","LFS_FONT",EyeAngle + 789 * scale, 25 * scale, Color(255,255,255,255))
		surface.DrawRect( 450 * scale, 25 * scale, 2 * scale, 50 * scale ) --left frame
		surface.DrawRect( 1149 * scale, 25 * scale, 2 * scale, 50 * scale ) --right frame
	
	
		for i = 1, 36 * Speed do
			degreecount = i == 1 and 180 or degreecount -- Esentally translates to if i == 1 then degreecount = 180 else degreecount = degreecount
			addline = math.Round(addline + 10 / (Speed / TickDist))
			ismul = IsMultipleofTen(tostring(math.abs(addline)))
			if ismul then
				degreecount = degreecount >= 350 and 0 or degreecount +  10 -- Esentally translates to if degreecount >= 350 then degreecount == 0 else degreecount == degreecount + 10
				numx = degreecount >= 100 and 789 or degreecount >= 10 and 793 or 797
				draw.SimpleText(degreecount,"LFS_FONT",EyeAngle + numx * scale + addline * Speed, 25 * scale, Color(255,255,255,255))
				ticklenght = 30
				ticky = 45
			else
				ticklenght = 20
				ticky = 55
			end
	
			surface.DrawRect( EyeAngle + (800 * scale) + addline * Speed, ticky * scale, 2, ticklenght )
		end
	
		addline = 0
	
		for i = 1, 36 * Speed do
			degreecount = i == 1 and 180 or degreecount
			addline = math.Round(addline - 10 / (Speed / TickDist))
			Alpha = 255
			ismul = IsMultipleofTen(tostring(math.abs(addline)))
			if ismul then
				degreecount = degreecount <= 0 and 350 or degreecount -  10
				numx = degreecount >= 100 and 789 or degreecount >= 10 and 793 or 797
				draw.SimpleText(degreecount,"LFS_FONT",EyeAngle + numx * scale + addline * Speed, 25 * scale, Color(255,255,255,255))
				ticklenght = 30
				ticky = 45
			else
				ticklenght = 20
				ticky = 55
			end
	
			surface.DrawRect( EyeAngle + (800 * scale) + addline * Speed, ticky * scale, 2, ticklenght )
		end
	
		render.SetScissorRect( 0, 0, 0, 0, false )

		draw.SimpleText( "FLIR: OFF", "LFS_FONT", X-40, Y-225, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		surface.SetDrawColor( Color(125,125,125,255) )
		surface.SetMaterial(zoom_mat ) 
		surface.DrawTexturedRectRotated( X + X * 0.5, Y * 0.5, X, Y, 0 )
		surface.DrawTexturedRectRotated( X + X * 0.5, Y + Y * 0.5, Y, X, 270 )
		surface.DrawTexturedRectRotated( X * 0.5, Y * 0.5, Y, X, 90 )
		surface.DrawTexturedRectRotated( X * 0.5, Y + Y * 0.5, X, Y, 180 )
	
		surface.SetDrawColor( Color(225,225,255,255) )
		surface.DrawRect( X, Y-120, 5, 80 )--Cross up
		surface.DrawRect( X, Y+40, 5, 80 )--Cross down
		surface.DrawRect( X-120, Y, 80, 5 )--Cross left
		surface.DrawRect( X+40, Y, 80, 5 )--Cross right
	
		surface.DrawRect( X-120, Y-120, 5, 80 )--Corner top left down
		surface.DrawRect( X-120, Y-120, 80, 5 )--Corner top left rght
		
		surface.DrawRect( X+45, Y+120, 80,5 )--Corner bottom right left
		surface.DrawRect( X+120, Y+45, 5,80 )--Corner bottom right up
	
		surface.DrawRect( X-120, Y+120, 80,5 )--Corner bottom left right
		surface.DrawRect( X-120, Y+45, 5,80 )--Corner bottom left up
	
		surface.DrawRect( X+45, Y-120, 80,5 )--Corner top right left
		surface.DrawRect( X+120, Y-120, 5,80 )--Corner top right donw
	
		draw.SimpleText( "THR", "LFS_FONT", X-80, Y-150, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( Throttle.."%" , "LFS_FONT", X+50, Y-150, Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "IAS", "LFS_FONT", X+180, Y-10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( speed, "LFS_FONT",X+180, Y-25, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "km/h", "LFS_FONT", X+160, Y+5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "ALT", "LFS_FONT", X-200,Y-10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( alt , "LFS_FONT", X-200,Y-25, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "m", "LFS_FONT", X-200,Y+5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "MISSILE", "LFS_FONT", X+85, Y+135, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( self:GetAmmoSecondary(), "LFS_FONT", X+105, Y+150, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "CANNON", "LFS_FONT", X-35, Y+135, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( self:GetAmmoTertiary(), "LFS_FONT", X-15, Y+150, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "FLARES", "LFS_FONT", X-30, Y-185, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( self:GetFlares(), "LFS_FONT", X-10, Y-200, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "FUEL", "LFS_FONT", X-20, Y+185, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( self:GetFuel(), "LFS_FONT", X-20, Y+200, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end
	if Weapon == 0 and self:GetLoadout() == 0 or self:GetLoadout() == 1 or self:GetLoadout() == 10 or self:GetLoadout() == 11 then
		if FLIR == 0 then
			draw.SimpleText( "WEAPON: CANNON", "LFS_FONT", X-85, Y+235, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif FLIR == 1 then
			draw.SimpleText( "WEAPON: CANNON", "LFS_FONT", X-85, Y+235, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif FLIR == 2 then
			draw.SimpleText( "WEAPON: CANNON", "LFS_FONT", X-85, Y+235, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
	elseif Weapon == 0 and self:GetLoadout() >= 2 and self:GetLoadout() <= 9 then
		if FLIR == 0 then
			draw.SimpleText( "WEAPON: CANNON", "LFS_FONT", X-85, Y+235, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif FLIR == 1 then
			draw.SimpleText( "WEAPON: CANNON", "LFS_FONT", X-85, Y+235, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif FLIR == 2 then
			draw.SimpleText( "WEAPON: CANNON", "LFS_FONT", X-85, Y+235, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
	elseif Weapon == 1 and self:GetLoadout() == 0 or self:GetLoadout() == 1 or self:GetLoadout() == 10 or self:GetLoadout() == 11 then
		if FLIR == 0 then
			draw.SimpleText( "WEAPON: CANNON", "LFS_FONT", X-85, Y+235, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif FLIR == 1 then
			draw.SimpleText( "WEAPON: CANNON", "LFS_FONT", X-85, Y+235, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif FLIR == 2 then
			draw.SimpleText( "WEAPON: CANNON", "LFS_FONT", X-85, Y+235, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
	elseif Weapon == 1 and self:GetLoadout() >= 4 and self:GetLoadout() <= 9 then
		if FLIR == 0 then
			draw.SimpleText( "WEAPON: AGM", "LFS_FONT", X-65, Y+235, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif FLIR == 1 then
			draw.SimpleText( "WEAPON: AGM", "LFS_FONT", X-65, Y+235, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif FLIR == 2 then
			draw.SimpleText( "WEAPON: AGM", "LFS_FONT", X-65, Y+235, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
	elseif Weapon == 1 and self:GetLoadout() == 2 or self:GetLoadout() == 3 then
		if FLIR == 0 then
			draw.SimpleText( "WEAPON: AAM", "LFS_FONT", X-65, Y+235, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif FLIR == 1 then
			draw.SimpleText( "WEAPON: AAM", "LFS_FONT", X-65, Y+235, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif FLIR == 2 then
			draw.SimpleText( "WEAPON: AAM", "LFS_FONT", X-65, Y+235, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
	end
end

function ENT:LFSHudPaint( X, Y, data ) -- driver only
	draw.SimpleText( "TRI", "LFS_FONT", 10, 135, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( self:GetAmmoTertiary(), "LFS_FONT", 120, 135, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( "FLR", "LFS_FONT", 10, 160, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( self:GetFlares(), "LFS_FONT", 120, 160, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( "FUEL", "LFS_FONT", 10, 185, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( self:GetFuel(), "LFS_FONT", 120, 185, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	local THR = RPM / self:GetLimitRPM()
	local CurDist = (LocalPlayer():GetViewEntity():GetPos() - self:GetPos()):Length()
	self.PitchOffset = self.PitchOffset and self.PitchOffset + (math.Clamp((CurDist - self.OldDist) * FrameTime() * 300,-40,40) - self.PitchOffset) * FrameTime() * 5 or 0

	if self.ENG then
		self.ENG:ChangePitch( math.Clamp(math.min(RPM / self:GetIdleRPM(),1) * 95 + Doppler + THR * 20,0,255) )
		self.ENG:ChangeVolume( math.Clamp( Pitch, 0.8,1) )
	end
	
	if self.ENG2 then
		self.ENG2:ChangePitch( math.Clamp(math.min(RPM / self:GetIdleRPM(),1) * 95 + Doppler + THR * 20,0,255) )
		self.ENG2:ChangeVolume( math.Clamp( Pitch, 0.8,1) )
	end
	
	if self.EXH then
		self.EXH:ChangePitch(  math.Clamp( 80 + Pitch * 40 + Doppler,0,255) )
		self.EXH:ChangeVolume( math.Clamp( Pitch, 0.8,1) )
	end
	
	if self.BNK then
		self.BNK:ChangePitch(  math.Clamp( 60 + Pitch * 40 + Doppler,0,255) )
		self.BNK:ChangeVolume( math.Clamp( Pitch, 0.3,1) )
	end
	
	if self.DMG then
		self.DMG:ChangePitch(  math.Clamp( 80 + Pitch * 40 + Doppler,0,255) )
		self.DMG:ChangeVolume( self:GetHP() < self:GetMaxHP() / 2 and 1 or 0, .5 )
	end
	
	if self.DMG2 then
		self.DMG2:ChangePitch(  math.Clamp( 80 + Pitch * 40 + Doppler,0,255) )
		self.DMG2:ChangeVolume( self:GetHP() < self:GetMaxHP() / 3 and 1 or 0, .5 )
	end
	
	if self.BEEP then
		self.BEEP:ChangePitch( 100 )
		self.BEEP:ChangeVolume( self:GetHP() < 150 and 1 or 0, .5 )
	end
end
function ENT:EngineActiveChanged( bActive )
	
	if bActive then
		self.ENG = CreateSound( self, "ENGINE_IDLE" )
		self.ENG:PlayEx(0,0)
		self.ENG2 = CreateSound( self, "ENGINE_RUN" )
		self.ENG2:PlayEx(0,0)
		self.EXH = CreateSound( self, "EXHAUST" )
		self.EXH:PlayEx(0,0)
		self.BNK = CreateSound( self, "BANK" )
		self.BNK:PlayEx(0,0)
		self.DMG = CreateSound( self, "DAMAGE" )
		self.DMG:PlayEx(0,0)
		self.DMG2 = CreateSound( self, "DAMAGE_2" )
		self.DMG2:PlayEx(0,0)
		self.BEEP = CreateSound( self, "BEEP" )
		self.BEEP:PlayEx(0,0)
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
	if self.ENG2 then
		self.ENG2:Stop()
	end
	if self.EXH then
		self.EXH:Stop()
	end
	if self.BNK then
		self.BNK:Stop()
	end
	if self.DMG then
		self.DMG:Stop()
	end
	if self.DMG2 then
		self.DMG2:Stop()
	end
	if self.BEEP then
		self.BEEP:Stop()
	end
end
function ENT:AnimFins()
end
function ENT:AnimRotor()
	local RotorBlown = self:GetRotorDestroyed()
	
	if not RotorBlown then
		local RPM = self:GetRPM()
		local PhysRot = RPM < 700
		local Rot = Angle(0,self.RPM,0)
		local Rot2 = Angle(0,0,self.RPM)
		self.RPM = self.RPM and (self.RPM + RPM * FrameTime() * (PhysRot and 4 or 1.1)) or 0
		
		self:ManipulateBoneAngles( 1, Rot )
		self:ManipulateBoneAngles( 2, Rot2 )
		self:InvalidateBoneCache()
	end
end
function ENT:AnimCabin()
	local bOn = self:GetActive()
	
	local TVal = bOn and 0 or 1
	
	local Speed = FrameTime() * 1
	
	self.SMcOpen = self.SMcOpen and self.SMcOpen + math.Clamp(TVal - self.SMcOpen,-Speed,Speed) or 0

	self:ManipulateBoneAngles( 3 , Angle(0,self.SMcOpen * -90,0) )
	self:ManipulateBoneAngles( 4 , Angle(0,self.SMcOpen * 90,0) )
end
function ENT:AnimLandingGear()
end
function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end
	
	self.nextEFX = self.nextEFX or 0
	
	local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	if self.nextEFX < CurTime() then
		self.nextEFX = CurTime() + 0.05

		local effectdata = EffectData()
			effectdata:SetOrigin( Vector(-67,0,98) )
			effectdata:SetAngles( Angle(-15,0,0) )
			effectdata:SetMagnitude( 0.8 + ((self:GetHP()/1000) * -1) ) 
			effectdata:SetEntity( self )
		util.Effect( "lfs_exhaust", effectdata )
	end
end
