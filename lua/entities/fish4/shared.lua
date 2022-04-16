ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Raw Rainbow Trout"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A raw fish"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/fishrainbow.mdl")
	
end