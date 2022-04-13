ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Donut"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A glazed donut"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/Donut.mdl")
	
end