ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Chips - Doritos - Cool Ranch"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A bag of Chips (Crisps if ya from Blighty)"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/ChipsDoritos5.mdl")
	
end