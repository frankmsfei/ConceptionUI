local HIDE_LIST = {
	MainMenuBar, 
	--MainMenuBarArtFrame, 
	MainMenuBarPageNumber,
	ActionBarDownButton,
	ActionBarUpButton,
	--OverrideActionBar,
	--OverrideActionBarExpBar,
	--OverrideActionBarHealthBar,
	--OverrideActionBarPowerBar,
	--OverrideActionBarPitchFrame,
	--OverrideActionBarLeaveFrameLeaveButton,
	--BonusActionBarFrame, 
	--PossessBarFrame,
	MainMenuBarBackpackButton,
	CharacterBag0Slot,
	CharacterBag1Slot,
	CharacterBag2Slot,
	CharacterBag3Slot,
	StanceBarLeft,
	StanceBarMiddle,
	StanceBarRight,
	SlidingActionBarTexture0,
	SlidingActionBarTexture1,
	PossessBackground1,
	PossessBackground2,
	MainMenuBarTexture0,
	MainMenuBarTexture1,
	MainMenuBarTexture2,
	MainMenuBarTexture3,
	MainMenuBarLeftEndCap,
	MainMenuBarRightEndCap,
	MultiBarBottomLeft,
	MultiBarBottomRight,
}

local hide = CreateFrame('Frame')
hide:Hide()

for _, v in pairs(HIDE_LIST) do
	if v:GetObjectType() == 'Texture' then
		v:SetTexture(nil)
	else
		v:SetParent(hide)
		if v.UnregisterAllEvents then
			v:UnregisterAllEvents()
		end
    end
end

local OverrideTexList = {
	"_BG",
	"_MicroBGMid",
	"_Border",
	"EndCapL",
	"EndCapR",
	"Divider1",
	"Divider2",
	"Divider3",
	"ExitBG",
	"MicroBGL",
	"MicroBGR",
	"ButtonBGL",
	"ButtonBGR",
	"_ButtonBGMid",
}
--for _, t in pairs(OverrideTexList) do
--	OverrideActionBar[t]:SetAlpha(0)
--end