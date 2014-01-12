UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")

local F = CreateFrame ("Frame", 'ConceptionUI ErrorFrame', ConceptionCORE)
	F:SetFrameStrata('TOOLTIP')
	F.fadeInTime = 0
	F.fadeOutTime = .2
	F.holdTime = 1
	F:Hide()

	F.text = F:CreateFontString()
	F.text:SetShadowOffset(0, -1)
	F.text:SetPoint('TOP', UIParent, 0, -96)
	F.text:SetFont(DAMAGE_TEXT_FONT, 12)
	F.text:SetTextColor(.618, 0, 0, 1)

local FadingFrame_Show = FadingFrame_Show
local OnEvent = function(self, _, error)
	self.text:SetText(error)
	FadingFrame_Show(self)
end

F:RegisterEvent("UI_ERROR_MESSAGE")
F:SetScript("OnEvent", OnEvent)
F:SetScript("OnUpdate", FadingFrame_OnUpdate)