
local ang1 = Angle(90)
local ParticleEffect = ParticleEffect

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local ang = data:GetAngles()
	ParticleEffect("ins_water_explosion",pos,ang,nil)
end
function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

local ang1 = Angle(90)
local ParticleEffect = ParticleEffect

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local ang = data:GetAngles()
	ParticleEffect("ins_water_explosion",pos,ang,nil)
end
function EFFECT:Think()
	return false
end

function EFFECT:Render()
end