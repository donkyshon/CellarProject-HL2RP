-- require("reqwest")

ix.admiral = ix.admiral or {}


CITADEL_ACCOUNT = -1
ILLEGAL_ACCOUNT = -2
CITY_ACCOUNT = -4
TRANSACTION_FAIL = '1'
TRANSACTION_AUTO = '2'
TRANSACTION_COMPLETE = '0'

LOCALHOST = "http://127.0.0.1:8000"
REMOTE = "http://194.87.214.31:8000"
admiral_ip = REMOTE

ix.admiral.name = "Admiral's Main Connector"
ix.admiral.description = "Connector to remote application."
ix.admiral.author = "Rodial-Admiral"
ix.admiral.maxLength = 512

--
-- Encodes a character as a percent encoded string
local function char_to_pchar(c)
	return string.format("%%%02X", c:byte(1,1))
end

-- encodeURI replaces all characters except the following with the appropriate UTF-8 escape sequences:
-- ; , / ? : @ & = + $
-- alphabetic, decimal digits, - _ . ! ~ * ' ( )
-- #
local function encodeURI(str)
	return (str:gsub("[^%;%,%/%?%:%@%&%=%+%$%w%-%_%.%!%~%*%'%(%)%#]", char_to_pchar))
end

-- encodeURIComponent escapes all characters except the following: alphabetic, decimal digits, - _ . ! ~ * ' ( )
local function encodeURIComponent(str)
	return (str:gsub("[^%w%-_%.%!%~%*%'%(%)]", char_to_pchar))
end

-- decodeURI unescapes url encoded characters
-- excluding characters that are special in urls
local decodeURI do
	local decodeURI_blacklist = {}
	for char in ("#$&+,/:;=?@"):gmatch(".") do
		decodeURI_blacklist[string.byte(char)] = true
	end
	local function decodeURI_helper(str)
		local x = tonumber(str, 16)
		if not decodeURI_blacklist[x] then
			return string.char(x)
		end
		-- return nothing; gsub will not perform the replacement
	end
	function decodeURI(str)
		return (str:gsub("%%(%x%x)", decodeURI_helper))
	end
end

-- Converts a hex string to a character
local function pchar_to_char(str)
	return string.char(tonumber(str, 16))
end

-- decodeURIComponent unescapes *all* url encoded characters
local function decodeURIComponent(str)
	return (str:gsub("%%(%x%x)", pchar_to_char))
end

-- An iterator over query segments (delimited by "&") as key/value pairs
-- if a query segment has no '=', the value will be `nil`
local function query_args(str)
	local iter, state, first = str:gmatch("([^=&]+)(=?)([^&]*)&?")
	return function(state, last) -- luacheck: ignore 431
		local name, equals, value = iter(state, last)
		if name == nil then return nil end
		name = decodeURIComponent(name)
		if equals == "" then
			value = nil
		else
			value = decodeURIComponent(value)
		end
		return name, value
	end, state, first
end

-- Converts a dictionary (string keys, string values) to an encoded query string
local function dict_to_query(form)
	local r, i = {}, 0
	for name, value in pairs(form) do
		i = i + 1
		r[i] = encodeURIComponent(name).."="..encodeURIComponent(value)
	end
	return table.concat(r, "&", 1, i)
end
--

if (SERVER) then
	util.AddNetworkString("ixEcoOpen")
	util.AddNetworkString("ixEcoSend")
	function PLUGIN:SaveData()
		local data = {}

		for _, entity in ipairs(ents.FindByClass("ix_ecoterminal")) do

			data[#data + 1] = {
				name = entity:GetDisplayName(),
				description = entity:GetDescription(),
				pos = entity:GetPos(),
				angles = entity:GetAngles(),
				model = entity:GetModel(),
				terminal_type = entity.terminal_type,
				terminal_id = entity.terminal_id
			}
		end

		self:SetData(data)
	end

	function PLUGIN:LoadData()
		for _, v in ipairs(self:GetData() or {}) do
			local entity = ents.Create("ix_ecoterminal")
			entity:SetPos(v.pos)
			entity:SetAngles(v.angles)
			entity:Spawn()
			entity:SetModel(v.model)
			entity:SetMoveType(MOVETYPE_NONE)
			entity:SetSolid(SOLID_VPHYSICS)
			-- entity:SetCollisionBounds(Vector(-16, -16, 0), Vector(16, 16, 72))

			local physObj = entity:GetPhysicsObject()

			if (IsValid(physObj)) then
				physObj:EnableMotion(false)
				physObj:Sleep()
			end

			entity:SetDisplayName(v.name)
			entity:SetDescription(v.description)
			entity.terminal_type = v.terminal_type
			entity.terminal_id = v.terminal_id
			entity:OnChangedTerminalID(v.terminal_id)
			entity:OnChangedTerminalType(v.terminal_type)

		end
	end
	
	net.Receive("ixEcoSend", function(length, client)
		

		local operation_type = net.ReadString()
		local reason = net.ReadString()
		local cid = net.ReadUInt(32)
		local amount = net.ReadUInt(32)
		
		print(operation_type, reason, cid, amount)
		ix.admiral.GuiShitpost(client, operation_type, reason, cid, amount)

		
	end)
else
	net.Receive("ixEcoOpen", function()
		faction = net.ReadString()
		ix.gui.ecogui = vgui.Create("ixEcoInter")
		ix.gui.ecogui:SetReadOnly(false)
		ix.gui.ecogui:Setup(faction)
	end)
end

function ix.admiral.PackRequest(request_table)
	for k, v in pairs(request_table) do
		request_table[k] = tostring(v)
	end
	return dict_to_query(request_table)
end

function ix.admiral.PackRequestAlt(request_table)
	for k, v in pairs(request_table) do
		request_table[k] = tostring(v)
	end
	return request_table
end

function ix.admiral.PackString(...)
	local arguments = {...}
	packed_string = ""
	for _, v in pairs(arguments) do
		if type(v) == 'number' then
			v = string.format("%.0f", v)
		end
		packed_string = string.format("%s/%s", packed_string, v)
	end
	-- return packed_string
	return string.format("%s%s", admiral_ip, packed_string)
end
function ix.admiral.PackStringAlt(...)
	local arguments = {...}
	packed_string = ""
	for _, v in pairs(arguments) do
		if type(v) == 'number' then
			v = string.format("%.0f", v)
		end
		packed_string = string.format("%s/%s", packed_string, v)
	end
	-- return packed_string
	return packed_string
end
function ix.admiral.AdmiralFetch(client, callback, request_table)
	

	-- address = ix.admiral.PackString(...)
	packed_string = ix.admiral.PackRequest(request_table)
	address = string.format("%s/%s", admiral_ip, packed_string)
	print(address)
	-- response = nil

	http.Fetch(address,
		function(body, length, headers, code)
			-- response = decodeURI(body)
			-- print('response', response)
			--print('decoded_response:')
			--for k, v in query_args(body) do
			--	print(k, v)
			--end
			--print('---')
			response = ix.admiral.ValidateResponse(body)
			callback(client, response)
			-- response_array = ix.admiral.ResponseToArray(response)
			-- callback(client, ix.admiral.CreateValidObject(response_array))
		end,
		
		function(message)
			print(message)
			print("I somehow got here 2")
			response = message
			if (callback != InfoCallbackToConsole) then
				client:Notify('System Protocol Error: Access Denied')
			end
			return nil
		end
	)
end

function ix.admiral.AdmiralShitpost(client, callback, parameter, request_table)
	address = admiral_ip
	-- request = ix.admiral.PackRequest(request_table)
	-- print(request)
	request = ix.admiral.PackRequestAlt(request_table)
	http.Post(address, request,
		function(body, length, headers, code)
			--print('encoded body: ', body)
			--print('partially decoded body: ', decodeURI(body))
			--print('decoded_response:')
			--for k, v in query_args(body) do
			--	print(k, v)
			--end
			--print('---')
			response = ix.admiral.ValidateResponse(body)
			callback(client, response, parameter)
		end,
		
		function(message)
			print(message)
			print("I somehow got here")
			if (callback != InfoCallbackToConsole) then
				client:Notify('System Protocol Error: Access Denied')
			end
		end
	)
end

function ix.admiral.ValidateResponse(response_body)
	validated_response = {}
	response_iter = query_args(response_body)
	for k, v in response_iter do
		validated_response[k] = v
	end
	return validated_response
end

function ix.admiral.GuiShitpost(client, operation_type, reason, cid, amount)
	character = client:GetCharacter()
	sender_cid = ix.admiral.GetProperCardID(character)
	if (sender_cid == false) then
		client:Notify("ACCESS DENIED.")
		return
	end
	gui_requester = {
	operation = 'gui',
	operation_type = operation_type,
	sender_cid = sender_cid,
	target_cid = cid,
	amount = amount,
	char_id = character:GetID(),
	reason = reason
	}
	ix.admiral.AdmiralShitpost(client, ix.admiral.GuiCallback, character, gui_requester)
end

function ix.admiral.GuiCallback(client, info, parameter)
	if !info.desc then
		client:Notify("An error occured.")
		return
	end
	client:Notify(info.desc)
	if (info.success == 'no') then
		return
	end
end

function ix.admiral.EconomyInfo(client, callback, type, object_id)
	requester_table = {
	type=type,
	id=object_id
	}
	ix.admiral.AdmiralFetch(client, callback, requester_table)
end

function ix.admiral.PlayerLoaded(client)
	requester_table = {
	operation='load',
	user_id=client:SteamID64()
	}
	ix.admiral.AdmiralShitpost(client, ix.admiral.InfoCallbackToConsole, 'nothing', requester_table)
end

function ix.admiral.CharacterLoaded(client, character)
	requester_table = {
	operation='load',
	user_id=client:SteamID64(),
	char_id=character:GetID()
	}
	ix.admiral.AdmiralShitpost(client, ix.admiral.InfoCallbackToConsole, 'nothing', requester_table)
end

function ix.admiral.PersonalTokensToCredits(client, amount)
	character = client:GetCharacter()
	if !character:HasMoney(amount) then
		client:Notify(string.format("You do not have %s tokens.", amount))
		return
	end
	character_account = ix.admiral.GetProperCardID(character)
	transaction_deduct = {
	operation='new',
	type='transaction',
	account_from=CITY_ACCOUNT,
	account_to=character_account,
	amount=amount,
	tech_data=-3}
	ix.admiral.AdmiralShitpost(character:GetPlayer(), ix.admiral.LegallyDeductTokens, 'nothing', transaction_deduct)
end

function ix.admiral.CashFromSalesman(client, character, amount, uniqueID)
	transaction_cash_sale = {
	operation='new',
	type='transaction',
	account_from=ILLEGAL_ACCOUNT,
	account_to=CITADEL_ACCOUNT,
	amount=amount,
	tech_data=uniqueID
	}
	ix.admiral.AdmiralShitpost(character:GetPlayer(), ix.admiral.IllegalSalesmanCompleteSale, uniqueID, transaction_cash_sale)
end
function ix.admiral.CashToSalesman(client, character, amount, uniqueID)
	transaction_cash_buy = {
	operation='new',
	type='transaction',
	account_to=ILLEGAL_ACCOUNT,
	account_from=CITADEL_ACCOUNT,
	amount=amount,
	tech_data=uniqueID
	}
	ix.admiral.AdmiralShitpost(character:GetPlayer(), ix.admiral.IllegalSalesmanCompleteBuy, uniqueID, transaction_cash_buy)
end
function ix.admiral.PaymentFromSalesman(client, character, amount, uniqueID)
	character_account = ix.admiral.GetProperCardID(character)
	transaction_credits_sale = {
	operation='new',
	type='transaction',
	account_from=CITY_ACCOUNT,
	account_to=character_account*2,
	amount=amount,
	tech_data=uniqueID
	}
	ix.admiral.AdmiralShitpost(character:GetPlayer(), ix.admiral.LegalSalesmanCompleteSale, uniqueID, transaction_credits_sale)
end

function ix.admiral.PaymentToSalesman(client, character, amount, uniqueID)
	character_account = ix.admiral.GetProperCardID(character)
	transaction_credits_buy = {
	operation='new',
	type='transaction',
	account_to=CITY_ACCOUNT,
	account_from=character_account*2,
	amount=amount,
	tech_data=uniqueID
	}
	ix.admiral.AdmiralShitpost(character:GetPlayer(), ix.admiral.LegalSalesmanCompleteBuy, uniqueID, transaction_credits_buy)
end

function ix.admiral.PaymentToSomeone(client, amount, target_account)
	character_account = ix.admiral.GetProperCardID(client:GetCharacter())
	transaction_from_personal_to_personal = {
	operation='new',
	type='transaction',
	account_to=target_account*2,
	account_from=character_account*2,
	amount=amount
	}
	ix.admiral.AdmiralShitpost(client, ix.admiral.RequestBalanceNotify, target_account, transaction_from_personal_to_personal)
end

function ix.admiral.LegallyDeductTokens(client, info, parameter)
	ix.admiral.DeductTokens(client, info, CITY_ACCOUNT)
end

function ix.admiral.GetCredits(amount, legal_status)
	if (legal_status == 'legal') then
		currency = 'credit'
	else
		currency = 'token'
	end
	if (amount == 1) then
		return "#1 "..currency.."."
	else
		return "#"..amount.." "..currency.."s"
	end
end

function ix.admiral.RequestTerminalResponse(client, character, terminal_id)
	response_requester = {
	info_type = 'terminal',
	id = terminal_id,
	char_id = character:GetID(),
	account = ix.admiral.GetProperCardID(character)
	}
	ix.admiral.AdmiralFetch(client, ix.admiral.CheckTerminalResponse, response_requester)
end

function ix.admiral.CheckTerminalResponse(client, info)
	if info.success == 'no' then
		client:Notify("Access Denied")
	end
	for k, v in pairs(info) do
		-- test
		client:Notify(string.format("%s: %s", k, v))
	end
	if info.loyalty_level then
		ix.admiral.UpdateLoyaltyLevel(client, info)
	end
end

function ix.admiral.SetItemPrice(client, item_id, price)
	item_price_setter = {
	operation = 'set_price',
	base_price = price,
	id = item_id
	}
	ix.admiral.AdmiralShitpost(client, ix.admiral.InfoCallbackToChat, item_id, item_price_setter)
end

function ix.admiral.UpdateLoyaltyLevel(client, info)
	local dID, datafile, genericdata = ix.plugin.list["datafile"]:ReturnDatafileByID(client.ixDatafile)
	if (genericdata.status == info.loyalty_level) then
		return
	end
	ix.plugin.list["datafile"]:SetCivilStatus(dID, info.loyalty_level)
	
end

function ix.admiral.MoneyConvertCheck(client, character, terminal_id, convert_type, amount)
	if (convert_type == 'token') then
		if (!character:HasMoney(amount)) then
			client:NotifyLocalized("canNotAfford")
			return
		end
	end
	conversion_checker = {
	operation = 'convert',
	convert_type = convert_type,
	id = terminal_id,
	char_id = character:GetID(),
	account = ix.admiral.GetProperCardID(character),
	amount = amount,
	check_or_convert = 'check'
	}
	ix.admiral.AdmiralShitpost(client, ix.admiral.MoneyConvertPerform, character, conversion_checker)
end

function ix.admiral.MoneyConvertPerform(client, info, character)
	if (info.success == 'no') then
		client:Notify("Operation declined.")
		return
	end
	if (info.convert_type == 'token') then
		if (!character:HasMoney(tonumber(info.amount))) then
			client:NotifyLocalized("canNotAfford")
			return
		end
		character:TakeMoney(tonumber(info.amount))
	end
	ix.admiral.AdmiralShitpost(client, ix.admiral.MoneyConvertFinish, character, info)
end

function ix.admiral.MoneyConvertFinish(client, info, character)
	if (info.success == 'no') then
		client:Notify("Operation declined.")
		return
	end
	client:Notify(string.format("You successfully got %s %s", info.amount, info.desc))
	ix.admiral.RequestBalanceNotify(client)
end

function ix.admiral.RequestBalanceNotify(client)
	character_account = ix.admiral.GetProperCardID(client:GetCharacter())
	personal_requester = {
	type='account',
	id=character_account
	}
	ix.admiral.AdmiralFetch(client, ix.admiral.BalanceNotify, personal_requester)
end
function ix.admiral.BalanceNotify(client, info)
	--if (info.type != 'account') then
	--	client:Notify('System Error: Access Denied')
	--	return
	--end
	client:Notify(string.format("Personal Account Balance: #%s credits.", info.balance))
end
function ix.admiral.Refund(client, info)
	refund_transaction = {
	operation='new',
	type='transaction',
	account_from = info.account_to,
	account_to = info.account_from,
	amount = info.amount,
	transaction_type = 'REFUND'
	}
	ix.admiral.AdmiralShitpost(client, ix.admiral.InfoCallbackToConsole, 'nothing', refund_transaction)
	-- ix.admiral.AdmiralShitpost(client, ix.admiral.InfoCallbackToConsole, 'nothing', 'new', 'transaction', info.account_to, info.account_from, info.amount, -3, -1, 'REFUND')
end

function ix.admiral.IllegalSalesmanCompleteBuy(client, info, par)
	ix.admiral.SalesmanCompleteBuy(client, info, 'illegal', par) 
end
function ix.admiral.IllegalSalesmanCompleteSale(client, info, par)
	ix.admiral.SalesmanCompleteSale(client, info, 'illegal', par)
end
function ix.admiral.LegalSalesmanCompleteBuy(client, info, par)
	ix.admiral.SalesmanCompleteBuy(client, info, 'legal', par) 
end
function ix.admiral.LegalSalesmanCompleteSale(client, info, par)
	ix.admiral.SalesmanCompleteSale(client, info, 'legal', par)
end

function ix.admiral.TradeCheck(client, character, trader_id, buy_or_sell, item_id)
	payment_checker = {
	operation = 'trade',
	trader_id = trader_id,
	buy_or_sell = buy_or_sell,
	item_id = item_id,
	account = ix.admiral.GetProperCardID(character),
	check_or_trade = 'check'
	}
	ix.admiral.AdmiralShitpost(client, ix.admiral.TradePerform, character, payment_checker)
end

function ix.admiral.TradePerform(client, info, character)
	if (!info.success or info.success == 'no') then
		client:Notify(string.format("You are unable to trade this item."))
		return
	end
	if (info.buy_or_sell == 'buy') then
		if (info.legal_status == 'illegal') then
			if (!client:GetCharacter():HasMoney(info.item_price)) then
				client:NotifyLocalized("canNotAfford")
				return
			end
			character:TakeMoney(info.item_price)
		end
	else
		local found_item = false

		local invOkay = true
		
		-- local uniqueID = tostring(info.tech_data)
		local uniqueID = info.item_id
		
		for _, v in pairs(character:GetInventory():GetItems()) do
			if (v.uniqueID == uniqueID and v:GetID() != 0 and ix.item.instances[v:GetID()] and v:GetData("equip", false) == false) then
				invOkay = v:Remove()
				found = true
				found_item = v
				name = L(found_item.name, client)

				break
			end
		end

		if (!found) then
			client:Notify("Item was not found?..")
			return
		end

		if (!invOkay) then
			character:GetInventory():Sync(client, true)
			return client:NotifyLocalized("tellAdmin", "trd!iid")
		end
	end
	ix.admiral.AdmiralShitpost(client, ix.admiral.TradeFinish, character, info)
end

function ix.admiral.TradeFinish(client, info, character)
	if (!info.success or info.success == 'no') then
		client:Notify(string.format("You are unable to trade this item."))
		return
	end
	local uniqueID = info.item_id
	local name = L(ix.item.list[uniqueID].name, client)
	if info.buy_or_sell == 'buy' then
		client:NotifyLocalized("businessPurchase", name, ix.admiral.GetCredits(info.item_price, info.legal_status))
		if info.legal_status == 'legal' then
			ix.admiral.RequestBalanceNotify(client)
		end
		
		if (!character:GetInventory():Add(uniqueID)) then
			ix.item.Spawn(uniqueID, client)
		end
	else
		client:NotifyLocalized("businessSell", name, ix.admiral.GetCredits(info.item_price, info.legal_status))
		if info.legal_status == 'legal' then
			ix.admiral.RequestBalanceNotify(client)
		else
			character:GiveMoney(info.item_price)
		end
	end
	
end

function ix.admiral.SalesmanCompleteBuy(client, info, legal_status, par)
	--if legal_status != legal then
	--	local uniqueID = tostring(info.tech_data)
	--	local name = L(ix.item.list[uniqueID].name, client)
	--	client:GetCharacter():TakeMoney(info.amount)
	--	client:NotifyLocalized("businessPurchase", name, ix.currency.Get(info.amount))
	--	if (!client:GetCharacter():GetInventory():Add(uniqueID)) then
	--		ix.item.Spawn(uniqueID, client)
	--	end
	--	return
	--end
	if info.type == 'error' then
		client:Notify(string.format("Payment system failed. Reason: %s", info.error_message))
		return
	end
	
	if info.status == TRANSACTION_FAIL then
		client:Notify(string.format("Transaction was formed, but declined."))
		return
	end
	--for k, v in pairs(info) do
	--	client:Notify(string.format("%s: %s", k, v))
	--end
	local uniqueID = par
	local name = L(ix.item.list[uniqueID].name, client)
	client:NotifyLocalized("businessPurchase", name, ix.admiral.GetCredits(info.amount, legal_status))
	if legal_status == 'legal' then
		ix.admiral.RequestBalanceNotify(client)
	else
		client:GetCharacter():TakeMoney(info.amount)
	end
	
	if (!client:GetCharacter():GetInventory():Add(uniqueID)) then
		ix.item.Spawn(uniqueID, client)
	end
end


function ix.admiral.SalesmanCompleteSale(client, info, legal_status, par)
	if info.type == 'error' then
		client:Notify(string.format("Payment system failed. Reason: %s", info.error_message))
		return
	end
	
	if info.status == TRANSACTION_FAIL then
		client:Notify(string.format("Transaction was formed, but declined."))
		return
	end
	--for k, v in pairs(info) do
	--	client:Notify(string.format("%s: %s", k, v))
	--end
	
	local found_item = false

	local invOkay = true
	
	-- local uniqueID = tostring(info.tech_data)
	local uniqueID = par
	
	for _, v in pairs(client:GetCharacter():GetInventory():GetItems()) do
		if (v.uniqueID == uniqueID and v:GetID() != 0 and ix.item.instances[v:GetID()] and v:GetData("equip", false) == false) then
			invOkay = v:Remove()
			found = true
			found_item = v
			name = L(found_item.name, client)

			break
		end
	end

	if (!found) then
		client:Notify("Item was not found?..")
		if legal_status == 'legal' then
			ix.admiral.Refund(client, info)
		end
		return
	end

	if (!invOkay) then
		client:GetCharacter():GetInventory():Sync(client, true)
		if legal_status == 'legal' then
			ix.admiral.Refund(client, info)
		end
		return client:NotifyLocalized("tellAdmin", "trd!iid")
	end
	client:NotifyLocalized("businessSell", name, ix.admiral.GetCredits(info.amount, legal_status))
	if legal_status == 'legal' then
		ix.admiral.RequestBalanceNotify(client)
	else
		client:GetCharacter():GiveMoney(info.amount)
	end
end

function ix.admiral.DeductTokens(client, info, account_type)
	if account_type == ILLEGAL_ACCOUNT then
		phrase = {give="give merchant his money", fail="merchant", complete="fading in the hands of the merchant"}
	else
		phrase = {give="deposit anything", fail="banking system", complete="successfully deposited"}
	end

	if info.type == 'error' then
		client:Notify(string.format("You failed to %s. Reason: %s", phrase.give, info.error_message))
		return
	end
	if info.status == TRANSACTION_FAIL then
		client:Notify(string.format("The %s refused to take your $s tokens.", phrase.fail, info.amount))
		return
	end
	character = client:GetCharacter()
	character:TakeMoney(info.amount)
	client:Notify(string.format("%s tokens are %s.", info.amount, phrase.complete))
	if account_type == CITY_ACCOUNT then
		ix.admiral.RequestBalanceNotify(client)
	end
end

function ix.admiral.RegisterUser(client, callback, target_client)
	user_id = target_client:SteamID64()
	new_user_requester = {
	operation = 'new',
	type = 'user',
	id = user_id,
	nickname = target_client:SteamName(),
	ip = target_client:IPAddress():match("%d+%.%d+%.%d+%.%d+")
	}
	-- user_name = ix.admiral.SanitizeShit(target_client:SteamName())
	ix.admiral.AdmiralShitpost(client, callback, target_client, new_user_requester)
end

function ix.admiral.RegisterCharacter(client, callback, character)
	char_id = character:GetID()
	user_id = character:GetPlayer():SteamID64()
	faction = ix.faction.indices[character:GetFaction()]
	-- char_name = ix.admiral.SanitizeShit(character:GetName())
	new_char_requester = {
	operation = 'new',
	type = 'character',
	name = character:GetName(),
	faction = faction.uniqueID,
	id = char_id,
	user_id = user_id
	}
	ix.admiral.AdmiralShitpost(client, callback, character, new_char_requester)
end

function ix.admiral.GetProperCardID(character)
	if admiral_ip == LOCALHOST then
		return character:GetID()
	else
		if !character:GetEquipment() then
			return false
		end
		local cid = character:GetEquipment():HasItemOfBase("base_cards", {equip = true})
		if !cid then 
			return false
		end
		card_id = cid:GetData("economy_id")
		if card_id == '' then
			return false
		end
		return card_id
	end
end

function ix.admiral.CreatePersonalAccount(client, callback, character)
	char_id = character:GetID()
	card_id = ix.admiral.GetProperCardID(character)
	if !card_id then
		client:Notify("No ID card detected.")
		return
	end
	personal_account_requester = {
	operation = 'new',
	type = 'account',
	owner_id = char_id,
	card_id = card_id
	}
	ix.admiral.AdmiralShitpost(client, callback, character, personal_account_requester)
end

function ix.admiral.InfoCallbackToChat(client, info, parameter)
	-- ix.chat.Send(client, "notice", '-----')
	for k, v in pairs(info) do
		client:Notify(string.format("%s: %s", k, v))
	end
end

function ix.admiral.InfoCallbackToConsole(client, info, parameter)
	for k, v in pairs(info) do
		print(string.format("%s: %s", k, v))
	end
end

function ix.admiral.BalanceCallback(client, info, parameter)
	
end

function ix.admiral.RegisterInSystem(client, character)
	ix.admiral.RegisterUser(character:GetPlayer(), ix.admiral.RegisterInSystemSecond, character:GetPlayer())
end

function ix.admiral.RegisterInSystemSecond(client, info, parameter)
	ix.admiral.RegisterCharacter(parameter:GetPlayer(), ix.admiral.RegisterInSystemThird, parameter)
end

function ix.admiral.RegisterInSystemThird(client, info, parameter)
	ix.admiral.CreatePersonalAccount(parameter:GetPlayer(), ix.admiral.InfoCallbackToConsole, parameter)
end

function ix.admiral.RegisterAllItems(client)
	for k, v in pairs(ix.item.list) do
		ix.admiral.RegisterItem(client, ix.admiral.InfoCallbackToConsole, v)
	end
end

function ix.admiral.RegisterItem(client, callback, item_value)
	item_requester = {
	operation = 'new',
	type = 'item',
	id = item_value.uniqueID,
	name = item_value.name or 'NoName',
	description = item_value.description or 'NoDesc',
	base_price = item_value.price or 100,
	is_weapon = item_value.isWeapon or false
	}
	-- ix.chat.Send(client, "event", '-----')
	--for k, v in pairs(item_requester) do
	--	ix.chat.Send(client, "event", (string.format("%s: %s", k, v)))
	--end
	ix.admiral.AdmiralShitpost(client, callback, item_value.uniqueID, item_requester)
end

function ix.admiral.RegisterVendor(client, vendor, economy_id)
	vendor:OnChangedEconomyID(economy_id)
	items = vendor.items
	items_accurate = {}
	for uid, item in pairs(items) do
		items_accurate[uid] = {
		price = item[1],
		mode = item[3],
		id = uid
		}
	end
	
	trader_requester = {
	operation = 'new',
	type = 'trader',
	id = economy_id,
	legal_status = vendor.legal_status,
	name = vendor:GetDisplayName(),
	}
	parameter_to_pass = {
	vendor = vendor,
	items = items_accurate,
	economy_id = economy_id
	}

	ix.admiral.AdmiralShitpost(client, ix.admiral.RegisterVendorFinish, parameter_to_pass, trader_requester)
	
end

function ix.admiral.RegisterTerminal(client, terminal)
	terminal_requester = {
	operation = 'new',
	type = 'terminal',
	id = terminal.terminal_id,
	terminal_type = terminal.terminal_type,
	name = terminal:GetDisplayName()
	}
	ix.admiral.AdmiralShitpost(client, ix.admiral.RegisterTerminalFinish, terminal, terminal_requester)
end

function ix.admiral.RegisterTerminalFinish(client, info, terminal)
	if (info.type != 'terminal') then
		print('oh well')
		return
	end
	terminal:OnChangedTerminalID(info.id)
end

function ix.admiral.VendorUpdateItems(client, vendor)
	if vendor.economy_id == '' then
		return
	end
	items = vendor.items
	items_accurate = {}
	for uid, item in pairs(items) do
		items_accurate[uid] = {
		price = item[1],
		mode = item[3],
		id = uid
		}
	end
	parameter_to_pass = {
	vendor = vendor,
	items = items_accurate,
	economy_id = vendor.economy_id
	}
	for _, item in pairs(items_accurate) do
		print('i am item ', item)
		ix.admiral.VendorUpdateItem(client, item, parameter_to_pass)
	end
end

function ix.admiral.RegisterVendorFinish(client, info, parameter)
	ix.admiral.InfoCallbackToChat(client, info)
	if (info.type != 'trader') then
		print('oh well')
		return
	end
	parameter.vendor.economy_id = info.id
	parameter.vendor:OnChangedEconomyID(info.id)
	for _, item in pairs(parameter.items) do
		print('i am item ', item)
		ix.admiral.VendorUpdateItem(client, item, parameter)
	end
end

function ix.admiral.VendorUpdateItem(client, item, parameter)
	item_updater = {
	operation = 'update_item',
	type = 'trader',
	trader_id = parameter.vendor.economy_id,
	price = item.price or 100,
	mode = item.mode,
	id = item.id
	}
	print(item_updater)
	ix.admiral.AdmiralShitpost(client, ix.admiral.VendorUpdateItemFinish, parameter, item_updater)
end

function ix.admiral.VendorUpdateItemFinish(client, item, parameter)
	ix.admiral.InfoCallbackToConsole(client, item, parameter)
	vendor = parameter.vendor
	vendor:OnChangedPrice(item)
end

function ix.admiral.UseSalesman(activator, id, callback)
	vendor_requester = {
	type = 'trader',
	id = id
	}
	ix.admiral.AdmiralFetch(client, callback, vendor_requester)
	-- vendor:UseCallback(activator, info, parameter)
end

function ix.admiral.CardFinish(client, info, cid)
	print('now i am finished')
	if info.account then
		cid:SetData("economy_id", info.account)
	end
end

local factions_with_cid = {
	cwu_clerk = true,
	cwu_segnior = true,
	med_clerk = true,
	cwu_head = true,
	citizen = true,
	metropolice = true,
	administration = true,
	administrator = true,
	overseer = true,
	dispatch = false,
	ota = false,
	ota_elite = false,
	zombie = false,
	bird = false,
	vortigaunt = true
}

local factions_access = {
	dispatch = false,
	ota = true,
	ota_elite = true,
	zombie = false,
	bird = false
}

function ix.admiral.CardGiveProperEconomyID(client)
	character = client:GetCharacter()
	faction_object = character:GetFaction()
	faction_indice = ix.faction.indices[faction_object]
	faction_id = faction_indice.uniqueID
	user_id = client:SteamID64()
	char_id = character:GetID()
	card_id = ''
	if admiral_ip == LOCALHOST then
		card_id = char_id
	elseif factions_with_cid[faction_id] then
		if !character:GetEquipment() then
			return false
		end
		cid = character:GetEquipment():HasItemOfBase("base_cards", {equip = true})
		if !cid then 
			return false
		end
		card_id = cid:GetData("cid")
	elseif factions_access[faction_id] then
		card_id = 'ota'
	end
	card_requester = {
	operation='register',
	type='card',
	id=card_id,
	char_id=char_id,
	user_id=user_id
	}
	ix.admiral.AdmiralShitpost(client, ix.admiral.CardFinish, cid, card_requester)
end

function ix.admiral.SetEconomyParameter(client, type, id, parameter, value)
	requester = {
	operation = 'setpar',
	type = type,
	id = id,
	par = parameter,
	value = value
	}
	ix.admiral.AdmiralShitpost(client, ix.admiral.InfoCallbackToChat, requester, requester)
end


ix.util.Include("sh_commands.lua")
ix.util.Include("sv_hooks.lua")
