ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Kinder Surprise"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A Kinder Surprise"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/KinderSurprise.mdl")
	
end