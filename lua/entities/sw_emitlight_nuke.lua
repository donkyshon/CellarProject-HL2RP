
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.Spawnable			= false
ENT.RenderGroup 		= RENDERGROUP_BOTH

local matLight 			= Material( "sprites/light_ignorez" )
local matBeam			= Material( "effects/lamp_beam" )

AccessorFunc( ENT, "Texture", "FlashlightTexture" )

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 1, "On" );
	self:NetworkVar( "Bool", 1, "Toggle" );
	self:NetworkVar( "Float", 0, "LightFOV" );
	self:NetworkVar( "Float", 0, "Distance" );
	self:NetworkVar( "Float", 0, "Brightness" );

end



function ENT:Initialize()
	if ( SERVER ) then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )
		self:SetModel("models/props_junk/PopCan01a.mdl")
		self:SetAngles(Angle(90,0,50))	
		self.TimePassed = 0
		self.Brightness=8000	
		local phys = self:GetPhysicsObject()
	
		if ( IsValid( phys ) ) then
			phys:Wake()
		end
	
		self:SetNoDraw(false)
		
		
	end
	if ( CLIENT ) then
		self.PixVis = util.GetPixelVisibleHandle()
	end
	
end

function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
end

function ENT:GetEntityDriveMode()
	return "drive_noclip"
end

function ENT:Use( activator, caller )
end

function ENT:Update( )
	
	local angForward = self:GetAngles()
	self.flashlight = ents.Create( "env_projectedtexture" )
	self.flashlight:SetParent( self.Entity )
	self.flashlight:SetLocalPos( Vector( 0, 0, 0 ) )
	self.flashlight:SetLocalAngles( Angle(0,0,0) )
	self.flashlight:SetKeyValue( "enableshadows", 1 )
	self.flashlight:SetKeyValue( "farz", 50048)
	self.flashlight:SetKeyValue( "nearz", 12 )
	self.flashlight:SetKeyValue( "lightfov", 179 )
	
	local b = self.Brightness
	self.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", self.RGB_Variable["red"] * b, self.RGB_Variable["green"] * b, self.RGB_Variable["blue"] * b ) )	
	self.flashlight:Spawn()
	self.flashlight:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight/soft" )

end

function ENT:MoveUp()
	self:SetPos(self:GetPos()+Vector(0,0,2))
end

function ENT:DimLight()
	self.Brightness=math.Clamp(8000-(8000/self.Life)*self.TimePassed, 0, 8000)
end

function ENT:ColorShift()
	if self.TimePassed < 1 then
		self.RGB_Variable["red"]=self.RGB_Static["red"]*self.TimePassed
		self.RGB_Variable["green"]=self.RGB_Static["green"]*self.TimePassed
	end
	
end
function ENT:Initialise_Static()
	if self.StaticCreated then return end
	self.StaticCreated=true
	
	self.RGB_Static={["red"] = self.RGB_Variable["red"], ["green"] = self.RGB_Variable["green"], ["blue"] = self.RGB_Variable["blue"]}

end

function ENT:Think()
	if (SERVER) then
		if !self:IsValid() then return end
		if GetConVarNumber( "sw_nuke_light" )==0 then return end
		self.TimePassed=self.TimePassed+0.01
		self:Initialise_Static()
		self:ColorShift()
		self:MoveUp() 
		self:DimLight()
		self:Update()
		self.flashlight:Remove()
		
		
		if self.TimePassed>=self.Life then
			self:Remove()
		end
		
		self:NextThink( CurTime()+0.01)
		return true		
	end
end



function ENT:Draw()
	BaseClass.Draw( self )
end



AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.Spawnable			= false
ENT.RenderGroup 		= RENDERGROUP_BOTH

local matLight 			= Material( "sprites/light_ignorez" )
local matBeam			= Material( "effects/lamp_beam" )

AccessorFunc( ENT, "Texture", "FlashlightTexture" )

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 1, "On" );
	self:NetworkVar( "Bool", 1, "Toggle" );
	self:NetworkVar( "Float", 0, "LightFOV" );
	self:NetworkVar( "Float", 0, "Distance" );
	self:NetworkVar( "Float", 0, "Brightness" );

end



function ENT:Initialize()
	if ( SERVER ) then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )
		self:SetModel("models/props_junk/PopCan01a.mdl")
		self:SetAngles(Angle(90,0,50))	
		self.TimePassed = 0
		self.Brightness=8000	
		local phys = self:GetPhysicsObject()
	
		if ( IsValid( phys ) ) then
			phys:Wake()
		end
	
		self:SetNoDraw(false)
		
		
	end
	if ( CLIENT ) then
		self.PixVis = util.GetPixelVisibleHandle()
	end
	
end

function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
end

function ENT:GetEntityDriveMode()
	return "drive_noclip"
end

function ENT:Use( activator, caller )
end

function ENT:Update( )
	
	local angForward = self:GetAngles()
	self.flashlight = ents.Create( "env_projectedtexture" )
	self.flashlight:SetParent( self.Entity )
	self.flashlight:SetLocalPos( Vector( 0, 0, 0 ) )
	self.flashlight:SetLocalAngles( Angle(0,0,0) )
	self.flashlight:SetKeyValue( "enableshadows", 1 )
	self.flashlight:SetKeyValue( "farz", 50048)
	self.flashlight:SetKeyValue( "nearz", 12 )
	self.flashlight:SetKeyValue( "lightfov", 179 )
	
	local b = self.Brightness
	self.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", self.RGB_Variable["red"] * b, self.RGB_Variable["green"] * b, self.RGB_Variable["blue"] * b ) )	
	self.flashlight:Spawn()
	self.flashlight:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight/soft" )

end

function ENT:MoveUp()
	self:SetPos(self:GetPos()+Vector(0,0,2))
end

function ENT:DimLight()
	self.Brightness=math.Clamp(8000-(8000/self.Life)*self.TimePassed, 0, 8000)
end

function ENT:ColorShift()
	if self.TimePassed < 1 then
		self.RGB_Variable["red"]=self.RGB_Static["red"]*self.TimePassed
		self.RGB_Variable["green"]=self.RGB_Static["green"]*self.TimePassed
	end
	
end
function ENT:Initialise_Static()
	if self.StaticCreated then return end
	self.StaticCreated=true
	
	self.RGB_Static={["red"] = self.RGB_Variable["red"], ["green"] = self.RGB_Variable["green"], ["blue"] = self.RGB_Variable["blue"]}

end

function ENT:Think()
	if (SERVER) then
		if !self:IsValid() then return end
		if GetConVarNumber( "sw_nuke_light" )==0 then return end
		self.TimePassed=self.TimePassed+0.01
		self:Initialise_Static()
		self:ColorShift()
		self:MoveUp() 
		self:DimLight()
		self:Update()
		self.flashlight:Remove()
		
		
		if self.TimePassed>=self.Life then
			self:Remove()
		end
		
		self:NextThink( CurTime()+0.01)
		return true		
	end
end



function ENT:Draw()
	BaseClass.Draw( self )
end

