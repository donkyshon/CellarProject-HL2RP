TOOL.Category		= "slaugh7er"
TOOL.Name			= "Perma All"
TOOL.Command		= nil
TOOL.ConfigName		= ""

if CLIENT then
	language.Add("Tool.permaall.name", 		"[PermaAll] Entity Saving Tool" )
	language.Add("Tool.permaall.desc", 		"Save or remove targeted Entities from the perminent table" )
	language.Add("Tool.permaall.left", 		"Save Entity")
	language.Add("Tool.permaall.left_use", 	"Save Entity and all constrained Entities")
	language.Add("Tool.permaall.right", 	"Remove Entity")
	language.Add("Tool.permaall.right_use", "Remove Entity and all constrained Entities")
	language.Add("Tool.permaall.reload", 	"Open Perma Table viewer")
end

TOOL.Information = {
	{ name = "left" },
	{ name = "left_use", icon2 = "gui/e.png" },
	{ name = "right" },
	{ name = "right_use", icon2 = "gui/e.png" },
	{ name = "reload" },
}

if SERVER then
	CreateConVar("sv_perma_log", 0)
end

TOOL.ClientConVar[ "secure1" ] = "0"
TOOL.ClientConVar[ "removeclick" ] = "0"
TOOL.ClientConVar[ "removeclear" ] = "0"

function TOOL:LeftClick( tr )
	if SERVER then 
		Perma_Add( self:GetOwner(), tr.Entity )
	end
	return true
end

function TOOL:RightClick( tr )
	if SERVER then
		Perma_Remove( self:GetOwner(), tr.Entity )
	end
	return true
end

function TOOL:Reload(trace) 
	if SERVER then
		self:GetOwner():ConCommand( "permaall_opentableeditor" )
	end
	return false
end

PermaAllKeyValues = PermaAllKeyValues or {}
function TOOL.BuildCPanel( DForm )
	
	DForm:Help( "" )-- splitter
	local e = DForm:Button( "", "" )
	e.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(255,150,0))
		draw.SimpleText( "CLIENT","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
	end
	
	DForm:CheckBox( "Crosshair information", "perma_all_crosshair_hud" )
	DForm:ControlHelp( "Enable crosshair hud information" )
	
	DForm:CheckBox( "Remove Click", "permaall_removeclick" )
	DForm:ControlHelp( "Remove the targeted object when you un-perma it" )
	
	DForm:CheckBox( "Remove Clear", "permaall_removeclear" )
	DForm:ControlHelp( "Remove All Perma Object Present When You Clear The Perma Table" )
	
	DForm:Help( "" )-- splitter
	DForm:Help( "" )-- splitter
	local e = DForm:Button( "", "" )
	e.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,150,255))
		draw.SimpleText( "SERVER","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
	end
	
	DForm:Button( "Respawn All Permanent Object", "permaall_respawn_all" )
	DForm:ControlHelp( "Respawns all Perma Objects from the table back into the map" )
	
	-- local e = DForm:NumSlider( "Respawn speed scalar", "_permaall_respawn_speed", 1, 10, 0 )
	-- DForm:ControlHelp( "Respawn speed scalar" )
	
	local e = DForm:CheckBox( "Safty Switch", "permaall_secure1" )
	e.OnChange = function() 
		timer.Create("permall.saftyreset",3,1,function() RunConsoleCommand("permaall_secure1", 0) end) 
	end
	DForm:ControlHelp( "Safty toggle before you can clear the Perma Table" )
	
	local e = DForm:Button( "Clear Permanent Table", "permaall_cleartable" )
	e.DoClick = function() 
		timer.Create("permall.saftyreset",1,1,function() RunConsoleCommand("permaall_secure1", 0) end) 
		RunConsoleCommand( "permaall_cleartable" )
	end
	DForm:ControlHelp( "Clears all Perma Object stored in the Perma Table (resetting the whole addon)" )
	
	DForm:Help( "" )-- splitter
	DForm:Help( "" )-- splitter
	local e = DForm:Button( "", "" )
	e.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w/2,h,Color(0,150,255))
		draw.RoundedBox(0,w/2,0,w,h,Color(255,150,0))
		draw.SimpleText( "PERMA TABLE VIEWER","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
	end
	
	DForm:Button( "Open Table Editor", "permaall_opentableeditor" )
	DForm:ControlHelp( "Opens the Perma All table editor" )
	
	
	DForm:Help( "" )-- splitter
	DForm:Help( "" )-- splitter
	local e = DForm:Button( "", "" )
	e.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(50,200,50))
		draw.SimpleText( "IMPORT/ EXPORT","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
	end
	 
	DForm:Button( "Import permaprops", "permaall_import_permaprops" )
	DForm:ControlHelp( "(PermaProps must be installed)" )
	DForm:ControlHelp( "(this doesn't touch anything in PermaProps)" )
	
	
end

CreateClientConVar( "perma_all_crosshair_hud", "1", true, false, "Enable crosshair hud information", 0, 1 )
function TOOL:DrawHUD()
	if !GetConVar( "perma_all_crosshair_hud" ):GetBool() then return end
	local p, w, h = LocalPlayer(), ScrW(), ScrH()
	local tr = p:GetEyeTrace()
	local e = tr.Entity
	if !IsValid(e) then return end
	local b = e:GetNWBool( "IsPermaEntity", false )
	draw.RoundedBoxEx( h*.024, w*.525, h*.46, w*.1, h*.08, Color(0,0,0,200), false, true, false, true )
	draw.SimpleTextOutlined( "PERMANENT", "DermaLarge", w*.53, h*.485, Color(255,255,255), 0, 1, 2, Color(0,0,0,100) )
	local s, c = (b), (b and Color(100,255,100) or Color(255,100,100))
	draw.SimpleTextOutlined( s, "DermaLarge", w*.53, h*.515, c, 0, 1, 2, Color(0,0,0,100) )
end





//////////////////////////////////
// NONE TOOL SPECIFIC CODE BELOW
// NONE TOOL SPECIFIC CODE BELOW
// NONE TOOL SPECIFIC CODE BELOW
//////////////////////////////////


if CLIENT then 
	
	concommand.Add( "permaall_opentableeditor", function()
	
		local DFrame = vgui.Create( "DFrame" )
		DFrame:SetSize( ScrW()*.8, ScrH()*.6 )
		DFrame:SetSize( ScrW()*.8, ScrH()*.6 )
		DFrame:Center()
		DFrame:SetTitle("")
		DFrame:MakePopup()
		
		DFrame.Think = function(s)
			if input.IsKeyDown( KEY_TAB ) then s:Remove() end
		end
		
		DFrame.Paint = function(s,w,h)
			draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0) )
			draw.RoundedBox( 0, 1, 1, w-2, h-2, Color(250,240,230) )
			draw.RoundedBox( 0, w/3, 10, w/3, 40, Color(50,50,50) )
			draw.SimpleText( "PermaAll Editor","DermaLarge",w/2,28,Color(255,255,255),1,1 )
		end
		
		local x,y,w,h = DFrame:GetBounds()
		
		local SelectedID 
		
		local DListView = vgui.Create( "DListView", DFrame )
		DListView:SetPos( 10, 60 )
		DListView:SetSize( w-20, h-150 )
		DListView:AddColumn( "ID" )
		DListView:AddColumn( "GroupID" )
		DListView:AddColumn( "Entity" )
		DListView:AddColumn( "Class" )
		DListView:AddColumn( "Model" )
		DListView:SetMultiSelect( false )
		DListView.ResyncListing = function(s)
			RunConsoleCommand( "PermaAll_RequestSync" )
		end
		DListView.RefreshListing = function(s)
			s.PopulatingListUntil = CurTime() + 1
			timer.Simple( .1, function()
				if !IsValid( s ) then return end
				s:Clear()
				
				-- entities by PermaUID
				local EntsByPermaUID = {}
				for _, e in pairs( ents.GetAll() ) do
					local k = e:GetNWString( "_PermaUID", "" )
					if k != "" then EntsByPermaUID[k] = e end
				end
				-- entities by PermaUID
				
				for k, v in pairs( PermaAllKeyValues ) do
					DListView:AddLine( k, (v.GroupID or ""), tostring(EntsByPermaUID[k] or "none"), (v.Class or ""), (v.Model or "") )
				end
			end )
		end	
		DListView.OnRowSelected = function( s, i, e )
			SelectedID = e:GetColumnText( 1 )
		end 
		DListView.DoDoubleClick = function( s, i, e )
			SelectedID = e:GetColumnText( 1 )
			RunConsoleCommand( "permaall_gotoid", tostring(SelectedID) )
		end 
		DListView.OnRowRightClick = function( s, i, e )
			local uid = e:GetColumnText( 1 )
			local group_uid = e:GetColumnText( 2 )
			local entity = e:GetColumnText( 3 )
			local class = e:GetColumnText( 4 )
			local model = e:GetColumnText( 5 )
			
			local function CopyInfo(s)
				s = tostring(s) or ""
				print( s .. " : copied to clipboard" )
				SetClipboardText( s )
			end
			
			local DMenu = DermaMenu()
				DMenu:AddOption( "Copy UID" ).DoClick = function() CopyInfo(uid) end 
				DMenu:AddOption( "Copy Group UID" ).DoClick = function() CopyInfo(group_uid) end 
				DMenu:AddOption( "Copy Entity" ).DoClick = function() CopyInfo(entity) end 
				DMenu:AddOption( "Copy Entity (index)" ).DoClick = function() CopyInfo(entity:EntIndex()) end 
				DMenu:AddOption( "Copy Class" ).DoClick = function() CopyInfo(class) end 
				DMenu:AddOption( "Copy Model" ).DoClick = function() CopyInfo(model) end 
			DMenu:Open()
		end
		DListView.PaintOver = function(s,w,h)
			if s.PopulatingListUntil and s.PopulatingListUntil>CurTime() then
				draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,200) )
				draw.SimpleText( "Populating List", "DermaLarge", w*.5, h*.47, Color(255,255,255), 1, 1 )
				draw.SimpleText( "Please Wait", "DermaLarge", w*.5, h*.53, Color(255,255,255), 1, 1 )
			end
		end
		DListView:RefreshListing()
		
		local DButton = vgui.Create( "DButton", DFrame )
		DButton:SetSize( w-20, 30 ); DButton:SetPos( 10, h-80 ); 
		DButton:SetText( "" )
		DButton.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			draw.RoundedBox(0,1,1,w/2-2,h-2,Color(0,150,255))
			draw.RoundedBox(0,1+w/2,1,w-2,h-2,Color(255,150,0))
			draw.SimpleText( "ACTIONS","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
		end
		
		local DButton = vgui.Create( "DButton", DFrame )
		DButton:SetSize( w/4, 30 ); DButton:SetPos( w-DButton:GetWide()-10, h-40 ); 
		DButton:SetText( "" )
		DButton.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			if s:IsHovered() then 
				draw.RoundedBox(0,1,1,w-2,h-2,Color(255,200,0))
			else
				draw.RoundedBox(0,1,1,w-2,h-2,Color(255,150,0))
			end	
			-- draw.RoundedBox(0,1,1,w-2,h-2,Color(255,150,0))
			draw.SimpleText( "GOTO","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
		end
		DButton.DoClick = function() 
			RunConsoleCommand( "permaall_gotoid", tostring(SelectedID) )
		end
		
		local DButton = vgui.Create( "DButton", DFrame )
		DButton:SetSize( w/4, 30 ); DButton:SetPos( w/2-DButton:GetWide()/2, h-40 ); 
		DButton:SetText( "" )
		DButton.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			if s:IsHovered() then 
				draw.RoundedBox(0,1,1,w/2-2,h-2,Color(0,200,255))
				draw.RoundedBox(0,1+w/2,1,w-2,h-2,Color(255,200,0))
			else
				draw.RoundedBox(0,1,1,w/2-2,h-2,Color(0,150,255))
				draw.RoundedBox(0,1+w/2,1,w-2,h-2,Color(255,150,0))
			end	
			-- draw.RoundedBox(0,1,1,w-2,h-2,Color(255,150,0))
			draw.SimpleText( "REFRESH","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
		end
		DButton.DoClick = function() 
			DListView:Clear()
			DListView:ResyncListing()
		end
		
			local DButton = vgui.Create( "DButton", DFrame )
		DButton:SetSize( w/4, 30 ); DButton:SetPos( 10, h-40 ); 
		DButton:SetText( "" )
		DButton.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			-- draw.RoundedBox(0,1,1,w-2,h-2,Color(0,150,255))
			if s:IsHovered() then 
				draw.RoundedBox(0,1,1,w-2,h-2,Color(0,200,255))
			else
				draw.RoundedBox(0,1,1,w-2,h-2,Color(0,150,255))
			end
			draw.SimpleText( "REMOVE","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
		end
		DButton.DoClick = function() 
			RunConsoleCommand( "permaall_removeid", tostring(SelectedID) )
			DListView:ResyncListing()
		end
		
		DListView_RefreshListing = DListView
		
	end )
	
	
	local PermaAll_HaloEntities = {}
	net.Receive( "PermaAll.Halo", function( l, p )
		if IsValid(p) then return end
		local e = net.ReadEntity() 
		local c = net.ReadColor() 
		if IsValid(e) and c then PermaAll_HaloEntities[ e ] = c end
	end	)
	
	function PermaAll_CL_Halos()
		local scale = 5
		local falloff = 1
		for e, c in pairs( PermaAll_HaloEntities ) do
			if !IsValid(e) then 
				PermaAll_HaloEntities[ e ] = nil
				continue 
			end
			halo.Add( {e}, c, scale, scale, scale )
			c.r = math.Approach( r or 0, 0, falloff )
			c.g = math.Approach( g or 0, 0, falloff )
			c.b = math.Approach( b or 0, 0, falloff )
			if c.r>0 or c.g>0 or c.b>0 then
				PermaAll_HaloEntities[ e ] = c
			else
				PermaAll_HaloEntities[ e ] = nil
			end
		end		
	end
	hook.Add( "PreDrawHalos", "AddHalos", PermaAll_CL_Halos ) 
	
end

local PermaAllBigNetUid = 0
local PermaAllBigNetString = ""
net.Receive( "PermaAll.Net", function(l,p)
	if IsValid(p) then return end
	
	// COMPRESSED NET MAY BE USING THE BIG NET IDEA SOON
	local l = net.ReadFloat()
	local s = net.ReadData( l )
	local ss = util.Decompress(s)
	local t = util.JSONToTable( ss or "" ) or {}
	if t then PermaAllKeyValues = t end	
	timer.Simple( .05, function() 
		if IsValid(DListView_RefreshListing) then 
			DListView_RefreshListing:RefreshListing() 
		end 
	end )
	if true then return end
	// COMPRESSED NET MAY BE USING THE BIG NET IDEA SOON
	
	// BIG NET IDEA IF WE HIT THE NETWORK LIMIT AGAIN
	// check if the big net string is from the same sync request or clear the data for a new one
	-- local uid = net.ReadFloat()
	-- if PermaAllBigNetUid != uid then 
		-- PermaAllBigNetUid = uid
		-- PermaAllBigNetString = ""
	-- end
	-- print( "[big net] received ("..uid..")" )
	-- // concatinate the new BigNetString to the caches BigNetString
	-- PermaAllBigNetString = PermaAllBigNetString .. (net.ReadString() or "")
	-- print( string.len( PermaAllBigNetString ) )
	-- // after a period of time after the last big net compile the data and output to the vgui
	-- timer.Create( "PermaAllBigNetFinish", 1, 1, function()
		-- local t = util.JSONToTable( PermaAllBigNetString or "" ) or {}
		-- print( PermaAllBigNetString )
		
		-- if t then PermaAllKeyValues = t end	
		-- timer.Simple( .05, function() 
			-- if IsValid(DListView_RefreshListing) then 
				-- DListView_RefreshListing:RefreshListing() 
			-- end 
		-- end )
	-- end )
	// BIG NET IDEA IF WE HIT THE NETWORK LIMIT AGAIN
	
end )



TOOL.Category		= "slaugh7er"
TOOL.Name			= "Perma All"
TOOL.Command		= nil
TOOL.ConfigName		= ""

if CLIENT then
	language.Add("Tool.permaall.name", 		"[PermaAll] Entity Saving Tool" )
	language.Add("Tool.permaall.desc", 		"Save or remove targeted Entities from the perminent table" )
	language.Add("Tool.permaall.left", 		"Save Entity")
	language.Add("Tool.permaall.left_use", 	"Save Entity and all constrained Entities")
	language.Add("Tool.permaall.right", 	"Remove Entity")
	language.Add("Tool.permaall.right_use", "Remove Entity and all constrained Entities")
	language.Add("Tool.permaall.reload", 	"Open Perma Table viewer")
end

TOOL.Information = {
	{ name = "left" },
	{ name = "left_use", icon2 = "gui/e.png" },
	{ name = "right" },
	{ name = "right_use", icon2 = "gui/e.png" },
	{ name = "reload" },
}

if SERVER then
	CreateConVar("sv_perma_log", 0)
end

TOOL.ClientConVar[ "secure1" ] = "0"
TOOL.ClientConVar[ "removeclick" ] = "0"
TOOL.ClientConVar[ "removeclear" ] = "0"

function TOOL:LeftClick( tr )
	if SERVER then 
		Perma_Add( self:GetOwner(), tr.Entity )
	end
	return true
end

function TOOL:RightClick( tr )
	if SERVER then
		Perma_Remove( self:GetOwner(), tr.Entity )
	end
	return true
end

function TOOL:Reload(trace) 
	if SERVER then
		self:GetOwner():ConCommand( "permaall_opentableeditor" )
	end
	return false
end

PermaAllKeyValues = PermaAllKeyValues or {}
function TOOL.BuildCPanel( DForm )
	
	DForm:Help( "" )-- splitter
	local e = DForm:Button( "", "" )
	e.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(255,150,0))
		draw.SimpleText( "CLIENT","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
	end
	
	DForm:CheckBox( "Crosshair information", "perma_all_crosshair_hud" )
	DForm:ControlHelp( "Enable crosshair hud information" )
	
	DForm:CheckBox( "Remove Click", "permaall_removeclick" )
	DForm:ControlHelp( "Remove the targeted object when you un-perma it" )
	
	DForm:CheckBox( "Remove Clear", "permaall_removeclear" )
	DForm:ControlHelp( "Remove All Perma Object Present When You Clear The Perma Table" )
	
	DForm:Help( "" )-- splitter
	DForm:Help( "" )-- splitter
	local e = DForm:Button( "", "" )
	e.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,150,255))
		draw.SimpleText( "SERVER","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
	end
	
	DForm:Button( "Respawn All Permanent Object", "permaall_respawn_all" )
	DForm:ControlHelp( "Respawns all Perma Objects from the table back into the map" )
	
	-- local e = DForm:NumSlider( "Respawn speed scalar", "_permaall_respawn_speed", 1, 10, 0 )
	-- DForm:ControlHelp( "Respawn speed scalar" )
	
	local e = DForm:CheckBox( "Safty Switch", "permaall_secure1" )
	e.OnChange = function() 
		timer.Create("permall.saftyreset",3,1,function() RunConsoleCommand("permaall_secure1", 0) end) 
	end
	DForm:ControlHelp( "Safty toggle before you can clear the Perma Table" )
	
	local e = DForm:Button( "Clear Permanent Table", "permaall_cleartable" )
	e.DoClick = function() 
		timer.Create("permall.saftyreset",1,1,function() RunConsoleCommand("permaall_secure1", 0) end) 
		RunConsoleCommand( "permaall_cleartable" )
	end
	DForm:ControlHelp( "Clears all Perma Object stored in the Perma Table (resetting the whole addon)" )
	
	DForm:Help( "" )-- splitter
	DForm:Help( "" )-- splitter
	local e = DForm:Button( "", "" )
	e.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w/2,h,Color(0,150,255))
		draw.RoundedBox(0,w/2,0,w,h,Color(255,150,0))
		draw.SimpleText( "PERMA TABLE VIEWER","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
	end
	
	DForm:Button( "Open Table Editor", "permaall_opentableeditor" )
	DForm:ControlHelp( "Opens the Perma All table editor" )
	
	
	DForm:Help( "" )-- splitter
	DForm:Help( "" )-- splitter
	local e = DForm:Button( "", "" )
	e.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(50,200,50))
		draw.SimpleText( "IMPORT/ EXPORT","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
	end
	 
	DForm:Button( "Import permaprops", "permaall_import_permaprops" )
	DForm:ControlHelp( "(PermaProps must be installed)" )
	DForm:ControlHelp( "(this doesn't touch anything in PermaProps)" )
	
	
end

CreateClientConVar( "perma_all_crosshair_hud", "1", true, false, "Enable crosshair hud information", 0, 1 )
function TOOL:DrawHUD()
	if !GetConVar( "perma_all_crosshair_hud" ):GetBool() then return end
	local p, w, h = LocalPlayer(), ScrW(), ScrH()
	local tr = p:GetEyeTrace()
	local e = tr.Entity
	if !IsValid(e) then return end
	local b = e:GetNWBool( "IsPermaEntity", false )
	draw.RoundedBoxEx( h*.024, w*.525, h*.46, w*.1, h*.08, Color(0,0,0,200), false, true, false, true )
	draw.SimpleTextOutlined( "PERMANENT", "DermaLarge", w*.53, h*.485, Color(255,255,255), 0, 1, 2, Color(0,0,0,100) )
	local s, c = (b), (b and Color(100,255,100) or Color(255,100,100))
	draw.SimpleTextOutlined( s, "DermaLarge", w*.53, h*.515, c, 0, 1, 2, Color(0,0,0,100) )
end





//////////////////////////////////
// NONE TOOL SPECIFIC CODE BELOW
// NONE TOOL SPECIFIC CODE BELOW
// NONE TOOL SPECIFIC CODE BELOW
//////////////////////////////////


if CLIENT then 
	
	concommand.Add( "permaall_opentableeditor", function()
	
		local DFrame = vgui.Create( "DFrame" )
		DFrame:SetSize( ScrW()*.8, ScrH()*.6 )
		DFrame:SetSize( ScrW()*.8, ScrH()*.6 )
		DFrame:Center()
		DFrame:SetTitle("")
		DFrame:MakePopup()
		
		DFrame.Think = function(s)
			if input.IsKeyDown( KEY_TAB ) then s:Remove() end
		end
		
		DFrame.Paint = function(s,w,h)
			draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0) )
			draw.RoundedBox( 0, 1, 1, w-2, h-2, Color(250,240,230) )
			draw.RoundedBox( 0, w/3, 10, w/3, 40, Color(50,50,50) )
			draw.SimpleText( "PermaAll Editor","DermaLarge",w/2,28,Color(255,255,255),1,1 )
		end
		
		local x,y,w,h = DFrame:GetBounds()
		
		local SelectedID 
		
		local DListView = vgui.Create( "DListView", DFrame )
		DListView:SetPos( 10, 60 )
		DListView:SetSize( w-20, h-150 )
		DListView:AddColumn( "ID" )
		DListView:AddColumn( "GroupID" )
		DListView:AddColumn( "Entity" )
		DListView:AddColumn( "Class" )
		DListView:AddColumn( "Model" )
		DListView:SetMultiSelect( false )
		DListView.ResyncListing = function(s)
			RunConsoleCommand( "PermaAll_RequestSync" )
		end
		DListView.RefreshListing = function(s)
			s.PopulatingListUntil = CurTime() + 1
			timer.Simple( .1, function()
				if !IsValid( s ) then return end
				s:Clear()
				
				-- entities by PermaUID
				local EntsByPermaUID = {}
				for _, e in pairs( ents.GetAll() ) do
					local k = e:GetNWString( "_PermaUID", "" )
					if k != "" then EntsByPermaUID[k] = e end
				end
				-- entities by PermaUID
				
				for k, v in pairs( PermaAllKeyValues ) do
					DListView:AddLine( k, (v.GroupID or ""), tostring(EntsByPermaUID[k] or "none"), (v.Class or ""), (v.Model or "") )
				end
			end )
		end	
		DListView.OnRowSelected = function( s, i, e )
			SelectedID = e:GetColumnText( 1 )
		end 
		DListView.DoDoubleClick = function( s, i, e )
			SelectedID = e:GetColumnText( 1 )
			RunConsoleCommand( "permaall_gotoid", tostring(SelectedID) )
		end 
		DListView.OnRowRightClick = function( s, i, e )
			local uid = e:GetColumnText( 1 )
			local group_uid = e:GetColumnText( 2 )
			local entity = e:GetColumnText( 3 )
			local class = e:GetColumnText( 4 )
			local model = e:GetColumnText( 5 )
			
			local function CopyInfo(s)
				s = tostring(s) or ""
				print( s .. " : copied to clipboard" )
				SetClipboardText( s )
			end
			
			local DMenu = DermaMenu()
				DMenu:AddOption( "Copy UID" ).DoClick = function() CopyInfo(uid) end 
				DMenu:AddOption( "Copy Group UID" ).DoClick = function() CopyInfo(group_uid) end 
				DMenu:AddOption( "Copy Entity" ).DoClick = function() CopyInfo(entity) end 
				DMenu:AddOption( "Copy Entity (index)" ).DoClick = function() CopyInfo(entity:EntIndex()) end 
				DMenu:AddOption( "Copy Class" ).DoClick = function() CopyInfo(class) end 
				DMenu:AddOption( "Copy Model" ).DoClick = function() CopyInfo(model) end 
			DMenu:Open()
		end
		DListView.PaintOver = function(s,w,h)
			if s.PopulatingListUntil and s.PopulatingListUntil>CurTime() then
				draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,200) )
				draw.SimpleText( "Populating List", "DermaLarge", w*.5, h*.47, Color(255,255,255), 1, 1 )
				draw.SimpleText( "Please Wait", "DermaLarge", w*.5, h*.53, Color(255,255,255), 1, 1 )
			end
		end
		DListView:RefreshListing()
		
		local DButton = vgui.Create( "DButton", DFrame )
		DButton:SetSize( w-20, 30 ); DButton:SetPos( 10, h-80 ); 
		DButton:SetText( "" )
		DButton.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			draw.RoundedBox(0,1,1,w/2-2,h-2,Color(0,150,255))
			draw.RoundedBox(0,1+w/2,1,w-2,h-2,Color(255,150,0))
			draw.SimpleText( "ACTIONS","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
		end
		
		local DButton = vgui.Create( "DButton", DFrame )
		DButton:SetSize( w/4, 30 ); DButton:SetPos( w-DButton:GetWide()-10, h-40 ); 
		DButton:SetText( "" )
		DButton.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			if s:IsHovered() then 
				draw.RoundedBox(0,1,1,w-2,h-2,Color(255,200,0))
			else
				draw.RoundedBox(0,1,1,w-2,h-2,Color(255,150,0))
			end	
			-- draw.RoundedBox(0,1,1,w-2,h-2,Color(255,150,0))
			draw.SimpleText( "GOTO","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
		end
		DButton.DoClick = function() 
			RunConsoleCommand( "permaall_gotoid", tostring(SelectedID) )
		end
		
		local DButton = vgui.Create( "DButton", DFrame )
		DButton:SetSize( w/4, 30 ); DButton:SetPos( w/2-DButton:GetWide()/2, h-40 ); 
		DButton:SetText( "" )
		DButton.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			if s:IsHovered() then 
				draw.RoundedBox(0,1,1,w/2-2,h-2,Color(0,200,255))
				draw.RoundedBox(0,1+w/2,1,w-2,h-2,Color(255,200,0))
			else
				draw.RoundedBox(0,1,1,w/2-2,h-2,Color(0,150,255))
				draw.RoundedBox(0,1+w/2,1,w-2,h-2,Color(255,150,0))
			end	
			-- draw.RoundedBox(0,1,1,w-2,h-2,Color(255,150,0))
			draw.SimpleText( "REFRESH","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
		end
		DButton.DoClick = function() 
			DListView:Clear()
			DListView:ResyncListing()
		end
		
			local DButton = vgui.Create( "DButton", DFrame )
		DButton:SetSize( w/4, 30 ); DButton:SetPos( 10, h-40 ); 
		DButton:SetText( "" )
		DButton.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			-- draw.RoundedBox(0,1,1,w-2,h-2,Color(0,150,255))
			if s:IsHovered() then 
				draw.RoundedBox(0,1,1,w-2,h-2,Color(0,200,255))
			else
				draw.RoundedBox(0,1,1,w-2,h-2,Color(0,150,255))
			end
			draw.SimpleText( "REMOVE","Trebuchet24",w/2,h/2,Color(255,255,255),1,1 )
		end
		DButton.DoClick = function() 
			RunConsoleCommand( "permaall_removeid", tostring(SelectedID) )
			DListView:ResyncListing()
		end
		
		DListView_RefreshListing = DListView
		
	end )
	
	
	local PermaAll_HaloEntities = {}
	net.Receive( "PermaAll.Halo", function( l, p )
		if IsValid(p) then return end
		local e = net.ReadEntity() 
		local c = net.ReadColor() 
		if IsValid(e) and c then PermaAll_HaloEntities[ e ] = c end
	end	)
	
	function PermaAll_CL_Halos()
		local scale = 5
		local falloff = 1
		for e, c in pairs( PermaAll_HaloEntities ) do
			if !IsValid(e) then 
				PermaAll_HaloEntities[ e ] = nil
				continue 
			end
			halo.Add( {e}, c, scale, scale, scale )
			c.r = math.Approach( r or 0, 0, falloff )
			c.g = math.Approach( g or 0, 0, falloff )
			c.b = math.Approach( b or 0, 0, falloff )
			if c.r>0 or c.g>0 or c.b>0 then
				PermaAll_HaloEntities[ e ] = c
			else
				PermaAll_HaloEntities[ e ] = nil
			end
		end		
	end
	hook.Add( "PreDrawHalos", "AddHalos", PermaAll_CL_Halos ) 
	
end

local PermaAllBigNetUid = 0
local PermaAllBigNetString = ""
net.Receive( "PermaAll.Net", function(l,p)
	if IsValid(p) then return end
	
	// COMPRESSED NET MAY BE USING THE BIG NET IDEA SOON
	local l = net.ReadFloat()
	local s = net.ReadData( l )
	local ss = util.Decompress(s)
	local t = util.JSONToTable( ss or "" ) or {}
	if t then PermaAllKeyValues = t end	
	timer.Simple( .05, function() 
		if IsValid(DListView_RefreshListing) then 
			DListView_RefreshListing:RefreshListing() 
		end 
	end )
	if true then return end
	// COMPRESSED NET MAY BE USING THE BIG NET IDEA SOON
	
	// BIG NET IDEA IF WE HIT THE NETWORK LIMIT AGAIN
	// check if the big net string is from the same sync request or clear the data for a new one
	-- local uid = net.ReadFloat()
	-- if PermaAllBigNetUid != uid then 
		-- PermaAllBigNetUid = uid
		-- PermaAllBigNetString = ""
	-- end
	-- print( "[big net] received ("..uid..")" )
	-- // concatinate the new BigNetString to the caches BigNetString
	-- PermaAllBigNetString = PermaAllBigNetString .. (net.ReadString() or "")
	-- print( string.len( PermaAllBigNetString ) )
	-- // after a period of time after the last big net compile the data and output to the vgui
	-- timer.Create( "PermaAllBigNetFinish", 1, 1, function()
		-- local t = util.JSONToTable( PermaAllBigNetString or "" ) or {}
		-- print( PermaAllBigNetString )
		
		-- if t then PermaAllKeyValues = t end	
		-- timer.Simple( .05, function() 
			-- if IsValid(DListView_RefreshListing) then 
				-- DListView_RefreshListing:RefreshListing() 
			-- end 
		-- end )
	-- end )
	// BIG NET IDEA IF WE HIT THE NETWORK LIMIT AGAIN
	
end )


