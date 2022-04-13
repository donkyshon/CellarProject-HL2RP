AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable		            	 =  false        
ENT.AdminSpawnable		             =  false

ENT.PrintName		                 =  "EMP Device"
ENT.Author			                 =  "Shermann Wolf"
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "sw/avia/bombs/emp.mdl"                      
ENT.Effect                           =  "emp_main"                  
ENT.EffectAir                        =  "emp_main"                   
ENT.EffectWater                      =  "water_huge"
ENT.ExplosionSound                   =  "sw/bombs/emp.mp3"
ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"            
ENT.ActivationSound                  =  "buttons/button14.wav"     

ENT.ShouldUnweld                     =  false
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  false
ENT.UseRandomSounds                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  25
ENT.PhysForce                        =  5
ENT.ExplosionRadius                  =  5
ENT.SpecialRadius                    =  1250
ENT.MaxIgnitionTime                  =  0
ENT.Life                             =  25                                  
ENT.MaxDelay                         =  2                                 
ENT.TraceLength                      =  100
ENT.ImpactSpeed                      =  700
ENT.Mass                             =  500
ENT.ArmDelay                         =  1   
ENT.Timer                            =  0
ENT.Shocktime                        = 0.1
ENT.GBOWNER                          =  nil            

function ENT:Initialize()
 if (SERVER) then
     self:SetModel(self.Model)
	 self:PhysicsInit( SOLID_VPHYSICS )
	 self:SetSolid( SOLID_VPHYSICS )
	 self:SetMoveType( MOVETYPE_VPHYSICS )
	 self:SetUseType( ONOFF_USE )
	 local phys = self:GetPhysicsObject()
	 if (phys:IsValid()) then
		 phys:SetMass(self.Mass)
		 phys:Wake()
     end 
	 local pos = self:GetPos()
	 for k, v in pairs(ents.FindInSphere(pos,30000)) do
		 if v:IsValid() then
			 if(v.isWacAircraft) && (v.active==true) then
				v:setEngine(false)
				v.engineDead = true							 
				ParticleEffectAttach("emp_electrify_model",PATTACH_POINT_FOLLOW,v,0) 
			 end
			if v:GetClass()=="prop_vehicle_jeep" or v:GetClass()=="prop_vehicle_airboat" then 
				v:EmitSound("ambient/machines/spindown.wav")
				local ent = ents.Create("sw_emp_v_dead")
				ent:SetPos(v:GetPos() ) 
				ent:Spawn()
				ent:Activate()
				ent.radowner = v
				ParticleEffectAttach("emp_electrify_model",PATTACH_POINT_FOLLOW,v,0) 
				timer.Simple(math.random(), function()
					local sound = string.Explode(" ",table.Random(emp_soundlist))[1]
					ent:EmitSound(sound)
				end)
			 end
			 if(GetConVar("sw_safeemp"):GetInt() >= 1) then
				 if math.random(1,10)==10 then
					 if(table.HasValue(emp_whiteragdolllist,v:GetClass())) then
					 local ent = ents.Create("prop_ragdoll")
						 local old_ent_constrains = constraint.GetAllConstrainedEntities( v )
						 local old_angle = v:GetAngles( )
						 ent:SetPos( v:LocalToWorld(self:OBBCenter()) ) 
						 ent:SetModel(v:GetModel())
						 ent:Spawn()
						 ent:Activate()
						 ent:SetColor(Color(65,65,65,255))
						 ent:Ignite(5,0)
						 ent:SetAngles(old_angle)
						 v:Remove()
						 ParticleEffectAttach("emp_electrify_model",PATTACH_POINT_FOLLOW,ent,0) 
						 timer.Simple(math.random(), function()
							local sound = string.Explode(" ",table.Random(emp_soundlist))[1]
							ent:EmitSound(sound)
						 end)
						 timer.Simple(math.random(4,5)+math.random(), function()
							if !ent:IsValid() then return end
							ent:Remove()
						 end)
					 end		
					 
					 if v:GetClass()=="npc_grenade_frag" then
						 local ent = ents.Create("prop_physics")
						 local old_ent_constrains = constraint.GetAllConstrainedEntities( v )
						 local old_angle = v:GetAngles( )
						 ent:SetPos( v:LocalToWorld(self:OBBCenter()) ) 	
						 ent:SetModel(v:GetModel())
						 ent:Spawn()
						 ent:Activate()
						 ent:SetColor(Color(65,65,65,255))
						 ent:Ignite(5,0)
						 ent:SetAngles(old_angle)
						 v:Remove()
						 ParticleEffectAttach("emp_electrify_model",PATTACH_POINT_FOLLOW,ent,0) 
						 timer.Simple(math.random(), function()
							local sound = string.Explode(" ",table.Random(emp_soundlist))[1]
							ent:EmitSound(sound)
						 end)
						 timer.Simple(math.random(4,5)+math.random(), function()
							if !ent:IsValid() then return end
							ent:Remove()
						 end)
					 end		
					 
					 if(table.HasValue(emp_whitelist,v:GetClass())) then
						 local ent = ents.Create("prop_physics")
						 local old_ent_constrains = constraint.GetAllConstrainedEntities( v )
						 local old_angle = v:GetAngles( )
						 ent:SetPos( v:LocalToWorld(self:OBBCenter()) ) 
						 ent:SetModel(v:GetModel())
						 ent:Spawn()
						 ent:Activate()
						 ent:SetVar("GBOWNER",ply)
						 ent:SetColor(Color(65,65,65,255))
						 ent:Ignite(5,0)
						 ent:SetAngles(old_angle)
						 for _, Prop in pairs (old_ent_constrains) do
							constraint.Weld( ent, Prop, 0, 0, 0, true, false )	
						 end
						 v:Remove()
						 ParticleEffectAttach("emp_electrify_model",PATTACH_POINT_FOLLOW,ent,0) 
						 timer.Simple(math.random(), function()
							local sound = string.Explode(" ",table.Random(emp_soundlist))[1]
							ent:EmitSound(sound)
						 end)
						 timer.Simple(math.random(4,5)+math.random(), function()
							if !ent:IsValid() then return end
							ent:Remove()
						 end)
					 end
				end
			else
				if(table.HasValue(emp_whiteragdolllist,v:GetClass())) then
					 local ent = ents.Create("prop_ragdoll")
					 local old_ent_constrains = constraint.GetAllConstrainedEntities( v )
					 local old_angle = v:GetAngles( )
					 ent:SetPos( v:LocalToWorld(self:OBBCenter()) ) 
					 ent:SetModel(v:GetModel())
					 ent:Spawn()
					 ent:Activate()
					 ent:SetColor(Color(65,65,65,255))
					 ent:Ignite(5,0)
					 ent:SetAngles(old_angle)
					 v:Remove()
					 ParticleEffectAttach("emp_electrify_model",PATTACH_POINT_FOLLOW,ent,0) 
					 timer.Simple(math.random(), function()
						local sound = string.Explode(" ",table.Random(emp_soundlist))[1]
						ent:EmitSound(sound)
					 end)
					 timer.Simple(math.random(4,5)+math.random(), function()
						if !ent:IsValid() then return end
						ent:Remove()
					 end)
				 end		
				 
				 if v:GetClass()=="npc_grenade_frag" then
					 local ent = ents.Create("prop_physics")
					 local old_ent_constrains = constraint.GetAllConstrainedEntities( v )
					 local old_angle = v:GetAngles( )
					 ent:SetPos( v:LocalToWorld(self:OBBCenter()) ) 	
					 ent:SetModel(v:GetModel())
					 ent:Spawn()
					 ent:Activate()
					 ent:SetColor(Color(65,65,65,255))
					 ent:Ignite(5,0)
					 ent:SetAngles(old_angle)
					 v:Remove()
					 ParticleEffectAttach("emp_electrify_model",PATTACH_POINT_FOLLOW,ent,0) 
					 timer.Simple(math.random(), function()
						local sound = string.Explode(" ",table.Random(emp_soundlist))[1]
						ent:EmitSound(sound)
					 end)
					 timer.Simple(math.random(4,5)+math.random(), function()
						if !ent:IsValid() then return end
						ent:Remove()
					 end)
				 end		
				 
				 if(table.HasValue(emp_whitelist,v:GetClass())) then
					 local ent = ents.Create("prop_physics")
					 local old_ent_constrains = constraint.GetAllConstrainedEntities( v )
					 local old_angle = v:GetAngles( )
					 ent:SetPos( v:LocalToWorld(self:OBBCenter()) ) 
					 ent:SetModel(v:GetModel())
					 ent:Spawn()
					 ent:Activate()
					 ent:SetVar("GBOWNER",ply)
					 ent:SetColor(Color(65,65,65,255))
					 ent:Ignite(5,0)
					 ent:SetAngles(old_angle)
					 for _, Prop in pairs (old_ent_constrains) do
						constraint.Weld( ent, Prop, 0, 0, 0, true, false )	
					 end
					 v:Remove()
					 ParticleEffectAttach("emp_electrify_model",PATTACH_POINT_FOLLOW,ent,0) 
					 timer.Simple(math.random(), function()
						local sound = string.Explode(" ",table.Random(emp_soundlist))[1]
						ent:EmitSound(sound)
					 end)
					 timer.Simple(math.random(4,5)+math.random(), function()
						if !ent:IsValid() then return end
						ent:Remove()
					 end)
				 end
			end
		 end
	 end 
	 
	self:Remove()
	end
end
