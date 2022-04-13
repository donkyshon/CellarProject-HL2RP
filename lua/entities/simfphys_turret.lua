AddCSLuaFile()

DEFINE_BASECLASS( "base_wire_entity" )

ENT.PrintName		= "Turret"
ENT.WireDebugName = "simfphys Turret"
ENT.Author		= "Blu"
ENT.Information		= "Fires simfphys-Projectiles"
ENT.Category		= "simfphys"

ENT.Spawnable       = false
ENT.AdminSpawnable  = false

ENT.Editable = true

ENT.ValidHitEffects = {
	["Small_Explosion"] = "simfphys_tankweapon_explosion_micro",
	["Normal_Explosion"] = "simfphys_tankweapon_explosion_small",
	["Large_Explosion"] = "simfphys_tankweapon_explosion",
}

ENT.FXToRadius = {
	["simfphys_tankweapon_explosion"] = 300,
	["simfphys_tankweapon_explosion_micro"] = 50,
	["simfphys_tankweapon_explosion_small"] = 150,
}

function ENT:SetupDataTables()
	
	local Options = {}
	
	for i, v in pairs( self.ValidHitEffects ) do
		Options[i] = v
	end
	
	self:NetworkVar( "Float",1, "ShootDelay", { KeyName = "Shoot Delay", Edit = { type = "Float", order = 1,min = 0.2, max = 2, category = "Options"} } )
	self:NetworkVar( "Float",2, "Damage", { KeyName = "Damage", Edit = { type = "Float", order = 2,min = 0, max = 5000, category = "Options"} } )
	self:NetworkVar( "Float",3, "Force", { KeyName = "Force", Edit = { type = "Float", order = 3,min = 0, max = 10000, category = "Options"} } )
	self:NetworkVar( "Float",4, "Size", { KeyName = "Size", Edit = { type = "Float", order = 4,min = 3, max = 15, category = "Options"} } )
	self:NetworkVar( "Float",5, "DeflectAng", { KeyName = "DeflectAng", Edit = { type = "Float", order = 5,min = 0, max = 45, category = "Options"} } )
	self:NetworkVar( "Float",6, "BlastDamage", { KeyName = "Blast Damage", Edit = { type = "Float", order = 6,min = 0, max = 1500, category = "Options"} } )
	self:NetworkVar( "String",1, "BlastEffect",{ KeyName = "Blast Effect",Edit = { type = "Combo",	order = 7,values = Options,category = "Options"} } )

	if SERVER then
		self:SetShootDelay( 0.2 )
		self:SetDamage( 100 )
		self:SetForce( 50 )
		self:SetSize( 3 )
		self:SetDeflectAng( 40 )
		self:SetBlastDamage( 50 )
		self:SetBlastEffect( "simfphys_tankweapon_explosion_micro" )
	end
end

if CLIENT then return end

function ENT:SpawnFunction( ply, tr, ClassName )

	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.Attacker = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 5 )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:TriggerInput( name, value )
	if name == "Fire" then
		self.TriggerFire = value >= 1
	end
end

function ENT:Initialize()	
	self:SetModel( "models/props_junk/PopCan01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON  ) 
	
	self:PhysWake()
	
	self.Inputs = WireLib.CreateInputs( self,{"Fire"} )
end

function ENT:SetNextShoot( time )
	self.NextShoot = time
end

function ENT:CanShoot()
	if not self.TriggerFire then return false end
	
	self.NextShoot = self.NextShoot or 0
	
	return self.NextShoot < CurTime()
end

function ENT:Shoot()
	if not self:CanShoot() then return end

	local projectile = {}
		projectile.filter = {self}
		projectile.shootOrigin = self:GetPos()
		projectile.shootDirection = self:GetUp()
		projectile.attacker = IsValid( self.Attacker ) and self.Attacker or self
		projectile.attackingent = self
		projectile.Damage = self:GetDamage()
		projectile.Force = self:GetForce()
		projectile.Size = self:GetSize()
		projectile.DeflectAng = self:GetDeflectAng()
		projectile.BlastRadius = self.FXToRadius[ self:GetBlastEffect() ] or 0
		projectile.BlastDamage = self:GetBlastDamage()
		projectile.BlastEffect = self:GetBlastEffect()
	simfphys.FirePhysProjectile( projectile )
	
	self:SetNextShoot( CurTime() + self:GetShootDelay() )
end

function ENT:Think()	

	self.BaseClass.Think( self )
	
	self:Shoot()

	self:NextThink( CurTime() )
	
	return true
end