ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Hotdog"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "Half a hotdog"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/hotdog.mdl")
	
end