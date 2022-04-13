ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Chips - Fritos BarBQ Hoops"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A bag of Fritos BarBQ Hoops"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/chipsfritoshoops.mdl")
	
end