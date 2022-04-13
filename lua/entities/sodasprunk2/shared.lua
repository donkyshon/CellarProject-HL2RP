ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Sprunk Light (Large)"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A large bottle of Sprunk Light"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/sprunk2.mdl")
	
end