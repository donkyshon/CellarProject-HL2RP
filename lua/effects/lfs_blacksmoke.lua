--DO NOT EDIT OR REUPLOAD THIS FILE

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
	local Pos = data:GetOrigin() + VectorRand() * 50
	
	local emitter = ParticleEmitter( Pos, false )

	if emitter then
		local particle = emitter:Add( Materials[math.Round(math.Rand(1,table.Count( Materials )),0)], Pos )
		
		if particle then
			particle:SetVelocity( VectorRand() * 100 )
			particle:SetDieTime( 1.5 )
			particle:SetAirResistance( 600 ) 
			particle:SetStartAlpha( 50 )
			particle:SetStartSize( 80 )
			particle:SetEndSize( math.Rand(250,300) )
			particle:SetRoll( math.Rand(-1,1) * 100 )
			particle:SetColor( 70,70,70 )
			particle:SetGravity( Vector( 0, 0, 500 ) )
			particle:SetCollide( false )
		end
		
		emitter:Finish()
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
