
TOOL.Category = "Half-Life 2"
TOOL.Name = "#tool.item_item_crate"

TOOL.Models = {}
TOOL.Models[ "models/items/item_item_crate.mdl" ] = 0
TOOL.Models[ "models/items/item_beacon_crate.mdl" ] = 1

TOOL.ClientConVar[ "model" ] = "models/items/item_item_crate.mdl"
TOOL.ClientConVar[ "item" ] = "item_healthkit"
TOOL.ClientConVar[ "amount" ] = "3"
TOOL.ClientConVar[ "health" ] = "25"

TOOL.ClientConVar[ "desired_health" ] = "100"
TOOL.ClientConVar[ "desired_armor" ] = "30"
TOOL.ClientConVar[ "desired_pistol" ] = "50"
TOOL.ClientConVar[ "desired_smg1" ] = "50"
TOOL.ClientConVar[ "desired_smg1_alt" ] = "10"
TOOL.ClientConVar[ "desired_ar2" ] = "40"
TOOL.ClientConVar[ "desired_shotgun" ] = "50"
TOOL.ClientConVar[ "desired_rpg" ] = "0"
TOOL.ClientConVar[ "desired_grenade" ] = "10"
TOOL.ClientConVar[ "desired_357" ] = "0"
TOOL.ClientConVar[ "desired_crossbow" ] = "0"
TOOL.ClientConVar[ "desired_ar2_alt" ] = "0"

cleanup.Register( "item_item_crates" )

if ( SERVER ) then
	CreateConVar( "sbox_maxitem_item_crates", 8 )

	function MakeItemCrate( ply, pos, ang, appearance, class, amount, health, dynamic_values )
		if ( IsValid( ply ) && !ply:CheckLimit( "item_item_crates" ) ) then return nil end

		local item_item_crate = ents.Create( "item_item_crate" )
		if ( !IsValid( item_item_crate ) ) then return false end
		item_item_crate:SetPos( pos )
		item_item_crate:SetAngles( ang )

		-- Map placed entity fix
		class = class || "item_dynamic_ressuply"
		appearance = appearance || 0
		amount = tonumber( amount ) || 1
		dynamic_values = dynamic_values || {}

		if ( class == "item_dynamic_resupply" ) then
			local item_dynamic_resupply = ents.Create( "item_dynamic_resupply" )
			item_dynamic_resupply:SetKeyValue( "targetname", "rb655_item_dynamic_resupply" .. item_dynamic_resupply:EntIndex() )
			for i, n in pairs( dynamic_values ) do
				item_dynamic_resupply:SetKeyValue( i, n )
			end
			item_item_crate:SetKeyValue( "SpecificResupply", "rb655_item_dynamic_resupply" .. item_dynamic_resupply:EntIndex() )
			item_item_crate:DeleteOnRemove( item_dynamic_resupply )
		end

		item_item_crate:SetKeyValue( "CrateAppearance", appearance )
		item_item_crate:SetKeyValue( "ItemClass", class )
		item_item_crate:SetKeyValue( "ItemCount", math.Clamp( amount , 1, 25 ) )

		item_item_crate:Spawn()
		item_item_crate:Activate()

		if ( health ) then item_item_crate:Fire( "SetHealth", math.Clamp( health, 1, 100 ) ) end

		if ( appearance && appearance == 1 ) then -- Episode 2 Jalopy radar thingy
			local t = ents.Create( "info_radar_target" )
			t:SetPos( item_item_crate:GetPos() )
			t:SetKeyValue( "mode", 0 )
			t:SetKeyValue( "type", 0 )
			t:SetKeyValue( "radius", 1200 )
			t:Spawn()
			t:Activate()
			t:Fire( "Enable" )
			t:SetParent( item_item_crate )
		end

		table.Merge( item_item_crate:GetTable(), {
			ply = ply,
			appearance = appearance,
			class = class,
			amount = amount,
			health = health,
			dynamic_values = dynamic_values,
		} )

		if ( IsValid( ply ) ) then
			ply:AddCount( "item_item_crates", item_item_crate )
			ply:AddCleanup( "item_item_crates", item_item_crate )
		end

		DoPropSpawnedEffect( item_item_crate )

		return item_item_crate
	end

	duplicator.RegisterEntityClass( "item_item_crate", MakeItemCrate, "pos", "ang", "appearance", "class", "amount", "health", "dynamic_values" )
end

function TOOL:LeftClick( trace )
	if ( trace.HitSky || !trace.HitPos || IsValid( trace.Entity ) && ( trace.Entity:IsPlayer() || trace.Entity:IsNPC() ) ) then return false end
	if ( CLIENT ) then return true end

	local ply = self:GetOwner()
	local ang = trace.HitNormal:Angle()
	ang.pitch = ang.pitch - 270

	if ( trace.HitNormal.z > 0.9999 ) then ang.y = ply:GetAngles().y + 90 end

	local item = self:GetClientInfo( "item" )
	if ( item == "" ) then
		local t = {}
		for k, v in pairs( list.Get( "ItemCrateItems" ) ) do
			if ( k == "#tool.item_item_crate.random" ) then continue end
			table.insert( t, v.item_item_crate_item )
		end

		item = t[ math.random( 1, #t ) ]
	end

	local contains = false
	for k, v in pairs( list.Get( "ItemCrateItems" ) ) do
		if ( !v.item_item_crate_item ) then continue end
		if ( item != v.item_item_crate_item ) then continue end
		contains = true
	end

	if ( !contains ) then return end

	local dynamic_values = {
		DesiredHealth = self:GetClientInfo( "desired_health" ) / 100,
		DesiredArmor = self:GetClientInfo( "desired_armor" ) / 100,
		DesiredAmmoPistol = self:GetClientInfo( "desired_pistol" ) / 100,
		DesiredAmmoSMG1 = self:GetClientInfo( "desired_smg1" ) / 100,
		DesiredAmmoSMG1_Grenade = self:GetClientInfo( "desired_smg1_alt" ) / 100,
		DesiredAmmoAR2 = self:GetClientInfo( "desired_ar2" ) / 100,
		DesiredAmmoBuckshot = self:GetClientInfo( "desired_shotgun" ) / 100,
		DesiredAmmoRPG_Round = self:GetClientInfo( "desired_rpg" ) / 100,
		DesiredAmmoGrenade = self:GetClientInfo( "desired_grenade" ) / 100,
		DesiredAmmo357 = self:GetClientInfo( "desired_357" ) / 100,
		DesiredAmmoCrossbow = self:GetClientInfo( "desired_crossbow" ) / 100,
		DesiredAmmoAR2_AltFire = self:GetClientInfo( "desired_ar2_alt" ) / 100
	}

	local item_item_crate = MakeItemCrate( ply, trace.HitPos, ang, self.Models[ self:GetClientInfo( "model" ) ], item, self:GetClientNumber( "amount" ), self:GetClientNumber( "health" ), dynamic_values )

	undo.Create( "item_item_crate" )
		undo.AddEntity( item_item_crate )
		undo.SetPlayer( ply )
	undo.Finish()

	return true
end

function TOOL:UpdateGhostEntity( ent, ply )
	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()

	if ( !trace.Hit ) then return end
	if ( trace.Entity && ( trace.Entity:GetClass() == "item_item_crate" || trace.Entity:IsPlayer() ) ) then ent:SetNoDraw( true ) return end

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

list.Set( "ItemCrateModels", "models/items/item_item_crate.mdl", {} )
list.Set( "ItemCrateModels", "models/items/item_beacon_crate.mdl", {} )

list.Set( "ItemCrateItems", "#item_ammo_pistol", { item_item_crate_item = "item_ammo_pistol" } )
list.Set( "ItemCrateItems", "#item_ammo_pistol_large", { item_item_crate_item = "item_ammo_pistol_large" } )
list.Set( "ItemCrateItems", "#item_ammo_smg1", { item_item_crate_item = "item_ammo_smg1" } )
list.Set( "ItemCrateItems", "#item_ammo_smg1_large", { item_item_crate_item = "item_ammo_smg1_large" } )
list.Set( "ItemCrateItems", "#item_ammo_smg1_grenade", { item_item_crate_item = "item_ammo_smg1_grenade" } )
list.Set( "ItemCrateItems", "#item_ammo_ar2", { item_item_crate_item = "item_ammo_ar2" } )
list.Set( "ItemCrateItems", "#item_ammo_ar2_large", { item_item_crate_item = "item_ammo_ar2_large" } )
list.Set( "ItemCrateItems", "#item_ammo_ar2_altfire", { item_item_crate_item = "item_ammo_ar2_altfire" } )
list.Set( "ItemCrateItems", "#item_ammo_357", { item_item_crate_item = "item_ammo_357" } )
list.Set( "ItemCrateItems", "#item_ammo_357_large", { item_item_crate_item = "item_ammo_357_large" } )
list.Set( "ItemCrateItems", "#item_ammo_crossbow", { item_item_crate_item = "item_ammo_crossbow" } )
list.Set( "ItemCrateItems", "#item_rpg_round", { item_item_crate_item = "item_rpg_round" } )
list.Set( "ItemCrateItems", "#item_box_buckshot", { item_item_crate_item = "item_box_buckshot" } )
list.Set( "ItemCrateItems", "#item_battery", { item_item_crate_item = "item_battery" } )
list.Set( "ItemCrateItems", "#item_healthvial", { item_item_crate_item = "item_healthvial" } )
list.Set( "ItemCrateItems", "#item_healthkit", { item_item_crate_item = "item_healthkit" } )
list.Set( "ItemCrateItems", "#item_grubnugget", { item_item_crate_item = "item_grubnugget" } )
list.Set( "ItemCrateItems", "#item_dynamic_resupply", { item_item_crate_item = "item_dynamic_resupply" } )
list.Set( "ItemCrateItems", "#tool.item_item_crate.random", { item_item_crate_item = "" } )

list.Set( "ItemCrateItems", "#weapon_crowbar", { item_item_crate_item = "weapon_crowbar" } )
list.Set( "ItemCrateItems", "#weapon_stunstick", { item_item_crate_item = "weapon_stunstick" } )
list.Set( "ItemCrateItems", "#weapon_physcannon", { item_item_crate_item = "weapon_physcannon" } )
list.Set( "ItemCrateItems", "#weapon_physgun", { item_item_crate_item = "weapon_physgun" } )
list.Set( "ItemCrateItems", "#weapon_pistol", { item_item_crate_item = "weapon_pistol" } )
list.Set( "ItemCrateItems", "#weapon_357", { item_item_crate_item = "weapon_357" } )
list.Set( "ItemCrateItems", "#weapon_smg1", { item_item_crate_item = "weapon_smg1" } )
list.Set( "ItemCrateItems", "#weapon_ar2", { item_item_crate_item = "weapon_ar2" } )
list.Set( "ItemCrateItems", "#weapon_shotgun", { item_item_crate_item = "weapon_shotgun" } )
list.Set( "ItemCrateItems", "#weapon_crossbow", { item_item_crate_item = "weapon_crossbow" } )
list.Set( "ItemCrateItems", "#weapon_rpg", { item_item_crate_item = "weapon_rpg" } )
list.Set( "ItemCrateItems", "#weapon_frag", { item_item_crate_item = "weapon_frag" } )

if ( SERVER ) then return end

TOOL.Information = { { name = "left" } }

concommand.Add( "item_item_crate_reset", function()
	RunConsoleCommand( "item_item_crate_desired_health", "100" )
	RunConsoleCommand( "item_item_crate_desired_armor", "30" )
	RunConsoleCommand( "item_item_crate_desired_pistol", "50" )
	RunConsoleCommand( "item_item_crate_desired_smg1", "50" )
	RunConsoleCommand( "item_item_crate_desired_smg1_alt", "10" )
	RunConsoleCommand( "item_item_crate_desired_ar2", "40" )
	RunConsoleCommand( "item_item_crate_desired_shotgun", "50" )
	RunConsoleCommand( "item_item_crate_desired_rpg", "0" )
	RunConsoleCommand( "item_item_crate_desired_grenade", "10" )
	RunConsoleCommand( "item_item_crate_desired_357", "0" )
	RunConsoleCommand( "item_item_crate_desired_crossbow", "0" )
	RunConsoleCommand( "item_item_crate_desired_ar2_alt", "0" )
end )

local ConVarsDefault = TOOL:BuildConVarList()

language.Add( "tool.item_item_crate", "Item Crates" )
language.Add( "tool.item_item_crate.name", "Item Crate Tool" )
language.Add( "tool.item_item_crate.desc", "Spawn item crates" )
language.Add( "tool.item_item_crate.left", "Spawn an item crate" )

language.Add( "tool.item_item_crate.model", "Crate Model" )

language.Add( "tool.item_item_crate.contents", "Crate Contents" )
language.Add( "tool.item_item_crate.random", "Random Item" )

language.Add( "tool.item_item_crate.amount", "Content Amount:" )
language.Add( "tool.item_item_crate.amount.help", "The amount of items to put into item crate." )
language.Add( "tool.item_item_crate.health", "Crate Health:" )
language.Add( "tool.item_item_crate.health.help", "Amount of damage the item crate can take before it will break." )

language.Add( "tool.item_item_crate.edit", "Edit Dynamic Resupply Item Values" )
language.Add( "tool.item_item_crate.back", "Return back" )
language.Add( "tool.item_item_crate.reset", "Reset to defaults" )

language.Add( "Cleanup_item_item_crates", "Item Crates" )
language.Add( "Cleaned_item_item_crates", "Cleaned up all Item Crates" )
language.Add( "SBoxLimit_item_item_crates", "You've hit the Item Crates limit!" )
language.Add( "Undone_item_item_crate", "Item Crate undone" )

language.Add( "max_item_item_crates", "Max Item Crates:" )

language.Add( "tool.item_item_crate.desired_health", "Health:" )
language.Add( "tool.item_item_crate.desired_armor", "Armor:" )
language.Add( "tool.item_item_crate.desired_pistol", "Pistol ammo:" )
language.Add( "tool.item_item_crate.desired_smg1", "SMG1 ammo:" )
language.Add( "tool.item_item_crate.desired_smg1_alt", "SMG1 Grenades:" )
language.Add( "tool.item_item_crate.desired_ar2", "AR2 ammo:" )
language.Add( "tool.item_item_crate.desired_shotgun", "Shotgun Ammo:" )
language.Add( "tool.item_item_crate.desired_rpg", "RPG Rounds:" )
language.Add( "tool.item_item_crate.desired_grenade", "Grenades:" )
language.Add( "tool.item_item_crate.desired_357", ".357 Ammo:" )
language.Add( "tool.item_item_crate.desired_crossbow", "Crossbow Ammo:" )
language.Add( "tool.item_item_crate.desired_ar2_alt", "AR2 Energy Balls:" )
language.Add( "tool.item_item_crate.desired_ar2_alt.help", "A dynamic ressuply item. When the player enters the PVS of this entity, it will determine the item most needed by the player, spawn one of those items, and remove itself. To determine which item the player most needs, it calculates which of the Desired Health/Armor/Ammo ratios the player is farthest from.\n\nIf the player is above all the desired levels, then no item will be spawned." )

function TOOL.BuildCPanel( panel )
	panel:AddControl( "ComboBox", { MenuButton = 1, Folder = "item_item_crate", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	panel:AddControl( "PropSelect", { Label = "#tool.item_item_crate.model", Height = 1, ConVar = "item_item_crate_model", Models = list.Get( "ItemCrateModels" ) } )
	panel:AddControl( "ListBox", { Label = "#tool.item_item_crate.contents", Height = 256, Options = list.Get( "ItemCrateItems" ) } )

	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.amount", Min = 1, Max = 25, Command = "item_item_crate_amount", Help = true } )
	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.health", Min = 1, Max = 100, Command = "item_item_crate_health", Help = true } )

	panel:Help( "#tool.item_item_crate.desired_ar2_alt.help" )

	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.desired_health", Max = 100, Command = "item_item_crate_desired_health" } )
	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.desired_armor", Max = 100, Command = "item_item_crate_desired_armor" } )
	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.desired_pistol", Max = 100, Command = "item_item_crate_desired_pistol" } )
	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.desired_smg1", Max = 100, Command = "item_item_crate_desired_smg1" } )
	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.desired_smg1_alt", Max = 100, Command = "item_item_crate_desired_smg1_alt" } )
	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.desired_ar2", Max = 100, Command = "item_item_crate_desired_ar2" } )
	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.desired_shotgun", Max = 100, Command = "item_item_crate_desired_shotgun" } )
	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.desired_rpg", Max = 100, Command = "item_item_crate_desired_rpg" } )
	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.desired_grenade", Max = 100, Command = "item_item_crate_desired_grenade" } )
	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.desired_357", Max = 100, Command = "item_item_crate_desired_357" } )
	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.desired_crossbow", Max = 100, Command = "item_item_crate_desired_crossbow" } )
	panel:AddControl( "Slider", { Label = "#tool.item_item_crate.desired_ar2_alt", Max = 100, Command = "item_item_crate_desired_ar2_alt" } )

	panel:Button( "#tool.item_item_crate.reset", "item_item_crate_reset" )
end
