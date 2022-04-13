AddCSLuaFile()

DEFINE_BASECLASS( "base_shell" )

local CloseExploSnds = {}
CloseExploSnds[1]                         =  "explosions/artillery_strike_gas_close_01.wav"
CloseExploSnds[2]                         =  "explosions/artillery_strike_gas_close_02.wav"
CloseExploSnds[3]                         =  "explosions/artillery_strike_gas_close_03.wav"
CloseExploSnds[4]                         =  "explosions/artillery_strike_gas_close_04.wav"

local ExploSnds = {}
ExploSnds[1]                         =  "explosions/doi_wp_01.wav"
ExploSnds[2]                         =  "explosions/doi_wp_02.wav"
ExploSnds[3]                         =  "explosions/doi_wp_03.wav"
ExploSnds[4]                         =  "explosions/doi_wp_04.wav"

ENT.Spawnable		            	 =  false         
ENT.AdminSpawnable		             =  false 

ENT.PrintName		                 =  "[SHELLS]Gas Shell"
ENT.Author			                 =  "Gredwitch"
ENT.Contact			                 =  "contact.gredwitch@gmail.com"
ENT.Category                         =  "Gredwitch's Stuff"
ENT.Model                            =  "models/gredwitch/bombs/75mm_shell.mdl"
ENT.Mass                             =  105

ENT.Effect                           =  "doi_GASarty_explosion"
ENT.EffectAir                        =  "doi_GASarty_explosion"
ENT.EffectWater                      =  "ins_water_explosion"
ENT.AngEffect						 =	true


ENT.ExplosionSound                   =  table.Random(CloseExploSnds)
ENT.FarExplosionSound				 =  table.Random(ExploSnds)
ENT.DistExplosionSound				 =  table.Random(ExploSnds)

ENT.RSound   						 =  0

ENT.ShouldUnweld                     =  false
ENT.ShouldIgnite                     =  false
ENT.SmartLaunch                      =  true
ENT.Timed                            =  false

ENT.APDamage						 =  150
ENT.ExplosionDamage                  =  30
ENT.EnginePower                      =  100
ENT.ExplosionRadius                  =  350
ENT.ModelSize						 =	1.2


function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
	self.GBOWNER = ply
    local ent = ents.Create( self.ClassName )
	ent:SetPhysicsAttacker(ply)
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
    ent:Spawn()
    ent:Activate()
	
	
	ent.ExplosionSound	= table.Random(CloseExploSnds)
	ent.FarExplosionSound	= table.Random(ExploSnds)
	ent.DistExplosionSound	= table.Random(ExploSnds)

    return ent
end

function ENT:AddOnExplode(pos)
	local ent = ents.Create("base_gas")
	ent:SetPos(pos)
	ent.Radius	 = 600
	ent.Rate  	 = 0.3
	ent.Lifetime = 18
	ent:Spawn()
	ent:Activate()
	ent:SetVar("GBOWNER",self.GBOWNER)
end