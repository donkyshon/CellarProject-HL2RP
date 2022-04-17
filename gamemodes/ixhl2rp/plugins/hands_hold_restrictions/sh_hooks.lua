
local speedMultipliers = {}

local function GetHeldChar(client)
	local heldPlayer = client.ixHeldPlayer

	if (IsValid(heldPlayer)) then
		return heldPlayer
	end

	return false
end

function PLUGIN:InitializedPlugins()
	speedMultipliers[FACTION_OTA] = 0.25
	speedMultipliers[FACTION_EOW] = 0.25
end

function PLUGIN:SetupMove(client, moveData)
	local heldPlayer = GetHeldChar(client)

	if (heldPlayer) then
		if (client:IsProne() and prone.CanExit(client)) then
			prone.Exit(client)
		end

		moveData:SetMaxClientSpeed(client:GetWalkSpeed() * (speedMultipliers[heldPlayer:Team()] or 0.5))
	end
end

PLUGIN["prone.CanEnter"] = function(_, client)
	if (GetHeldChar(client)) then
		return false
	end
end
