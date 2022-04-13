local PLUGIN = PLUGIN

function PLUGIN:CanPlayerViewInventory()
	if LocalPlayer():GetCharacter():GetData("zstage") == 3 then
		return false
	end
end
