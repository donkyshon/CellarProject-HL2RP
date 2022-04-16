ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Fried Egg"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A fried egg"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/egg.mdl")
	
end