ENT.Spawnable		            	=	false
ENT.AdminSpawnable		            =	false

ENT.PrintName		                =	"Gredwitch's Shell base"
ENT.Author			                =	"Gredwitch"
ENT.Contact			                =	"contact.gredwitch@gmail.com"
ENT.Category                        =	"Gredwitch's Stuff"
ENT.Base							=	"base_rocket"

ENT.Model							=	"models/gredwitch/bombs/75mm_shell.mdl"
ENT.IsShell							=	true
ENT.MuzzleVelocity					=	0
ENT.Caliber							=	0
ENT.RSound							=	0
ENT.ShellType						=	""
ENT.EffectWater						=	"ins_water_explosion"
ENT.Normalization					=	0
ENT.NextUse 						=	0
ENT.Mass							=	1

ENT.TRACERCOLOR_TO_INT = {
	["white"] = 1,
	["red"] = 2,
	["green"] = 3,
	["blue"] = 4,
	["yellow"] = 5,
}
ENT.TRACERCOLOR_TO_VECTOR = {
	Vector(255,255,255),
	Vector(255,0,0),
	Vector(0,255,0),
	Vector(0,0,255),
	Vector(255,255,255),
}



function ENT:SetupDataTables()
	self:NetworkVar("Bool",0,"Fired")
	self:NetworkVar("String",0,"ShellType")
	self:NetworkVar("Int",0,"TracerColor")
	self:NetworkVar("Int",1,"Caliber")
end
