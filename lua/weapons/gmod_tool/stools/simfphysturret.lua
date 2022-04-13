TOOL.Category		= "simfphys"
TOOL.Name		= "#tool.simfphysturret.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

cleanup.Register( "simfphysturrets" )
CreateConVar("sbox_maxsimfphysturrets", 1, "FCVAR_NOTIFY")

TOOL.ClientConVar[ "delay" ] 		= "0.2"
TOOL.ClientConVar[ "damage" ] 		= "100"
TOOL.ClientConVar[ "force" ] 		= "50"
TOOL.ClientConVar[ "size" ] 		= "3"
TOOL.ClientConVar[ "deflectang" ] 	= "40"
TOOL.ClientConVar[ "blastdamage" ] 	= "50"
TOOL.ClientConVar[ "blasteffect" ] 	= "simfphys_tankweapon_explosion_micro"

if CLIENT then
	language.Add( "tool.simfphysturret.name", "Projectile Turret" )
	language.Add( "tool.simfphysturret.desc", "A Tool used to spawn Turrets" )
	language.Add( "tool.simfphysturret.0", "Left click to spawn or update a turret" )
	language.Add( "tool.simfphysturret.1", "Left click to spawn or update a turret" )
	
	language.Add( "Cleanup_simfphysturrets", "simfphys Projectile Turret" )
	language.Add( "Cleaned_simfphysturrets", "Cleaned up all simfphys Projectile Turrets" )
	
	language.Add( "SBoxLimit_simfphysturrets", "You've reached the Projectile Turret limit!" )
end

function TOOL:LeftClick( trace )

	if (CLIENT) then return true end
	
	local ply = self:GetOwner()

	if not istable( WireLib ) then
		ply:PrintMessage( HUD_PRINTTALK, "[SIMFPHYS ARMED]: WIREMOD REQUIRED" )
		ply:SendLua( "gui.OpenURL( 'https://steamcommunity.com/sharedfiles/filedetails/?id=160250458' )") 
	end
	
	if IsValid( trace.Entity ) and trace.Entity:GetClass():lower() == "simfphys_turret" then 
		self:UpdateTurret( trace.Entity )
	else
		local turret = self:MakeTurret( ply, trace.HitPos + trace.HitNormal * 5 )
		
		undo.Create("Turret")
			undo.AddEntity( turret )
			undo.AddEntity( weld )
			undo.SetPlayer( ply )
		undo.Finish()
	end
	
	return true
end

function TOOL:RightClick( trace )
	return false
end

if SERVER then
	local ValidFX = {
		["simfphys_tankweapon_explosion"] = true,
		["simfphys_tankweapon_explosion_micro"] = true,
		["simfphys_tankweapon_explosion_small"] = true,
	}

	function TOOL:UpdateTurret( ent )
		if not IsValid( ent ) then return end
	
		ent:SetShootDelay( math.Clamp(self:GetClientNumber( "delay" ),0.2,2) )
		ent:SetDamage( math.Clamp(self:GetClientNumber( "damage" ),0,5000) )
		ent:SetForce( math.Clamp(self:GetClientNumber( "force" ),0,10000) )
		ent:SetSize( math.Clamp(self:GetClientNumber( "size" ),3,15) )
		ent:SetDeflectAng( math.Clamp(self:GetClientNumber( "deflectang" ),0,45) )
		ent:SetBlastDamage( math.Clamp(self:GetClientNumber( "blastdamage" ),0,1500) )
		
		local FX = self:GetClientInfo( "blasteffect" )
		
		ent:SetBlastEffect( ValidFX[ FX ] and FX or "simfphys_tankweapon_explosion_micro" )
	end

	function TOOL:MakeTurret( ply, Pos, Ang )

		if not ply:CheckLimit( "simfphysturrets" ) then return NULL end

		local turret = ents.Create( "simfphys_turret" )
		
		if not IsValid( turret )  then return NULL end

		turret:SetPos( Pos )
		turret:SetAngles( Angle(0,0,0) )
		turret:Spawn()
		
		turret.Attacker = ply
		
		self:UpdateTurret( turret )

		ply:AddCount( "simfphysturrets", turret )
		ply:AddCleanup( "simfphysturrets", turret )

		return turret
	end
end

local ConVarsDefault = TOOL:BuildConVarList()
function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "simfphys_turrets", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Header", { Text = "#tool.simfphysturret.name", Description	= "#tool.simfphysturret.desc" }  )

	CPanel:AddControl( "Slider",  { Label	= "Shoot Delay",
									Type	= "Float",
									Min		= 0.2,
									Max		= 2.0,
									Command = "simfphysturret_delay" }	 )
									
	CPanel:AddControl( "Slider",  { Label	= "Damage",
									Type	= "Float",
									Min		= 0,
									Max		= 5000,
									Command = "simfphysturret_damage" }	 )

	CPanel:AddControl( "Slider",  { Label	= "Force",
									Type	= "Float",
									Min		= 0,
									Max		= 10000,
									Command = "simfphysturret_force" }	 )

	CPanel:AddControl( "Slider",  { Label	= "Size",
									Type	= "Float",
									Min		= 3,
									Max		= 15,
									Command = "simfphysturret_size" }	 )

	CPanel:AddControl( "Slider",  { Label	= "Max Deflect Angle",
									Type	= "Float",
									Min		= 0,
									Max		= 45,
									Command = "simfphysturret_deflectang" }	 )
									
	CPanel:AddControl( "Slider",  { Label	= "Blast Damage",
									Type	= "Float",
									Min		= 0,
									Max		= 1500,
									Command = "simfphysturret_blastdamage" }	 )


	local BlastEffect = {Label = "Blast Effect", MenuButton = 0, Options={}, CVars = {}}
	BlastEffect["Options"]["Small Explosion"]			= { simfphysturret_blasteffect = "simfphys_tankweapon_explosion_micro" }
	BlastEffect["Options"]["Medium Explosion"]			= { simfphysturret_blasteffect = "simfphys_tankweapon_explosion_small" }
	BlastEffect["Options"]["Large Explosion"]			= { simfphysturret_blasteffect = "simfphys_tankweapon_explosion" }

	CPanel:AddControl("ComboBox", BlastEffect )
end
