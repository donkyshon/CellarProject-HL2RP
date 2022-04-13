ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Bagel"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "food"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/Bagel1.mdl")
	
end