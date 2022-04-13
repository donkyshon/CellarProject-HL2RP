ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "McDonalds Cheeseburger (in box)"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A double cheeseburger from McDonalds"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/mcdburgerboxclosed.mdl")
	
end