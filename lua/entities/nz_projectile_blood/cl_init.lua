include("shared.lua")

ENT.NextEmit = 0

function ENT:Initialize()
	self:DrawShadow(false)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(36, 44)

	self.Size = math.Rand(14, 17)
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
end

function ENT:OnRemove()
	--self.Emitter:Finish()
end

local colFlesh = Color(255, 255, 255, 255)
local matFlesh = Material("decals/blood1")
function ENT:Draw()
	local size = self.Size

	render.SetMaterial(matFlesh)
	local pos = self:GetPos()
	render.DrawSprite(pos, size, size, colFlesh)

	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.05

	local particle = self.Emitter:Add("decals/blood1", pos + VectorRand():GetNormalized() * math.Rand(1, 4))
	particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(1, 4))
	particle:SetDieTime(math.Rand(0.6, 0.9))
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(255)
	particle:SetStartSize(size * math.Rand(0.2, 0.22))
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-4, 4))
	particle:SetLighting(true)
end