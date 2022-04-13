ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Birthday Cake (Slice)"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A piece of birthday cake"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/cakeslice1.mdl")
	
end