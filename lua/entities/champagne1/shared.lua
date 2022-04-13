ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Champagne"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A bottle of champagne"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/champagne.mdl")
	
end