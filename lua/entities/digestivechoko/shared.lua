ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Digestives Chocolate"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A pack of chocolate Digestives"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/Digestive1.mdl")
	
end