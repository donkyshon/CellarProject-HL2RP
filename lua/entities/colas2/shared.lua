ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Cola (Swift Light)"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "Food"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/cola_swift2.mdl")
	
end