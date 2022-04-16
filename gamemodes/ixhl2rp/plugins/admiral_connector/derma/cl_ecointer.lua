
local PANEL = {}

AccessorFunc(PANEL, "bReadOnly", "ReadOnly", FORCE_BOOL)

local operation_types = {
	transfer = "ПЕРЕВОД",
	register = "РЕГИСТРАЦИЯ",
	fine = "ШТРАФ",
	reward = "НАГРАДА",
	upgrade = "ПОВЫШЕНИЕ УЛ",
	buy_lp = "ПОКУПКА ОЛ",
	sell_lp = "ПРОДАЖА ОЛ",
	info_get = "ЗАПРОС ИНФОРМАЦИИ"
}

local civilian_operations = {
	transfer = "ПЕРЕВОД",
	upgrade = "ПОВЫШЕНИЕ УЛ",
	buy_lp = "ПОКУПКА ОЛ",
	sell_lp = "ПРОДАЖА ОЛ"
}

local cwu_operations = {
	transfer = "ПЕРЕВОД",
	upgrade = "ПОВЫШЕНИЕ УЛ",
	buy_lp = "ПОКУПКА ОЛ",
	sell_lp = "ПРОДАЖА ОЛ"
}

local metropolice_operations = {
	transfer = "ПЕРЕВОД",
	register = "РЕГИСТРАЦИЯ",
	fine = "ШТРАФ",
	reward = "НАГРАДА",
	info_get = "ЗАПРОС ИНФОРМАЦИИ"
}

local admin_operations = {
	transfer = "ПЕРЕВОД",
	register = "РЕГИСТРАЦИЯ",
	fine = "ШТРАФ",
	reward = "НАГРАДА",
	upgrade = "ПОВЫШЕНИЕ УЛ",
	buy_lp = "ПОКУПКА ОЛ",
	sell_lp = "ПРОДАЖА ОЛ",
	info_get = "ЗАПРОС ИНФОРМАЦИИ"
}

local faction_operations = {
	cwu_clerk = cwu_operations,
	cwu_segnior = cwu_operations,
	med_clerk = cwu_operations,
	cwu_head = cwu_operations,
	citizen = civilian_operations,
	metropolice = metropolice_operations,
	administration = admin_operations,
	administrator = admin_operations,
	overseer = metropolice_operations,
	vortigaunt = civilian_operations
}

function PANEL:Init()
	self:SetSize(ScrW() * 0.45, ScrH() * 0.35)
	self:SetTitle("CMB:TERMINAL-1435317")
	self:MakePopup()
	self:Center()
	
	local numeric_labels = self:Add("DPanel")
	numeric_labels:SetTall(32)
	numeric_labels:Dock(TOP)
	
	self.cid_label = numeric_labels:Add("DLabel")
	self.cid_label:Dock(LEFT)
	self.cid_label:SetWide(self:GetWide() * 0.4)
	self.cid_label:SetText("ИДЕНТИФИКАТОР ЦЕЛИ")
	-- self.cid_label:SetTextInset(4, 0)
	self.cid_label:SetFont("ixMediumFont")
	self.cid_label:SetTextColor(color_white)
	
	self.amount_label = numeric_labels:Add("DLabel")
	self.amount_label:Dock(RIGHT)
	self.amount_label:SetWide(self:GetWide() * 0.4)
	self.amount_label:SetText("КОЛИЧЕСТВО")
	-- self.amount_label:SetTextInset(4, 0)
	self.amount_label:SetFont("ixMediumFont")
	self.amount_label:SetTextColor(color_white)
	
	local numeric_panel = self:Add("DPanel")
	numeric_panel:SetTall(32)
	numeric_panel:Dock(TOP)
	
	self.cid = numeric_panel:Add("DTextEntry")
	self.cid:Dock(LEFT)
	self.cid:SetWide(self:GetWide() * 0.4)
	self.cid:SetNumeric(true)
	self.cid:SetFont("ixMediumFont")
	self.cid:SetTextColor(color_black)
	
	self.amount = numeric_panel:Add("DTextEntry")
	self.amount:Dock(RIGHT)
	self.amount:SetWide(self:GetWide() * 0.4)
	self.amount:SetNumeric(true)
	self.amount:SetFont("ixMediumFont")
	self.amount:SetTextColor(color_black)
	
	local top_spacer = self:Add("DPanel")
	top_spacer:SetTall(32)
	top_spacer:Dock(TOP)
	
	local reason_panel = self:Add("DPanel")
	reason_panel:SetTall(64)
	reason_panel:Dock(TOP)
	
	self.reason_label = reason_panel:Add("DLabel")
	self.reason_label:SetTall(32)
	self.reason_label:Dock(TOP)
	self.reason_label:SetWide(self:GetWide() * 0.8)
	self.reason_label:SetText("УКАЗАНИЕ НАЗНАЧЕНИЯ ОПЕРАЦИИ ОБЯЗАТЕЛЬНО:")
	self.reason_label:SetFont("ixMediumFont")
	self.reason_label:SetTextColor(color_white)
	
	self.reason = reason_panel:Add("DTextEntry")
	self.reason:SetTall(32)
	self.reason:Dock(BOTTOM)
	self.reason:SetWide(self:GetWide() * 0.8)
	self.reason:SetText("НАЗНАЧЕНИЕ ОПЕРАЦИИ")
	self.reason:SetFont("ixMediumFont")
	self.reason:SetTextColor(color_black)
	
	local bottom_spacer = self:Add("DPanel")
	bottom_spacer:SetTall(32)
	bottom_spacer:Dock(TOP)
	
	local operation_panel = self:Add("DPanel")
	operation_panel:SetTall(32)
	operation_panel:Dock(TOP)
	
	self.operation_type = operation_panel:Add("DComboBox")
	self.operation_type:Dock(LEFT)
	self.operation_type:SetWide(self:GetWide() * 0.4)
	self.operation_type:SetFont("ixMediumFont")
	self.operation_type:SetTextColor(color_yellow)
	self.operation_type:SetValue("ТИП ОПЕРАЦИИ", 'none')
	--function self.operation_type:OnSelect (index, value, data)
	--	self.cid:SetEnabled(false)
	--	if (data == 'transfer' or data == 'register' or data == 'fine' or data == 'reward') then
	--		self.cid:SetEnabled(true)
	--	end
	--end
	
	--self.operation_type:AddChoice("ПЕРЕВОД", 'transfer')
	--self.operation_type:AddChoice("РЕГИСТРАЦИЯ", 'register')
	--self.operation_type:AddChoice("ШТРАФ", 'fine')
	--self.operation_type:AddChoice("НАГРАДА", 'reward')
	--self.operation_type:AddChoice("ПОВЫШЕНИЕ УЛ", 'upgrade')
	--self.operation_type:AddChoice("ПОКУПКА ОЛ", 'buy_lp')
	--self.operation_type:AddChoice("ПРОДАЖА ОЛ", 'sell_lp')
	
	self.operation_send = operation_panel:Add("DButton")
	self.operation_send:Dock(RIGHT)
	self.operation_send:SetWide(self:GetWide() * 0.4)
	self.operation_send:SetText("ВЫПОЛНИТЬ")
	self.operation_send:SetFont("ixMediumFont")
	self.operation_send:SetTextColor(color_red)
	-- self.operation_send:SetEnabled(false)
	self.operation_send.DoClick = function(this)
		local _, data = self.operation_type:GetSelected()
		local reason = self.reason:GetValue() or '4nr'
		if (data == nil) then
			return
		end
		local cid = self.cid:GetInt() or 0
		local amount = self.amount:GetInt() or 0
		-- print(cid, amount, reason, data)
		if (cid > 99999 or amount > 99999) then
			return
		end
		
		if (cid < 0 or amount < 0) then
			return
		end
		
		net.Start("ixEcoSend")
			net.WriteString(data)
			net.WriteString(reason)
			net.WriteUInt(cid, 32)
			net.WriteUInt(amount, 32)
		net.SendToServer()
	end
end



function PANEL:Setup(faction)
	
	--self:SetTitle(string.format("Name: %s, Status: %s", entity:GetDisplayName(), entity.legal_status))

	--self.vendorBuy:SetEnabled(!self:GetReadOnly())
	--self.vendorSell:SetEnabled(!self:GetReadOnly())
	-- 
	--for k, v in pairs(operation_types) do
	--	self.operation_type:AddChoice(v, k)
	--end
	
	for k, v in pairs(faction_operations[faction]) do
		self.operation_type:AddChoice(v, k)
	end
	

	
end



function PANEL:Think()

	if ((self.nextUpdate or 0) < CurTime()) then

		self.nextUpdate = CurTime() + 0.25
	end
end

vgui.Register("ixEcoInter", PANEL, "DFrame")

