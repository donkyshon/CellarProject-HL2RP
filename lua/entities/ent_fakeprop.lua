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
		
		local phys = self:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion( true )
				phys:EnableGravity( true )
				phys:Wake()
			end
		
			timer.Simple(8, function() 
				if ( self:IsValid() ) then 
				
				local sounds = {}
					sounds[1] = ("physics/wood/wood_furniture_break1.wav")
					sounds[2] = ("physics/wood/wood_furniture_break2.wav")
					self:EmitSound( sounds[math.random(1,2)] )	
				
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
		
		local phys = self:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion( true )
				phys:EnableGravity( true )
				phys:Wake()
			end
		
			timer.Simple(8, function() 
				if ( self:IsValid() ) then 
				
				local sounds = {}
					sounds[1] = ("physics/wood/wood_furniture_break1.wav")
					sounds[2] = ("physics/wood/wood_furniture_break2.wav")
					self:EmitSound( sounds[math.random(1,2)] )	
				
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
