if SERVER then
	AddCSLuaFile()
end

DEFINE_BASECLASS("base_entity")

ENT.PrintName		= "Outcast Scanner Terminal"
ENT.Category		= "HL2 RP"
ENT.Spawnable		= true
ENT.AdminOnly		= true
ENT.RenderGroup 	= RENDERGROUP_BOTH
ENT.IsScannerTerminal = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_lab/monitor02.mdl")
		self:SetSkin(2)

		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetHealth(20)
		self:SetSolid(SOLID_VPHYSICS)

		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
			physicsObject:EnableMotion(true)
		end
	end

	function ENT:CanTool(player, trace, tool)
		return false
	end

	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end
else
	function ENT:Draw()
		self:DrawModel()
	end

	ENT.PopulateEntityInfo = true

	function ENT:GetEntityMenu()
		local options = {
			["Deploy"] = function()
				net.Start("ScannerTerminalDeploy2")
					net.WriteEntity(self)
				net.SendToServer()

				return false
			end
		}

		return options
	end

	function ENT:OnPopulateEntityInfo(tooltip)
		local name = tooltip:AddRow("name")
		name:SetText("Scanner Controlling Device")
		name:SizeToContents()
	end
end