AddCSLuaFile()

ENT.Type = "anim"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false



--stats
ENT.PrintName		= "Prop"
ENT.Category 		= ""

ENT.Model = ("")

if SERVER then

	function ENT:Initialize()
	
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		
		local phys = self:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion( true )
				phys:EnableGravity( true )
				phys:Wake()
			end
		
			timer.Simple(8, function() 
				if ( self:IsValid() ) then 

					SafeRemoveEntity( self )
				end
			end)
		
		
	end
	
end

function ENT:Think()
end

if CLIENT then

	function ENT:Draw()
		self:DrawModel()
	end
	
end
