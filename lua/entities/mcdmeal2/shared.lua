ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "McDonalds Meal"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A McDonalds Meal"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/mcdmeal2.mdl")
	
end