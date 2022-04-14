
TOOL.Category = "Half-Life 2"
TOOL.Name = "#tool.item_ammo_crate"

TOOL.ClientConVar[ "type" ] = "0"

local ToolModels = {}
ToolModels[ 0 ] = "models/items/ammocrate_pistol.mdl"
ToolModels[ 1 ] = "models/items/ammocrate_smg1.mdl"
ToolModels[ 2 ] = "models/items/ammocrate_ar2.mdl"
ToolModels[ 3 ] = "models/items/ammocrate_rockets.mdl"
ToolModels[ 4 ] = "models/items/ammocrate_buckshot.mdl"
ToolModels[ 5 ] = "models/items/ammocrate_grenade.mdl"
ToolModels[ 6 ] = "models/items/ammocrate_357.mdl"
ToolModels[ 7 ] = "models/items/ammocrate_crossbow.mdl"
ToolModels[ 8 ] = "models/items/ammocrate_ar2.mdl"
ToolModels[ 9 ] = "models/items/ammocrate_smg2.mdl"
ToolModels[ 10 ] = "models/items/ammocrate_smg1.mdl"

cleanup.Register( "item_ammo_crates" )

if ( SERVER ) then

	CreateConVar( "rb655_force_downloads", "0", FCVAR_ARCHIVE )

	if ( GetConVarNumber( "rb655_force_downloads" ) > 0 ) then

		resource.AddFile( "models/items/ammocrate_357.mdl" )
		resource.AddFile( "models/items/ammocrate_crossbow.mdl" )

	end

	CreateConVar( "sbox_maxitem_ammo_crates", 10 )

	function MakeAmmoCrate( ply, model, pos, ang, type )
		if ( IsValid( ply ) && !ply:CheckLimit( "item_ammo_crates" ) ) then return nil end

		type = tonumber( type ) or 0

		local item_ammo_crate = ents.Create( "item_ammo_crate" )
		if ( !IsValid( item_ammo_crate ) ) then return nil end
		item_ammo_crate:SetPos( pos )
		item_ammo_crate:SetAngles( ang )
		item_ammo_crate:SetKeyValue( "AmmoType", math.Clamp( type, 0, 9 ) )
		item_ammo_crate:Spawn()
		item_ammo_crate:Activate()
		item_ammo_crate:SetModel( model )

		table.Merge( item_ammo_crate:GetTable(), {
			ply = ply,
			type = type
		} )

		if ( IsValid( ply ) ) then
			ply:AddCount( "item_ammo_crates", item_ammo_crate )
			ply:AddCleanup( "item_ammo_crates", item_ammo_crate )
		end

		DoPropSpawnedEffect( item_ammo_crate )

		return item_ammo_crate
	end

	duplicator.RegisterEntityClass( "item_ammo_crate", MakeAmmoCrate, "model", "pos", "ang", "type" )
end

function TOOL:LeftClick( trace )
	if ( trace.HitSky or !trace.HitPos or trace.HitNormal.z < 0.7 ) then return false end
	if ( IsValid( trace.Entity ) and ( trace.Entity:GetClass() == "item_ammo_crate" or trace.Entity:IsPlayer() or trace.Entity:IsNPC() ) ) then return false end
	if ( CLIENT ) then return true end

	local ply = self:GetOwner()

	local ang = trace.HitNormal:Angle()
	ang.p = ang.p - 270
	if ( trace.HitNormal.z > 0.9999 ) then ang.y = ply:GetAngles().y + 180 end

	local type = self:GetClientNumber( "type" )
	if ( type == 10 ) then type = math.random( 0, 9 ) end

	local item_ammo_crate = MakeAmmoCrate( ply, ToolModels[ type ], trace.HitPos + trace.HitNormal * 16, ang, type )

	undo.Create( "item_ammo_crate" )
		undo.AddEntity( item_ammo_crate )
		undo.SetPlayer( ply )
	undo.Finish()

	return true
end

function TOOL:UpdateGhostEntity( ent, ply )
	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()

	if ( !trace.Hit || trace.HitNormal.z < 0.7 ) then ent:SetNoDraw( true ) return end
	if ( trace.Entity && ( trace.Entity:GetClass() == "item_ammo_crate" || trace.Entity:IsPlayer() ) ) then ent:SetNoDraw( true ) return end

	local ang = trace.HitNormal:Angle()
	ang.p = ang.p - 270
	if ( trace.HitNormal.z > 0.9999 ) then ang.y = ply:GetAngles().y + 180 end

	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos - trace.HitNormal * min.z )

	ent:SetAngles( ang )
	ent:SetNoDraw( false )
end

function TOOL:Think()
	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != ToolModels[ self:GetClientNumber( "type" ) ] ) then
		self:MakeGhostEntity( ToolModels[ self:GetClientNumber( "type" ) ], Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end
	self:UpdateGhostEntity( self.GhostEntity, self:GetOwner() )
end

list.Set( "AmmoCrateTypes", "#Pistol_ammo", { item_ammo_crate_type = "0" } )
list.Set( "AmmoCrateTypes", "#Buckshot_ammo", { item_ammo_crate_type = "4" } )
list.Set( "AmmoCrateTypes", "#SMG1_grenade_ammo", { item_ammo_crate_type = "9" } )

list.Set( "AmmoCrateTypes", "#SMG1_ammo", { item_ammo_crate_type = "1" } )
list.Set( "AmmoCrateTypes", "#AR2_ammo", { item_ammo_crate_type = "2" } )
list.Set( "AmmoCrateTypes", "#RPG_round_ammo", { item_ammo_crate_type = "3" } )
list.Set( "AmmoCrateTypes", "#Buckshot_ammo", { item_ammo_crate_type = "4" } )
list.Set( "AmmoCrateTypes", "#Grenade_ammo", { item_ammo_crate_type = "5" } )
list.Set( "AmmoCrateTypes", "#357_ammo", { item_ammo_crate_type = "6" } )
list.Set( "AmmoCrateTypes", "#XBowBolt_ammo", { item_ammo_crate_type = "7" } )
list.Set( "AmmoCrateTypes", "#AR2AltFire_ammo", { item_ammo_crate_type = "8" } )
list.Set( "AmmoCrateTypes", "#SMG1_grenade_ammo", { item_ammo_crate_type = "9" } )
list.Set( "AmmoCrateTypes", "#tool.item_ammo_crate.random", { item_ammo_crate_type = "10" } )

if ( SERVER ) then return end

TOOL.Information = { { name = "left" } }

language.Add( "tool.item_ammo_crate", "Ammo Crates" )
language.Add( "tool.item_ammo_crate.name", "Ammo Crate Tool" )
language.Add( "tool.item_ammo_crate.desc", "Spawn crates full of ammo for resupply" )
language.Add( "tool.item_ammo_crate.left", "Spawn an ammo crate" )

language.Add( "tool.item_ammo_crate.type", "Ammo Crate Type" )
language.Add( "tool.item_ammo_crate.random", "Random" )

language.Add( "Cleanup_item_ammo_crates", "Ammo Crates" )
language.Add( "Cleaned_item_ammo_crates", "Cleaned up all Ammo Crates" )
language.Add( "SBoxLimit_item_ammo_crates", "You've hit the Ammo Crate limit!" )
language.Add( "Undone_item_ammo_crate", "Ammo Crate undone" )

language.Add( "max_item_ammo_crates", "Max Ammo Crates:" )

function TOOL.BuildCPanel( panel )
	panel:AddControl( "ListBox", { Label = "#tool.item_ammo_crate.type", Options = list.Get( "AmmoCrateTypes" ), Height = 204 } )
end


TOOL.Category = "Half-Life 2"
TOOL.Name = "#tool.item_ammo_crate"

TOOL.ClientConVar[ "type" ] = "0"

local ToolModels = {}
ToolModels[ 0 ] = "models/items/ammocrate_pistol.mdl"
ToolModels[ 1 ] = "models/items/ammocrate_smg1.mdl"
ToolModels[ 2 ] = "models/items/ammocrate_ar2.mdl"
ToolModels[ 3 ] = "models/items/ammocrate_rockets.mdl"
ToolModels[ 4 ] = "models/items/ammocrate_buckshot.mdl"
ToolModels[ 5 ] = "models/items/ammocrate_grenade.mdl"
ToolModels[ 6 ] = "models/items/ammocrate_357.mdl"
ToolModels[ 7 ] = "models/items/ammocrate_crossbow.mdl"
ToolModels[ 8 ] = "models/items/ammocrate_ar2.mdl"
ToolModels[ 9 ] = "models/items/ammocrate_smg2.mdl"
ToolModels[ 10 ] = "models/items/ammocrate_smg1.mdl"

cleanup.Register( "item_ammo_crates" )

if ( SERVER ) then

	CreateConVar( "rb655_force_downloads", "0", FCVAR_ARCHIVE )

	if ( GetConVarNumber( "rb655_force_downloads" ) > 0 ) then

		resource.AddFile( "models/items/ammocrate_357.mdl" )
		resource.AddFile( "models/items/ammocrate_crossbow.mdl" )

	end

	CreateConVar( "sbox_maxitem_ammo_crates", 10 )

	function MakeAmmoCrate( ply, model, pos, ang, type )
		if ( IsValid( ply ) && !ply:CheckLimit( "item_ammo_crates" ) ) then return nil end

		type = tonumber( type ) or 0

		local item_ammo_crate = ents.Create( "item_ammo_crate" )
		if ( !IsValid( item_ammo_crate ) ) then return nil end
		item_ammo_crate:SetPos( pos )
		item_ammo_crate:SetAngles( ang )
		item_ammo_crate:SetKeyValue( "AmmoType", math.Clamp( type, 0, 9 ) )
		item_ammo_crate:Spawn()
		item_ammo_crate:Activate()
		item_ammo_crate:SetModel( model )

		table.Merge( item_ammo_crate:GetTable(), {
			ply = ply,
			type = type
		} )

		if ( IsValid( ply ) ) then
			ply:AddCount( "item_ammo_crates", item_ammo_crate )
			ply:AddCleanup( "item_ammo_crates", item_ammo_crate )
		end

		DoPropSpawnedEffect( item_ammo_crate )

		return item_ammo_crate
	end

	duplicator.RegisterEntityClass( "item_ammo_crate", MakeAmmoCrate, "model", "pos", "ang", "type" )
end

function TOOL:LeftClick( trace )
	if ( trace.HitSky or !trace.HitPos or trace.HitNormal.z < 0.7 ) then return false end
	if ( IsValid( trace.Entity ) and ( trace.Entity:GetClass() == "item_ammo_crate" or trace.Entity:IsPlayer() or trace.Entity:IsNPC() ) ) then return false end
	if ( CLIENT ) then return true end

	local ply = self:GetOwner()

	local ang = trace.HitNormal:Angle()
	ang.p = ang.p - 270
	if ( trace.HitNormal.z > 0.9999 ) then ang.y = ply:GetAngles().y + 180 end

	local type = self:GetClientNumber( "type" )
	if ( type == 10 ) then type = math.random( 0, 9 ) end

	local item_ammo_crate = MakeAmmoCrate( ply, ToolModels[ type ], trace.HitPos + trace.HitNormal * 16, ang, type )

	undo.Create( "item_ammo_crate" )
		undo.AddEntity( item_ammo_crate )
		undo.SetPlayer( ply )
	undo.Finish()

	return true
end

function TOOL:UpdateGhostEntity( ent, ply )
	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()

	if ( !trace.Hit || trace.HitNormal.z < 0.7 ) then ent:SetNoDraw( true ) return end
	if ( trace.Entity && ( trace.Entity:GetClass() == "item_ammo_crate" || trace.Entity:IsPlayer() ) ) then ent:SetNoDraw( true ) return end

	local ang = trace.HitNormal:Angle()
	ang.p = ang.p - 270
	if ( trace.HitNormal.z > 0.9999 ) then ang.y = ply:GetAngles().y + 180 end

	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos - trace.HitNormal * min.z )

	ent:SetAngles( ang )
	ent:SetNoDraw( false )
end

function TOOL:Think()
	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != ToolModels[ self:GetClientNumber( "type" ) ] ) then
		self:MakeGhostEntity( ToolModels[ self:GetClientNumber( "type" ) ], Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end
	self:UpdateGhostEntity( self.GhostEntity, self:GetOwner() )
end

list.Set( "AmmoCrateTypes", "#Pistol_ammo", { item_ammo_crate_type = "0" } )
list.Set( "AmmoCrateTypes", "#Buckshot_ammo", { item_ammo_crate_type = "4" } )
list.Set( "AmmoCrateTypes", "#SMG1_grenade_ammo", { item_ammo_crate_type = "9" } )

list.Set( "AmmoCrateTypes", "#SMG1_ammo", { item_ammo_crate_type = "1" } )
list.Set( "AmmoCrateTypes", "#AR2_ammo", { item_ammo_crate_type = "2" } )
list.Set( "AmmoCrateTypes", "#RPG_round_ammo", { item_ammo_crate_type = "3" } )
list.Set( "AmmoCrateTypes", "#Buckshot_ammo", { item_ammo_crate_type = "4" } )
list.Set( "AmmoCrateTypes", "#Grenade_ammo", { item_ammo_crate_type = "5" } )
list.Set( "AmmoCrateTypes", "#357_ammo", { item_ammo_crate_type = "6" } )
list.Set( "AmmoCrateTypes", "#XBowBolt_ammo", { item_ammo_crate_type = "7" } )
list.Set( "AmmoCrateTypes", "#AR2AltFire_ammo", { item_ammo_crate_type = "8" } )
list.Set( "AmmoCrateTypes", "#SMG1_grenade_ammo", { item_ammo_crate_type = "9" } )
list.Set( "AmmoCrateTypes", "#tool.item_ammo_crate.random", { item_ammo_crate_type = "10" } )

if ( SERVER ) then return end

TOOL.Information = { { name = "left" } }

language.Add( "tool.item_ammo_crate", "Ammo Crates" )
language.Add( "tool.item_ammo_crate.name", "Ammo Crate Tool" )
language.Add( "tool.item_ammo_crate.desc", "Spawn crates full of ammo for resupply" )
language.Add( "tool.item_ammo_crate.left", "Spawn an ammo crate" )

language.Add( "tool.item_ammo_crate.type", "Ammo Crate Type" )
language.Add( "tool.item_ammo_crate.random", "Random" )

language.Add( "Cleanup_item_ammo_crates", "Ammo Crates" )
language.Add( "Cleaned_item_ammo_crates", "Cleaned up all Ammo Crates" )
language.Add( "SBoxLimit_item_ammo_crates", "You've hit the Ammo Crate limit!" )
language.Add( "Undone_item_ammo_crate", "Ammo Crate undone" )

language.Add( "max_item_ammo_crates", "Max Ammo Crates:" )

function TOOL.BuildCPanel( panel )
	panel:AddControl( "ListBox", { Label = "#tool.item_ammo_crate.type", Options = list.Get( "AmmoCrateTypes" ), Height = 204 } )
end
