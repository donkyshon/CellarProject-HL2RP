AddCSLuaFile()

timer.Simple(1,function()
	if !simfphys then print ("[LFS AH-64] LFS IS MISSING !") return end
	if !simfphys.LFS then print ("[LFS AH-64] LFS IS MISSING !") return end
	if !simfphys.LFS.AddKey then print ("[LFS AH-64] LFS IS NOT UP TO DATE!") return end 
	local DEFAULT_KEYS = {
		{name = "TOGGLECAMERA",		class = "misc",		name_menu = "Toggle Camera",			default = KEY_V,	cmd = "cl_lfs_togglecamera",	IN_KEY = 0},
		{name = "ZOOMINCAMERA",		class = "misc",		name_menu = "Camera Zoom In",			default = KEY_G,	cmd = "cl_lfs_camerazoomin",	IN_KEY = 0},
		{name = "ZOOMOUTCAMERA",	class = "misc",		name_menu = "Camera Zoom Out",			default = KEY_H,	cmd = "cl_lfs_camerazoomout",	IN_KEY = 0},
		{name = "POINTCAMERA",		class = "misc",		name_menu = "Camera Point",				default = KEY_K,	cmd = "cl_lfs_camerapoint",		IN_KEY = 0},
		{name = "FLIRCAMERA",		class = "misc",		name_menu = "Toggle Camera FLIR",		default = KEY_N,	cmd = "cl_lfs_cameraflir",		IN_KEY = 0},
	}
	for _,v in pairs(DEFAULT_KEYS) do
		simfphys.LFS:AddKey(v.name,v.class,v.name_menu,v.default,v.cmd,v.IN_KEY)
	end

if SERVER then
	util.AddNetworkString("gred_apache_reset_pointpos")
	util.AddNetworkString("gred_apache_pointpos")
	util.AddNetworkString("gred_apache_pointpos_rem")
	util.AddNetworkString("gred_apache_request_pointpos")
	util.AddNetworkString("gred_apache_tail")
	util.AddNetworkString("gred_apache_request_tail")
	util.AddNetworkString("gred_apache_tail_destroyed")
	util.AddNetworkString("gred_apache_aitarget")
	util.AddNetworkString("gred_apache_rotor_destroyed")
	
	net.Receive("gred_apache_pointpos",function()
		net.ReadEntity().PointPos = net.ReadVector()
	end)
	net.Receive("gred_apache_pointpos_rem",function()
		net.ReadEntity().PointPos = nil
	end)
	net.Receive("gred_apache_request_tail",function()
		local self = net.ReadEntity()
		net.Start("gred_apache_tail")
			net.WriteEntity(self)
			net.WriteEntity(self.Tail)
		net.Broadcast()
	end)
	net.Receive("gred_apache_reset_pointpos",function()
		local self = net.ReadEntity()
		self.PointPos = nil
		self.ControlInput.LockCamera = false
		self.ControlInput.ToggleFreeview = false
	end)
else
	CreateClientConVar("gred_cl_lfs_apache_enable_screens",1)
	local CVar = GetConVar("gred_cl_lfs_apache_enable_screens")
	
	hook.Add("RenderScene","gred_apache_render_screens",function(pos,ang,fov)
		local ply = LocalPlayer()
		if !ply.lfsGetPlane then return end
		local vehicle = ply:lfsGetPlane()
		if !IsValid(vehicle) then return end
		if vehicle.ClassName != "gred_lfs_ah64" then return end
		if CVar:GetInt() != 1 then return end
		vehicle:RenderScreens(pos,ang,fov)
	end)
	
	net.Receive("gred_apache_tail_destroyed",function()
		local self = net.ReadEntity()
		local tail = net.ReadEntity()
		if tail != nil then tail:SetBodygroup(0,0) end
		self.TailDestroyed = true
		self.Tail = nil
		self:SetNWEntity("Tail",nil)
	end)
	
	net.Receive("gred_apache_rotor_destroyed",function()
		local self = net.ReadEntity()
		self.TailRotorDestroyed = !self.TailRotorDestroyed
	end)
	
	net.Receive("gred_apache_aitarget",function()
		net.ReadEntity().AITarget = net.ReadEntity()
	end)
	
	net.Receive("gred_apache_tail",function()
		local self = net.ReadEntity()
		self:SetNWEntity("Tail",net.ReadEntity())
	end)
	
	net.Receive("gred_apache_request_pointpos",function()
		local self = net.ReadEntity()
		if not self.PointPos then return end
		
		net.Start("gred_apache_pointpos")
			net.WriteEntity(self)
			net.WriteVector(self.PointPos)
		net.SendToServer()
	end)
end
end)

sound.Add( 	{
	name = "LFS_PART_DESTROYED_01",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 130,
	sound = "gredwitch/common/plane_explosion_1.wav"
} )
sound.Add( 	{
	name = "LFS_PART_DESTROYED_02",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 130,
	sound = "gredwitch/common/plane_explosion_2.wav"
} )
sound.Add( 	{
	name = "LFS_PART_DESTROYED_03",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 130,
	sound = "gredwitch/common/plane_explosion_3.wav"
} )
sound.Add( {
	name = "AH64_CLOSE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 120,
	pitch = {100},
	sound = "^gredwitch/ah64_lfs/ah64_close.wav"
} )
sound.Add( {
	name = "AH64_FAR",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = {100},
	sound = "^gredwitch/ah64_lfs/ah64_far.wav"
} )
sound.Add( {
	name = "M230_CLOSE",
	channel = CHAN_STATIC, --,
	volume = 1.0,
	level = 120,
	pitch = {100},
	sound = "^gredwitch/ah64_lfs/m230_close.wav"
} )
sound.Add( {
	name = "M230_CLOSE_STOP",
	channel = CHAN_STATIC, --,
	volume = 1.0,
	level = 120,
	pitch = {100},
	sound = "^gredwitch/ah64_lfs/m230_close_stop.wav"
} )
sound.Add( {
	name = "M230_FAR",
	channel = CHAN_STATIC, --,
	volume = 1.0,
	level = 140,
	pitch = {100},
	sound = "^gredwitch/ah64_lfs/m230_close.wav"
} )
sound.Add( {
	name = "M230_FAR_STOP",
	channel = CHAN_STATIC, --,
	volume = 1.0,
	level = 140,
	pitch = {100},
	sound = "^gredwitch/ah64_lfs/m230_close_stop.wav"
} )
sound.Add( {
	name = "M230_CAM_STOP",
	channel = CHAN_STATIC, --,
	volume = 1.0,
	level = 0,
	pitch = {100},
	sound = "gredwitch/ah64_lfs/m230_cam_stop.wav"
} )
sound.Add( {
	name = "M230_CAM",
	channel = CHAN_STATIC, --,
	volume = 1.0,
	level = 0,
	pitch = {100},
	sound = "gredwitch/ah64_lfs/m230_cam.wav"
} )
sound.Add( {
	name = "FIRE_HELLFIRE",
	channel = CHAN_STATIC, --,
	volume = 1.0,
	level = 130,
	pitch = {100},
	sound = "^gredwitch/common/hellfire.wav"
} )
sound.Add( {
	name = "BEEP_CRASH",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {100},
	sound = "crash/bip_loop.wav"
} )
for i = 1,10 do
sound.Add( {
	name = "HELICOPTER_CRASHING_"..i,
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = {100},
	sound = "crash/crash_"..i..".ogg"
} )
end