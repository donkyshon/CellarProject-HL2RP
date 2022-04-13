ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Cabbage"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "Caggage"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/cabbage3.mdl")
	
end