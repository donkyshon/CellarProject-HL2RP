
ENT.Type = "anim"
ENT.PrintName = "EcoTerminal"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminOnly = true
-- ENT.isVendor = true
ENT.isTerminal = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
	-- self:NetworkVar("Bool", 0, "NoBubble")
	self:NetworkVar("String", 0, "DisplayName")
	self:NetworkVar("String", 1, "Description")
end

function ENT:Initialize()
	if (SERVER) then
		self:SetModel("models/props_combine/combine_intmonitor001.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_NONE)
		
		self.terminal_type = 'generic'
		self.terminal_id = ''

		self:SetDisplayName("The Economy Terminal")
		self:SetDescription("It has no hands but it must rub")

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end
end

function ENT:CanAccess(client)
	
	if !ix.admiral.GetProperCardID(client:GetCharacter()) then
		return false
	end

	return true
end



if (SERVER) then
	local PLUGIN = PLUGIN

	function ENT:SpawnFunction(client, trace)
		local angles = (trace.HitPos - client:GetPos()):Angle()
		angles.r = 0
		angles.p = 0
		angles.y = angles.y + 180

		local entity = ents.Create("ix_ecoterminal")
		entity:SetPos(trace.HitPos)
		entity:SetAngles(angles)
		entity:Spawn()

		-- PLUGIN:SaveData()

		return entity
	end
	
	function ENT:OnChangedTerminalType(terminal_type)
		self.terminal_type = terminal_type
		
		PLUGIN:SaveData()
	end
	
	function ENT:OnChangedTerminalID(terminal_id)
		self.terminal_id = terminal_id
		PLUGIN:SaveData()
	end
	
	function ENT:Use(activator)
		local character = activator:GetCharacter()

		if !self:CanAccess(activator) then
			activator:Notify("Access denied.")
			ix.admiral.CardGiveProperEconomyID(activator)
			return
		end
		ix.admiral.RequestTerminalResponse(activator, character, self.terminal_id)
		-- ix.admiral.RequestBalanceNotify(activator)
	end

else

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Think()

		self:SetNextClientThink(CurTime() + 0.25)

		return true
	end

	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText(self:GetDisplayName())
		name:SizeToContents()

		local descriptionText = self:GetDescription()

		if (descriptionText != "") then
			local description = container:AddRow("description")
			description:SetText(self:GetDescription())
			description:SizeToContents()
		end
	end
end


ENT.Type = "anim"
ENT.PrintName = "EcoTerminal"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminOnly = true
-- ENT.isVendor = true
ENT.isTerminal = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
	-- self:NetworkVar("Bool", 0, "NoBubble")
	self:NetworkVar("String", 0, "DisplayName")
	self:NetworkVar("String", 1, "Description")
end

function ENT:Initialize()
	if (SERVER) then
		self:SetModel("models/props_combine/combine_intmonitor001.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_NONE)
		
		self.terminal_type = 'generic'
		self.terminal_id = ''

		self:SetDisplayName("The Economy Terminal")
		self:SetDescription("It has no hands but it must rub")

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end
end

function ENT:CanAccess(client)
	
	if !ix.admiral.GetProperCardID(client:GetCharacter()) then
		return false
	end

	return true
end



if (SERVER) then
	local PLUGIN = PLUGIN

	function ENT:SpawnFunction(client, trace)
		local angles = (trace.HitPos - client:GetPos()):Angle()
		angles.r = 0
		angles.p = 0
		angles.y = angles.y + 180

		local entity = ents.Create("ix_ecoterminal")
		entity:SetPos(trace.HitPos)
		entity:SetAngles(angles)
		entity:Spawn()

		-- PLUGIN:SaveData()

		return entity
	end
	
	function ENT:OnChangedTerminalType(terminal_type)
		self.terminal_type = terminal_type
		
		PLUGIN:SaveData()
	end
	
	function ENT:OnChangedTerminalID(terminal_id)
		self.terminal_id = terminal_id
		PLUGIN:SaveData()
	end
	
	function ENT:Use(activator)
		local character = activator:GetCharacter()

		if !self:CanAccess(activator) then
			activator:Notify("Access denied.")
			ix.admiral.CardGiveProperEconomyID(activator)
			return
		end
		ix.admiral.RequestTerminalResponse(activator, character, self.terminal_id)
		-- ix.admiral.RequestBalanceNotify(activator)
	end

else

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Think()

		self:SetNextClientThink(CurTime() + 0.25)

		return true
	end

	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText(self:GetDisplayName())
		name:SizeToContents()

		local descriptionText = self:GetDescription()

		if (descriptionText != "") then
			local description = container:AddRow("description")
			description:SetText(self:GetDescription())
			description:SizeToContents()
		end
	end
end
