
TOOL.Category = "Half-Life 2"
TOOL.Name = "#tool.prop_thumper"

TOOL.ClientConVar["model" ] = "models/props_combine/CombineThumper002.mdl"
TOOL.ClientConVar[ "dustscale" ] = "128"
TOOL.ClientConVar[ "activate" ] = "38"
TOOL.ClientConVar[ "deactivate" ] = "39"

cleanup.Register( "prop_thumpers" )

if ( SERVER ) then
	CreateConVar( "sbox_maxprop_thumpers", 10 )

	numpad.Register( "prop_thumper_on", function( ply, prop_thumper )
		if ( !IsValid( prop_thumper ) ) then return false end
		prop_thumper:Fire( "Enable" )
	end )

	numpad.Register( "prop_thumper_off", function( ply, prop_thumper )
		if ( !IsValid( prop_thumper ) ) then return false end
		prop_thumper:Fire( "Disable" )
	end )

	function MakeThumper( ply, model, pos, ang, keyOn, keyOff, dustscale, targetname )
		if ( IsValid( ply ) && !ply:CheckLimit( "prop_thumpers" ) ) then return nil end

		local prop_thumper = ents.Create( "prop_thumper" )
		if ( !IsValid( prop_thumper ) ) then return false end

		prop_thumper:SetPos( pos )
		prop_thumper:SetAngles( ang )

		keyOn = keyOn || -1
		keyOff = keyOff || -1
		dustscale = tonumber( dustscale ) || 128

		if ( model == "models/props_combine/combinethumper001a.mdl" ) then
			local vec1 = Vector( -64, 72, 256 )
			vec1:Rotate( ang )
			local Lpos = pos + vec1

			local ladder = ents.Create("func_useableladder")
			ladder:SetPos( Lpos )
			ladder:SetAngles( ang )
			ladder:SetKeyValue( "targetname", "rb655_ThumperLadder_" .. prop_thumper:EntIndex() )
			ladder:SetKeyValue( "point0", Lpos.x .. " " .. Lpos.y .. " " .. Lpos.z )
			ladder:SetKeyValue( "point1", Lpos.x .. " " .. Lpos.y .. " " .. ( Lpos.z - 252 ) )
			ladder:Spawn()

			prop_thumper:DeleteOnRemove( ladder )
			ladder:DeleteOnRemove( prop_thumper )
		end

		if ( targetname ) then prop_thumper:SetKeyValue( "targetname", targetname ) end
		if ( dustscale ) then prop_thumper:SetKeyValue( "dustscale", math.Clamp( dustscale, 64, 1024 ) ) end
		prop_thumper:SetModel( model )
		prop_thumper:Spawn()
		prop_thumper:Activate()

		prop_thumper.NumpadOn = numpad.OnDown( ply, keyOn, "prop_thumper_on", prop_thumper )
		prop_thumper.NumpadOff = numpad.OnDown( ply, keyOff, "prop_thumper_off", prop_thumper )

		table.Merge( prop_thumper:GetTable(), {
			ply = ply,
			keyOn = keyOn,
			keyOff = keyOff,
			dustscale = dustscale,
			targetname = targetname
		} )

		if ( IsValid( ply ) ) then
			ply:AddCount( "prop_thumpers", prop_thumper )
			ply:AddCleanup( "prop_thumpers", prop_thumper )
		end

		DoPropSpawnedEffect( prop_thumper )

		if ( Wire_CreateOutputs ) then
			prop_thumper.Inputs = Wire_CreateInputs( prop_thumper, { "Turn On" } )

			function prop_thumper:TriggerInput( name, value )
				if ( name == "Turn On" ) then self:Fire( value != 0 && "Enable" || "Disable" ) end
			end
		end

		return prop_thumper
	end

	duplicator.RegisterEntityClass( "prop_thumper", MakeThumper, "model", "pos", "ang", "keyOn", "keyOff", "dustscale", "targetname" )
end

function TOOL:LeftClick( trace )
	if ( trace.HitSky || !trace.HitPos || trace.HitNormal.z < 0.98 ) then return false end
	if ( IsValid( trace.Entity ) && ( trace.Entity:GetClass() == "prop_thumper" || trace.Entity:IsPlayer() || trace.Entity:IsNPC() ) ) then return false end
	if ( CLIENT ) then return true end

	local ply = self:GetOwner()

	local ang = trace.HitNormal:Angle()
	ang.pitch = ang.pitch - 270

	if ( trace.HitNormal.z > 0.9999 ) then ang.y = ply:GetAngles().y + 90 end

	local prop_thumper = MakeThumper( ply, self:GetClientInfo( "model" ),
		trace.HitPos, ang,
		self:GetClientNumber( "activate" ),
		self:GetClientNumber( "deactivate" ),
		self:GetClientNumber( "dustscale" ),
		self:GetClientNumber( "distance" )
	)

	undo.Create( "prop_thumper" )
		undo.AddEntity( prop_thumper )
		undo.SetPlayer( ply )
	undo.Finish()

	return true
end

function TOOL:UpdateGhostEntity( ent, ply )
	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()

	if ( !trace.Hit || trace.HitNormal.z < 0.98 || trace.Entity && ( trace.Entity:GetClass() == "prop_thumper" || trace.Entity:IsPlayer() || trace.Entity:IsNPC() ) ) then
		ent:SetNoDraw( true )
		return
	end

	local ang = trace.HitNormal:Angle()
	ang.pitch = ang.pitch - 270

	if ( trace.HitNormal.z > 0.9999 ) then ang.y = ply:GetAngles().y + 90 end

	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos - trace.HitNormal * min.z )

	ent:SetAngles( ang )
	ent:SetNoDraw( false )
end

function TOOL:Think()
	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != self:GetClientInfo( "model" ) ) then
		self:MakeGhostEntity( self:GetClientInfo( "model" ), Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end
	self:UpdateGhostEntity( self.GhostEntity, self:GetOwner() )
end

list.Set( "ThumperModels", "models/props_combine/CombineThumper001a.mdl", {} )
list.Set( "ThumperModels", "models/props_combine/CombineThumper002.mdl", {} )

if ( SERVER ) then return end

TOOL.Information = { { name = "left" } }

language.Add( "tool.prop_thumper", "Thumpers" )
language.Add( "tool.prop_thumper.name", "Thumper Tool" )
language.Add( "tool.prop_thumper.desc", "Spawn thumpers from Half-Life 2" )
language.Add( "tool.prop_thumper.left", "Spawn a thumper" )

language.Add( "tool.prop_thumper.model", "Thumper Model:" )
language.Add( "tool.prop_thumper.dustscale", "Thumper dust size:" )
language.Add( "tool.prop_thumper.dustscale.help", "The scale of dust produced when thumper hits ground." )
language.Add( "tool.prop_thumper.activate", "Activate Thumper" )
language.Add( "tool.prop_thumper.deactivate", "Deactivate Thumper" )

language.Add( "Cleanup_prop_thumpers", "Thumpers" )
language.Add( "Cleaned_prop_thumpers", "Cleaned up all Thumpers" )
language.Add( "SBoxLimit_prop_thumpers", "You've hit the Thumper limit!" )
language.Add( "Undone_prop_thumper", "Thumper undone" )

language.Add( "max_prop_thumpers", "Max Thumpers:" )

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( panel )
	panel:AddControl( "ComboBox", { MenuButton = 1, Folder = "prop_thumper", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	panel:AddControl( "PropSelect", { Label = "#tool.prop_thumper.model", Height = 1, ConVar = "prop_thumper_model", Models = list.Get( "ThumperModels" ) } )
	panel:AddControl( "Numpad", { Label = "#tool.prop_thumper.activate", Label2 = "#tool.prop_thumper.deactivate", Command = "prop_thumper_activate", Command2 = "prop_thumper_deactivate" } )
	panel:AddControl( "Slider", { Label = "#tool.prop_thumper.dustscale", Min = 64, Max = 1024, Command = "prop_thumper_dustscale", Help = true } )
end


TOOL.Category = "Half-Life 2"
TOOL.Name = "#tool.prop_thumper"

TOOL.ClientConVar["model" ] = "models/props_combine/CombineThumper002.mdl"
TOOL.ClientConVar[ "dustscale" ] = "128"
TOOL.ClientConVar[ "activate" ] = "38"
TOOL.ClientConVar[ "deactivate" ] = "39"

cleanup.Register( "prop_thumpers" )

if ( SERVER ) then
	CreateConVar( "sbox_maxprop_thumpers", 10 )

	numpad.Register( "prop_thumper_on", function( ply, prop_thumper )
		if ( !IsValid( prop_thumper ) ) then return false end
		prop_thumper:Fire( "Enable" )
	end )

	numpad.Register( "prop_thumper_off", function( ply, prop_thumper )
		if ( !IsValid( prop_thumper ) ) then return false end
		prop_thumper:Fire( "Disable" )
	end )

	function MakeThumper( ply, model, pos, ang, keyOn, keyOff, dustscale, targetname )
		if ( IsValid( ply ) && !ply:CheckLimit( "prop_thumpers" ) ) then return nil end

		local prop_thumper = ents.Create( "prop_thumper" )
		if ( !IsValid( prop_thumper ) ) then return false end

		prop_thumper:SetPos( pos )
		prop_thumper:SetAngles( ang )

		keyOn = keyOn || -1
		keyOff = keyOff || -1
		dustscale = tonumber( dustscale ) || 128

		if ( model == "models/props_combine/combinethumper001a.mdl" ) then
			local vec1 = Vector( -64, 72, 256 )
			vec1:Rotate( ang )
			local Lpos = pos + vec1

			local ladder = ents.Create("func_useableladder")
			ladder:SetPos( Lpos )
			ladder:SetAngles( ang )
			ladder:SetKeyValue( "targetname", "rb655_ThumperLadder_" .. prop_thumper:EntIndex() )
			ladder:SetKeyValue( "point0", Lpos.x .. " " .. Lpos.y .. " " .. Lpos.z )
			ladder:SetKeyValue( "point1", Lpos.x .. " " .. Lpos.y .. " " .. ( Lpos.z - 252 ) )
			ladder:Spawn()

			prop_thumper:DeleteOnRemove( ladder )
			ladder:DeleteOnRemove( prop_thumper )
		end

		if ( targetname ) then prop_thumper:SetKeyValue( "targetname", targetname ) end
		if ( dustscale ) then prop_thumper:SetKeyValue( "dustscale", math.Clamp( dustscale, 64, 1024 ) ) end
		prop_thumper:SetModel( model )
		prop_thumper:Spawn()
		prop_thumper:Activate()

		prop_thumper.NumpadOn = numpad.OnDown( ply, keyOn, "prop_thumper_on", prop_thumper )
		prop_thumper.NumpadOff = numpad.OnDown( ply, keyOff, "prop_thumper_off", prop_thumper )

		table.Merge( prop_thumper:GetTable(), {
			ply = ply,
			keyOn = keyOn,
			keyOff = keyOff,
			dustscale = dustscale,
			targetname = targetname
		} )

		if ( IsValid( ply ) ) then
			ply:AddCount( "prop_thumpers", prop_thumper )
			ply:AddCleanup( "prop_thumpers", prop_thumper )
		end

		DoPropSpawnedEffect( prop_thumper )

		if ( Wire_CreateOutputs ) then
			prop_thumper.Inputs = Wire_CreateInputs( prop_thumper, { "Turn On" } )

			function prop_thumper:TriggerInput( name, value )
				if ( name == "Turn On" ) then self:Fire( value != 0 && "Enable" || "Disable" ) end
			end
		end

		return prop_thumper
	end

	duplicator.RegisterEntityClass( "prop_thumper", MakeThumper, "model", "pos", "ang", "keyOn", "keyOff", "dustscale", "targetname" )
end

function TOOL:LeftClick( trace )
	if ( trace.HitSky || !trace.HitPos || trace.HitNormal.z < 0.98 ) then return false end
	if ( IsValid( trace.Entity ) && ( trace.Entity:GetClass() == "prop_thumper" || trace.Entity:IsPlayer() || trace.Entity:IsNPC() ) ) then return false end
	if ( CLIENT ) then return true end

	local ply = self:GetOwner()

	local ang = trace.HitNormal:Angle()
	ang.pitch = ang.pitch - 270

	if ( trace.HitNormal.z > 0.9999 ) then ang.y = ply:GetAngles().y + 90 end

	local prop_thumper = MakeThumper( ply, self:GetClientInfo( "model" ),
		trace.HitPos, ang,
		self:GetClientNumber( "activate" ),
		self:GetClientNumber( "deactivate" ),
		self:GetClientNumber( "dustscale" ),
		self:GetClientNumber( "distance" )
	)

	undo.Create( "prop_thumper" )
		undo.AddEntity( prop_thumper )
		undo.SetPlayer( ply )
	undo.Finish()

	return true
end

function TOOL:UpdateGhostEntity( ent, ply )
	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()

	if ( !trace.Hit || trace.HitNormal.z < 0.98 || trace.Entity && ( trace.Entity:GetClass() == "prop_thumper" || trace.Entity:IsPlayer() || trace.Entity:IsNPC() ) ) then
		ent:SetNoDraw( true )
		return
	end

	local ang = trace.HitNormal:Angle()
	ang.pitch = ang.pitch - 270

	if ( trace.HitNormal.z > 0.9999 ) then ang.y = ply:GetAngles().y + 90 end

	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos - trace.HitNormal * min.z )

	ent:SetAngles( ang )
	ent:SetNoDraw( false )
end

function TOOL:Think()
	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != self:GetClientInfo( "model" ) ) then
		self:MakeGhostEntity( self:GetClientInfo( "model" ), Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end
	self:UpdateGhostEntity( self.GhostEntity, self:GetOwner() )
end

list.Set( "ThumperModels", "models/props_combine/CombineThumper001a.mdl", {} )
list.Set( "ThumperModels", "models/props_combine/CombineThumper002.mdl", {} )

if ( SERVER ) then return end

TOOL.Information = { { name = "left" } }

language.Add( "tool.prop_thumper", "Thumpers" )
language.Add( "tool.prop_thumper.name", "Thumper Tool" )
language.Add( "tool.prop_thumper.desc", "Spawn thumpers from Half-Life 2" )
language.Add( "tool.prop_thumper.left", "Spawn a thumper" )

language.Add( "tool.prop_thumper.model", "Thumper Model:" )
language.Add( "tool.prop_thumper.dustscale", "Thumper dust size:" )
language.Add( "tool.prop_thumper.dustscale.help", "The scale of dust produced when thumper hits ground." )
language.Add( "tool.prop_thumper.activate", "Activate Thumper" )
language.Add( "tool.prop_thumper.deactivate", "Deactivate Thumper" )

language.Add( "Cleanup_prop_thumpers", "Thumpers" )
language.Add( "Cleaned_prop_thumpers", "Cleaned up all Thumpers" )
language.Add( "SBoxLimit_prop_thumpers", "You've hit the Thumper limit!" )
language.Add( "Undone_prop_thumper", "Thumper undone" )

language.Add( "max_prop_thumpers", "Max Thumpers:" )

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( panel )
	panel:AddControl( "ComboBox", { MenuButton = 1, Folder = "prop_thumper", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	panel:AddControl( "PropSelect", { Label = "#tool.prop_thumper.model", Height = 1, ConVar = "prop_thumper_model", Models = list.Get( "ThumperModels" ) } )
	panel:AddControl( "Numpad", { Label = "#tool.prop_thumper.activate", Label2 = "#tool.prop_thumper.deactivate", Command = "prop_thumper_activate", Command2 = "prop_thumper_deactivate" } )
	panel:AddControl( "Slider", { Label = "#tool.prop_thumper.dustscale", Min = 64, Max = 1024, Command = "prop_thumper_dustscale", Help = true } )
end
