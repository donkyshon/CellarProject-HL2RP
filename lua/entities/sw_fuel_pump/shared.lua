ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName = "Fuel pump"
ENT.Author = "Shermann Wolf"
ENT.Category = "[LFS]"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Editable = false

ENT.RefuelAmount = 1
ENT.Radius = 500

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "Radius", { KeyName = "radius", Edit = { type = "Float", order = 1,min = 0, max = 5000, category = "Area"} } )
	self:NetworkVar( "Float", 1, "RefuelAmount", { KeyName = "refuelamount", Edit = { type = "Float", order = 2,min = 0, max = 10000, category = "Refueling"} } )

	if SERVER then
		self:SetRefuelAmount( self.RefuelAmount )
		self:SetRadius( self.Radius )
	end
end