EFFECT.Mat = Material( "effects/simfphys_armed/gauss_beam" )

function EFFECT:Init( data )

	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()

	local ent = data:GetEntity()
	self.parentent = ent
	
	local att = data:GetAttachment()

	if ( IsValid( ent ) && att > 0 ) then
		if ( ent.Owner == LocalPlayer() && !LocalPlayer():GetViewModel() != LocalPlayer() ) then ent = ent.Owner:GetViewModel() end

		local att = ent:GetAttachment( att )
		if ( att ) then
			self.StartPos = att.Pos
		end
	end

	self.Dir = self.EndPos - self.StartPos

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	self.TracerTime = 0.1
	self.Length = math.Rand( 0.15, 0.3 )

	-- Die when it reaches its target
	self.DieTime = CurTime() + self.TracerTime

end

function EFFECT:Think()

	if ( CurTime() > self.DieTime ) then

		-- Awesome End Sparks
		local effectdata = EffectData()
		effectdata:SetOrigin( self.EndPos + self.Dir:GetNormalized() * -5 )
		effectdata:SetNormal( self.Dir:GetNormalized() * -3 )
		effectdata:SetMagnitude( 1 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 6 )
		util.Effect( "Sparks", effectdata )

		return false
	end

	return true

end

function EFFECT:RenderGauss(dir,dist)
	if !IsValid(self.parentent) then return end
	
	local origin = self.parentent:GetAttachment( 1 ).Pos
	
	render.SetMaterial( self.Mat )
	render.DrawBeam(origin, origin + dir * dist, 2, 1, 1, Color( 255,145,0, 255 ) )
	
	self:GaussArc(origin,dir,dist)
	self:GaussArc(origin,dir,dist)
end

function EFFECT:GaussArc(origin,dir,dist)
	local amount = math.Round(dist / 100,1)
	
	local positions = {}
	for i = 1, amount do
		local intensitivity = math.sin( (i / amount) * 180  * (math.pi / 180) )
		
		local arc_offset = dir * i * (dist / amount) + self.side:Right() * intensitivity * dist * 0.02
		local noise = Vector( math.random(-1,1), math.random(-1,1), math.random(-1,1) ) * intensitivity
		
		table.insert(positions, origin + arc_offset + noise )
		
		render.DrawBeam(positions[i-1] or origin, positions[i], 1, 1, 1, Color( 255,195,50, 255 ) )
	end
end

function EFFECT:Render()
	local dir = self.Dir
	dir:Normalize()
	
	self.side = dir:Angle()
	self.side:RotateAroundAxis(dir, math.random(-180,180) )
	
	self:RenderGauss(dir,(self.EndPos - self.StartPos):Length())
end

EFFECT.Mat = Material( "effects/simfphys_armed/gauss_beam" )

function EFFECT:Init( data )

	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()

	local ent = data:GetEntity()
	self.parentent = ent
	
	local att = data:GetAttachment()

	if ( IsValid( ent ) && att > 0 ) then
		if ( ent.Owner == LocalPlayer() && !LocalPlayer():GetViewModel() != LocalPlayer() ) then ent = ent.Owner:GetViewModel() end

		local att = ent:GetAttachment( att )
		if ( att ) then
			self.StartPos = att.Pos
		end
	end

	self.Dir = self.EndPos - self.StartPos

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	self.TracerTime = 0.1
	self.Length = math.Rand( 0.15, 0.3 )

	-- Die when it reaches its target
	self.DieTime = CurTime() + self.TracerTime

end

function EFFECT:Think()

	if ( CurTime() > self.DieTime ) then

		-- Awesome End Sparks
		local effectdata = EffectData()
		effectdata:SetOrigin( self.EndPos + self.Dir:GetNormalized() * -5 )
		effectdata:SetNormal( self.Dir:GetNormalized() * -3 )
		effectdata:SetMagnitude( 1 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 6 )
		util.Effect( "Sparks", effectdata )

		return false
	end

	return true

end

function EFFECT:RenderGauss(dir,dist)
	if !IsValid(self.parentent) then return end
	
	local origin = self.parentent:GetAttachment( 1 ).Pos
	
	render.SetMaterial( self.Mat )
	render.DrawBeam(origin, origin + dir * dist, 2, 1, 1, Color( 255,145,0, 255 ) )
	
	self:GaussArc(origin,dir,dist)
	self:GaussArc(origin,dir,dist)
end

function EFFECT:GaussArc(origin,dir,dist)
	local amount = math.Round(dist / 100,1)
	
	local positions = {}
	for i = 1, amount do
		local intensitivity = math.sin( (i / amount) * 180  * (math.pi / 180) )
		
		local arc_offset = dir * i * (dist / amount) + self.side:Right() * intensitivity * dist * 0.02
		local noise = Vector( math.random(-1,1), math.random(-1,1), math.random(-1,1) ) * intensitivity
		
		table.insert(positions, origin + arc_offset + noise )
		
		render.DrawBeam(positions[i-1] or origin, positions[i], 1, 1, 1, Color( 255,195,50, 255 ) )
	end
end

function EFFECT:Render()
	local dir = self.Dir
	dir:Normalize()
	
	self.side = dir:Angle()
	self.side:RotateAroundAxis(dir, math.random(-180,180) )
	
	self:RenderGauss(dir,(self.EndPos - self.StartPos):Length())
end
