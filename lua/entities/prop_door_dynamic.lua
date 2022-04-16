
AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"

ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	if ( CLIENT ) then return end

	self.Locked = false
	self.Opened = false
	self.NextToggle = 0
	self.CloseDelay = 0

	-- self:PhysicsInit( SOLID_VPHYSICS )

	self.door = ents.Create( "prop_dynamic" )
	self.door:SetModel( self:GetModel() )
	self.door:SetPos( self:GetPos() )
	self.door:SetAngles( self:GetAngles() )
	self.door:SetKeyValue( "solid", "6" )
	self.door:SetKeyValue( "MinAnimTime", "1" )
	self.door:SetKeyValue( "MaxAnimTime", "5" )
	self.door.ClassOverride = "prop_door_dynamic"
	self.door.RB655_Prop_Door_Dynamic = self

	-- self.door:SetParent( self )

	self.door:Spawn()
	self.door:Activate()

	self:SetParent( self.door )

	self.door:DeleteOnRemove( self )
	self:DeleteOnRemove( self.door )

	if ( self:GetModel() == "models/props/portal_door_combined.mdl" ) then
		self.Opened = true
		self:Close()
	end

end

function ENT:SetCloseDelay( num )
	self.CloseDelay = tonumber( num )
end

function ENT:GetSequenceDuration()
	return self.door:SequenceDuration()
	--return self:SequenceDuration()
end
function ENT:PlayAnimation( str )
	-- self:ResetSequence( self:LookupSequence( str ) ) -- This produces double sounds

	--[[self.door:ResetSequenceInfo()
	self.door:SetPlaybackRate( 1 )
	self.door:SetCycle( 0 )]]
	self.door:ResetSequence( self.door:LookupSequence( str ) ) -- This is for SequenceDuration to work

	self.door:Fire( "SetAnimation", str ) -- The actual animation
end

function ENT:Open()
	if ( self.NextToggle > CurTime() || self.Locked || self.Opened == true ) then return end

	self:PlayAnimation( "Open" )

	local model = self:GetModel():lower()
	if ( model == "models/props_mining/elevator01_cagedoor.mdl" ) then
		self:EmitSound( "ambient/levels/outland/ol04elevatorgate_up.wav" )
	end
	if ( model == "models/props_mining/techgate01.mdl" || model == "models/props_mining/techgate01_outland03.mdl" ) then
		self:EmitSound( "ambient/levels/outland/ol03_slidingoverhead_open.wav" )
	end
	if ( model == "models/props_lab/elevatordoor.mdl" ) then
		self:EmitSound( "plats/hall_elev_door.wav" )
	end
	if ( model == "models/props/portal_door_combined.mdl" ) then
		self:EmitSound( "plats/door_round_blue_unlock_01.wav" )
		timer.Simple( SoundDuration("plats/door_round_blue_unlock_01.wav") - 0.3, function()
			if ( !IsValid( self ) ) then return end
			self:EmitSound( "plats/door_round_blue_open_01.wav" )
		end )
	end
	if ( model == "models/combine_gate_vehicle.mdl" ) then
		self:EmitSound( "Doors.CombineGate_citizen_move1" )
		self:EmitSound( "plats/hall_elev_door.wav" )
		timer.Simple( self:GetSequenceDuration() - 0.7, function()
			if ( !IsValid( self ) ) then return end
			self:StopSound( "Doors.CombineGate_citizen_move1" )
			self:EmitSound( "Doors.CombineGate_citizen_stop2" )
		end )
	end

	self.NextToggle = CurTime() + self:GetSequenceDuration()
	self.Opened = true

	if ( self.CloseDelay < 0 ) then return end
	timer.Create( "rb655_door_autoclose_" .. self:EntIndex(), self:GetSequenceDuration() + self.CloseDelay, 1, function() if ( IsValid( self ) ) then self:Close() end end )
end

function ENT:Close()
	if ( self.NextToggle > CurTime() || self.Locked || self.Opened == false ) then return end

	timer.Remove( "rb655_door_autoclose_" .. self:EntIndex() )

	self:PlayAnimation( "close" )

	local model = self:GetModel():lower()
	if ( model == "models/props_mining/elevator01_cagedoor.mdl" ) then
		self:EmitSound( "ambient/levels/outland/ol01a_gate_open.wav" )
	end
	if ( model == "models/props_mining/techgate01.mdl" || model == "models/props_mining/techgate01_outland03.mdl" ) then
		self:EmitSound( "ambient/levels/outland/ol03_slidingoverhead_open.wav" )
	end
	if ( model == "models/props_lab/elevatordoor.mdl" ) then
		self:EmitSound( "plats/elevator_stop1.wav" )
	end
	if ( model == "models/props/portal_door_combined.mdl" ) then
		self:EmitSound( "plats/door_round_blue_close_01.wav" )
		timer.Simple( SoundDuration("plats/door_round_blue_close_01.wav") - 0.3, function()
			if ( !IsValid( self ) ) then return end
			self:EmitSound( "plats/door_round_blue_lock_01.wav" )
		end )
	end
	if ( model == "models/combine_gate_vehicle.mdl" ) then
		self:EmitSound( "Doors.CombineGate_citizen_move1" )
		self:EmitSound( "plats/hall_elev_door.wav" )
		timer.Simple( self:GetSequenceDuration() - 0.7, function()
			if ( !IsValid( self ) ) then return end
			self:StopSound( "Doors.CombineGate_citizen_move1" )
			self:EmitSound( "Doors.CombineGate_citizen_stop2" )
		end )
	end

	self.NextToggle = CurTime() + self:GetSequenceDuration()
	self.Opened = false
end

function ENT:OnRemove()
	if ( SERVER ) then
		self:StopSound( "Doors.Move10" ) -- Small combine doors
		self:StopSound( "Doors.Move11" ) -- Kleiner lab door
		self:StopSound( "Doors.Move12" ) -- Vertical combine doors
		self:StopSound( "Doors.CombineGate_citizen_move1" ) -- Big Combine doors

		-- Same stuff for the engine entity
		self.door:StopSound( "Doors.Move10" )
		self.door:StopSound( "Doors.Move11" )
		self.door:StopSound( "Doors.Move12" )
		self.door:StopSound( "Doors.CombineGate_citizen_move1" )
	end
end

function ENT:OnEntityCopyTableFinish( data )
	for k, v in pairs( data ) do data[ k ] = nil end
end

function ENT:AcceptInput( name, activator, caller, data )
	name = string.lower( name )

	if ( name == "open" && self.NextToggle < CurTime() && !self.Locked && self.Opened == false ) then
		self:Open()
	elseif ( name == "close" && self.NextToggle < CurTime() && !self.Locked && self.Opened == true ) then
		self:Close()
	elseif ( name == "lock" ) then
		self.Locked = true
	elseif ( name == "unlock" ) then
		self.Locked = false
	end
end

function ENT:Think()
	if ( CLIENT ) then
		self:DestroyShadow()
	end
end

function ENT:Draw()
	-- self:DrawModel()
end
