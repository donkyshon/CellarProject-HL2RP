AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		= true
ENT.AdminOnly		= true

ENT.PrintName		                 =  "Mark 3"
ENT.Author			                 =  "Shermann Wolf"
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/sw/avia/bombs/mk3.mdl"                      
ENT.Effect                           =  "fatman_main"                  
ENT.EffectAir                        =  "fatman_air"                     
ENT.EffectWater                      =  "water_huge"
ENT.ExplosionSound                   =  "sw/bombs/an602_detonate.mp3"
ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"            
ENT.ActivationSound                  =  "buttons/button14.wav"     

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  false
ENT.UseRandomSounds                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  50000
ENT.PhysForce                        =  5000
ENT.ExplosionRadius                  =  4000
ENT.SpecialRadius                    =  4000
ENT.MaxIgnitionTime                  =  0
ENT.Life                             =  25                                  
ENT.MaxDelay                         =  2                                 
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  1300
ENT.Mass                             =  18500
ENT.ArmDelay                         =  0   
ENT.Timer                            =  0

ENT.GBOWNER                          =  nil             -- don't you fucking touch this.
ENT.Decal                            = "nuke_medium"
function ENT:Initialize()
 if (SERVER) then
     self:SetModel(self.Model)
	 self:PhysicsInit( SOLID_VPHYSICS )
	 self:SetSolid( SOLID_VPHYSICS )
	 self:SetMoveType( MOVETYPE_VPHYSICS )
	 self:SetUseType( ONOFF_USE ) -- doesen't fucking work
	 local phys = self:GetPhysicsObject()
	 if (phys:IsValid()) then
		 phys:SetMass(self.Mass)
		 phys:Wake()
     end 
	 if(self.Dumb) then
	     self.Armed    = true
	 else
	     self.Armed    = false
	 end
	 self.Exploded = false
	 self.Used     = false
	 self.Arming = false
	 self.Exploding = false
	  if !(WireAddon == nil) then self.Inputs   = Wire_CreateInputs(self, { "Arm", "Detonate" }) end
	end
end

function ENT:PhysicsCollide( data, physobj )
     if(self.Exploded) then return end
     if(!self:IsValid()) then return end
	 if(self.Life <= 0) then return end
	 if(data.Speed > 200) then
		if math.random(1,2)==1 then
			self:EmitSound("sw/bombs/an602land.wav", 80, math.random(90,110))
		else
			self:EmitSound("sw/bombs/an602land2.wav", 80, math.random(90,110))
		end
	 end
	 if(GetConVar("sw_fragility"):GetInt() >= 1) then
	     if(data.Speed > self.ImpactSpeed) then
	 	     if(!self.Armed and !self.Arming) then

	             self:Arm()
	         end
		 end
	 end
	 if(!self.Armed) then return end
     if self.ShouldExplodeOnImpact then
	     if (data.Speed > self.ImpactSpeed ) then
			 self.Exploded = true
			 self:Explode()
		 end
	 end
end

function ENT:Explode()
     if !self.Exploded then return end
	 if self.Exploding then return end
	
	 local pos = self:LocalToWorld(self:OBBCenter())
	 local ent = ents.Create("sw_shockwave_ent")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE",35000)
	 ent:SetVar("SHOCKWAVE_INCREMENT",100)
	 ent:SetVar("DELAY",0.01)
	 ent:SetVar("DEFAULT_PHYSFORCE", 955)
	 ent:SetVar("DEFAULT_PHYSFORCE_PLYAIR", 15)
	 ent:SetVar("DEFAULT_PHYSFORCE_PLYGROUND", 155)
	 ent.trace=self.TraceLength
	 ent.decal=self.Decal
	 
	 local ent = ents.Create("sw_emitlight_nuke")
	 ent:SetPos( pos + Vector(0,0,1000) ) 
	 ent:Spawn()
	 ent:Activate()
	 ent.RGB_Variable = {["red"] = 255, ["green"] = 130, ["blue"] = 0}
	 ent.Life = 15
	 
	if GetConVar("sw_nuclear_fallout"):GetInt()== 1 then
		local ent = ents.Create("sw_base_radiation_draw_ent")
		ent:SetPos( pos ) 
		ent:Spawn()
		ent:Activate()
		ent.Burst = 50
		ent.RadRadius=35000
		
		local ent = ents.Create("sw_base_radiation_ent")
		ent:SetPos( pos ) 
		ent:Spawn()
		ent:Activate()
		ent.Burst = 50
		ent.RadRadius=35000
	 end			 
	 local ent = ents.Create("sw_shockwave_rumbling")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE",50000)
	 ent:SetVar("SHOCKWAVE_INCREMENT",5000)
	 ent:SetVar("DELAY",0.01)
	 ent:SetVar("SOUND", "sw/bombs/an602_in.mp3")

	 
	 local ent = ents.Create("sw_shockwave_sound_burst")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE",50000)
	 ent:SetVar("SHOCKWAVE_INCREMENT",100)
	 ent:SetVar("DELAY",0.01)
	 ent:SetVar("SOUND", self.ExplosionSound)

	 local ent = ents.Create("sw_shockwave_sound_lowsh")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE",50000)
	 ent:SetVar("SHOCKWAVE_INCREMENT",110)
	 ent:SetVar("DELAY",0.01)
	 ent:SetVar("SOUND", "sw/bombs/abomb.mp3")
	 self:SetModel("models/gibs/scanner_gib02.mdl")
	 self.Exploding = true
	
	 local physo = self:GetPhysicsObject()
	 physo:Wake()
	 physo:EnableMotion(true)
	 for k, v in pairs(ents.FindInSphere(pos,self.SpecialRadius*3)) do
		 if (v:IsValid() or v:IsPlayer()) and (v.forcefielded==false or v.forcefielded==nil) then
			if v:IsValid() and v:GetPhysicsObject():IsValid() then
				v:Ignite(4,0)
			end
		 end
	 end
	 for k, v in pairs(ents.FindInSphere(pos,self.SpecialRadius*2)) do
		if (v:IsValid() or v:IsPlayer()) and (v.forcefielded==false or v.forcefielded==nil) then
			if v:IsPlayer() && v:Alive() then
			    v:SetModel("models/Humans/Charple04.mdl")
				v:Kill()
				ParticleEffectAttach("nuke_player_vaporize_fatman",PATTACH_POINT_FOLLOW,v,0) 
			end
		 end
	 end
	
  	 timer.Simple(2, function()
	     if !self:IsValid() then return end 
		 constraint.RemoveAll(self)
		 util.ScreenShake( pos, 55555, 255, 10, 121000 )
		 self:StopParticles()
     end)
		 if(self:WaterLevel() >= 1) then
		 	 local trdata   = {}
			 local trlength = Vector(0,0,9000)

			 trdata.start   = pos
			 trdata.endpos  = trdata.start + trlength
			 trdata.filter  = self
			 local tr = util.TraceLine(trdata) 

		     local trdat2   = {}
			 trdat2.start   = tr.HitPos
			 trdat2.endpos  = trdata.start - trlength
			 trdat2.filter  = self
			 trdat2.mask    = MASK_WATER + CONTENTS_TRANSLUCENT
			 
			 local tr2 = util.TraceLine(trdat2)
			 
			 if tr2.Hit then
		         ParticleEffect(self.EffectWater, tr2.HitPos, Angle(0,0,0), nil)
		    
			 end
		 else
		     local tracedata    = {}
	         tracedata.start    = pos
		     tracedata.endpos   = tracedata.start - Vector(0, 0, self.TraceLength)
		     tracedata.filter   = self.Entity
				
		     local trace = util.TraceLine(tracedata)
	     
		     if trace.HitWorld then
		         ParticleEffect(self.Effect,pos,Angle(0,0,0),nil)	
			     timer.Simple(2, function()
			         if !self:IsValid() then return end 
			         ParticleEffect("",trace.HitPos,Angle(0,0,0),nil)	
				     self:Remove()
             end)	
		     else 
			     ParticleEffect(self.EffectAir,pos,Angle(0,0,0),nil) 
				 --Here we do an emp check
				 timer.Simple(2, function()
					 if !self:IsValid() then return end 
					 ParticleEffect("",trace.HitPos,Angle(0,0,0),nil)	
					 self:Remove()
				end)	
				if(GetConVar("sw_nuclear_emp"):GetInt() >= 1) then
					 local ent = ents.Create("sw_emp_entity")
					 ent:SetPos( self:GetPos() ) 
					 ent:Spawn()
					 ent:Activate()	
				 end
		     end
		 end
end

function ENT:SpawnFunction( ply, tr )
     if ( !tr.Hit ) then return end
	 self.GBOWNER = ply
     local ent = ents.Create( self.ClassName )
	 ent:SetPhysicsAttacker(ply)
     ent:SetPos( tr.HitPos + tr.HitNormal * 56 ) 
     ent:Spawn()
     ent:Activate()

     return ent
end
AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		= true
ENT.AdminOnly		= true

ENT.PrintName		                 =  "Mark 3"
ENT.Author			                 =  "Shermann Wolf"
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/sw/avia/bombs/mk3.mdl"                      
ENT.Effect                           =  "fatman_main"                  
ENT.EffectAir                        =  "fatman_air"                     
ENT.EffectWater                      =  "water_huge"
ENT.ExplosionSound                   =  "sw/bombs/an602_detonate.mp3"
ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"            
ENT.ActivationSound                  =  "buttons/button14.wav"     

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  false
ENT.UseRandomSounds                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  50000
ENT.PhysForce                        =  5000
ENT.ExplosionRadius                  =  4000
ENT.SpecialRadius                    =  4000
ENT.MaxIgnitionTime                  =  0
ENT.Life                             =  25                                  
ENT.MaxDelay                         =  2                                 
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  1300
ENT.Mass                             =  18500
ENT.ArmDelay                         =  0   
ENT.Timer                            =  0

ENT.GBOWNER                          =  nil             -- don't you fucking touch this.
ENT.Decal                            = "nuke_medium"
function ENT:Initialize()
 if (SERVER) then
     self:SetModel(self.Model)
	 self:PhysicsInit( SOLID_VPHYSICS )
	 self:SetSolid( SOLID_VPHYSICS )
	 self:SetMoveType( MOVETYPE_VPHYSICS )
	 self:SetUseType( ONOFF_USE ) -- doesen't fucking work
	 local phys = self:GetPhysicsObject()
	 if (phys:IsValid()) then
		 phys:SetMass(self.Mass)
		 phys:Wake()
     end 
	 if(self.Dumb) then
	     self.Armed    = true
	 else
	     self.Armed    = false
	 end
	 self.Exploded = false
	 self.Used     = false
	 self.Arming = false
	 self.Exploding = false
	  if !(WireAddon == nil) then self.Inputs   = Wire_CreateInputs(self, { "Arm", "Detonate" }) end
	end
end

function ENT:PhysicsCollide( data, physobj )
     if(self.Exploded) then return end
     if(!self:IsValid()) then return end
	 if(self.Life <= 0) then return end
	 if(data.Speed > 200) then
		if math.random(1,2)==1 then
			self:EmitSound("sw/bombs/an602land.wav", 80, math.random(90,110))
		else
			self:EmitSound("sw/bombs/an602land2.wav", 80, math.random(90,110))
		end
	 end
	 if(GetConVar("sw_fragility"):GetInt() >= 1) then
	     if(data.Speed > self.ImpactSpeed) then
	 	     if(!self.Armed and !self.Arming) then

	             self:Arm()
	         end
		 end
	 end
	 if(!self.Armed) then return end
     if self.ShouldExplodeOnImpact then
	     if (data.Speed > self.ImpactSpeed ) then
			 self.Exploded = true
			 self:Explode()
		 end
	 end
end

function ENT:Explode()
     if !self.Exploded then return end
	 if self.Exploding then return end
	
	 local pos = self:LocalToWorld(self:OBBCenter())
	 local ent = ents.Create("sw_shockwave_ent")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE",35000)
	 ent:SetVar("SHOCKWAVE_INCREMENT",100)
	 ent:SetVar("DELAY",0.01)
	 ent:SetVar("DEFAULT_PHYSFORCE", 955)
	 ent:SetVar("DEFAULT_PHYSFORCE_PLYAIR", 15)
	 ent:SetVar("DEFAULT_PHYSFORCE_PLYGROUND", 155)
	 ent.trace=self.TraceLength
	 ent.decal=self.Decal
	 
	 local ent = ents.Create("sw_emitlight_nuke")
	 ent:SetPos( pos + Vector(0,0,1000) ) 
	 ent:Spawn()
	 ent:Activate()
	 ent.RGB_Variable = {["red"] = 255, ["green"] = 130, ["blue"] = 0}
	 ent.Life = 15
	 
	if GetConVar("sw_nuclear_fallout"):GetInt()== 1 then
		local ent = ents.Create("sw_base_radiation_draw_ent")
		ent:SetPos( pos ) 
		ent:Spawn()
		ent:Activate()
		ent.Burst = 50
		ent.RadRadius=35000
		
		local ent = ents.Create("sw_base_radiation_ent")
		ent:SetPos( pos ) 
		ent:Spawn()
		ent:Activate()
		ent.Burst = 50
		ent.RadRadius=35000
	 end			 
	 local ent = ents.Create("sw_shockwave_rumbling")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE",50000)
	 ent:SetVar("SHOCKWAVE_INCREMENT",5000)
	 ent:SetVar("DELAY",0.01)
	 ent:SetVar("SOUND", "sw/bombs/an602_in.mp3")

	 
	 local ent = ents.Create("sw_shockwave_sound_burst")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE",50000)
	 ent:SetVar("SHOCKWAVE_INCREMENT",100)
	 ent:SetVar("DELAY",0.01)
	 ent:SetVar("SOUND", self.ExplosionSound)

	 local ent = ents.Create("sw_shockwave_sound_lowsh")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE",50000)
	 ent:SetVar("SHOCKWAVE_INCREMENT",110)
	 ent:SetVar("DELAY",0.01)
	 ent:SetVar("SOUND", "sw/bombs/abomb.mp3")
	 self:SetModel("models/gibs/scanner_gib02.mdl")
	 self.Exploding = true
	
	 local physo = self:GetPhysicsObject()
	 physo:Wake()
	 physo:EnableMotion(true)
	 for k, v in pairs(ents.FindInSphere(pos,self.SpecialRadius*3)) do
		 if (v:IsValid() or v:IsPlayer()) and (v.forcefielded==false or v.forcefielded==nil) then
			if v:IsValid() and v:GetPhysicsObject():IsValid() then
				v:Ignite(4,0)
			end
		 end
	 end
	 for k, v in pairs(ents.FindInSphere(pos,self.SpecialRadius*2)) do
		if (v:IsValid() or v:IsPlayer()) and (v.forcefielded==false or v.forcefielded==nil) then
			if v:IsPlayer() && v:Alive() then
			    v:SetModel("models/Humans/Charple04.mdl")
				v:Kill()
				ParticleEffectAttach("nuke_player_vaporize_fatman",PATTACH_POINT_FOLLOW,v,0) 
			end
		 end
	 end
	
  	 timer.Simple(2, function()
	     if !self:IsValid() then return end 
		 constraint.RemoveAll(self)
		 util.ScreenShake( pos, 55555, 255, 10, 121000 )
		 self:StopParticles()
     end)
		 if(self:WaterLevel() >= 1) then
		 	 local trdata   = {}
			 local trlength = Vector(0,0,9000)

			 trdata.start   = pos
			 trdata.endpos  = trdata.start + trlength
			 trdata.filter  = self
			 local tr = util.TraceLine(trdata) 

		     local trdat2   = {}
			 trdat2.start   = tr.HitPos
			 trdat2.endpos  = trdata.start - trlength
			 trdat2.filter  = self
			 trdat2.mask    = MASK_WATER + CONTENTS_TRANSLUCENT
			 
			 local tr2 = util.TraceLine(trdat2)
			 
			 if tr2.Hit then
		         ParticleEffect(self.EffectWater, tr2.HitPos, Angle(0,0,0), nil)
		    
			 end
		 else
		     local tracedata    = {}
	         tracedata.start    = pos
		     tracedata.endpos   = tracedata.start - Vector(0, 0, self.TraceLength)
		     tracedata.filter   = self.Entity
				
		     local trace = util.TraceLine(tracedata)
	     
		     if trace.HitWorld then
		         ParticleEffect(self.Effect,pos,Angle(0,0,0),nil)	
			     timer.Simple(2, function()
			         if !self:IsValid() then return end 
			         ParticleEffect("",trace.HitPos,Angle(0,0,0),nil)	
				     self:Remove()
             end)	
		     else 
			     ParticleEffect(self.EffectAir,pos,Angle(0,0,0),nil) 
				 --Here we do an emp check
				 timer.Simple(2, function()
					 if !self:IsValid() then return end 
					 ParticleEffect("",trace.HitPos,Angle(0,0,0),nil)	
					 self:Remove()
				end)	
				if(GetConVar("sw_nuclear_emp"):GetInt() >= 1) then
					 local ent = ents.Create("sw_emp_entity")
					 ent:SetPos( self:GetPos() ) 
					 ent:Spawn()
					 ent:Activate()	
				 end
		     end
		 end
end

function ENT:SpawnFunction( ply, tr )
     if ( !tr.Hit ) then return end
	 self.GBOWNER = ply
     local ent = ents.Create( self.ClassName )
	 ent:SetPhysicsAttacker(ply)
     ent:SetPos( tr.HitPos + tr.HitNormal * 56 ) 
     ent:Spawn()
     ent:Activate()

     return ent
end