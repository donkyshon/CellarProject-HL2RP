local PLUGIN = PLUGIN

PLUGIN.name = ""
PLUGIN.description = ""
PLUGIN.author = ""

if (CLIENT) then return end

economyCashBack = {}

do
	local economyDump = util.JSONToTable(file.Read("economy_dump.json", "DATA"))

	for _, entry in ipairs(economyDump) do
		if not economyCashBack[entry["char_id"]] then
			economyCashBack[entry["char_id"]] = entry["balance"]
		else
			if economyCashBack[entry["char_id"]] != entry["balance"] then
				economyCashBack[entry["char_id"]] = economyCashBack[entry["char_id"]] + entry["balance"]
			end
		end
	end
end


function PLUGIN:PlayerLoadedCharacter(client, character, currentChar)
	if not character:GetData("cashback", false) then
		local charID = character:GetID()
		local cashback = economyCashBack[charID]
		if not cashback then cashback = 0 end

		character:SetMoney(character:GetMoney() + cashback)
		character:SetData("cashback", true)
		timer.Simple(5, function()
			ix.util.Notify(Format("Вам выданы наличные средства в размере %s жетонов", cashback), client)
		end)
	end
end
