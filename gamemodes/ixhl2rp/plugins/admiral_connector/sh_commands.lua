
local PLUGIN = PLUGIN

ix.command.Add("EconomyInfo", {
	description = "Get all info about an economy object - user/character/account/transaction",
	superAdminOnly = true,
	arguments = {ix.type.string, ix.type.string},
	OnRun = function(self, client, type, object_id)
		ix.admiral.EconomyInfo(client, ix.admiral.InfoCallbackToChat, type, object_id)
	end
})

ix.command.Add("EconomyRegisterChar", {
	description = "Force Register Char",
	superAdminOnly = true,
	arguments = ix.type.character,
	OnRun = function(self, client, target)
		ix.admiral.RegisterCharacter(client, ix.admiral.InfoCallbackToChat, target)
	end
})

ix.command.Add("EconomyRegisterUser", {
	description = "Force Register User",
	superAdminOnly = true,
	arguments = ix.type.character,
	OnRun = function(self, client, target)
		ix.admiral.RegisterUser(client, ix.admiral.InfoCallbackToChat, target:GetPlayer())
	end
})

ix.command.Add("EconomyCreatePersonalAccount", {
	description = "Create personal account for user",
	superAdminOnly = true,
	arguments = ix.type.character,
	OnRun = function(self, client, target)
		ix.admiral.CreatePersonalAccount(client, ix.admiral.InfoCallbackToChat, target)
	end
})

ix.command.Add("EconomyRegisterAllItems", {
	description = "Register all items",
	superAdminOnly = true,
	OnRun = function(self, client)
		ix.admiral.RegisterAllItems(client)
	end
})

ix.command.Add("EconomyVendorRegister", {
	description = "Register a vendor in economy system",
	superAdminOnly = true,
	OnRun = function(self, client)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_vendor") then

			--if (target.economy_id != "" and target.economy_id != economy_id) then
			--	return
			--end
			
			ix.admiral.RegisterVendor(client, target, target.economy_id)
		end
	end
})
-- ix.admiral.RegisterTerminal

ix.command.Add("EconomyTerminalRegister", {
	description = "Register a terminal in economy system",
	superAdminOnly = true,
	OnRun = function(self, client)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_ecoterminal") then

			--if (target.economy_id != "" and target.economy_id != economy_id) then
			--	return
			--end
			
			ix.admiral.RegisterTerminal(client, target)
		end
	end
})

ix.command.Add("EconomyVendorChangeStatus", {
	description = "Register a vendor in economy system",
	superAdminOnly = true,
	OnRun = function(self, client)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_vendor") then
			target:OnChangedLegalStatus('test')
			client:Notify(string.format("Legal status: %s", target.legal_status))
		end
	end
})

ix.command.Add("EconomyVendorChangeID", {
	description = "Change vendor's economy ID",
	superAdminOnly = true,
	arguments = ix.type.string,
	OnRun = function(self, client, economy_id)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_vendor") then
			target:OnChangedEconomyID(economy_id)
			client:Notify(string.format("Vendor Economy ID: %s", target.economy_id))
		end
	end
})

ix.command.Add("EconomyVendorInfo", {
	description = "Get vendor data",
	superAdminOnly = true,
	OnRun = function(self, client)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_vendor") then
			client:Notify(string.format("Vendor's ID: %s, status: %s", target.economy_id, target.legal_status))
		end
	end
})

ix.command.Add("EconomyTerminalChangeID", {
	description = "Change terminal's ID",
	superAdminOnly = true,
	arguments = ix.type.string,
	OnRun = function(self, client, terminal_id)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_ecoterminal") then
			target:OnChangedTerminalID(terminal_id)
			client:Notify(string.format("Terminal's ID: %s", target.terminal_id))
		end
	end
})

ix.command.Add("EconomyTerminalInfo", {
	description = "Get terminal data",
	superAdminOnly = true,
	OnRun = function(self, client)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_ecoterminal") then
			client:Notify(string.format("Terminal's ID: %s, type: %s", target.terminal_id, target.terminal_type))
		end
	end
})

ix.command.Add("EconomyTerminalChangeType", {
	description = "Change terminal's type",
	superAdminOnly = true,
	arguments = ix.type.string,
	OnRun = function(self, client, terminal_type)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_ecoterminal") then
			target:OnChangedTerminalType(terminal_type)
			client:Notify(string.format("Terminal's type: %s", target.terminal_type))
		end
	end
})

ix.command.Add("CheckOwnBalance", {
	description = "Check your own balance",
	OnRun = function(self, client)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_ecoterminal") then
			ix.admiral.RequestBalanceNotify(client)
		end
		
	end
})

ix.command.Add("EconomyDepositTokens", {
	description = "Deposit tokens to your account",
	arguments = ix.type.number,
	superAdminOnly = true,
	OnRun = function(self, client, amount)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_ecoterminal") then
			ix.admiral.PersonalTokensToCredits(client, amount)
		end
		
	end
})

ix.command.Add("ConvertTokens", {
	description = "Convert tokens to credits",
	arguments = ix.type.number,
	OnRun = function(self, client, amount)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_ecoterminal" and target.terminal_type == 'generic') then
			-- ix.admiral.PersonalTokensToCredits(client, amount)
			ix.admiral.MoneyConvertCheck(client, client:GetCharacter(), target.terminal_id, 'token', amount)
		end
		
	end
})

ix.command.Add("BuyLP", {
	description = "Buy loyalty points for credits",
	arguments = ix.type.number,
	OnRun = function(self, client, amount)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_ecoterminal" and target.terminal_type == 'generic') then
			-- ix.admiral.PersonalTokensToCredits(client, amount)
			ix.admiral.MoneyConvertCheck(client, client:GetCharacter(), target.terminal_id, 'loyalty', amount)
		end
	end

})

ix.command.Add("UpgradeLoyalty", {
	description = "Upgrade your loyalty level",
	OnRun = function(self, client)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_ecoterminal" and target.terminal_type == 'generic') then
			-- ix.admiral.PersonalTokensToCredits(client, amount)
			ix.admiral.MoneyConvertCheck(client, client:GetCharacter(), target.terminal_id, 'level', 1)
		end
	end

})

ix.command.Add("Economy", {
	description = "Open economy interface",
	OnRun = function(self, client)
		character = client:GetCharacter()
		faction_object = character:GetFaction()
		faction_indice = ix.faction.indices[faction_object]
		faction_id = faction_indice.uniqueID
		-- faction = ix.faction.indices[character:GetFaction()].uniqueID
		net.Start("ixEcoOpen")
			net.WriteString(faction_id)
			--net.WriteEntity(self)
			--net.WriteUInt(self.money or 0, 16)
			--net.WriteTable(items)
			--net.WriteTable(prices)
			--net.WriteFloat(self.scale or 0.5)
			--net.WriteString(self.legal_status)
		net.Send(client)
	end
})

ix.command.Add("EconomyTransferMoney", {
	description = "Transfer money",
	superAdminOnly = true,
	arguments = {ix.type.number, ix.type.number},
	OnRun = function(self, client, amount, target_account)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_ecoterminal") then
			ix.admiral.PaymentToSomeone(client, amount, target_account)
		end
		
	end
})

ix.command.Add("EconomySelfRegister", {
	description = "Register own card",
	superAdminOnly = true,
	OnRun = function(self, client)
		ix.admiral.CardGiveProperEconomyID(client)
	end
})

ix.command.Add("EconomySetPar", {
	description = "Set Economy Parameter",
	superAdminOnly = true,
	arguments = {ix.type.string, ix.type.string, ix.type.string, ix.type.string},
	OnRun = function(self, client, type, id, par, value)
		ix.admiral.SetEconomyParameter(client, type, id, par, value)
	end
})

ix.command.Add("ItemChangeBasePrice", {
	description = "Change item price",
	superAdminOnly = true,
	arguments = {ix.type.string, ix.type.number},
	OnRun = function(self, client, item_id, price)
		ix.admiral.SetItemPrice(client, item_id, price)
	end
})
