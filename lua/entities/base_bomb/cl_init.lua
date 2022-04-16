include("shared.lua")

function ENT:Draw()
    self:DrawModel()
	
	if WireAddon then Wire_Render(self.Entity) end
end