
TOOL.Category		= "LFS"
TOOL.Name			= "#tool.lfshealthshieldeditor.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "maxshield" ] = 0
TOOL.ClientConVar[ "maxhealth" ] = 5000

if CLIENT then
	language.Add( "tool.lfshealthshieldeditor.name", "Max Health & Shield Editor" )
	language.Add( "tool.lfshealthshieldeditor.desc", "A tool used to edit Max Health & Shield on LFS-Vehicles" )
	language.Add( "tool.lfshealthshieldeditor.0", "Left click on a LFS-Vehicle to set Max Health, Right click to set Max Shield, Reload to reset." )
	language.Add( "tool.lfshealthshieldeditor.1", "Left click on a LFS-Vehicle to set Max Health, Right click to set Max Shield, Reload to reset." )
	language.Add( "tool.lfshealthshieldeditor.maxshield", "Max Shield" )
	language.Add( "tool.lfshealthshieldeditor.maxhealth", "Max Health" )
end

function TOOL:LeftClick( trace )
	local ent = trace.Entity

	if not IsValid( ent ) or not ent.LFS then return false end

	if not ent.OGMaxHealth then
		ent.OGMaxHealth = ent.MaxHealth
	end

	ent.MaxHealth = self:GetClientNumber( "maxhealth" )
	ent:SetHP( ent.MaxHealth )

	return true
end

function TOOL:RightClick( trace )
	local ent = trace.Entity

	if not IsValid( ent ) or not ent.LFS then return false end

	if not ent.OGMaxShield then
		ent.OGMaxShield = ent.MaxShield
	end

	ent.MaxShield = self:GetClientNumber( "maxshield" )
	ent:SetShield( ent.MaxShield )

	return true
end

function TOOL:Reload( trace )
	local ent = trace.Entity

	if not IsValid( ent ) or not ent.LFS then return false end

	if ent.OGMaxHealth then
		ent.MaxHealth = ent.OGMaxHealth
	end

	if ent.OGMaxShield then
		ent.MaxShield = ent.OGMaxShield
	end

	ent:SetHP( ent.MaxHealth )
	ent:SetShield( ent.MaxShield )

	return true
end

function TOOL:Think()
	if SERVER then return end

	local ply = LocalPlayer()
	local tr = ply:GetEyeTrace()

	local ent = tr.Entity
	if not IsValid( ent ) or not ent.LFS then return end

	local Text = "Health: "..tostring( math.Round( ent:GetHP(), 0 ) ).."/"..tostring( ent.MaxHealth )
	if ent:GetShield() > 0 then
		Text = Text.."\nShield: "..tostring( math.Round( ent:GetShield(), 0 ) ).."/"..tostring( ent.MaxShield )
	end

	AddWorldTip( ent:EntIndex(), Text, SysTime() + 0.05, ent:GetPos(), ent )
end

function TOOL.BuildCPanel( panel )
	panel:AddControl( "Header", { Text = "#tool.lfshealthshieldeditor.name", Description = "#tool.lfshealthshieldeditor.desc" } )

	panel:AddControl( "Slider", 
	{
		Label 	= "#tool.lfshealthshieldeditor.maxhealth",
		Type 	= "Int",
		Min 	= "1",
		Max 	= "50000",
		Command = "lfshealthshieldeditor_maxhealth",
		Help = false
	})

	panel:AddControl( "Slider", 
	{
		Label 	= "#tool.lfshealthshieldeditor.maxshield",
		Type 	= "Int",
		Min 	= "0",
		Max 	= "50000",
		Command = "lfshealthshieldeditor_maxshield",
		Help = false
	})

	panel:AddControl( "Label",  { Text = "NOTE: Value in Edit-Properties menu will still be the same, because they can not be updated after the vehicle is spawned!" } )
end
