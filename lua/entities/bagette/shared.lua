ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Baguette"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A french baguette"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/bagette.mdl")
	
end