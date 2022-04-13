
local Materials = {
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
function EFFECT:Init( data )
	local vehicle = data:GetEntity()
	
	if not IsValid( vehicle ) then return end
	
	local ID = vehicle:LookupAttachment( "muzzle" )
	if ID == 0 then return end
	
	local Attachment = vehicle:GetAttachment( ID )
	
	local Pos = Attachment.Pos
	local Dir = Attachment.Ang:Up()
	local vel = vehicle:GetVelocity()
	
	self.emitter = ParticleEmitter( Pos, false )
	
	self:Muzzle( Pos, Dir, vel )
	self:Smoke( Pos, Dir, vel )
	self:Smoke2( Pos, Attachment.Ang:Forward(), Dir, vel )
	self:Smoke2( Pos, -Attachment.Ang:Forward(), Dir, vel )
	
	self.Time = math.Rand(3,6)
	self.DieTime = CurTime() + self.Time
	self.AttachmentID = ID
	self.Vehicle = vehicle
end

function EFFECT:Muzzle( pos, dir, vel )
	if not self.emitter then return end
	
	for i = 0,20 do
		local particle = self.emitter:Add( "effects/muzzleflash2", pos )

		if particle then
			particle:SetVelocity( dir * math.Rand(50,200) + vel )
			particle:SetDieTime( 0.3 )
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( math.random(24,60) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( -1, 1 ) )
			particle:SetColor( 255,255,255 )
			particle:SetCollide( false )
		end
	end
end

function EFFECT:Smoke( pos, dir, vel )
	if not self.emitter then return end
	
	for i = 0,10 do
		local particle = self.emitter:Add( Materials[math.random(1,table.Count( Materials ))], pos )
		
		local rCol = math.Rand(120,140)
		
		if particle then
			particle:SetVelocity( dir * math.Rand(300,1300) + VectorRand() * math.Rand(0,10) + vel )
			particle:SetDieTime( math.Rand(3,4) )
			particle:SetAirResistance( math.Rand(300,600) ) 
			particle:SetStartAlpha( math.Rand(50,150) )
			particle:SetStartSize( 5 )
			particle:SetEndSize( math.Rand(80,160) )
			particle:SetRoll( math.Rand(-1,1) )
			particle:SetColor( rCol,rCol,rCol )
			particle:SetGravity( VectorRand() * 200 + Vector(0,0,200) )
			particle:SetCollide( false )
		end
	end
end

function EFFECT:Smoke2( pos, dir, dir_muzzle, vel )
	if not self.emitter then return end
	
	pos = pos + dir_muzzle * 5
	
	for i = 0,20 do
		local particle = self.emitter:Add( Materials[math.random(1,table.Count( Materials ))], pos )
		
		if particle then
			particle:SetVelocity( dir * math.Rand(250,800) + VectorRand() * math.Rand(0,50) + vel)
			particle:SetDieTime( math.Rand(1,3) )
			particle:SetAirResistance( 800 ) 
			particle:SetStartAlpha( 150 )
			particle:SetStartSize( 0 )
			particle:SetEndSize( math.Rand(20,60) )
			particle:SetRoll( math.Rand(-1,1) )
			particle:SetColor( 120,120,120 )
			particle:SetGravity( Vector(0,0,10) )
			particle:SetCollide( false )
		end
	end
end


function EFFECT:Think()
	local vehicle = self.Vehicle
	if not IsValid( vehicle ) then return false end
	
	if self.DieTime > CurTime() then
		if self.emitter then
			local intensity = ((self.DieTime - CurTime()) / self.Time)
			
			local Attachment = vehicle:GetAttachment( self.AttachmentID )
			local dir = Attachment.Ang:Up()
			local pos = Attachment.Pos + dir * 15
		
			for i = 0,math.Rand(3,6) do
				local particle = self.emitter:Add( Materials[math.random(1,table.Count( Materials ))], pos )
				
				if particle then
					particle:SetVelocity( dir * 2 + VectorRand() * 10 )
					particle:SetDieTime( math.Rand(1,2) )
					particle:SetAirResistance( 0 ) 
					particle:SetStartAlpha( (intensity ^ 5) * 20 )
					particle:SetStartSize( intensity * 5 )
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


local Materials = {
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
function EFFECT:Init( data )
	local vehicle = data:GetEntity()
	
	if not IsValid( vehicle ) then return end
	
	local ID = vehicle:LookupAttachment( "muzzle" )
	if ID == 0 then return end
	
	local Attachment = vehicle:GetAttachment( ID )
	
	local Pos = Attachment.Pos
	local Dir = Attachment.Ang:Up()
	local vel = vehicle:GetVelocity()
	
	self.emitter = ParticleEmitter( Pos, false )
	
	self:Muzzle( Pos, Dir, vel )
	self:Smoke( Pos, Dir, vel )
	self:Smoke2( Pos, Attachment.Ang:Forward(), Dir, vel )
	self:Smoke2( Pos, -Attachment.Ang:Forward(), Dir, vel )
	
	self.Time = math.Rand(3,6)
	self.DieTime = CurTime() + self.Time
	self.AttachmentID = ID
	self.Vehicle = vehicle
end

function EFFECT:Muzzle( pos, dir, vel )
	if not self.emitter then return end
	
	for i = 0,20 do
		local particle = self.emitter:Add( "effects/muzzleflash2", pos )

		if particle then
			particle:SetVelocity( dir * math.Rand(50,200) + vel )
			particle:SetDieTime( 0.3 )
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( math.random(24,60) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( -1, 1 ) )
			particle:SetColor( 255,255,255 )
			particle:SetCollide( false )
		end
	end
end

function EFFECT:Smoke( pos, dir, vel )
	if not self.emitter then return end
	
	for i = 0,10 do
		local particle = self.emitter:Add( Materials[math.random(1,table.Count( Materials ))], pos )
		
		local rCol = math.Rand(120,140)
		
		if particle then
			particle:SetVelocity( dir * math.Rand(300,1300) + VectorRand() * math.Rand(0,10) + vel )
			particle:SetDieTime( math.Rand(3,4) )
			particle:SetAirResistance( math.Rand(300,600) ) 
			particle:SetStartAlpha( math.Rand(50,150) )
			particle:SetStartSize( 5 )
			particle:SetEndSize( math.Rand(80,160) )
			particle:SetRoll( math.Rand(-1,1) )
			particle:SetColor( rCol,rCol,rCol )
			particle:SetGravity( VectorRand() * 200 + Vector(0,0,200) )
			particle:SetCollide( false )
		end
	end
end

function EFFECT:Smoke2( pos, dir, dir_muzzle, vel )
	if not self.emitter then return end
	
	pos = pos + dir_muzzle * 5
	
	for i = 0,20 do
		local particle = self.emitter:Add( Materials[math.random(1,table.Count( Materials ))], pos )
		
		if particle then
			particle:SetVelocity( dir * math.Rand(250,800) + VectorRand() * math.Rand(0,50) + vel)
			particle:SetDieTime( math.Rand(1,3) )
			particle:SetAirResistance( 800 ) 
			particle:SetStartAlpha( 150 )
			particle:SetStartSize( 0 )
			particle:SetEndSize( math.Rand(20,60) )
			particle:SetRoll( math.Rand(-1,1) )
			particle:SetColor( 120,120,120 )
			particle:SetGravity( Vector(0,0,10) )
			particle:SetCollide( false )
		end
	end
end


function EFFECT:Think()
	local vehicle = self.Vehicle
	if not IsValid( vehicle ) then return false end
	
	if self.DieTime > CurTime() then
		if self.emitter then
			local intensity = ((self.DieTime - CurTime()) / self.Time)
			
			local Attachment = vehicle:GetAttachment( self.AttachmentID )
			local dir = Attachment.Ang:Up()
			local pos = Attachment.Pos + dir * 15
		
			for i = 0,math.Rand(3,6) do
				local particle = self.emitter:Add( Materials[math.random(1,table.Count( Materials ))], pos )
				
				if particle then
					particle:SetVelocity( dir * 2 + VectorRand() * 10 )
					particle:SetDieTime( math.Rand(1,2) )
					particle:SetAirResistance( 0 ) 
					particle:SetStartAlpha( (intensity ^ 5) * 20 )
					particle:SetStartSize( intensity * 5 )
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
