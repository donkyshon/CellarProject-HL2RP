function EFFECT:Init( data )
	local vehicle = data:GetEntity()

	local ID = vehicle:LookupAttachment( "muzzle_cannon" )
	if ID == 0 then return end

	local Attachment = vehicle:GetAttachment( ID )

	local Pos = Attachment.Pos
	local Dir = Attachment.Ang:Forward()
	local vel = vehicle:GetVelocity()

	self.emitter = ParticleEmitter( Pos, false )

	self:Muzzle( Pos, Dir, vel )

	self.Time = 30
	self.DieTime = CurTime() + self.Time
	self.AttachmentID = ID
	self.Vehicle = vehicle
end

function EFFECT:Muzzle( pos, dir, vel )
	if not self.emitter then return end

   local particle = self.emitter:Add( "effects/ar2_altfire1b", pos )

   if particle then
      particle:SetVelocity( dir * math.Rand(50,200) + vel )
      particle:SetDieTime( 0.3 )
      particle:SetStartAlpha( 255 )
      particle:SetStartSize( 200 )
      particle:SetEndSize( 0 )
      particle:SetRoll( math.Rand( -1, 1 ) )
      particle:SetColor( 255,255,255 )
      particle:SetCollide( false )
   end

   for i = 0,8 do
		local particle = self.emitter:Add( "particles/smokey", pos )

		local rCol = math.Rand(120,140)

		if particle then
			particle:SetVelocity( dir * math.Rand(300,1300) + VectorRand() * math.Rand(0,300) + vel )
			particle:SetDieTime( math.Rand(3,4) )
			particle:SetAirResistance( math.Rand(300,600) )
			particle:SetStartAlpha( math.Rand(50,100) )
			particle:SetStartSize( math.Rand(5,20) )
			particle:SetEndSize( math.Rand(150,200) )
			particle:SetRoll( math.Rand(-1,1) )
			particle:SetColor( rCol,rCol,rCol )
			particle:SetGravity( VectorRand() * 200 + Vector(0,0,200) )
			particle:SetCollide( false )
		end
	end

	local light = DynamicLight(self:EntIndex())
	if (light) then
		light.Pos = pos
		light.r = 255
		light.g = 206
		light.b = 122
		light.Brightness = 4
		light.Decay = 5100
		light.Size = 512
		light.DieTime = CurTime() + 0.1
	end
end

function EFFECT:Think()
	local vehicle = self.Vehicle
	if not IsValid( vehicle ) then return false end

	if self.DieTime > CurTime() then
		local intensity = ((self.DieTime - CurTime()) / self.Time)

		local Attachment = vehicle:GetAttachment( self.AttachmentID )
		local dir = Attachment.Ang:Forward()
		local pos = Attachment.Pos + dir * 3
		if self.emitter then
			for i = 0,math.Rand(3,6) do
				local particle = self.emitter:Add( "particles/smokey", pos )

				if particle then
					particle:SetVelocity( (dir * intensity * math.Rand(50, 64)) + VectorRand() * 30 )
					particle:SetDieTime( math.Rand(1,2) )
					particle:SetAirResistance( 0 ) 
					particle:SetStartAlpha( (intensity ^ 5) * 10 )
					particle:SetStartSize( intensity ^ 2 * 15 )
					particle:SetEndSize( math.Rand(10,20) * intensity )
					particle:SetRoll( math.Rand(-1,1) )
					particle:SetColor( 120,120,120 )
					particle:SetGravity( Vector(0,0,20) + VectorRand() * math.Rand(0,5) )
					particle:SetCollide( false )
				end
			end
		end

		return true
	else
		if self.emitter then
			self.emitter:Finish()
		end
		
		return false
	end
end

function EFFECT:Render()
end
