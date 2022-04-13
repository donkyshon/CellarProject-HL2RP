-- require("reqwest")

ix.admiral = ix.admiral or {}


CITADEL_ACCOUNT = -1
ILLEGAL_ACCOUNT = -2
CITY_ACCOUNT = -4
TRANSACTION_FAIL = 1
TRANSACTION_AUTO = 2
TRANSACTION_COMPLETE = 0

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
	util.AddNetworkString("ixAdmiralGetData")
	net.Receive("ixAdmiralGetData", function(length, client)
		print("I'm already here.")
		net.ReadString()
		http.Post("http://localhost/meh/bleh/blah/bluh", {b = "test"},
			function(body, length, headers, code)
				ix.chat.Send(client, "notice", body)
			end,
			
			function(message)
				print(message)
				print("I somehow got here")
			end
		)
	end)
	function ix.admiral.AdmiralInfoSend(info, ...)
		local arguments =  {...}

		net.Start("ixAdmiralGetData") 
		-- net.WriteString(info)
		-- net.WriteUInt(#arguments, 4)

		-- for _, v in ipairs(arguments) do
		-- 	net.WriteType(v)
		-- end
		net.WriteString( "Hi" )

		net.SendToServer("ixAdmiralGetData")
	end
	
end
function ix.admiral.ResponseToArray(response)
	response_array = {}
	counter = 1
	
	for response_part in string.gmatch(response, "[^>]+") do
		response_array[counter] = response_part
		
		-- local num_status, returned = pcall(tonumber, response_part)
		response_number = tonumber(response_part)
		if response_number != nil then
			response_array[counter] = response_number
		end
		counter = counter + 1
	end
	return response_array
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
		packed_string = string.format("%s>%s", packed_string, v)
	end
	-- return packed_string
	return packed_string
end
function ix.admiral.AdmiralFetch(client, callback, ...)
	

	address = ix.admiral.PackString(...)
	print(address)
	-- response = nil

	http.Fetch(address,
		function(body, length, headers, code)
			response = decodeURI(body)
			print('response', response)
			response_array = ix.admiral.ResponseToArray(response)
			callback(client, ix.admiral.CreateValidObject(response_array))
		end,
		
		function(message)
			print(message)
			print("I somehow got here 2")
			response = message
			if (callback != InfoCallbackToConsole) then
				client:Notify('System Error: Access Denied')
			end
			return nil
		end
	)
end
function ix.admiral.AdmiralShitpost(client, callback, parameter, ...)
	-- arguments = {'new', 'user', 451, 'Fartenberg'}
	address = ix.admiral.PackString(...)
	request = ix.admiral.PackStringAlt(...)
	print(address)
	http.Post(address, {b = request},
		function(body, length, headers, code)
			response = decodeURI(body)
			print('response', response)
			response_array = ix.admiral.ResponseToArray(response)
			callback(client, ix.admiral.CreateValidObject(response_array), parameter)
		end,
		
		function(message)
			print(message)
			print("I somehow got here")
			if (callback != InfoCallbackToConsole) then
				client:Notify('System Error: Access Denied')
			end
		end
	)
end
function ix.admiral.CreateValidObject(info)
	
	if info[1] == 'account' then
		valid_info = {
		type=info[1],
		id=info[2], 
		duplicate=info[3],		
		owner_id=info[4], 
		card_id=info[5], 
		-- name=info[6], 
		-- type=info[7], 
		balance=info[6]
		}
	elseif info[1] == 'transaction' then
		valid_info = {
		type=info[1],
		id=info[2],
		duplicate=info[3],
		from=info[4],
		to=info[5],
		amount=info[6],
		transaction_type=info[7],
		status=info[8],
		tech_data=info[9],
		description=info[10]
		}
	elseif info[1] == 'character' then
		valid_info = {
		type=info[1],
		id=info[2],
		duplicate=info[3],
		-- name=info[4],
		user_id=info[4],
		fake=info[5]
		}
	elseif info[1] == 'user' then
		valid_info = {
		type=info[1],
		steam_id=info[2],
		duplicate=info[3],
		-- discord_id=info[4],
		fake=info[4],
		-- nickname=info[6]
		}
	else
		valid_info = {
		type='error',
		error_message='An error occured.'
		}
	end
	return valid_info
end
function ix.admiral.PrepareShitpostObject(info)
	return
end
function ix.admiral.EconomyInfo(client, callback, type, object_id)
	ix.admiral.AdmiralFetch(client, callback, type, object_id)
end

function ix.admiral.PersonalTokensToCredits(client, amount)
	character = client:GetCharacter()
	if !character:HasMoney(amount) then
		client:Notify(string.format("You do not have %s tokens.", amount))
		return
	end
	character_account = ix.admiral.GetProperCardID(character)
	ix.admiral.AdmiralShitpost(character:GetPlayer(), ix.admiral.LegallyDeductTokens, 'nothing', 'new', 'transaction', CITY_ACCOUNT, character_account*2, amount, -3)
end

function ix.admiral.CashFromSalesman(client, character, amount, uniqueID)
	ix.admiral.AdmiralShitpost(character:GetPlayer(), ix.admiral.IllegalSalesmanCompleteSale, uniqueID, 'new', 'transaction', ILLEGAL_ACCOUNT, CITADEL_ACCOUNT, amount, uniqueID)
end
function ix.admiral.CashToSalesman(client, character, amount, uniqueID)
	ix.admiral.AdmiralShitpost(character:GetPlayer(), ix.admiral.IllegalSalesmanCompleteBuy, uniqueID, 'new', 'transaction', CITADEL_ACCOUNT, ILLEGAL_ACCOUNT, amount, uniqueID)
end
function ix.admiral.PaymentFromSalesman(client, character, amount, uniqueID)
	character_account = ix.admiral.GetProperCardID(character)
	ix.admiral.AdmiralShitpost(character:GetPlayer(), ix.admiral.LegalSalesmanCompleteSale, uniqueID, 'new', 'transaction', CITY_ACCOUNT, character_account*2, amount, uniqueID)
end

function ix.admiral.PaymentToSalesman(client, character, amount, uniqueID)
	character_account = ix.admiral.GetProperCardID(character)
	ix.admiral.AdmiralShitpost(character:GetPlayer(), ix.admiral.LegalSalesmanCompleteBuy, uniqueID, 'new', 'transaction', character_account*2, CITY_ACCOUNT, amount, uniqueID)
end

function ix.admiral.PaymentToSomeone(client, amount, target_account)
	character_account = ix.admiral.GetProperCardID(client:GetCharacter())
	ix.admiral.AdmiralShitpost(client, ix.admiral.RequestBalanceNotify, target_account, 'new', 'transaction', character_account*2, target_account*2, amount)
end

function ix.admiral.LegallyDeductTokens(client, info, parameter)
	ix.admiral.DeductTokens(client, info, CITY_ACCOUNT)
end

function ix.admiral.GetCredits(amount)
	if (amount == 1) then
		return "#1 credit"
	else
		return "#"..amount.." credits"
	end
end

function ix.admiral.RequestBalanceNotify(client)
	character_account = ix.admiral.GetProperCardID(client:GetCharacter())
	ix.admiral.AdmiralFetch(client, ix.admiral.BalanceNotify, 'personal', character_account)
end
function ix.admiral.BalanceNotify(client, info)
	if (info.type != 'account') then
		client:Notify('System Error: Access Denied')
		return
	end
	client:Notify(string.format("Personal Account Balance: #%s credits.", info.balance))
end
function ix.admiral.Refund(client, info)
	ix.admiral.AdmiralShitpost(client, ix.admiral.InfoCallbackToConsole, 'nothing', 'new', 'transaction', info.account_to, info.account_from, info.amount, -3, -1, 'REFUND')
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
	local uniqueID = par
	local name = L(ix.item.list[uniqueID].name, client)

	if legal_status == 'legal' then
		client:NotifyLocalized("businessPurchase", name, ix.admiral.GetCredits(info.amount))
		ix.admiral.RequestBalanceNotify(client)
	else
		client:GetCharacter():TakeMoney(info.amount)
		client:NotifyLocalized("businessPurchase", name, ix.currency.Get(info.amount))
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
	if legal_status == 'legal' then
		client:NotifyLocalized("businessSell", name, ix.admiral.GetCredits(info.amount))
		ix.admiral.RequestBalanceNotify(client)
	else
		client:GetCharacter():GiveMoney(info.amount)
		client:NotifyLocalized("businessSell", name, ix.currency.Get(info.amount))
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

function ix.admiral.SanitizeShit(shitty_name)
	sanitized_name = string.gsub(shitty_name, "%s", "_")
	--for name_part in string.gmatch(shitty_name, "[^%s]+") do
	--	sanitized_name = string.format("%s_%s", sanitized_name, name_part)
	--end
	return sanitized_name
end
function ix.admiral.RegisterUser(client, callback, target_client)
	user_id = target_client:SteamID64()
	-- user_name = ix.admiral.SanitizeShit(target_client:SteamName())
	ix.admiral.AdmiralShitpost(client, callback, target_client, 'new', 'user', user_id)
end

function ix.admiral.RegisterCharacter(client, callback, character)
	char_id = character:GetID()
	user_id = character:GetPlayer():SteamID64()
	-- char_name = ix.admiral.SanitizeShit(character:GetName())
	ix.admiral.AdmiralShitpost(client, callback, character, 'new', 'character', char_id, user_id)
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
		card_id = cid:GetData("cid")
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
	ix.admiral.AdmiralShitpost(client, callback, character, 'new', 'account', char_id, 0, 0, card_id)
end

function ix.admiral.InfoCallbackToChat(client, info, parameter)
	ix.chat.Send(client, "notice", '-----')
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


ix.util.Include("sh_commands.lua")
ix.util.Include("sv_hooks.lua")
