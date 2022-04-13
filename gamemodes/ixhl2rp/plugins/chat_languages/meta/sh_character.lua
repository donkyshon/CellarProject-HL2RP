
local charMeta = ix.meta.character

function charMeta:CanSpeakLanguage(languageID)
	return self:GetStudiedLanguages(languageID) == true
end

if (SERVER) then
	function charMeta:ResetLanguageLeftStudyTime(languageID, genericDataKey, volumeCount)
		genericDataKey = genericDataKey or ix.chatLanguages.GetStudyTimeLeftGenericDataKey(languageID)
		volumeCount = volumeCount or ix.config.Get("languageTextbooksVolumeCount", 3)

		for i = 1, volumeCount do
			self:SetData(genericDataKey .. i, nil)
		end
	end
end
