
TOOL.Category		= "LFS"
TOOL.Name			= "#AI Enabler"
TOOL.Command		= nil
TOOL.ConfigName		= ""

if CLIENT then
	language.Add( "tool.lfsaienabler.name", "AI Enabler" )
	language.Add( "tool.lfsaienabler.desc", "A tool used to enable/disable AI on LFS-Vehicles" )
	language.Add( "tool.lfsaienabler.0", "Left click on a LFS-Vehicle to enable AI, Right click to disable." )
	language.Add( "tool.lfsaienabler.1", "Left click on a LFS-Vehicle to enable AI, Right click to disable." )
end

function TOOL:LeftClick( trace )
	local ent = trace.Entity

	if not IsValid( ent ) or not ent.LFS then return false end

	if isfunction( ent.SetAI ) then
		ent:SetAI( true )
	end

	return true
end

function TOOL:RightClick( trace )
	local ent = trace.Entity

	if not IsValid( ent ) or not ent.LFS then return false end

	if isfunction( ent.SetAI ) then
		ent:SetAI( false )
	end

	return true
end

function TOOL:Reload( trace )
	return false
end

--[[
function TOOL.BuildCPanel( panel )
end
]]--