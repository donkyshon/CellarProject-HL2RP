--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

ENT.TailPos = Vector(-173.242,0,15.6829)
ENT.NEXTPRESS_TOGGLE = 0
ENT.NEXTPRESS_ZOOMIN = 0
ENT.NEXTPRESS_ZOOMOUT = 0
ENT.NEXTPRESS_LOCK = 0
ENT.NEXTPRESS_FLIR = 0
ENT.FLIR = 0
ENT.ZOOM = 0
ENT.Display1_Pos = Vector(79,16.1229,52.6551)
ENT.Display1_Ang = Angle(-3,270+2.5,64.428)
ENT.Display2_Pos = Vector(135.77,2.33955,32.1574)
ENT.Display2_Ang = Angle(0.2,270,63.6973)
ENT.BoneBlackList = {
	[3] = true,
	[4] = true,
	[15] = true,
}
local mat = CreateMaterial("UnlitGeneric","GMODScreenspace",{ })
local ply = LocalPlayer() 
local CVar = GetConVar("gred_cl_lfs_apache_enable_screens") 
timer.Simple(1,function() 
	local ply = LocalPlayer() 
	local CVar = GetConVar("gred_cl_lfs_apache_enable_screens") 
end)

local letters = {
	[0] = "N",
	[90] = "E",
	[180] = "S",
	[270] = "W",
	[360] = "N",
}


function ENT:Draw()
	self:DrawModel()
	ply = IsValid(ply) and ply or LocalPlayer()
	if self.Rt and ply.lfsGetPlane then
		if ply:lfsGetPlane() != self then return end
		CVar = CVar or GetConVar("gred_cl_lfs_apache_enable_screens") 
		if CVar:GetInt() != 1 then return end
		if ply == self:GetDriver() and !ply:GetVehicle():GetThirdPersonMode() then
			local w,h = 5,5
			cam.Start3D2D(self:LocalToWorld(self.Display1_Pos),self:LocalToWorldAngles(self.Display1_Ang),0.54)
				mat:SetTexture("$basetexture",self.Rt)
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(0,0,w,h)
			cam.End3D2D()
		elseif ply == self:GetGunner() and !ply:GetVehicle():GetThirdPersonMode() then
			local w,h = 9,9
			cam.Start3D2D(self:LocalToWorld(self.Display2_Pos),self:LocalToWorldAngles(self.Display2_Ang),0.56)
				mat:SetTexture("$basetexture",self.Rt)
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(0,0,w,h)
			cam.End3D2D()
		end
	end
end

function ENT:RenderScreens(pos,Ang,fov)
	if !self:GetEngineActive() then self.Rt = nil return end
	local att = self:GetAttachment(2)
	local ang
	local fov
	if self.CannonShooting and self:Get30mm() > 0 then
		ang = att.Ang + Angle(0,0,math.random(-1.5,1.5))
		timer.Simple(0.02,function() if IsValid(self) then
			ang = att.Ang
			end
		end)
	else
		ang = att.Ang
	end
	if self.ZOOM == 0 then
		fov = fov
	elseif self.ZOOM == 1 then
		fov = 60
	elseif self.ZOOM == 2 then
		fov = 40
	elseif self.ZOOM == 3 then
		fov = 20
	elseif self.ZOOM == 4 then
		fov = 10
	end
	
	self.Rt = GetRenderTarget("gred_lfs_apache_"..self:EntIndex(),1024,1024,false)
	local oldRT = render.GetRenderTarget()
	
	render.SetRenderTarget(self.Rt)
		render.Clear(0,0,0,255)
		-- self:ApacheHUD(true)
		surface.SetDrawColor(255,255,255,255)
		render.RenderView({
			x = 0,
			y = 0,
			w = 1024,
			h = 1024,
			origin = att.Pos,
			angles = ang,
			fov = fov,
			drawpostprocess = false,
			drawhud = false,
			drawmonitors = false,
			drawviewmodel = false,
			dopostprocess = false,
			bloomtone = false,
		})
	render.SetRenderTarget(oldRT)
end

function ENT:LFSCalcViewFirstPerson(view,plr)
	local Gunner = self:GetGunner()
	local Driver = self:GetDriver()
	local GunnerValid = IsValid(Gunner)
	local DriverValid = IsValid(Driver)
	local DriverKeyDown = DriverValid and plr == Driver and Driver:lfsGetInput("FREELOOK")
	
	local HasGunner = GunnerValid or (!GunnerValid and DriverKeyDown)
	if HasGunner then
		Driver = GunnerValid and Gunner or Driver
		if plr != Driver then return view end
		if self.ShouldCalcView then
			local att = self:GetAttachment(2)
			view.origin = att.Pos
			if self.CannonShooting and self:Get30mm() > 0 then
				view.angles = att.Ang + Angle(0,0,math.random(-1.5,1.5))
				timer.Simple(0.02,function() if IsValid(self) then
					view.angles = att.Ang
					end
				end)
			else
				view.angles = att.Ang
			end
			if self.ZOOM == 0 then
				view.fov = view.fov
			elseif self.ZOOM == 1 then
				view.fov = 60
			elseif self.ZOOM == 2 then
				view.fov = 40
			elseif self.ZOOM == 3 then
				view.fov = 20
			elseif self.ZOOM == 4 then
				view.fov = 10
			end
			
		end
	end
	return view
end

function ENT:GetCalcViewFilter(ent)
	return ent != self.Tail
end

function ENT:LFSCalcViewThirdPerson(view,plr)
	view.origin = plr:EyePos()
	local Parent = plr:lfsGetPlane()
	local Pod = plr:GetVehicle()
	local radius = 550
	radius = radius + radius * Pod:GetCameraDistance()
	local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
	local WallOffset = 4
	local tr = util.TraceHull({
		start = view.origin,
		endpos = TargetOrigin,
		filter = function(e)
			local c = e:GetClass()
			local collide = not c:StartWith("prop_physics") and not c:StartWith("prop_dynamic") and not c:StartWith("prop_ragdoll") and not e:IsVehicle() and not c:StartWith("gmod_") and not c:StartWith("player") and not e.LFS and Parent:GetCalcViewFilter(e)
			
			return collide
		end,
		mins = Vector(-WallOffset,-WallOffset,-WallOffset),
		maxs = Vector(WallOffset,WallOffset,WallOffset),
	})
	view.origin = tr.HitPos
	
	if tr.Hit and not tr.StartSolid then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end
	
	return view
end

function ENT:LFSHudPaint(X,Y,data,plr) -- driver only
	local y = 85
	local hasHellfire
	local hasHydra
	local hasWP
	for k,v in pairs(self.Weaponery) do
		if v.Type == 3 then hasHellfire = true
		elseif v.Type == 1 or v.Type == 2 then hasHydra = true end
	end
	draw.SimpleText("M230","LFS_FONT",10,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
	draw.SimpleText(self:Get30mm(),"LFS_FONT",120,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
	y = y + 25
	if hasHellfire then
		draw.SimpleText("HELLFIRES","LFS_FONT",10,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText(self:GetHellfires(),"LFS_FONT",120,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		y = y + 25
	end
	if hasHydra then
		draw.SimpleText("HYDRAS","LFS_FONT",10,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText(self:GetHydras(),"LFS_FONT",120,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		y = y + 25
	end
	-- if self:GetEnableStingers() then
		-- draw.SimpleText("STINGERS","LFS_FONT",10,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		-- draw.SimpleText(self:GetStingers(),"LFS_FONT",120,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
	-- end
	plr = plr or self:GetDriver()
	if !IsValid(self:GetGunner()) and plr.lfsGetInput and plr:lfsGetInput("FREELOOK") then
		if self.ShouldCalcView and !plr:GetVehicle():GetThirdPersonMode() then
			self:ApacheHUD()
		end
	end
end

function ENT:LFSHudPaintPassenger(X,Y,plr)
	local y = 0
	local hasHellfire
	local hasHydra
	for k,v in pairs(self.Weaponery) do
		if v.Type == 3 then hasHellfire = true
		elseif v.Type == 1 or v.Type == 2 then hasHydra = true end
	end
	draw.SimpleText("M230","LFS_FONT",10,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
	draw.SimpleText(self:Get30mm(),"LFS_FONT",120,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
	y = y + 25
	if hasHellfire then
		draw.SimpleText("HELLFIRES","LFS_FONT",10,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText(self:GetHellfires(),"LFS_FONT",120,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		y = y + 25
	end
	if hasHydra then
		draw.SimpleText("HYDRAS","LFS_FONT",10,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText(self:GetHydras(),"LFS_FONT",120,y,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
	end
	plr = plr or self:GetDriver()
	if !IsValid(self:GetGunner()) and Driver:lfsGetInput("FREELOOK") then
		if self.ShouldCalcView and !plr:GetVehicle():GetThirdPersonMode() then
			self:ApacheHUD()
		end
	end
	if self.ShouldCalcView and !plr:GetVehicle():GetThirdPersonMode() then
		self:ApacheHUD()
	end
end

function ENT:ApacheHUD(isScreen)
	local center = {x = ScrW()*0.5,y = ScrH()*0.5}
	local f
	surface.SetDrawColor(255,255,255,isScreen and 255 or 150)
	if self.FLIR == 0 then
		DrawColorModify({
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast" ] = 1,
			["$pp_colour_colour" ] = 0.01,
			["$pp_colour_mulr" ] = 0,
			["$pp_colour_mulg" ] = 0,
			["$pp_colour_mulb" ] = 0,
		})
	elseif self.FLIR == 1 then
		f = function()
			surface.SetFont("LFS_FONT")
			surface.SetTextColor(color_black)
			surface.SetTextPos(center.x-150,center.y-165)
			surface.DrawText("FLIR")
			surface.SetDrawColor(0,0,0,isScreen and 255 or 200)
		end
		cam.Start3D()
		for k,v in pairs(ents.GetAll()) do
			if(v:IsNPC()) or (v:IsPlayer() and v:Alive()) or (v:IsVehicle() and !IsValid(v:GetParent())) then
				render.SuppressEngineLighting(true)
				render.SetColorModulation(0,0,0)
				render.SetBlend(1)
				v:DrawModel()
				render.SuppressEngineLighting(false)
			else
				-- local c = v:GetClass()
				-- if c == "prop_physics" or c == "prop_dynamic" or c == "prop_ragdoll" then
				if IsValid(v) then
					render.SuppressEngineLighting(true)
					render.SetColorModulation(0,0,0)
					render.SetBlend(0.8)
					v:DrawModel()
					render.SuppressEngineLighting(false)
				end
			end
		end
		cam.End3D()
		DrawColorModify({
			["$pp_colour_addr"] = 0.5,
			["$pp_colour_addg"] = 0.5,
			["$pp_colour_addb"] = 0.5,
			["$pp_colour_brightness"] = 0.5,
			["$pp_colour_contrast" ] = 0.5,
			["$pp_colour_colour" ] = 0.01,
			["$pp_colour_mulr" ] = 0,
			["$pp_colour_mulg" ] = 0,
			["$pp_colour_mulb" ] = 0,
		})
	elseif self.FLIR == 2 then
		f = function()
			surface.SetFont("LFS_FONT")
			surface.SetTextColor(color_white)
			surface.SetTextPos(center.x-150,center.y-165)
			surface.DrawText("FLIR")
		end
		cam.Start3D()
		for k,v in pairs(ents.GetAll()) do
			if(v:IsNPC()) or (v:IsPlayer() and v:Alive()) or (v:IsVehicle() and !IsValid(v:GetParent())) then
				render.SuppressEngineLighting(true)
				render.SetColorModulation(255,255,255)
				render.SetBlend(1)
				v:DrawModel()
				render.SuppressEngineLighting(false)
			else
				-- local c = v:GetClass()
				-- if c == "prop_physics" or c == "prop_dynamic" or c == "prop_ragdoll" then
				if IsValid(v) then
					render.SuppressEngineLighting(true)
					render.SetColorModulation(255,255,255)
					render.SetBlend(0.8)
					v:DrawModel()
					render.SuppressEngineLighting(false)
				end
			end
		end
		DrawColorModify({
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0.1,
			["$pp_colour_contrast" ] = 0.4,
			["$pp_colour_colour" ] = 0.01,
			["$pp_colour_mulr" ] = 0,
			["$pp_colour_mulg" ] = 0,
			["$pp_colour_mulb" ] = 0,
		})
		cam.End3D()
	elseif self.FLIR == 3 then
		self.FLIR = 0
	end
	-- cam.Start2D()
	if f then f() end
	surface.DrawRect(center.x-100,center.y-2,90,4)
	surface.DrawRect(center.x+5.5,center.y-2,95,4)
	
	surface.DrawRect(center.x-2.5,center.y+5,4,95)
	surface.DrawRect(center.x-2.5,center.y-100,4,95)
	
	
	surface.DrawRect(center.x-15.5,center.y+100,30,4)
	surface.DrawRect(center.x-15.5,center.y-104,30,4)
	
	surface.DrawRect(center.x+100,center.y-15,4,30)
	surface.DrawRect(center.x-104,center.y-15,4,30)
	
	if self.ZOOM == 3 then
		surface.DrawLine(center.x+160,center.y+150,center.x+160,center.y+85)
		surface.DrawLine(center.x+160,center.y+150,center.x+105,center.y+150)
		
		surface.DrawLine(center.x-160,center.y-150,center.x-160,center.y-85)
		surface.DrawLine(center.x-160,center.y-150,center.x-105,center.y-150)
		
		surface.DrawLine(center.x+160,center.y-150,center.x+160,center.y-85)
		surface.DrawLine(center.x+160,center.y-150,center.x+105,center.y-150)
		
		surface.DrawLine(center.x-160,center.y+150,center.x-160,center.y+85)
		surface.DrawLine(center.x-160,center.y+150,center.x-105,center.y+150)
	
	
	elseif self.ZOOM == 2 then
		surface.DrawLine(center.x+150,center.y+140,center.x+150,center.y+85)
		surface.DrawLine(center.x+150,center.y+140,center.x+105,center.y+140)
		
		surface.DrawLine(center.x-150,center.y-140,center.x-150,center.y-85)
		surface.DrawLine(center.x-150,center.y-140,center.x-105,center.y-140)
		
		surface.DrawLine(center.x+150,center.y-140,center.x+150,center.y-85)
		surface.DrawLine(center.x+150,center.y-140,center.x+105,center.y-140)
		
		surface.DrawLine(center.x-150,center.y+140,center.x-150,center.y+85)
		surface.DrawLine(center.x-150,center.y+140,center.x-105,center.y+140)
	
	elseif self.ZOOM == 1 then
		surface.DrawLine(center.x+140,center.y+130,center.x+140,center.y+85)
		surface.DrawLine(center.x+140,center.y+130,center.x+105,center.y+130)
		
		surface.DrawLine(center.x-140,center.y-130,center.x-140,center.y-85)
		surface.DrawLine(center.x-140,center.y-130,center.x-105,center.y-130)
		
		surface.DrawLine(center.x+140,center.y-130,center.x+140,center.y-85)
		surface.DrawLine(center.x+140,center.y-130,center.x+105,center.y-130)
	
		surface.DrawLine(center.x-140,center.y+130,center.x-140,center.y+85)
		surface.DrawLine(center.x-140,center.y+130,center.x-105,center.y+130)
	
	elseif self.ZOOM == 0 then
		surface.DrawLine(center.x+130,center.y+120,center.x+130,center.y+85)
		surface.DrawLine(center.x+130,center.y+120,center.x+105,center.y+120)
		
		surface.DrawLine(center.x-130,center.y-120,center.x-130,center.y-85)
		surface.DrawLine(center.x-130,center.y-120,center.x-105,center.y-120)
		
		surface.DrawLine(center.x+130,center.y-120,center.x+130,center.y-85)
		surface.DrawLine(center.x+130,center.y-120,center.x+105,center.y-120)
		
		surface.DrawLine(center.x-130,center.y+120,center.x-130,center.y+85)
		surface.DrawLine(center.x-130,center.y+120,center.x-105,center.y+120)
	end
	
	local ang = self:GetAngles()
	
	local offset = 180
	local width =  500
	local spacing = (width * 2) / 360
	local numOfLines = width / spacing
	local fadeDistMultiplier = 1
	local fadeDistance = (width/2) / fadeDistMultiplier

	for i = (math.Round(ang.y) - numOfLines/2) % 360,((math.Round(ang.y) - numOfLines/2) % 360) + numOfLines do
		local x = (960 + (width/2 * 2)) - (((i - ang.y - offset) % 360) * spacing)

		if i % 15 == 0 and i > 0 then
			local num = (360 - (i % 360))
			local text = letters[num] and letters[num] or ((num/10 == (math.modf(num/10)) and num/10 or ""))
			local font = type(text) == "string" and "LFS_FONT" or "LFS_FONT"..1.8
			surface.SetFont("LFS_FONT")
			local w,h = surface.GetTextSize(text)
			surface.SetTextColor(color_white)
			
			if text != "" then
				surface.DrawRect(x-3,54,3,30)
			else
				surface.DrawRect(x-15,60,2,20)
				surface.DrawRect(x+15,60,2,20)
			end
			surface.SetTextPos(x - w/2,20)
			surface.DrawText(text)
		end
	end
	
	if self.ShouldLock then
		surface.SetFont("LFS_FONT")
		surface.SetTextColor(color_white)
		surface.SetTextPos(center.x-30,center.y+150)
		surface.DrawText("POINT")
	end
	-- cam.End2D()
end

-----------------------------

function ENT:AnimFins()
	if not self.Bones then gred.UpdateBoneTable(self) return end
	local FT = FrameTime() * 10
	local Pitch = self:GetRotPitch()
	local Yaw = self:GetRotYaw()
	local Roll = -self:GetRotRoll()
	
	if self.TailDestroyed then
		self.snd.BEEP_CRASH:Play()
	end
	---------------------------
	
	self.smPitch = self.smPitch and self.smPitch + (Pitch - self.smPitch) * FT or 0
	self.smYaw = self.smYaw and self.smYaw + (Yaw - self.smYaw) * FT or 0
	self.smRoll = self.smRoll and self.smRoll + (Roll - self.smRoll) * FT or 0
	
	local Ang_pedal = Vector(0,0,self.smYaw*2)
	gred.ManipulateBonePosition(self,"pilot_pedal_l",Ang_pedal)
	gred.ManipulateBonePosition(self,"pilot_pedal_r",-Ang_pedal)
	gred.ManipulateBonePosition(self,"gunner_pedal_l",Ang_pedal)
	gred.ManipulateBonePosition(self,"gunner_pedal_r",-Ang_pedal)
	self.Tail = IsValid(self.Tail) and self.Tail or self:GetNWEntity("Tail")
	if IsValid(self.Tail) then
		local Ang_elevator = Angle(0,0,self.smPitch*-20)
		self.Tail:ManipulateBoneAngles(2,Ang_elevator)
	else
		self:RequestTail()
	end
	
	local Ang_stick = Angle(0,-self.smRoll*50,self.smPitch*10)
	gred.ManipulateBoneAngles(self,"cockpit_pilot_stick",Ang_stick)
	gred.ManipulateBoneAngles(self,"gunner_stick",Ang_stick)
	
	local Throttle = (math.max(math.Round(((self:GetRPM() - self:GetIdleRPM()) / (self:GetMaxRPM() - self:GetIdleRPM())) * 100,0)))
	local Ang_throttle = Angle(0,0,-Throttle/8)
	gred.ManipulateBoneAngles(self,"pilot_collective",Ang_throttle)
	gred.ManipulateBoneAngles(self,"gunner_collective",Ang_throttle)
	
	
	local Ang_compass = Angle(-self:GetAngles().y+290) -- Made it like that so it matches the camera's compass
	gred.ManipulateBoneAngles(self,"compass",Ang_compass)
	
	self:SetBodygroup(1,self:GetEngineActive() and 1 or 0)
	------------------------------

	local IsAI = self:GetAI()
	local Driver = IsAI and self or self:GetDriver()
	local Gunner = self:GetGunner()
	local DriverValid = IsValid(Driver)
	local GunnerValid = IsValid(Gunner)
	local DriverKeyDown = (DriverValid and ply == Driver and Driver:lfsGetInput("FREELOOK")) or IsAI
	local Target
	local TargetValid
	if IsAI then 
		Target = self.AITarget
		TargetValid = IsValid(Target)
	end
	-- PrintTable(self.ControlInput)
	local HasGunner = GunnerValid or (!GunnerValid and DriverKeyDown)
	
	if not DriverValid and not GunnerValid and not HasGunner then
		
		if self.CannonShooting then
			self.CannonShooting = false
			self.snd.CANNON_CLOSE_LOOP:Stop()
			self.snd.CANNON_CLOSE_STOP:Play()
			self.snd.CANNON_FAR_LOOP:Stop()
			self.snd.CANNON_CAM_LOOP:Stop()
			self.snd.CANNON_CAM_STOP:Stop()
			self.snd.CANNON_FAR_STOP:Play()
		end
		self.ShouldCalcView = false
		
	elseif (IsAI and TargetValid) or (HasGunner and !IsAI) or GunnerValid then
		if GunnerValid then Driver = Gunner end
		
		local att = self:GetAttachment(2)
		
		if ply == Driver then
			local ct = CurTime()
			if !Driver.lfsGetInput then
				print("[LFS AH-64] ERROR! MISSING FUNCTION 'lfsGetInput' ! IS LFS UP TO DATE?")
			else
				if Driver:lfsGetInput("TOGGLECAMERA") then
					if self.NEXTPRESS_TOGGLE < ct then
						self.NEXTPRESS_TOGGLE = ct + 0.3
						self.ShouldCalcView = !self.ShouldCalcView
					end
				elseif Driver:lfsGetInput("FLIRCAMERA") then
					if self.NEXTPRESS_FLIR < ct then
						self.NEXTPRESS_FLIR = ct + 0.3
						self.FLIR = self.FLIR + 1 > 3 and 0 or self.FLIR + 1
						
					end
				elseif Driver:lfsGetInput("ZOOMINCAMERA") then
					if self.NEXTPRESS_ZOOMIN < ct then
						self.NEXTPRESS_ZOOMIN = ct + 0.3
						self.ZOOM = self.ZOOM + 1 > 4 and self.ZOOM or self.ZOOM + 1
						
					end
				elseif Driver:lfsGetInput("ZOOMOUTCAMERA") then
					if self.NEXTPRESS_ZOOMOUT < ct then
						self.NEXTPRESS_ZOOMOUT = ct + 0.3
						self.ZOOM = self.ZOOM - 1 < 0 and self.ZOOM or self.ZOOM - 1
						
					end
				elseif Driver:lfsGetInput("POINTCAMERA") then
					if self.NEXTPRESS_LOCK < ct then
						self.NEXTPRESS_LOCK = ct + 0.3
						self.ShouldLock = !self.ShouldLock
						if self.ShouldLock then
							self.PointPos = util.QuickTrace(att.Pos,att.Pos + att.Ang:Forward()*9999999,self).HitPos
							net.Start("gred_apache_pointpos")
								net.WriteEntity(self)
								net.WriteVector(self.PointPos)
							net.SendToServer()
						else
							net.Start("gred_apache_pointpos_rem")
								net.WriteEntity(self)
							net.SendToServer()
							-- local ANG = att.Ang
							-- ANG:RotateAroundAxis(ANG:Up(),180)
							-- Driver:SetEyeAngles(ANG)
							self.PointPos = nil
						end
					end
				end
			end
		else
			self.ShouldCalcView = false
			-- self.ZOOM = 0
		end
		local AI_Shooting = IsAI and (!GunnerValid and TargetValid) or (GunnerValid and Gunner:KeyDown(IN_ATTACK)) and self:GetFIRING_30MM()
		local Player_Shooting = !IsAI and self:GetFIRING_30MM()
		
		if (AI_Shooting or Player_Shooting) and self:Get30mm() > 0 then -- if the player is shooting
			local p_y = self:GetPoseParameter("camera_yaw")
			local p_p = self:GetPoseParameter("camera_pitch")
			
			if p_p > 0 and p_p < 1 and p_y > 0 and p_y < 1 then
				if ply == Driver and self.ShouldCalcView and !Driver:GetVehicle():GetThirdPersonMode() then
					self.snd.CANNON_CLOSE_STOP:Stop()
					self.snd.CANNON_FAR_STOP:Stop()
					self.snd.CANNON_CLOSE_LOOP:Stop()
					self.snd.CANNON_FAR_LOOP:Stop()
					self.snd.CANNON_CAM_STOP:Stop()
					self.snd.CANNON_CAM_LOOP:Play()
				else
					self.snd.CANNON_CLOSE_STOP:Stop()
					self.snd.CANNON_FAR_STOP:Stop()
					self.snd.CANNON_CAM_LOOP:Stop()
					self.snd.CANNON_CAM_STOP:Stop()
					self.snd.CANNON_CLOSE_LOOP:Play()
					self.snd.CANNON_FAR_LOOP:Play()
				end
				self.CannonShooting = true
			else
				if self.CannonShooting then
					self.CannonShooting = false
					if ply == Driver and self.ShouldCalcView and !Driver:GetVehicle():GetThirdPersonMode() then
						self.snd.CANNON_CLOSE_LOOP:Stop()
						self.snd.CANNON_CLOSE_STOP:Stop()
						self.snd.CANNON_FAR_LOOP:Stop()
						self.snd.CANNON_FAR_STOP:Stop()
						self.snd.CANNON_CAM_LOOP:Stop()
						self.snd.CANNON_CAM_STOP:Play()
					else
						self.snd.CANNON_CAM_LOOP:Stop()
						self.snd.CANNON_CAM_STOP:Stop()
						self.snd.CANNON_CLOSE_LOOP:Stop()
						self.snd.CANNON_FAR_LOOP:Stop()
						self.snd.CANNON_CLOSE_STOP:Play()
						self.snd.CANNON_FAR_STOP:Play()
					end
				end
			end
		else
			if self.CannonShooting then
				self.CannonShooting = false
				if ply == Driver and self.ShouldCalcView and !Driver:GetVehicle():GetThirdPersonMode() then
					self.snd.CANNON_CLOSE_LOOP:Stop()
					self.snd.CANNON_CLOSE_STOP:Stop()
					self.snd.CANNON_FAR_LOOP:Stop()
					self.snd.CANNON_FAR_STOP:Stop()
					self.snd.CANNON_CAM_LOOP:Stop()
					self.snd.CANNON_CAM_STOP:Play()
				else
					self.snd.CANNON_CAM_LOOP:Stop()
					self.snd.CANNON_CAM_STOP:Stop()
					self.snd.CANNON_CLOSE_LOOP:Stop()
					self.snd.CANNON_FAR_LOOP:Stop()
					self.snd.CANNON_CLOSE_STOP:Play()
					self.snd.CANNON_FAR_STOP:Play()
				end
			end
		end
	else 
		self.ShouldCalcView = false
		-- self.ZOOM = 0
		if self.CannonShooting then
			self.CannonShooting = false
			self.snd.CANNON_CAM_LOOP:Stop()
			self.snd.CANNON_CAM_STOP:Stop()
			self.snd.CANNON_CLOSE_LOOP:Stop()
			self.snd.CANNON_CLOSE_STOP:Play()
			self.snd.CANNON_FAR_LOOP:Stop()
			self.snd.CANNON_FAR_STOP:Play()
		end
	end
	local L1 = self:GetLeft1Pod()
	local L2 = self:GetLeft2Pod()
	local R1 = self:GetRight1Pod()
	local R2 = self:GetRight2Pod()
	
	self.Weaponery.L1.Type = L1
	self.Weaponery.L2.Type = L2
	self.Weaponery.R1.Type = R1
	self.Weaponery.R2.Type = R2
	
end

function ENT:AnimRotor()
	if not self.Bones or not self.Bones.toprotor then gred.UpdateBoneTable(self) return end
	local RotorBlown = self:GetRotorDestroyed()

	if RotorBlown ~= self.wasRotorBlown then
		self.wasRotorBlown = RotorBlown
		
		if RotorBlown then
			self:DrawShadow(false) 
		end
	end
	
	if RotorBlown then
		self:SetBodygroup(0,3)
		return
	end
	
	local RPM = math.min(self:GetRPM() * 5,self:GetMaxRPM())
	if RPM < 1800 then
		self:SetBodygroup(0,0)
	elseif RPM >= 1800 and RPM < 3000 then
		self:SetBodygroup(0,1)
	elseif RPM >= 3000 then
		self:SetBodygroup(0,2)
	end
	self.RPM = self.RPM and (self.RPM + RPM * FrameTime() * 0.5) or 0
	
	local Rot1 = Angle(-self.RPM)
	Rot1:Normalize()
	gred.ManipulateBoneAngles(self,"toprotor",Rot1)
	self.Tail = IsValid(self.Tail) and self.Tail or self:GetNWEntity("Tail")
	if IsValid(self.Tail) then
		if self.Tail.TailRotorDestroyed then
			self.Tail:SetBodygroup(0,3)
		else
			local Rot2 = Angle(self.RPM)
			Rot2:Normalize()
			self.Tail:ManipulateBoneAngles(1,Rot2)
			if RPM < 1800 then
				self.Tail:SetBodygroup(0,0)
			elseif RPM >= 1800 and RPM < 3000 then
				self.Tail:SetBodygroup(0,1)
			elseif RPM >= 3000 then
				self.Tail:SetBodygroup(0,2)
			end
		end
	else
		self:RequestTail()
	end
end

-----------------------------

function ENT:CalcEngineSound(RPM,Pitch,Doppler)
	local THR = RPM / self:GetLimitRPM()
	
	if self.snd.ENG_CLOSE and self.snd.ENG_FAR then
		local pitch = math.Clamp(math.min(RPM / self:GetIdleRPM(),1) * 100+ Doppler + THR * 20,0,255)
		local volume = math.Clamp(THR,0.8,1)
		self.snd.ENG_CLOSE:ChangePitch(pitch)
		self.snd.ENG_CLOSE:ChangeVolume(volume)
		
		self.snd.ENG_FAR:ChangePitch(pitch)
		self.snd.ENG_FAR:ChangeVolume(volume)
	end
end

function ENT:EngineActiveChanged(bActive)
	if bActive then
		self.snd.ENG_CLOSE:Play()
		self.snd.ENG_FAR:Play()
	else
		self:SoundStop()
	end
end

-----------------------------

function ENT:ExhaustFX()
end

function ENT:DamageFX()
	local HP = self:GetHP()
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		if HP != 0 and HP < self:GetMaxHP() * 0.5 then
			local effectdata = EffectData()
				effectdata:SetOrigin(self:GetRotorPos() - self:GetForward() * 50)
			util.Effect("lfs_blacksmoke",effectdata)
		end
		if self.TailDestroyed then
			local effectdata = EffectData()
				effectdata:SetOrigin(self:LocalToWorld(self.TailPos))
			util.Effect("lfs_blacksmoke",effectdata)
		end
		
	end
end

function ENT:Initialize()
	self.snd = {}
	self.snd["ENG_CLOSE"] = CreateSound(self,"AH64_CLOSE")
	self.snd["ENG_FAR"] = CreateSound(self,"AH64_FAR")
	self.snd["CANNON_CLOSE_LOOP"] = CreateSound(self,"M230_CLOSE")
	self.snd["CANNON_CLOSE_STOP"] = CreateSound(self,"M230_CLOSE_STOP")
	self.snd["CANNON_FAR_LOOP"] = CreateSound(self,"M230_FAR")
	self.snd["CANNON_FAR_STOP"] = CreateSound(self,"M230_FAR_STOP")
	self.snd["CANNON_CAM_LOOP"] = CreateSound(self,"M230_CAM")
	self.snd["CANNON_CAM_STOP"] = CreateSound(self,"M230_CAM_STOP")
	self.snd["BEEP_CRASH"] = CreateSound(self,"BEEP_CRASH")
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
	for k,v in pairs(self.snd) do v:Stop() end
end

function ENT:RequestTail()
	if self.TailDestroyed then return end
	local ct = CurTime()
	self.NextTailRequest = self.NextTailRequest or 0
	if self.NextTailRequest < ct then
		net.Start("gred_apache_request_tail")
			net.WriteEntity(self)
		net.SendToServer()
		self.NextTailRequest = ct + 0.3
	end
end

function ENT:AnimCabin()
end