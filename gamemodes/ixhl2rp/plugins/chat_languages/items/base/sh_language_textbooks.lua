
ITEM.name = "Language Textbooks Base"
ITEM.description = "iLanguageTextbookDescription"
ITEM.model = Model("models/props_lab/bindergreen.mdl")
ITEM.category = "Language Textbooks"
ITEM.languageID = "english"
ITEM.volume = 1
ITEM.studyTime = 60

function ITEM:GetStudyTimeLeftDataKey()
	return ix.chatLanguages.GetStudyTimeLeftGenericDataKey(self.languageID) .. self.volume
end

if (CLIENT) then
	function ITEM:GetName()
		local languageData = ix.chatLanguages.Get(self.languageID)

		if (languageData) then
			return L("iLanguageTextbookName", L(languageData.name), self.volume)
		end

		return L(self.name)
	end

	function ITEM:PopulateTooltip(tooltip)
		local client = LocalPlayer()
		local character = client:GetCharacter()
		local charLanguageData = character:GetData(self:GetStudyTimeLeftDataKey())
		local color, text

		local progressT = tooltip:AddRowAfter("name", "progress")

		if (character:GetStudiedLanguages(self.languageID)) then
			text = L("textbookLanguageStudied")
			color = derma.GetColor("Success", progressT)
		elseif (!charLanguageData) then
			text = L("textbookNoStudy")
			color = derma.GetColor("Error", progressT)
		elseif (isnumber(charLanguageData)) then
			local percentage = string.format("%.2f", math.Round((1 - charLanguageData / self.studyTime) * 100, 2)) .. "%"

			text = L("textbookStudyInProgress", percentage)
			color = derma.GetColor("Info", progressT)
		elseif (charLanguageData == true) then
			text = L("textbookStudySuccess")
			color = derma.GetColor("Success", progressT)
		end

		progressT:SetBackgroundColor(color)
		progressT:SetText(L("textbookStudyProgress", text))
		progressT:SizeToContents()
	end
end

ITEM.functions.Study = {
	icon = "icon16/book_open.png",
	OnRun = function(item)
		local languageData = ix.chatLanguages.Get(item.languageID)

		if (languageData) then
			local client = item.player

			if (client:GetVelocity():LengthSqr() == 0) then
				local character = client:GetCharacter()
				local savedPosition = client:GetPos()
				local steamID = client:SteamID()
				local timerID = "ixStudyingLanguage" .. steamID
				local actionTimerID = "ixAct" .. steamID
				local dataKey = item:GetStudyTimeLeftDataKey()
				local studyTime = character:GetData(dataKey, item.studyTime)

				if (studyTime > item.studyTime) then
					studyTime = item.studyTime

                    character:SetData(dataKey, item.studyTime)
				end

				client:SetAction("@studyingLanguage", studyTime, function()
					local languageName = L(languageData.name, client)
					local volumeCount = ix.config.Get("languageTextbooksVolumeCount", 3)
					local genericDataKey = dataKey:utf8sub(1, dataKey:utf8len() - 1)
					local textbookNumber = dataKey:utf8sub(-1)

					character:SetData(dataKey, true)

					for i = 1, volumeCount do
						if (character:GetData(genericDataKey .. i) != true) then
							client:NotifyLocalized("volumeStudied", textbookNumber, volumeCount, languageName)
							ix.log.Add(client, "studiedLanguageTextbook", textbookNumber, volumeCount, languageData.name)

							return
						end
					end

					character:ResetLanguageLeftStudyTime(item.languageID, genericDataKey, volumeCount)

					character:SetStudiedLanguages(item.languageID, true)
					client:NotifyLocalized("languageStudied", languageName)
					ix.log.Add(client, "studiedLanguage", languageData.name)
				end, nil, nil, function()
					timer.Remove(timerID)
				end)

				timer.Create(timerID, 0.1, studyTime / 0.1, function()
					if (IsValid(client)) then
						local bNotInInventory = client != item:GetOwner()

						if (bNotInInventory or savedPosition != client:GetPos()) then
							client:SetAction()

							if (!bNotInInventory) then client:NotifyLocalized("noStudyOnMove") end

							-- just in case
							timer.Remove(timerID)
						elseif (timer.RepsLeft(timerID) > 0) then
							character:SetData(dataKey, timer.TimeLeft(actionTimerID))
						end
					else
						timer.Remove(actionTimerID)
						timer.Remove(timerID)
					end
				end)
			else
				client:NotifyLocalized("noStudyOnMove")
			end
		else
			client:NotifyLocalized("unknownError")
		end

		return false
	end,
	OnCanRun = function(item)
		if (IsValid(item.entity) or !IsValid(item.player)) then
			return false
		end

		local client = item.player
		local character = client:GetCharacter()

		return character:GetData(item:GetStudyTimeLeftDataKey()) != true and !character:GetStudiedLanguages(item.languageID)
	end
}
