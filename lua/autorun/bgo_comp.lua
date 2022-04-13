AddCSLuaFile("autorun/bgo_comp.lua")

if file.Exists( "autorun/bgo_autorun_sh.lua", "LUA" ) then
	SetGlobalBool( "nb_use_ragdolls", true )
	print( "NB 2.0 using BGO" )
else
	SetGlobalBool( "nb_use_ragdolls", false )
	print( "NB 2.0 NOT using BGO" )
end