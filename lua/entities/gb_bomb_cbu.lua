AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		            	 =  true
ENT.AdminSpawnable		             =  true

ENT.PrintName		                 =  "[BOMBS] CBU-52U"
ENT.Author			                 =  "Gredwitch"
ENT.Contact		                     =  "contact.gredwitch@gmail.com"
ENT.Category                         =  "Gredwitch's Stuff"

ENT.Model                            =  "models/gbombs/bomb_cbu.mdl"
ENT.Effect                           =  "high_explosive_main_2"
ENT.EffectAir                        =  "high_explosive_air_2"
ENT.EffectWater                      =  "water_medium"
ENT.ExplosionSound                   =  "explosions/gbomb_6.mp3"
ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"
ENT.ActivationSound                  =  "buttons/button14.wav"

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  false
ENT.UseRandomSounds                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  200
ENT.PhysForce                        =  200
ENT.ExplosionRadius                  =  600
ENT.SpecialRadius                    =  500
ENT.MaxIgnitionTime                  =  0
ENT.Life                             =  50
ENT.MaxDelay                         =  0
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  700
ENT.Mass                             =  52
ENT.ArmDelay                         =  0
ENT.GBOWNER                          =  nil             -- don't you fucking touch this.

ENT.Cube							 =	nil
ENT.DEFAULT_PHYSFORCE                = 155
ENT.DEFAULT_PHYSFORCE_PLYAIR         = 20
ENT.DEFAULT_PHYSFORCE_PLYGROUND      = 1000

function ENT:AddOnExplode()
	local pos = self:LocalToWorld(self:OBBCenter())
	
	local entities = {}
	
	for i = 1,10 do
		local ent = ents.Create("gb_bomb_cbubomblet") 
		ent:SetPos(pos) 
		ent.Owner = self.Owner
		ent.ang = Angle(math.random(-160,-20),math.random(-70,70),math.random(-70,70))
		-- ent:SetModelScale(0.1)
		-- ent:SetAngles(ent.ang)
		ent:SetNoDraw(true)
		ent:Spawn()
		ent:Activate()
		constraint.NoCollide(ent,self,0,0)
		
		table.insert(entities,ent)
	end
	
	for i = 1,#entities do
		
		for k = 1,#entities do
			constraint.NoCollide(entities[i],entities[k],0,0)
		end
		
		entities[i]:Arm()
		entities[i]:TimedExplosion()
		
		local bphys = entities[i]:GetPhysicsObject()
		
		if IsValid(bphys) then
			bphys:SetVelocityInstantaneous(entities[i].ang:Forward() * 500)
		end
	end
end

-- function ENT:Think()
	-- if self.Armed and SERVER then
		-- if self.Cube == nil then 
			-- local e = ents.Create("prop_dynamic")
			-- e:SetModel("models/hunter/blocks/cube05x05x05.mdl")
			-- e:Spawn()
			-- self.Cube = e
		-- end
		-- local pos = self:GetPos()
		-- local tr = util.QuickTrace(pos,self:GetUp()*-300,self)
		-- self.Cube:SetPos(tr.HitPos)
		-- if tr.Hit and !tr.HitSky then 
			-- print("blow up")
			-- self:Explode() 
		-- end
	-- end
-- end
function ENT:SpawnFunction( ply, tr )
     if ( !tr.Hit ) then return end
	 self.GBOWNER = ply
     local ent = ents.Create( self.ClassName )
	 ent:SetPhysicsAttacker(ply)
     ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
     ent:Spawn()
     ent:Activate()

     return ent
end