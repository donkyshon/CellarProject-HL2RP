AddCSLuaFile()

DEFINE_BASECLASS( "base_rocket" )

ENT.Spawnable		= true
ENT.AdminOnly		= true

ENT.PrintName		 		=  "Kh-102"
ENT.Author			 		=  "Shermann Wolf"
ENT.Contact			 		=  "shermannwolf@gmail.com"
ENT.Category         		=  "SW Bombs"

ENT.Model              		=  "models/sw/avia/bombs/kh102.mdl"
ENT.RocketTrail        		=  "fire_jet_01"
ENT.RocketBurnoutTrail 		=  "grenadetrail"
ENT.Effect                  =  "littleboy_main"                  
ENT.EffectAir               =  "littleboy_air_main"                   
ENT.EffectWater             =  "water_huge"
ENT.ArmSound                =  "npc/roller/mine/rmine_blip3.wav"            
ENT.ActivationSound         =  "buttons/button14.wav"     
ENT.ExplosionSound          =  "sw/bombs/abomb.mp3"
ENT.StartSound         		=  "sw/bombs/rocket_start_0"..math.random(1,4)..".wav"
ENT.EngineSound        		=  "sw/bombs/rocket_idle.mp3"
ENT.StartSoundFollow		=	true

ENT.ExplosionDamage			=	20000
ENT.ExplosionRadius         =   3500
ENT.SpecialRadius           =   3500
ENT.PhysForce               =  5000
ENT.Mass           			=	64
ENT.EnginePower    			=	999999
ENT.TNTEquivalent			=	3.4
ENT.FuelBurnoutTime			=	50
ENT.LinearPenetration		=	75
ENT.MaxVelocity				=	9999999
ENT.Caliber					=	127
ENT.Decal					=	"nuke_medium"

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

   
   function ENT:Explode()
		if !self.Exploded then return end
		 if self.Exploding then return end
		local pos = self:LocalToWorld(self:OBBCenter())
		 
		 for k, v in pairs(ents.FindInSphere(pos,6000)) do
			  if (v:IsValid() or v:IsPlayer()) and (v.forcefielded==false or v.forcefielded==nil) then
				  if v:IsValid() and v:GetPhysicsObject():IsValid() then
					   v:Ignite(4,0)
				  end
			  end
		 end
		 for k, v in pairs(ents.FindInSphere(pos,self.SpecialRadius)) do
			 if (v:IsValid() or v:IsPlayer()) and (v.forcefielded==false or v.forcefielded==nil) then
				  if v:IsPlayer() && !v:IsNPC() then
					  v:SetModel("models/Humans/Charple04.mdl")
					   ParticleEffectAttach("nuke_player_vaporize_fatman",PATTACH_POINT_FOLLOW,ent,0) 
					   v:Kill()
				  end
			  end
		 end
		 
		 local ent = ents.Create("sw_emitlight_nuke")
		 ent:SetPos( pos + Vector(0,0,1000) ) 
		 ent:Spawn()
		 ent:Activate()
		 ent.RGB_Variable = {["red"] = 179, ["green"] = 175, ["blue"] = 150}
		 ent.Life = 11
		 
   
   
		   timer.Simple(2, function()
			 if !self:IsValid() then return end 
			  local ent = ents.Create("sw_shockwave_ent")
			  ent:SetPos( pos ) 
			  ent:Spawn()
			  ent:Activate()
			  ent:SetVar("DEFAULT_PHYSFORCE", self.DEFAULT_PHYSFORCE)
			  ent:SetVar("DEFAULT_PHYSFORCE_PLYAIR", self.DEFAULT_PHYSFORCE_PLYAIR)
			  ent:SetVar("DEFAULT_PHYSFORCE_PLYGROUND", self.DEFAULT_PHYSFORCE_PLYGROUND)
			  ent:SetVar("GBOWNER", self.GBOWNER)
			  ent:SetVar("MAX_RANGE",8000)
			  ent:SetVar("SHOCKWAVE_INCREMENT",100)
			  ent:SetVar("DELAY",0.01)
			  ent.trace=self.TraceLength
			  ent.decal=self.Decal
			  if GetConVar("sw_nuclear_fallout"):GetInt()== 1 then
				  local ent = ents.Create("sw_base_radiation_draw_ent")
				  ent:SetPos( pos ) 
				  ent:Spawn()
				  ent:Activate()
				  ent.Burst = 25
				  ent.RadRadius=7000
				  
				  local ent = ents.Create("sw_base_radiation_ent")
				  ent:SetPos( pos ) 
				  ent:Spawn()
				  ent:Activate()
				  ent.Burst = 25
				  ent.RadRadius=7000
			 end	
			  local ent = ents.Create("sw_shockwave_rumbling")
			  ent:SetPos( pos ) 
			  ent:Spawn()
			  ent:Activate()
			  ent:SetVar("GBOWNER", self.GBOWNER)
			  ent:SetVar("MAX_RANGE",9000)
			  ent:SetVar("SHOCKWAVE_INCREMENT",200)
			  ent:SetVar("DELAY",0.01)
			  ent:SetVar("SOUND", self.ExplosionSound)
			  self:SetModel("models/gibs/scanner_gib02.mdl")
			  
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
			  ent:SetVar("MAX_RANGE",12000)
			  ent:SetVar("SHOCKWAVE_INCREMENT",100)
			  ent:SetVar("DELAY",0.01)
			  ent:SetVar("SOUND", "sw/bombs/abomb.mp3")
			  
			  self:SetModel("models/gibs/scanner_gib02.mdl")
			  self.Exploding = true
		
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
				   timer.Simple(2, function()
						if !self:IsValid() then return end 
						ParticleEffect("",trace.HitPos,Angle(0,0,0),nil)	
						self:Remove()
				  end)	
				   --Here we do an emp check
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
    if (!tr.Hit) then return end
	
    local ent = ents.Create(self.ClassName)
	ent:SetPhysicsAttacker(ply)
	ent.GBOWNER = ply
    ent:SetPos(tr.HitPos + tr.HitNormal * 16) 
    ent:Spawn()
    ent:Activate()
	
    return ent
end
function ENT:Use(ply)
	if not gred.CVars["gred_sv_easyuse"]:GetBool() or self.Fired then return end
	self:SetBodygroup(0,1)
	self.Owner = ply
	self:EmitSound(self.ActivationSound)
	self:Launch()
end