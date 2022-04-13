
ix.char.RegisterVar("usedLanguage", {
	field = "used_language",
	fieldType = ix.type.string,
	default = "",
	isLocal = true,
	bNoDisplay = true
})

do
	local charMeta = ix.meta.character

	function charMeta:CanSpeakLanguage(languageID)
		return tobool(self:GetStudiedLanguages(languageID))
	end
end


ix.char.RegisterVar("usedLanguage", {
	field = "used_language",
	fieldType = ix.type.string,
	default = "",
	isLocal = true,
	bNoDisplay = true
})

do
	local charMeta = ix.meta.character

	function charMeta:CanSpeakLanguage(languageID)
		return tobool(self:GetStudiedLanguages(languageID))
	end
end
