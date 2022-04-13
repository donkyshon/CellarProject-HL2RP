
TOOL.Category = "Half-Life 2"
TOOL.Name = "#tool.env_headcrabcanister"

TOOL.Model = "models/props_combine/headcrabcannister01b.mdl"

TOOL.ClientConVar[ "key_fire" ] = "38"
TOOL.ClientConVar[ "key_open" ] = "39"
TOOL.ClientConVar[ "key_spawn" ] = "40"
TOOL.ClientConVar[ "fire_immediately" ] = "0"
TOOL.ClientConVar[ "headcrab" ] = "0"

TOOL.ClientConVar[ "count" ] = "6"
TOOL.ClientConVar[ "speed" ] = "3000"
TOOL.ClientConVar[ "time" ] = "5"
TOOL.ClientConVar[ "height" ] = "0"

TOOL.ClientConVar[ "damage" ] = "150"
TOOL.ClientConVar[ "radius" ] = "750"
TOOL.ClientConVar[ "duration" ] = "30"
TOOL.ClientConVar[ "smoke" ] = "0"

TOOL.ClientConVar[ "sf1" ] = "0"
TOOL.ClientConVar[ "sf2" ] = "0"
TOOL.ClientConVar[ "sf4096" ] = "0"
TOOL.ClientConVar[ "sf16384" ] = "0"
TOOL.ClientConVar[ "sf32768" ] = "0"
TOOL.ClientConVar[ "sf65536" ] = "0"
TOOL.ClientConVar[ "sf131072" ] = "0"
TOOL.ClientConVar[ "sf262144" ] = "0"
TOOL.ClientConVar[ "sf524288" ] = "0"

cleanup.Register( "env_headcrabcanisters" )

if ( SERVER ) then

	CreateConVar( "sbox_maxenv_headcrabcanisters", 4 )

	numpad.Register( "env_headcrabcanister_fire", function( ply, env_headcrabcanister )
		if ( !IsValid( env_headcrabcanister ) ) then return false end
		env_headcrabcanister:Fire( "FireCanister" )
	end )
	numpad.Register( "env_headcrabcanister_open", function( ply, env_headcrabcanister )
		if ( !IsValid( env_headcrabcanister ) ) then return false end
		env_headcrabcanister:Fire( "OpenCanister" )
	end )
	numpad.Register( "env_headcrabcanister_spawn", function( ply, env_headcrabcanister )
		if ( !IsValid( env_headcrabcanister ) ) then return false end
		env_headcrabcanister:Fire( "SpawnHeadcrabs" )
	end )

	function MakeHeadcrabCanister( ply, model, pos, ang, keyFire, keyOpen, keySpawn, fire_immediately, headcrab, count, speed, time, height, damage, radius, duration, spawnflags, smoke )
		if ( IsValid( ply ) && !ply:CheckLimit( "env_headcrabcanisters" ) ) then return false end

		if ( tobool( smoke ) ) then duration = -1 end

		fire_immediately = fire_immediately or false
		headcrab = headcrab or 0
		count = count or 6
		speed = speed or 3000
		time = time or 5
		height = height or 0
		damage = damage or 150
		radius = radius or 750
		duration = duration or 30
		spawnflags = spawnflags or 0

		keyOpen = keyOpen or -1
		keyFire = keyFire or -1
		keySpawn = keySpawn or -1

		if ( !game.SinglePlayer() ) then
			headcrab = math.Clamp( headcrab, 0, 2 )
			count = math.Clamp( count, 0, 10 )
			time = math.Clamp( time, 0, 30 )
			height = math.Clamp( height, 0, 10240 )
			damage = math.Clamp( damage, 0, 256 )
			radius = math.Clamp( radius, 0, 1024 )
			duration = math.Clamp( duration, 0, 90 )
		end

		local env_headcrabcanister = ents.Create( "env_headcrabcanister" )
		if ( !IsValid( env_headcrabcanister ) ) then return false end
		env_headcrabcanister:SetPos( pos )
		env_headcrabcanister:SetAngles( ang )
		env_headcrabcanister:SetKeyValue( "HeadcrabType", headcrab )
		env_headcrabcanister:SetKeyValue( "HeadcrabCount", count )
		env_headcrabcanister:SetKeyValue( "FlightSpeed", speed )
		env_headcrabcanister:SetKeyValue( "FlightTime", time )
		env_headcrabcanister:SetKeyValue( "StartingHeight", height )
		env_headcrabcanister:SetKeyValue( "Damage", damage )
		env_headcrabcanister:SetKeyValue( "DamageRadius", radius )
		env_headcrabcanister:SetKeyValue( "SmokeLifetime", duration )
		env_headcrabcanister:SetKeyValue( "spawnflags", spawnflags )
		env_headcrabcanister:Spawn()
		env_headcrabcanister:Activate()

		env_headcrabcanister.NumpadFire = numpad.OnDown( ply, keyFire, "env_headcrabcanister_fire", env_headcrabcanister )
		env_headcrabcanister.NumpadOpen = numpad.OnDown( ply, keyOpen, "env_headcrabcanister_open", env_headcrabcanister )
		env_headcrabcanister.NumpadSpawn = numpad.OnDown( ply, keySpawn, "env_headcrabcanister_spawn", env_headcrabcanister )

		if ( tobool( fire_immediately ) ) then env_headcrabcanister:Fire( "FireCanister" ) end

		table.Merge( env_headcrabcanister:GetTable(), {
			ply = ply,
			keyFire = keyFire,
			keyOpen = keyOpen,
			keySpawn = keySpawn,
			fire_immediately = fire_immediately,
			headcrab = headcrab,
			count = count,
			speed = speed,
			time = time,
			height = height,
			damage = damage,
			radius = radius,
			duration = duration,
			spawnflags = spawnflags,
			smoke = smoke
		} )

		if ( IsValid( ply ) ) then
			ply:AddCount( "env_headcrabcanisters", env_headcrabcanister )
			ply:AddCleanup( "env_headcrabcanisters", env_headcrabcanister )
		end

		DoPropSpawnedEffect( env_headcrabcanister )

		if ( Wire_CreateOutputs ) then
			env_headcrabcanister.Inputs = Wire_CreateInputs( env_headcrabcanister, { "Open", "Spawn" } )

			function env_headcrabcanister:TriggerInput( name, value )
				if ( name == "Open" && value > 0 ) then self:Fire( "OpenCanister" ) end
				if ( name == "Spawn" && value > 0 ) then self:Fire( "SpawnHeadcrabs" ) end
			end
		end

		return env_headcrabcanister
	end

	duplicator.RegisterEntityClass( "env_headcrabcanister", MakeHeadcrabCanister, "model", "pos", "ang", "keyFire", "keyOpen", "keySpawn", "fire_immediately", "headcrab", "count", "speed", "time", "height", "damage", "radius", "duration", "spawnflags", "smoke" )

end

function TOOL:IntrnlGetSF( str )
	return math.Clamp( self:GetClientNumber( str ), 0, 1 )
end

function TOOL:LeftClick( trace )

	if ( trace.HitSky or !trace.HitPos or trace.HitNormal.z < 0 ) then return false end
	if ( IsValid( trace.Entity ) and ( trace.Entity:GetClass() == "env_headcrabcanister" or trace.Entity:IsPlayer() or trace.Entity:IsNPC() ) ) then return false end
	if ( CLIENT ) then return true end

	local ply = self:GetOwner()

	local spawnflags = 0
	spawnflags = self:IntrnlGetSF( "sf1" ) + self:IntrnlGetSF( "sf2" ) * 2 + self:IntrnlGetSF( "sf4096" ) * 4096 + self:IntrnlGetSF( "sf16384" ) * 16384
	spawnflags = spawnflags + self:IntrnlGetSF( "sf32768" ) * 32768 + self:IntrnlGetSF( "sf65536" ) * 65536 + self:IntrnlGetSF( "sf131072" ) * 131072
	spawnflags = spawnflags + self:IntrnlGetSF( "sf262144" ) * 262144 + self:IntrnlGetSF( "sf524288" ) * 524288

	local ang = Angle( math.sin( CurTime() ) * 16 - 55, trace.HitNormal:Angle().y, 0 )
	if ( trace.HitNormal.z > 0.9999 ) then ang.y = ply:GetAngles().y end

	local env_headcrabcanister = MakeHeadcrabCanister(
		ply,
		self.Model,
		trace.HitPos,
		ang,
		self:GetClientNumber( "key_fire" ),
		self:GetClientNumber( "key_open" ),
		self:GetClientNumber( "key_spawn" ),
		self:GetClientNumber( "fire_immediately" ),
		self:GetClientNumber( "headcrab" ),
		self:GetClientNumber( "count" ),
		self:GetClientNumber( "speed" ),
		self:GetClientNumber( "time" ),
		self:GetClientNumber( "height" ),
		self:GetClientNumber( "damage" ),
		self:GetClientNumber( "radius" ),
		self:GetClientNumber( "duration" ),
		spawnflags,
		self:GetClientNumber( "smoke" )
	 )

	undo.Create( "env_headcrabcanister" )
		undo.AddEntity( env_headcrabcanister )
		undo.SetPlayer( ply )
	undo.Finish()

	return true

end

function TOOL:UpdateGhostEntity( ent, ply )
	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()

	if ( !trace.Hit || trace.HitNormal.z < 0 ) then ent:SetNoDraw( true ) return end
	if ( IsValid( trace.Entity ) && ( trace.Entity:GetClass() == "env_headcrabcanister" || trace.Entity:IsPlayer() || trace.Entity:IsNPC() ) ) then ent:SetNoDraw( true ) return end

	local min = ent:OBBMins()
	local ang = Angle( math.sin( CurTime() ) * 16 - 55, trace.HitNormal:Angle().y, 0 )
	if ( trace.HitNormal.z > 0.9999 ) then
		ang.y = ply:GetAngles().y
		ent:SetPos( trace.HitPos - trace.HitNormal * min.z - Vector( 0, 0, 16 ) )
	else
		ent:SetPos( trace.HitPos - trace.HitNormal )
	end

	ent:SetAngles( ang )
	ent:SetNoDraw( false )
end

function TOOL:Think()
	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != self.Model ) then
		self:MakeGhostEntity( self.Model, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end

	self:UpdateGhostEntity( self.GhostEntity, self:GetOwner() )
end


list.Set( "HeadcrabModels", "#npc_headcrab", { env_headcrabcanister_headcrab = "0" } )
list.Set( "HeadcrabModels", "#npc_headcrab_fast", { env_headcrabcanister_headcrab = "1" } )
list.Set( "HeadcrabModels", "#npc_headcrab_poison", { env_headcrabcanister_headcrab = "2" } )

if ( SERVER ) then return end

TOOL.Information = { { name = "left" } }

language.Add( "tool.env_headcrabcanister", "Headcrab Canisters" )
language.Add( "tool.env_headcrabcanister.name", "Headcrab Canister Tool" )
language.Add( "tool.env_headcrabcanister.desc", "Spawn headcrab canisters" )
language.Add( "tool.env_headcrabcanister.left", "Spawn a headcrab canister" )

language.Add( "tool.env_headcrabcanister.fire", "Fire Headcrab Canister" )
language.Add( "tool.env_headcrabcanister.fire_immediately", "Fire on spawn" )

language.Add( "tool.env_headcrabcanister.open", "Open The Canister" )
language.Add( "tool.env_headcrabcanister.spawn", "Spawn headcrabs" )

language.Add( "tool.env_headcrabcanister.headcrab", "Headcrab Type" )
language.Add( "tool.env_headcrabcanister.count", "Headcrab count:" )
language.Add( "tool.env_headcrabcanister.speed", "Flight speed:" )
language.Add( "tool.env_headcrabcanister.time", "Flight time:" )
language.Add( "tool.env_headcrabcanister.height", "Starting height:" )
language.Add( "tool.env_headcrabcanister.damage", "Impact damage:" )
language.Add( "tool.env_headcrabcanister.radius", "Damage radius:" )
language.Add( "tool.env_headcrabcanister.duration", "Smoke duration:" )
language.Add( "tool.env_headcrabcanister.smoke", "Always smoke" )

language.Add( "tool.env_headcrabcanister.sf1", "No impact sound" )
language.Add( "tool.env_headcrabcanister.sf2", "No launch sound" )
language.Add( "tool.env_headcrabcanister.sf4096", "Start impacted" )
language.Add( "tool.env_headcrabcanister.sf16384", "Wait for input to open" )
language.Add( "tool.env_headcrabcanister.sf32768", "Wait for input to spawn headcrabs" )
language.Add( "tool.env_headcrabcanister.sf65536", "No smoke" )
language.Add( "tool.env_headcrabcanister.sf131072", "No shake" )
language.Add( "tool.env_headcrabcanister.sf262144", "Remove on impact" )
language.Add( "tool.env_headcrabcanister.sf524288", "No impact effects" )

language.Add( "Cleanup_env_headcrabcanisters", "Headcrab Canisters" )
language.Add( "Cleaned_env_headcrabcanisters", "Cleaned up all Headcrab Canisters" )
language.Add( "SBoxLimit_env_headcrabcanisters", "You've hit the Headcrab Canisters limit!" )
language.Add( "Undone_env_headcrabcanister", "Headcrab Canister undone" )

language.Add( "max_env_headcrabcanisters", "Max Headcrab Canisters:" )

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( panel )
	panel:AddControl( "ComboBox", { MenuButton = 1, Folder = "env_headcrabcanister", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	panel:AddControl( "Numpad", { Label = "#tool.env_headcrabcanister.fire", Command = "env_headcrabcanister_key_fire" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.fire_immediately", Command = "env_headcrabcanister_fire_immediately" } )

	panel:AddControl( "Numpad", { Label = "#tool.env_headcrabcanister.open", Command = "env_headcrabcanister_key_open", Label2 = "#tool.env_headcrabcanister.spawn", Command2 = "env_headcrabcanister_key_spawn" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf16384", Command = "env_headcrabcanister_sf16384" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf32768", Command = "env_headcrabcanister_sf32768" } )

	panel:AddControl( "ListBox", { Label = "#tool.env_headcrabcanister.headcrab", Height = 68, Options = list.Get( "HeadcrabModels" ) } )

	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.count", Max = 10, Command = "env_headcrabcanister_count" } )

	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.speed", Type = "Float", Min = 1, Max = 8192, Command = "env_headcrabcanister_speed" } )
	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.time", Type = "Float", Max = 30, Command = "env_headcrabcanister_time" } )

	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.height", Type = "Float", Max = 10240, Command = "env_headcrabcanister_height" } )

	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.damage", Type = "Float", Max = 256, Command = "env_headcrabcanister_damage" } )
	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.radius", Type = "Float", Max = 1024, Command = "env_headcrabcanister_radius" } )

	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.duration", Type = "Float", Max = 90, Command = "env_headcrabcanister_duration" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.smoke", Command = "env_headcrabcanister_smoke" } )

	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf2", Command = "env_headcrabcanister_sf2" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf1", Command = "env_headcrabcanister_sf1" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf65536", Command = "env_headcrabcanister_sf65536" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf131072", Command = "env_headcrabcanister_sf131072" } )

	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf524288", Command = "env_headcrabcanister_sf524288" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf4096", Command = "env_headcrabcanister_sf4096" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf262144", Command = "env_headcrabcanister_sf262144" } )
end


TOOL.Category = "Half-Life 2"
TOOL.Name = "#tool.env_headcrabcanister"

TOOL.Model = "models/props_combine/headcrabcannister01b.mdl"

TOOL.ClientConVar[ "key_fire" ] = "38"
TOOL.ClientConVar[ "key_open" ] = "39"
TOOL.ClientConVar[ "key_spawn" ] = "40"
TOOL.ClientConVar[ "fire_immediately" ] = "0"
TOOL.ClientConVar[ "headcrab" ] = "0"

TOOL.ClientConVar[ "count" ] = "6"
TOOL.ClientConVar[ "speed" ] = "3000"
TOOL.ClientConVar[ "time" ] = "5"
TOOL.ClientConVar[ "height" ] = "0"

TOOL.ClientConVar[ "damage" ] = "150"
TOOL.ClientConVar[ "radius" ] = "750"
TOOL.ClientConVar[ "duration" ] = "30"
TOOL.ClientConVar[ "smoke" ] = "0"

TOOL.ClientConVar[ "sf1" ] = "0"
TOOL.ClientConVar[ "sf2" ] = "0"
TOOL.ClientConVar[ "sf4096" ] = "0"
TOOL.ClientConVar[ "sf16384" ] = "0"
TOOL.ClientConVar[ "sf32768" ] = "0"
TOOL.ClientConVar[ "sf65536" ] = "0"
TOOL.ClientConVar[ "sf131072" ] = "0"
TOOL.ClientConVar[ "sf262144" ] = "0"
TOOL.ClientConVar[ "sf524288" ] = "0"

cleanup.Register( "env_headcrabcanisters" )

if ( SERVER ) then

	CreateConVar( "sbox_maxenv_headcrabcanisters", 4 )

	numpad.Register( "env_headcrabcanister_fire", function( ply, env_headcrabcanister )
		if ( !IsValid( env_headcrabcanister ) ) then return false end
		env_headcrabcanister:Fire( "FireCanister" )
	end )
	numpad.Register( "env_headcrabcanister_open", function( ply, env_headcrabcanister )
		if ( !IsValid( env_headcrabcanister ) ) then return false end
		env_headcrabcanister:Fire( "OpenCanister" )
	end )
	numpad.Register( "env_headcrabcanister_spawn", function( ply, env_headcrabcanister )
		if ( !IsValid( env_headcrabcanister ) ) then return false end
		env_headcrabcanister:Fire( "SpawnHeadcrabs" )
	end )

	function MakeHeadcrabCanister( ply, model, pos, ang, keyFire, keyOpen, keySpawn, fire_immediately, headcrab, count, speed, time, height, damage, radius, duration, spawnflags, smoke )
		if ( IsValid( ply ) && !ply:CheckLimit( "env_headcrabcanisters" ) ) then return false end

		if ( tobool( smoke ) ) then duration = -1 end

		fire_immediately = fire_immediately or false
		headcrab = headcrab or 0
		count = count or 6
		speed = speed or 3000
		time = time or 5
		height = height or 0
		damage = damage or 150
		radius = radius or 750
		duration = duration or 30
		spawnflags = spawnflags or 0

		keyOpen = keyOpen or -1
		keyFire = keyFire or -1
		keySpawn = keySpawn or -1

		if ( !game.SinglePlayer() ) then
			headcrab = math.Clamp( headcrab, 0, 2 )
			count = math.Clamp( count, 0, 10 )
			time = math.Clamp( time, 0, 30 )
			height = math.Clamp( height, 0, 10240 )
			damage = math.Clamp( damage, 0, 256 )
			radius = math.Clamp( radius, 0, 1024 )
			duration = math.Clamp( duration, 0, 90 )
		end

		local env_headcrabcanister = ents.Create( "env_headcrabcanister" )
		if ( !IsValid( env_headcrabcanister ) ) then return false end
		env_headcrabcanister:SetPos( pos )
		env_headcrabcanister:SetAngles( ang )
		env_headcrabcanister:SetKeyValue( "HeadcrabType", headcrab )
		env_headcrabcanister:SetKeyValue( "HeadcrabCount", count )
		env_headcrabcanister:SetKeyValue( "FlightSpeed", speed )
		env_headcrabcanister:SetKeyValue( "FlightTime", time )
		env_headcrabcanister:SetKeyValue( "StartingHeight", height )
		env_headcrabcanister:SetKeyValue( "Damage", damage )
		env_headcrabcanister:SetKeyValue( "DamageRadius", radius )
		env_headcrabcanister:SetKeyValue( "SmokeLifetime", duration )
		env_headcrabcanister:SetKeyValue( "spawnflags", spawnflags )
		env_headcrabcanister:Spawn()
		env_headcrabcanister:Activate()

		env_headcrabcanister.NumpadFire = numpad.OnDown( ply, keyFire, "env_headcrabcanister_fire", env_headcrabcanister )
		env_headcrabcanister.NumpadOpen = numpad.OnDown( ply, keyOpen, "env_headcrabcanister_open", env_headcrabcanister )
		env_headcrabcanister.NumpadSpawn = numpad.OnDown( ply, keySpawn, "env_headcrabcanister_spawn", env_headcrabcanister )

		if ( tobool( fire_immediately ) ) then env_headcrabcanister:Fire( "FireCanister" ) end

		table.Merge( env_headcrabcanister:GetTable(), {
			ply = ply,
			keyFire = keyFire,
			keyOpen = keyOpen,
			keySpawn = keySpawn,
			fire_immediately = fire_immediately,
			headcrab = headcrab,
			count = count,
			speed = speed,
			time = time,
			height = height,
			damage = damage,
			radius = radius,
			duration = duration,
			spawnflags = spawnflags,
			smoke = smoke
		} )

		if ( IsValid( ply ) ) then
			ply:AddCount( "env_headcrabcanisters", env_headcrabcanister )
			ply:AddCleanup( "env_headcrabcanisters", env_headcrabcanister )
		end

		DoPropSpawnedEffect( env_headcrabcanister )

		if ( Wire_CreateOutputs ) then
			env_headcrabcanister.Inputs = Wire_CreateInputs( env_headcrabcanister, { "Open", "Spawn" } )

			function env_headcrabcanister:TriggerInput( name, value )
				if ( name == "Open" && value > 0 ) then self:Fire( "OpenCanister" ) end
				if ( name == "Spawn" && value > 0 ) then self:Fire( "SpawnHeadcrabs" ) end
			end
		end

		return env_headcrabcanister
	end

	duplicator.RegisterEntityClass( "env_headcrabcanister", MakeHeadcrabCanister, "model", "pos", "ang", "keyFire", "keyOpen", "keySpawn", "fire_immediately", "headcrab", "count", "speed", "time", "height", "damage", "radius", "duration", "spawnflags", "smoke" )

end

function TOOL:IntrnlGetSF( str )
	return math.Clamp( self:GetClientNumber( str ), 0, 1 )
end

function TOOL:LeftClick( trace )

	if ( trace.HitSky or !trace.HitPos or trace.HitNormal.z < 0 ) then return false end
	if ( IsValid( trace.Entity ) and ( trace.Entity:GetClass() == "env_headcrabcanister" or trace.Entity:IsPlayer() or trace.Entity:IsNPC() ) ) then return false end
	if ( CLIENT ) then return true end

	local ply = self:GetOwner()

	local spawnflags = 0
	spawnflags = self:IntrnlGetSF( "sf1" ) + self:IntrnlGetSF( "sf2" ) * 2 + self:IntrnlGetSF( "sf4096" ) * 4096 + self:IntrnlGetSF( "sf16384" ) * 16384
	spawnflags = spawnflags + self:IntrnlGetSF( "sf32768" ) * 32768 + self:IntrnlGetSF( "sf65536" ) * 65536 + self:IntrnlGetSF( "sf131072" ) * 131072
	spawnflags = spawnflags + self:IntrnlGetSF( "sf262144" ) * 262144 + self:IntrnlGetSF( "sf524288" ) * 524288

	local ang = Angle( math.sin( CurTime() ) * 16 - 55, trace.HitNormal:Angle().y, 0 )
	if ( trace.HitNormal.z > 0.9999 ) then ang.y = ply:GetAngles().y end

	local env_headcrabcanister = MakeHeadcrabCanister(
		ply,
		self.Model,
		trace.HitPos,
		ang,
		self:GetClientNumber( "key_fire" ),
		self:GetClientNumber( "key_open" ),
		self:GetClientNumber( "key_spawn" ),
		self:GetClientNumber( "fire_immediately" ),
		self:GetClientNumber( "headcrab" ),
		self:GetClientNumber( "count" ),
		self:GetClientNumber( "speed" ),
		self:GetClientNumber( "time" ),
		self:GetClientNumber( "height" ),
		self:GetClientNumber( "damage" ),
		self:GetClientNumber( "radius" ),
		self:GetClientNumber( "duration" ),
		spawnflags,
		self:GetClientNumber( "smoke" )
	 )

	undo.Create( "env_headcrabcanister" )
		undo.AddEntity( env_headcrabcanister )
		undo.SetPlayer( ply )
	undo.Finish()

	return true

end

function TOOL:UpdateGhostEntity( ent, ply )
	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()

	if ( !trace.Hit || trace.HitNormal.z < 0 ) then ent:SetNoDraw( true ) return end
	if ( IsValid( trace.Entity ) && ( trace.Entity:GetClass() == "env_headcrabcanister" || trace.Entity:IsPlayer() || trace.Entity:IsNPC() ) ) then ent:SetNoDraw( true ) return end

	local min = ent:OBBMins()
	local ang = Angle( math.sin( CurTime() ) * 16 - 55, trace.HitNormal:Angle().y, 0 )
	if ( trace.HitNormal.z > 0.9999 ) then
		ang.y = ply:GetAngles().y
		ent:SetPos( trace.HitPos - trace.HitNormal * min.z - Vector( 0, 0, 16 ) )
	else
		ent:SetPos( trace.HitPos - trace.HitNormal )
	end

	ent:SetAngles( ang )
	ent:SetNoDraw( false )
end

function TOOL:Think()
	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != self.Model ) then
		self:MakeGhostEntity( self.Model, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end

	self:UpdateGhostEntity( self.GhostEntity, self:GetOwner() )
end


list.Set( "HeadcrabModels", "#npc_headcrab", { env_headcrabcanister_headcrab = "0" } )
list.Set( "HeadcrabModels", "#npc_headcrab_fast", { env_headcrabcanister_headcrab = "1" } )
list.Set( "HeadcrabModels", "#npc_headcrab_poison", { env_headcrabcanister_headcrab = "2" } )

if ( SERVER ) then return end

TOOL.Information = { { name = "left" } }

language.Add( "tool.env_headcrabcanister", "Headcrab Canisters" )
language.Add( "tool.env_headcrabcanister.name", "Headcrab Canister Tool" )
language.Add( "tool.env_headcrabcanister.desc", "Spawn headcrab canisters" )
language.Add( "tool.env_headcrabcanister.left", "Spawn a headcrab canister" )

language.Add( "tool.env_headcrabcanister.fire", "Fire Headcrab Canister" )
language.Add( "tool.env_headcrabcanister.fire_immediately", "Fire on spawn" )

language.Add( "tool.env_headcrabcanister.open", "Open The Canister" )
language.Add( "tool.env_headcrabcanister.spawn", "Spawn headcrabs" )

language.Add( "tool.env_headcrabcanister.headcrab", "Headcrab Type" )
language.Add( "tool.env_headcrabcanister.count", "Headcrab count:" )
language.Add( "tool.env_headcrabcanister.speed", "Flight speed:" )
language.Add( "tool.env_headcrabcanister.time", "Flight time:" )
language.Add( "tool.env_headcrabcanister.height", "Starting height:" )
language.Add( "tool.env_headcrabcanister.damage", "Impact damage:" )
language.Add( "tool.env_headcrabcanister.radius", "Damage radius:" )
language.Add( "tool.env_headcrabcanister.duration", "Smoke duration:" )
language.Add( "tool.env_headcrabcanister.smoke", "Always smoke" )

language.Add( "tool.env_headcrabcanister.sf1", "No impact sound" )
language.Add( "tool.env_headcrabcanister.sf2", "No launch sound" )
language.Add( "tool.env_headcrabcanister.sf4096", "Start impacted" )
language.Add( "tool.env_headcrabcanister.sf16384", "Wait for input to open" )
language.Add( "tool.env_headcrabcanister.sf32768", "Wait for input to spawn headcrabs" )
language.Add( "tool.env_headcrabcanister.sf65536", "No smoke" )
language.Add( "tool.env_headcrabcanister.sf131072", "No shake" )
language.Add( "tool.env_headcrabcanister.sf262144", "Remove on impact" )
language.Add( "tool.env_headcrabcanister.sf524288", "No impact effects" )

language.Add( "Cleanup_env_headcrabcanisters", "Headcrab Canisters" )
language.Add( "Cleaned_env_headcrabcanisters", "Cleaned up all Headcrab Canisters" )
language.Add( "SBoxLimit_env_headcrabcanisters", "You've hit the Headcrab Canisters limit!" )
language.Add( "Undone_env_headcrabcanister", "Headcrab Canister undone" )

language.Add( "max_env_headcrabcanisters", "Max Headcrab Canisters:" )

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( panel )
	panel:AddControl( "ComboBox", { MenuButton = 1, Folder = "env_headcrabcanister", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	panel:AddControl( "Numpad", { Label = "#tool.env_headcrabcanister.fire", Command = "env_headcrabcanister_key_fire" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.fire_immediately", Command = "env_headcrabcanister_fire_immediately" } )

	panel:AddControl( "Numpad", { Label = "#tool.env_headcrabcanister.open", Command = "env_headcrabcanister_key_open", Label2 = "#tool.env_headcrabcanister.spawn", Command2 = "env_headcrabcanister_key_spawn" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf16384", Command = "env_headcrabcanister_sf16384" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf32768", Command = "env_headcrabcanister_sf32768" } )

	panel:AddControl( "ListBox", { Label = "#tool.env_headcrabcanister.headcrab", Height = 68, Options = list.Get( "HeadcrabModels" ) } )

	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.count", Max = 10, Command = "env_headcrabcanister_count" } )

	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.speed", Type = "Float", Min = 1, Max = 8192, Command = "env_headcrabcanister_speed" } )
	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.time", Type = "Float", Max = 30, Command = "env_headcrabcanister_time" } )

	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.height", Type = "Float", Max = 10240, Command = "env_headcrabcanister_height" } )

	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.damage", Type = "Float", Max = 256, Command = "env_headcrabcanister_damage" } )
	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.radius", Type = "Float", Max = 1024, Command = "env_headcrabcanister_radius" } )

	panel:AddControl( "Slider", { Label = "#tool.env_headcrabcanister.duration", Type = "Float", Max = 90, Command = "env_headcrabcanister_duration" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.smoke", Command = "env_headcrabcanister_smoke" } )

	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf2", Command = "env_headcrabcanister_sf2" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf1", Command = "env_headcrabcanister_sf1" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf65536", Command = "env_headcrabcanister_sf65536" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf131072", Command = "env_headcrabcanister_sf131072" } )

	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf524288", Command = "env_headcrabcanister_sf524288" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf4096", Command = "env_headcrabcanister_sf4096" } )
	panel:AddControl( "Checkbox", { Label = "#tool.env_headcrabcanister.sf262144", Command = "env_headcrabcanister_sf262144" } )
end
