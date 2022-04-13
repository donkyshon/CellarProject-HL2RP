AddCSLuaFile()
local DEFAULT_KEYS = {
	{name = "CAMERA",		class = "misc",		name_menu = "Camera",			default = KEY_O,	cmd = "sw_lfs_camera",	IN_KEY = 0},
	{name = "ZOOM",		class = "misc",		name_menu = "Camera Zoom",			default = KEY_P,	cmd = "sw_lfs_camerazoom",	IN_KEY = 0},
	{name = "FLIR",		class = "misc",		name_menu = "Camera FLIR",		default = KEY_K,	cmd = "sw_lfs_cameraflir",		IN_KEY = 0},
	{name = "GEAR",		class = "misc",		name_menu = "Landing gear",		default = KEY_G,	cmd = "sw_lfs_gear",		IN_KEY = 0},
	{name = "DOORS",		class = "misc",		name_menu = "Close/open doors",		default = KEY_L,	cmd = "sw_lfs_doors",		IN_KEY = 0},
	{name = "BAIL",		class = "misc",		name_menu = "Bail out",		default = KEY_N,	cmd = "sw_lfs_bail",		IN_KEY = 0},
	{name = "WEAPON",		class = "misc",		name_menu = "Switch weapon",		default = KEY_F,	cmd = "sw_lfs_weapon",		IN_KEY = 0},
	{name = "FLARE",		class = "misc",		name_menu = "Flare",		default = KEY_M,	cmd = "sw_lfs_flare",		IN_KEY = 0},
	{name = "PARACHUTE",		class = "misc",		name_menu = "Barke parachute",		default = KEY_I,	cmd = "sw_lfs_bparachute",		IN_KEY = 0},
	{name = "RADARMODE",		class = "misc",		name_menu = "Radar mode switch",		default = KEY_PAD_PLUS,	cmd = "sw_lfs_radarmode",		IN_KEY = 0},
}
for _,v in pairs(DEFAULT_KEYS) do
	simfphys.LFS:AddKey(v.name,v.class,v.name_menu,v.default,v.cmd,v.IN_KEY)
end
AddCSLuaFile()
local DEFAULT_KEYS = {
	{name = "CAMERA",		class = "misc",		name_menu = "Camera",			default = KEY_O,	cmd = "sw_lfs_camera",	IN_KEY = 0},
	{name = "ZOOM",		class = "misc",		name_menu = "Camera Zoom",			default = KEY_P,	cmd = "sw_lfs_camerazoom",	IN_KEY = 0},
	{name = "FLIR",		class = "misc",		name_menu = "Camera FLIR",		default = KEY_K,	cmd = "sw_lfs_cameraflir",		IN_KEY = 0},
	{name = "GEAR",		class = "misc",		name_menu = "Landing gear",		default = KEY_G,	cmd = "sw_lfs_gear",		IN_KEY = 0},
	{name = "DOORS",		class = "misc",		name_menu = "Close/open doors",		default = KEY_L,	cmd = "sw_lfs_doors",		IN_KEY = 0},
	{name = "BAIL",		class = "misc",		name_menu = "Bail out",		default = KEY_N,	cmd = "sw_lfs_bail",		IN_KEY = 0},
	{name = "WEAPON",		class = "misc",		name_menu = "Switch weapon",		default = KEY_F,	cmd = "sw_lfs_weapon",		IN_KEY = 0},
	{name = "FLARE",		class = "misc",		name_menu = "Flare",		default = KEY_M,	cmd = "sw_lfs_flare",		IN_KEY = 0},
	{name = "PARACHUTE",		class = "misc",		name_menu = "Barke parachute",		default = KEY_I,	cmd = "sw_lfs_bparachute",		IN_KEY = 0},
	{name = "RADARMODE",		class = "misc",		name_menu = "Radar mode switch",		default = KEY_PAD_PLUS,	cmd = "sw_lfs_radarmode",		IN_KEY = 0},
}
for _,v in pairs(DEFAULT_KEYS) do
	simfphys.LFS:AddKey(v.name,v.class,v.name_menu,v.default,v.cmd,v.IN_KEY)
end