include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

net.Receive("gred_net_wacrocket_explosion_fx",function()
	ParticleEffect(net.ReadString(),net.ReadVector(),net.ReadAngle(),nil)
end)