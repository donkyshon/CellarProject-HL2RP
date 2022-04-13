
local PLUGIN = PLUGIN

ix.command.Add("EconomyInfo", {
	description = "Get all info about an economy object - user/character/account/transaction",
	superAdminOnly = true,
	arguments = {ix.type.string, ix.type.number},
	OnRun = function(self, client, type, object_id)
		ix.admiral.EconomyInfo(client, ix.admiral.InfoCallbackToChat, type, object_id)
	end
})

ix.command.Add("EconomyCreate", {
	description = "Create an economy object - user/character/account/transaction",
	superAdminOnly = true,
	OnRun = function(self, client, arguments)
		ix.admiral.EconomyShitpost(client, ix.admiral.InfoCallbackToChat, arguments)
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

ix.command.Add("EconomyInfoUser", {
	description = "Info About User",
	superAdminOnly = true,
	arguments = ix.type.character,
	OnRun = function(self, client, target)
		ix.admiral.EconomyInfo(client, ix.admiral.InfoCallbackToChat, 'user', target:GetPlayer():SteamID64())
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

ix.command.Add("CheckOwnBalance", {
	description = "Check your own balance",
	OnRun = function(self, client)
		ix.admiral.RequestBalanceNotify(client)
	end
})

ix.command.Add("EconomyDepositTokens", {
	description = "Deposit tokens to your account",
	arguments = ix.type.number,
	OnRun = function(self, client, amount)
		ix.admiral.PersonalTokensToCredits(client, amount)
	end
})

ix.command.Add("EconomyTransferMoney", {
	description = "Transfer money",
	arguments = {ix.type.number, ix.type.number},
	OnRun = function(self, client, amount, target_account)
		ix.admiral.PaymentToSomeone(client, amount, target_account)
	end
})