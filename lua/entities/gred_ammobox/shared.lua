ENT.Type 							= "anim"
ENT.Spawnable		            	=	true
ENT.AdminSpawnable		            =	true

ENT.PrintName		                =	"[OTHERS]Ammo box"
ENT.Author			                =	"Gredwitch"
ENT.Contact			                =	"contact.gredwitch@gmail.com"
ENT.Category                        =	"Gredwitch's Stuff"
ENT.Model                         	=	"models/Items/ammocrate_smg1.mdl"

ENT.Opened							= 	false
ENT.NextUse							=	0
ENT.Life							=	300
ENT.CurLife							=	ENT.Life
ENT.Attacker						=	nil

ENT.ExplosionDamage					=	1000
ENT.ExplosionRadius					=	1000

ENT.ExplosionSound 					=	"explosions/cache_explode.wav"
ENT.FarExplosionSound 				=	"explosions/cache_explode_distant.wav"
ENT.DistExplosionSound 				=	"explosions/cache_explode_far_distant.wav"
ENT.AdminOnly						=	true
ENT.Editable						=	true
ENT.AutomaticFrameAdvance 			= 	true
ENT.DEFAULT_PHYSFORCE               = 	50
ENT.DEFAULT_PHYSFORCE_PLYAIR        = 	500
ENT.DEFAULT_PHYSFORCE_PLYGROUND     = 	5000

function ENT:SetupDataTables()
	self:NetworkVar("Bool",0,"Invincible", {KeyName = "Invincible", Edit = { type = "Boolean", category = "Logistic"}})
	-- self:NetworkVar("Float",0,"Life")
	-- if SERVER then
		-- self:SetLife(self.Life)
	-- end
end