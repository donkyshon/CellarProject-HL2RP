AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		            	 =  true
ENT.AdminSpawnable		             =  true

ENT.PrintName		                 =  "RBK-500"
ENT.Author			                 =  "Shermann Wolf"
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/sw/avia/bombs/rbk500.mdl"
ENT.Effect                           =  "doi_stuka_explosion"
ENT.EffectAir                        =  "doi_stuka_explosion"
ENT.EffectWater                      =  "ins_water_explosion"
ENT.ExplosionSound                   =  "explosions/doi_stuka_close.wav"
ENT.FarExplosionSound				 =  "explosions/doi_stuka_far.wav"
ENT.DistExplosionSound				 =  "explosions/doi_stuka_dist.wav"
ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"
ENT.ActivationSound                  =  "buttons/button14.wav"

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  false
ENT.UseRandomSounds                  =  false
ENT.Timed                            =  false
ENT.AngEffect						 =	true
ENT.ExplosionDamage                  =  10000
ENT.PhysForce                        =  1000
ENT.ExplosionRadius                  =  1000
ENT.SpecialRadius                    =  1500
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  50
ENT.MaxDelay                         =  0                                 
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  200
ENT.Mass                             =  1000
ENT.Decal							 =	"scorch_big"
ENT.GBOWNER                          =  nil      -- don't you fucking touch this.

ENT.Cube							 =	nil
ENT.DEFAULT_PHYSFORCE                = 155
ENT.DEFAULT_PHYSFORCE_PLYAIR         = 20
ENT.DEFAULT_PHYSFORCE_PLYGROUND      = 1000

function ENT:AddOnExplode()
	local pos = self:LocalToWorld(self:OBBCenter())
	
	local entities = {}
	
	for i = 1,40 do
		local ent = ents.Create("bomb_mk118") 
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
AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		            	 =  true
ENT.AdminSpawnable		             =  true

ENT.PrintName		                 =  "RBK-500"
ENT.Author			                 =  "Shermann Wolf"
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/sw/avia/bombs/rbk500.mdl"
ENT.Effect                           =  "doi_stuka_explosion"
ENT.EffectAir                        =  "doi_stuka_explosion"
ENT.EffectWater                      =  "ins_water_explosion"
ENT.ExplosionSound                   =  "explosions/doi_stuka_close.wav"
ENT.FarExplosionSound				 =  "explosions/doi_stuka_far.wav"
ENT.DistExplosionSound				 =  "explosions/doi_stuka_dist.wav"
ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"
ENT.ActivationSound                  =  "buttons/button14.wav"

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  false
ENT.UseRandomSounds                  =  false
ENT.Timed                            =  false
ENT.AngEffect						 =	true
ENT.ExplosionDamage                  =  10000
ENT.PhysForce                        =  1000
ENT.ExplosionRadius                  =  1000
ENT.SpecialRadius                    =  1500
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  50
ENT.MaxDelay                         =  0                                 
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  200
ENT.Mass                             =  1000
ENT.Decal							 =	"scorch_big"
ENT.GBOWNER                          =  nil      -- don't you fucking touch this.

ENT.Cube							 =	nil
ENT.DEFAULT_PHYSFORCE                = 155
ENT.DEFAULT_PHYSFORCE_PLYAIR         = 20
ENT.DEFAULT_PHYSFORCE_PLYGROUND      = 1000

function ENT:AddOnExplode()
	local pos = self:LocalToWorld(self:OBBCenter())
	
	local entities = {}
	
	for i = 1,40 do
		local ent = ents.Create("bomb_mk118") 
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