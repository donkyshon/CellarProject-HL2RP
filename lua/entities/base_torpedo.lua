AddCSLuaFile()
DEFINE_BASECLASS( "base_rocket" )

local ExploSnds = {}
ExploSnds[1]                      =  "chappi/imp0.wav"

local damagesound                    =  "weapons/rpg/shotdown.wav"


ENT.Spawnable		            	 =  false
ENT.AdminSpawnable		             =  false

ENT.PrintName		                 =  "Gredwitch's Torpedo base"
ENT.Author			                 =  "Gredwitch"
ENT.Contact			                 =  "contact.gredwitch@gmail.com"
ENT.Category                         =  "Explosives"

ENT.Model                            =  ""
ENT.RocketTrail                      =  ""
ENT.Effect                           =  ""
ENT.EffectAir                        =  ""
ENT.EffectWater                      =  ""

ENT.ExplosionSound                   =  ENT.ExplosionSound
ENT.FarExplosionSound				 =  ENT.ExplosionSound
ENT.DistExplosionSound				 =  ENT.ExplosionSound

ENT.WaterExplosionSound				 =	nil
ENT.WaterFarExplosionSound			 =  nil

ENT.StartSound                       =  ""
ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"
ENT.ActivationSound                  =  "buttons/button14.wav"
ENT.EngineSound                      =  "Missile.Ignite"
ENT.NBCEntity                        =  ""

ENT.ShouldUnweld                     =  false
ENT.ShouldIgnite                     =  false
ENT.UseRandomSounds                  =  false
ENT.SmartLaunch                      =  false
ENT.Timed                            =  false
ENT.IsNBC                            =  false

ENT.ExplosionDamage                  =  0
ENT.ExplosionRadius                  =  0
ENT.PhysForce                        =  0
ENT.SpecialRadius                    =  0
ENT.MaxIgnitionTime                  =  5
ENT.Life                             =  20
ENT.MaxDelay                         =  2
ENT.TraceLength                      =  500
ENT.ImpactSpeed                      =  500
ENT.Mass                             =  0
ENT.EnginePower                      =  0             
ENT.FuelBurnoutTime                  =  0             
ENT.IgnitionDelay                    =  0          
ENT.ForceOrientation                 =  "NORMAL"
ENT.Timer                            =  0


ENT.LightEmitTime                    =  0
ENT.LightRed                         =  0
ENT.LightBlue						 =  0
ENT.LightGreen						 =  0
ENT.LightBrightness					 =  0
ENT.LightSize   					 =  0
ENT.RSound   						 =  1



ENT.GBOWNER                          =  nil             -- don't you fucking touch this.

function ENT:PhysicsCollide( data, physobj )
	 timer.Simple(0,function()
     if(self.Exploded) then return end
     if(!self:IsValid()) then return end
	 if(self.Life <= 0) then return end
		 if(GetConVar("gred_sv_fragility"):GetInt() >= 1) then
			 if(!self.Fired and !self.Burnt and !self.Arming and !self.Armed ) and (data.Speed > self.ImpactSpeed * 5) then --and !self.Arming and !self.Armed
				 if(math.random(0,9) == 1) then
					 self:Launch()
					 self:EmitSound(damagesound)
				 else
					 self:Arm()
					 self:EmitSound(damagesound)
				 end
			 end
		 end

		 if(!self.Armed) then return end
			
		 if (data.Speed > self.ImpactSpeed )then
			 self.Exploded = true
			 self:Explode()
		 end
	end)
end
function ENT:Launch()
    if(self.Exploded) then return end
	if(self.Burned) then return end
	if(self.Fired) then return end
	if(!self.Armed) then return end
	if self:WaterLevel() < 1 then return end
	 
	 local phys = self:GetPhysicsObject()
	 if !phys:IsValid() then return end
	 
	 if(self.SmartLaunch) then
		 constraint.RemoveAll(self)
	 end
	 timer.Simple(0,function()
	     if not self:IsValid() then return end
	     if(phys:IsValid()) then
             phys:Wake()
		     phys:EnableMotion(true)
	     end
	 end)
	 self.Fired = true
end


function ENT:Think()
    if(self.Burnt) then return end
	if(self.Exploded) then return end -- if we exploded then what the fuck are we doing here
	if(!self:IsValid()) then return end -- if we aren't good then something fucked up
	local phys = self:GetPhysicsObject()  
	local thrustpos = self:GetPos()
	self:Launch()
	ParticleEffectAttach("weapon_tracers_smoke",PATTACH_ABSORIGIN_FOLLOW,self,1)
	if self.Fired and self:WaterLevel() > 2 then
		self:SetAngles(Angle(0,self:GetAngles().y,0))
		phys:AddVelocity(self:GetForward() * self.EnginePower)
	elseif self.Fired and self:WaterLevel() <= 1 then
		self:SetPos(self:GetPos()-Vector(0,0,50))
		self:SetAngles(Angle(0,self:GetAngles().y,0))
		phys:AddVelocity(self:GetForward() * self.EnginePower)
	end
	self:AddOnThink()
end

function ENT:Use( activator, caller )
     if(self.Exploded) then return end
	 if(self.Dumb) then return end
	 if(GetConVar("gred_sv_easyuse"):GetInt() >= 1) then
         if(self:IsValid()) then
             if (!self.Exploded) and (!self.Burnt) and (!self.Fired) then
	             if (activator:IsPlayer()) then
                    self:EmitSound(self.ActivationSound)
                    self:Arm()
                    self:Launch()
		         end
	         end
         end
	 end
end
