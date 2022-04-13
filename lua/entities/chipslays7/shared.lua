ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Chips - Lays - BBQ"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A bag of Lays"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/chipslays7.mdl")
	
end