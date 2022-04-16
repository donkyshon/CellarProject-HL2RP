ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Toast"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A toasted piece of toast"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/toast.mdl")
	
end