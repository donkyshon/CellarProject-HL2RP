local SIMFPHYS_COLOR = Color(255,235,0)
local angle_zero = Angle()
local ang_1 = Angle(90)
local vec = Vector()
local math = math
local tostring = tostring
local TraceHull = util.TraceHull
local TraceLine = util.TraceLine
local QuickTrace = util.QuickTrace
local Effect = util.Effect
local GetRenderTarget = GetRenderTarget
local GetRenderTargetEx = GetRenderTargetEx
local ClientsideModel = ClientsideModel
local CreateClientProp = ents.CreateClientProp
local FOVCvar = GetConVar("fov_desired")
local render = render
local table = table

local trtab = {}
local view = {}
local scr = {}

local mat = CreateMaterial("simfphystank_viewport","UnlitGeneric",{
	["$color"] = "[0.5 0.5 0.5]"
})

local DeadTrack = {
	["$basetexture"] = "models/mm1/box",
	["$alphatest"] = 1,
}

local TankRenderTab = {
	x = 0,
	y = 0,
	w = ScrW(),
	h = ScrH(),
	fov = 90,
	drawpostprocess = false,
	drawhud = false,
	drawmonitors = false,
	drawviewmodel = false,
	dopostprocess = false,
	bloomtone = false,
}

local Zoom = 1.25

local tr_sus


local function PrintBones(ent)
    for i=0, ent:GetBoneCount()-1 do
        print(i,ent:GetBoneName(i))
    end
end

local function RoundAngle(ang,decimals)
	ang.p = math.Round(ang.p,decimals)
	ang.r = math.Round(ang.r,decimals)
	return ang
end

local function DrawCircle( X, Y, radius ) -- copyright LunasFlightSchool™
	local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
	
	for a = 0, 360 - segmentdist, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
	end
end

local function DrawCircleThing( X, Y, radius,Percentage ) -- copyright LunasFlightSchool™
	local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
	Percentage = Percentage * 360
	for a = 0, 360 - segmentdist, segmentdist do
		if Percentage > a then
			surface.SetDrawColor(255,0,0,150)
		else
			surface.SetDrawColor(0,255,0,150)
		end
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
	end
end


gred.TankID = gred.TankID or 0
gred.DrawCircle = DrawCircle

simfphys = simfphys or {}

function simfphys.RegisterCamera( ent, offset_firstperson, offset_thirdperson, bLocalAng, attachment )
	simfphys.CameraRegister( ent, offset_firstperson, offset_thirdperson, bLocalAng, attachment )
end


function simfphys.CameraRegister( ent, offset_firstperson, offset_thirdperson, bLocalAng, attachment ) -- sorry luna :(
	if not IsValid( ent ) then return end
	
	offset_firstperson = isvector( offset_firstperson ) and offset_firstperson or Vector(0,0,0)
	offset_thirdperson = isvector( offset_thirdperson ) and offset_thirdperson or Vector(0,0,0)
	
	ent:SetNWBool( "simfphys_SpecialCam", true )
	ent:SetNWBool( "SpecialCam_LocalAngles",  bLocalAng or false )
	ent:SetNWVector( "SpecialCam_Firstperson", offset_firstperson )
	ent:SetNWVector( "SpecialCam_Thirdperson", offset_thirdperson )
	
	if isstring( attachment ) then 
		ent:SetNWString( "SpecialCam_Attachment", attachment )
	end
end


gred.InitializeSimfphys = function(vehicle,callback)
	-- if true then return end
	if vehicle.TankIsInitializing then return false end
	
	vehicle.TankIsInitializing = true
	vehicle.EntityIndex = vehicle.EntityIndex or vehicle:EntIndex()
	
	timer.Create("GRED_TANK_INIT_"..vehicle.EntityIndex,1,1,function()
		if !IsValid(vehicle) then return end
		
		vehicle.CachedSpawnList = vehicle.CachedSpawnList or (vehicle.GetSpawn_List and vehicle:GetSpawn_List())
		
		if !vehicle.CachedSpawnList then
			vehicle.TankIsInitializing = false
			gred.InitializeSimfphys(vehicle)
			return
		end
	
		local TrackVector = Vector(0,0,0)
		local LocalPly = LocalPlayer()
		
		local VehicleTab = gred.simfphys[vehicle.CachedSpawnList]
		
		local SusDataTab = VehicleTab.SusData
		local ViewPortsTab = VehicleTab.ViewPorts
		local TracksTab = VehicleTab.Tracks
		local VehicleSeatTab = VehicleTab.Seats
		
		gred.TankLookupTankSeats(vehicle)
		gred.TankInitHookHacks(vehicle)
		gred.TankInitCrosshair(vehicle)
		gred.TankInitMode(vehicle)
		gred.TankInitVars(vehicle,VehicleTab)
		gred.TankInitTracks(vehicle,TracksTab)
		gred.TankInitSuspensions(vehicle,SusDataTab,TracksTab)
		gred.TankInitViewPorts(vehicle,ViewPortsTab)
		gred.TankInitModules(vehicle,VehicleTab)
		gred.TankInitSeats(vehicle,vehicle.Mode,VehicleSeatTab,LocalPly)
		
		vehicle.TankInitialized = true
		vehicle.TankIsInitializing = false
		
		local Mode = vehicle.Mode
		
		-- local SysTime = SysTime
		-- local t
		
		vehicle.Think = function(vehicle)
			vehicle:OldThink()
			-- t = SysTime()
			vehicle.PoseParamModified = false
			
			gred.TankHandleTracks(vehicle,TrackVector,TracksTab,SusDataTab)
			gred.TankHandleSuspensions(vehicle,LocalPly,SusDataTab)
			gred.TankHandleSeats(vehicle,Mode,LocalPly,VehicleSeatTab,ViewPortsTab)
			vehicle:OnCSTick(LocalPly)
			
			if vehicle.PoseParamModified then
				vehicle:InvalidateBoneCache()
			end
			-- print(SysTime() - t)
		end
		
		if callback then
			callback()
		end
	end)
	
	return true
end



gred.TankLookupTankSeats = function(vehicle)
	vehicle.pSeat = {}
	local i = 0
	for k,v in SortedPairs(vehicle:GetChildren(),true) do
		if v:GetClass() == "prop_vehicle_prisoner_pod" then
			vehicle.pSeat[i] = v
			i = i + 1
		end
	end
end

gred.TankInitHookHacks = function(vehicle)
	if !gred.SimfphysCalcViewHack or !gred.SimfphysCalcMainActivityHack then
		local HookTab = hook.GetTable()
		
		if !gred.SimfphysCalcViewHack and HookTab.CalcView and HookTab.CalcView.zz_simfphys_gunner_view then
			hook.Remove("CalcView","simfphys_gunner_view")
			gred.SimfphysCalcViewHack = HookTab.CalcView.zz_simfphys_gunner_view
		end
		
		if !gred.SimfphysCalcMainActivityHack and HookTab.CalcMainActivity and HookTab.CalcMainActivity.simfphysSeatActivityOverride then
			local simfphysSeatActivityOverride = HookTab.CalcMainActivity.simfphysSeatActivityOverride
			
			gred.SimfphysCalcMainActivityHack = simfphysSeatActivityOverride
			
			local CalcIdeal,CalcSeqOverride,HatchID,holdtype,seqid
			
			hook.Add("CalcMainActivity","simfphysSeatActivityOverride",function(ply)
				CalcIdeal,CalcSeqOverride = simfphysSeatActivityOverride(ply)
				
				if ply:GetVehicle():GetNWInt("HatchID",0) != 0 and CalcIdeal and CalcSeqOverride then
					ply.CalcSeqOverride = -1
					
					if ply:GetAllowWeaponsInVehicle() and IsValid(ply:GetActiveWeapon()) then
					
						holdtype = ply:GetActiveWeapon():GetHoldType()
						
						if holdtype == "smg" then 
							holdtype = "smg1"
						end

						seqid = ply:LookupSequence("sit_"..holdtype)
						
						if seqid != -1 then
							ply.CalcSeqOverride = seqid
						end
					end
					
					return ply.CalcIdeal,ply.CalcSeqOverride
				end
				
				return CalcIdeal,CalcSeqOverride
			end)
		end
	end
end

gred.TankInitCrosshair = function(vehicle)
	vehicle.Crosshair = hook.Run("GredTankCrosshair",vehicle,Crosshair,vehicle.CachedSpawnList)
	vehicle.Crosshair = vehicle.Crosshair == nil and gred.CVars.gred_sv_simfphys_enablecrosshair:GetBool() or vehicle.Crosshair
end

gred.TankInitMode = function(vehicle)
	vehicle.ArcadeMode = hook.Run("GredTankArcadeMode",vehicle,ArcadeMode,vehicle.CachedSpawnList)
	vehicle.ArcadeMode = vehicle.ArcadeMode == nil and gred.CVars.gred_sv_simfphys_arcade:GetBool() or vehicle.ArcadeMode
	vehicle.Mode = vehicle.ArcadeMode and "ArcadeMode" or "NormalMode"
end

gred.TankInitVars = function(vehicle,VehicleTab)
	local OldThink = vehicle.Think
	local mins,maxs = vehicle:GetModelBounds()
	
	vehicle.CachedSpawnList = vehicle.CachedSpawnList or vehicle:GetSpawn_List()
	vehicle.OldThink = vehicle.OldThink or OldThink
	
	vehicle.gred_cl_simfphys_viewport_fovnodraw_vertical = gred.CVars.gred_cl_simfphys_viewport_fovnodraw_vertical:GetFloat()
	vehicle.gred_cl_simfphys_maxsuspensioncalcdistance = gred.CVars.gred_cl_simfphys_maxsuspensioncalcdistance:GetFloat()
	vehicle.gred_sv_simfphys_disable_viewmodels = gred.CVars.gred_sv_simfphys_disable_viewmodels:GetBool()
	vehicle.gred_sv_simfphys_manualreloadsystem = gred.CVars.gred_sv_simfphys_manualreloadsystem:GetBool()
	vehicle.gred_cl_simfphys_viewport_fovnodraw = gred.CVars.gred_cl_simfphys_viewport_fovnodraw:GetInt()
	vehicle.gred_sv_simfphys_forcefirstperson = gred.CVars.gred_sv_simfphys_forcefirstperson:GetBool()
	vehicle.gred_sv_simfphys_smokereloadtime = gred.CVars.gred_sv_simfphys_smokereloadtime:GetFloat()
	vehicle.gred_cl_simfphys_testviewports = gred.CVars.gred_cl_simfphys_testviewports:GetBool()
	vehicle.gred_cl_simfphys_suspensions = gred.CVars.gred_cl_simfphys_suspensions:GetBool()
	vehicle.gred_cl_simfphys_viewport_hq = gred.CVars.gred_cl_simfphys_viewport_hq:GetBool()
	
	vehicle.CachedViewPortAspectRatio = {}
	vehicle.CachedViewPortPos = {}
	vehicle.CachedViewPortAng = {}
	vehicle.CachedViewPortAtt = {}
	vehicle.SmokeAttachments = {}
	vehicle.GhostWheels = {}
	vehicle.ViewPorts = {}
	vehicle.tr_table = {}
	vehicle.oldDist = {}
	
	vehicle.ModelBounds = {maxs = maxs,mins = mins}
	vehicle.ModelSize = vehicle.ModelBounds.maxs + vehicle.ModelBounds.mins
	vehicle.ModelSizeLength = vehicle.ModelSize:Length()
	
	vehicle.LastDistanceCache = 9999999999
	vehicle.NextDistanceCheck = 0
	vehicle.sm_TrackDelta_L = 0
	vehicle.sm_TrackDelta_R = 0
	vehicle.trackspin_l = 0
	vehicle.trackspin_r = 0
	
	
	vehicle:SetNWBool("simfphys_NoRacingHud",true)
	
	
	vehicle.FILTER = {}
	table.Add(vehicle.FILTER,vehicle.pSeat)
	table.Add(vehicle.FILTER,vehicle.GhostWheels)
	table.Add(vehicle.FILTER,vehicle.Wheels)
	table.insert(vehicle.FILTER,vehicle)
	table.insert(vehicle.FILTER,vehicle:GetDriverSeat())
	table.insert(vehicle.FILTER,vehicle.SteerMaster)
	table.insert(vehicle.FILTER,vehicle.SteerMaster2)
	table.insert(vehicle.FILTER,vehicle.MassOffset)
	
	vehicle.GearsBackup = table.Copy(vehicle.Gears)
	vehicle.filterEntities = player.GetAll()
	
	vehicle.filterEntities = player.GetAll()
	table.insert(vehicle.filterEntities,vehicle)
	table.Add(vehicle.filterEntities,ents.FindByClass("gmod_sent_vehicle_fphysics_wheel"))
	table.Add(vehicle.filterEntities,vehicle.FILTER)
	vehicle.OnCSTick = VehicleTab.OnCSTick or function() end
	
end

gred.TankInitSuspensions = function(vehicle,SusDataTab,TracksTab)
	if SusDataTab then
		if vehicle.SeparateTracks and !vehicle.TracksInitialized then return end
		
		vehicle.tr_table.mins = SusDataTab.Mins
		vehicle.tr_table.maxs = SusDataTab.Maxs
		vehicle.tr_table.filter = vehicle.filterEntities
		vehicle.AttachmentIDs = {}
		local v
		local ent
		local half = #SusDataTab*0.5
		vehicle.HalfSuspensions = half
		
		for k = 1,#SusDataTab do
			v = SusDataTab[k]
			if v then
				ent = (TracksTab and TracksTab.SeparateTracks and (k > half and vehicle.RightTrack or vehicle.LeftTrack) or vehicle)
				
				if !IsValid(ent) then
					vehicle.TracksInitialized = false
					return
				end
				
				vehicle.AttachmentIDs[k] = vehicle:WorldToLocal(ent:GetAttachment(ent:LookupAttachment(v.Attachment)).Pos)
			end
		end
	end
end

gred.TankInitViewPorts = function(vehicle,ViewPortsTab)
	vehicle.ViewPortAttachments = {}
	if ViewPortsTab then
		local v
		for k = 1,#ViewPortsTab do
			v = ViewPortsTab[k]
			if v then
				if v.Attachment then
					vehicle.ViewPortAttachments[v.Attachment] = vehicle.ViewPortAttachments[v.Attachment] or vehicle:LookupAttachment(v.Attachment)
				end
				if v.CamAtt then
					vehicle.ViewPortAttachments[v.CamAtt] = vehicle.ViewPortAttachments[v.CamAtt] or vehicle:LookupAttachment(v.CamAtt)
				end
			end
		end
	end
end

gred.TankInitModules = function(vehicle,VehicleTab)
	local ModulesTab = VehicleTab.Armour and VehicleTab.Armour.Modules or nil
	if ModulesTab then
		vehicle.ModuleAttachments = {}
		local v
		for Name,Tab in pairs(ModulesTab) do
			for k = 1,#Tab do
				v = Tab[k]
				vehicle:SetNWVarProxy("ModuleHealth_"..Name.."_"..v.ID,function(ent,name,oldval,newval)
					if oldval and oldval != newval and IsValid(vehicle) then
						gred.ModuleHealthChanged(vehicle,Name,v.ID,name,newval,oldval)
					end
				end)
				if v and v.Attachment then
					vehicle.ModuleAttachments[v.Attachment] = vehicle:LookupAttachment(v.Attachment)
				end
			end
		end
	end
end

gred.TankInitTracks = function(vehicle,TracksTab)
	if TracksTab then
		vehicle.LeftTrack = vehicle:GetNWEntity("LeftTrack") 
		vehicle.RightTrack = vehicle:GetNWEntity("RightTrack")
		
		vehicle.SeparateTracks = TracksTab.SeparateTracks
		
		if TracksTab.SeparateTracks and (!IsValid(vehicle.LeftTrack) or !IsValid(vehicle.RightTrack)) then return end
		
		vehicle.wheel_left_mat = CreateMaterial("gred_trackmat_"..vehicle.CachedSpawnList.."_"..vehicle.EntityIndex.."_left","VertexLitGeneric",TracksTab.TrackMat)
		vehicle.wheel_right_mat = CreateMaterial("gred_trackmat_"..vehicle.CachedSpawnList.."_"..vehicle.EntityIndex.."_right","VertexLitGeneric",TracksTab.TrackMat)
		
		if TracksTab.SeparateTracks then
			vehicle.LeftTrackID = TracksTab.LeftTrackID or (table.KeyFromValue(vehicle.LeftTrack:GetMaterials(),TracksTab.LeftTrackMat) or 1) - 1
			vehicle.RightTrackID = TracksTab.RightTrackID or (table.KeyFromValue(vehicle.RightTrack:GetMaterials(),TracksTab.RightTrackMat) or 1) - 1
			
			vehicle.LeftTrack:SetSubMaterial(vehicle.LeftTrackID,"!gred_trackmat_"..vehicle.CachedSpawnList.."_"..vehicle.EntityIndex.."_left") 
			vehicle.RightTrack:SetSubMaterial(vehicle.RightTrackID,"!gred_trackmat_"..vehicle.CachedSpawnList.."_"..vehicle.EntityIndex.."_right")
		else
			local mat = vehicle:GetMaterials()
			vehicle.LeftTrackID = TracksTab.LeftTrackID or (table.KeyFromValue(mat,TracksTab.LeftTrackMat) or 1) - 1
			vehicle.RightTrackID = TracksTab.RightTrackID or (table.KeyFromValue(mat,TracksTab.RightTrackMat) or 1) - 1
			
			vehicle:SetSubMaterial(vehicle.LeftTrackID,"!gred_trackmat_"..vehicle.CachedSpawnList.."_"..vehicle.EntityIndex.."_left") 
			vehicle:SetSubMaterial(vehicle.RightTrackID,"!gred_trackmat_"..vehicle.CachedSpawnList.."_"..vehicle.EntityIndex.."_right")
		end
	
		vehicle.LowTrackSound = TracksTab.LowTrackSound and CreateSound(vehicle,TracksTab.LowTrackSound) or nil
		vehicle.MedTrackSound = TracksTab.MedTrackSound and CreateSound(vehicle,TracksTab.MedTrackSound) or nil
		vehicle.HighTrackSound = TracksTab.HighTrackSound and CreateSound(vehicle,TracksTab.HighTrackSound) or nil
		vehicle.LowTrackSound:SetSoundLevel(TracksTab.TrackSoundLevel)
		vehicle.MedTrackSound:SetSoundLevel(TracksTab.TrackSoundLevel)
		vehicle.HighTrackSound:SetSoundLevel(TracksTab.TrackSoundLevel)
		vehicle.LowTrackSound:PlayEx(0,0)
		vehicle.MedTrackSound:PlayEx(0,0)
		vehicle.HighTrackSound:PlayEx(0,0)
		vehicle:CallOnRemove("RemoveTrackSound",function(vehicle)
			vehicle.LowTrackSound:Stop()
			vehicle.MedTrackSound:Stop()
			vehicle.HighTrackSound:Stop()
		end)
		
		vehicle.TracksInitialized = true
	end
end

gred.TankInitSeats = function(vehicle,Mode,VehicleSeatTab,LocalPly)
	if VehicleSeatTab then
		local seat
		local SeatTab
		
		for k = 0,#VehicleSeatTab do
			local v = VehicleSeatTab[k]
			
			if v and v[Mode] then
				SeatTab = v[Mode]
				seat = k == 0 and vehicle:GetDriverSeat() or (vehicle.pSeat and vehicle.pSeat[k] or nil)
				if IsValid(seat) then
					if SeatTab.MuzzleAttachment then
						seat.MuzzleAttachment = vehicle:LookupAttachment(SeatTab.MuzzleAttachment)
					end
					
					if SeatTab.Sight and SeatTab.Sight.SightMaterial then
						seat.SightTextureID = surface.GetTextureID(SeatTab.Sight.SightMaterial)
					end
					
					if SeatTab.MuzzleAttachment then
						seat.MuzzleAttachment = vehicle:LookupAttachment(SeatTab.MuzzleAttachment)
					end
					
					if v[Mode].Sight then
						seat.SightAttachment = (gred.CVars.gred_sv_simfphys_camera_tankgunnersight:GetBool() and gred.CVars.gred_cl_simfphys_camera_tankgunnersight:GetBool() and seat.MuzzleAttachment) and seat.MuzzleAttachment or vehicle:LookupAttachment(SeatTab.Sight.SightAttachment)
					end
					
					seat.FirstPersonViewPosIsInside = SeatTab.FirstPersonViewPosIsInside
					seat.LocalView = SeatTab.LocalView != nil and SeatTab.LocalView or ((SeatTab.ViewAttachment or SeatTab.Attachment) and true or false)
					simfphys.RegisterCamera(seat,SeatTab.FirstPersonViewPos,SeatTab.ThirdPersonViewPos,seat.LocalView,SeatTab.ViewAttachment)
					
					if SeatTab.Hatches then
						local HatchesTab = SeatTab.Hatches
						
						seat:SetNWVarProxy("HatchID",function(ent,name,oldval,newval)
							gred.HandleHatch(vehicle,ent,k,newval,oldval,SeatTab,HatchesTab)
						end)
					end
					
					if SeatTab.SmokeLaunchers then
						local v
						
						local SmokeLaunchersTab = SeatTab.SmokeLaunchers
						
						for k = 1,#SmokeLaunchersTab do
							v = SeatTab.SmokeLaunchers[k]
							
							if v then
								vehicle.SmokeAttachments[v] = vehicle.SmokeAttachments[v] or vehicle:LookupAttachment(v)
							end
						end
						
						seat:SetNWVarProxy("SmokeGrenades",function(ent,name,oldval,newval)
							gred.HandleSmokeGrenades(vehicle,ent,k,oldval,newval,LocalPly,SeatTab,SmokeLaunchersTab)
						end)
					end
					
					if SeatTab.Primary then
						seat.Primary = {}
						local WepTab
						
						for WepID = 1,#SeatTab.Primary do
							WepTab = SeatTab.Primary[WepID]
							
							if WepTab then
								seat.Primary[WepID] = {}
								gred.TankInitMuzzleAttachments(vehicle,seat,k,seat.Primary[WepID],WepTab,WepID)
							end
						end
						
						-- seat:SetNWVarProxy("SlotID",function(ent,name,oldval,newval)
							-- if oldval != newval then
								
							-- end
						-- end)
						
						local SlotID
						local SeatSlotTab
						local WeaponTab
						local SeatTab = SeatTab
						local Ammo
						
						seat:SetNWVarProxy("IsPrimaryAttacking",function(ent,name,oldval,newval)
							if oldval != newval then
								if newval == false then
									SlotID = ent:GetNWInt("SlotID",1)
									SeatSlotTab = ent.Primary[SlotID]
									WeaponTab = SeatTab.Primary[SlotID]
									
									if SeatSlotTab and SeatSlotTab.CurrentMuzzle and WeaponTab.Type == "MG" then
										Ammo = ent:GetNWInt(SlotID.."CurAmmo",WeaponTab.Ammo or 0)
										SeatSlotTab.CurrentMuzzle = (Ammo % #WeaponTab.Muzzles) + 1
										SeatSlotTab.Ammo = Ammo
									end
								end
							end
						end)
					end
					
					if SeatTab.Secondary then
						seat.Secondary = {}
						gred.TankInitMuzzleAttachments(vehicle,seat,k,seat.Secondary,SeatTab.Secondary)
					
						local SeatSlotTab
						local WeaponTab
						local Ammo
						
						seat:SetNWVarProxy("IsSecondaryAttacking",function(ent,name,oldval,newval)
							if oldval != newval then
								SeatSlotTab = ent.Secondary
								WeaponTab = SeatTab.Secondary
								
								if SeatSlotTab and WeaponTab and SeatSlotTab.CurrentMuzzle and WeaponTab.Type == "MG" then
									Ammo = ent:GetNWInt("SecondaryAmmo",WeaponTab.Ammo or 0)
									SeatSlotTab.CurrentMuzzle = (Ammo % #WeaponTab.Muzzles) + 1
									SeatSlotTab.Ammo = Ammo
								end
							end
						end)
					end
					
					seat.ZoomVal = 0
				end
			end
		end
	end
end

gred.TankInitMuzzleAttachments = function(vehicle,seat,SeatID,SeatSlotTab,WeaponTab,WepID)
	if WeaponTab.Sounds then
		SeatSlotTab.Sounds = {}
		
		seat:CallOnRemove("RemoveEnts"..vehicle.CachedSpawnList..tostring(seat),function(seat)
			for k,v in pairs(SeatSlotTab.Sounds) do
				v:Stop()
			end
		end)
		
		-- for k,v in pairs(WeaponTab.Sounds) do
			-- SeatSlotTab.Sounds[k] = CreateSound(seat,Sound(v))
			-- SeatSlotTab.Sounds[k]:Stop()
		-- end
	end
	
	if WeaponTab.Muzzles then
		SeatSlotTab.Muzzles = {}
		SeatSlotTab.CurrentMuzzle = 1
		SeatSlotTab.NextShot = 0
		SeatSlotTab.Ammo = 0
		SeatSlotTab.UpdateTracers = {}
		SeatSlotTab.Tracers = {}
		
		local v
		
		for k = 1,#WeaponTab.Muzzles do
			v = WeaponTab.Muzzles[k]
			
			if v then
				SeatSlotTab.Muzzles[k] = vehicle:LookupAttachment(v)
				SeatSlotTab.Tracers[k] = 0
				SeatSlotTab.UpdateTracers[k] = function()
					SeatSlotTab.Tracers[k] = SeatSlotTab.Tracers[k] + 1
					if SeatSlotTab.Tracers[k] >= gred.CVars.gred_sv_tracers:GetInt() then
						SeatSlotTab.Tracers[k] = 0
						return WeaponTab.TracerColor
					else
						return false
					end
				end
			end
		end
		
		if WeaponTab.Type == "Cannon" and WepID then
			SeatSlotTab.ReloadTime = WeaponTab.ReloadTime * gred.CVars.gred_sv_simfphys_reload_speed_multiplier:GetFloat()
			
			if WeaponTab.Sounds and WeaponTab.Sounds.Reload then
				seat:SetNWVarProxy(WepID.."NextShot",function(ent,name,oldval,newval)
					oldval = oldval or 0
					
					if oldval != newval and (newval - oldval) < 99999999 and IsValid(ent) then
						gred.PlayReloadSound(ent,SeatID,vehicle,WeaponTab,SeatSlotTab)
					end
				end)
			end
		elseif WeaponTab.Type == "RocketLauncher" then
			SeatSlotTab.NextShot = 0
			SeatSlotTab.ReloadTime = WeaponTab.ReloadTime * gred.CVars.gred_sv_simfphys_reload_speed_multiplier:GetFloat()
			
			seat:SetNWVarProxy(WepID and WepID.."CurAmmo" or "SecondaryAmmo",function(ent,name,oldval,newval)
				oldval = oldval or 0
				
				if oldval != newval and newval <= 0 and IsValid(ent) then
					SeatSlotTab.NextShot = CurTime() + SeatSlotTab.ReloadTime
					
					if WeaponTab.Sounds and WeaponTab.Sounds.Reload then
						gred.PlayReloadSound(ent,SeatID,vehicle,WeaponTab,SeatSlotTab)
					end
				end
			end)
		elseif WeaponTab.Type == "MG" then
			SeatSlotTab.FireRate = (60 / WeaponTab.FireRate) / (WeaponTab.Sequential and #WeaponTab.Muzzles or 1)
		end
	end
end



gred.TankHandleTracks = function(vehicle,TrackVector,TracksTab,SusDataTab)
	if TracksTab then
		if !vehicle.TracksInitialized then
			gred.TankInitTracks(vehicle,TracksTab)
			
			if !vehicle.TracksInitialized then
				return
			end
			
			if vehicle.SeparateTracks then
				gred.TankInitSuspensions(vehicle,SusDataTab,TracksTab)
			end
		end
		
		if vehicle.trackspin_l != vehicle.oldtrackspin_l and vehicle.oldtrackspin_r != vehicle.trackspin_r then
			vehicle.sm_TrackDelta_L = vehicle.sm_TrackDelta_L + ((-vehicle.trackspin_l / TracksTab.Divider) - vehicle.sm_TrackDelta_L) * TracksTab.Smoother
			vehicle.sm_TrackDelta_R = vehicle.sm_TrackDelta_R + ((-vehicle.trackspin_r / TracksTab.Divider) - vehicle.sm_TrackDelta_R) * TracksTab.Smoother
		
			if vehicle.LeftTrackID and vehicle.RightTrackID and vehicle.wheel_left_mat and vehicle.wheel_right_mat then
				if TracksTab.UpTranslate then
					TrackVector.z = vehicle.sm_TrackDelta_L
					vehicle.wheel_left_mat:SetVector("$translate",TrackVector)
					TrackVector.z = vehicle.sm_TrackDelta_R
					vehicle.wheel_right_mat:SetVector("$translate",TrackVector)
				elseif TracksTab.RightTranslate then
					TrackVector.x = vehicle.sm_TrackDelta_L
					vehicle.wheel_left_mat:SetVector("$translate",TrackVector)
					TrackVector.x = vehicle.sm_TrackDelta_R
					vehicle.wheel_right_mat:SetVector("$translate",TrackVector)
				else
					TrackVector.y = vehicle.sm_TrackDelta_L
					vehicle.wheel_left_mat:SetVector("$translate",TrackVector)
					TrackVector.y = vehicle.sm_TrackDelta_R
					vehicle.wheel_right_mat:SetVector("$translate",TrackVector)
				end
			end
		end
		
		local vel = (!vehicle:GetActive() or !vehicle.susOnGround or vehicle:GetHandBrakeEnabled()) and 0 or vehicle:GetVelocity():LengthSqr()
		local speed = math.Clamp(vel * 0.0001,0,TracksTab.TrackSoundVolume) * ((vehicle.LocalPlayerActiveSeat and gred.PlayerIsInsideVehicle(LocalPlayer(),vehicle,vehicle.LocalPlayerActiveSeat,vehicle.LocalPlayerActiveSeatID)) and vehicle.VolumeMul or 1)
		
		vehicle.LowTrackSound:PlayEx(vel >= 30000 and 0 or speed,100)
		vehicle.MedTrackSound:PlayEx((vel < 30000 or vel >= 150000) and 0 or speed,100)
		vehicle.HighTrackSound:PlayEx(vel > 150000 and speed or 0,100)
		
		vehicle.oldtrackspin_l = vehicle.trackspin_l
		vehicle.oldtrackspin_r = vehicle.trackspin_r
	end
end

gred.TankHandleSuspensions = function(vehicle,ply,SusDataTab,up,pos,v,tr_table,ct,ent)
	if SusDataTab and vehicle.gred_cl_simfphys_suspensions and !gred.PlayerIsInsideVehicle(ply,vehicle) then
		if vehicle.LastDistanceCache < vehicle.gred_cl_simfphys_maxsuspensioncalcdistance and !(vehicle.SeparateTracks and !vehicle.TracksInitialized) then
			vehicle.susOnGround = nil
			
			up = vehicle:GetUp() * -100
			
			for k = 1,#SusDataTab do
				v = SusDataTab[k]
				if v then
					ent = vehicle.SeparateTracks and (k > vehicle.HalfSuspensions and vehicle.RightTrack or vehicle.LeftTrack) or vehicle
					pos = vehicle:LocalToWorld(vehicle.AttachmentIDs[k])
					
					vehicle.tr_table.start = pos
					vehicle.tr_table.endpos = pos + up
					-- tr_sus = QuickTrace(vehicle.tr_table.start,vehicle.tr_table.endpos,vehicle.tr_table.filter)
					tr_sus = TraceHull(vehicle.tr_table)
					vehicle.susOnGround = vehicle.susOnGround or tr_sus.Hit
					vehicle.oldDist[k] = vehicle.oldDist[k] and vehicle.oldDist[k] + math.Clamp(((pos.z - tr_sus.HitPos.z) - v.Height) - vehicle.oldDist[k],-5,1) or 0
					ent:SetPoseParameter(v.PoseParameter,(v.ReversePoseParam and -vehicle.oldDist[k] or vehicle.oldDist[k]) * v.PoseParameterMultiplier)
				end
			end
			
			vehicle.PoseParamModified = true
		else
			vehicle.susOnGround = true
			ct = CurTime()
			if vehicle.NextDistanceCheck < ct then
				vehicle.LastDistanceCache = (ply:GetPos() - vehicle:GetPos()):LengthSqr()
				vehicle.NextDistanceCheck = vehicle.NextDistanceCheck + 2
			end
		end
	else
		vehicle.susOnGround = true
	end
end

gred.TankHandleSeats = function(vehicle,Mode,ply,VehicleSeatTab,ViewPortsTab)
	if vehicle.LocalPlayerActiveSeat then
		local SeatTab = (VehicleSeatTab and VehicleSeatTab[vehicle.LocalPlayerActiveSeatID]) and VehicleSeatTab[vehicle.LocalPlayerActiveSeatID][Mode] or nil
		
		if vehicle.gred_sv_simfphys_forcefirstperson then vehicle.LocalPlayerActiveSeat:SetThirdPersonMode(false) end
		
		if ViewPortsTab and ((SeatTab and !SeatTab.ViewPort or !SeatTab) or vehicle.gred_cl_simfphys_testviewports) and gred.PlayerIsInsideVehicle(ply,vehicle,vehicle.LocalPlayerActiveSeat,vehicle.LocalPlayerActiveSeatID) then
			if !ply.RenderHooksAdded then
				local Fov = (ply.DesiredFOV or FOVCvar:GetFloat()) + vehicle.gred_cl_simfphys_viewport_fovnodraw
				local Fov1 = Fov * vehicle.gred_cl_simfphys_viewport_fovnodraw_vertical
				
				hook.Add("RenderScene","gred_simfphys_tank_RenderScene",function(pos,ang,fov)
					-- local ViewPortsTab = gred.simfphys[vehicle.CachedSpawnList].ViewPorts
					gred.RenderViewPortsScene(vehicle,vehicle.LocalPlayerActiveSeat,ply,pos,ang,fov,Fov,Fov1,ViewPortsTab)
				end)
				
				hook.Add("PostDrawTranslucentRenderables","gred_simfphys_tank_PostDrawTranslucentRenderables",function()
					-- local ViewPortsTab = gred.simfphys[vehicle.CachedSpawnList].ViewPorts
					gred.Render3D2DViewPorts(vehicle,ply,ViewPortsTab)
				end)
				
				ply.RenderHooksAdded = true
			end
		else
			hook.Remove("PostDrawTranslucentRenderables","gred_simfphys_tank_PostDrawTranslucentRenderables")
			hook.Remove("RenderScene","gred_simfphys_tank_RenderScene")
			
			ply.RenderHooksAdded = nil
		end
		
		if SeatTab then
			if (vehicle.LocalPlayerActiveSeat.MuzzleAttachment or SeatTab.IsLoader or SeatTab.Hatches or SeatTab.IsCommander or SeatTab.HasRadio) and !ply.HookAdded then
				local ScrW,ScrH = ScrW(),ScrH()
				local LoadingSeatTab = SeatTab.IsLoader and VehicleSeatTab[SeatTab.IsLoader][Mode]
				local LoadingSeat = SeatTab.IsLoader == 0 and vehicle:GetDriverSeat() or vehicle.pSeat[SeatTab.IsLoader]
				
				hook.Add("HUDPaint","gred_simfphys_tank_HUDPaint",function()
					if !IsValid(vehicle) then return end
					if !vehicle.LocalPlayerActiveSeatID then return end
					
					gred.TankDrawHUD(vehicle,vehicle.LocalPlayerActiveSeat,vehicle.LocalPlayerActiveSeatID,SeatTab,Mode,ply,ScrW,ScrH,LoadingSeatTab,LoadingSeat)
				end)
				
				ply.HookAdded = true
			end
			
			if SeatTab.Sight then
				vehicle.LocalPlayerActiveSeat.Sight = input.IsButtonDown(gred.CVars.gred_cl_simfphys_key_togglesight:GetInt())
				
				if vehicle.LocalPlayerActiveSeat.Sight != vehicle.LocalPlayerActiveSeat.OldSight then
					if vehicle.LocalPlayerActiveSeat.Sight then
						vehicle.LocalPlayerActiveSeat.SightToggle = !vehicle.LocalPlayerActiveSeat.SightToggle
					end
					
					if vehicle.LocalPlayerActiveSeat.SightToggle then
						if IsValid(ply.ViewPortModel) then
							ply.ViewPortModel:SetNoDraw(true)
						end
						
						hook.Remove( "CalcView","zz_simfphys_gunner_view")
						hook.Add("CalcView","gred_simfphys_tank_CalcView",function(ply,pos,ang)
							if !IsValid(vehicle) then return end
							if !vehicle.LocalPlayerActiveSeat then return end
							if !vehicle.LocalPlayerActiveSeatID then return end
							
							return gred.TankSightCalcView(vehicle,vehicle.LocalPlayerActiveSeat,vehicle.LocalPlayerActiveSeatID,SeatTab,Mode,ply,pos,ang)
						end)
						
						local gred_cl_simfphys_sightsensitivity = gred.CVars.gred_cl_simfphys_sightsensitivity
						
						hook.Add("AdjustMouseSensitivity","gred_simfphys_tank_AdjustMouseSensitivity",function(val)
							if !IsValid(vehicle) then return end
							if !vehicle.LocalPlayerActiveSeat then return end
							
							return gred_cl_simfphys_sightsensitivity:GetFloat() * (vehicle.LocalPlayerActiveSeat.ZoomSensitivityFactor or 1)
						end)
					else
						hook.Remove("AdjustMouseSensitivity","gred_simfphys_tank_AdjustMouseSensitivity")
						
						if SeatTab.ViewPort then
							hook.Add("CalcView","gred_simfphys_tank_CalcView",function(ply,pos,ang)
								if !IsValid(vehicle) then return end
								if !vehicle.LocalPlayerActiveSeat then return end
								if !vehicle.LocalPlayerActiveSeatID then return end
								
								return gred.TankViewPortCalcView(vehicle,vehicle.LocalPlayerActiveSeat,vehicle.LocalPlayerActiveSeatID,VehicleSeatTab[vehicle.LocalPlayerActiveSeatID][vehicle.Mode],Mode,VehicleSeatTab[vehicle.LocalPlayerActiveSeatID][vehicle.Mode].ViewPort,ply,pos,ang)
							end)
						else
							hook.Remove("CalcView","gred_simfphys_tank_CalcView")
							hook.Add("CalcView","zz_simfphys_gunner_view",gred.SimfphysCalcViewHack)
						end
						
						vehicle.LocalPlayerActiveSeat.ZoomVal = 0
						vehicle.LocalPlayerActiveSeat.ZoomToggle = nil
					end
				end
				
				vehicle.LocalPlayerActiveSeat.OldSight = vehicle.LocalPlayerActiveSeat.Sight
				
				if vehicle.LocalPlayerActiveSeat.SightToggle then
					vehicle.LocalPlayerActiveSeat.Zoom = input.IsButtonDown(gred.CVars.gred_cl_simfphys_key_togglezoom:GetInt())
					local ct = CurTime()
					
					if vehicle.LocalPlayerActiveSeat.Zoom != vehicle.LocalPlayerActiveSeat.OldZoom then
						if vehicle.LocalPlayerActiveSeat.Zoom then
							vehicle.LocalPlayerActiveSeat.ZoomToggle = !vehicle.LocalPlayerActiveSeat.ZoomToggle
						end
					end
					
					vehicle.LocalPlayerActiveSeat.ZoomVal = math.Clamp(vehicle.LocalPlayerActiveSeat.ZoomVal + (vehicle.LocalPlayerActiveSeat.ZoomToggle and 7 or -7)*FrameTime(),0,1)
					vehicle.LocalPlayerActiveSeat.OldZoom = vehicle.LocalPlayerActiveSeat.Zoom
				end
			end
		end
	end
	
	if VehicleSeatTab then
		local driver
		local seat
		local SeatTab
		local PrimaryTab
		local CanShoot
		local IsShooting
		local IsKeyDown
		local SlotID
		local HatchID
		local ct = CurTime()
		local v
		
		for k = 0,#VehicleSeatTab do
			v = VehicleSeatTab[k]
			SeatTab = v and v[Mode]
			
			if SeatTab then
				seat = k == 0 and vehicle:GetDriverSeat() or (vehicle.pSeat and vehicle.pSeat[k] or nil)
				
				if IsValid(seat) then
					driver = seat:GetDriver()
					
					if IsValid(driver) then
						SlotID = seat:GetNWInt("SlotID",1)
						HatchID = seat:GetNWInt("HatchID",0)
						PrimaryTab = SeatTab.Primary and SeatTab.Primary[SlotID] or nil
						SecondaryTab = SeatTab.Secondary
						
						if PrimaryTab and PrimaryTab.Type == "MG" then
							CanShoot,IsShooting,IsKeyDown = nil,nil,driver == ply and ply:KeyDown(IN_ATTACK) or seat:GetNWBool("IsPrimaryAttacking",false)
							
							if IsKeyDown then
								seat.Primary[SlotID].Ammo = seat:GetNWInt(SlotID.."CurAmmo",0)
								CanShoot,IsShooting = gred.TankCanShootMG(vehicle,seat,driver,ct,SeatTab,PrimaryTab,k,seat.Primary[SlotID],SlotID,HatchID)
								if CanShoot then
									gred.TankShootMG(seat,k,vehicle,true)
									seat.PrimaryAttacking = true
								end
							end
							
							if (IsKeyDown and !IsShooting) or !IsKeyDown then
								if seat.PrimaryAttacking then
									gred.TankStopMG(seat,k,vehicle,true)
								end
								
								seat.PrimaryAttacking = false
							end
						end
						
						if SecondaryTab and SecondaryTab.Type == "MG" then
							CanShoot,IsShooting,IsKeyDown = nil,nil,driver == ply and ply:KeyDown(IN_ATTACK2) or seat:GetNWBool("IsSecondaryAttacking",false)
							
							if IsKeyDown then
								seat.Secondary.Ammo = seat:GetNWInt("SecondaryAmmo",0)
								CanShoot,IsShooting = gred.TankCanShootMG(vehicle,seat,driver,ct,SeatTab,SecondaryTab,k,seat.Secondary,nil,HatchID)
								
								if CanShoot then
									gred.TankShootMG(seat,k,vehicle,false)
									seat.SecondaryAttacking = true
								end
							end
							
							if (IsKeyDown and !IsShooting) or !IsKeyDown then
								if seat.SecondaryAttacking then
									gred.TankStopMG(seat,k,vehicle,false)
								end
								
								seat.SecondaryAttacking = false
							end
						end
					elseif driver != seat.PrevDriver and IsValid(seat.PrevDriver) then
						SlotID = seat:GetNWInt("SlotID",1)
						HatchID = seat:GetNWInt("HatchID",0)
						PrimaryTab = SeatTab.Primary and SeatTab.Primary[SlotID] or nil
						SecondaryTab = SeatTab.Secondary
						
						if seat.PrimaryAttacking and PrimaryTab and PrimaryTab.Type == "MG" then
							gred.TankStopMG(seat,k,vehicle,true)
						end
						
						if seat.SecondaryAttacking and SecondaryTab and SecondaryTab.Type == "MG" then
							gred.TankStopMG(seat,k,vehicle,false)
						end
						
						seat.PrimaryAttacking = false
						seat.SecondaryAttacking = false
					end
					
					if SeatTab.HasRadio and OpenRadioMenu then
						seat.IsJumping = ply:KeyDown(IN_JUMP)
						
						if seat.IsJumping and seat.IsJumping != seat.OldIsJumping then
							net.Start("gred_net_simfphys_enableradio")
							net.SendToServer()
						end
						
						seat.OldIsJumping = seat.IsJumping
						
						seat.IsShooting = ply:KeyDown(IN_ATTACK2)
						
						if seat.IsShooting and seat.IsShooting != seat.OldIsShooting then
							OpenRadioMenu()
						end
						
						seat.OldIsShooting = seat.IsShooting
					end
					
					seat.PrevDriver = driver
				end
			end
		end
	end
end



gred.RenderViewPortsScene = function(vehicle,seat,ply,pos,ang,fov,Fov,Fov1,ViewPortsTab)
	if !IsValid(vehicle) then return end
	
	ViewPortsTab = gred.simfphys[vehicle.CachedSpawnList].ViewPorts
	
	local oldRT = render.GetRenderTarget()
	local CalcAng
	local v
	
	render.Clear(0,0,0,255) 
	surface.SetDrawColor(255,255,255,255)
	
	table.Empty(vehicle.CachedViewPortAtt)
	
	ang.p = math.abs(ang.p)
	
	for k = 1,#ViewPortsTab do
		v = ViewPortsTab[k]
		
		if v then
			if v.NoDraw and v.NoDraw[vehicle.LocalPlayerActiveSeatID] then
				vehicle.ViewPorts[k] = nil
			else
				local att
				
				if v.Attachment and vehicle.ViewPortAttachments[v.Attachment] then
					if !vehicle.CachedViewPortAtt[v.Attachment] then
						vehicle.CachedViewPortAtt[v.Attachment] = vehicle:GetAttachment(vehicle.ViewPortAttachments[v.Attachment])
						vehicle.CachedViewPortAtt[v.Attachment].LPos,vehicle.CachedViewPortAtt[v.Attachment].LAng = vehicle:WorldToLocal(vehicle.CachedViewPortAtt[v.Attachment].Pos),vehicle:WorldToLocalAngles(vehicle.CachedViewPortAtt[v.Attachment].Ang)
					end
					
					att = vehicle.CachedViewPortAtt[v.Attachment]
					
					local Pos,Ang = LocalToWorld(v.ViewPortPos,v.ViewPortAng,att.LPos,att.LAng)
					vehicle.CachedViewPortPos[k] = vehicle:LocalToWorld(Pos)
					vehicle.CachedViewPortAng[k] = vehicle:LocalToWorldAngles(Ang)
					
					if v.Attachment != v.CamAtt then
						if v.CamAtt then
							if !vehicle.CachedViewPortAtt[v.CamAtt] then
								vehicle.CachedViewPortAtt[v.CamAtt] = vehicle:GetAttachment(vehicle.ViewPortAttachments[v.CamAtt])
								vehicle.CachedViewPortAtt[v.CamAtt].LPos,vehicle.CachedViewPortAtt[v.CamAtt].LAng = vehicle:WorldToLocal(vehicle.CachedViewPortAtt[v.CamAtt].Pos),vehicle:WorldToLocalAngles(vehicle.CachedViewPortAtt[v.CamAtt].Ang)
							end
							
							att = vehicle.CachedViewPortAtt[v.CamAtt]
						else
							att = nil
						end
					end
				else
					vehicle.CachedViewPortPos[k] = vehicle:LocalToWorld(v.ViewPortPos)
					vehicle.CachedViewPortAng[k] = vehicle:LocalToWorldAngles(v.ViewPortAng)
				end
				
				vehicle.CachedViewPortAspectRatio[k] = vehicle.CachedViewPortAspectRatio[k] or v.ViewPortWidth / v.ViewPortHeight
				CalcAng = (pos - vehicle.CachedViewPortPos[k]):Angle() - ang
				CalcAng:Normalize()
				
				-- if math.abs(CalcAng.y) <= Fov or math.abs(CalcAng.p) <= Fov1 then
				if false then
					vehicle.ViewPorts[k] = nil
				else
					if vehicle.gred_cl_simfphys_viewport_hq then
						vehicle.ViewPorts[k] = GetRenderTarget("simfphystank_viewport_"..vehicle.EntityIndex.."_"..k,TankRenderTab.w,TankRenderTab.h,false)
					else
						vehicle.ViewPorts[k] = GetRenderTargetEx("simfphystank_viewport_"..vehicle.EntityIndex.."_"..k,TankRenderTab.w,TankRenderTab.h,
						2, -- https://wiki.facepunch.com/gmod/Enums/RT_SIZE
						0, -- https://wiki.facepunch.com/gmod/Enums/MATERIAL_RT_DEPTH
						2, -- https://wiki.facepunch.com/gmod/Enums/TEXTUREFLAGS
						1, -- https://wiki.facepunch.com/gmod/Enums/CREATERENDERTARGETFLAGS
						-1) -- https://wiki.facepunch.com/gmod/Enums/IMAGE_FORMAT
					end
					
					render.SetRenderTarget(vehicle.ViewPorts[k])
						if att then
							TankRenderTab.origin,TankRenderTab.angles = LocalToWorld(v.CamPos,v.CamAng,att.LPos,att.LAng)
							TankRenderTab.origin,TankRenderTab.angles = vehicle:LocalToWorld(TankRenderTab.origin),vehicle:LocalToWorldAngles(TankRenderTab.angles)
						else
							TankRenderTab.origin = vehicle:LocalToWorld(v.CamPos)
							TankRenderTab.angles = vehicle:LocalToWorldAngles(v.CamAng)
						end
						
						TankRenderTab.aspectratio = vehicle.CachedViewPortAspectRatio[k]
						TankRenderTab.fov = v.CamFov or ply.DesiredFOV -- fov
						
					render.RenderView(TankRenderTab)
				end
			end
		end
	end
	render.SetRenderTarget(oldRT)
end

gred.Render3D2DViewPorts = function(vehicle,ply,ViewPortsTab)
	if !IsValid(vehicle) then return end
	local v
	for k = 1,#ViewPortsTab do
		v = ViewPortsTab[k]
		
		if v and vehicle.ViewPorts[k] and vehicle.CachedViewPortPos[k] and vehicle.CachedViewPortAng[k] then
			cam.Start3D2D(vehicle.CachedViewPortPos[k],vehicle.CachedViewPortAng[k],0.01)
			
				mat:SetTexture("$basetexture",vehicle.ViewPorts[k])
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(0,0,v.ViewPortWidth,v.ViewPortHeight)
				
				if ViewPortsTab[k].Paint then
					ViewPortsTab[k].Paint(vehicle,ply)
				end
				
			cam.End3D2D()
		end
	end
end

gred.TankDrawHUD = function(vehicle,seat,SeatID,SeatTab,Mode,ply,ScrW,ScrH,LoadingSeatTab,LoadingSeat)
	if !IsValid(vehicle) then return end
	
	local Height = 0.02
	local HeightAdd = 0.022
	local HeightCalc = ScrH*Height
	local X = ScrW*0.09
	
	if (SeatTab.RequiresHatch and SeatTab.RequiresHatch[seat:GetNWInt("HatchID",0)] or (!SeatTab.RequiresHatch and seat:GetNWInt("HatchID",0) == 0)) then
		if SeatTab.IsLoader and LoadingSeat != seat then
			if IsValid(LoadingSeat) and LoadingSeatTab and LoadingSeatTab.Primary then
				local SlotID = LoadingSeat:GetNWInt("SlotID",1)
				local LoadingPrimaryTab = LoadingSeatTab.Primary[SlotID]
				
				if LoadingPrimaryTab then
					draw.SimpleText("PRIMARY","SIMFPHYS_ARMED_HUDFONT",7,HeightCalc,SIMFPHYS_COLOR,0,1)
					draw.SimpleText((LoadingPrimaryTab.Type == "Cannon" and LoadingPrimaryTab.ShellTypes[1].Caliber.."MM " 
					or ((LoadingPrimaryTab.Type == "MG" and LoadingPrimaryTab.ExactCaliber) and LoadingPrimaryTab.ExactCaliber.."MM " or ""))..LoadingPrimaryTab.Type:upper()..(#LoadingSeatTab.Primary > 1 and " (PRESS "..(tostring(input.GetKeyName(gred.CVars["gred_cl_simfphys_key_togglegun"]:GetInt()):upper())).." TO TOGGLE)" or ""),"SIMFPHYS_ARMED_HUDFONT",X,HeightCalc,SIMFPHYS_COLOR,0,1)
					Height = Height + HeightAdd
					HeightCalc = ScrH*Height
					
					local ShellType
					
					if LoadingPrimaryTab.Type == "Cannon" then
						ShellType = LoadingSeat:GetNWInt(SlotID.."ShellType",1)
						draw.SimpleText("SHELLTYPE","SIMFPHYS_ARMED_HUDFONT",7,HeightCalc,SIMFPHYS_COLOR,0,1)
						draw.SimpleText(LoadingPrimaryTab.ShellTypes[ShellType].ShellType,"SIMFPHYS_ARMED_HUDFONT",X,HeightCalc,SIMFPHYS_COLOR,0,1)
						Height = Height + HeightAdd
						HeightCalc = ScrH*Height
						
						surface.SetDrawColor(255,255,255,150)
						local Ammo = LoadingSeat:GetNWInt(SlotID.."CurAmmo"..LoadingSeat:GetNWInt(SlotID.."ShellType",1))
						local val = Ammo == 0 and 1 or math.max(LoadingSeat:GetNWFloat(SlotID.."NextShot") - CurTime(),0) / LoadingSeat.Primary[SlotID].ReloadTime
						
						if val == 0 and Ammo != 0 then
							DrawCircle(ScrW * 0.5,ScrH * 0.5,29)
						else
							DrawCircleThing(ScrW * 0.5,ScrH * 0.5,29,val)
						end
						
						surface.SetDrawColor(0,0,0,150)
						DrawCircle(ScrW * 0.5,ScrH * 0.5,30)
					end
					
					Height = Height + HeightAdd
					HeightCalc = ScrH*Height
					draw.SimpleText("YOU ARE THE LOADER"..(vehicle.gred_sv_simfphys_manualreloadsystem and "" or ", BUT THE LOADER SYSTEM IS DISABLED"),"SIMFPHYS_ARMED_HUDFONT",7,HeightCalc,SIMFPHYS_COLOR,0,1)
				else
					Height = 0
				end
			end
		end
		
		if ((SeatTab.NoFirstPersonCrosshair and !gred.PlayerIsInsideVehicle(ply,vehicle)) or !SeatTab.NoFirstPersonCrosshair) and seat.MuzzleAttachment then
			local att = vehicle:GetAttachment(seat.MuzzleAttachment)
			local EyeAng
			
			if vehicle.LocalPlayerActiveSeat.SightToggle then
				EyeAng = seat.LocalView and ply:EyeAngles() or (seat.LocalView and ply:EyeAngles() or seat:LocalToWorldAngles(ply:EyeAngles()))
				surface.SetDrawColor(255,255,255,255)
				surface.SetTexture(seat.SightTextureID)
				local Ang = EyeAng - att.Ang
				Ang:Normalize()
				local Yaw   = 0 -- math.Clamp(Ang.y / 10,-1,1) * 200
				local Pitch = 0 -- math.Clamp(Ang.p / 45,-1,1) * -100
				surface.DrawTexturedRect((-(ScrW*Zoom-ScrW)*0.5) + Yaw,(-(ScrW*Zoom-ScrH)*0.5) + Pitch,ScrW*Zoom,ScrW*Zoom)
			else
				if vehicle.Crosshair then
					trtab.start = att.Pos
					trtab.endpos = (att.Pos + att.Ang:Forward() * 10000)
					trtab.filter = vehicle.filterEntities
					local tr = TraceLine(trtab)
					scr = tr.HitPos:ToScreen()
					scr.x = scr.x > ScrW and ScrW or (scr.x < 0 and 0 or scr.x)
					scr.y = scr.y > ScrH and ScrH or (scr.y < 0 and 0 or scr.y)
					
					surface.SetDrawColor(255,255,255,255)
					DrawCircle(scr.x,scr.y,19)
					DrawCircle(scr.x,scr.y,2)
					surface.SetDrawColor(0,0,0,255)
					DrawCircle(scr.x,scr.y,20)
					DrawCircle(scr.x,scr.y,3)
				end
			end
			
			if vehicle.Crosshair or vehicle.LocalPlayerActiveSeat.SightToggle then
				EyeAng = EyeAng or (seat.LocalView and ply:EyeAngles() or seat:LocalToWorldAngles(ply:EyeAngles()))
				trtab.start = att.Pos
				trtab.endpos = (att.Pos + EyeAng:Forward() * 100000)
				trtab.filter = vehicle.filterEntities
				scr = TraceLine(trtab).HitPos:ToScreen()
				
				scr.x = scr.x > ScrW and ScrW or (scr.x < 0 and 0 or scr.x)
				scr.y = scr.y > ScrH and ScrH or (scr.y < 0 and 0 or scr.y)
				
				if SeatTab.TurretTraverseSpeed then
					surface.SetDrawColor(255,255,255,150)
					
					if SeatTab.Primary or SeatTab.Secondary then
						local SlotID = seat:GetNWInt("SlotID",1)
						
						if SeatTab.Primary[SlotID] and SeatTab.Primary[SlotID].Type == "Cannon" then
							local Ammo = seat:GetNWInt(SlotID.."CurAmmo"..seat:GetNWInt(SlotID.."ShellType",1))
							local val = Ammo == 0 and 1 or math.max(seat:GetNWFloat(SlotID.."NextShot") - CurTime(),0) / seat.Primary[SlotID].ReloadTime
							
							if val == 0 and Ammo != 0 then
								DrawCircle(scr.x,scr.y,29)
							else
								DrawCircleThing(scr.x,scr.y,29,val)
							end
						elseif (SeatTab.Primary[SlotID] and SeatTab.Primary[SlotID].Type == "RocketLauncher") or (SeatTab.Secondary and SeatTab.Secondary.Type == "RocketLauncher") then
							local IsPrimary = (SeatTab.Primary[SlotID] and SeatTab.Primary[SlotID].Type == "RocketLauncher")
							local SeatSlotTab = seat[IsPrimary and "Primary" or "Secondary"]
							
							if IsPrimary then
								SeatSlotTab = SeatSlotTab[SlotID]
							end
							
							local Ammo = seat:GetNWInt(IsPrimary and SlotID.."CurAmmo" or "SecondaryAmmo")
							local val = Ammo == 0 and (SeatSlotTab.NextShot - CurTime()) / SeatSlotTab.ReloadTime or 0
							if val == 0 and Ammo != 0 then
								DrawCircle(scr.x,scr.y,29)
							else
								DrawCircleThing(scr.x,scr.y,29,val)
							end
						else
							DrawCircle(scr.x,scr.y,29)
						end
					else
						DrawCircle(scr.x,scr.y,29)
					end
					
					surface.SetDrawColor(0,0,0,150)
					DrawCircle(scr.x,scr.y,30)
				end
			end
		end
		
		if SeatTab.Primary or SeatTab.Secondary then
			if SeatTab.Primary  then
				local SlotID = seat:GetNWInt("SlotID",1)
				-- local Height = 0.02
				-- local HeightAdd = 0.022
				-- local HeightCalc = ScrH*Height
				-- local X = ScrW*0.09
				local PrimaryTab = SeatTab.Primary[SlotID]
				local SecondaryTab = SeatTab.Secondary
				
				if PrimaryTab then
					draw.SimpleText("PRIMARY","SIMFPHYS_ARMED_HUDFONT",7,HeightCalc,SIMFPHYS_COLOR,0,1)
					draw.SimpleText((PrimaryTab.Type == "Cannon" and PrimaryTab.ShellTypes[1].Caliber.."MM " 
					or ((PrimaryTab.Type == "MG" and PrimaryTab.ExactCaliber) and PrimaryTab.ExactCaliber.."MM " or ""))..(PrimaryTab.ExactType or PrimaryTab.Type:upper())..(#SeatTab.Primary > 1 and " (PRESS "..(tostring(input.GetKeyName(gred.CVars["gred_cl_simfphys_key_togglegun"]:GetInt()):upper())).." TO TOGGLE)" or ""),"SIMFPHYS_ARMED_HUDFONT",X,HeightCalc,SIMFPHYS_COLOR,0,1)
					Height = Height + HeightAdd
					HeightCalc = ScrH*Height
					
					local ShellType
					
					if PrimaryTab.Type == "Cannon" then
						ShellType = seat:GetNWInt(SlotID.."ShellType",1)
						draw.SimpleText("SHELLTYPE","SIMFPHYS_ARMED_HUDFONT",7,HeightCalc,SIMFPHYS_COLOR,0,1)
						draw.SimpleText(PrimaryTab.ShellTypes[ShellType].ShellType,"SIMFPHYS_ARMED_HUDFONT",X,HeightCalc,SIMFPHYS_COLOR,0,1)
						Height = Height + HeightAdd
						HeightCalc = ScrH*Height
					end
					
					if PrimaryTab.Type != "Flamethrower" then
						ShellType = ShellType or ""
						draw.SimpleText("AMMO","SIMFPHYS_ARMED_HUDFONT",7,HeightCalc,SIMFPHYS_COLOR,0,1)
						draw.SimpleText(seat:GetNWInt(SlotID.."CurAmmo"..ShellType),"SIMFPHYS_ARMED_HUDFONT",X,HeightCalc,SIMFPHYS_COLOR,0,1)
						Height = Height + HeightAdd
						HeightCalc = ScrH*Height
					end
						
					if vehicle.gred_sv_simfphys_manualreloadsystem then
						draw.SimpleText("MANUAL RELOAD IS ENABLED - "..(LoadingSeat == seat and "YOU ARE THE LOADER" or "A TEAMMATE MUST RELOAD YOUR GUN"),"SIMFPHYS_ARMED_HUDFONT",7,HeightCalc,SIMFPHYS_COLOR,0,1)
						Height = Height + HeightAdd
						HeightAdd = HeightAdd + (HeightAdd * (1/5))
						HeightCalc = ScrH*Height
					end
					
				else
					Height = 0
				end
				
				if SecondaryTab then
					Height = Height == 0 and 0.02 or HeightAdd * 5
					HeightCalc = ScrH*Height
					draw.SimpleText("SECONDARY","SIMFPHYS_ARMED_HUDFONT",7,HeightCalc,SIMFPHYS_COLOR,0,1)
					draw.SimpleText((SecondaryTab.Type == "Cannon" and SecondaryTab.ShellTypes[1].Caliber.."MM " 
					or ((SecondaryTab.Type == "MG" and SecondaryTab.ExactCaliber) and SecondaryTab.ExactCaliber.."MM " or ""))..SecondaryTab.Type:upper(),"SIMFPHYS_ARMED_HUDFONT",X,HeightCalc,SIMFPHYS_COLOR,0,1)
					
					if SecondaryTab.Type != "Flamethrower" then
						Height = Height + HeightAdd
						HeightCalc = ScrH*Height
						draw.SimpleText("AMMO","SIMFPHYS_ARMED_HUDFONT",7,HeightCalc,SIMFPHYS_COLOR,0,1)
						draw.SimpleText(seat:GetNWInt("SecondaryAmmo",0),"SIMFPHYS_ARMED_HUDFONT",X,HeightCalc,SIMFPHYS_COLOR,0,1)
					end
				end
			end
		end
		
		
		if SeatTab.SmokeLaunchers then
			local H = ScrH * (Height + HeightAdd*2)
			draw.SimpleText("SMOKES","SIMFPHYS_ARMED_HUDFONT",7,H,SIMFPHYS_COLOR,0,1)
			draw.SimpleText(seat:GetNWInt("SmokeGrenades",0)..(seat.SmokeGrenadesReloading and " [RELOADING]" or ""),"SIMFPHYS_ARMED_HUDFONT",X,H,SIMFPHYS_COLOR,0,1)
			Height = Height + HeightAdd*2
			HeightCalc = ScrH*Height
		end
		
		if SeatTab.PoseParameters then
			if SeatTab.TraverseIndicator and SeatTab.PoseParameters.Yaw and (SeatTab.PoseParameters.Yaw["turret_yaw"] or SeatTab.PoseParameters.Yaw[SeatTab.TraverseIndicator]) then
				local scrW,scrH = ScrW*0.5,ScrH*0.518
				
				surface.SetDrawColor( 240, 200, 0, 255 ) 
				local YawName = SeatTab.PoseParameters.Yaw["turret_yaw"] and "turret_yaw" or SeatTab.TraverseIndicator
				local Yaw = vehicle:GetPoseParameter(YawName)
				
				if !SeatTab.MaxTraverse and !SeatTab.MinTraverse then
					Yaw = math.Remap(Yaw,0,1,vehicle:GetPoseParameterRange(YawName)) + 90
				else
					Yaw = math.Remap(Yaw,0,1,SeatTab.MinTraverse,SeatTab.MaxTraverse) + 90
				end
				
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
			
			local H = ScrH * (Height + HeightAdd*2)
			-- draw.SimpleText("DOUBLE PRESS "..(input.LookupBinding("+walk") or "[WALK - Unbound!]").." TO TOGGLE THE TURRET","SIMFPHYS_ARMED_HUDFONT",7,H,SIMFPHYS_COLOR,0,1)
			draw.SimpleText("HOLD "..(input.LookupBinding("+walk") or "[WALK - Unbound!]").." TO ENTER FREEVIEW","SIMFPHYS_ARMED_HUDFONT",7,H,SIMFPHYS_COLOR,0,1)
			Height = Height + HeightAdd*2
			HeightCalc = ScrH*Height
		end
	end
	
	Height = Height + HeightAdd*2
	HeightCalc = ScrH*Height
	
	if SeatTab.IsCommander then
		draw.SimpleText("YOU ARE THE COMMANDER","SIMFPHYS_ARMED_HUDFONT",7,HeightCalc,SIMFPHYS_COLOR,0,1)
		Height = Height + HeightAdd
		HeightCalc = ScrH*Height
	end
	
	if SeatTab.Hatches then
		draw.SimpleText("PRESS "..(tostring(input.GetKeyName(gred.CVars["gred_cl_simfphys_key_togglehatch"]:GetInt()):upper())).." TO TOGGLE THE HATCH","SIMFPHYS_ARMED_HUDFONT",7,HeightCalc,SIMFPHYS_COLOR,0,1)
		Height = Height + HeightAdd
		HeightCalc = ScrH*Height
	end
	
	if SeatTab.HasRadio and OpenRadioMenu then
		draw.SimpleTextOutlined((seat:GetNWBool("RadioActive",false) and "Radio ON: Channel: "..math.Round(seat:GetNWFloat("Channel",90.1),2) or "Radio OFF"),"Trebuchet24",ScrW*.76,ScrH*.87,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,color_black)
		draw.SimpleTextOutlined("Espace pour activer","Trebuchet24",ScrW*.76,ScrH*.89,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,color_black)
		draw.SimpleTextOutlined("Clic droit pour changer la fréquence","Trebuchet24",ScrW*.76,ScrH*.91,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,color_black)
	end
end

gred.TankSightCalcView = function(vehicle,seat,SeatID,SeatTab,Mode,ply,pos,ang)
	view.origin = pos
	view.drawviewer = false
	
	ply.simfphys_smooth_out = 0
	
	local att = vehicle:GetAttachment(seat.SightAttachment)
	
	if SeatTab.Sight.SightAngOffset or SeatTab.Sight.SightPosOffset then
		att.LPos,att.LAng = vehicle:WorldToLocal(att.Pos),vehicle:WorldToLocalAngles(att.Ang)
		local Pos,Ang = LocalToWorld(SeatTab.Sight.SightPosOffset,SeatTab.Sight.SightAngOffset,att.LPos,att.LAng)
		att.Pos = vehicle:LocalToWorld(Pos)
		att.Ang = vehicle:LocalToWorldAngles(Ang)
	end
	
	view.angles = SeatTab.Sight.Stabilizer and RoundAngle(att.Ang,2) or att.Ang
	view.origin = att.Pos
	
	view.fov = SeatTab.Sight.SightFOV - vehicle.LocalPlayerActiveSeat.ZoomVal*SeatTab.Sight.SightFOVZoom
	
	seat.ZoomSensitivityFactor = math.min(view.fov / 30,1)
	
	return view
end



gred.TankSafetyCheck = function(vehicle,callback)
	if !vehicle.CachedSpawnList or !vehicle.pSeat or !vehicle.ViewPortAttachments then
		return gred.InitializeSimfphys(vehicle,callback)
	else
		if callback then callback() end
		return true
	end
end



gred.TankStopMG = function(seat,SeatID,vehicle,IsPrimary)
	local WeaponTab = gred.simfphys[vehicle.CachedSpawnList].Seats[SeatID][vehicle.ArcadeMode and "ArcadeMode" or "NormalMode"][IsPrimary and "Primary" or "Secondary"]
	local SeatSlotTab = seat[IsPrimary and "Primary" or "Secondary"]
	
	if IsPrimary then
		local SlotID = seat:GetNWInt("SlotID",1)
		WeaponTab = WeaponTab[SlotID]
		SeatSlotTab = SeatSlotTab[SlotID]
	end
	
	gred.PlayStopSound(seat,SeatID,vehicle,SeatSlotTab,WeaponTab,LocalPlayer())
end

gred.TankShootCannon = function(seat,SeatID,vehicle,IsPrimary)
	if !SeatID then return end
	
	local SlotID = seat:GetNWInt("SlotID",1)
	local WeaponTab = gred.simfphys[vehicle.CachedSpawnList].Seats[SeatID][vehicle.ArcadeMode and "ArcadeMode" or "NormalMode"][IsPrimary and "Primary" or "Secondary"]
	local SeatSlotTab = seat[IsPrimary and "Primary" or "Secondary"]
	
	if IsPrimary then
		WeaponTab = WeaponTab[SlotID]
		SeatSlotTab = SeatSlotTab[SlotID]
	end
	local effectdata = EffectData()
	local v
	
	for k = 1,#SeatSlotTab.Muzzles do
		v = SeatSlotTab.Muzzles[k]
		if v then
			local att = vehicle:GetAttachment(v)
			
			if att then
				-- att.Pos = WeaponTab.MuzzlePosOffset and vehicle:LocalToWorld(vehicle:WorldToLocal(att.Pos) + WeaponTab.MuzzlePosOffset) or att.Pos
				-- att.Ang = WeaponTab.MuzzleAngOffset and att.Ang + WeaponTab.MuzzleAngOffset or att.Ang
				
				effectdata:SetFlags(table.KeyFromValue(gred.Particles,WeaponTab.MuzzleFlash))
				effectdata:SetOrigin(att.Pos)
				effectdata:SetAngles(att.Ang)
				effectdata:SetSurfaceProp(0)
				Effect("gred_particle_simple",effectdata)
			end
			
			effectdata:SetFlags(table.KeyFromValue(gred.Particles,"gred_mortar_explosion_smoke_ground"))
			effectdata:SetOrigin(vehicle:GetPos())
			effectdata:SetAngles(vehicle:GetAngles() + ang_1)
			effectdata:SetSurfaceProp(0)
			Effect("gred_particle_simple",effectdata)
			
			gred.PlayShootSound(seat,SeatID,vehicle,WeaponTab,SeatSlotTab,LocalPlayer())
		end
	end
end

gred.TankShootMG = function(seat,SeatID,vehicle,IsPrimary,SequentialID)
	local SlotID = seat:GetNWInt("SlotID",1)
	local effectdata = EffectData()
	local add = vehicle:GetVelocity() * (FrameTime() + engine.ServerFrameTime())
	local WeaponTab = gred.simfphys[vehicle.CachedSpawnList].Seats[SeatID][vehicle.ArcadeMode and "ArcadeMode" or "NormalMode"][IsPrimary and "Primary" or "Secondary"]
	local SeatSlotTab = seat[IsPrimary and "Primary" or "Secondary"]
	
	if IsPrimary then
		WeaponTab = WeaponTab[SlotID]
		SeatSlotTab = SeatSlotTab[SlotID]
	end
	
	if WeaponTab.Sequential then
		local att = vehicle:GetAttachment(vehicle:LookupAttachment(WeaponTab.Muzzles[SeatSlotTab.CurrentMuzzle])) -- SequentialID
		
		if att then
			att.Pos = (WeaponTab.MuzzlePosOffset and vehicle:LocalToWorld(vehicle:WorldToLocal(att.Pos) + WeaponTab.MuzzlePosOffset) or att.Pos) + add
			att.Ang = WeaponTab.MuzzleAngOffset and att.Ang + WeaponTab.MuzzleAngOffset or att.Ang
			
			if WeaponTab.Type == "MG" then gred.CreateBullet(seat:GetDriver(),att.Pos,att.Ang + gred.TankGetRandomSpreadAngle(SeatID,vehicle,WeaponTab,SeatSlotTab.CurrentMuzzle),WeaponTab.Caliber,vehicle.FILTER,nil,nil,SeatSlotTab.UpdateTracers[SeatSlotTab.CurrentMuzzle](),nil,nil,true) end
			
			effectdata:SetFlags(table.KeyFromValue(gred.Particles,WeaponTab.MuzzleFlash))
			effectdata:SetOrigin(att.Pos)
			effectdata:SetAngles(att.Ang)
			effectdata:SetSurfaceProp(0)
			Effect("gred_particle_simple",effectdata)
		end
		
		SeatSlotTab.CurrentMuzzle = SeatSlotTab.CurrentMuzzle < #WeaponTab.Muzzles and SeatSlotTab.CurrentMuzzle + 1 or 1
		
	elseif WeaponTab.Muzzles then
		local v
		
		for k = 1,#WeaponTab.Muzzles do
			v = WeaponTab.Muzzles[k]
			
			if v then
				local att = vehicle:GetAttachment(vehicle:LookupAttachment(v))
				
				if att then
					att.Pos = (WeaponTab.MuzzlePosOffset and vehicle:LocalToWorld(vehicle:WorldToLocal(att.Pos) + WeaponTab.MuzzlePosOffset) or att.Pos) + add
					att.Ang = WeaponTab.MuzzleAngOffset and att.Ang + WeaponTab.MuzzleAngOffset or att.Ang
					
					if WeaponTab.Type == "MG" then gred.CreateBullet(seat:GetDriver(),att.Pos,att.Ang + gred.TankGetRandomSpreadAngle(SeatID,vehicle,WeaponTab,k),WeaponTab.Caliber,vehicle.FILTER,nil,nil,SeatSlotTab.UpdateTracers[k](),nil,nil,true) end
					
					effectdata:SetFlags(table.KeyFromValue(gred.Particles,WeaponTab.MuzzleFlash))
					effectdata:SetOrigin(att.Pos)
					effectdata:SetAngles(att.Ang)
					effectdata:SetSurfaceProp(0)
					Effect("gred_particle_simple",effectdata)
				end
			end
		end
	end
	
	if WeaponTab.Type == "MG" then SeatSlotTab.NextShot = CurTime() + SeatSlotTab.FireRate end
	
	gred.PlayShootSound(seat,SeatID,vehicle,WeaponTab,SeatSlotTab,LocalPlayer())
end



gred.PlayReloadSound = function(seat,SeatID,vehicle,WeaponTab,SeatSlotTab,ply)
	if WeaponTab.Sounds.ReloadInside and gred.PlayerIsInsideVehicle(ply,vehicle,seat,SeatID) then
		if SeatSlotTab.Sounds.ReloadInside then
			SeatSlotTab.Sounds.ReloadInside:Stop()
		end
		
		SeatSlotTab.Sounds.ReloadInside = CreateSound(seat,WeaponTab.Sounds.ReloadInside[math.random(#WeaponTab.Sounds.ReloadInside)])
		
		SeatSlotTab.Sounds.ReloadInside:Play()
	else
		if SeatSlotTab.Sounds.Reload then
			SeatSlotTab.Sounds.Reload:Stop()
		end
		
		SeatSlotTab.Sounds.Reload = CreateSound(seat,WeaponTab.Sounds.Reload[math.random(#WeaponTab.Sounds.Reload)])
		
		SeatSlotTab.Sounds.Reload:Play()
	end
end

gred.PlayShootSound = function(seat,SeatID,vehicle,WeaponTab,SeatSlotTab,ply)
	if (WeaponTab.Sounds.ShootInside or WeaponTab.Sounds.LoopInside) and gred.PlayerIsInsideVehicle(ply,vehicle,seat,SeatID) then
		if SeatSlotTab.Sounds.Loop then
			SeatSlotTab.Sounds.Loop:Stop()
		end
		
		if WeaponTab.Sounds.ShootInside then
			if SeatSlotTab.Sounds.ShootInside then 
				SeatSlotTab.Sounds.ShootInside:Stop()
			end
			
			if #WeaponTab.Sounds.ShootInside > 1 or !SeatSlotTab.Sounds.ShootInside then
				SeatSlotTab.Sounds.ShootInside = CreateSound(seat,WeaponTab.Sounds.ShootInside[math.random(#WeaponTab.Sounds.ShootInside)]) 
			end
			
			if WeaponTab.Type == "Cannon" then
				seat:EmitSound("GRED_CANNON_MECH_INSIDE_0"..math.random(3))
			end
			
			SeatSlotTab.Sounds.ShootInside:Play()
		end
		
		if WeaponTab.Sounds.LoopInside then
			if !SeatSlotTab.Sounds.LoopInside or (#WeaponTab.Sounds.LoopInside > 1 and !SeatSlotTab.Sounds.LoopInside:IsPlaying()) then
				SeatSlotTab.Sounds.LoopInside = CreateSound(seat,WeaponTab.Sounds.LoopInside[math.random(#WeaponTab.Sounds.LoopInside)])
			end
			
			SeatSlotTab.Sounds.LoopInside:Play()
		end
	else
		if SeatSlotTab.Sounds.LoopInside then 
			SeatSlotTab.Sounds.LoopInside:Stop() 
		end
		
		if WeaponTab.Sounds.Shoot then
			if SeatSlotTab.Sounds.Shoot then 
				SeatSlotTab.Sounds.Shoot:Stop() 
			end
			
			if #WeaponTab.Sounds.Shoot > 1 or !SeatSlotTab.Sounds.Shoot then 
				SeatSlotTab.Sounds.Shoot = CreateSound(seat,WeaponTab.Sounds.Shoot[math.random(#WeaponTab.Sounds.Shoot)])
			end
			
			SeatSlotTab.Sounds.Shoot:Play()
		end
		
		if WeaponTab.Sounds.Loop then
			if !SeatSlotTab.Sounds.Loop or (#WeaponTab.Sounds.Loop > 1 and !SeatSlotTab.Sounds.Loop:IsPlaying()) then
				SeatSlotTab.Sounds.Loop = CreateSound(seat,WeaponTab.Sounds.Loop[math.random(#WeaponTab.Sounds.Loop)])
			end
			
			SeatSlotTab.Sounds.Loop:Play()
		end
	end
end

gred.StopLoopSounds = function(seat,SeatID,vehicle,SeatSlotTab,WeaponTab,ply)
	if SeatSlotTab.Sounds then
		if SeatSlotTab.Sounds.LoopInside then
			SeatSlotTab.Sounds.LoopInside:Stop()
		end
		if SeatSlotTab.Sounds.Loop then
			SeatSlotTab.Sounds.Loop:Stop()
		end
	end
end

gred.PlayStopSound = function(seat,SeatID,vehicle,SeatSlotTab,WeaponTab,ply)
	gred.StopLoopSounds(seat,SeatID,vehicle,SeatSlotTab,WeaponTab,ply)
	
	if WeaponTab.Sounds.StopInside and gred.PlayerIsInsideVehicle(ply,vehicle,seat,SeatID) then
		if SeatSlotTab.Sounds.StopInside then 
			SeatSlotTab.Sounds.StopInside:Stop() 
		end
		
		if #WeaponTab.Sounds.StopInside > 1 or !SeatSlotTab.Sounds.StopInside then 
			SeatSlotTab.Sounds.StopInside = CreateSound(seat,WeaponTab.Sounds.StopInside[math.random(#WeaponTab.Sounds.StopInside)]) 
		end
		
		SeatSlotTab.Sounds.StopInside:Play()
	elseif WeaponTab.Sounds.Stop then
		if SeatSlotTab.Sounds.Stop then 
			SeatSlotTab.Sounds.Stop:Stop() 
		end
		
		if #WeaponTab.Sounds.Stop > 1 or !SeatSlotTab.Sounds.Stop then 
			SeatSlotTab.Sounds.Stop = CreateSound(seat,WeaponTab.Sounds.Stop[math.random(#WeaponTab.Sounds.Stop)]) 
		end
		
		SeatSlotTab.Sounds.Stop:Play()
	end
end


gred.TankViewPortCalcView = function(vehicle,seat,SeatID,SeatTab,Mode,ViewPortTab,ply,pos,ang)
	if seat:GetNWInt("HatchID",0) != 0 or seat:GetThirdPersonMode() or seat.SightToggle then
		if IsValid(ply.ViewPortModel) and !ViewPortTab.Debug then
			ply.ViewPortModel:SetNoDraw(true)
		end
		return gred.SimfphysCalcViewHack(ply,pos,ang)
	else
		if IsValid(ply.ViewPortModel) and !ViewPortTab.Debug then
			ply.ViewPortModel:SetNoDraw(false)
		end
	end
	view.drawviewer = false
	
	ply.simfphys_smooth_out = 0
	
	local Pos,Ang
	if ViewPortTab.Attachment then
		local att = vehicle:GetAttachment(vehicle:LookupAttachment(ViewPortTab.Attachment))
		att.LPos,att.LAng = vehicle:WorldToLocal(att.Pos),vehicle:WorldToLocalAngles(att.Ang)
		Pos,Ang = LocalToWorld(ViewPortTab.Pos,ViewPortTab.Ang,att.LPos,att.LAng)
		-- view.origin,view.angles = vehicle:LocalToWorld(view.origin),vehicle:LocalToWorldAngles(view.angles)
	else
		Pos,Ang = ViewPortTab.Pos,ViewPortTab.Ang
	end
	
	if ((ViewPortTab.MinAng and ViewPortTab.MaxAng) or vehicle.gred_sv_simfphys_disable_viewmodels) and ((ViewPortTab.FreeView and (!seat:GetNWBool("TurretDisabled") or !ply:KeyDown(IN_WALK))) or (!ViewPortTab.FreeView and (seat:GetNWBool("TurretDisabled") or ply:KeyDown(IN_WALK)))) then
		ang = vehicle:WorldToLocalAngles(ang)
		ang.p = math.Clamp(ang.p,vehicle.gred_sv_simfphys_disable_viewmodels and -180 or ViewPortTab.MinAng.p,vehicle.gred_sv_simfphys_disable_viewmodels and 180 or ViewPortTab.MaxAng.p)
		ang.y = math.Clamp(ang.y,vehicle.gred_sv_simfphys_disable_viewmodels and -180 or ViewPortTab.MinAng.y,vehicle.gred_sv_simfphys_disable_viewmodels and 180 or ViewPortTab.MaxAng.y)
		Ang = Ang + ang
	end
	
	view.origin,view.angles = vehicle:LocalToWorld(Pos),vehicle:LocalToWorldAngles(Ang)
	view.angles.r = ViewPortTab.Attachment and view.angles.r or vehicle:GetAngles().r
	view.fov = nil
	
	return view
end

gred.ModuleHealthChanged = function(vehicle,Name,ID,VarName,NewVal,OldVal)
	if Name == "LeftTrack" then
		if OldVal <= 0 and NewVal > 0 then
			local ent = vehicle.SeparateTracks and vehicle.LeftTrack or vehicle
			
			ent:SetSubMaterial(vehicle.LeftTrackID,"!gred_trackmat_"..vehicle.CachedSpawnList.."_"..vehicle.EntityIndex.."_left") 
		elseif OldVal > 0 and NewVal <= 0 then
			local ent = vehicle.SeparateTracks and vehicle.LeftTrack or vehicle
			
			vehicle.wheel_right_mat_dead = CreateMaterial("gred_trackmat_"..vehicle.CachedSpawnList.."_"..vehicle.EntityIndex.."_left_dead","VertexLitGeneric",DeadTrack)
			ent:SetSubMaterial(vehicle.LeftTrackID,"!gred_trackmat_"..vehicle.CachedSpawnList.."_"..vehicle.EntityIndex.."_left_dead") 
		end
	elseif Name == "RightTrack" then
		if OldVal <= 0 and NewVal > 0 then
			local ent = vehicle.SeparateTracks and vehicle.RightTrack or vehicle
			
			ent:SetSubMaterial(vehicle.RightTrackID,"!gred_trackmat_"..vehicle.CachedSpawnList.."_"..vehicle.EntityIndex.."_right")
		elseif OldVal > 0 and NewVal <= 0 then
			local ent = vehicle.SeparateTracks and vehicle.RightTrack or vehicle
			
			vehicle.wheel_left_mat_dead = CreateMaterial("gred_trackmat_"..vehicle.CachedSpawnList.."_"..vehicle.EntityIndex.."_right_dead","VertexLitGeneric",DeadTrack)
			ent:SetSubMaterial(vehicle.RightTrackID,"!gred_trackmat_"..vehicle.CachedSpawnList.."_"..vehicle.EntityIndex.."_right_dead")
		end
	end
end

gred.HandleHatch = function(vehicle,seat,SeatID,newval,oldval,SeatTab,HatchesTab)
	if !IsValid(vehicle) then return end
	
	local ply = seat:GetDriver()
	
	-- if newval != oldval and IsValid(ply) then
		-- if newval != 0 then
			-- if HatchesTab[newval].PlayerBoneManipulation then
				-- gred.ClearBoneManipulations(ply)
				-- gred.DoBoneManipulation(vehicle,seat,SeatID,ply,HatchesTab[newval].PlayerBoneManipulation)
			-- end
		-- else
			-- gred.ClearBoneManipulations(ply)
			-- gred.DoBoneManipulation(vehicle,seat,SeatID,ply)
		-- end
	-- end
end

gred.HandleSmokeGrenades = function(vehicle,seat,SeatID,oldval,newval,LocalPly,SeatTab,SmokeLaunchersTab)
	if !IsValid(vehicle) then return end
	
	if newval != oldval and newval and oldval then
		if newval > oldval then
			seat.SmokeGrenadesReloading = false
		else
			if newval < 1 then
				seat.SmokeGrenadesReloading = true
			else
				local att = vehicle:GetAttachment(vehicle.SmokeAttachments[SmokeLaunchersTab[oldval]])
				
				local effectdata = EffectData()
				effectdata:SetFlags(table.KeyFromValue(gred.Particles,"muzzleflash_mg42_3p"))
				effectdata:SetOrigin(att.Pos)
				effectdata:SetAngles(att.Ang)
				effectdata:SetSurfaceProp(0)
				Effect("gred_particle_simple",effectdata)
				if gred.PlayerIsInsideVehicle(LocalPly,vehicle,seat,SeatID) then
					seat:EmitSound("SMOKE_LAUNCHER_"..math.random(3))
				else
					seat:EmitSound("SMOKE_LAUNCHER_INSIDE_"..math.random(3))
				end
			end
		end
	end
end

gred.DoBoneManipulation = function(vehicle,seat,SeatID,ply,BoneTab)
	local SeatTab = gred.simfphys[vehicle.CachedSpawnList].Seats[SeatID][vehicle.ArcadeMode and "ArcadeMode" or "NormalMode"]
	
	if SeatTab.PlayerBoneManipulation or BoneTab then
		local Bone
		ply.TankManipulatedBones = ply.TankManipulatedBones or {}
		
		for k,v in pairs(BoneTab or SeatTab.PlayerBoneManipulation) do
			Bone = ply:LookupBone(k)
			if Bone then
				ply.TankManipulatedBones[k] = Bone
				ply:ManipulateBoneAngles(Bone,v)
			end
		end
	end
end

gred.PlayerEnteredSeat = function(vehicle,seat,SeatID,ply)
	gred.ClearStuff(ply)
	vehicle.LocalPlayerActiveSeat = seat
	vehicle.LocalPlayerActiveSeatID = SeatID
	ply.LastLocalPlayerVehicle = vehicle
	ply.DesiredFOV = FOVCvar:GetFloat()
	
	local SeatTab = gred.simfphys[vehicle.CachedSpawnList].Seats and gred.simfphys[vehicle.CachedSpawnList].Seats[SeatID]
	SeatTab = SeatTab and SeatTab[vehicle.Mode]
	
	if SeatTab and SeatTab.ViewPort then
		local ViewPortTab = SeatTab.ViewPort
		
		if ViewPortTab.Model and !vehicle.gred_sv_simfphys_disable_viewmodels then
			local Pos,Ang
			-- if ViewPortTab.Attachment then
				-- local att = vehicle:GetAttachment(vehicle:LookupAttachment(ViewPortTab.Attachment))
				-- att.LPos,att.LAng = vehicle:WorldToLocal(att.Pos),vehicle:WorldToLocalAngles(att.Ang)
				-- Pos,Ang = LocalToWorld(ViewPortTab.Pos + ViewPortTab.ModelPosOffset,ViewPortTab.Ang + ViewPortTab.ModelAngOffset,att.LPos,att.LAng)
				-- Pos,Ang = vehicle:LocalToWorld(Pos),vehicle:LocalToWorldAngles(Ang)
			-- else
				Pos,Ang = vehicle:LocalToWorld(ViewPortTab.Pos + ViewPortTab.ModelPosOffset),vehicle:LocalToWorldAngles(ViewPortTab.Ang + ViewPortTab.ModelAngOffset)
			-- end
			
			ply.ViewPortModel = CreateClientProp(ViewPortTab.Model)
			ply.ViewPortModel:SetParent(vehicle,ViewPortTab.Attachment and vehicle:LookupAttachment(ViewPortTab.Attachment) or nil)
			ply.ViewPortModel:SetPos(Pos)
			ply.ViewPortModel:SetAngles(Ang)
			ply.ViewPortModel:Spawn()
			ply.ViewPortModel:Activate()
			ply.ViewPortModel:SetPredictable(true)
		end
		
		hook.Remove( "CalcView","zz_simfphys_gunner_view")
		hook.Add("CalcView","gred_simfphys_tank_CalcView",function(ply,pos,ang)
			if !IsValid(vehicle) then return end
			if !vehicle.LocalPlayerActiveSeatID then return end
			return gred.TankViewPortCalcView(vehicle,seat,SeatID,SeatTab,vehicle.Mode,ViewPortTab,ply,pos,ang)
		end)
	end
end

gred.PlayerIsInsideVehicle = function(ply,vehicle,seat,SeatID)
	ply = ply or LocalPlayer()
	return vehicle.LocalPlayerActiveSeat and (vehicle.LocalPlayerActiveSeat.SightToggle or (vehicle.LocalPlayerActiveSeat.FirstPersonViewPosIsInside and !vehicle.LocalPlayerActiveSeat:GetThirdPersonMode() and vehicle.LocalPlayerActiveSeat:GetNWBool("HatchID",0) == 0))
	-- return true
end

gred.ClearBoneManipulations = function(ply)
	if !ply.TankManipulatedBones then return end
	-- PrintBones(ply)
	for k,v in pairs(ply.TankManipulatedBones) do
		ply:ManipulateBoneAngles(v,angle_zero)
	end
	ply.TankManipulatedBones = nil
end

gred.ClearStuff = function(ply)
	hook.Remove("HUDPaint","gred_simfphys_tank_HUDPaint")
	hook.Remove("CalcView","gred_simfphys_tank_CalcView")
	hook.Remove("AdjustMouseSensitivity","gred_simfphys_tank_AdjustMouseSensitivity")
	hook.Remove("RenderScene","gred_simfphys_tank_RenderScene")
	hook.Remove("PostDrawTranslucentRenderables","gred_simfphys_tank_PostDrawTranslucentRenderables")
	hook.Add("CalcView","zz_simfphys_gunner_view",gred.SimfphysCalcViewHack)
	
	if IsValid(ply.ViewPortModel) then
		ply.ViewPortModel:SetPredictable(false)
		ply.ViewPortModel:Remove()
	end
	
	if IsValid(ply.LastLocalPlayerVehicle) then
		if IsValid(ply.LastLocalPlayerVehicle.LocalPlayerActiveSeat) then
			local vehicle = ply.LastLocalPlayerVehicle
			local seat = vehicle.LocalPlayerActiveSeat
			seat.SightToggle = nil
			seat.ZoomedToggle = nil
			seat.ZoomVal = 0
			local SeatTab = gred.simfphys[vehicle.CachedSpawnList].Seats
			
			if SeatTab then
				local SeatID = table.KeyFromValue(vehicle.pSeat,seat)
				SeatTab = SeatTab[SeatID] and SeatTab[SeatID][vehicle.ArcadeMode and "ArcadeMode" or "NormalMode"]
				
				if SeatTab then
					if SeatTab.Primary then
						local SlotID = seat:GetNWInt("SlotID",1)
						gred.StopLoopSounds(seat,SeatID,vehicle,seat.Primary[SlotID],SeatTab.Primary[SlotID],ply)
					end
					
					if SeatTab.Secondary then
						gred.StopLoopSounds(seat,SeatID,vehicle,seat.Secondary,SeatTab.Secondary,ply)
					end
				end
			end
		end
		
		ply.LastLocalPlayerVehicle.LocalPlayerActiveSeat = nil
		ply.LastLocalPlayerVehicle.LocalPlayerActiveSeatID = nil
	end
	
	ply.LastLocalPlayerVehicle = nil
	ply.HookAdded = nil
	ply.RenderHooksAdded = nil
end



net.Receive("gred_net_simfphys_shoot_secondary_machinegun_sequential",function(len)
	local seat = net.ReadEntity()
	local SequentialID = net.ReadUInt(5)
	if !IsValid(seat) then return end
	
	local vehicle = seat:GetParent()
	if !IsValid(vehicle) then return end
	
	gred.TankSafetyCheck(vehicle,function()
		if !IsValid(seat) then return end
		gred.TankShootMG(seat,table.KeyFromValue(vehicle.pSeat,seat),vehicle,false,SequentialID)
	end)
end)

net.Receive("gred_net_simfphys_shoot_primary_machinegun_sequential",function(len)
	local seat = net.ReadEntity()
	local SequentialID = net.ReadUInt(5)
	if !IsValid(seat) then return end
	
	local vehicle = seat:GetParent()
	if !IsValid(vehicle) then return end
		
	gred.TankSafetyCheck(vehicle,function()
		if !IsValid(seat) then return end
		gred.TankShootMG(seat,table.KeyFromValue(vehicle.pSeat,seat),vehicle,true,SequentialID)
	end)
end)

net.Receive("gred_net_simfphys_playerenteredseat_broadcast",function(len)
	local ply = net.ReadEntity()
	timer.Simple(0.2,function()
		if !IsValid(ply) then return end
		
		local seat = ply:GetVehicle()
		if !IsValid(seat) then return end
		
		local vehicle = seat:GetParent()
		if !IsValid(vehicle) then return end
		
		gred.TankSafetyCheck(vehicle,function()
			if seat != ply:GetVehicle() or !IsValid(seat) then return end
			
			local SeatID = table.KeyFromValue(vehicle.pSeat,seat)
			-- gred.DoBoneManipulation(vehicle,seat,SeatID,ply)
			
			if ply == LocalPlayer() then
				gred.PlayerEnteredSeat(vehicle,seat,SeatID,ply)
			end
		end)
	end)
end)

net.Receive("gred_net_simfphys_shoot_secondary_machinegun",function(len)
	local seat = net.ReadEntity()
	if !IsValid(seat) then return end
	
	local vehicle = seat:GetParent()
	if !IsValid(vehicle) then return end
	
	gred.TankSafetyCheck(vehicle,function()
		if !IsValid(seat) then return end
		gred.TankShootMG(seat,table.KeyFromValue(vehicle.pSeat,seat),vehicle,false)
	end)
end)

net.Receive("gred_net_simfphys_shoot_secondary_tankCannon",function(len)
	local seat = net.ReadEntity()
	if !IsValid(seat) then return end
	
	local vehicle = seat:GetParent()
	if !IsValid(vehicle) then return end
	
	gred.TankSafetyCheck(vehicle,function()
		if !IsValid(seat) then return end
		gred.TankShootCannon(seat,table.KeyFromValue(vehicle.pSeat,seat),vehicle,false)
	end)
end)

net.Receive("gred_net_simfphys_stop_secondary_machinegun",function(len)
	local seat = net.ReadEntity()
	if !IsValid(seat) then return end
	
	local vehicle = seat:GetParent()
	if !IsValid(vehicle) then return end
	
	gred.TankSafetyCheck(vehicle,function()
		if !IsValid(seat) then return end
		gred.TankStopMG(seat,table.KeyFromValue(vehicle.pSeat,seat),vehicle,false)
	end)
end)

net.Receive("gred_net_simfphys_shoot_primary_machinegun",function(len)
	local seat = net.ReadEntity()
	if !IsValid(seat) then return end
	
	local vehicle = seat:GetParent()
	if !IsValid(vehicle) then return end
	
	gred.TankSafetyCheck(vehicle,function()
		if !IsValid(seat) then return end
		gred.TankShootMG(seat,table.KeyFromValue(vehicle.pSeat,seat),vehicle,true)
	end)
end)

net.Receive("gred_net_simfphys_shoot_primary_tankCannon",function(len)
	local seat = net.ReadEntity()
	if !IsValid(seat) then return end
	
	local vehicle = seat:GetParent()
	if !IsValid(vehicle) then return end
	
	gred.TankSafetyCheck(vehicle,function()
		if !IsValid(seat) then return end
		gred.TankShootCannon(seat,table.KeyFromValue(vehicle.pSeat,seat),vehicle,true)
	end)
end)

net.Receive("gred_net_simfphys_stop_primary_machinegun",function(len)
	local seat = net.ReadEntity()
	if !IsValid(seat) then return end
	
	local vehicle = seat:GetParent()
	if !IsValid(vehicle) then return end
	
	gred.TankSafetyCheck(vehicle,function() 
		if !IsValid(seat) then return end
		gred.TankStopMG(seat,table.KeyFromValue(vehicle.pSeat,seat),vehicle,true)
	end)
end)

net.Receive("gred_net_simfphys_clearbonemanipulations",function(len)
	local ply = net.ReadEntity()
	if !IsValid(ply) then return end
	
	gred.ClearBoneManipulations(ply)
end)

net.Receive("gred_net_simfphys_playerenteredseat",function(len)
	timer.Simple(0.2,function()
		local ply = LocalPlayer()
		local seat = ply:GetVehicle()
		if !IsValid(seat) then return end
		
		local vehicle = seat:GetParent()
		if !IsValid(vehicle) then return end
		
		gred.TankSafetyCheck(vehicle,function()
			if seat != ply:GetVehicle() or !IsValid(seat) then return end
			gred.PlayerEnteredSeat(vehicle,seat,table.KeyFromValue(vehicle.pSeat,seat),ply)
		end)
	end)
end)

net.Receive("gred_net_simfphys_playerexitedseat",function(len)
	gred.ClearStuff(LocalPlayer())
end)

net.Receive("gred_net_simfphys_update_tracks",function(len)
	local vehicle = net.ReadEntity()
	if !IsValid(vehicle) then return end
	
	vehicle.trackspin_l = net.ReadInt(15) * 1.25
	vehicle.trackspin_r = net.ReadInt(15) * 1.25
end)

