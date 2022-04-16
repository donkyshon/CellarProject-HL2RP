
-- Original idea by High6

TOOL.Category = "Half-Life 2"
TOOL.Name = "#tool.prop_door"

TOOL.ClientConVar[ "model" ] = "models/props_c17/door01_left.mdl"
TOOL.ClientConVar[ "type" ] = "1"
TOOL.ClientConVar[ "key_open" ] = "38"
TOOL.ClientConVar[ "key_close" ] = "39"
TOOL.ClientConVar[ "key_lock" ] = "40"
TOOL.ClientConVar[ "key_unlock" ] = "41"

TOOL.ClientConVar[ "auto_close" ] = "1"
TOOL.ClientConVar[ "auto_close_delay" ] = "4"

TOOL.ClientConVar[ "skin" ] = "1"

TOOL.ClientConVar[ "r_double" ] = "0"
TOOL.ClientConVar[ "r_hardware" ] = "1"
TOOL.ClientConVar[ "r_distance" ] = "90"
TOOL.ClientConVar[ "r_speed" ] = "100"

local gDoorUniqueID = 0

cleanup.Register( "prop_doors" )

local minsZ = {}
minsZ[ "models/props/portal_door_combined.mdl" ] = -18.421800613403
minsZ[ "models/props_mining/elevator01_cagedoor.mdl" ] = 0
minsZ[ "models/props_mining/techgate01.mdl" ] = -3.0040739147807e-05
minsZ[ "models/props_combine/combine_door01.mdl" ] = -96.376152038574
minsZ[ "models/combine_gate_vehicle.mdl" ] = -30.216606140137
minsZ[ "models/combine_gate_citizen.mdl" ] = -30.00006103515
minsZ[ "models/props_lab/elevatordoor.mdl" ] = -1
--minsZ[ "models/props_doors/doorklab01.mdl" ] = -5.004433631897

function TOOL:FixDynamicPos( mdl, pos, ang, minz )

	-- This is UGLY AF
	if ( --[[!minz &&]] minsZ[ mdl ] ) then minz = minsZ[ mdl ] else minz = 0 end

	local ent = self:GetOwner()

	if ( mdl == "models/props_mining/elevator01_cagedoor.mdl" ) then
		ang:RotateAroundAxis( Vector( 0, 0, 1 ), -90 )
	else
		pos = pos - Vector( 0, 0, minz )
	end

	if ( mdl == "models/props_combine/combine_door01.mdl" ) then
		ang:RotateAroundAxis( Vector( 0, 0, 1 ), -90 )
	end
	if ( mdl == "models/props_mining/techgate01.mdl" || mdl == "models/props_mining/techgate01_outland03.mdl" ) then
		ang:RotateAroundAxis( Vector( 0, 0, 1 ), -90 )
		pos = pos - ent:GetRight() * 80
	end

	if ( mdl == "models/props/portal_door_combined.mdl" ) then
		pos = pos - ent:GetUp() * 21
		ang:RotateAroundAxis( Vector( 0, 0, 1 ), -180 )
	end

	return pos, ang
end

function TOOL:FixRotatingPos( ent )
	if ( !IsValid( ent ) ) then return end

	local e = ent

	local min = ent:OBBMins()
	local max = ent:OBBMaxs()
	local pos = ent:GetPos()
	local ang = ent:GetAngles()

	local typ = self:GetClientNumber( "type" )
	local doubl = self:GetClientNumber( "r_double" ) + 1

	if ( typ == 1 || typ == 3 ) then pos = pos + ent:GetRight() * ( max.y / 2.01 ) * doubl end
	if ( typ == 2 ) then pos = pos + ent:GetRight() * ( max.y / 3.1 ) * doubl end

	-- L4D2 doors
	if ( typ == 4 ) then pos = pos + ent:GetRight() * ( max.y / 2.34 ) * doubl end
	if ( typ == 5 ) then pos = pos + ent:GetRight() * ( max.y / 2.04 ) * doubl end
	if ( typ == 6 ) then pos = pos + ent:GetRight() * ( max.y / 2.21 ) * doubl end
	if ( typ == 7 ) then pos = pos + ent:GetRight() * ( max.y / 2.057 ) * doubl end
	if ( typ == 8 ) then pos = pos + ent:GetRight() * ( max.y / 2.07 ) * doubl end
	if ( typ == 9 ) then pos = pos + ent:GetRight() * ( max.y / 2.067 ) * doubl end
	if ( typ == 10 ) then pos = pos + ent:GetRight() * ( max.y / 2.081 ) * doubl end

	e:SetPos( pos - Vector( 0, 0, min.z ) )
	e:SetAngles( ang )
	e:Activate()
end

if ( SERVER ) then
	CreateConVar( "sbox_maxprop_doors", 10 )

	numpad.Register( "prop_door_open", function( ply, prop_door ) if ( !IsValid( prop_door ) ) then return false end prop_door:Fire( "Open" ) end )
	numpad.Register( "prop_door_close", function( ply, prop_door ) if ( !IsValid( prop_door ) ) then return false end prop_door:Fire( "Close" ) end )
	numpad.Register( "prop_door_lock", function( ply, prop_door ) if ( !IsValid( prop_door ) ) then return false end prop_door:Fire( "Lock" ) end )
	numpad.Register( "prop_door_unlock", function( ply, prop_door ) if ( !IsValid( prop_door ) ) then return false end prop_door:Fire( "Unlock" ) end )

	function MakeDoorRotating( ply, model, pos, ang, _oSkin, keyOpen, keyClose, keyLock, keyUnlock, _oHardware, _oDistance, _oSpeed, _oReturnDelay, _oTargetName, data )
		if ( IsValid( ply ) && !ply:CheckLimit( "prop_doors" ) ) then return nil end

		local prop_door_rotating = ents.Create( "prop_door_rotating" )
		if ( !IsValid( prop_door_rotating ) ) then return false end

		prop_door_rotating:SetModel( model )
		prop_door_rotating:SetPos( pos )
		if ( data && data.initialAngles ) then ang = data.initialAngles end
		prop_door_rotating:SetAngles( ang )

		keyOpen = keyOpen || -1
		keyClose = keyClose || -1
		keyLock = keyLock || -1
		keyUnlock = keyUnlock || -1

		local targetname = _oTargetName || ""
		if ( data && data.targetname ) then targetname = data.targetname end
		local hardware = _oHardware || 1
		if ( data && data.hardware ) then hardware = data.hardware end
		local distance = _oDistance || 90
		if ( data && data.distance ) then distance = data.distance end
		local speed = _oSpeed || 100
		if ( data && data.speed ) then speed = data.speed end
		local returndelay = _oReturnDelay || 4
		if ( data && data.returndelay ) then returndelay = data.returndelay end
		local skin = _oSkin || 0
		if ( data && data.skin ) then skin = data.skin end

		local spawnflags = 8192
		--if ( data && data.spawnflags ) then spawnflags = data.spawnflags end
		local ajarangles
		if ( data && data.ajarangles ) then ajarangles = data.ajarangles end
		local axis
		if ( data && data.axis ) then axis = data.axis end
		local spawnpos
		if ( data && data.spawnpos ) then spawnpos = data.spawnpos end

		prop_door_rotating:SetKeyValue( "targetname", targetname )
		prop_door_rotating:SetKeyValue( "hardware", hardware )
		prop_door_rotating:SetKeyValue( "distance", distance )
		prop_door_rotating:SetKeyValue( "speed", speed )
		prop_door_rotating:SetKeyValue( "returndelay", returndelay )
		prop_door_rotating:SetKeyValue( "spawnflags", spawnflags )
		if ( ajarangles ) then prop_door_rotating:SetKeyValue( "ajarangles", ajarangles ) end
		if ( axis ) then prop_door_rotating:SetKeyValue( "axis", axis ) end
		if ( spawnpos ) then prop_door_rotating:SetKeyValue( "spawnpos", spawnpos ) end

		prop_door_rotating:Spawn()
		prop_door_rotating:Activate()

		prop_door_rotating:SetSkin( skin )

		numpad.OnDown( ply, keyOpen, "prop_door_open", prop_door_rotating )
		numpad.OnDown( ply, keyClose, "prop_door_close", prop_door_rotating )
		numpad.OnDown( ply, keyLock, "prop_door_lock", prop_door_rotating )
		numpad.OnDown( ply, keyUnlock, "prop_door_unlock", prop_door_rotating )

		table.Merge( prop_door_rotating:GetTable(), {
			ply = ply,
			keyOpen = keyOpen,
			keyClose = keyClose,
			keyLock = keyLock,
			keyUnlock = keyUnlock,

			rb655_dupe_data = {
				spawnflags = spawnflags,
				ajarangles = ajarangles,
				skin = skin,
				axis = axis,
				initialAngles = ang,
				spawnpos = spawnpos,
				hardware = hardware,
				distance = distance,
				speed = speed,
				returndelay = returndelay,
				targetname = targetname,

				--[[slavename = slavename,
				state = 0,
				opendir = opendir,
				forceclosed = forceclosed,

				soundopenoverride = soundopenoverride,
				soundcloseoverride = soundcloseoverride,
				soundmoveoverride = soundmoveoverride,
				soundlockedoverride = soundlockedoverride,
				soundunlockedoverride = soundunlockedoverride,]]

			}
		} )

		if ( IsValid( ply ) ) then
			ply:AddCount( "prop_doors", prop_door_rotating )
			ply:AddCleanup( "prop_doors", prop_door_rotating )
		end

		if ( Wire_CreateOutputs ) then
			--prop_door_rotating.Outputs = Wire_CreateOutputs( prop_door_rotating, { "OnClosed", "OnOpened", "OnLocked", "OnUnlocked" } )
			prop_door_rotating.Inputs = Wire_CreateInputs( prop_door_rotating, { "Open", "Lock" } )

			function prop_door_rotating:TriggerInput( name, value )
				if ( name == "Open" ) then self:Fire( value != 0 && "Open" || "Close" ) end
				if ( name == "Lock" ) then self:Fire( value != 0 && "Lock" || "Unlock" ) end
			end
		end

		DoPropSpawnedEffect( prop_door_rotating )

		return prop_door_rotating
	end
	duplicator.RegisterEntityClass( "prop_door_rotating", MakeDoorRotating, "model", "pos", "ang", "skin", "keyOpen", "keyClose", "keyLock", "keyUnlock", "rHardware", "rDistance", "rSpeed", "auto_close_delay", "targetname", "rb655_dupe_data" )

	function MakeDoorDynamic( ply, model, pos, ang, keyOpen, keyClose, keyLock, keyUnlock, auto_close_delay, skin )
		if ( IsValid( ply ) && !ply:CheckLimit( "prop_doors" ) ) then return false end

		local prop_door_dynamic = ents.Create( "prop_door_dynamic" )
		if ( !IsValid( prop_door_dynamic ) ) then return false end

		prop_door_dynamic:SetModel( model )
		prop_door_dynamic:SetPos( pos )
		prop_door_dynamic:SetAngles( ang )

		prop_door_dynamic:Spawn()
		prop_door_dynamic:Activate()

		prop_door_dynamic:SetSkin( skin || 0 )
		prop_door_dynamic:SetCloseDelay( auto_close_delay )

		numpad.OnDown( ply, keyOpen, "prop_door_open", prop_door_dynamic )
		numpad.OnDown( ply, keyClose, "prop_door_close", prop_door_dynamic )
		numpad.OnDown( ply, keyLock, "prop_door_lock", prop_door_dynamic )
		numpad.OnDown( ply, keyUnlock, "prop_door_unlock", prop_door_dynamic )

		--[[table.Merge( prop_door_dynamic:GetTable(), {
			ply = ply,
			keyOpen = keyOpen,
			keyClose = keyClose,
			keyLock = keyLock,
			keyUnlock = keyUnlock,
			auto_close_delay = auto_close_delay,
			skin = skin
		} )]]

		-- This shit is needed because we are using a proxy entity for dynamic doors
		table.Merge( prop_door_dynamic.door:GetTable(), {
			ply = ply,
			keyOpen = keyOpen,
			keyClose = keyClose,
			keyLock = keyLock,
			keyUnlock = keyUnlock,
			auto_close_delay = auto_close_delay,
			skin = skin
		} )

		if ( IsValid( ply ) ) then
			ply:AddCount( "prop_doors", prop_door_dynamic )
			ply:AddCleanup( "prop_doors", prop_door_dynamic )
		end

		DoPropSpawnedEffect( prop_door_dynamic )

		if ( Wire_CreateOutputs ) then
			local door = prop_door_dynamic.door
			--door.Outputs = Wire_CreateOutputs( door, { "OnClosed", "OnOpened", "OnLocked", "OnUnlocked" } )
			door.Inputs = Wire_CreateInputs( door, { "Open", "Lock" } )

			function door:TriggerInput( name, value ) if ( self.RB655_Prop_Door_Dynamic ) then return self.RB655_Prop_Door_Dynamic:TriggerInput( name, value ) end end
			function prop_door_dynamic:TriggerInput( name, value )
				if ( name == "Open" ) then self:Fire( value != 0 && "Open" || "Close" ) end
				if ( name == "Lock" ) then self:Fire( value != 0 && "Lock" || "Unlock" ) end
			end
		end

		return prop_door_dynamic
	end
	duplicator.RegisterEntityClass( "prop_door_dynamic", MakeDoorDynamic, "model", "pos", "ang", "keyOpen", "keyClose", "keyLock", "keyUnlock", "auto_close_delay", "skin" )

end

function TOOL:LeftClick( trace )
	if ( trace.HitSky || !trace.HitPos ) then return false end
	if ( IsValid( trace.Entity ) ) then return false end
	if ( CLIENT ) then return true end

	local ply = self:GetOwner()

	local ang = Angle( 0, ply:GetAngles().y, 0 )

	local auto_close_delay = self:GetClientNumber( "auto_close_delay" )
	if ( self:GetClientNumber( "auto_close" ) <= 0 ) then auto_close_delay = -1 end

	local mdl = self:GetClientInfo( "model" )
	local kO = self:GetClientNumber( "key_open" )
	local kC = self:GetClientNumber( "key_close" )
	local kL = self:GetClientNumber( "key_lock" )
	local kU = self:GetClientNumber( "key_unlock" )

	local doorSkin = self:GetClientNumber( "skin" ) - 1

	local rH = math.Clamp( self:GetClientNumber( "r_hardware" ), 1, 3 )
	local rD = self:GetClientNumber( "r_distance" )
	local rS = self:GetClientNumber( "r_speed" )

	local prop_door
	local prop_door2
	if ( self:GetClientNumber( "type" ) == 0 ) then
		local pos, angD = self:FixDynamicPos( mdl, trace.HitPos, ang )

		prop_door = MakeDoorDynamic( ply, mdl, pos, angD, kO, kC, kL, kU, auto_close_delay, doorSkin )

		-- print( prop_door.door:OBBMins().z )
		--[[ This is HORRIBLE
		prop_door.door:SetPos( pos - Vector( 0, 0, prop_door.door:OBBMins().z ) )
		prop_door.door:Fire( "SetAnimation", "idle_closed" )
		prop_door.door:Fire( "SetAnimation", "idleclosed" )
		prop_door.door:Fire( "SetAnimation", "idle" )]]
	else
		prop_door = MakeDoorRotating( ply, mdl, trace.HitPos, ang, doorSkin, kO, kC, kL, kU, rH, rD, rS, auto_close_delay, "rb655_door_" .. gDoorUniqueID )
		self:FixRotatingPos( prop_door )

		if ( self:GetClientNumber( "r_double" ) == 1 ) then
			ang:RotateAroundAxis( Vector( 0, 0, 1 ), 180 )

			prop_door2 = MakeDoorRotating( ply, mdl, trace.HitPos, ang, doorSkin, kO, kC, kL, kU, rH, rD, rS, auto_close_delay, "rb655_door_" .. gDoorUniqueID )
			self:FixRotatingPos( prop_door2 )
		end

		gDoorUniqueID = gDoorUniqueID + 1
	end

	undo.Create( "prop_door" )
		undo.AddEntity( prop_door )
		undo.AddEntity( prop_door2 )
		undo.SetPlayer( ply )
	undo.Finish()

	return true
end

function TOOL:UpdateGhostEntity( ent, ply )
	if ( !IsValid( ent ) || !IsValid( ply ) ) then return end

	local trace = ply:GetEyeTrace()

	if ( IsValid( trace.Entity ) || !trace.Hit ) then ent:SetNoDraw( true ) return end

	ent:SetPos( trace.HitPos )
	ent:SetAngles( Angle( 0, ply:GetAngles().y, 0 ) )
	ent:SetSkin( self:GetClientNumber( "skin" ) - 1 )

	ent:SetBodygroup( 1, self:GetClientNumber( "r_hardware" ) )

	if ( self:GetClientNumber( "type" ) == 0 ) then
		local pos, angD = self:FixDynamicPos( ent:GetModel(), ent:GetPos(), ent:GetAngles(), ent:OBBMins().z )

		ent:SetPos( pos )
		ent:SetAngles( angD )
	else
		self:FixRotatingPos( ent )
	end

	ent:SetNoDraw( false )
end

function TOOL:MakeGhostEntity( model, pos, angle )
	util.PrecacheModel( model )

	if ( SERVER && !game.SinglePlayer() ) then return end -- We do ghosting serverside in single player
	if ( CLIENT && game.SinglePlayer() ) then return end -- It's done clientside in multiplayer

	self:ReleaseGhostEntity() -- Release the old ghost entity

	--if ( !util.IsValidProp( model ) ) then return end -- Don't allow ragdolls/effects to be ghosts

	if ( CLIENT ) then self.GhostEntity = ents.CreateClientProp( model )
	else self.GhostEntity = ents.Create( "prop_dynamic" ) end

	if ( !IsValid( self.GhostEntity ) ) then self.GhostEntity = nil return end -- If there's too many entities we might not spawn..

	self.GhostEntity:SetModel( model )
	self.GhostEntity:SetPos( pos )
	self.GhostEntity:SetAngles( angle )
	self.GhostEntity:Spawn()

	self.GhostEntity:SetSolid( SOLID_VPHYSICS )
	self.GhostEntity:SetMoveType( MOVETYPE_NONE )
	self.GhostEntity:SetNotSolid( true )
	self.GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.GhostEntity:SetColor( Color( 255, 255, 255, 150 ) )
end

local OldMDL = GetConVarString( "prop_door_model" )
function TOOL:Think()
	if ( CLIENT && OldMDL != GetConVarString( "prop_door_model" ) ) then
		OldMDL = GetConVarString( "prop_door_model" )
		if ( LocalPlayer():GetTool() && LocalPlayer():GetTool( "prop_door" ) ) then LocalPlayer():GetTool():UpdateControlPanel() end
	end

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != self:GetClientInfo( "model" ) ) then
		self:MakeGhostEntity( self:GetClientInfo( "model" ), Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end
	self:UpdateGhostEntity( self.GhostEntity, self:GetOwner() )
end

--[[
	Types
	0 - Dynamic door
	1 - Normal door
	2 - Normal slim door
	3 - Normal door but with a 3rd option for door handle
]]

list.Set( "DoorModels", "models/props_c17/door01_left.mdl", { prop_door_type = 1 } )
list.Set( "DoorModels", "models/props_c17/door02_double.mdl", { prop_door_type = 2 } )
list.Set( "DoorModels", "models/props_doors/door03_slotted_left.mdl", { prop_door_type = 1 } )

list.Set( "DoorModels", "models/props_combine/combine_door01.mdl", { prop_door_type = 0 } )
list.Set( "DoorModels", "models/combine_gate_vehicle.mdl", { prop_door_type = 0 } )
list.Set( "DoorModels", "models/combine_gate_citizen.mdl", { prop_door_type = 0 } )

list.Set( "DoorModels", "models/props_lab/elevatordoor.mdl", { prop_door_type = 0 } )
list.Set( "DoorModels", "models/props_doors/doorklab01.mdl", { prop_door_type = 0 } )

if ( IsMounted( "episodic" ) ) then list.Set( "DoorModels", "models/props_c17/door03_left.mdl", { prop_door_type = 3 } ) end
if ( IsMounted( "zps" ) ) then list.Set( "DoorModels", "models/props_corpsington/doors/swingdoor01.mdl", { prop_door_type = 1 } ) end
--if ( IsMounted( "portal" ) ) then list.Set( "DoorModels", "models/props/round_elevator_doors.mdl", { prop_door_type = 0 } ) end -- Fucked up angles & collisions

if ( IsMounted( "portal2" ) ) then
	list.Set( "DoorModels", "models/props/portal_door_combined.mdl", { prop_door_type = 0 } )
end

if ( IsMounted( "left4dead2" ) ) then
	list.Set( "DoorModels", "models/props_doors/doormainmetal01.mdl", { prop_door_type = 7 } )
	list.Set( "DoorModels", "models/props_doors/doormainmetalsmall01.mdl", { prop_door_type = 1 } )

	list.Set( "DoorModels", "models/props_downtown/door_interior_112_01.mdl", { prop_door_type = 1 } )
	list.Set( "DoorModels", "models/props_downtown/door_interior_128_01.mdl", { prop_door_type = 1 } )
	list.Set( "DoorModels", "models/props_doors/doorfreezer01.mdl", { prop_door_type = 6 } )

	list.Set( "DoorModels", "models/props_doors/doormainmetalwindow01.mdl", { prop_door_type = 10 } )
	list.Set( "DoorModels", "models/props_doors/doormainmetalwindowsmall01.mdl", { prop_door_type = 1 } )

	list.Set( "DoorModels", "models/props_doors/doorglassmain01.mdl", { prop_door_type = 10 } )
	list.Set( "DoorModels", "models/props_doors/doorglassmain01_small.mdl", { prop_door_type = 10 } )

	list.Set( "DoorModels", "models/props_downtown/metal_door_112.mdl", { prop_door_type = 1 } )
	list.Set( "DoorModels", "models/props_doors/door_rotate_112.mdl", { prop_door_type = 1 } )
	list.Set( "DoorModels", "models/props_doors/door_sliding_112.mdl", { prop_door_type = 1 } )

	-- Escape doors
	list.Set( "DoorModels", "models/props_doors/checkpoint_door_-01.mdl", { prop_door_type = 4 } )
	list.Set( "DoorModels", "models/props_doors/checkpoint_door_-02.mdl", { prop_door_type = 5 } )
	list.Set( "DoorModels", "models/props_doors/checkpoint_door_01.mdl", { prop_door_type = 6 } )
	list.Set( "DoorModels", "models/props_doors/checkpoint_door_02.mdl", { prop_door_type = 5 } )

	-- Wood
	list.Set( "DoorModels", "models/props_doors/doormain01.mdl", { prop_door_type = 1 } )
	list.Set( "DoorModels", "models/props_doors/doormain01_airport.mdl", { prop_door_type = 7 } )
	list.Set( "DoorModels", "models/props_doors/doormain01_airport_small.mdl", { prop_door_type = 8 } )
	list.Set( "DoorModels", "models/props_doors/doormain01_small.mdl", { prop_door_type = 9 } )
	list.Set( "DoorModels", "models/props_doors/doormain_rural01.mdl", { prop_door_type = 9 } )
	list.Set( "DoorModels", "models/props_doors/doormain_rural01_small.mdl", { prop_door_type = 9 } )

end

if ( IsMounted( "ep2" ) ) then
	list.Set( "DoorModels", "models/props_mining/elevator01_cagedoor.mdl", { prop_door_type = 0 } )
	list.Set( "DoorModels", "models/props_mining/techgate01.mdl", { prop_door_type = 0 } )
	-- list.Set( "DoorModels", "models/props_mining/techgate01_outland03.mdl", { prop_door_type = 0 } )
	-- list.Set( "DoorModels", "models/props_silo/silo_elevator_door.mdl", { prop_door_type = 0 } ) -- No collisions
end

if ( SERVER ) then return end

TOOL.Information = { { name = "left" } }

language.Add( "tool.prop_door", "Doors" )
language.Add( "tool.prop_door.name", "Door Tool" )
language.Add( "tool.prop_door.desc", "Spawn a variety of doors" )
language.Add( "tool.prop_door.left", "Spawn a door" )

language.Add( "tool.prop_door.model", "Door Model:" )
language.Add( "tool.prop_door.key_open", "Open door" )
language.Add( "tool.prop_door.key_close", "Close Door" )
language.Add( "tool.prop_door.key_lock", "Lock Door" )
language.Add( "tool.prop_door.key_unlock", "Unlock Door" )
language.Add( "tool.prop_door.auto_close", "Auto Close" )
language.Add( "tool.prop_door.auto_close_delay", "Auto close delay:" )
language.Add( "tool.prop_door.skin", "Door skin:" )

language.Add( "tool.prop_door.specific", "Door specific options" )

language.Add( "tool.prop_door.r_double", "Make Double Doors" )
language.Add( "tool.prop_door.r_hardware", "Hardware Type" )
language.Add( "tool.prop_door.r_distance", "Rotation distance:" )
language.Add( "tool.prop_door.r_speed", "Open speed:" )

language.Add( "tool.prop_door.lever", "Lever" )
language.Add( "tool.prop_door.pushbar", "Push Bar" )
language.Add( "tool.prop_door.keypad", "Lever with Keypad" )

language.Add( "Cleanup_prop_doors", "Doors" )
language.Add( "Cleaned_prop_doors", "Cleaned up all Doors" )
language.Add( "SBoxLimit_prop_doors", "You've hit the Door limit!" )
language.Add( "Undone_prop_door", "Door undone" )

language.Add( "max_prop_doors", "Max Doors:" )

function TOOL:UpdateControlPanel( index )
	local panel = controlpanel.Get( "prop_door" )
	if ( !panel ) then Msg( "Couldn't find prop_door panel!" ) return end

	panel:ClearControls()
	self.BuildCPanel( panel )
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( panel )
	panel:AddControl( "ComboBox", { MenuButton = 1, Folder = "prop_door", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	panel:AddControl( "PropSelect", { Label = "#tool.prop_door.model", Height = 3, ConVar = "prop_door_model", Models = list.Get( "DoorModels" ) } )
	panel:AddControl( "Numpad", { Label = "#tool.prop_door.key_open", Label2 = "#tool.prop_door.key_close", Command = "prop_door_key_open", Command2 = "prop_door_key_close" } )
	panel:AddControl( "Numpad", { Label = "#tool.prop_door.key_lock", Label2 = "#tool.prop_door.key_unlock", Command = "prop_door_key_lock", Command2 = "prop_door_key_unlock" } )

	panel:AddControl( "Checkbox", { Label = "#tool.prop_door.auto_close", Command = "prop_door_auto_close" } )
	panel:AddControl( "Slider", { Label = "#tool.prop_door.auto_close_delay", Type = "Float", Min = 0, Max = 32, Command = "prop_door_auto_close_delay" } )

	local typ = GetConVarNumber( "prop_door_type" )
	local numSkins = NumModelSkins( GetConVarString( "prop_door_model" ) )

	if ( typ == 0 && numSkins <= 1 ) then return end

	panel:Help( "#tool.prop_door.specific" )

	if ( numSkins > 1 ) then
		panel:AddControl( "Slider", { Label = "#tool.prop_door.skin", Min = 1, Max = numSkins, Command = "prop_door_skin" } )
	end

	if ( typ == 0 ) then return end

	panel:AddControl( "Checkbox", { Label = "#tool.prop_door.r_double", Command = "prop_door_r_double" } )

	local r_hard = GetConVarNumber( "prop_door_r_hardware" )
	if ( ( typ != 3 && r_hard == 3 ) || ( typ == 2 && r_hard != 1 ) ) then LocalPlayer():ConCommand( "prop_door_r_hardware 1" ) end

	local r_hardware = {
		["#tool.prop_door.lever"] = { prop_door_r_hardware = "1" },
		["#tool.prop_door.pushbar"] = { prop_door_r_hardware = "2" }
	}

	if ( typ == 3 ) then r_hardware["#tool.prop_door.keypad"] = { prop_door_r_hardware = "3" } end

	if ( typ != 2 ) then
		panel:AddControl( "ListBox", { Label = "#tool.prop_door.r_hardware", Height = 68, Options = r_hardware } )
	end

	panel:AddControl( "Slider", { Label = "#tool.prop_door.r_distance", Type = "Float", Min = 72, Max = 128, Command = "prop_door_r_distance" } )
	panel:AddControl( "Slider", { Label = "#tool.prop_door.r_speed", Type = "Float", Min = 48, Max = 256, Command = "prop_door_r_speed" } )
end
