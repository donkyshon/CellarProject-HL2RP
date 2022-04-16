include("gredwitch/gred_autorun_shared.lua")

local util = util 
local pairs = pairs
local table = table
local istable = istable
local TraceLine = util.TraceLine
local Effect = util.Effect
local MASK_ALL = MASK_ALL
local game = game
local PrecacheParticleSystem = PrecacheParticleSystem
local CreateConVar = CreateConVar
local CreateClientConVar = CreateClientConVar
local tableinsert = table.insert
local IsValid = IsValid
local ply = LocalPlayer()

gred = gred or {}
gred.simfphys = gred.simfphys or {}
gred.CVars = gred.CVars or {}

timer.Simple(2,function()
	gred.AddonList = {}
	gred.RequiredAddons = {}
end)

gred.CVars["gred_cl_resourceprecache"] 						= CreateClientConVar("gred_cl_resourceprecache"						, "0" ,true,false)
gred.CVars["gred_cl_sound_shake"] 							= CreateClientConVar("gred_cl_sound_shake"							, "1" ,true,false)
gred.CVars["gred_cl_nowaterimpacts"] 						= CreateClientConVar("gred_cl_nowaterimpacts"						, "0" ,true,false)
gred.CVars["gred_cl_insparticles"]		 					= CreateClientConVar("gred_cl_insparticles"							, "0" ,true,false)
gred.CVars["gred_cl_noparticles_7mm"] 						= CreateClientConVar("gred_cl_noparticles_7mm"						, "0" ,true,false)
gred.CVars["gred_cl_noparticles_12mm"] 						= CreateClientConVar("gred_cl_noparticles_12mm"						, "0" ,true,false)
gred.CVars["gred_cl_noparticles_20mm"] 						= CreateClientConVar("gred_cl_noparticles_20mm"						, "0" ,true,false)
gred.CVars["gred_cl_noparticles_30mm"] 						= CreateClientConVar("gred_cl_noparticles_30mm"						, "0" ,true,false)
gred.CVars["gred_cl_noparticles_40mm"] 						= CreateClientConVar("gred_cl_noparticles_40mm"						, "0" ,true,false)
gred.CVars["gred_cl_decals"] 								= CreateClientConVar("gred_cl_decals"								, "1" ,true,false)
gred.CVars["gred_cl_altmuzzleeffect"] 						= CreateClientConVar("gred_cl_altmuzzleeffect"						, "1" ,true,false)
gred.CVars["gred_cl_wac_explosions"] 						= CreateClientConVar("gred_cl_wac_explosions" 						, "1" ,true,false)
gred.CVars["gred_cl_enable_popups"] 						= CreateClientConVar("gred_cl_enable_popups"	 					, "1" ,true,false)
gred.CVars["gred_cl_firstload"] 							= CreateClientConVar("gred_cl_firstload"							, "1" ,true,false)
gred.CVars["gred_cl_simfphys_enablecrosshair"]				= CreateClientConVar("gred_cl_simfphys_enablecrosshair"				, "1" ,true,false)
gred.CVars["gred_cl_simfphys_sightsensitivity"] 			= CreateClientConVar("gred_cl_simfphys_sightsensitivity"			,"0.25",true,false)
gred.CVars["gred_cl_simfphys_maxsuspensioncalcdistance"] 	= CreateClientConVar("gred_cl_simfphys_maxsuspensioncalcdistance"	, "85000000" ,true,false)
gred.CVars["gred_cl_simfphys_viewport_fovnodraw"] 			= CreateClientConVar("gred_cl_simfphys_viewport_fovnodraw"			,"15",true,false)
gred.CVars["gred_cl_simfphys_viewport_fovnodraw_vertical"] 	= CreateClientConVar("gred_cl_simfphys_viewport_fovnodraw_vertical"	,"0.75",true,false)
gred.CVars["gred_cl_simfphys_viewport_hq"] 					= CreateClientConVar("gred_cl_simfphys_viewport_hq"					,"0",true,false)
gred.CVars["gred_cl_simfphys_suspensions"] 					= CreateClientConVar("gred_cl_simfphys_suspensions"					, "1" ,true,false)
gred.CVars["gred_cl_simfphys_testviewports"] 				= CreateClientConVar("gred_cl_simfphys_testviewports"				, "0" ,true,false)
gred.CVars["gred_cl_favouritetab"] 							= CreateClientConVar("gred_cl_favouritetab"							, "HOME" ,true,false)
gred.CVars["gred_cl_shell_blur"] 							= CreateClientConVar("gred_cl_shell_blur"							, "1" ,true,false)
gred.CVars["gred_cl_shell_blur_invehicles"] 				= CreateClientConVar("gred_cl_shell_blur_invehicles"				, "1" ,true,false)
gred.CVars["gred_cl_shell_enable_killcam"] 					= CreateClientConVar("gred_cl_shell_enable_killcam"					, "1" ,true,false)
gred.CVars["gred_cl_simfphys_camera_tankgunnersight"] 		= CreateClientConVar("gred_cl_simfphys_camera_tankgunnersight"		, "0" ,true,false)
gred.CVars["gred_cl_explosionvolume"] 						= CreateClientConVar("gred_cl_explosionvolume"						, "1" ,true,false)

local TAB_PRESS = {FCVAR_ARCHIVE,FCVAR_USERINFO}
gred.CVars["gred_cl_simfphys_key_changeshell"]				= CreateConVar("gred_cl_simfphys_key_changeshell"			, "21",TAB_PRESS)
gred.CVars["gred_cl_simfphys_key_togglesight"]				= CreateConVar("gred_cl_simfphys_key_togglesight"			, "22",TAB_PRESS)
gred.CVars["gred_cl_simfphys_key_togglegun"]				= CreateConVar("gred_cl_simfphys_key_togglegun"				, "23",TAB_PRESS)
gred.CVars["gred_cl_simfphys_key_togglehatch"]				= CreateConVar("gred_cl_simfphys_key_togglehatch"			, "25",TAB_PRESS)
gred.CVars["gred_cl_simfphys_key_togglezoom"]				= CreateConVar("gred_cl_simfphys_key_togglezoom"			, "79",TAB_PRESS)
gred.CVars["gred_cl_simfphys_key_throwsmoke"]				= CreateConVar("gred_cl_simfphys_key_throwsmoke"			, "17",TAB_PRESS)

gred.Precache()
if gred.CVars["gred_cl_resourceprecache"]:GetBool() then
	gred.PrecacheResources()
end


local OverrideHAB 		= gred.CVars["gred_sv_override_hab"]
local Tracers 			= gred.CVars["gred_sv_tracers"]
local BulletDMG 		= gred.CVars["gred_sv_bullet_dmg"]
local HE12MM 			= gred.CVars["gred_sv_12mm_he_impact"]
local HE7MM 			= gred.CVars["gred_sv_7mm_he_impact"]
local HERADIUS 			= gred.CVars["gred_sv_bullet_radius"]
local Effect = util.Effect
local TraceLine = util.TraceLine
local QuickTrace = util.QuickTrace
local tr = { collisiongroup = COLLISION_GROUP_WORLD }
local BulletID = 0
local vector_zero = Vector()
local WorldMin,WorldMax

local CAL_TABLE = {
	["wac_base_7mm"] = 1,
	["wac_base_12mm"] = 2,
	["wac_base_20mm"] = 3,
	["wac_base_30mm"] = 4,
	["wac_base_40mm"] = 5,
}
local COL_TABLE = {
	["none"]   = 0,
	["red"]    = 1,
	["green"]  = 2,
	["white"]  = 3,
	["yellow"] = 4,
}

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
})

local function IsInWorld(pos)
	if not WorldMax then
		WorldMin,WorldMax = game.GetWorld():GetModelBounds()
	end
	
	return pos:WithinAABox(WorldMin,WorldMax)
end

local function CheckForConflicts()
	if steamworks.IsSubscribed("2083101470") and steamworks.ShouldMountAddon("2083101470") then
		local DFrame = vgui.Create("DFrame")
		DFrame:SetSize(ScrW()*0.5,ScrH()*0.5)
		DFrame:SetTitle("Gredwitch's Base : CONFLICTING ADDON FOUND!! PLEASE REMOVE IT IF YOU WANT TO USE MY TANKS")
		DFrame:Center()
		DFrame:MakePopup()
		
		local DButton = vgui.Create("DButton",DFrame)
		DButton:Dock(FILL)
		DButton:SetText("UH OH, YOU HAVE '[simfphys] Trailers Reborn' INSTALLED!\nTHIS WILL CAUSE MAJOR ISSUES WITH GREDWITCH'S SIMFPHYS VEHICLES AND / OR OTHER SIMFPHYS VEHICLES! CLICK HERE TO OPEN THE ADDON PAGE AND REMOVE IT!")
		DButton.DoClick = function()
			gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2083101470")
		end
	end
end

local function CheckForUpdates()
	local CURRENT_VERSION = ""
	local changelogs = file.Exists("changelog.lua","LUA") and file.Read("changelog.lua","LUA") or false
	changelogs = changelogs or (file.Exists("changelog.lua","lsv") and file.Read("changelog.lua","lsv") or "")
	for i = 1,14 do if !changelogs[i] then break end CURRENT_VERSION = CURRENT_VERSION..changelogs[i] end
	local GITHUB_VERSION = "" 
	local GitHub = http.Fetch("https://raw.githubusercontent.com/Gredwitch/gredwitch-base/master/Base%20Addon/lua/changelog.lua",function(body)
		if !body then return end
		for i = 1,14 do GITHUB_VERSION = GITHUB_VERSION..body[i] end
		if CURRENT_VERSION != GITHUB_VERSION then
			local DFrame = vgui.Create("DFrame")
			DFrame:SetSize(ScrW()*0.9,ScrH()*0.9)
			DFrame:SetTitle("GREDWITCH'S BASE IS OUT OF DATE. EXPECT LUA ERRORS!")
			DFrame:Center()
			DFrame:MakePopup()
			
			local DHTML = vgui.Create("DHTML",DFrame)
			DHTML:Dock(FILL)
			DHTML:OpenURL("https://steamcommunity.com/workshop/filedetails/discussion/1131455085/1640915206496685563/")
		end
	end)
	local exists = file.Exists("gredwitch_base.txt","DATA")
	if !exists or (exists and file.Read("gredwitch_base.txt","DATA") != CURRENT_VERSION) then
		local DFrame = vgui.Create("DFrame")
		DFrame:SetSize(ScrW()*0.5,ScrH()*0.5)
		DFrame:SetTitle("Gredwitch's Base : last update changelogs")
		DFrame:Center()
		DFrame:MakePopup()
		
		local DHTML = vgui.Create("DHTML",DFrame)
		DHTML:Dock(FILL)
		DHTML:OpenURL("https://raw.githubusercontent.com/Gredwitch/gredwitch-base/master/Base%20Addon/lua/changelog.lua")
		
		file.Write("gredwitch_base.txt",CURRENT_VERSION)
	end
end

local function CheckDXDiag()
	if GetConVar("mat_dxlevel"):GetInt() < 90 then
		local DFrame = vgui.Create("DFrame")
		DFrame:SetSize(ScrW()*0.9,ScrH()*0.9)
		DFrame:SetTitle("DXDIAG ERROR")
		DFrame:Center()
		DFrame:MakePopup()
		
		local DHTML = vgui.Create("DHTML",DFrame)
		DHTML:Dock(FILL)
		DHTML:OpenURL("https://steamcommunity.com/workshop/filedetails/discussion/1131455085/3166519278505386201/")
	end
end

local function CreateTracer(startpos,cal,tracercolor,endpos)
	local effect = EffectData()
	effect:SetOrigin(startpos)
	effect:SetFlags(cal)
	effect:SetMaterialIndex(tracercolor)
	effect:SetStart(endpos)
	Effect("gred_particle_tracer",effect)
end

local function CreateWaterImpact(pos,cal)
	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	effectdata:SetAngles(angle_zero)
	effectdata:SetSurfaceProp(0)
	effectdata:SetMaterialIndex(0)
	effectdata:SetFlags(cal)
	Effect("gred_particle_impact",effectdata)
end

local function CreateImpact(pos,ang,surfaceprop,cal)
	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	effectdata:SetAngles(ang)
	effectdata:SetSurfaceProp(surfaceprop)
	effectdata:SetMaterialIndex(1)
	effectdata:SetFlags(cal)
	
	Effect("gred_particle_impact",effectdata)
end

local function BulletExplode(ply,NoBullet,tr,cal,filter,ang,NoParticle,explodable,dmg,radius,fusetime,IsShared)
	ply = IsValid(ply) and ply or Entity(0)
	local hitang
	local hitpos
	local HitSky = false
	
	if istable(tr) then -- if tr isn't a table, then it's a vector
		hitang = tr.HitNormal:Angle()
		hitpos = tr.HitPos
		if cal == "wac_base_7mm" or cal == "wac_base_12mm" then
			hitang.p = hitang.p + 90
		end
		HitSky = tr.HitSky
	else
		hitang = angle_zero
		hitpos = tr
		HitSky = true
	end
	
	if not explodable then
		if HitSky or NoParticle then return end
		
		CreateImpact(hitpos,hitang,gred.Mats[util.GetSurfacePropName(tr.SurfaceProps)] or 24,gred.CalTable[cal].ID)
		
		-- if cal == "wac_base_12mm" then
			-- sound.Play("impactsounds/gun_impact_"..math.random(1,14)..".wav",hitpos,75,100,0.5)
		-- end
	else
		if cal == "wac_base_30mm" then
			sound.Play("impactsounds/30mm_old.wav",hitpos,110,math.random(90,110),1)
		else
			sound.Play("impactsounds/20mm_0"..math.random(1,5)..".wav",hitpos,100,100,0.7)
		end
		
		if not NoParticle then
			CreateImpact(hitpos,hitang,HitSky and 1 or 0,gred.CalTable[cal].ID,4)
		end
	end
end


gred.CheckConCommand = function(cmd,val)
	if !val or !cmd then return end
	net.Start("gred_net_checkconcommand")
		net.WriteString(cmd)
		net.WriteFloat(val)
	net.SendToServer()
end

gred.CreateBullet = function(ply,pos,ang,cal,filter,fusetime,NoBullet,tracer,dmg,radius)
	if hab and hab.Module.PhysBullet and OverrideHAB:GetInt() == 0 then
		phybullet.AmmoType		= cal..(tracer and tracer or "")
		phybullet.Num 			= 1
		phybullet.Src 			= pos
		phybullet.Dir 			= ang:Forward()
		phybullet.Spread 		= vector_zero
		phybullet.Tracer		= 0--tracer and 0 or 1
		phybullet.IsNetworked	= false
		phybullet.IgnoreEntity = filter
		phybullet.Distance		= false
		phybullet.Damage		= ((cal == "wac_base_7mm" and HE7MM:GetBool()) or (cal == "wac_base_12mm" and HE12MM:GetBool())) and 0 or (dmg and dmg or (cal == "wac_base_7mm" and 40 or (cal == "wac_base_12mm" and 60 or (cal == "wac_base_20mm" and 80 or (cal == "wac_base_30mm" and 100 or (cal == "wac_base_40mm" and 120)))))) * BulletDMG:GetFloat()
		phybullet.Force		= phybullet.Damage*0.1
		
		ply:FirePhysicalBullets(phybullet)
	else
		World = IsValid(World) or Entity(0)
		BulletID = BulletID + 1
		
		local caltab = gred.CalTable[cal]
		local speed = caltab.Speed
		local dmg = (dmg or caltab.Damage) * BulletDMG:GetFloat()
		local radius = (radius or 70) * caltab.RadiusMul * HERADIUS:GetFloat()
		local expltime = fusetime and CurTime() + fusetime
		
		local fwd = ang:Forward()
		local explodable = caltab.Explodeable
		
		local dir = fwd * speed
		local endpos = pos + Vector()
		
		local NoParticle
		local oldbullet = BulletID
		
		if tracer then
			tracer = tracer:lower()
			
			if COL_TABLE[tracer] then
				CreateTracer(pos,CAL_TABLE[cal],COL_TABLE[tracer],QuickTrace(pos,expltime and fwd*(fusetime*speed) or fwd*99999999999999,filter).HitPos)
			end
		end
		
		local BulletTrTab = {}
		BulletTrTab.filter = filter
		BulletTrTab.mask = MASK_SHOT
		
		timer.Create("gred_bullet_"..oldbullet,0,0,function()
			endpos:Add(dir)
			
			BulletTrTab.start = pos
			BulletTrTab.endpos = endpos
			
			-- local lifetime = 3
			-- local add = ang:Right()*100 * 0
			-- local debugpos = pos + add
			-- debugoverlay.Line(debugpos,endpos + add,lifetime,color_white)
			-- debugoverlay.Cross(debugpos,30,lifetime,color_white)
			-- debugoverlay.EntityTextAtPosition(debugpos,1,SysTime(),lifetime,color_white)
			
			local tr = TraceLine(BulletTrTab)
			
			pos.x = endpos.x
			pos.y = endpos.y
			pos.z = endpos.z
			
			if tr.MatType == 83 then
				CreateWaterImpact(tr.HitPos,caltab.ID,3)
				
				NoParticle = true
				sound.Play("impactsounds/water_bullet_impact_0"..math.random(1,5)..".wav",tr.HitPos,75,100,1)
			end
			
			if tr.Hit and not (IsValid(tr.Entity) and tr.Entity:GetClass() == "func_breakable") then
				BulletExplode(ply,NoBullet,tr,cal,filter,ang,NoParticle,explodable,dmg,radius,fusetime,IsShared)
				timer.Remove("gred_bullet_"..oldbullet)
				return
			else
				if !IsInWorld(pos) then
					if explodable then 
						BulletExplode(ply,NoBullet,tr,cal,filter,ang,NoParticle,explodable,dmg,radius,fusetime,IsShared)
					end
					timer.Remove("gred_bullet_"..oldbullet)
				else
					pos = pos
				end
			end
			
			if expltime and CurTime() >= expltime then
				BulletExplode(ply,NoBullet,pos,cal,filter,ang,NoParticle,explodable,dmg,radius,fusetime,IsShared)
				timer.Remove("gred_bullet_"..oldbullet)
				return
			end
		end)
	end
end


hook.Add("PopulateToolMenu","gred_menu",function()
	spawnmenu.AddToolMenuOption("Options",
								"Gredwitch's Stuff",
								"gred_settings",
								"Options",
								"",
								"",
								function(CPanel)
									CPanel:ClearControls()
									
									local DButton = vgui.Create("DButton")
									DButton:SetText("Options..")
									DButton.DoClick = function(DButton)
										gred.OpenOptions()
									end
									CPanel:AddItem(DButton)
								end)
end)

local BulletID = 0

local CAL_TABLE = {
	[1] = "7mm",
	[2] = "12mm",
	[3] = "20mm",
	[4] = "30mm",
	[5] = "40mm",
}
local COL_TABLE = {
	[1] = "red",
	[2] = "green",
	[3] = "white",
	[4] = "yellow",
	-- [5] = "blue",
}

net.Receive("gred_net_createbullet",function()
	local pos = net.ReadVector()
	local ang = net.ReadAngle()
	local cal = net.ReadUInt(3)
	local tracer = net.ReadUInt(3)
	local caliber = CAL_TABLE[cal]
	local Tracer = COL_TABLE[tracer]
	local fusetime = net.ReadUInt(7) * 0.01
	
	local expltime = fusetime > 0 and fusetime and CurTime() + fusetime
	
	local caltab = gred.CalTable[caliber]
	local speed = caltab.Speed
	local fwd = ang:Forward()
	local oldpos = pos - fwd * speed
	local explodable = caltab.Explodeable
	local dif = Vector()
	local BulletTrTab = {}
	
	if Tracer then
		local effect = EffectData()
		effect:SetOrigin(pos)
		effect:SetFlags(cal)
		effect:SetMaterialIndex(tracer)
		effect:SetStart(util.QuickTrace(pos + fwd * 10,expltime and fwd*(fusetime*speed) or fwd*99999999999999,filter).HitPos)
	end
	
	Effect("gred_particle_tracer",effect)
	
	timer.Create("gred_bullet_"..BulletID,0,0,function()
		dif.x = pos.x + pos.x - oldpos.x
		dif.y = pos.y + pos.y - oldpos.y
		dif.z = pos.z + pos.z - oldpos.z
		
		BulletTrTab.start = pos
		BulletTrTab.endpos = dif
		BulletTrTab.filter = filter
		BulletTrTab.mask = MASK_ALL
		
		local tr = TraceLine(BulletTrTab)
	end)
	
	BulletID = BulletID + 1
end)

net.Receive("gred_net_send_ply_hint_key",function()
	surface.PlaySound("ambient/water/drip"..math.random(1,4)..".wav")
	notification.AddLegacy("Press the '"..input.GetKeyName(net.ReadInt(9))..net.ReadString(),NOTIFY_HINT,10)
end)

net.Receive("gred_net_check_binding_simfphys",function()
	if input.LookupBinding("+walk") != nil then return end
	
	local DFrame = vgui.Create("DFrame")
	DFrame:SetSize(ScrW()*0.9,ScrH()*0.9)
	DFrame:Center()
	DFrame:MakePopup()
	DFrame:SetDraggable(false)
	DFrame:ShowCloseButton(false)
	DFrame:SetTitle("YOU DON'T HAVE YOUR +WALK KEY BOUND, WHICH IS REQUIRED IF YOU WANT THE TANK TURRET TO WORK")
	
	timer.Simple(3,function()
		if !IsValid(DFrame) then return end
		DFrame:ShowCloseButton(true)
	end)
	
	local DHTML = vgui.Create("DHTML",DFrame)
	DHTML:Dock(FILL)
	DHTML:OpenURL("https://steamuserimages-a.akamaihd.net/ugc/773983150582822983/8FAB41F8FDC796EF2033B0AF3379DF5734DDC150/")
	
end)

net.Receive("gred_net_send_ply_hint_simple",function()
	surface.PlaySound("ambient/water/drip"..math.random(1,4)..".wav")
	notification.AddLegacy(net.ReadString(),NOTIFY_HINT,10)
end)

net.Receive("gred_net_message_ply",function()
	ply = IsValid(ply) and ply or LocalPlayer()
	local msg = net.ReadString()
	ply:PrintMessage(HUD_PRINTTALK,msg)
end)

net.Receive("gred_net_bombs_decals",function()
	local decal = net.ReadString()
	local start = net.ReadVector()
	local hitpos = net.ReadVector()
	if GetConVar("gred_cl_decals"):GetInt() <= 0 then return end
	util.Decal(decal,start,hitpos)
end)

net.Receive("gred_net_sound_lowsh",function()
	ply = IsValid(ply) and ply or LocalPlayer()
	ply:GetViewEntity():EmitSound(net.ReadString())
end)

net.Receive("gred_net_nw_var",function()
	local self = net.ReadEntity()
	local str = net.ReadString()
	local t = net.ReadInt(4)
	if t == 1 then
		local val = net.ReadString()
		self:SetNWString(str,val)
	elseif t == 2 then
		local ent = net.ReadEntity()
		self:SetNWEntity(str,ent)
	elseif t == 3 then
		local table = net.ReadTable()
		self:SetNWTable(str,table)
	end
end)

net.Receive("gred_net_createtracer",function()
	CreateTracer(net.ReadVector(),net.ReadUInt(3),net.ReadUInt(3),net.ReadVector())
end)

net.Receive("gred_net_createimpact",function()
	CreateImpact(net.ReadVector(),net.ReadAngle(),net.ReadUInt(5),net.ReadUInt(4))
end)

local angle_zero = Angle()

net.Receive("gred_net_createwaterimpact",function()
	CreateWaterImpact(net.ReadVector(),net.ReadUInt(3))
end)

net.Receive("gred_net_createparticle",function()
	local effectdata = EffectData()
	effectdata:SetFlags(table.KeyFromValue(gred.Particles,net.ReadString()) or "")
	effectdata:SetOrigin(net.ReadVector())
	effectdata:SetAngles(net.ReadAngle())
	effectdata:SetSurfaceProp(net.ReadBool() and 1 or 0)
	Effect("gred_particle_simple",effectdata)
end)

net.Receive("gred_net_applyboolonsimfphys_cl",function()
	local str = net.ReadString()
	local cvar = gred.CVars[str]
	if !cvar then return end
	
	local bool = cvar:GetBool()
	
	for k,v in pairs(gred.ActiveSimfphysVehicles) do
		v[str] = bool
	end
end)

net.Receive("gred_net_applyfloatonsimfphys_cl",function()
	local str = net.ReadString()
	local cvar = gred.CVars[str]
	if !cvar then return end
	
	local val = cvar:GetFloat()
	
	for k,v in pairs(gred.ActiveSimfphysVehicles) do
		v[str] = val
	end
end)

local soundSpeed 		= 18005.25*18005.25 -- 343m/s

local Level = {
	[1] = {
		112,
		150,
		150,
	},
	[2] = {
		-- 100,
		-- 120,
		-- 130,
		112,
		150,
		150,
	},
	[3] = {
		-- 90,
		-- 110,
		-- 110,
		112,
		150,
		150,
	},
}

local BigExplosionSounds = {
	["explosions/gbomb_2.mp3"] = true,
	["impactsounds/Tank_shell_impact_ricochet_w_whizz_01.ogg"] = true,
	["impactsounds/Tank_shell_impact_ricochet_w_whizz_02.ogg"] = true,
	["impactsounds/Tank_shell_impact_ricochet_w_whizz_03.ogg"] = true,
	["impactsounds/Tank_shell_impact_ricochet_w_whizz_01_mid.ogg"] = true,
	["impactsounds/Tank_shell_impact_ricochet_w_whizz_02_mid.ogg"] = true,
	["impactsounds/Tank_shell_impact_ricochet_w_whizz_03_mid.ogg"] = true,
}

local BigExplosionSoundLevels = {
	[1] = {
		150,
		150,
		150,
	},
	[2] = {
		150,
		150,
		150,
	},
	[3] = {
		150,
		150,
		150,
	},
}

net.Receive("gred_net_sound_new",function()
	local pos = net.ReadVector()
	local tab = net.ReadTable()
	
	if not tab[1] then return end
	
	local e1 = tab[1]
	local e2 = tab[2] or e1
	local e3 = tab[3] or e2
	
	-- PrintTable(tab)
	
	local div = math.Clamp(math.ceil(gred.CVars["gred_sv_soundspeed_divider"]:GetInt()),1,#Level)
	local vol = gred.CVars["gred_cl_explosionvolume"]:GetFloat()
	local currange = 1000 / div
	
	local curRange_min = currange*5
	curRange_min = curRange_min*curRange_min
	local curRange_mid = currange*14
	curRange_mid = curRange_mid * curRange_mid
	local curRange_max = currange*40
	curRange_max = curRange_max * curRange_max
	
	local ply = LocalPlayer():GetViewEntity()
	local plypos = ply:GetPos()
	local distance = ply:GetPos():DistToSqr(pos)
	
	local ShakeScreen = gred.CVars["gred_cl_sound_shake"]:GetBool()
	
	hook.Run("GredExplosion",e1,pos,distance,e2,e3)
	
	if distance <= curRange_min then
		
		if not LocalPlayer():InVehicle() and ShakeScreen then
			util.ScreenShake(pos,10,75,2,math.sqrt(curRange_min))
		end
		
		if BigExplosionSounds[e1] then
			sound.Play(e1,pos,BigExplosionSoundLevels[div][1],100,1 * vol)
		else
			sound.Play(e1,pos,Level[div][1],100,1 * vol)
		end
		
	elseif distance <= curRange_mid then
		timer.Simple(distance/soundSpeed,function()
			if not LocalPlayer():InVehicle() and ShakeScreen then
				util.ScreenShake(pos,3,75,1.5,math.sqrt(curRange_mid))
			end
			
			if BigExplosionSounds[e3] then
				sound.Play(e2,pos,BigExplosionSoundLevels[div][2],100,1 * vol)
			else
				sound.Play(e2,pos,Level[div][2],100,0.5 * vol)
			end
		end)
	else -- if distance <= curRange_max then
		timer.Simple(distance/soundSpeed,function()
			if BigExplosionSounds[e2] then
				sound.Play(e1,pos,BigExplosionSoundLevels[div][3],100,1 * vol)
			else
				sound.Play(e3,pos,Level[div][3],100,1 * vol)
			end
		end)
	end
	
end)

timer.Simple(5,function()
	local singleplayerIPs = {
		["loopback"] = true,
		["0.0.0.0"] = true,
		["0.0.0.0:port"] = true,
	}
	if singleplayerIPs[game.GetIPAddress()] then
		-- CheckForUpdates()
		-- CheckForConflicts()
	end
	
	CheckDXDiag()
end)

include("gredwitch/gred_cl_lfs_functions.lua")
include("gredwitch/gred_cl_simfphys_functions.lua")
include("gredwitch/gred_cl_menu.lua")
include("gredwitch/gred_sh_simfphys_functions.lua")