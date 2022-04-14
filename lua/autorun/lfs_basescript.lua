--DO NOT EDIT OR REUPLOAD THIS FILE

local cVar_playerignore = GetConVar( "ai_ignoreplayers" )
local meta = FindMetaTable( "Player" )

simfphys = istable( simfphys ) and simfphys or {} -- lets check if the simfphys table exists. if not, create it!
simfphys.LFS = {} -- lets add another table for this project. We will be storing all our global functions and variables here. LFS means LunasFlightSchool

simfphys.LFS.VERSION = 303
simfphys.LFS.VERSION_TYPE = ".WS"

simfphys.LFS.KEYS_IN = {}
simfphys.LFS.KEYS_DEFAULT = {}
simfphys.LFS.CollisionFilter = {}
simfphys.LFS.PlanesStored = {}
simfphys.LFS.NextPlanesGetAll = 0
simfphys.LFS.NPCsStored = {}
simfphys.LFS.NextNPCsGetAll = 0

simfphys.LFS.cVar_IgnoreNPCs = CreateConVar( "lfs_ai_ignorenpcs", "0", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"should LFS-AI ignore NPC's?" )

simfphys.LFS.FreezeTeams = CreateConVar( "lfs_freeze_teams", "0", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"enable/disable auto ai-team switching" )
simfphys.LFS.TeamPassenger = CreateConVar( "lfs_teampassenger", "0", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"only allow players of matching ai-team to enter the vehicle? 1 = team only, 0 = everyone can enter" )
simfphys.LFS.PlayerDefaultTeam = CreateConVar( "lfs_default_teams", "0", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"set default player ai-team" )

simfphys.LFS.IgnoreNPCs = simfphys.LFS.cVar_IgnoreNPCs and simfphys.LFS.cVar_IgnoreNPCs:GetBool() or false
simfphys.LFS.IgnorePlayers = cVar_playerignore and cVar_playerignore:GetBool() or false

simfphys.LFS.pSwitchKeys = {[KEY_1] = 1,[KEY_2] = 2,[KEY_3] = 3,[KEY_4] = 4,[KEY_5] = 5,[KEY_6] = 6,[KEY_7] = 7,[KEY_8] = 8,[KEY_9] = 9,[KEY_0] = 10}
simfphys.LFS.pSwitchKeysInv = {[1] = KEY_1,[2] = KEY_2,[3] = KEY_3,[4] = KEY_4,[5] = KEY_5,[6] = KEY_6,[7] = KEY_7,[8] = KEY_8,[9] = KEY_9,[10] = KEY_0}

function simfphys.LFS:AddKey(name, class, name_menu, default, cmd, IN_KEY)
	table.insert( simfphys.LFS.KEYS_DEFAULT, {name = name, class = class, name_menu = name_menu, default = default, cmd = cmd, IN_KEY = IN_KEY} )
	simfphys.LFS.KEYS_IN[name] = IN_KEY
	
	if CLIENT then
		CreateClientConVar( cmd, default, true, true )
	end
end

local DEFAULT_KEYS = {
	{name = "EXIT",			class = "misc",		name_menu = "Exit Vehicle",		default = KEY_J,		cmd = "cl_lfs_exit",					IN_KEY = 0},
	{name = "FREELOOK",		class = "misc",		name_menu = "Freelook (Hold)",	default = MOUSE_MIDDLE,	cmd = "cl_lfs_freelook",				IN_KEY = IN_WALK},
	{name = "ENGINE",			class = "misc",		name_menu = "Toggle Engine",		default = KEY_R,		cmd = "cl_lfs_toggle_engine",			IN_KEY = IN_RELOAD},
	{name = "VSPEC",			class = "misc",		name_menu = "Toggle Vehicle-specific Function",	default = KEY_SPACE,	cmd = "cl_lfs_toggle_vspecific",	IN_KEY = IN_JUMP},
	--{name = "PRI_ATTACK",		class = "misc",		name_menu = "Primary Attack",		default = MOUSE_LEFT,	cmd = "cl_lfs_primaryattack",	IN_KEY = IN_ATTACK},
	--{name = "SEC_ATTACK",		class = "misc",		name_menu = "Secondary Attack",	default = MOUSE_RIGHT,	cmd = "cl_lfs_secondaryattack",	IN_KEY = IN_ATTACK2},
	
	{name = "+THROTTLE",		class = "plane",		name_menu = "Throttle Increase",	default = KEY_W,		cmd = "cl_lfs_throttle_inc",	IN_KEY = IN_FORWARD},
	{name = "-THROTTLE",		class = "plane",		name_menu = "Throttle Decrease",	default = KEY_S,		cmd = "cl_lfs_throttle_dec",	IN_KEY = IN_BACK},
	{name = "+PITCH",			class = "plane",		name_menu = "Pitch Up",			default = KEY_LSHIFT,	cmd = "cl_lfs_pitch_up",		IN_KEY = IN_SPEED},
	{name = "-PITCH",			class = "plane",		name_menu = "Pitch Down",		default = KEY_LALT,	cmd = "cl_lfs_pitch_Down",	IN_KEY = 0},
	{name = "-YAW",			class = "plane",		name_menu = "Yaw Left",			default = KEY_Q,		cmd = "cl_lfs_yaw_left",		IN_KEY = 0},
	{name = "+YAW",			class = "plane",		name_menu = "Yaw Right",		default = KEY_E,		cmd = "cl_lfs_yaw_right",		IN_KEY = 0},
	{name = "-ROLL",			class = "plane",		name_menu = "Roll Left",			default = KEY_A,		cmd = "cl_lfs_roll_left",		IN_KEY = IN_MOVELEFT},
	{name = "+ROLL",			class = "plane",		name_menu = "Roll Right",			default = KEY_D,		cmd = "cl_lfs_roll_right",		IN_KEY = IN_MOVERIGHT},
	
	{name = "+THROTTLE_HELI",	class = "heli",		name_menu = "Throttle Increase",			default = KEY_W,		cmd = "cl_lfsheli_throttle_inc",	IN_KEY = IN_FORWARD},
	{name = "-THROTTLE_HELI",	class = "heli",		name_menu = "Throttle Decrease",			default = KEY_S,		cmd = "cl_lfsheli_throttle_dec",	IN_KEY = IN_BACK},
	{name = "+PITCH_HELI",		class = "heli",		name_menu = "Pitch Up (Hovermode Only)",	default = KEY_LALT,		cmd = "cl_lfsheli_pitch_up",	IN_KEY = 0},
	{name = "-PITCH_HELI",		class = "heli",		name_menu = "Pitch Down (Hovermode Only)",	default = KEY_LSHIFT ,	cmd = "cl_lfsheli_pitch_Down",	IN_KEY = 0},
	{name = "-YAW_HELI",		class = "heli",		name_menu = "Yaw Left (Hovermode Only)",	default = KEY_Q,		cmd = "cl_lfsheli_yaw_left",	IN_KEY = 0},
	{name = "+YAW_HELI",		class = "heli",		name_menu = "Yaw Righ (Hovermode Only)",	default = KEY_E,		cmd = "cl_lfsheli_yaw_right",	IN_KEY = 0},
	{name = "-ROLL_HELI",		class = "heli",		name_menu = "Roll Left",					default = KEY_A,		cmd = "cl_lfsheli_roll_left",		IN_KEY = IN_MOVELEFT},
	{name = "+ROLL_HELI",		class = "heli",		name_menu = "Roll Right",					default = KEY_D,		cmd = "cl_lfsheli_roll_right",	IN_KEY = IN_MOVERIGHT},
	{name = "HOVERMODE",		class = "heli",		name_menu = "Hovermode (Hold)",			default = KEY_SPACE,	cmd = "cl_lfsheli_hover",		IN_KEY = IN_SPEED},
}
for _, v in pairs( DEFAULT_KEYS ) do 
	simfphys.LFS:AddKey( v.name, v.class,  v.name_menu, v.default, v.cmd, v.IN_KEY )
end

function simfphys.LFS.CheckUpdates()
	http.Fetch("https://raw.githubusercontent.com/Blu-x92/LunasFlightSchool/master/lfs_base/lua/autorun/lfs_basescript.lua", function(contents,size) 
		local LatestVersion = tonumber( string.match( string.match( contents, "simfphys.LFS.VERSION%s=%s%d+" ) , "%d+" ) ) or 0

		if LatestVersion == 0 then
			print("[LFS] latest version could not be detected, You have Version: "..simfphys.LFS.GetVersion())
		else
			if simfphys.LFS.GetVersion() >= LatestVersion then
				print("[LFS] is up to date, Version: "..simfphys.LFS.GetVersion())
			else
				print("[LFS] a newer version is available! Version: "..LatestVersion..", You have Version: "..simfphys.LFS.GetVersion())
				print("[LFS] get the latest version at https://github.com/Blu-x92/LunasFlightSchool")
				
				if CLIENT then 
					timer.Simple(18, function() 
						chat.AddText( Color( 255, 0, 0 ), "[LFS] a newer version is available!" )
					end)
				end
			end
		end
	end)

	if SERVER then return end

	if not LFS_1878568737 then
		if file.Exists( "lfs_dontnotifyme.txt", "DATA" ) then return end

		local bgMat = Material( "lfs_controlpanel_bg.png" )

		local InfoFrame = vgui.Create( "DFrame" )
		InfoFrame:SetSize( 345, 120 )
		InfoFrame:SetTitle( "" )
		InfoFrame:SetDraggable( true )
		InfoFrame:MakePopup()
		InfoFrame:Center()
		InfoFrame.Paint = function(self, w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color( 0, 0, 0, 255 ) )
			draw.RoundedBox( 8, 1, 46, w-2, h-47, Color( 120, 120, 120, 255 ) )

			draw.RoundedBox( 4, 1, 26, w-2, 36, Color( 120, 120, 120, 255 ) )

			draw.RoundedBox( 8, 0, 0, w, 25, Color( 127, 0, 0, 255 ) )
			draw.SimpleText( "[LFS] - Notification", "LFS_FONT", 5, 11, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			surface.SetDrawColor( 255, 255, 255, 50 )
			surface.SetMaterial( bgMat )
			surface.DrawTexturedRect( 0, -50, w, w )

			draw.DrawText( "Due to ongoing complaints about filesize,", "LFS_FONT_PANEL", 10, 30, Color( 255, 170, 170, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.DrawText( "STAR WARS vehicles are NO LONGER PART OF THE BASE ADDON!", "LFS_FONT_PANEL", 10, 45, Color( 255, 170, 170, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.DrawText( "If you still want to use them", "LFS_FONT_PANEL", 10, 67, Color( 255, 170, 170, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end

		local DermaButton = vgui.Create( "DButton", InfoFrame )
		DermaButton:SetText( "" )
		DermaButton:SetPos( 150, 63 )
		DermaButton:SetSize( 150, 20 )
		DermaButton.DoClick = function() steamworks.ViewFile( "1878568737" ) end
		DermaButton.Paint = function(self, w, h ) 
			draw.DrawText( "CLICK HERE", "LFS_FONT", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end

		local CheckBox = vgui.Create( "DCheckBoxLabel", InfoFrame )
		CheckBox:SetText( "OK, don't show me this message ever again." )
		CheckBox:SizeToContents()
		CheckBox:SetPos( 10, 95 )
		CheckBox.OnChange = function(self, bVal)
			if bVal then
				surface.PlaySound( "buttons/button14.wav" )
				InfoFrame:Close()
				file.Write( "lfs_dontnotifyme.txt", "[LFS] - Star Wars Pack Notification suppressing file." )
			end
		end
	end
end

function simfphys.LFS.GetVersion()
	return simfphys.LFS.VERSION
end

hook.Add( "OnEntityCreated", "!!!!lfsEntitySorter", function( ent )
	timer.Simple( FrameTime(), function() 
		if not IsValid( ent ) then return end

		if isfunction( ent.IsNPC ) and ent:IsNPC() then
			table.insert( simfphys.LFS.NPCsStored, ent )
		end

		if ent.LFS then 
			if CLIENT and ent.PrintName then
				language.Add( ent:GetClass(), ent.PrintName)
			end

			table.insert( simfphys.LFS.PlanesStored, ent )

			if SERVER then
				simfphys.LFS:FixVelocity()
			end
		end
	end )
end )

function simfphys.LFS:NPCsGetAll()
	local Time = CurTime()
	
	if simfphys.LFS.NextNPCsGetAll < Time then
		simfphys.LFS.NextNPCsGetAll = Time + FrameTime()

		for index, npc in pairs( simfphys.LFS.NPCsStored ) do
			if not IsValid( npc ) then
				simfphys.LFS.NPCsStored[ index ] = nil
			end
		end
	end

	return simfphys.LFS.NPCsStored
end

function simfphys.LFS:PlanesGetAll()
	local Time = CurTime()
	
	if simfphys.LFS.NextPlanesGetAll < Time then
		simfphys.LFS.NextPlanesGetAll = Time + FrameTime()

		for index, plane in pairs( simfphys.LFS.PlanesStored ) do
			if not IsValid( plane ) then
				simfphys.LFS.PlanesStored[ index ] = nil
			end
		end
	end

	return simfphys.LFS.PlanesStored
end

function simfphys.LFS:GetNPCRelationship( npc_class )
	local Teams = {
		["npc_breen"] = 1,
		["npc_combine_s"] = 1,
		["npc_combinedropship"] = 1,
		["npc_combinegunship"] = 1,
		["npc_crabsynth"] = 1,
		["npc_cscanner"] = 1,
		["npc_helicopter"] = 1,
		["npc_manhack"] = 1,
		["npc_metropolice"] = 1,
		["npc_mortarsynth"] = 1,
		["npc_sniper"] = 1,
		["npc_stalker"] = 1,
		["npc_strider"] = 1,
		["monster_human_grunt"] = 1,
		["monster_human_assassin"] = 1,
		["monster_sentry"] = 1,

		["npc_kleiner"] = 2,
		["npc_monk"] = 2,
		["npc_mossman"] = 2,
		["npc_vortigaunt"] = 2,
		["npc_alyx"] = 2,
		["npc_barney"] = 2,
		["npc_citizen"] = 2,
		["npc_dog"] = 2,
		["npc_eli"] = 2,
		["monster_scientist"] = 2,
		["monster_barney"] = 2,

		["npc_fastzombie"] = 3,
		["npc_headcrab"] = 3,
		["npc_headcrab_black"] = 3,
		["npc_headcrab_fast"] = 3,
		["npc_antlion"] = 3,
		["npc_antlionguard"] = 3,
		["npc_zombie"] = 3,
		["npc_zombie_torso"] = 3,
		["npc_poisonzombie"] = 3,
		["monster_alien_grunt"] = 3,
		["monster_alien_slave"] = 3,
		["monster_gargantua"] = 3,
		["monster_bullchicken"] = 3,
		["monster_headcrab"] = 3,
		["monster_babycrab"] = 3,
		["monster_zombie"] = 3,
		["monster_houndeye"] = 3,
		["monster_nihilanth"] = 3,
		["monster_bigmomma"] = 3,
		["monster_babycrab"] = 3,
	}
	return Teams[ npc_class ] or "0"
end

function meta:lfsGetPlane()
	if not self:InVehicle() then return NULL end
	
	local Pod = self:GetVehicle()
	
	if not IsValid( Pod ) then return NULL end
	
	if Pod.LFSchecked then
		
		return Pod.LFSBaseEnt
		
	else
		local Parent = Pod:GetParent()
		
		if not IsValid( Parent ) then return NULL end
		
		if not Parent.LFS then return NULL end
		
		Pod.LFSchecked = true
		Pod.LFSBaseEnt = Parent
		
		return Parent
	end
end

function meta:lfsGetAITeam()
	return self:GetNWInt( "lfsAITeam", simfphys.LFS.PlayerDefaultTeam:GetInt() )
end

function meta:lfsBuildControls()
	if istable( self.LFS_BINDS ) then
		table.Empty( self.LFS_BINDS )
	end
	
	if SERVER then
		self.LFS_BINDS = {
			["misc"] = {},
			["plane"] = {},
			["heli"] = {},
		}
		
		self.LFS_HIPSTER = self:GetInfoNum( "lfs_hipster", 0 ) == 1
		
		for _,v in pairs( simfphys.LFS.KEYS_DEFAULT ) do
			self.LFS_BINDS[v.class][ self:GetInfoNum( v.cmd, 0 ) ] = v.name
		end
	else
		self.LFS_BINDS = {}
		
		self.LFS_HIPSTER = GetConVar( "lfs_hipster" ):GetBool()
		
		for _,v in pairs( simfphys.LFS.KEYS_DEFAULT ) do
			self.LFS_BINDS[ v.name ] = GetConVar( v.cmd ):GetInt()
		end
	end
end

function meta:lfsGetControls()
	if not istable( self.LFS_BINDS ) then
		self:lfsBuildControls()
	end
	
	return self.LFS_BINDS
end

local IS_MOUSE_ENUM = {
	[MOUSE_LEFT] = true,
	[MOUSE_RIGHT] = true,
	[MOUSE_MIDDLE] = true,
	[MOUSE_4] = true,
	[MOUSE_5] = true,
	[MOUSE_WHEEL_UP] = true,
	[MOUSE_WHEEL_DOWN] = true,
}

function meta:lfsGetInput( name )
	if self.LFS_HIPSTER then
		if SERVER then
			self.LFS_KEYDOWN = self.LFS_KEYDOWN and self.LFS_KEYDOWN or {}
			
			return self.LFS_KEYDOWN[ name ]
		else
			local Key = self:lfsGetControls()[ name ]
			
			if IS_MOUSE_ENUM[ Key ] then
				return input.IsMouseDown( Key ) 
			else
				return input.IsKeyDown( Key ) 
			end
		end
	else
		if self.LFS_HIPSTER == nil then -- something went wrong.
			self:lfsBuildControls()
			
			return false
		else
			if simfphys.LFS.KEYS_IN[ name ] then
				return self:KeyDown( simfphys.LFS.KEYS_IN[ name ] )
			else
				return false
			end
		end
	end
end

if SERVER then 
	resource.AddWorkshop("1571918906")

	util.AddNetworkString( "lfs_failstartnotify" )
	util.AddNetworkString( "lfs_admin_setconvar" )
	util.AddNetworkString( "lfs_player_request_filter" )
	util.AddNetworkString( "lfs_hitmarker" )
	util.AddNetworkString( "lfs_killmarker" )

	net.Receive( "lfs_player_request_filter", function( length, ply )
		if not IsValid( ply ) then return end
		
		local LFSent = net.ReadEntity()
		
		if not IsValid( LFSent ) then return end
		
		if not istable( LFSent.CrosshairFilterEnts ) then
			LFSent.CrosshairFilterEnts = {}
			
			for _, Entity in pairs( constraint.GetAllConstrainedEntities( LFSent ) ) do
				if IsValid( Entity ) then
					if not Entity:GetNoDraw() then -- dont add nodraw entites. They are NULL for client anyway
						table.insert( LFSent.CrosshairFilterEnts, Entity )
					end
				end
			end
			
			for _, Parent in pairs( LFSent.CrosshairFilterEnts ) do
				local Childs = Parent:GetChildren()
				for _, Child in pairs( Childs ) do
					if IsValid( Child ) then
						table.insert( LFSent.CrosshairFilterEnts, Child )
					end
				end
			end
		end
		
		net.Start( "lfs_player_request_filter" )
			net.WriteEntity( LFSent )
			net.WriteTable( LFSent.CrosshairFilterEnts )
		net.Send( ply )
	end)

	net.Receive( "lfs_admin_setconvar", function( length, ply )
		if not IsValid( ply ) or not ply:IsSuperAdmin() then return end
		
		local ConVar = net.ReadString()
		local Value = tonumber( net.ReadString() )
		
		RunConsoleCommand( ConVar, Value ) 
	end)

	function meta:lfsSetAITeam( nTeam )
		nTeam = nTeam or simfphys.LFS.PlayerDefaultTeam:GetInt()

		local TeamText = {
			[0] = "FRIENDLY TO EVERYONE",
			[1] = "Team 1",
			[2] = "Team 2",
			[3] = "HOSTILE TO EVERYONE",
		}

		if self:lfsGetAITeam() ~= nTeam then
			self:PrintMessage( HUD_PRINTTALK, "[LFS] Your AI-Team has been updated to: "..TeamText[ nTeam ] )
		end

		self:SetNWInt( "lfsAITeam", nTeam )
	end

	function meta:lfsSetInput( name, value )
		self.LFS_KEYDOWN = self.LFS_KEYDOWN and self.LFS_KEYDOWN or {}
		self.LFS_KEYDOWN[ name ] = value
	end

	function simfphys.LFS:AddColDMGFilterClass( name_class )
		if not isstring( name_class ) then return end

		simfphys.LFS.CollisionFilter[ name_class:lower() ] = true
	end

	function simfphys.LFS:FixVelocity()
		local tbl = physenv.GetPerformanceSettings()

		if tbl.MaxVelocity < 4000 then
			local OldVel = tbl.MaxVelocity

			tbl.MaxVelocity = 4000
			physenv.SetPerformanceSettings(tbl)

			print("[LFS] Low MaxVelocity detected! Increasing! "..OldVel.." => 4000")
		end

		if tbl.MaxAngularVelocity < 7272 then
			local OldAngVel = tbl.MaxAngularVelocity

			tbl.MaxAngularVelocity = 7272
			physenv.SetPerformanceSettings(tbl)

			print("[LFS] Low MaxAngularVelocity detected! Increasing! "..OldAngVel.." => 7272")
		end
	end

	hook.Add("CanExitVehicle","!!!lfsCanExitVehicle",function(vehicle,ply)
		if IsValid( ply:lfsGetPlane() ) then return not ply.LFS_HIPSTER end
	end)

	hook.Add( "PlayerButtonUp", "!!!lfsButtonUp", function( ply, button )
		for _, LFS_BIND in pairs( ply:lfsGetControls() ) do
			if LFS_BIND[ button ] then
				ply:lfsSetInput( LFS_BIND[ button ], false )
			end
		end
	end )
	
	hook.Add( "PlayerButtonDown", "!!!lfsButtonDown", function( ply, button )
		local vehicle = ply:lfsGetPlane()
		
		for _, LFS_BIND in pairs( ply:lfsGetControls() ) do
			if LFS_BIND[ button ] then
				ply:lfsSetInput( LFS_BIND[ button ], true )
				
				if IsValid( vehicle ) then
					if ply.LFS_HIPSTER then
						if LFS_BIND[ button ] == "EXIT" then
							ply:ExitVehicle()
						end
					end
				end
			end
		end
		
		if not IsValid( vehicle ) then return end
		
		if button == KEY_1 then
			if ply == vehicle:GetDriver() then
				if vehicle:GetlfsLockedStatus() then
					vehicle:UnLock()
				else
					vehicle:Lock()
				end
			else
				if not IsValid( vehicle:GetDriver() ) and not vehicle:GetAI() then
					ply:ExitVehicle()
					
					local DriverSeat = vehicle:GetDriverSeat()
					
					if IsValid( DriverSeat ) then
						timer.Simple( FrameTime(), function()
							if not IsValid( vehicle ) or not IsValid( ply ) then return end
							if IsValid( vehicle:GetDriver() ) or not IsValid( DriverSeat ) or vehicle:GetAI() then return end
							
							ply:EnterVehicle( DriverSeat )
							
							timer.Simple( FrameTime() * 2, function()
								if not IsValid( ply ) or not IsValid( vehicle ) then return end
								ply:SetEyeAngles( Angle(0,vehicle:GetAngles().y,0) )
							end)
						end)
					end
				end
			end
		else
			for _, Pod in pairs( vehicle:GetPassengerSeats() ) do
				if IsValid( Pod ) then
					if Pod:GetNWInt( "pPodIndex", 3 ) == simfphys.LFS.pSwitchKeys[ button ] then
						if not IsValid( Pod:GetDriver() ) then
							ply:ExitVehicle()
						
							timer.Simple( FrameTime(), function()
								if not IsValid( Pod ) or not IsValid( ply ) then return end
								if IsValid( Pod:GetDriver() ) then return end
								
								ply:EnterVehicle( Pod )
							end)
						end
					end
				end
			end
		end
	end )
	
	hook.Add( "PlayerLeaveVehicle", "!!LFS_Exit", function( ply, vehicle )
		if not ply:IsPlayer() then return end
		
		local Pod = ply:GetVehicle()
		local Parent = ply:lfsGetPlane()
		
		if not IsValid( Pod ) or not IsValid( Parent ) then return end
		
		if not simfphys.LFS.FreezeTeams:GetBool() then
			ply:lfsSetAITeam( Parent:GetAITEAM() )
		end
		
		local ent = Pod
		local b_ent = Parent
		
		local Center = b_ent:LocalToWorld( b_ent:OBBCenter() )
		local vel = b_ent:GetVelocity()
		local radius = b_ent:BoundingRadius()
		local HullSize = Vector(18,18,0)
		local Filter1 = {ent,ply}
		local Filter2 = {ent,ply,b_ent}

		for _, filterEntity in pairs( constraint.GetAllConstrainedEntities( b_ent ) ) do
			if IsValid( filterEntity ) then
				table.insert( Filter2, filterEntity )
			end
		end

		if vel:Length() > 250 then
			local pos = b_ent:GetPos()
			local dir = vel:GetNormalized()
			local targetpos = pos - dir *  (radius + 40)
			
			local tr = util.TraceHull( {
				start = Center,
				endpos = targetpos - Vector(0,0,10),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter2
			} )
			
			local exitpoint = tr.HitPos + Vector(0,0,10)
			
			if util.IsInWorld( exitpoint ) then
				ply:SetPos(exitpoint)
				ply:SetEyeAngles((pos - exitpoint):Angle())
			end
		else
			local pos = ent:GetPos()
			local targetpos = (pos + ent:GetRight() * 80)
			
			local tr1 = util.TraceLine( {
				start = targetpos,
				endpos = targetpos - Vector(0,0,100),
				filter = {}
			} )
			local tr2 = util.TraceHull( {
				start = targetpos,
				endpos = targetpos + Vector(0,0,80),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter1
			} )
			local traceto = util.TraceLine( {start = Center,endpos = targetpos,filter = Filter2} )
			
			local HitGround = tr1.Hit
			local HitWall = tr2.Hit or traceto.Hit
			
			local check0 = (HitWall == true or HitGround == false or util.IsInWorld( targetpos ) == false) and (pos - ent:GetRight() * 80) or targetpos
			local tr = util.TraceHull( {
				start = check0,
				endpos = check0 + Vector(0,0,80),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter1
			} )
			local traceto = util.TraceLine( {start = Center,endpos = check0,filter = Filter2} )
			local HitWall = tr.Hit or traceto.hit
			
			local check1 = (HitWall == true or HitGround == false or util.IsInWorld( check0 ) == false) and (pos + ent:GetUp() * 100) or check0
			
			local tr = util.TraceHull( {
				start = check1,
				endpos = check1 + Vector(0,0,80),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter1
			} )
			local traceto = util.TraceLine( {start = Center,endpos = check1,filter = Filter2} )
			local HitWall = tr.Hit or traceto.hit
			local check2 = (HitWall == true or util.IsInWorld( check1 ) == false) and (pos - ent:GetUp() * 100) or check1
			
			local tr = util.TraceHull( {
				start = check2,
				endpos = check2 + Vector(0,0,80),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter1
			} )
			local traceto = util.TraceLine( {start = Center,endpos = check2,filter = Filter2} )
			local HitWall = tr.Hit or traceto.hit
			local check3 = (HitWall == true or util.IsInWorld( check2 ) == false) and b_ent:LocalToWorld( Vector(0,radius,0) ) or check2
			
			local tr = util.TraceHull( {
				start = check3,
				endpos = check3 + Vector(0,0,80),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter1
			} )
			local traceto = util.TraceLine( {start = Center,endpos = check3,filter = Filter2} )
			local HitWall = tr.Hit or traceto.hit
			local check4 = (HitWall == true or util.IsInWorld( check3 ) == false) and b_ent:LocalToWorld( Vector(0,-radius,0) ) or check3
			
			local tr = util.TraceHull( {
				start = check4,
				endpos = check4 + Vector(0,0,80),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter1
			} )
			local traceto = util.TraceLine( {start = Center,endpos = check4,filter = Filter2} )
			local HitWall = tr.Hit or traceto.hit
			local exitpoint = (HitWall == true or util.IsInWorld( check4 ) == false) and b_ent:LocalToWorld( Vector(0,0,0) ) or check4
			
			if isvector( ent.ExitPos ) then
				exitpoint = b_ent:LocalToWorld( ent.ExitPos )
			end
			
			if util.IsInWorld( exitpoint ) then
				ply:SetPos(exitpoint)
				ply:SetEyeAngles((pos - exitpoint):Angle())
			end
		end
	end )
end

if CLIENT then
	local cvarVolume = CreateClientConVar( "lfs_volume", 0.65, true, false)
	local cvarCamFocus = CreateClientConVar( "lfs_camerafocus", 0, true, false)
	local cvarShowPlaneIdent = CreateClientConVar( "lfs_show_identifier", 1, true, false)
	local cvarShowRollIndic = CreateClientConVar( "lfs_show_rollindicator", 0, true, false)
	local cvarUnlockControls = CreateClientConVar( "lfs_hipster", 0, true, true)
	local cvarDisableQMENU = CreateClientConVar( "lfs_qmenudisable", 1, true, false)
	local cvarHitMarker = CreateConVar( "lfs_hitmarker", 1, true, false)

	local ShowPlaneIdent = cvarShowPlaneIdent and cvarShowPlaneIdent:GetBool() or true
	local ShowShowRollIndic = cvarShowRollIndic and cvarShowRollIndic:GetBool() or false
	local ShowHitMarker = cvarHitMarker and cvarHitMarker:GetBool() or false

	simfphys.LFS.AltitudeMinZ = 0

	local LastHitMarker = 0
	local LastKillMarker = 0

	net.Receive( "lfs_hitmarker", function( len )
		if not ShowHitMarker  then return end

		if LastHitMarker - math.random(0.09,0.14) > CurTime() then return end

		LastHitMarker = CurTime() + 0.15

		local ply = LocalPlayer()

		local vehicle = ply:lfsGetPlane()
		if IsValid( ply:lfsGetPlane() ) then 
			vehicle:HitMarker( LastHitMarker )
		end
	end )

	net.Receive( "lfs_killmarker", function( len )
		if not ShowHitMarker  then return end

		if LastKillMarker - 0.14 > CurTime() then return end

		LastKillMarker = CurTime() + 0.5

		local ply = LocalPlayer()

		local vehicle = ply:lfsGetPlane()
		if IsValid( ply:lfsGetPlane() ) then 
			vehicle:KillMarker( LastKillMarker )
		end
	end )

	local function PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness,bClockwise)
		local triarc = {}
		local deg2rad = math.pi / 180

		local startang,endang = startang or 0, endang or 0
		if bClockwise and (startang < endang) then
			local temp = startang
			startang = endang
			endang = temp
			temp = nil
		elseif (startang > endang) then 
			local temp = startang
			startang = endang
			endang = temp
			temp = nil
		end

		local roughness = math.max(roughness or 1, 1)
		local step = roughness
		if bClockwise then
			step = math.abs(roughness) * -1
		end

		local inner = {}
		local r = radius - thickness
		for deg=startang, endang, step do
			local rad = deg2rad * deg
			table.insert(inner, {
				x=cx+(math.cos(rad)*r),
				y=cy+(math.sin(rad)*r)
			})
		end

		local outer = {}
		for deg=startang, endang, step do
			local rad = deg2rad * deg
			table.insert(outer, {
				x=cx+(math.cos(rad)*radius),
				y=cy+(math.sin(rad)*radius)
			})
		end

		for tri=1,#inner*2 do
			local p1,p2,p3
			p1 = outer[math.floor(tri/2)+1]
			p3 = inner[math.floor((tri+1)/2)+1]
			if tri%2 == 0 then
				p2 = outer[math.floor((tri+1)/2)]
			else
				p2 = inner[math.floor((tri+1)/2)]
			end
		
			table.insert(triarc, {p1,p2,p3})
		end
		return triarc
	end

	function simfphys.LFS.DrawArc(cx,cy,radius,thickness,startang,endang,roughness,color,bClockwise)
		surface.SetDrawColor(color)
		draw.NoTexture()

		for k,v in ipairs( PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness,bClockwise) ) do
			surface.DrawPoly(v)
		end
	end

	function simfphys.LFS.DrawCircle( X, Y, radius )
		local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
		
		for a = 0, 360, segmentdist do
			surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
		end
	end

	function simfphys.LFS.DrawDiamond( X, Y, radius, perc )
		if perc <= 0 then return end

		local segmentdist = 90

		draw.NoTexture()

		for a = 90, 360, segmentdist do
			local Xa = math.Round( math.sin( math.rad( -a ) ) * radius, 0 )
			local Ya = math.Round( math.cos( math.rad( -a ) ) * radius, 0 )

			local C = math.sqrt( radius ^ 2 + radius ^ 2 )

			if a == 90 then
				C = C * math.min(math.max(perc - 0.75,0) / 0.25,1)
			elseif a == 180 then
				C = C * math.min(math.max(perc - 0.5,0) / 0.25,1)
			elseif a == 270 then
				C = C * math.min(math.max(perc - 0.25,0) / 0.25,1)
			elseif a == 360 then
				C = C * math.min(math.max(perc,0) / 0.25,1)
			end

			if C > 0 then
				local AxisMoveX = math.Round( math.sin( math.rad( -a + 135) ) * (C + 3) * 0.5, 0 )
				local AxisMoveY =math.Round( math.cos( math.rad( -a + 135) ) * (C + 3) * 0.5, 0 )

				surface.DrawTexturedRectRotated(X - Xa - AxisMoveX, Y - Ya - AxisMoveY,3, math.ceil( C ), a - 45)
			end
		end
	end

	hook.Add("SpawnMenuOpen", "!!!lfsDisableSpawnmenu", function()
		local ply = LocalPlayer() 
		
		if not ply.LFS_HIPSTER then return end
		if not IsValid( ply:lfsGetPlane() ) then return end
		
		return not cvarDisableQMENU:GetBool()
	end)

	local HintPlayerAboutHisFuckingIncompetence = true
	local smTran = 0
	hook.Add( "CalcView", "!!!!LFS_calcview", function(ply, pos, angles, fov)
		HintPlayerAboutHisFuckingIncompetence = false
	 
		if ply:GetViewEntity() ~= ply then return end
		
		local Pod = ply:GetVehicle()
		local Parent = ply:lfsGetPlane()
		
		if not IsValid( Pod ) or not IsValid( Parent ) then return end
		
		local cvarFocus = math.Clamp( cvarCamFocus:GetFloat() , -1, 1 )
		
		smTran = smTran + ((ply:lfsGetInput( "FREELOOK" ) and 0 or 1) - smTran) * FrameTime() * 10
		
		local view = {}
		view.origin = pos
		view.fov = fov
		view.drawviewer = true
		view.angles = (Parent:GetForward() * (1 + cvarFocus) * smTran * 0.8 + ply:EyeAngles():Forward() * math.max(1 - cvarFocus, 1 - smTran)):Angle()

		if cvarFocus >= 1 then
			view.angles = LerpAngle( smTran, ply:EyeAngles(), Parent:GetAngles() )
		else
			view.angles.r = 0
		end
		
		if Parent:GetDriverSeat() ~= Pod then
			view.angles = ply:EyeAngles()
		end
		
		if not Pod:GetThirdPersonMode() then
			
			view.drawviewer = false
			
			return Parent:LFSCalcViewFirstPerson( view, ply )
		end
		
		local radius = 550
		radius = radius + radius * Pod:GetCameraDistance()
		
		local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
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

		return Parent:LFSCalcViewThirdPerson( view, ply )
	end )

	surface.CreateFont( "LFS_FONT", {
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

	surface.CreateFont( "LFS_FONT_SWITCHER", {
		font = "Verdana",
		extended = false,
		size = 16,
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
	
	surface.CreateFont( "LFS_FONT_PANEL", {
		font = "Arial",
		extended = false,
		size = 14,
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	function simfphys.LFS.HudPaintPlaneIdentifier( X, Y, In_Col, target_ent )
		if not IsValid( target_ent ) then return end

		surface.SetDrawColor( In_Col.r, In_Col.g, In_Col.b, In_Col.a )
		simfphys.LFS.DrawDiamond( X + 1, Y + 1, 20, target_ent:GetHP() / target_ent:GetMaxHP() )

		if target_ent:GetMaxShield() > 0 then
			surface.SetDrawColor( 200, 200, 255, 255 )
			simfphys.LFS.DrawDiamond( X + 1, Y + 1, 24, target_ent:GetShield() / target_ent:GetMaxShield() )
		end

		--[[ old style
		local Size = 60
		
		surface.DrawLine( X - Size, Y + Size, X + Size, Y + Size )
		surface.DrawLine( X - Size, Y - Size, X - Size, Y + Size )
		surface.DrawLine( X + Size, Y - Size, X + Size, Y + Size )
		surface.DrawLine( X - Size, Y - Size, X + Size, Y - Size )
		]]
	end

	local function PaintPlaneHud( ent, X, Y, ply )
		if not IsValid( ent ) then return end
		
		local vel = ent:GetVelocity():Length()
		
		local Throttle = ent:GetThrottlePercent()

		local speed = math.Round(vel * 0.09144,0)

		local ZPos = math.Round( ent:GetPos().z,0)
		if (ZPos + simfphys.LFS.AltitudeMinZ)< 0 then simfphys.LFS.AltitudeMinZ = math.abs(ZPos) end
		local alt = math.Round( (ent:GetPos().z + simfphys.LFS.AltitudeMinZ) * 0.0254,0)

		local AmmoPrimary = ent:GetAmmoPrimary()
		local AmmoSecondary = ent:GetAmmoSecondary()

		local RepairProgress = ent:GetMaintenanceProgress()

		ent:LFSHudPaintInfoText( X, Y, speed, alt, AmmoPrimary, AmmoSecondary, Throttle )
		ent:LFSHudPaint( X, Y, {speed = speed, altitude = alt, PrimaryAmmo = AmmoPrimary, SecondaryAmmo = AmmoSecondary, Throttle = Throttle}, ply )
		ent:LFSRepairInfo( X, Y, ent:GetRepairMode(), RepairProgress, RepairProgress > 0 and RepairProgress < 1 )
	end

	local LockText = Material( "lfs_locked.png" )
	local smHider = 0
	local function PaintSeatSwitcher( ent, X, Y )
		local me = LocalPlayer()
		
		if not IsValid( ent ) then return end
		
		local pSeats = ent:GetPassengerSeats()
		local SeatCount = table.Count( pSeats ) 
		
		if SeatCount <= 0 then return end
		
		pSeats[0] = ent:GetDriverSeat()
		
		draw.NoTexture() 
		
		local MySeat = me:GetVehicle():GetNWInt( "pPodIndex", -1 )
		
		local Passengers = {}
		for _, ply in pairs( player.GetAll() ) do
			if ply:lfsGetPlane() == ent then
				local Pod = ply:GetVehicle()
				Passengers[ Pod:GetNWInt( "pPodIndex", -1 ) ] = ply:GetName()
			end
		end
		if ent:GetAI() then
			Passengers[1] = "[AI] "..ent.PrintName
		end
		
		me.SwitcherTime = me.SwitcherTime or 0
		me.oldPassengers = me.oldPassengers or {}
		
		local Time = CurTime()
		for k, v in pairs( Passengers ) do
			if me.oldPassengers[k] ~= v then
				me.oldPassengers[k] = v
				me.SwitcherTime = Time + 2
			end
		end
		for k, v in pairs( me.oldPassengers ) do
			if not Passengers[k] then
				me.oldPassengers[k] = nil
				me.SwitcherTime = Time + 2
			end
		end
		
		for _, v in pairs( simfphys.LFS.pSwitchKeysInv ) do
			if input.IsKeyDown(v) then
				me.SwitcherTime = Time + 2
			end
		end
		
		local Hide = me.SwitcherTime > Time
		smHider = smHider + ((Hide and 1 or 0) - smHider) * RealFrameTime() * 15
		local Alpha1 = 135 + 110 * smHider 
		local HiderOffset = 300 * smHider
		local Offset = -50
		local yPos = Y - (SeatCount + 1) * 30 - 10
		
		for _, Pod in pairs( pSeats ) do
			local I = Pod:GetNWInt( "pPodIndex", -1 )
			if I >= 0 then
				if I == MySeat then
					draw.RoundedBox(5, X + Offset - HiderOffset, yPos + I * 30, 35 + HiderOffset, 25, Color(127,0,0,100 + 50 * smHider) )
				else
					draw.RoundedBox(5, X + Offset - HiderOffset, yPos + I * 30, 35 + HiderOffset, 25, Color(0,0,0,100 + 50 * smHider) )
				end
				if I == SeatCount then
					if ent:GetlfsLockedStatus() then
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.SetMaterial( LockText  )
						surface.DrawTexturedRect( X + Offset - HiderOffset - 25, yPos + I * 30, 25, 25 )
					end
				end
				if Hide then
					if Passengers[I] then
						draw.DrawText( Passengers[I], "LFS_FONT_SWITCHER", X + 40 + Offset - HiderOffset, yPos + I * 30 + 2.5, Color( 255, 255, 255,  Alpha1 ), TEXT_ALIGN_LEFT )
					else
						draw.DrawText( "-", "LFS_FONT_SWITCHER", X + 40 + Offset - HiderOffset, yPos + I * 30 + 2.5, Color( 255, 255, 255,  Alpha1 ), TEXT_ALIGN_LEFT )
					end
					
					draw.DrawText( "["..I.."]", "LFS_FONT_SWITCHER", X + 17 + Offset - HiderOffset, yPos + I * 30 + 2.5, Color( 255, 255, 255, Alpha1 ), TEXT_ALIGN_CENTER )
				else
					if Passengers[I] then
						draw.DrawText( "[^"..I.."]", "LFS_FONT_SWITCHER", X + 17 + Offset - HiderOffset, yPos + I * 30 + 2.5, Color( 255, 255, 255, Alpha1 ), TEXT_ALIGN_CENTER )
					else
						draw.DrawText( "["..I.."]", "LFS_FONT_SWITCHER", X + 17 + Offset - HiderOffset, yPos + I * 30 + 2.5, Color( 255, 255, 255, Alpha1 ), TEXT_ALIGN_CENTER )
					end
				end
			end
		end
	end

	local NextFind = 0
	local AllPlanes = {}
	local function PaintPlaneIdentifier( ent )
		if not ShowPlaneIdent then return end

		if NextFind < CurTime() then
			NextFind = CurTime() + 3
			AllPlanes = simfphys.LFS:PlanesGetAll()
		end

		local MyPos = ent:GetPos()
		local MyTeam = ent:GetAITEAM()

		for _, v in pairs( AllPlanes ) do
			if IsValid( v ) then
				if v ~= ent then
					if isvector( v.SeatPos ) then
						local rPos = v:LocalToWorld( v.SeatPos )

						local Pos = rPos:ToScreen()
						local Dist = (MyPos - rPos):Length()

						if Dist < 10000 then
							if not util.TraceLine( {start = ent:GetRotorPos(),endpos = rPos,mask = MASK_NPCWORLDSTATIC,} ).Hit then

								local Alpha = 255 * (1 - (Dist / 10000) ^ 2)
								local Team = v:GetAITEAM()
								local IndicatorColor = Color( 255, 0, 0, Alpha )

								if Team == 0 then
									IndicatorColor = Color( 0, 255, 0, Alpha )
								else
									if Team == 1 or Team == 2 then
										if Team ~= MyTeam and MyTeam ~= 0 then
											IndicatorColor = Color( 255, 0, 0, Alpha )
										else
											IndicatorColor = Color( 0, 127, 255, Alpha )
										end
									end
								end

								ent:LFSHudPaintPlaneIdentifier( Pos.x, Pos.y, IndicatorColor, v )
							end
						end
					end
				end
			end
		end
	end

	net.Receive( "lfs_player_request_filter", function( length )
		local LFSent = net.ReadEntity()

		if not IsValid( LFSent ) then return end

		local Filter = net.ReadTable()

		LFSent.CrosshairFilterEnts = Filter
	end )

	local LFS_TIME_NOTIFY = 0
	net.Receive( "lfs_failstartnotify", function( len )
		surface.PlaySound( "common/wpn_hudon.ogg" )
		LFS_TIME_NOTIFY = CurTime() + 2
	end )

	hook.Add( "HUDShouldDraw", "!!!!_LFS_HideZOOM", function( name )
		local ply = LocalPlayer()

		if not ply.lfsGetPlane or not IsValid( ply:lfsGetPlane() ) then return end

		if name == "CHudZoom" then return false end
	end )

	hook.Add( "HUDPaint", "!!!!!LFS_hud", function()
		local ply = LocalPlayer()
		
		if ply:GetViewEntity() ~= ply then return end
		
		local Pod = ply:GetVehicle()
		local Parent = ply:lfsGetPlane()
		
		if not IsValid( Pod ) or not IsValid( Parent ) then 
			ply.oldPassengers = {}
			
			return
		end
		
		local X = ScrW()
		local Y = ScrH()
		
		PaintSeatSwitcher( Parent, X, Y )

		if Parent:GetDriverSeat() ~= Pod then 
			Parent:LFSHudPaintPassenger( X, Y, ply )
			PaintPlaneIdentifier( Parent )
			
			return
		end
		
		if HintPlayerAboutHisFuckingIncompetence then
			if not Parent.ERRORSOUND then
				surface.PlaySound( "error.wav" )
				Parent.ERRORSOUND = true
			end
			
			local HintCol = Color(255,0,0, 255 )
			
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawRect( 0, 0, X, Y ) 
			surface.SetDrawColor( 255, 255, 255, 255 )
			
			draw.SimpleText( "OOPS! SOMETHING WENT WRONG :( ", "LFS_FONT", X * 0.5, Y * 0.5 - 40, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "ONE OF YOUR ADDONS IS BREAKING THE CALCVIEW HOOK. PLANES WILL NOT BE USEABLE", "LFS_FONT", X * 0.5, Y * 0.5 - 20, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "HOW TO FIX?", "LFS_FONT", X * 0.5, Y * 0.5 + 20, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "DISABLE ALL ADDONS THAT COULD POSSIBLY MESS WITH THE CAMERA-VIEW", "LFS_FONT", X * 0.5, Y * 0.5 + 40, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "(THIRDPERSON ADDONS OR SIMILAR)", "LFS_FONT", X * 0.5, Y * 0.5 + 60, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			draw.SimpleText( ">>PRESS YOUR USE-KEY TO LEAVE THE VEHICLE & HIDE THIS MESSAGE<<", "LFS_FONT", X * 0.5, Y * 0.5 + 120, Color(255,0,0, math.abs( math.cos( CurTime() ) * 255) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			return
		end
		
		PaintPlaneHud( Parent, X, Y, ply )
		PaintPlaneIdentifier( Parent )
		
		local startpos =  Parent:GetRotorPos()
		local TracePlane = util.TraceLine( {
			start = startpos,
			endpos = (startpos + Parent:GetForward() * 50000),
			filter = Parent:GetCrosshairFilterEnts()
		} )
		
		local TracePilot = util.TraceLine( {
			start = startpos,
			endpos = (startpos + ply:EyeAngles():Forward() * 50000),
			filter = Parent:GetCrosshairFilterEnts()
		} )
		
		local HitPlane = TracePlane.HitPos:ToScreen()
		local HitPilot = TracePilot.HitPos:ToScreen()

		local Sub = Vector(HitPilot.x,HitPilot.y,0) - Vector(HitPlane.x,HitPlane.y,0)
		local Len = Sub:Length()
		local Dir = Sub:GetNormalized()
		
		Parent:LFSHudPaintInfoLine( HitPlane, HitPilot, LFS_TIME_NOTIFY, Dir, Len, ply:lfsGetInput( "FREELOOK" ) )
		Parent:LFSHudPaintCrosshair( HitPlane, HitPilot )
		Parent:LFSHudPaintRollIndicator( HitPlane, ShowShowRollIndic )
	end )

	local Frame
	local bgMat = Material( "lfs_controlpanel_bg.png" )
	local adminMat = Material( "icon16/shield.png" )
	local soundPreviewMat = Material( "materials/icon16/sound.png" )

	local IsClientSelected = true

	function simfphys.LFS.OpenClientSettings( Frame )
		IsClientSelected = true
		
		if IsValid( Frame.SV_PANEL ) then
			Frame.SV_PANEL:Remove()
		end
		
		if IsValid( Frame.CT_PANEL ) then
			Frame.CT_PANEL:Remove()
		end
		
		if not IsValid( Frame.CL_PANEL ) then
			local DPanel = vgui.Create( "DPanel", Frame )
			DPanel:SetPos( 0, 45 )
			DPanel:SetSize( 400, 175 )
			DPanel.Paint = function(self, w, h ) 
				draw.DrawText( "( -1 = Focus Mouse   1 = Focus Plane )", "LFS_FONT_PANEL", 20, 75, Color( 200, 200, 200, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				--draw.DrawText( "Update Notification Voice", "LFS_FONT_PANEL", 20, 105, Color( 200, 200, 200, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			Frame.CL_PANEL = DPanel
			
			local slider = vgui.Create( "DNumSlider", DPanel )
			slider:SetPos( 20, 30 )
			slider:SetSize( 300, 20 )
			slider:SetText( "Engine Volume" )
			slider:SetMin( 0 )
			slider:SetMax( 1 )
			slider:SetDecimals( 2 )
			slider:SetConVar( "lfs_volume" )
			
			local slider = vgui.Create( "DNumSlider", DPanel )
			slider:SetPos( 20, 60 )
			slider:SetSize( 300, 20 )
			slider:SetText( "Camera Focus" )
			slider:SetMin( -1 )
			slider:SetMax( 1 )
			slider:SetDecimals( 2 )
			slider:SetConVar( "lfs_camerafocus" )

			local CheckBox = vgui.Create( "DCheckBoxLabel", DPanel )
			CheckBox:SetText( "Show Hit/Kill Marker" )
			CheckBox:SetConVar("lfs_hitmarker") 
			CheckBox:SizeToContents()
			CheckBox:SetPos( 20, 115 )

			local CheckBox = vgui.Create( "DCheckBoxLabel", DPanel )
			CheckBox:SetText( "Show Plane Identifier" )
			CheckBox:SetConVar("lfs_show_identifier") 
			CheckBox:SizeToContents()
			CheckBox:SetPos( 20, 140 )
			
			local CheckBox = vgui.Create( "DCheckBoxLabel", DPanel )
			CheckBox:SetText( "Show Roll Indicator" )
			CheckBox:SetConVar("lfs_show_rollindicator") 
			CheckBox:SizeToContents()
			CheckBox:SetPos( 180, 140 )

			local DButton = vgui.Create("DPanel",DPanel)
			DButton:SetText("")
			DButton:SetPos(0,0)
			DButton:SetSize(201,20)
			DButton.Paint = function(self, w, h ) 
				draw.DrawText( "SETTINGS", "LFS_FONT", w * 0.5, -1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			local DButton = vgui.Create("DButton",DPanel)
			DButton:SetText("")
			DButton:SetPos(200,0)
			DButton:SetSize(200,20)
			DButton.DoClick = function() 
				surface.PlaySound( "buttons/button14.wav" )
				simfphys.LFS.OpenControlSettings( Frame )
			end
			DButton.Paint = function(self, w, h ) 
				local Highlight = self:IsHovered()
				
				surface.SetDrawColor(0,0,0,255)
				surface.DrawRect(0, 0, w, h)
				
				surface.SetDrawColor( Highlight and Color( 120, 120, 120, 255 ) or Color( 80, 80, 80, 255 ) )
				surface.DrawRect(1, 1, w - 2, h - 2)
				
				draw.DrawText( "CONTROLS", "LFS_FONT", w * 0.5, -1, Highlight and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
	end

	function simfphys.LFS.OpenControlSettings( Frame )
		IsClientSelected = true
		
		if IsValid( Frame.SV_PANEL ) then
			Frame.SV_PANEL:Remove()
		end
		
		if IsValid( Frame.CL_PANEL ) then
			Frame.CL_PANEL:Remove()
		end
		
		if not IsValid( Frame.CT_PANEL ) then
			local DPanel = vgui.Create( "DPanel", Frame )
			DPanel:SetPos( 0, 45 )
			DPanel:SetSize( 400, 175 )
			DPanel.Paint = function(self, w, h ) 
			end
			Frame.CT_PANEL = DPanel
			
			local DButton = vgui.Create("DPanel",DPanel)
			DButton:SetText("")
			DButton:SetPos(200,0)
			DButton:SetSize(200,20)
			DButton.Paint = function(self, w, h ) 
				draw.DrawText( "CONTROLS", "LFS_FONT", w * 0.5, -1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			local DButton = vgui.Create("DButton",DPanel)
			DButton:SetText("")
			DButton:SetPos(0,0)
			DButton:SetSize(201,20)
			DButton.DoClick = function() 
				surface.PlaySound( "buttons/button14.wav" )
				simfphys.LFS.OpenClientSettings( Frame )
			end
			DButton.Paint = function(self, w, h ) 
				local Highlight = self:IsHovered()
				
				surface.SetDrawColor(0,0,0,255)
				surface.DrawRect(0, 0, w, h)
				
				surface.SetDrawColor( Highlight and Color( 120, 120, 120, 255 ) or Color( 80, 80, 80, 255 ) )
				surface.DrawRect(1, 1, w - 2, h - 2)
				
				draw.DrawText( "SETTINGS", "LFS_FONT", w * 0.5, -1, Highlight and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			if cvarUnlockControls:GetInt() == 0 then
				local DButton = vgui.Create("DButton",DPanel)
				DButton:SetText("")
				DButton:SetPos(1,25)
				DButton:SetSize(399,130)
				DButton.DoClick = function() 
					surface.PlaySound( "buttons/button14.wav" )
					
					cvarUnlockControls:SetInt( 1 )
					
					if IsValid( Frame.CT_PANEL ) then
						Frame.CT_PANEL:Remove()
					end
					simfphys.LFS.OpenControlSettings( Frame )
					
					LocalPlayer():lfsBuildControls()
				end
				DButton.Paint = function(self, w, h ) 
					local Highlight = self:IsHovered()
					draw.DrawText( "!!WARNING!!", "LFS_FONT_PANEL", 20, 10, Color( 255, 50, 50, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.DrawText( "By Default the vehicles use IN_ keys and since it was never intended to", "LFS_FONT_PANEL", 20, 30, Color( 255, 50, 50, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.DrawText( "allow rebinding this could cause problems or may not work properly", "LFS_FONT_PANEL", 20, 50, Color( 255, 50, 50, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.DrawText( "with some vehicles.", "LFS_FONT_PANEL", 20, 70, Color( 255, 50, 50, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					
					draw.DrawText( "CLICK ME TO UNLOCK KEY-BINDING", "LFS_FONT", w * 0.5, h * 0.5 + 30, Highlight and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			else
				local DScrollPanel = vgui.Create("DScrollPanel", DPanel)
				DScrollPanel:SetPos(0,25)
				DScrollPanel:SetSize(395,130)
				
				local TextHint = vgui.Create("DPanel",DScrollPanel)
				TextHint:SetText("")
				TextHint:SetPos(-5,5)
				TextHint:SetSize(395,20)
				TextHint.Paint = function(self, w, h ) 
					draw.DrawText( "You need to re-enter the vehicle in order for the changes to take effect!", "LFS_FONT_PANEL", w * 0.5, -1, Color( 255, 50, 50, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				
				local y  = 30
				
				local CheckBox = vgui.Create( "DCheckBoxLabel",DScrollPanel)
				CheckBox:SetText( "Disable Q-Menu while inside Vehicle" )
				CheckBox:SetConVar("lfs_qmenudisable") 
				CheckBox:SizeToContents()
				CheckBox:SetPos( 27, y )
				
				y = y + 30
				
				local TextHint = vgui.Create("DPanel",DScrollPanel)
				TextHint:SetText("")
				TextHint:SetPos(27,y)
				TextHint:SetSize(200,30)
				TextHint.Paint = function(self, w, h ) 
					draw.DrawText( "MISC", "LFS_FONT", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
				
				y = y + 30
				
				for _, v in pairs( simfphys.LFS.KEYS_DEFAULT ) do
					if v.class == "misc" then
						local ConVar = GetConVar( v.cmd )
						
						local DLabel = vgui.Create("DLabel",DScrollPanel)
						DLabel:SetPos(30,y)
						DLabel:SetText(v.name_menu)
						DLabel:SetSize(180,20)
						
						local DBinder = vgui.Create("DBinder",DScrollPanel)
						DBinder:SetValue( ConVar:GetInt() )
						DBinder:SetPos(240,y)
						DBinder:SetSize(110,20)
						DBinder.ConVar = ConVar
						DBinder.OnChange = function(self,iNum)
							self.ConVar:SetInt(iNum)
							
							LocalPlayer():lfsBuildControls()
						end

						y = y + 30
					end
				end
				
				y = y + 15
				
				local TextHint = vgui.Create("DPanel",DScrollPanel)
				TextHint:SetText("")
				TextHint:SetPos(27,y)
				TextHint:SetSize(200,30)
				TextHint.Paint = function(self, w, h ) 
					draw.DrawText( "PLANE", "LFS_FONT", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
				
				y = y + 30
				
				for _, v in pairs( simfphys.LFS.KEYS_DEFAULT ) do
					if v.class == "plane" then
						local ConVar = GetConVar( v.cmd )
						
						local DLabel = vgui.Create("DLabel",DScrollPanel)
						DLabel:SetPos(30,y)
						DLabel:SetText(v.name_menu)
						DLabel:SetSize(180,20)
						
						local DBinder = vgui.Create("DBinder",DScrollPanel)
						DBinder:SetValue( ConVar:GetInt() )
						DBinder:SetPos(240,y)
						DBinder:SetSize(110,20)
						DBinder.ConVar = ConVar
						DBinder.OnChange = function(self,iNum)
							self.ConVar:SetInt(iNum)
							
							LocalPlayer():lfsBuildControls()
						end

						y = y + 30
					end
				end
				
				y = y + 15
				
				local TextHint = vgui.Create("DPanel",DScrollPanel)
				TextHint:SetText("")
				TextHint:SetPos(27,y)
				TextHint:SetSize(200,30)
				TextHint.Paint = function(self, w, h ) 
					draw.DrawText( "HELICOPTER", "LFS_FONT", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
				
				y = y + 30
				
				for _, v in pairs( simfphys.LFS.KEYS_DEFAULT ) do
					if v.class == "heli" then
						local ConVar = GetConVar( v.cmd )
						
						local DLabel = vgui.Create("DLabel",DScrollPanel)
						DLabel:SetPos(30,y)
						DLabel:SetText(v.name_menu)
						DLabel:SetSize(180,20)
						
						local DBinder = vgui.Create("DBinder",DScrollPanel)
						DBinder:SetValue( ConVar:GetInt() )
						DBinder:SetPos(240,y)
						DBinder:SetSize(110,20)
						DBinder.ConVar = ConVar
						DBinder.OnChange = function(self,iNum)
							self.ConVar:SetInt(iNum)
							
							LocalPlayer():lfsBuildControls()
						end

						y = y + 30
					end
				end
				
				y = y + 15
				
				local DButton = vgui.Create("DButton",DScrollPanel)
				DButton:SetText("Reset")
				DButton:SetPos(28,y)
				DButton:SetSize(322,20)
				DButton.DoClick = function() 
					surface.PlaySound( "buttons/button14.wav" )
					
					cvarDisableQMENU:SetBool( true )
					cvarUnlockControls:SetInt( 0 )
					
					for _, v in pairs( simfphys.LFS.KEYS_DEFAULT ) do
						GetConVar( v.cmd ):SetInt( v.default ) 
					end
					
					if IsValid( Frame.CT_PANEL ) then
						Frame.CT_PANEL:Remove()
					end
					
					simfphys.LFS.OpenControlSettings( Frame )
					
					LocalPlayer():lfsBuildControls()
				end
			end
		end
	end

	function simfphys.LFS.OpenServerSettings( Frame )
		IsClientSelected = false
		
		if IsValid( Frame.CL_PANEL ) then
			Frame.CL_PANEL:Remove()
		end
		
		if IsValid( Frame.CT_PANEL ) then
			Frame.CT_PANEL:Remove()
		end
		
		if not IsValid( Frame.SV_PANEL ) then
			local DPanel = vgui.Create( "DPanel", Frame )
			DPanel:SetPos( 0, 45 )
			DPanel:SetSize( 400, 175 )
			DPanel.Paint = function(self, w, h )
				draw.DrawText( "( This will only affect new connected Players )", "LFS_FONT_PANEL", 20, 25, Color( 200, 200, 200, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			Frame.SV_PANEL = DPanel
		
			local slider = vgui.Create( "DNumSlider", DPanel )
			slider:SetPos( 20, 10 )
			slider:SetSize( 300, 20 )
			slider:SetText( "Player Default AI-Team" )
			slider:SetMin( 0 )
			slider:SetMax( 3 )
			slider:SetDecimals( 0 )
			slider:SetConVar( "lfs_default_teams" )
			function slider:OnValueChanged( val )
				net.Start("lfs_admin_setconvar")
					net.WriteString("lfs_default_teams")
					net.WriteString( tostring( val ) )
				net.SendToServer()
			end
			
			local CheckBox = vgui.Create( "DCheckBoxLabel", DPanel )
			CheckBox:SetPos( 20, 65 )
			CheckBox:SetText( "Freeze Player AI-Team" )
			CheckBox:SetValue( GetConVar( "lfs_freeze_teams" ):GetInt() )
			CheckBox:SizeToContents()
			function CheckBox:OnChange( val )
				net.Start("lfs_admin_setconvar")
					net.WriteString("lfs_freeze_teams")
					net.WriteString( tostring( val and 1 or 0 ) )
				net.SendToServer()
			end

			local CheckBox = vgui.Create( "DCheckBoxLabel", DPanel )
			CheckBox:SetPos( 20, 85 )
			CheckBox:SetText( "Only allow Players of matching AI-Team to enter Vehicles" )
			CheckBox:SetValue( GetConVar( "lfs_teampassenger" ):GetInt() )
			CheckBox:SizeToContents()
			function CheckBox:OnChange( val )
				net.Start("lfs_admin_setconvar")
					net.WriteString("lfs_teampassenger")
					net.WriteString( tostring( val and 1 or 0 ) )
				net.SendToServer()
			end

			local CheckBox = vgui.Create( "DCheckBoxLabel", DPanel )
			CheckBox:SetPos( 20, 105 )
			CheckBox:SetText( "LFS-AI ignore NPC's" )
			CheckBox:SetValue( GetConVar( "lfs_ai_ignorenpcs" ):GetInt() )
			CheckBox:SizeToContents()
			function CheckBox:OnChange( val )
				net.Start("lfs_admin_setconvar")
					net.WriteString("lfs_ai_ignorenpcs")
					net.WriteString( tostring( val and 1 or 0 ) )
				net.SendToServer()
			end
		end
	end

	local function OpenMenu()
		if not IsValid( Frame ) then
			Frame = vgui.Create( "DFrame" )
			Frame:SetSize( 400, 220 )
			Frame:SetTitle( "" )
			Frame:SetDraggable( true )
			Frame:MakePopup()
			Frame:Center()
			Frame.Paint = function(self, w, h )
				draw.RoundedBox( 8, 0, 0, w, h, Color( 0, 0, 0, 255 ) )
				draw.RoundedBox( 8, 1, 46, w-2, h-47, Color( 120, 120, 120, 255 ) )
				
				local ColorSelected = Color( 120, 120, 120, 255 )
				
				local Col_C = IsClientSelected and Color( 120, 120, 120, 255 ) or Color( 80, 80, 80, 255 )
				local Col_S = IsClientSelected and Color( 80, 80, 80, 255 ) or Color( 120, 120, 120, 255 )
				
				draw.RoundedBox( 4, 1, 26, 199, IsClientSelected and 36 or 19, Col_C )
				draw.RoundedBox( 4, 201, 26, 198, IsClientSelected and 19 or 36, Col_S )
				
				draw.RoundedBox( 8, 0, 0, w, 25, Color( 127, 0, 0, 255 ) )
				draw.SimpleText( "[LFS] Planes - Control Panel ", "LFS_FONT", 5, 11, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				surface.SetDrawColor( 255, 255, 255, 50 )
				surface.SetMaterial( bgMat )
				surface.DrawTexturedRect( 0, -50, w, w )

				draw.DrawText( "v"..simfphys.LFS.GetVersion()..simfphys.LFS.VERSION_TYPE, "LFS_FONT_PANEL", w - 15, h - 20, Color( 255, 191, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			end
			simfphys.LFS.OpenClientSettings( Frame )
			
			local DermaButton = vgui.Create( "DButton", Frame )
			DermaButton:SetText( "" )
			DermaButton:SetPos( 0, 25 )
			DermaButton:SetSize( 200, 20 )
			DermaButton.DoClick = function()
				surface.PlaySound( "buttons/button14.wav" )
				simfphys.LFS.OpenClientSettings( Frame )
			end
			DermaButton.Paint = function(self, w, h ) 
				if not IsClientSelected and self:IsHovered() then
					draw.RoundedBox( 4, 1, 1, w - 1, h - 1, Color( 120, 120, 120, 255 ) )
				end
				
				local Col = (self:IsHovered() or IsClientSelected) and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 )
				draw.DrawText( "CLIENT", "LFS_FONT", w * 0.5, 0, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			local DermaButton = vgui.Create( "DButton", Frame )
			DermaButton:SetText( "" )
			DermaButton:SetPos( 200, 25 )
			DermaButton:SetSize( 200, 20 )
			DermaButton.DoClick = function()
				if LocalPlayer():IsSuperAdmin() then
					surface.PlaySound( "buttons/button14.wav" )
					simfphys.LFS.OpenServerSettings( Frame )
				else
					surface.PlaySound( "buttons/button11.wav" )
				end
			end
			DermaButton.Paint = function(self, w, h ) 
				if IsClientSelected and self:IsHovered() then
					draw.RoundedBox( 4, 1, 1, w - 2, h - 1, Color( 120, 120, 120, 255 ) )
				end
				
				local Highlight = (self:IsHovered() or not IsClientSelected)
				
				local Col = Highlight and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 )
				draw.DrawText( "SERVER", "LFS_FONT", w * 0.5, 0, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				
				surface.SetDrawColor( 255, 255, 255, Highlight and 255 or 50 )
				surface.SetMaterial( adminMat )
				surface.DrawTexturedRect( 3, 2, 16, 16 )
			end
		end
	end

	local LFSSoundList = {}
	hook.Add( "EntityEmitSound", "!!!lfs_volumemanager", function( t )
		if t.Entity.LFS then
			local SoundFile = t.SoundName
			
			if LFSSoundList[ SoundFile ] == true then
				t.Volume = t.Volume * cvarVolume:GetFloat()
				return true
				
			elseif LFSSoundList[ SoundFile ] == false then
				return false
				
			else
				local File = string.Replace( SoundFile, "^", "" )

				local Exists = file.Exists( "sound/"..File , "GAME" )
				
				LFSSoundList[ SoundFile ] = Exists
				
				if not Exists then
					print("[LFS] '"..SoundFile.."' not found. Soundfile will not be played and is filtered for this game session to avoid fps issues.")
				end
			end
		end
	end )

	list.Set( "DesktopWindows", "LFSMenu", {
		title = "[LFS] Settings",
		icon = "icon64/iconlfs.png",
		init = function( icon, window )
			OpenMenu()
		end
	} )

	concommand.Add( "lfs_openmenu", function( ply, cmd, args ) OpenMenu() end )

	timer.Simple(10, function()
		if not istable( scripted_ents ) or not isfunction( scripted_ents.GetList ) then return end
		
		for _, v in pairs( scripted_ents.GetList() ) do
			if v and istable( v.t ) then
				if v.t.Spawnable then
					if v.t.Base and string.StartWith( v.t.Base:lower(), "lunasflightschool_basescript" ) then
						if v.t.Category and v.t.PrintName then
							if istable( killicon ) and isfunction( killicon.Add ) then
								killicon.Add( v.t.ClassName, "HUD/killicons/lfs_plane", Color( 255, 80, 0, 255 ) )
							end
						end
					end
				end
			end
		end
	end)

	cvars.AddChangeCallback( "lfs_show_identifier", function( convar, oldValue, newValue ) 
		ShowPlaneIdent = tonumber( newValue ) ~=0
	end)

	cvars.AddChangeCallback( "lfs_show_rollindicator", function( convar, oldValue, newValue ) 
		ShowShowRollIndic = tonumber( newValue ) ~=0
	end)

	cvars.AddChangeCallback( "lfs_hitmarker", function( convar, oldValue, newValue ) 
		ShowHitMarker = tonumber( newValue ) ~=0
	end)
end

cvars.AddChangeCallback( "ai_ignoreplayers", function( convar, oldValue, newValue ) 
	simfphys.LFS.IgnorePlayers = tonumber( newValue ) ~=0
end)

cvars.AddChangeCallback( "lfs_ai_ignorenpcs", function( convar, oldValue, newValue ) 
	simfphys.LFS.IgnoreNPCs = tonumber( newValue ) ~=0
end)

hook.Add( "InitPostEntity", "!!!lfscheckupdates", function()
	timer.Simple(20, function() simfphys.LFS.CheckUpdates() end)
end )

hook.Add( "CanProperty", "!!!!lfsEditPropertiesDisabler", function( ply, property, ent )
	if ent.LFS and not ply:IsAdmin() and property == "editentity" then return false end
end )
--DO NOT EDIT OR REUPLOAD THIS FILE

local cVar_playerignore = GetConVar( "ai_ignoreplayers" )
local meta = FindMetaTable( "Player" )

simfphys = istable( simfphys ) and simfphys or {} -- lets check if the simfphys table exists. if not, create it!
simfphys.LFS = {} -- lets add another table for this project. We will be storing all our global functions and variables here. LFS means LunasFlightSchool

simfphys.LFS.VERSION = 303
simfphys.LFS.VERSION_TYPE = ".WS"

simfphys.LFS.KEYS_IN = {}
simfphys.LFS.KEYS_DEFAULT = {}
simfphys.LFS.CollisionFilter = {}
simfphys.LFS.PlanesStored = {}
simfphys.LFS.NextPlanesGetAll = 0
simfphys.LFS.NPCsStored = {}
simfphys.LFS.NextNPCsGetAll = 0

simfphys.LFS.cVar_IgnoreNPCs = CreateConVar( "lfs_ai_ignorenpcs", "0", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"should LFS-AI ignore NPC's?" )

simfphys.LFS.FreezeTeams = CreateConVar( "lfs_freeze_teams", "0", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"enable/disable auto ai-team switching" )
simfphys.LFS.TeamPassenger = CreateConVar( "lfs_teampassenger", "0", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"only allow players of matching ai-team to enter the vehicle? 1 = team only, 0 = everyone can enter" )
simfphys.LFS.PlayerDefaultTeam = CreateConVar( "lfs_default_teams", "0", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"set default player ai-team" )

simfphys.LFS.IgnoreNPCs = simfphys.LFS.cVar_IgnoreNPCs and simfphys.LFS.cVar_IgnoreNPCs:GetBool() or false
simfphys.LFS.IgnorePlayers = cVar_playerignore and cVar_playerignore:GetBool() or false

simfphys.LFS.pSwitchKeys = {[KEY_1] = 1,[KEY_2] = 2,[KEY_3] = 3,[KEY_4] = 4,[KEY_5] = 5,[KEY_6] = 6,[KEY_7] = 7,[KEY_8] = 8,[KEY_9] = 9,[KEY_0] = 10}
simfphys.LFS.pSwitchKeysInv = {[1] = KEY_1,[2] = KEY_2,[3] = KEY_3,[4] = KEY_4,[5] = KEY_5,[6] = KEY_6,[7] = KEY_7,[8] = KEY_8,[9] = KEY_9,[10] = KEY_0}

function simfphys.LFS:AddKey(name, class, name_menu, default, cmd, IN_KEY)
	table.insert( simfphys.LFS.KEYS_DEFAULT, {name = name, class = class, name_menu = name_menu, default = default, cmd = cmd, IN_KEY = IN_KEY} )
	simfphys.LFS.KEYS_IN[name] = IN_KEY
	
	if CLIENT then
		CreateClientConVar( cmd, default, true, true )
	end
end

local DEFAULT_KEYS = {
	{name = "EXIT",			class = "misc",		name_menu = "Exit Vehicle",		default = KEY_J,		cmd = "cl_lfs_exit",					IN_KEY = 0},
	{name = "FREELOOK",		class = "misc",		name_menu = "Freelook (Hold)",	default = MOUSE_MIDDLE,	cmd = "cl_lfs_freelook",				IN_KEY = IN_WALK},
	{name = "ENGINE",			class = "misc",		name_menu = "Toggle Engine",		default = KEY_R,		cmd = "cl_lfs_toggle_engine",			IN_KEY = IN_RELOAD},
	{name = "VSPEC",			class = "misc",		name_menu = "Toggle Vehicle-specific Function",	default = KEY_SPACE,	cmd = "cl_lfs_toggle_vspecific",	IN_KEY = IN_JUMP},
	--{name = "PRI_ATTACK",		class = "misc",		name_menu = "Primary Attack",		default = MOUSE_LEFT,	cmd = "cl_lfs_primaryattack",	IN_KEY = IN_ATTACK},
	--{name = "SEC_ATTACK",		class = "misc",		name_menu = "Secondary Attack",	default = MOUSE_RIGHT,	cmd = "cl_lfs_secondaryattack",	IN_KEY = IN_ATTACK2},
	
	{name = "+THROTTLE",		class = "plane",		name_menu = "Throttle Increase",	default = KEY_W,		cmd = "cl_lfs_throttle_inc",	IN_KEY = IN_FORWARD},
	{name = "-THROTTLE",		class = "plane",		name_menu = "Throttle Decrease",	default = KEY_S,		cmd = "cl_lfs_throttle_dec",	IN_KEY = IN_BACK},
	{name = "+PITCH",			class = "plane",		name_menu = "Pitch Up",			default = KEY_LSHIFT,	cmd = "cl_lfs_pitch_up",		IN_KEY = IN_SPEED},
	{name = "-PITCH",			class = "plane",		name_menu = "Pitch Down",		default = KEY_LALT,	cmd = "cl_lfs_pitch_Down",	IN_KEY = 0},
	{name = "-YAW",			class = "plane",		name_menu = "Yaw Left",			default = KEY_Q,		cmd = "cl_lfs_yaw_left",		IN_KEY = 0},
	{name = "+YAW",			class = "plane",		name_menu = "Yaw Right",		default = KEY_E,		cmd = "cl_lfs_yaw_right",		IN_KEY = 0},
	{name = "-ROLL",			class = "plane",		name_menu = "Roll Left",			default = KEY_A,		cmd = "cl_lfs_roll_left",		IN_KEY = IN_MOVELEFT},
	{name = "+ROLL",			class = "plane",		name_menu = "Roll Right",			default = KEY_D,		cmd = "cl_lfs_roll_right",		IN_KEY = IN_MOVERIGHT},
	
	{name = "+THROTTLE_HELI",	class = "heli",		name_menu = "Throttle Increase",			default = KEY_W,		cmd = "cl_lfsheli_throttle_inc",	IN_KEY = IN_FORWARD},
	{name = "-THROTTLE_HELI",	class = "heli",		name_menu = "Throttle Decrease",			default = KEY_S,		cmd = "cl_lfsheli_throttle_dec",	IN_KEY = IN_BACK},
	{name = "+PITCH_HELI",		class = "heli",		name_menu = "Pitch Up (Hovermode Only)",	default = KEY_LALT,		cmd = "cl_lfsheli_pitch_up",	IN_KEY = 0},
	{name = "-PITCH_HELI",		class = "heli",		name_menu = "Pitch Down (Hovermode Only)",	default = KEY_LSHIFT ,	cmd = "cl_lfsheli_pitch_Down",	IN_KEY = 0},
	{name = "-YAW_HELI",		class = "heli",		name_menu = "Yaw Left (Hovermode Only)",	default = KEY_Q,		cmd = "cl_lfsheli_yaw_left",	IN_KEY = 0},
	{name = "+YAW_HELI",		class = "heli",		name_menu = "Yaw Righ (Hovermode Only)",	default = KEY_E,		cmd = "cl_lfsheli_yaw_right",	IN_KEY = 0},
	{name = "-ROLL_HELI",		class = "heli",		name_menu = "Roll Left",					default = KEY_A,		cmd = "cl_lfsheli_roll_left",		IN_KEY = IN_MOVELEFT},
	{name = "+ROLL_HELI",		class = "heli",		name_menu = "Roll Right",					default = KEY_D,		cmd = "cl_lfsheli_roll_right",	IN_KEY = IN_MOVERIGHT},
	{name = "HOVERMODE",		class = "heli",		name_menu = "Hovermode (Hold)",			default = KEY_SPACE,	cmd = "cl_lfsheli_hover",		IN_KEY = IN_SPEED},
}
for _, v in pairs( DEFAULT_KEYS ) do 
	simfphys.LFS:AddKey( v.name, v.class,  v.name_menu, v.default, v.cmd, v.IN_KEY )
end

function simfphys.LFS.CheckUpdates()
	http.Fetch("https://raw.githubusercontent.com/Blu-x92/LunasFlightSchool/master/lfs_base/lua/autorun/lfs_basescript.lua", function(contents,size) 
		local LatestVersion = tonumber( string.match( string.match( contents, "simfphys.LFS.VERSION%s=%s%d+" ) , "%d+" ) ) or 0

		if LatestVersion == 0 then
			print("[LFS] latest version could not be detected, You have Version: "..simfphys.LFS.GetVersion())
		else
			if simfphys.LFS.GetVersion() >= LatestVersion then
				print("[LFS] is up to date, Version: "..simfphys.LFS.GetVersion())
			else
				print("[LFS] a newer version is available! Version: "..LatestVersion..", You have Version: "..simfphys.LFS.GetVersion())
				print("[LFS] get the latest version at https://github.com/Blu-x92/LunasFlightSchool")
				
				if CLIENT then 
					timer.Simple(18, function() 
						chat.AddText( Color( 255, 0, 0 ), "[LFS] a newer version is available!" )
					end)
				end
			end
		end
	end)

	if SERVER then return end

	if not LFS_1878568737 then
		if file.Exists( "lfs_dontnotifyme.txt", "DATA" ) then return end

		local bgMat = Material( "lfs_controlpanel_bg.png" )

		local InfoFrame = vgui.Create( "DFrame" )
		InfoFrame:SetSize( 345, 120 )
		InfoFrame:SetTitle( "" )
		InfoFrame:SetDraggable( true )
		InfoFrame:MakePopup()
		InfoFrame:Center()
		InfoFrame.Paint = function(self, w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color( 0, 0, 0, 255 ) )
			draw.RoundedBox( 8, 1, 46, w-2, h-47, Color( 120, 120, 120, 255 ) )

			draw.RoundedBox( 4, 1, 26, w-2, 36, Color( 120, 120, 120, 255 ) )

			draw.RoundedBox( 8, 0, 0, w, 25, Color( 127, 0, 0, 255 ) )
			draw.SimpleText( "[LFS] - Notification", "LFS_FONT", 5, 11, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			surface.SetDrawColor( 255, 255, 255, 50 )
			surface.SetMaterial( bgMat )
			surface.DrawTexturedRect( 0, -50, w, w )

			draw.DrawText( "Due to ongoing complaints about filesize,", "LFS_FONT_PANEL", 10, 30, Color( 255, 170, 170, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.DrawText( "STAR WARS vehicles are NO LONGER PART OF THE BASE ADDON!", "LFS_FONT_PANEL", 10, 45, Color( 255, 170, 170, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.DrawText( "If you still want to use them", "LFS_FONT_PANEL", 10, 67, Color( 255, 170, 170, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end

		local DermaButton = vgui.Create( "DButton", InfoFrame )
		DermaButton:SetText( "" )
		DermaButton:SetPos( 150, 63 )
		DermaButton:SetSize( 150, 20 )
		DermaButton.DoClick = function() steamworks.ViewFile( "1878568737" ) end
		DermaButton.Paint = function(self, w, h ) 
			draw.DrawText( "CLICK HERE", "LFS_FONT", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end

		local CheckBox = vgui.Create( "DCheckBoxLabel", InfoFrame )
		CheckBox:SetText( "OK, don't show me this message ever again." )
		CheckBox:SizeToContents()
		CheckBox:SetPos( 10, 95 )
		CheckBox.OnChange = function(self, bVal)
			if bVal then
				surface.PlaySound( "buttons/button14.wav" )
				InfoFrame:Close()
				file.Write( "lfs_dontnotifyme.txt", "[LFS] - Star Wars Pack Notification suppressing file." )
			end
		end
	end
end

function simfphys.LFS.GetVersion()
	return simfphys.LFS.VERSION
end

hook.Add( "OnEntityCreated", "!!!!lfsEntitySorter", function( ent )
	timer.Simple( FrameTime(), function() 
		if not IsValid( ent ) then return end

		if isfunction( ent.IsNPC ) and ent:IsNPC() then
			table.insert( simfphys.LFS.NPCsStored, ent )
		end

		if ent.LFS then 
			if CLIENT and ent.PrintName then
				language.Add( ent:GetClass(), ent.PrintName)
			end

			table.insert( simfphys.LFS.PlanesStored, ent )

			if SERVER then
				simfphys.LFS:FixVelocity()
			end
		end
	end )
end )

function simfphys.LFS:NPCsGetAll()
	local Time = CurTime()
	
	if simfphys.LFS.NextNPCsGetAll < Time then
		simfphys.LFS.NextNPCsGetAll = Time + FrameTime()

		for index, npc in pairs( simfphys.LFS.NPCsStored ) do
			if not IsValid( npc ) then
				simfphys.LFS.NPCsStored[ index ] = nil
			end
		end
	end

	return simfphys.LFS.NPCsStored
end

function simfphys.LFS:PlanesGetAll()
	local Time = CurTime()
	
	if simfphys.LFS.NextPlanesGetAll < Time then
		simfphys.LFS.NextPlanesGetAll = Time + FrameTime()

		for index, plane in pairs( simfphys.LFS.PlanesStored ) do
			if not IsValid( plane ) then
				simfphys.LFS.PlanesStored[ index ] = nil
			end
		end
	end

	return simfphys.LFS.PlanesStored
end

function simfphys.LFS:GetNPCRelationship( npc_class )
	local Teams = {
		["npc_breen"] = 1,
		["npc_combine_s"] = 1,
		["npc_combinedropship"] = 1,
		["npc_combinegunship"] = 1,
		["npc_crabsynth"] = 1,
		["npc_cscanner"] = 1,
		["npc_helicopter"] = 1,
		["npc_manhack"] = 1,
		["npc_metropolice"] = 1,
		["npc_mortarsynth"] = 1,
		["npc_sniper"] = 1,
		["npc_stalker"] = 1,
		["npc_strider"] = 1,
		["monster_human_grunt"] = 1,
		["monster_human_assassin"] = 1,
		["monster_sentry"] = 1,

		["npc_kleiner"] = 2,
		["npc_monk"] = 2,
		["npc_mossman"] = 2,
		["npc_vortigaunt"] = 2,
		["npc_alyx"] = 2,
		["npc_barney"] = 2,
		["npc_citizen"] = 2,
		["npc_dog"] = 2,
		["npc_eli"] = 2,
		["monster_scientist"] = 2,
		["monster_barney"] = 2,

		["npc_fastzombie"] = 3,
		["npc_headcrab"] = 3,
		["npc_headcrab_black"] = 3,
		["npc_headcrab_fast"] = 3,
		["npc_antlion"] = 3,
		["npc_antlionguard"] = 3,
		["npc_zombie"] = 3,
		["npc_zombie_torso"] = 3,
		["npc_poisonzombie"] = 3,
		["monster_alien_grunt"] = 3,
		["monster_alien_slave"] = 3,
		["monster_gargantua"] = 3,
		["monster_bullchicken"] = 3,
		["monster_headcrab"] = 3,
		["monster_babycrab"] = 3,
		["monster_zombie"] = 3,
		["monster_houndeye"] = 3,
		["monster_nihilanth"] = 3,
		["monster_bigmomma"] = 3,
		["monster_babycrab"] = 3,
	}
	return Teams[ npc_class ] or "0"
end

function meta:lfsGetPlane()
	if not self:InVehicle() then return NULL end
	
	local Pod = self:GetVehicle()
	
	if not IsValid( Pod ) then return NULL end
	
	if Pod.LFSchecked then
		
		return Pod.LFSBaseEnt
		
	else
		local Parent = Pod:GetParent()
		
		if not IsValid( Parent ) then return NULL end
		
		if not Parent.LFS then return NULL end
		
		Pod.LFSchecked = true
		Pod.LFSBaseEnt = Parent
		
		return Parent
	end
end

function meta:lfsGetAITeam()
	return self:GetNWInt( "lfsAITeam", simfphys.LFS.PlayerDefaultTeam:GetInt() )
end

function meta:lfsBuildControls()
	if istable( self.LFS_BINDS ) then
		table.Empty( self.LFS_BINDS )
	end
	
	if SERVER then
		self.LFS_BINDS = {
			["misc"] = {},
			["plane"] = {},
			["heli"] = {},
		}
		
		self.LFS_HIPSTER = self:GetInfoNum( "lfs_hipster", 0 ) == 1
		
		for _,v in pairs( simfphys.LFS.KEYS_DEFAULT ) do
			self.LFS_BINDS[v.class][ self:GetInfoNum( v.cmd, 0 ) ] = v.name
		end
	else
		self.LFS_BINDS = {}
		
		self.LFS_HIPSTER = GetConVar( "lfs_hipster" ):GetBool()
		
		for _,v in pairs( simfphys.LFS.KEYS_DEFAULT ) do
			self.LFS_BINDS[ v.name ] = GetConVar( v.cmd ):GetInt()
		end
	end
end

function meta:lfsGetControls()
	if not istable( self.LFS_BINDS ) then
		self:lfsBuildControls()
	end
	
	return self.LFS_BINDS
end

local IS_MOUSE_ENUM = {
	[MOUSE_LEFT] = true,
	[MOUSE_RIGHT] = true,
	[MOUSE_MIDDLE] = true,
	[MOUSE_4] = true,
	[MOUSE_5] = true,
	[MOUSE_WHEEL_UP] = true,
	[MOUSE_WHEEL_DOWN] = true,
}

function meta:lfsGetInput( name )
	if self.LFS_HIPSTER then
		if SERVER then
			self.LFS_KEYDOWN = self.LFS_KEYDOWN and self.LFS_KEYDOWN or {}
			
			return self.LFS_KEYDOWN[ name ]
		else
			local Key = self:lfsGetControls()[ name ]
			
			if IS_MOUSE_ENUM[ Key ] then
				return input.IsMouseDown( Key ) 
			else
				return input.IsKeyDown( Key ) 
			end
		end
	else
		if self.LFS_HIPSTER == nil then -- something went wrong.
			self:lfsBuildControls()
			
			return false
		else
			if simfphys.LFS.KEYS_IN[ name ] then
				return self:KeyDown( simfphys.LFS.KEYS_IN[ name ] )
			else
				return false
			end
		end
	end
end

if SERVER then 
	resource.AddWorkshop("1571918906")

	util.AddNetworkString( "lfs_failstartnotify" )
	util.AddNetworkString( "lfs_admin_setconvar" )
	util.AddNetworkString( "lfs_player_request_filter" )
	util.AddNetworkString( "lfs_hitmarker" )
	util.AddNetworkString( "lfs_killmarker" )

	net.Receive( "lfs_player_request_filter", function( length, ply )
		if not IsValid( ply ) then return end
		
		local LFSent = net.ReadEntity()
		
		if not IsValid( LFSent ) then return end
		
		if not istable( LFSent.CrosshairFilterEnts ) then
			LFSent.CrosshairFilterEnts = {}
			
			for _, Entity in pairs( constraint.GetAllConstrainedEntities( LFSent ) ) do
				if IsValid( Entity ) then
					if not Entity:GetNoDraw() then -- dont add nodraw entites. They are NULL for client anyway
						table.insert( LFSent.CrosshairFilterEnts, Entity )
					end
				end
			end
			
			for _, Parent in pairs( LFSent.CrosshairFilterEnts ) do
				local Childs = Parent:GetChildren()
				for _, Child in pairs( Childs ) do
					if IsValid( Child ) then
						table.insert( LFSent.CrosshairFilterEnts, Child )
					end
				end
			end
		end
		
		net.Start( "lfs_player_request_filter" )
			net.WriteEntity( LFSent )
			net.WriteTable( LFSent.CrosshairFilterEnts )
		net.Send( ply )
	end)

	net.Receive( "lfs_admin_setconvar", function( length, ply )
		if not IsValid( ply ) or not ply:IsSuperAdmin() then return end
		
		local ConVar = net.ReadString()
		local Value = tonumber( net.ReadString() )
		
		RunConsoleCommand( ConVar, Value ) 
	end)

	function meta:lfsSetAITeam( nTeam )
		nTeam = nTeam or simfphys.LFS.PlayerDefaultTeam:GetInt()

		local TeamText = {
			[0] = "FRIENDLY TO EVERYONE",
			[1] = "Team 1",
			[2] = "Team 2",
			[3] = "HOSTILE TO EVERYONE",
		}

		if self:lfsGetAITeam() ~= nTeam then
			self:PrintMessage( HUD_PRINTTALK, "[LFS] Your AI-Team has been updated to: "..TeamText[ nTeam ] )
		end

		self:SetNWInt( "lfsAITeam", nTeam )
	end

	function meta:lfsSetInput( name, value )
		self.LFS_KEYDOWN = self.LFS_KEYDOWN and self.LFS_KEYDOWN or {}
		self.LFS_KEYDOWN[ name ] = value
	end

	function simfphys.LFS:AddColDMGFilterClass( name_class )
		if not isstring( name_class ) then return end

		simfphys.LFS.CollisionFilter[ name_class:lower() ] = true
	end

	function simfphys.LFS:FixVelocity()
		local tbl = physenv.GetPerformanceSettings()

		if tbl.MaxVelocity < 4000 then
			local OldVel = tbl.MaxVelocity

			tbl.MaxVelocity = 4000
			physenv.SetPerformanceSettings(tbl)

			print("[LFS] Low MaxVelocity detected! Increasing! "..OldVel.." => 4000")
		end

		if tbl.MaxAngularVelocity < 7272 then
			local OldAngVel = tbl.MaxAngularVelocity

			tbl.MaxAngularVelocity = 7272
			physenv.SetPerformanceSettings(tbl)

			print("[LFS] Low MaxAngularVelocity detected! Increasing! "..OldAngVel.." => 7272")
		end
	end

	hook.Add("CanExitVehicle","!!!lfsCanExitVehicle",function(vehicle,ply)
		if IsValid( ply:lfsGetPlane() ) then return not ply.LFS_HIPSTER end
	end)

	hook.Add( "PlayerButtonUp", "!!!lfsButtonUp", function( ply, button )
		for _, LFS_BIND in pairs( ply:lfsGetControls() ) do
			if LFS_BIND[ button ] then
				ply:lfsSetInput( LFS_BIND[ button ], false )
			end
		end
	end )
	
	hook.Add( "PlayerButtonDown", "!!!lfsButtonDown", function( ply, button )
		local vehicle = ply:lfsGetPlane()
		
		for _, LFS_BIND in pairs( ply:lfsGetControls() ) do
			if LFS_BIND[ button ] then
				ply:lfsSetInput( LFS_BIND[ button ], true )
				
				if IsValid( vehicle ) then
					if ply.LFS_HIPSTER then
						if LFS_BIND[ button ] == "EXIT" then
							ply:ExitVehicle()
						end
					end
				end
			end
		end
		
		if not IsValid( vehicle ) then return end
		
		if button == KEY_1 then
			if ply == vehicle:GetDriver() then
				if vehicle:GetlfsLockedStatus() then
					vehicle:UnLock()
				else
					vehicle:Lock()
				end
			else
				if not IsValid( vehicle:GetDriver() ) and not vehicle:GetAI() then
					ply:ExitVehicle()
					
					local DriverSeat = vehicle:GetDriverSeat()
					
					if IsValid( DriverSeat ) then
						timer.Simple( FrameTime(), function()
							if not IsValid( vehicle ) or not IsValid( ply ) then return end
							if IsValid( vehicle:GetDriver() ) or not IsValid( DriverSeat ) or vehicle:GetAI() then return end
							
							ply:EnterVehicle( DriverSeat )
							
							timer.Simple( FrameTime() * 2, function()
								if not IsValid( ply ) or not IsValid( vehicle ) then return end
								ply:SetEyeAngles( Angle(0,vehicle:GetAngles().y,0) )
							end)
						end)
					end
				end
			end
		else
			for _, Pod in pairs( vehicle:GetPassengerSeats() ) do
				if IsValid( Pod ) then
					if Pod:GetNWInt( "pPodIndex", 3 ) == simfphys.LFS.pSwitchKeys[ button ] then
						if not IsValid( Pod:GetDriver() ) then
							ply:ExitVehicle()
						
							timer.Simple( FrameTime(), function()
								if not IsValid( Pod ) or not IsValid( ply ) then return end
								if IsValid( Pod:GetDriver() ) then return end
								
								ply:EnterVehicle( Pod )
							end)
						end
					end
				end
			end
		end
	end )
	
	hook.Add( "PlayerLeaveVehicle", "!!LFS_Exit", function( ply, vehicle )
		if not ply:IsPlayer() then return end
		
		local Pod = ply:GetVehicle()
		local Parent = ply:lfsGetPlane()
		
		if not IsValid( Pod ) or not IsValid( Parent ) then return end
		
		if not simfphys.LFS.FreezeTeams:GetBool() then
			ply:lfsSetAITeam( Parent:GetAITEAM() )
		end
		
		local ent = Pod
		local b_ent = Parent
		
		local Center = b_ent:LocalToWorld( b_ent:OBBCenter() )
		local vel = b_ent:GetVelocity()
		local radius = b_ent:BoundingRadius()
		local HullSize = Vector(18,18,0)
		local Filter1 = {ent,ply}
		local Filter2 = {ent,ply,b_ent}

		for _, filterEntity in pairs( constraint.GetAllConstrainedEntities( b_ent ) ) do
			if IsValid( filterEntity ) then
				table.insert( Filter2, filterEntity )
			end
		end

		if vel:Length() > 250 then
			local pos = b_ent:GetPos()
			local dir = vel:GetNormalized()
			local targetpos = pos - dir *  (radius + 40)
			
			local tr = util.TraceHull( {
				start = Center,
				endpos = targetpos - Vector(0,0,10),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter2
			} )
			
			local exitpoint = tr.HitPos + Vector(0,0,10)
			
			if util.IsInWorld( exitpoint ) then
				ply:SetPos(exitpoint)
				ply:SetEyeAngles((pos - exitpoint):Angle())
			end
		else
			local pos = ent:GetPos()
			local targetpos = (pos + ent:GetRight() * 80)
			
			local tr1 = util.TraceLine( {
				start = targetpos,
				endpos = targetpos - Vector(0,0,100),
				filter = {}
			} )
			local tr2 = util.TraceHull( {
				start = targetpos,
				endpos = targetpos + Vector(0,0,80),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter1
			} )
			local traceto = util.TraceLine( {start = Center,endpos = targetpos,filter = Filter2} )
			
			local HitGround = tr1.Hit
			local HitWall = tr2.Hit or traceto.Hit
			
			local check0 = (HitWall == true or HitGround == false or util.IsInWorld( targetpos ) == false) and (pos - ent:GetRight() * 80) or targetpos
			local tr = util.TraceHull( {
				start = check0,
				endpos = check0 + Vector(0,0,80),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter1
			} )
			local traceto = util.TraceLine( {start = Center,endpos = check0,filter = Filter2} )
			local HitWall = tr.Hit or traceto.hit
			
			local check1 = (HitWall == true or HitGround == false or util.IsInWorld( check0 ) == false) and (pos + ent:GetUp() * 100) or check0
			
			local tr = util.TraceHull( {
				start = check1,
				endpos = check1 + Vector(0,0,80),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter1
			} )
			local traceto = util.TraceLine( {start = Center,endpos = check1,filter = Filter2} )
			local HitWall = tr.Hit or traceto.hit
			local check2 = (HitWall == true or util.IsInWorld( check1 ) == false) and (pos - ent:GetUp() * 100) or check1
			
			local tr = util.TraceHull( {
				start = check2,
				endpos = check2 + Vector(0,0,80),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter1
			} )
			local traceto = util.TraceLine( {start = Center,endpos = check2,filter = Filter2} )
			local HitWall = tr.Hit or traceto.hit
			local check3 = (HitWall == true or util.IsInWorld( check2 ) == false) and b_ent:LocalToWorld( Vector(0,radius,0) ) or check2
			
			local tr = util.TraceHull( {
				start = check3,
				endpos = check3 + Vector(0,0,80),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter1
			} )
			local traceto = util.TraceLine( {start = Center,endpos = check3,filter = Filter2} )
			local HitWall = tr.Hit or traceto.hit
			local check4 = (HitWall == true or util.IsInWorld( check3 ) == false) and b_ent:LocalToWorld( Vector(0,-radius,0) ) or check3
			
			local tr = util.TraceHull( {
				start = check4,
				endpos = check4 + Vector(0,0,80),
				maxs = HullSize,
				mins = -HullSize,
				filter = Filter1
			} )
			local traceto = util.TraceLine( {start = Center,endpos = check4,filter = Filter2} )
			local HitWall = tr.Hit or traceto.hit
			local exitpoint = (HitWall == true or util.IsInWorld( check4 ) == false) and b_ent:LocalToWorld( Vector(0,0,0) ) or check4
			
			if isvector( ent.ExitPos ) then
				exitpoint = b_ent:LocalToWorld( ent.ExitPos )
			end
			
			if util.IsInWorld( exitpoint ) then
				ply:SetPos(exitpoint)
				ply:SetEyeAngles((pos - exitpoint):Angle())
			end
		end
	end )
end

if CLIENT then
	local cvarVolume = CreateClientConVar( "lfs_volume", 0.65, true, false)
	local cvarCamFocus = CreateClientConVar( "lfs_camerafocus", 0, true, false)
	local cvarShowPlaneIdent = CreateClientConVar( "lfs_show_identifier", 1, true, false)
	local cvarShowRollIndic = CreateClientConVar( "lfs_show_rollindicator", 0, true, false)
	local cvarUnlockControls = CreateClientConVar( "lfs_hipster", 0, true, true)
	local cvarDisableQMENU = CreateClientConVar( "lfs_qmenudisable", 1, true, false)
	local cvarHitMarker = CreateConVar( "lfs_hitmarker", 1, true, false)

	local ShowPlaneIdent = cvarShowPlaneIdent and cvarShowPlaneIdent:GetBool() or true
	local ShowShowRollIndic = cvarShowRollIndic and cvarShowRollIndic:GetBool() or false
	local ShowHitMarker = cvarHitMarker and cvarHitMarker:GetBool() or false

	simfphys.LFS.AltitudeMinZ = 0

	local LastHitMarker = 0
	local LastKillMarker = 0

	net.Receive( "lfs_hitmarker", function( len )
		if not ShowHitMarker  then return end

		if LastHitMarker - math.random(0.09,0.14) > CurTime() then return end

		LastHitMarker = CurTime() + 0.15

		local ply = LocalPlayer()

		local vehicle = ply:lfsGetPlane()
		if IsValid( ply:lfsGetPlane() ) then 
			vehicle:HitMarker( LastHitMarker )
		end
	end )

	net.Receive( "lfs_killmarker", function( len )
		if not ShowHitMarker  then return end

		if LastKillMarker - 0.14 > CurTime() then return end

		LastKillMarker = CurTime() + 0.5

		local ply = LocalPlayer()

		local vehicle = ply:lfsGetPlane()
		if IsValid( ply:lfsGetPlane() ) then 
			vehicle:KillMarker( LastKillMarker )
		end
	end )

	local function PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness,bClockwise)
		local triarc = {}
		local deg2rad = math.pi / 180

		local startang,endang = startang or 0, endang or 0
		if bClockwise and (startang < endang) then
			local temp = startang
			startang = endang
			endang = temp
			temp = nil
		elseif (startang > endang) then 
			local temp = startang
			startang = endang
			endang = temp
			temp = nil
		end

		local roughness = math.max(roughness or 1, 1)
		local step = roughness
		if bClockwise then
			step = math.abs(roughness) * -1
		end

		local inner = {}
		local r = radius - thickness
		for deg=startang, endang, step do
			local rad = deg2rad * deg
			table.insert(inner, {
				x=cx+(math.cos(rad)*r),
				y=cy+(math.sin(rad)*r)
			})
		end

		local outer = {}
		for deg=startang, endang, step do
			local rad = deg2rad * deg
			table.insert(outer, {
				x=cx+(math.cos(rad)*radius),
				y=cy+(math.sin(rad)*radius)
			})
		end

		for tri=1,#inner*2 do
			local p1,p2,p3
			p1 = outer[math.floor(tri/2)+1]
			p3 = inner[math.floor((tri+1)/2)+1]
			if tri%2 == 0 then
				p2 = outer[math.floor((tri+1)/2)]
			else
				p2 = inner[math.floor((tri+1)/2)]
			end
		
			table.insert(triarc, {p1,p2,p3})
		end
		return triarc
	end

	function simfphys.LFS.DrawArc(cx,cy,radius,thickness,startang,endang,roughness,color,bClockwise)
		surface.SetDrawColor(color)
		draw.NoTexture()

		for k,v in ipairs( PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness,bClockwise) ) do
			surface.DrawPoly(v)
		end
	end

	function simfphys.LFS.DrawCircle( X, Y, radius )
		local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
		
		for a = 0, 360, segmentdist do
			surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
		end
	end

	function simfphys.LFS.DrawDiamond( X, Y, radius, perc )
		if perc <= 0 then return end

		local segmentdist = 90

		draw.NoTexture()

		for a = 90, 360, segmentdist do
			local Xa = math.Round( math.sin( math.rad( -a ) ) * radius, 0 )
			local Ya = math.Round( math.cos( math.rad( -a ) ) * radius, 0 )

			local C = math.sqrt( radius ^ 2 + radius ^ 2 )

			if a == 90 then
				C = C * math.min(math.max(perc - 0.75,0) / 0.25,1)
			elseif a == 180 then
				C = C * math.min(math.max(perc - 0.5,0) / 0.25,1)
			elseif a == 270 then
				C = C * math.min(math.max(perc - 0.25,0) / 0.25,1)
			elseif a == 360 then
				C = C * math.min(math.max(perc,0) / 0.25,1)
			end

			if C > 0 then
				local AxisMoveX = math.Round( math.sin( math.rad( -a + 135) ) * (C + 3) * 0.5, 0 )
				local AxisMoveY =math.Round( math.cos( math.rad( -a + 135) ) * (C + 3) * 0.5, 0 )

				surface.DrawTexturedRectRotated(X - Xa - AxisMoveX, Y - Ya - AxisMoveY,3, math.ceil( C ), a - 45)
			end
		end
	end

	hook.Add("SpawnMenuOpen", "!!!lfsDisableSpawnmenu", function()
		local ply = LocalPlayer() 
		
		if not ply.LFS_HIPSTER then return end
		if not IsValid( ply:lfsGetPlane() ) then return end
		
		return not cvarDisableQMENU:GetBool()
	end)

	local HintPlayerAboutHisFuckingIncompetence = true
	local smTran = 0
	hook.Add( "CalcView", "!!!!LFS_calcview", function(ply, pos, angles, fov)
		HintPlayerAboutHisFuckingIncompetence = false
	 
		if ply:GetViewEntity() ~= ply then return end
		
		local Pod = ply:GetVehicle()
		local Parent = ply:lfsGetPlane()
		
		if not IsValid( Pod ) or not IsValid( Parent ) then return end
		
		local cvarFocus = math.Clamp( cvarCamFocus:GetFloat() , -1, 1 )
		
		smTran = smTran + ((ply:lfsGetInput( "FREELOOK" ) and 0 or 1) - smTran) * FrameTime() * 10
		
		local view = {}
		view.origin = pos
		view.fov = fov
		view.drawviewer = true
		view.angles = (Parent:GetForward() * (1 + cvarFocus) * smTran * 0.8 + ply:EyeAngles():Forward() * math.max(1 - cvarFocus, 1 - smTran)):Angle()

		if cvarFocus >= 1 then
			view.angles = LerpAngle( smTran, ply:EyeAngles(), Parent:GetAngles() )
		else
			view.angles.r = 0
		end
		
		if Parent:GetDriverSeat() ~= Pod then
			view.angles = ply:EyeAngles()
		end
		
		if not Pod:GetThirdPersonMode() then
			
			view.drawviewer = false
			
			return Parent:LFSCalcViewFirstPerson( view, ply )
		end
		
		local radius = 550
		radius = radius + radius * Pod:GetCameraDistance()
		
		local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
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

		return Parent:LFSCalcViewThirdPerson( view, ply )
	end )

	surface.CreateFont( "LFS_FONT", {
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

	surface.CreateFont( "LFS_FONT_SWITCHER", {
		font = "Verdana",
		extended = false,
		size = 16,
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
	
	surface.CreateFont( "LFS_FONT_PANEL", {
		font = "Arial",
		extended = false,
		size = 14,
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	function simfphys.LFS.HudPaintPlaneIdentifier( X, Y, In_Col, target_ent )
		if not IsValid( target_ent ) then return end

		surface.SetDrawColor( In_Col.r, In_Col.g, In_Col.b, In_Col.a )
		simfphys.LFS.DrawDiamond( X + 1, Y + 1, 20, target_ent:GetHP() / target_ent:GetMaxHP() )

		if target_ent:GetMaxShield() > 0 then
			surface.SetDrawColor( 200, 200, 255, 255 )
			simfphys.LFS.DrawDiamond( X + 1, Y + 1, 24, target_ent:GetShield() / target_ent:GetMaxShield() )
		end

		--[[ old style
		local Size = 60
		
		surface.DrawLine( X - Size, Y + Size, X + Size, Y + Size )
		surface.DrawLine( X - Size, Y - Size, X - Size, Y + Size )
		surface.DrawLine( X + Size, Y - Size, X + Size, Y + Size )
		surface.DrawLine( X - Size, Y - Size, X + Size, Y - Size )
		]]
	end

	local function PaintPlaneHud( ent, X, Y, ply )
		if not IsValid( ent ) then return end
		
		local vel = ent:GetVelocity():Length()
		
		local Throttle = ent:GetThrottlePercent()

		local speed = math.Round(vel * 0.09144,0)

		local ZPos = math.Round( ent:GetPos().z,0)
		if (ZPos + simfphys.LFS.AltitudeMinZ)< 0 then simfphys.LFS.AltitudeMinZ = math.abs(ZPos) end
		local alt = math.Round( (ent:GetPos().z + simfphys.LFS.AltitudeMinZ) * 0.0254,0)

		local AmmoPrimary = ent:GetAmmoPrimary()
		local AmmoSecondary = ent:GetAmmoSecondary()

		local RepairProgress = ent:GetMaintenanceProgress()

		ent:LFSHudPaintInfoText( X, Y, speed, alt, AmmoPrimary, AmmoSecondary, Throttle )
		ent:LFSHudPaint( X, Y, {speed = speed, altitude = alt, PrimaryAmmo = AmmoPrimary, SecondaryAmmo = AmmoSecondary, Throttle = Throttle}, ply )
		ent:LFSRepairInfo( X, Y, ent:GetRepairMode(), RepairProgress, RepairProgress > 0 and RepairProgress < 1 )
	end

	local LockText = Material( "lfs_locked.png" )
	local smHider = 0
	local function PaintSeatSwitcher( ent, X, Y )
		local me = LocalPlayer()
		
		if not IsValid( ent ) then return end
		
		local pSeats = ent:GetPassengerSeats()
		local SeatCount = table.Count( pSeats ) 
		
		if SeatCount <= 0 then return end
		
		pSeats[0] = ent:GetDriverSeat()
		
		draw.NoTexture() 
		
		local MySeat = me:GetVehicle():GetNWInt( "pPodIndex", -1 )
		
		local Passengers = {}
		for _, ply in pairs( player.GetAll() ) do
			if ply:lfsGetPlane() == ent then
				local Pod = ply:GetVehicle()
				Passengers[ Pod:GetNWInt( "pPodIndex", -1 ) ] = ply:GetName()
			end
		end
		if ent:GetAI() then
			Passengers[1] = "[AI] "..ent.PrintName
		end
		
		me.SwitcherTime = me.SwitcherTime or 0
		me.oldPassengers = me.oldPassengers or {}
		
		local Time = CurTime()
		for k, v in pairs( Passengers ) do
			if me.oldPassengers[k] ~= v then
				me.oldPassengers[k] = v
				me.SwitcherTime = Time + 2
			end
		end
		for k, v in pairs( me.oldPassengers ) do
			if not Passengers[k] then
				me.oldPassengers[k] = nil
				me.SwitcherTime = Time + 2
			end
		end
		
		for _, v in pairs( simfphys.LFS.pSwitchKeysInv ) do
			if input.IsKeyDown(v) then
				me.SwitcherTime = Time + 2
			end
		end
		
		local Hide = me.SwitcherTime > Time
		smHider = smHider + ((Hide and 1 or 0) - smHider) * RealFrameTime() * 15
		local Alpha1 = 135 + 110 * smHider 
		local HiderOffset = 300 * smHider
		local Offset = -50
		local yPos = Y - (SeatCount + 1) * 30 - 10
		
		for _, Pod in pairs( pSeats ) do
			local I = Pod:GetNWInt( "pPodIndex", -1 )
			if I >= 0 then
				if I == MySeat then
					draw.RoundedBox(5, X + Offset - HiderOffset, yPos + I * 30, 35 + HiderOffset, 25, Color(127,0,0,100 + 50 * smHider) )
				else
					draw.RoundedBox(5, X + Offset - HiderOffset, yPos + I * 30, 35 + HiderOffset, 25, Color(0,0,0,100 + 50 * smHider) )
				end
				if I == SeatCount then
					if ent:GetlfsLockedStatus() then
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.SetMaterial( LockText  )
						surface.DrawTexturedRect( X + Offset - HiderOffset - 25, yPos + I * 30, 25, 25 )
					end
				end
				if Hide then
					if Passengers[I] then
						draw.DrawText( Passengers[I], "LFS_FONT_SWITCHER", X + 40 + Offset - HiderOffset, yPos + I * 30 + 2.5, Color( 255, 255, 255,  Alpha1 ), TEXT_ALIGN_LEFT )
					else
						draw.DrawText( "-", "LFS_FONT_SWITCHER", X + 40 + Offset - HiderOffset, yPos + I * 30 + 2.5, Color( 255, 255, 255,  Alpha1 ), TEXT_ALIGN_LEFT )
					end
					
					draw.DrawText( "["..I.."]", "LFS_FONT_SWITCHER", X + 17 + Offset - HiderOffset, yPos + I * 30 + 2.5, Color( 255, 255, 255, Alpha1 ), TEXT_ALIGN_CENTER )
				else
					if Passengers[I] then
						draw.DrawText( "[^"..I.."]", "LFS_FONT_SWITCHER", X + 17 + Offset - HiderOffset, yPos + I * 30 + 2.5, Color( 255, 255, 255, Alpha1 ), TEXT_ALIGN_CENTER )
					else
						draw.DrawText( "["..I.."]", "LFS_FONT_SWITCHER", X + 17 + Offset - HiderOffset, yPos + I * 30 + 2.5, Color( 255, 255, 255, Alpha1 ), TEXT_ALIGN_CENTER )
					end
				end
			end
		end
	end

	local NextFind = 0
	local AllPlanes = {}
	local function PaintPlaneIdentifier( ent )
		if not ShowPlaneIdent then return end

		if NextFind < CurTime() then
			NextFind = CurTime() + 3
			AllPlanes = simfphys.LFS:PlanesGetAll()
		end

		local MyPos = ent:GetPos()
		local MyTeam = ent:GetAITEAM()

		for _, v in pairs( AllPlanes ) do
			if IsValid( v ) then
				if v ~= ent then
					if isvector( v.SeatPos ) then
						local rPos = v:LocalToWorld( v.SeatPos )

						local Pos = rPos:ToScreen()
						local Dist = (MyPos - rPos):Length()

						if Dist < 10000 then
							if not util.TraceLine( {start = ent:GetRotorPos(),endpos = rPos,mask = MASK_NPCWORLDSTATIC,} ).Hit then

								local Alpha = 255 * (1 - (Dist / 10000) ^ 2)
								local Team = v:GetAITEAM()
								local IndicatorColor = Color( 255, 0, 0, Alpha )

								if Team == 0 then
									IndicatorColor = Color( 0, 255, 0, Alpha )
								else
									if Team == 1 or Team == 2 then
										if Team ~= MyTeam and MyTeam ~= 0 then
											IndicatorColor = Color( 255, 0, 0, Alpha )
										else
											IndicatorColor = Color( 0, 127, 255, Alpha )
										end
									end
								end

								ent:LFSHudPaintPlaneIdentifier( Pos.x, Pos.y, IndicatorColor, v )
							end
						end
					end
				end
			end
		end
	end

	net.Receive( "lfs_player_request_filter", function( length )
		local LFSent = net.ReadEntity()

		if not IsValid( LFSent ) then return end

		local Filter = net.ReadTable()

		LFSent.CrosshairFilterEnts = Filter
	end )

	local LFS_TIME_NOTIFY = 0
	net.Receive( "lfs_failstartnotify", function( len )
		surface.PlaySound( "common/wpn_hudon.ogg" )
		LFS_TIME_NOTIFY = CurTime() + 2
	end )

	hook.Add( "HUDShouldDraw", "!!!!_LFS_HideZOOM", function( name )
		local ply = LocalPlayer()

		if not ply.lfsGetPlane or not IsValid( ply:lfsGetPlane() ) then return end

		if name == "CHudZoom" then return false end
	end )

	hook.Add( "HUDPaint", "!!!!!LFS_hud", function()
		local ply = LocalPlayer()
		
		if ply:GetViewEntity() ~= ply then return end
		
		local Pod = ply:GetVehicle()
		local Parent = ply:lfsGetPlane()
		
		if not IsValid( Pod ) or not IsValid( Parent ) then 
			ply.oldPassengers = {}
			
			return
		end
		
		local X = ScrW()
		local Y = ScrH()
		
		PaintSeatSwitcher( Parent, X, Y )

		if Parent:GetDriverSeat() ~= Pod then 
			Parent:LFSHudPaintPassenger( X, Y, ply )
			PaintPlaneIdentifier( Parent )
			
			return
		end
		
		if HintPlayerAboutHisFuckingIncompetence then
			if not Parent.ERRORSOUND then
				surface.PlaySound( "error.wav" )
				Parent.ERRORSOUND = true
			end
			
			local HintCol = Color(255,0,0, 255 )
			
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawRect( 0, 0, X, Y ) 
			surface.SetDrawColor( 255, 255, 255, 255 )
			
			draw.SimpleText( "OOPS! SOMETHING WENT WRONG :( ", "LFS_FONT", X * 0.5, Y * 0.5 - 40, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "ONE OF YOUR ADDONS IS BREAKING THE CALCVIEW HOOK. PLANES WILL NOT BE USEABLE", "LFS_FONT", X * 0.5, Y * 0.5 - 20, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "HOW TO FIX?", "LFS_FONT", X * 0.5, Y * 0.5 + 20, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "DISABLE ALL ADDONS THAT COULD POSSIBLY MESS WITH THE CAMERA-VIEW", "LFS_FONT", X * 0.5, Y * 0.5 + 40, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "(THIRDPERSON ADDONS OR SIMILAR)", "LFS_FONT", X * 0.5, Y * 0.5 + 60, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			draw.SimpleText( ">>PRESS YOUR USE-KEY TO LEAVE THE VEHICLE & HIDE THIS MESSAGE<<", "LFS_FONT", X * 0.5, Y * 0.5 + 120, Color(255,0,0, math.abs( math.cos( CurTime() ) * 255) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			return
		end
		
		PaintPlaneHud( Parent, X, Y, ply )
		PaintPlaneIdentifier( Parent )
		
		local startpos =  Parent:GetRotorPos()
		local TracePlane = util.TraceLine( {
			start = startpos,
			endpos = (startpos + Parent:GetForward() * 50000),
			filter = Parent:GetCrosshairFilterEnts()
		} )
		
		local TracePilot = util.TraceLine( {
			start = startpos,
			endpos = (startpos + ply:EyeAngles():Forward() * 50000),
			filter = Parent:GetCrosshairFilterEnts()
		} )
		
		local HitPlane = TracePlane.HitPos:ToScreen()
		local HitPilot = TracePilot.HitPos:ToScreen()

		local Sub = Vector(HitPilot.x,HitPilot.y,0) - Vector(HitPlane.x,HitPlane.y,0)
		local Len = Sub:Length()
		local Dir = Sub:GetNormalized()
		
		Parent:LFSHudPaintInfoLine( HitPlane, HitPilot, LFS_TIME_NOTIFY, Dir, Len, ply:lfsGetInput( "FREELOOK" ) )
		Parent:LFSHudPaintCrosshair( HitPlane, HitPilot )
		Parent:LFSHudPaintRollIndicator( HitPlane, ShowShowRollIndic )
	end )

	local Frame
	local bgMat = Material( "lfs_controlpanel_bg.png" )
	local adminMat = Material( "icon16/shield.png" )
	local soundPreviewMat = Material( "materials/icon16/sound.png" )

	local IsClientSelected = true

	function simfphys.LFS.OpenClientSettings( Frame )
		IsClientSelected = true
		
		if IsValid( Frame.SV_PANEL ) then
			Frame.SV_PANEL:Remove()
		end
		
		if IsValid( Frame.CT_PANEL ) then
			Frame.CT_PANEL:Remove()
		end
		
		if not IsValid( Frame.CL_PANEL ) then
			local DPanel = vgui.Create( "DPanel", Frame )
			DPanel:SetPos( 0, 45 )
			DPanel:SetSize( 400, 175 )
			DPanel.Paint = function(self, w, h ) 
				draw.DrawText( "( -1 = Focus Mouse   1 = Focus Plane )", "LFS_FONT_PANEL", 20, 75, Color( 200, 200, 200, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				--draw.DrawText( "Update Notification Voice", "LFS_FONT_PANEL", 20, 105, Color( 200, 200, 200, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			Frame.CL_PANEL = DPanel
			
			local slider = vgui.Create( "DNumSlider", DPanel )
			slider:SetPos( 20, 30 )
			slider:SetSize( 300, 20 )
			slider:SetText( "Engine Volume" )
			slider:SetMin( 0 )
			slider:SetMax( 1 )
			slider:SetDecimals( 2 )
			slider:SetConVar( "lfs_volume" )
			
			local slider = vgui.Create( "DNumSlider", DPanel )
			slider:SetPos( 20, 60 )
			slider:SetSize( 300, 20 )
			slider:SetText( "Camera Focus" )
			slider:SetMin( -1 )
			slider:SetMax( 1 )
			slider:SetDecimals( 2 )
			slider:SetConVar( "lfs_camerafocus" )

			local CheckBox = vgui.Create( "DCheckBoxLabel", DPanel )
			CheckBox:SetText( "Show Hit/Kill Marker" )
			CheckBox:SetConVar("lfs_hitmarker") 
			CheckBox:SizeToContents()
			CheckBox:SetPos( 20, 115 )

			local CheckBox = vgui.Create( "DCheckBoxLabel", DPanel )
			CheckBox:SetText( "Show Plane Identifier" )
			CheckBox:SetConVar("lfs_show_identifier") 
			CheckBox:SizeToContents()
			CheckBox:SetPos( 20, 140 )
			
			local CheckBox = vgui.Create( "DCheckBoxLabel", DPanel )
			CheckBox:SetText( "Show Roll Indicator" )
			CheckBox:SetConVar("lfs_show_rollindicator") 
			CheckBox:SizeToContents()
			CheckBox:SetPos( 180, 140 )

			local DButton = vgui.Create("DPanel",DPanel)
			DButton:SetText("")
			DButton:SetPos(0,0)
			DButton:SetSize(201,20)
			DButton.Paint = function(self, w, h ) 
				draw.DrawText( "SETTINGS", "LFS_FONT", w * 0.5, -1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			local DButton = vgui.Create("DButton",DPanel)
			DButton:SetText("")
			DButton:SetPos(200,0)
			DButton:SetSize(200,20)
			DButton.DoClick = function() 
				surface.PlaySound( "buttons/button14.wav" )
				simfphys.LFS.OpenControlSettings( Frame )
			end
			DButton.Paint = function(self, w, h ) 
				local Highlight = self:IsHovered()
				
				surface.SetDrawColor(0,0,0,255)
				surface.DrawRect(0, 0, w, h)
				
				surface.SetDrawColor( Highlight and Color( 120, 120, 120, 255 ) or Color( 80, 80, 80, 255 ) )
				surface.DrawRect(1, 1, w - 2, h - 2)
				
				draw.DrawText( "CONTROLS", "LFS_FONT", w * 0.5, -1, Highlight and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
	end

	function simfphys.LFS.OpenControlSettings( Frame )
		IsClientSelected = true
		
		if IsValid( Frame.SV_PANEL ) then
			Frame.SV_PANEL:Remove()
		end
		
		if IsValid( Frame.CL_PANEL ) then
			Frame.CL_PANEL:Remove()
		end
		
		if not IsValid( Frame.CT_PANEL ) then
			local DPanel = vgui.Create( "DPanel", Frame )
			DPanel:SetPos( 0, 45 )
			DPanel:SetSize( 400, 175 )
			DPanel.Paint = function(self, w, h ) 
			end
			Frame.CT_PANEL = DPanel
			
			local DButton = vgui.Create("DPanel",DPanel)
			DButton:SetText("")
			DButton:SetPos(200,0)
			DButton:SetSize(200,20)
			DButton.Paint = function(self, w, h ) 
				draw.DrawText( "CONTROLS", "LFS_FONT", w * 0.5, -1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			local DButton = vgui.Create("DButton",DPanel)
			DButton:SetText("")
			DButton:SetPos(0,0)
			DButton:SetSize(201,20)
			DButton.DoClick = function() 
				surface.PlaySound( "buttons/button14.wav" )
				simfphys.LFS.OpenClientSettings( Frame )
			end
			DButton.Paint = function(self, w, h ) 
				local Highlight = self:IsHovered()
				
				surface.SetDrawColor(0,0,0,255)
				surface.DrawRect(0, 0, w, h)
				
				surface.SetDrawColor( Highlight and Color( 120, 120, 120, 255 ) or Color( 80, 80, 80, 255 ) )
				surface.DrawRect(1, 1, w - 2, h - 2)
				
				draw.DrawText( "SETTINGS", "LFS_FONT", w * 0.5, -1, Highlight and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			if cvarUnlockControls:GetInt() == 0 then
				local DButton = vgui.Create("DButton",DPanel)
				DButton:SetText("")
				DButton:SetPos(1,25)
				DButton:SetSize(399,130)
				DButton.DoClick = function() 
					surface.PlaySound( "buttons/button14.wav" )
					
					cvarUnlockControls:SetInt( 1 )
					
					if IsValid( Frame.CT_PANEL ) then
						Frame.CT_PANEL:Remove()
					end
					simfphys.LFS.OpenControlSettings( Frame )
					
					LocalPlayer():lfsBuildControls()
				end
				DButton.Paint = function(self, w, h ) 
					local Highlight = self:IsHovered()
					draw.DrawText( "!!WARNING!!", "LFS_FONT_PANEL", 20, 10, Color( 255, 50, 50, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.DrawText( "By Default the vehicles use IN_ keys and since it was never intended to", "LFS_FONT_PANEL", 20, 30, Color( 255, 50, 50, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.DrawText( "allow rebinding this could cause problems or may not work properly", "LFS_FONT_PANEL", 20, 50, Color( 255, 50, 50, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.DrawText( "with some vehicles.", "LFS_FONT_PANEL", 20, 70, Color( 255, 50, 50, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					
					draw.DrawText( "CLICK ME TO UNLOCK KEY-BINDING", "LFS_FONT", w * 0.5, h * 0.5 + 30, Highlight and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			else
				local DScrollPanel = vgui.Create("DScrollPanel", DPanel)
				DScrollPanel:SetPos(0,25)
				DScrollPanel:SetSize(395,130)
				
				local TextHint = vgui.Create("DPanel",DScrollPanel)
				TextHint:SetText("")
				TextHint:SetPos(-5,5)
				TextHint:SetSize(395,20)
				TextHint.Paint = function(self, w, h ) 
					draw.DrawText( "You need to re-enter the vehicle in order for the changes to take effect!", "LFS_FONT_PANEL", w * 0.5, -1, Color( 255, 50, 50, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				
				local y  = 30
				
				local CheckBox = vgui.Create( "DCheckBoxLabel",DScrollPanel)
				CheckBox:SetText( "Disable Q-Menu while inside Vehicle" )
				CheckBox:SetConVar("lfs_qmenudisable") 
				CheckBox:SizeToContents()
				CheckBox:SetPos( 27, y )
				
				y = y + 30
				
				local TextHint = vgui.Create("DPanel",DScrollPanel)
				TextHint:SetText("")
				TextHint:SetPos(27,y)
				TextHint:SetSize(200,30)
				TextHint.Paint = function(self, w, h ) 
					draw.DrawText( "MISC", "LFS_FONT", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
				
				y = y + 30
				
				for _, v in pairs( simfphys.LFS.KEYS_DEFAULT ) do
					if v.class == "misc" then
						local ConVar = GetConVar( v.cmd )
						
						local DLabel = vgui.Create("DLabel",DScrollPanel)
						DLabel:SetPos(30,y)
						DLabel:SetText(v.name_menu)
						DLabel:SetSize(180,20)
						
						local DBinder = vgui.Create("DBinder",DScrollPanel)
						DBinder:SetValue( ConVar:GetInt() )
						DBinder:SetPos(240,y)
						DBinder:SetSize(110,20)
						DBinder.ConVar = ConVar
						DBinder.OnChange = function(self,iNum)
							self.ConVar:SetInt(iNum)
							
							LocalPlayer():lfsBuildControls()
						end

						y = y + 30
					end
				end
				
				y = y + 15
				
				local TextHint = vgui.Create("DPanel",DScrollPanel)
				TextHint:SetText("")
				TextHint:SetPos(27,y)
				TextHint:SetSize(200,30)
				TextHint.Paint = function(self, w, h ) 
					draw.DrawText( "PLANE", "LFS_FONT", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
				
				y = y + 30
				
				for _, v in pairs( simfphys.LFS.KEYS_DEFAULT ) do
					if v.class == "plane" then
						local ConVar = GetConVar( v.cmd )
						
						local DLabel = vgui.Create("DLabel",DScrollPanel)
						DLabel:SetPos(30,y)
						DLabel:SetText(v.name_menu)
						DLabel:SetSize(180,20)
						
						local DBinder = vgui.Create("DBinder",DScrollPanel)
						DBinder:SetValue( ConVar:GetInt() )
						DBinder:SetPos(240,y)
						DBinder:SetSize(110,20)
						DBinder.ConVar = ConVar
						DBinder.OnChange = function(self,iNum)
							self.ConVar:SetInt(iNum)
							
							LocalPlayer():lfsBuildControls()
						end

						y = y + 30
					end
				end
				
				y = y + 15
				
				local TextHint = vgui.Create("DPanel",DScrollPanel)
				TextHint:SetText("")
				TextHint:SetPos(27,y)
				TextHint:SetSize(200,30)
				TextHint.Paint = function(self, w, h ) 
					draw.DrawText( "HELICOPTER", "LFS_FONT", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
				
				y = y + 30
				
				for _, v in pairs( simfphys.LFS.KEYS_DEFAULT ) do
					if v.class == "heli" then
						local ConVar = GetConVar( v.cmd )
						
						local DLabel = vgui.Create("DLabel",DScrollPanel)
						DLabel:SetPos(30,y)
						DLabel:SetText(v.name_menu)
						DLabel:SetSize(180,20)
						
						local DBinder = vgui.Create("DBinder",DScrollPanel)
						DBinder:SetValue( ConVar:GetInt() )
						DBinder:SetPos(240,y)
						DBinder:SetSize(110,20)
						DBinder.ConVar = ConVar
						DBinder.OnChange = function(self,iNum)
							self.ConVar:SetInt(iNum)
							
							LocalPlayer():lfsBuildControls()
						end

						y = y + 30
					end
				end
				
				y = y + 15
				
				local DButton = vgui.Create("DButton",DScrollPanel)
				DButton:SetText("Reset")
				DButton:SetPos(28,y)
				DButton:SetSize(322,20)
				DButton.DoClick = function() 
					surface.PlaySound( "buttons/button14.wav" )
					
					cvarDisableQMENU:SetBool( true )
					cvarUnlockControls:SetInt( 0 )
					
					for _, v in pairs( simfphys.LFS.KEYS_DEFAULT ) do
						GetConVar( v.cmd ):SetInt( v.default ) 
					end
					
					if IsValid( Frame.CT_PANEL ) then
						Frame.CT_PANEL:Remove()
					end
					
					simfphys.LFS.OpenControlSettings( Frame )
					
					LocalPlayer():lfsBuildControls()
				end
			end
		end
	end

	function simfphys.LFS.OpenServerSettings( Frame )
		IsClientSelected = false
		
		if IsValid( Frame.CL_PANEL ) then
			Frame.CL_PANEL:Remove()
		end
		
		if IsValid( Frame.CT_PANEL ) then
			Frame.CT_PANEL:Remove()
		end
		
		if not IsValid( Frame.SV_PANEL ) then
			local DPanel = vgui.Create( "DPanel", Frame )
			DPanel:SetPos( 0, 45 )
			DPanel:SetSize( 400, 175 )
			DPanel.Paint = function(self, w, h )
				draw.DrawText( "( This will only affect new connected Players )", "LFS_FONT_PANEL", 20, 25, Color( 200, 200, 200, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			Frame.SV_PANEL = DPanel
		
			local slider = vgui.Create( "DNumSlider", DPanel )
			slider:SetPos( 20, 10 )
			slider:SetSize( 300, 20 )
			slider:SetText( "Player Default AI-Team" )
			slider:SetMin( 0 )
			slider:SetMax( 3 )
			slider:SetDecimals( 0 )
			slider:SetConVar( "lfs_default_teams" )
			function slider:OnValueChanged( val )
				net.Start("lfs_admin_setconvar")
					net.WriteString("lfs_default_teams")
					net.WriteString( tostring( val ) )
				net.SendToServer()
			end
			
			local CheckBox = vgui.Create( "DCheckBoxLabel", DPanel )
			CheckBox:SetPos( 20, 65 )
			CheckBox:SetText( "Freeze Player AI-Team" )
			CheckBox:SetValue( GetConVar( "lfs_freeze_teams" ):GetInt() )
			CheckBox:SizeToContents()
			function CheckBox:OnChange( val )
				net.Start("lfs_admin_setconvar")
					net.WriteString("lfs_freeze_teams")
					net.WriteString( tostring( val and 1 or 0 ) )
				net.SendToServer()
			end

			local CheckBox = vgui.Create( "DCheckBoxLabel", DPanel )
			CheckBox:SetPos( 20, 85 )
			CheckBox:SetText( "Only allow Players of matching AI-Team to enter Vehicles" )
			CheckBox:SetValue( GetConVar( "lfs_teampassenger" ):GetInt() )
			CheckBox:SizeToContents()
			function CheckBox:OnChange( val )
				net.Start("lfs_admin_setconvar")
					net.WriteString("lfs_teampassenger")
					net.WriteString( tostring( val and 1 or 0 ) )
				net.SendToServer()
			end

			local CheckBox = vgui.Create( "DCheckBoxLabel", DPanel )
			CheckBox:SetPos( 20, 105 )
			CheckBox:SetText( "LFS-AI ignore NPC's" )
			CheckBox:SetValue( GetConVar( "lfs_ai_ignorenpcs" ):GetInt() )
			CheckBox:SizeToContents()
			function CheckBox:OnChange( val )
				net.Start("lfs_admin_setconvar")
					net.WriteString("lfs_ai_ignorenpcs")
					net.WriteString( tostring( val and 1 or 0 ) )
				net.SendToServer()
			end
		end
	end

	local function OpenMenu()
		if not IsValid( Frame ) then
			Frame = vgui.Create( "DFrame" )
			Frame:SetSize( 400, 220 )
			Frame:SetTitle( "" )
			Frame:SetDraggable( true )
			Frame:MakePopup()
			Frame:Center()
			Frame.Paint = function(self, w, h )
				draw.RoundedBox( 8, 0, 0, w, h, Color( 0, 0, 0, 255 ) )
				draw.RoundedBox( 8, 1, 46, w-2, h-47, Color( 120, 120, 120, 255 ) )
				
				local ColorSelected = Color( 120, 120, 120, 255 )
				
				local Col_C = IsClientSelected and Color( 120, 120, 120, 255 ) or Color( 80, 80, 80, 255 )
				local Col_S = IsClientSelected and Color( 80, 80, 80, 255 ) or Color( 120, 120, 120, 255 )
				
				draw.RoundedBox( 4, 1, 26, 199, IsClientSelected and 36 or 19, Col_C )
				draw.RoundedBox( 4, 201, 26, 198, IsClientSelected and 19 or 36, Col_S )
				
				draw.RoundedBox( 8, 0, 0, w, 25, Color( 127, 0, 0, 255 ) )
				draw.SimpleText( "[LFS] Planes - Control Panel ", "LFS_FONT", 5, 11, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				surface.SetDrawColor( 255, 255, 255, 50 )
				surface.SetMaterial( bgMat )
				surface.DrawTexturedRect( 0, -50, w, w )

				draw.DrawText( "v"..simfphys.LFS.GetVersion()..simfphys.LFS.VERSION_TYPE, "LFS_FONT_PANEL", w - 15, h - 20, Color( 255, 191, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			end
			simfphys.LFS.OpenClientSettings( Frame )
			
			local DermaButton = vgui.Create( "DButton", Frame )
			DermaButton:SetText( "" )
			DermaButton:SetPos( 0, 25 )
			DermaButton:SetSize( 200, 20 )
			DermaButton.DoClick = function()
				surface.PlaySound( "buttons/button14.wav" )
				simfphys.LFS.OpenClientSettings( Frame )
			end
			DermaButton.Paint = function(self, w, h ) 
				if not IsClientSelected and self:IsHovered() then
					draw.RoundedBox( 4, 1, 1, w - 1, h - 1, Color( 120, 120, 120, 255 ) )
				end
				
				local Col = (self:IsHovered() or IsClientSelected) and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 )
				draw.DrawText( "CLIENT", "LFS_FONT", w * 0.5, 0, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			local DermaButton = vgui.Create( "DButton", Frame )
			DermaButton:SetText( "" )
			DermaButton:SetPos( 200, 25 )
			DermaButton:SetSize( 200, 20 )
			DermaButton.DoClick = function()
				if LocalPlayer():IsSuperAdmin() then
					surface.PlaySound( "buttons/button14.wav" )
					simfphys.LFS.OpenServerSettings( Frame )
				else
					surface.PlaySound( "buttons/button11.wav" )
				end
			end
			DermaButton.Paint = function(self, w, h ) 
				if IsClientSelected and self:IsHovered() then
					draw.RoundedBox( 4, 1, 1, w - 2, h - 1, Color( 120, 120, 120, 255 ) )
				end
				
				local Highlight = (self:IsHovered() or not IsClientSelected)
				
				local Col = Highlight and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 )
				draw.DrawText( "SERVER", "LFS_FONT", w * 0.5, 0, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				
				surface.SetDrawColor( 255, 255, 255, Highlight and 255 or 50 )
				surface.SetMaterial( adminMat )
				surface.DrawTexturedRect( 3, 2, 16, 16 )
			end
		end
	end

	local LFSSoundList = {}
	hook.Add( "EntityEmitSound", "!!!lfs_volumemanager", function( t )
		if t.Entity.LFS then
			local SoundFile = t.SoundName
			
			if LFSSoundList[ SoundFile ] == true then
				t.Volume = t.Volume * cvarVolume:GetFloat()
				return true
				
			elseif LFSSoundList[ SoundFile ] == false then
				return false
				
			else
				local File = string.Replace( SoundFile, "^", "" )

				local Exists = file.Exists( "sound/"..File , "GAME" )
				
				LFSSoundList[ SoundFile ] = Exists
				
				if not Exists then
					print("[LFS] '"..SoundFile.."' not found. Soundfile will not be played and is filtered for this game session to avoid fps issues.")
				end
			end
		end
	end )

	list.Set( "DesktopWindows", "LFSMenu", {
		title = "[LFS] Settings",
		icon = "icon64/iconlfs.png",
		init = function( icon, window )
			OpenMenu()
		end
	} )

	concommand.Add( "lfs_openmenu", function( ply, cmd, args ) OpenMenu() end )

	timer.Simple(10, function()
		if not istable( scripted_ents ) or not isfunction( scripted_ents.GetList ) then return end
		
		for _, v in pairs( scripted_ents.GetList() ) do
			if v and istable( v.t ) then
				if v.t.Spawnable then
					if v.t.Base and string.StartWith( v.t.Base:lower(), "lunasflightschool_basescript" ) then
						if v.t.Category and v.t.PrintName then
							if istable( killicon ) and isfunction( killicon.Add ) then
								killicon.Add( v.t.ClassName, "HUD/killicons/lfs_plane", Color( 255, 80, 0, 255 ) )
							end
						end
					end
				end
			end
		end
	end)

	cvars.AddChangeCallback( "lfs_show_identifier", function( convar, oldValue, newValue ) 
		ShowPlaneIdent = tonumber( newValue ) ~=0
	end)

	cvars.AddChangeCallback( "lfs_show_rollindicator", function( convar, oldValue, newValue ) 
		ShowShowRollIndic = tonumber( newValue ) ~=0
	end)

	cvars.AddChangeCallback( "lfs_hitmarker", function( convar, oldValue, newValue ) 
		ShowHitMarker = tonumber( newValue ) ~=0
	end)
end

cvars.AddChangeCallback( "ai_ignoreplayers", function( convar, oldValue, newValue ) 
	simfphys.LFS.IgnorePlayers = tonumber( newValue ) ~=0
end)

cvars.AddChangeCallback( "lfs_ai_ignorenpcs", function( convar, oldValue, newValue ) 
	simfphys.LFS.IgnoreNPCs = tonumber( newValue ) ~=0
end)

hook.Add( "InitPostEntity", "!!!lfscheckupdates", function()
	timer.Simple(20, function() simfphys.LFS.CheckUpdates() end)
end )

hook.Add( "CanProperty", "!!!!lfsEditPropertiesDisabler", function( ply, property, ent )
	if ent.LFS and not ply:IsAdmin() and property == "editentity" then return false end
end )