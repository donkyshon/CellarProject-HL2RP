
local ang1 = Angle(90)
local ParticleEffect = ParticleEffect

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local ang = data:GetAngles()
	ParticleEffect("gred_highcal_rocket_explosion",pos,ang,nil)
end
function EFFECT:Think()
	return false
end

function EFFECT:Render()
end