-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT
-- DO NOT EDIT OR REUPLOAD THIS SCRIPT

local HintPlayerAboutHisFuckingIncompetence = true

hook.Add( "CalcView", "zz_simfphys_gunner_view", function( ply, pos, ang )
	HintPlayerAboutHisFuckingIncompetence = false

	if not IsValid( ply ) or not ply:Alive() or not ply:InVehicle() or ply:GetViewEntity() ~= ply then return end
	
	local Vehicle = ply:GetVehicle()
	
	if not IsValid( Vehicle ) then return end
	
	local Base = ply.GetSimfphys and ply:GetSimfphys() or Vehicle.vehiclebase
	
	if not IsValid( Base ) then return end
	
	if not Vehicle:GetNWBool( "simfphys_SpecialCam" ) then return end
	
	local view = {
		origin = pos,
		drawviewer = false,
	}
	
	if Vehicle:GetNWBool( "SpecialCam_LocalAngles" ) then
		view.angles = ply:EyeAngles()
	else
		view.angles = Vehicle:LocalToWorldAngles( ply:EyeAngles() )
	end
	
	if Vehicle.GetThirdPersonMode == nil or ply:GetViewEntity() ~= ply then
		return
	end
	
	ply.simfphys_smooth_out = 0
	
	local offset = Vehicle:GetNWVector( "SpecialCam_Thirdperson" )
	
	if not Vehicle:GetThirdPersonMode() then
		local offset = Vehicle:GetNWVector( "SpecialCam_Firstperson" )
		local ID = Base:LookupAttachment( Vehicle:GetNWString( "SpecialCam_Attachment" ) )
		
		if ID == 0 then
			view.origin = view.origin + Vehicle:GetForward() * offset.x + Vehicle:GetRight() * offset.y + Vehicle:GetUp() * offset.z
		else
			local attachment = Base:GetAttachment( ID )
			
			view.origin = attachment.Pos + attachment.Ang:Forward() * offset.x  + attachment.Ang:Right() * offset.y  + attachment.Ang:Up() *  offset.z
		end
		
		return view
	end
	
	view.origin = view.origin + Vehicle:GetForward() * offset.x + Vehicle:GetRight() * offset.y + Vehicle:GetUp() * offset.z
	
	local mn, mx = Vehicle:GetRenderBounds()
	local radius = ( mn - mx ):Length()
	local radius = radius + radius * Vehicle:GetCameraDistance()

	local TargetOrigin = view.origin + ( view.angles:Forward() * -radius )
	local WallOffset = 4

	local tr = util.TraceHull( {
		start = view.origin,
		endpos = TargetOrigin,
		filter = function( e )
			local c = e:GetClass()
			local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" )
			return collide
		end,
		mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
		maxs = Vector( WallOffset, WallOffset, WallOffset ),
	} )

	view.origin = tr.HitPos
	view.drawviewer = true

	if tr.Hit and not tr.StartSolid then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end
	
	return view
end )

surface.CreateFont( "SCRUBNOTE_FONT", {
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

hook.Add( "HUDPaint", "zz_simfphys_brokencam_hint", function()
	if not HintPlayerAboutHisFuckingIncompetence then return end
	
	local ply = LocalPlayer()
	
	if not ply:InVehicle() then return end
	if ply:GetViewEntity() ~= ply then return end
	
	local Pod = ply:GetVehicle()
	
	if not IsValid( Pod ) then return end
	
	local Base = ply.GetSimfphys and ply:GetSimfphys() or Pod.vehiclebase
	
	if not IsValid( Base ) then return end
	if not Pod:GetNWBool( "simfphys_SpecialCam" ) then return end

	if not Base.ERRORSOUND then
		surface.PlaySound( "error.wav" )
		Base.ERRORSOUND = true
	end
	
	local X = ScrW()
	local Y = ScrH()
	local HintCol = Color(255,0,0, 255 )
	
	surface.SetDrawColor( 0, 0, 0, 250 )
	surface.DrawRect( 0, 0, X, Y ) 
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	draw.SimpleText( "OOPS! SOMETHING WENT WRONG :( ", "SCRUBNOTE_FONT", X * 0.5, Y * 0.5 - 40, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( "ONE OF YOUR ADDONS IS BREAKING THE CALCVIEW HOOK. TANK TURRET WILL NOT BE USEABLE", "SCRUBNOTE_FONT", X * 0.5, Y * 0.5 - 20, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( "HOW TO FIX?", "SCRUBNOTE_FONT", X * 0.5, Y * 0.5 + 20, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( "DISABLE ALL ADDONS THAT COULD POSSIBLY MESS WITH THE CAMERA-VIEW", "SCRUBNOTE_FONT", X * 0.5, Y * 0.5 + 40, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( "(THIRDPERSON ADDONS OR SIMILAR)", "SCRUBNOTE_FONT", X * 0.5, Y * 0.5 + 60, HintCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	draw.SimpleText( ">>PRESS YOUR USE-KEY TO LEAVE THE VEHICLE & HIDE THIS MESSAGE<<", "SCRUBNOTE_FONT", X * 0.5, Y * 0.5 + 120, Color(255,0,0, math.abs( math.cos( CurTime() ) * 255) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end )
