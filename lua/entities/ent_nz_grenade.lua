AddCSLuaFile()

if SERVER then
ENT.Base = "nz_projectile_base"
end

ENT.Type = "anim"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.PrintName		= "Grenade"
ENT.Category 		= ""

ENT.Model = "models/weapons/w_grenade.mdl"

if SERVER then
	function ENT:Initialize()
	 
		self:SetModel( self.Model )
		
		self:SetHealth( 999999 )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
			local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion( true )
		end
		
	end
end

function ENT:OnInjured(dmginfo)
	dmginfo:ScaleDamage(0)
end
		
function ENT:Explode()
		
	if !self:GetOwner():IsValid() then return end
	if self:Health() < 0 then return end
	
	util.BlastDamage( self, self:GetOwner(), self:GetPos(), 155, 20 )
	
end	
		
function ENT:PhysicsCollide(data, physobj)
	if self:IsValid() then
		if SERVER then
			
		local explode = ents.Create("env_explosion")
		explode:SetPos( self:GetPos() )
		explode:Spawn()
		explode:SetKeyValue( "iMagnitude", 0 )
		explode:SetOwner(self:GetOwner())	
		explode:Fire( "Explode", 1, 0 )	
		
		self:Explode()
		
		SafeRemoveEntity( self )
		end
	end
end	

AddCSLuaFile()

if SERVER then
ENT.Base = "nz_projectile_base"
end

ENT.Type = "anim"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.PrintName		= "Grenade"
ENT.Category 		= ""

ENT.Model = "models/weapons/w_grenade.mdl"

if SERVER then
	function ENT:Initialize()
	 
		self:SetModel( self.Model )
		
		self:SetHealth( 999999 )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
			local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion( true )
		end
		
	end
end

function ENT:OnInjured(dmginfo)
	dmginfo:ScaleDamage(0)
end
		
function ENT:Explode()
		
	if !self:GetOwner():IsValid() then return end
	if self:Health() < 0 then return end
	
	util.BlastDamage( self, self:GetOwner(), self:GetPos(), 155, 20 )
	
end	
		
function ENT:PhysicsCollide(data, physobj)
	if self:IsValid() then
		if SERVER then
			
		local explode = ents.Create("env_explosion")
		explode:SetPos( self:GetPos() )
		explode:Spawn()
		explode:SetKeyValue( "iMagnitude", 0 )
		explode:SetOwner(self:GetOwner())	
		explode:Fire( "Explode", 1, 0 )	
		
		self:Explode()
		
		SafeRemoveEntity( self )
		end
	end
end	
