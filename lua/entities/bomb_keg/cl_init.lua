include('shared.lua')

--[[-------------------------------------------------------------------------
TODO: shadow
---------------------------------------------------------------------------]]
function ENT:Initialize()
	local keg = ClientsideModel('models/sw/avia/bombs/keg.mdl')
	
	local scale_matrix = Matrix()
	scale_matrix:Scale(Vector(1, 1, 1))
	keg:EnableMatrix('RenderMultiply', scale_matrix)
	
	self.Keg = keg
	--self:DrawShadow(false)
end


function ENT:OnRemove()
	self.Keg:Remove()
end


function ENT:Draw()
	self.Keg:SetPos(self:GetPos())
	self.Keg:SetAngles(self:GetAngles())
	--self.Keg:CreateShadow()
end

include('shared.lua')

--[[-------------------------------------------------------------------------
TODO: shadow
---------------------------------------------------------------------------]]
function ENT:Initialize()
	local keg = ClientsideModel('models/sw/avia/bombs/keg.mdl')
	
	local scale_matrix = Matrix()
	scale_matrix:Scale(Vector(1, 1, 1))
	keg:EnableMatrix('RenderMultiply', scale_matrix)
	
	self.Keg = keg
	--self:DrawShadow(false)
end


function ENT:OnRemove()
	self.Keg:Remove()
end


function ENT:Draw()
	self.Keg:SetPos(self:GetPos())
	self.Keg:SetAngles(self:GetAngles())
	--self.Keg:CreateShadow()
end
