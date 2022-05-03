local function GetTrackPos( ent, div, smoother )
	local FT =  FrameTime()
	local spin_left = ent.trackspin_l and (-ent.trackspin_l / div) or 0
	local spin_right = ent.trackspin_r and (-ent.trackspin_r / div) or 0

	ent.sm_TrackDelta_L = ent.sm_TrackDelta_L and (ent.sm_TrackDelta_L + (spin_left - ent.sm_TrackDelta_L) * smoother) or 0
	ent.sm_TrackDelta_R = ent.sm_TrackDelta_R and (ent.sm_TrackDelta_R + (spin_right- ent.sm_TrackDelta_R) * smoother) or 0

	return {Left = ent.sm_TrackDelta_L,Right = ent.sm_TrackDelta_R}
end

local function UpdateTrackScrollTexture( ent )
	local id = ent:EntIndex()

	if not ent.wheel_left_mat then
		ent.wheel_left_mat = CreateMaterial(ent.TrackID .. "trackmat_" .. id .. "_left", "VertexLitGeneric", { ["$basetexture"] = ent.TrackTexture, ["$alphatest"] = "1", ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end

	if not ent.wheel_right_mat then
		ent.wheel_right_mat = CreateMaterial(ent.TrackID .. "trackmat_" .. id .. "_right", "VertexLitGeneric", { ["$basetexture"] = ent.TrackTexture, ["$alphatest"] = "1", ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end

	local TrackPos = GetTrackPos( ent, ent.TrackDiv, ent.TrackMult )

	ent.wheel_left_mat:SetVector("$translate", Vector(0,TrackPos.Left,0) )
	ent.wheel_right_mat:SetVector("$translate", Vector(0,TrackPos.Right,0) )

	ent:SetSubMaterial( ent.LeftTrackSubMatIndex or 1, "!" .. ent.TrackID .. "trackmat_" .. id .. "_left" )
	ent:SetSubMaterial( ent.RightTrackSubMatIndex or 2, "!" .. ent.TrackID .. "trackmat_" .. id .. "_right" )
end

local function UpdateTracks()
	for i, ent in pairs( ents.FindByClass( "gmod_sent_vehicle_fphysics_base" ) ) do
		if ent.TrackID then
			UpdateTrackScrollTexture(ent)
		end
	end
end 

hook.Add( "Think", "avx_ins1_manage_tanks", function()
	UpdateTracks()
end )

net.Receive( "avx_ins1_register_tank", function( length )
	local ent = net.ReadEntity()
	local type = net.ReadString()

	if not IsValid( ent ) then return end

	if type == "bredley" then
		ent.TrackID = "bredley"
		ent.TrackTexture = "models/kali/vehicles/cod4/bradley/vehicle_bradley_track_col"
		ent.TrackDiv = -260
		ent.TrackMult = 0.25
		ent.LeftTrackSubMatIndex = 3
		ent.RightTrackSubMatIndex = 4
	end
end)