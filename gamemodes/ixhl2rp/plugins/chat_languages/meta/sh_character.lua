
local charMeta = ix.meta.character

function charMeta:CanSpeakLanguage(languageID)
	return self:GetStudiedLanguages(languageID) == true
end

function charMeta:GetLanguageStudyProgress(languageID, volumeNumber)
	if (ix.chatLanguages.Get(languageID)) then
		local studyProgress = self:GetLanguagesStudyProgress()

		if (studyProgress[languageID] and volumeNumber) then
			return studyProgress[languageID][volumeNumber]
		end

		return studyProgress[languageID]
	end
end
