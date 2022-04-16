ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "McDonalds Soda"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A cup of McDonalds Soda"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/mcddrink.mdl")
	
end