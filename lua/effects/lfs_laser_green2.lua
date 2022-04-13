--DO NOT EDIT OR REUPLOAD THIS FILE

EFFECT.Mat = Material( "effects/spark" )
EFFECT.Mat2 = Material( "sprites/light_glow02_add" )

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

	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	
	self.Dir = self.EndPos - self.StartPos

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )

	self.TracerTime = math.min( 1, self.StartPos:Distance( self.EndPos ) / 15000 ) * 0.5
	self.Length = math.Rand( 0.4, 0.45 )

	-- Die when it reaches its target
	self.DieTime = CurTime() + self.TracerTime
end

function EFFECT:Think()

	if CurTime() > self.DieTime then
		local effectdata = EffectData()
			effectdata:SetStart( Vector(50,255,50) ) 
			effectdata:SetOrigin( self.EndPos )
			effectdata:SetNormal( self.Dir:GetNormalized() )
		util.Effect( "lfs_laser_hit", effectdata )
		
		return false
	end

	return true

end

function EFFECT:Render()

	local fDelta = ( self.DieTime - CurTime() ) / self.TracerTime
	fDelta = math.Clamp( fDelta, 0, 1 ) ^ 2 -- lasers are faster than bullets...

	local sinWave = math.sin( fDelta * math.pi )
	
	local Pos1 = self.EndPos - self.Dir * ( fDelta - sinWave * self.Length )
	
	render.SetMaterial( self.Mat )
	render.DrawBeam( Pos1,
		self.EndPos - self.Dir * ( fDelta + sinWave * self.Length ),
		45, 1, 0, Color(0,255,0,255) )
		
	render.DrawBeam( Pos1,
		self.EndPos - self.Dir * ( fDelta + sinWave * self.Length ),
		15, 1, 0, Color(255,255,255,255) )
		
	--render.SetMaterial( self.Mat2 ) 
	--render.DrawSprite( Pos1, 80, 80, Color(0,255,0,255) ) 
end
