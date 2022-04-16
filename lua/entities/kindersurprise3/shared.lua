ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Kinder Surprise (Half)"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "An unwrapped halved Kinder Surprise"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/KinderSurprisehalf.mdl")
	
end