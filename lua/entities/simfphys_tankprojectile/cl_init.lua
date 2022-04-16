include("shared.lua")

ENT.mat = Material( "sprites/animglow02" )
ENT.mat2 = Material( "effects/simfphys_armed/spark" )

function ENT:Initialize()	
	self.Materials = {
		"particle/smokesprites_0001",
		"particle/smokesprites_0002",
		"particle/smokesprites_0003",
		"particle/smokesprites_0004",
		"particle/smokesprites_0005",
		"particle/smokesprites_0006",
		"particle/smokesprites_0007",
		"particle/smokesprites_0008",
		"particle/smokesprites_0009",
		"particle/smokesprites_0010",
		"particle/smokesprites_0011",
		"particle/smokesprites_0012",
		"particle/smokesprites_0013",
		"particle/smokesprites_0014",
		"particle/smokesprites_0015",
		"particle/smokesprites_0016"
	}
	
	self.OldPos = self:GetPos()
	self.emitter = ParticleEmitter(self.OldPos, false )
end

function ENT:Draw()
	if not self.Dir or not self.Size or not self.Len then return end
	
	if self.Size > 5 then return end
	
	local pos = self:GetPos()
	
	render.SetMaterial( self.mat2 )
	render.DrawBeam( pos +  self.Dir * self.Len, self.OldPos - self.Dir * self.Len, self.Size * 5, 1, 0, Color( 255, 255, 255, 255 ) )
end

function ENT:Think()
	local pos = self:GetPos()
	
	if pos ~= self.OldPos then
		self:doFX( pos, self.OldPos )
		self.OldPos = pos
	end
	
	return true
end

function ENT:doFX( newpos, oldpos )
	if not self.emitter then return end
	
	local Sub = (newpos - oldpos)
	local Dir = Sub:GetNormalized()
	local Len = Sub:Length()
	
	self.Len = Len
	self.Dir = Dir
	self.Size = self:GetSize()
	
	for i = 1, Len, 15 do
		local pos = oldpos + Dir * i
		
		local particle = self.emitter:Add( self.Materials[math.random(1, table.Count(self.Materials) )], pos )
		
		if particle then
			particle:SetGravity( Vector(0,0,100) + VectorRand() * 50 ) 
			particle:SetVelocity( -Dir * 500  )
			particle:SetAirResistance( 600 ) 
			particle:SetDieTime( math.Rand(0.1,0.5) )
			particle:SetStartAlpha( 80 )
			particle:SetStartSize( (math.Rand(6,12) / 20) * self.Size )
			particle:SetEndSize( (math.Rand(20,30) / 20) * self.Size )
			particle:SetRoll( math.Rand( -1, 1 ) )
			particle:SetColor( 120,120,120 )
			particle:SetCollide( false )
		end
		
		if self.Size > 5 then
			local particle = self.emitter:Add( self.mat, pos )
			if particle then
				particle:SetVelocity( -Dir * 300 + self:GetVelocity())
				particle:SetDieTime( 0.1 )
				particle:SetAirResistance( 0 ) 
				particle:SetStartAlpha( 255 )
				particle:SetStartSize( self.Size )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(-1,1) )
				particle:SetColor( 255,255,255 )
				particle:SetGravity( Vector( 0, 0, 0 ) )
				particle:SetCollide( false )
			end
		end
	end
end

function ENT:OnRemove()
	if self.emitter then
		self.emitter:Finish()
	end
end

function ENT:Explosion( pos )
	if not self.emitter then return end
	
	for i = 0,60 do
		local particle = self.emitter:Add( self.Materials[math.random(1,table.Count( self.Materials ))], pos )
		
		if particle then
			particle:SetVelocity(  VectorRand() * 600 )
			particle:SetDieTime( math.Rand(4,6) )
			particle:SetAirResistance( math.Rand(200,600) ) 
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( math.Rand(10,30) )
			particle:SetEndSize( math.Rand(80,120) )
			particle:SetRoll( math.Rand(-1,1) )
			particle:SetColor( 50,50,50 )
			particle:SetGravity( Vector( 0, 0, 100 ) )
			particle:SetCollide( false )
		end
	end
	
	for i = 0, 40 do
		local particle = self.emitter:Add( "sprites/flamelet"..math.random(1,5), pos )
		
		if particle then
			particle:SetVelocity( VectorRand() * 500 )
			particle:SetDieTime( 0.14 )
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( 10 )
			particle:SetEndSize( math.Rand(30,60) )
			particle:SetEndAlpha( 100 )
			particle:SetRoll( math.Rand( -1, 1 ) )
			particle:SetColor( 200,150,150 )
			particle:SetCollide( false )
		end
	end
	
	local dlight = DynamicLight( math.random(0,9999) )
	if dlight then
		dlight.pos = pos
		dlight.r = 255
		dlight.g = 180
		dlight.b = 100
		dlight.brightness = 8
		dlight.Decay = 2000
		dlight.Size = 200
		dlight.DieTime = CurTime() + 0.1
	end
end