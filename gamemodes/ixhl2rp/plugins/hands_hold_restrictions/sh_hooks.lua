
local speedMultipliers = {
	[FACTION_OTA] = 0.25
}

local function IsCarryingCharInCrit(client)
	local hands = client.ixActiveHands

	if (IsValid(hands)) then
		local heldPlayer = IsValid(hands.heldEntity) and hands.heldEntity.ixPlayer

		if (heldPlayer and heldPlayer:GetNetVar("crit")) then
			return heldPlayer
		end
	end

	return false
end

-- we don't want to use pretty heavy ActiveWeapon func
function PLUGIN:PlayerSwitchWeapon(client, _, weapon)
	weapon = weapon:GetClass() == "ix_hands" and weapon or nil

	if (weapon != client.ixActiveHands) then
		client.ixActiveHands = weapon
	end
end

function PLUGIN:SetupMove(client, moveData)
	local heldPlayer = IsCarryingCharInCrit(client)

	if (heldPlayer) then
		if (client:IsProne() and prone.CanExit(client)) then
			prone.Exit(client)
		end

		moveData:SetMaxClientSpeed(client:GetWalkSpeed() * (speedMultipliers[heldPlayer:Team()] or 0.5))
	end
end

PLUGIN["prone.CanEnter"] = function(_, client)
	if (IsCarryingCharInCrit(client)) then
		return false
	end
end
