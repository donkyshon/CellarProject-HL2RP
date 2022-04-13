include("shared.lua")

local soundSpeed = 18005.25
local vector_zero = Vector(0,0,0)

local SMALL_WHIZZ = 7000
local SMALL_WHIZZ_SQR = SMALL_WHIZZ*SMALL_WHIZZ
local BIG_WHIZZ = 13500
local BIG_WHIZZ_SQR = BIG_WHIZZ*BIG_WHIZZ
local LookAngAdd = Angle(10,45)
local OrgCamPos = Vector(250,0,80)
local vector_zero = Vector()
local color_red = Color(255,0,0,150)
local color_green = Color(0,255,0,150)
local color_grey = Color(220,220,220,150)
local CONE_LENGTH = 102.384225 -- millimeters
local VehicleVector = Vector()

local ShellHUDDist = 350
local ShellHUDDistSqr = ShellHUDDist*ShellHUDDist
local ShellHUDColor = Color(100,100,100,0)


local function GetWorldPos(ent,pos)
	local parent = ent:GetParent()
	if IsValid(parent) then
		return GetWorldPos(parent,parent:LocalToWorld(pos or ent:GetPos()))
	else
		return pos or ent:GetPos()
	end
end

local function ApproachVector(Current,Target,Change)
		Current.x = math.Approach(Current.x,Target.x,Change)
		Current.y = math.Approach(Current.y,Target.y,Change)
		Current.z = math.Approach(Current.z,Target.z,Change)
		return Current == Target
	end
	
local function IsInferior(Pos,Offset)
	return Pos.x + Offset < 0 and Pos.y + Offset < 0
end

local function CreateKillCamWindow(ShrapnelTab)
	local HitPos,HitAng,EndLength,NoPen = ShrapnelTab[0][1],ShrapnelTab[0][4],ShrapnelTab[0][2],ShrapnelTab[0][6]
	local ModelPath,ModelSkin,DamageDealt,Penetration,ArmourThickness = ShrapnelTab[0][7],ShrapnelTab[0][8],ShrapnelTab[0][9],ShrapnelTab[0][10],ShrapnelTab[0][11]
	local Caliber = ShrapnelTab[0][5]
	local ShellTypeBodygroup = ShrapnelTab[0][15] or 0
	
	local ScrW,ScrH = ScrW(),ScrH()
	local X,Y = ScrW*0.3,ScrH*0.3
	
	local HitNormal = HitAng:Forward()
	local HitLookAng = HitAng + LookAngAdd
	local HitLookNormal = HitLookAng:Forward()
	
	local Speed = (HitPos - OrgCamPos):Length()
	local CaliberMul = Caliber / 75
	local pos,endpos = HitPos - HitNormal*150*CaliberMul,HitPos + HitNormal * EndLength
	local ConeLength = CONE_LENGTH * CaliberMul * 0.8
	local endposLengthSqr = endpos:LengthSqr() + (ConeLength * ConeLength)
	local ShellSpeed = 50
	local CamPos = OrgCamPos + vector_zero
	
	if IsValid(KILLCAM_WINDOW) then
		KILLCAM_WINDOW:Remove()
	end
	
	
	
	local DPanel = vgui.Create("DPanel")
	KILLCAM_WINDOW = DPanel
	DPanel:SetSize(1,1)
	DPanel:SetPos(ScrW - X*0.5,Y*0.5)
	DPanel.HitPos = HitPos
	DPanel.LookPos = HitPos - HitLookNormal * 80
	DPanel.Paint = function(DPanel,w,h)
		surface.SetDrawColor(55,55,55,255)
		surface.DrawRect(0,0,w,h)
	end
	
	
	
	local DModelPanel = vgui.Create("DModelPanel",DPanel)
	DModelPanel.OldPaint = DModelPanel.Paint
	DModelPanel.OldOnRemove = DModelPanel.OnRemove
	
	DModelPanel:Dock(FILL)
	DModelPanel:SetLookAt(HitPos)
	DModelPanel:SetModel(ModelPath)
	DModelPanel.Entity:SetSkin(ModelSkin)
	DModelPanel.LayoutEntity = function(DModelPanel,Entity) return end 
	DModelPanel:SetCamPos(OrgCamPos)
	
	DModelPanel.Shell = ClientsideModel("models/gredwitch/bombs/75mm_shell.mdl",RENDERGROUP_OTHER)
	DModelPanel.Shell:SetPos(pos)
	DModelPanel.Shell:SetModelScale(CaliberMul)
	DModelPanel.Shell:SetAngles(HitAng)
	DModelPanel.Shell:SetBodygroup(0,1)
	
	DModelPanel.OnRemove = function(DModelPanel)
		DModelPanel:OldOnRemove()
		
		if IsValid(DModelPanel.Shell) then
			DModelPanel.Shell:Remove()
		end
	end
	DModelPanel.Shell:SetBodygroup(1,ShellTypeBodygroup)
	
	DModelPanel.PostDrawModel = function(DModelPanel,ent)
		if !IsValid(DModelPanel.Shell) then return end
		
		pos = pos + HitNormal * FrameTime() * ShellSpeed
		DModelPanel.Shell:SetPos(pos)
		DModelPanel.Shell:DrawModel()
		
		if DModelPanel.WentThrough or pos:LengthSqr() < endposLengthSqr then
			DModelPanel.ImpactPos = HitPos:ToScreen()
			
			if !DModelPanel.WentThrough then
				DModelPanel.WentThroughTime = CurTime()
				
				if NoPen then
					DModelPanel.Shell:Remove()
				end
				
				DModelPanel.WentThrough = true
			end
			
			if NoPen then return end
		end
	end
	
	local SmallRectTime = 0.2
	local BigRectTime = 0.25
	
	DModelPanel.Paint = function(DModelPanel,w,h)
		DModelPanel:OldPaint(w,h)
		if DModelPanel.ImpactPos and DModelPanel.WentThroughTime then
			local x,y = math.floor((DModelPanel.ImpactPos.x / ScrW) * w),math.floor((DModelPanel.ImpactPos.y / ScrH) * h)
			-- draw.DrawText("Hello there!","Trebuchet24",x,y,color_white,TEXT_ALIGN_CENTER)
			local t = CurTime() - DModelPanel.WentThroughTime
			
			local SmallRectVal = math.Clamp(t / SmallRectTime,0,1)
			
			surface.SetDrawColor(0,0,0,255)
			surface.DrawRect(x-1,y-1,6,152*SmallRectVal)
			surface.SetDrawColor(200,200,200,255)
			surface.DrawRect(x,y,4,150*SmallRectVal)
			
			if SmallRectVal >= 1 then
				t = t - SmallRectTime
				local BigRectVal = math.Clamp(t / BigRectTime,0,1)
				
				surface.SetDrawColor(0,0,0,255)
				surface.DrawRect(x + 4,y + 74,149*BigRectVal,1)
				surface.DrawRect(x + 4,y + 150,149*BigRectVal,1)
				surface.DrawRect(x + 152*BigRectVal,y + 74,1,77)
				
				surface.SetDrawColor(200,200,200,255)
				surface.DrawRect(x + 2,y + 75,150*BigRectVal,75)
				
				if BigRectVal >= 1 then
					surface.SetFont("Default")
					
					surface.SetTextColor(0,0,0,255)
					surface.SetTextPos(x + 2,y + 75) 
					surface.DrawText("Damage dealt:")
					surface.SetTextColor(255,0,0,255)
					surface.SetTextPos(x + 2,y + 87) 
					surface.DrawText(DamageDealt)
					
					surface.SetTextColor(0,0,0,255)
					surface.SetTextPos(x + 2,y + 97) 
					surface.DrawText("Penetration:")
					surface.SetTextColor(255,0,0,255)
					surface.SetTextPos(x + 2,y + 109) 
					surface.DrawText(Penetration.."mm")
					
					surface.SetTextColor(0,0,0,255)
					surface.SetTextPos(x + 2,y + 119) 
					surface.DrawText("Effective Armour Thickness:")
					surface.SetTextColor(255,0,0,255)
					surface.SetTextPos(x + 2,y + 131) 
					surface.DrawText(ArmourThickness.."mm")
				end
			end
		end
	end
	
	
	
	
	local DLabel = vgui.Create("DPanel",DPanel)
	DLabel:SetSize(X,32)
	DLabel:SetText("")
	DLabel.Paint = function(DLabel,w,h)
		surface.SetDrawColor(55,55,55,240)
		surface.DrawRect(0,0,w,h)
		if Dead then
			surface.SetDrawColor(color_red.r,color_red.g,color_red.b,color_red.a)
			surface.DrawRect(0,0,w,2)
			draw.DrawText("Crew knocked out","Trebuchet24",w*0.5,6,color_red,1)
		elseif NoPen or Ricochet then
			surface.SetDrawColor(color_grey.r,color_grey.g,color_grey.b,color_grey.a)
			surface.DrawRect(0,0,w,2)
			draw.DrawText(Ricochet and "Ricochet" or "Non penetration","Trebuchet24",w*0.5,6,color_grey,1)
		else
			surface.SetDrawColor(color_green.r,color_green.g,color_green.b,color_green.a)
			surface.DrawRect(0,0,w,2)
			draw.DrawText("Hit","Trebuchet24",w*0.5,6,color_green,1)
		end
	end
	
	
	
	DPanel:MoveTo(ScrW - X,Y*0.5,0.2)
	DPanel:SizeTo(X,1,0.2,0,-1,function()
		DPanel:SizeTo(X,Y,0.2)
		DPanel:MoveTo(ScrW - X,0,0.2,0,-1,function()
			-- DModelPanel:SetLookAt(DPanel.HitPos)
			DModelPanel.LayoutEntity = function(DModelPanel,Entity)
				ApproachVector(CamPos,DPanel.LookPos,Speed*FrameTime())
				DModelPanel:SetCamPos(CamPos)
				return
			end
		end)
	end)
	
	timer.Simple(6.5,function()
		if IsValid(DPanel) then
			DPanel:MoveTo(ScrW - X,Y*0.5,0.2)
			DPanel:SizeTo(X,1,0.2,0,-1,function()
				DPanel:SizeTo(1,1,0.2)
				DPanel:MoveTo(ScrW - X*0.5,Y*0.5,0.2,0,-1,function()
					DPanel:Remove()
				end)
			end)
		end
	end)
end

local function DrawWorldTip(text,pos,tipcol,font,offset)
	pos = pos:ToScreen()
	local black = Color(0,0,0,tipcol.a)
	
	local x = 0
	local y = 0
	local padding = 10
	
	surface.SetFont(font)
	local w,h = surface.GetTextSize(text)
	
	x = pos.x - w*0.5
	y = pos.y - h*0.5 - offset
	
	draw.RoundedBox(8, x-padding-2, y-padding-2, w+padding*2+4, h+padding*2+4, black)
	draw.RoundedBox( 8, x-padding, y-padding, w+padding*2, h+padding*2, tipcol )
	draw.DrawText(text,font,x+w/2,y,black,TEXT_ALIGN_CENTER)
end

local function RemoveHUDPaint(ply)
	hook.Remove("HUDPaint","gred_shell_HUDPaint")
end

local function HUDPaint(ply,ent)
	if !IsValid(ent) then
		RemoveHUDPaint(ply)
		return
	end
	
	if ent != ply:GetNWEntity("PickedUpObject") then
		RemoveHUDPaint(ply)
		return
	end
	
	local pos = ply:GetPos()
	local EntityTable = ents.FindInSphere(pos,ShellHUDDist)
	local vehicle
	
	for k = 1,#EntityTable do
		vehicle = EntityTable[k]
		if vehicle and vehicle.CachedSpawnList and vehicle.ModelBounds and gred.simfphys[vehicle.CachedSpawnList] and gred.simfphys[vehicle.CachedSpawnList].Seats then
		
			VehicleVector.z = vehicle.ModelBounds.maxs.z
			
			ShellHUDColor.a = math.Clamp((1 - pos:DistToSqr(vehicle:LocalToWorld(VehicleVector)) / ShellHUDDistSqr) * 1200,0,255)
			
			local seat
			local v
			for SeatID = 0,#gred.simfphys[vehicle.CachedSpawnList].Seats do
				v = gred.simfphys[vehicle.CachedSpawnList].Seats[SeatID]
				seat = SeatID == 0 and vehicle:GetDriverSeat() or (vehicle.pSeat and vehicle.pSeat[SeatID] or nil)
				
				if v and IsValid(seat) and v[vehicle.Mode] and v[vehicle.Mode].Primary then
					local i = 0
					local TextPos = VehicleVector + seat:GetPos()
					local WeaponTab
					
					for SlotID = 1,#v[vehicle.Mode].Primary do
						WeaponTab = v[vehicle.Mode].Primary[SlotID]
						
						if WeaponTab and WeaponTab.Type == "Cannon" then
							local TotalAmmo = 0
							local Ammo
							local Text = ""
							for ShellID = 1,#WeaponTab.ShellTypes do
								Ammo = seat:GetNWInt(SlotID.."CurAmmo"..ShellID,0)
								TotalAmmo = TotalAmmo + Ammo
								Text = Text..WeaponTab.ShellTypes[ShellID].ShellType..": "..Ammo..(ShellID == #WeaponTab.ShellTypes and "" or "\n")
							end
							Text = WeaponTab.ShellTypes[1].Caliber.."mm cannon\nCapacity: "..TotalAmmo.."/"..WeaponTab.MaxAmmo.."\n"..Text
							DrawWorldTip(Text,TextPos,ShellHUDColor,"GModWorldtip",25*i)
							i = i + 1
						end
					end
				end
			end
		end
	end
end


function ENT:Initialize()
	self.ply = LocalPlayer()
	self.shouldOwnerNotHearSnd = false
	
	if IsValid(self) and self.GetTracerColor then  -- sometimes the function just doesn't exist
		self.TracerColor = self:GetTracerColor()
		if self.TRACERCOLOR_TO_VECTOR[self.TracerColor] then
			self.Tracer = Material("sprites/animglow02") 
			self.Tracer:SetVector("$color",self.TRACERCOLOR_TO_VECTOR[self.TracerColor])
		end
		self.Caliber = self:GetCaliber()
		self.Inited = true
	end
	self:Think()
end

function ENT:OnRemove()
	if IsValid(self.Emitter) then
		self.Emitter:Finish()
	end
	if self.Sound then
		self.Sound:FadeOut(1.5)
	end
end

function ENT:Think()
	if !self.Inited then self:Initialize() end
	
	local v = self:GetVelocity()
	local pos = self:GetPos()
	self.StartPos = self.StartPos or pos
	
	if !IsValid(self.ply) then self.ply = LocalPlayer() end
	local ent = self.ply:GetViewEntity()
	local l
	
	l = (l and l or v:Length()) *0.001
	
	if !self.SoundEmited and self.StartPos then
		local EntPos
		
		if ((ent != self.GBOWNER and ent != self.Owner) or self.shouldOwnerHearSnd) and !self.EntIsTooClose and v != vector_zero and l > 5 then
			
			local l_sqr = v:LengthSqr()
			EntPos = EntPos or ent:GetPos()
			local LengthSqr = (pos - EntPos):LengthSqr()
			if self.SoundType == nil then
				l = v:Length()
				-- if self.Caliber > 100 then
					-- self.SoundType = 3
					-- self.SoundMul = 0.1
					-- self.WhizzMin = BIG_WHIZZ_SQR
				-- else
					self.SoundType = 2
					self.SoundMul = 0.1
					self.WhizzMin = SMALL_WHIZZ_SQR
				-- end
			end
			-- print(LengthSqr < l_sqr*self.SoundMul)
			if LengthSqr < l_sqr*self.SoundMul then
				self.SoundEmited = true
				self.Sound = CreateSound(ent,"shells/shell_passby_"..self.SoundType.."00_"..math.random(1,3)..".wav")
				self.Sound:PlayEx(0,100)
				
				local lpos = self:WorldToLocal(EntPos)
				local volume = 1 - math.Clamp((math.abs(lpos.y) + math.abs(lpos.z)) / 4000,0,1)
				if lpos.x > 0 and volume > 0 then self.Sound:ChangeVolume(volume,self.SoundType == 3 and 0.4 or nil) end
				
				if (ent.InVehicle and (ent:InVehicle() and gred.CVars.gred_cl_shell_blur_invehicles:GetBool() or !ent:InVehicle()) or !ent.InVehicle) and gred.CVars.gred_cl_shell_blur:GetBool() then
					-- timer.Simple(0.1,function()
						local Start = CurTime()
						local Num = 0.2
						-- print("star")
						hook.Add("GetMotionBlurValues","gred_shell_GetMotionBlurValues2",function(x,y,f,spin)
							local val = (CurTime() - Num - Start) / Num
							
							if val > 1 then
								hook.Remove("GetMotionBlurValues","gred_shell_GetMotionBlurValues2")
							else
								val = (1 - math.abs(val)) * (volume^2) * 1.5
								f = f + val
								-- x = x + val
								-- y = y + val
								return x,y,f,spin
							end
						end)
					-- end)
				end
			end
			
			-- local CalcDist = pos:DistToSqr(EntPos)
			-- local CalcLen = l*800
			-- if  < CalcLen then
				-- ent:EmitSound("shells/shell_passby_"..math.random(2,2).."00_"..math.random(1,3)..".wav")
				-- self.SoundEmited = true
			-- end
		end
	end
	-- if !self.TracerColor then self.TracerColor = colors["white"] end
	
	
	-- l = (l and l or v:Length()) *0.001
	
	if self.Tracer and l > 5 then
		local fwd = self:GetForward()
		
		
		self.OldPos = pos
		local vang = v:Angle()
		local fwdv = vang:Forward()
		pos = pos + fwd*30
		
		self:SetAngles(vang)
		
		if IsValid(self.Emitter) then
			local particle
			for i = 1,10 do
				particle = self.Emitter:Add(self.Tracer,pos + fwdv*(i*-self.Caliber*0.1 * math.Clamp(l,0,1)))
				if particle then
					particle:SetVelocity(v)
					particle:SetDieTime(0.05)
					particle:SetAirResistance(0) 
					particle:SetStartAlpha(255)
					particle:SetStartSize(self.Caliber and self.Caliber*0.2 or 20)
					particle:SetEndSize(0)
					particle:SetRoll(math.Rand(-1,1))
					particle:SetGravity(Vector(0,0,0))
					particle:SetCollide(false)
				end
			end
		else
			self.Emitter = ParticleEmitter(self:GetPos(),false)
		end
	end
end

net.Receive("gred_net_shell_pickup_rem",function()
	local ent = net.ReadEntity()
	if !IsValid(ent) then return end
	
	local ply = LocalPlayer()
	if !IsValid(ply) then return end
	
	hook.Remove("HUDPaint","gred_shell_HUDPaint")
end)

net.Receive("gred_net_shell_pickup_add",function()
	local ent = net.ReadEntity()
	if !IsValid(ent) then return end
	
	local ply = LocalPlayer()
	if !IsValid(ply) then return end
	
	ply:SetNWEntity("PickedUpObject",ent)
	
	hook.Add("HUDPaint","gred_shell_HUDPaint",function()
		HUDPaint(ply,ent)
	end)
end)

net.Receive("gred_net_shell_shrapnel_windows_send",function(len)
	local ShrapnelTab = util.JSONToTable(util.Decompress(net.ReadData(net.ReadUInt(14))))
	if !istable(ShrapnelTab) then return end
	
	if !gred.CVars.gred_cl_shell_enable_killcam:GetBool() then return end
	
	CreateKillCamWindow(ShrapnelTab)
end)
