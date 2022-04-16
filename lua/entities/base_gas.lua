AddCSLuaFile()

DEFINE_BASECLASS( "base_fire" )


ENT.Base							 =	"base_anim"
ENT.Spawnable		            	 =  false
ENT.AdminSpawnable		             =  false     

ENT.PrintName		                 =  "Gas"        
ENT.Author			                 =  ""      
ENT.Contact			                 =  ""      

ENT.GBOWNER                          =  nil            
ENT.DAMAGE_MUL						 = 1
ENT.Radius							 = 1400
ENT.Lifetime						 = 18
ENT.Damage							 = 20,50
ENT.Rate							 = 0.5

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/mm1/box.mdl")
		self:SetSolid(SOLID_NONE)
		self:SetMoveType(MOVETYPE_NONE)
		self.GBOWNER = self:GetVar("GBOWNER")
		self.DeathTime = CurTime() + self.Lifetime
		
		self.GBOWNER = IsValid(self.GBOWNER) and self.GBOWNER or (IsValid(self.Owner) and self.Owner or self)
	end
	
	local CurTime = CurTime
	local DamageInfo = DamageInfo
	
	function ENT:Think()
		local ct = CurTime()
		local dmg = DamageInfo()
		
		dmg:SetDamage(self.Damage)
		
		dmg:SetAttacker(self.GBOWNER or self)
		dmg:SetDamageType(DMG_NERVEGAS)
		
		for k, v in ipairs(ents.FindInSphere(self:GetPos(),self.Radius)) do
			if (v:IsPlayer() or v:IsNPC()) and not v:GetNWBool("SH_GasMask",false) and v:GetClass() != "npc_helicopter" then
				v:TakeDamageInfo(dmg)
			end
		end
		
		if ct >= self.DeathTime then 
			self:Remove() 
			
			return
		end
		
		self:NextThink(ct + self.Rate)
		return true
	end
end