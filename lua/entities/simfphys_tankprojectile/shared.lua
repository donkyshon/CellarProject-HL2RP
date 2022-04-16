ENT.Type            = "anim"


ENT.PrintName = "tank projectile"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "simfphys Armed Vehicles"

ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:SetupDataTables()
	self:NetworkVar( "String",1, "BlastEffect" )
	self:NetworkVar( "Float",1, "Size" )
end

