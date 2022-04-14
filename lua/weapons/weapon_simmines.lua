AddCSLuaFile()

CreateConVar( "sv_simfphys_maxmines", "3", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"max mines" )

SWEP.Category				= "simfphys"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.ViewModel			= "models/weapons/v_slam.mdl"
SWEP.WorldModel			= "models/blu/mine.mdl"
SWEP.UseHands				= false
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 10
SWEP.Weight 				= 42
SWEP.AutoSwitchTo 			= true
SWEP.AutoSwitchFrom 		= true
SWEP.HoldType				= "slam"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip		= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "slam"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo		= "none"

function SWEP:SetupDataTables()
end

if CLIENT then
	SWEP.PrintName		= "Mines"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 11
	SWEP.IconLetter			= "k"
	
	--SWEP.WepSelectIcon 			= surface.GetTextureID( "weapons/s_repair" ) 
	SWEP.DrawWeaponInfoBox 	= false
	
	SWEP.pViewModel = ClientsideModel("models/blu/mine.mdl", RENDERGROUP_OPAQUE)
	SWEP.pViewModel:SetNoDraw( true )
	
	function SWEP:ViewModelDrawn()
		if IsValid( self.Owner ) then
			local vm = self.Owner:GetViewModel()			
			local bm = vm:GetBoneMatrix(0)
			local pos =  bm:GetTranslation()
			local ang =  bm:GetAngles()	
			
			pos = pos + ang:Up() * 220
			pos = pos + ang:Right() * 2
			pos = pos + ang:Forward() * -12
			
			ang:RotateAroundAxis(ang:Forward(), 45)
			ang:RotateAroundAxis(ang:Right(),120)
			ang:RotateAroundAxis(ang:Up(), 0)
			
			self.pViewModel:SetPos(pos)
			self.pViewModel:SetAngles(ang)
			self.pViewModel:DrawModel()
		end
	end
	
	function SWEP:DrawWorldModel()
		if not IsValid( self.Owner ) then self:DrawModel() return end
		
		local id = self.Owner:LookupAttachment("anim_attachment_rh")
		local attachment = self.Owner:GetAttachment( id )
		
		if not attachment then return end

		local pos = attachment.Pos + attachment.Ang:Forward() * 2
		local ang = attachment.Ang
		ang:RotateAroundAxis(attachment.Ang:Up(), 20)
		ang:RotateAroundAxis(attachment.Ang:Right(), -30)
		ang:RotateAroundAxis(attachment.Ang:Forward(), 0)
		
		self:SetRenderOrigin( pos )
		self:SetRenderAngles( ang )
	
		self:DrawModel()
	end
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( "z", "WeaponIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	end
end

function SWEP:Initialize()
	self.Weapon:SetHoldType( self.HoldType )
end

function SWEP:OwnerChanged()
end

function SWEP:Think()
end

function SWEP:TakePrimaryAmmo( num )
	if self.Weapon:Clip1() <= 0 then

		if self:Ammo1() <= 0 then return end

		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )
		
		return
	end

	self.Weapon:SetClip1( math.max(self.Weapon:Clip1() - num,0) )

end

function SWEP:CanPrimaryAttack()
	self.NextFire = self.NextFire or 0
	
	return self.NextFire <= CurTime() and self:Ammo1() > 0
end

function SWEP:SetNextPrimaryFire( time )
	self.NextFire = time
end

function SWEP:ThrowMine()
	if CLIENT then return end
	
	local ent = ents.Create( "simfphys_antitankmine" )
	local ply = self.Owner

	ply:EmitSound( "npc/zombie/claw_miss1.wav" )

	local Num = 0
	local TimeOldest = 99999999999999
	local Oldest = NULL

	for _,v in ipairs( ents.FindByClass("simfphys_antitankmine" ) ) do
		if v.CreatedBy ~= ply then continue end

		Num = Num + 1

		if TimeOldest > v.CreateTime then
			TimeOldest = v.CreateTime 
			Oldest = v
		end
	end

	if Num >= GetConVar("sv_simfphys_maxmines"):GetInt() then
		if IsValid( Oldest ) then
			Oldest:Remove()
		end
	end

	if IsValid( ent ) then
		local EyeAng = ply:EyeAngles()
		
		ent:SetPos( ply:GetShootPos() - Vector(0,0,10) )
		ent:SetAngles( Angle(0,EyeAng.y,0) )
		ent.Thrown = true
		ent.CreateTime = CurTime()
		ent.CreatedBy = ply
		ent:Spawn()
		ent:Activate()

		ent:SetAttacker( ply )

		if CPPI then
			ent:CPPISetOwner( ply )
		end
		
		local PhysObj = ent:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:SetVelocityInstantaneous( EyeAng:Forward() * 200 + Vector(0,0,150) )
			PhysObj:AddAngleVelocity( VectorRand() * 20 ) 
		end
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self:ThrowMine()

	self:SetNextPrimaryFire( CurTime() + 1.5 )

	self:TakePrimaryAmmo( 1 )

	if SERVER then
		if self:Ammo1() <= 0 then
			self.Owner:StripWeapon( "weapon_simmines" ) 
		end
	end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
end

function SWEP:Holster()
	return true
end
AddCSLuaFile()

CreateConVar( "sv_simfphys_maxmines", "3", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"max mines" )

SWEP.Category				= "simfphys"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.ViewModel			= "models/weapons/v_slam.mdl"
SWEP.WorldModel			= "models/blu/mine.mdl"
SWEP.UseHands				= false
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 10
SWEP.Weight 				= 42
SWEP.AutoSwitchTo 			= true
SWEP.AutoSwitchFrom 		= true
SWEP.HoldType				= "slam"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip		= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "slam"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo		= "none"

function SWEP:SetupDataTables()
end

if CLIENT then
	SWEP.PrintName		= "Mines"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 11
	SWEP.IconLetter			= "k"
	
	--SWEP.WepSelectIcon 			= surface.GetTextureID( "weapons/s_repair" ) 
	SWEP.DrawWeaponInfoBox 	= false
	
	SWEP.pViewModel = ClientsideModel("models/blu/mine.mdl", RENDERGROUP_OPAQUE)
	SWEP.pViewModel:SetNoDraw( true )
	
	function SWEP:ViewModelDrawn()
		if IsValid( self.Owner ) then
			local vm = self.Owner:GetViewModel()			
			local bm = vm:GetBoneMatrix(0)
			local pos =  bm:GetTranslation()
			local ang =  bm:GetAngles()	
			
			pos = pos + ang:Up() * 220
			pos = pos + ang:Right() * 2
			pos = pos + ang:Forward() * -12
			
			ang:RotateAroundAxis(ang:Forward(), 45)
			ang:RotateAroundAxis(ang:Right(),120)
			ang:RotateAroundAxis(ang:Up(), 0)
			
			self.pViewModel:SetPos(pos)
			self.pViewModel:SetAngles(ang)
			self.pViewModel:DrawModel()
		end
	end
	
	function SWEP:DrawWorldModel()
		if not IsValid( self.Owner ) then self:DrawModel() return end
		
		local id = self.Owner:LookupAttachment("anim_attachment_rh")
		local attachment = self.Owner:GetAttachment( id )
		
		if not attachment then return end

		local pos = attachment.Pos + attachment.Ang:Forward() * 2
		local ang = attachment.Ang
		ang:RotateAroundAxis(attachment.Ang:Up(), 20)
		ang:RotateAroundAxis(attachment.Ang:Right(), -30)
		ang:RotateAroundAxis(attachment.Ang:Forward(), 0)
		
		self:SetRenderOrigin( pos )
		self:SetRenderAngles( ang )
	
		self:DrawModel()
	end
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( "z", "WeaponIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	end
end

function SWEP:Initialize()
	self.Weapon:SetHoldType( self.HoldType )
end

function SWEP:OwnerChanged()
end

function SWEP:Think()
end

function SWEP:TakePrimaryAmmo( num )
	if self.Weapon:Clip1() <= 0 then

		if self:Ammo1() <= 0 then return end

		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )
		
		return
	end

	self.Weapon:SetClip1( math.max(self.Weapon:Clip1() - num,0) )

end

function SWEP:CanPrimaryAttack()
	self.NextFire = self.NextFire or 0
	
	return self.NextFire <= CurTime() and self:Ammo1() > 0
end

function SWEP:SetNextPrimaryFire( time )
	self.NextFire = time
end

function SWEP:ThrowMine()
	if CLIENT then return end
	
	local ent = ents.Create( "simfphys_antitankmine" )
	local ply = self.Owner

	ply:EmitSound( "npc/zombie/claw_miss1.wav" )

	local Num = 0
	local TimeOldest = 99999999999999
	local Oldest = NULL

	for _,v in ipairs( ents.FindByClass("simfphys_antitankmine" ) ) do
		if v.CreatedBy ~= ply then continue end

		Num = Num + 1

		if TimeOldest > v.CreateTime then
			TimeOldest = v.CreateTime 
			Oldest = v
		end
	end

	if Num >= GetConVar("sv_simfphys_maxmines"):GetInt() then
		if IsValid( Oldest ) then
			Oldest:Remove()
		end
	end

	if IsValid( ent ) then
		local EyeAng = ply:EyeAngles()
		
		ent:SetPos( ply:GetShootPos() - Vector(0,0,10) )
		ent:SetAngles( Angle(0,EyeAng.y,0) )
		ent.Thrown = true
		ent.CreateTime = CurTime()
		ent.CreatedBy = ply
		ent:Spawn()
		ent:Activate()

		ent:SetAttacker( ply )

		if CPPI then
			ent:CPPISetOwner( ply )
		end
		
		local PhysObj = ent:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:SetVelocityInstantaneous( EyeAng:Forward() * 200 + Vector(0,0,150) )
			PhysObj:AddAngleVelocity( VectorRand() * 20 ) 
		end
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self:ThrowMine()

	self:SetNextPrimaryFire( CurTime() + 1.5 )

	self:TakePrimaryAmmo( 1 )

	if SERVER then
		if self:Ammo1() <= 0 then
			self.Owner:StripWeapon( "weapon_simmines" ) 
		end
	end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
end

function SWEP:Holster()
	return true
end