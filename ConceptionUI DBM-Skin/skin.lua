local C, D = unpack(ConceptionUI)
local MEDIA = D.MEDIA
local BAR_TEXTURE = MEDIA.TEXTURE.blank
local BAR_BACKDROP = MEDIA.TEXTURE.backdrop
local BUTTON_OVERLAY = MEDIA.TEXTURE.buttonOverlay
local BUTTON_SHADOW = MEDIA.TEXTURE.buttonShadow



local function SkinBar(self)
	self.bar:SetHeight(2)
	self.bar:ClearAllPoints()
	self.bar:SetPoint('BOTTOM', self.frame, 'BOTTOM', 0, 0)
	self.bar_texture:SetDrawLayer('BACKGROUND')
	self.bar_background:SetTexture(nil)
	self.bar_backdrop = CreateFrame('Frame', nil, self.bar)
	self.bar_backdrop:SetPoint('TOPRIGHT', self.bar, 'TOPRIGHT', 3, 3)
	self.bar_backdrop:SetPoint('BOTTOMLEFT', self.bar, 'BOTTOMLEFT', -3, -3)
	self.bar_backdrop:SetFrameLevel(self.bar:GetFrameLevel() -1 > 0 and self.bar:GetFrameLevel() -1 or 0)
	self.bar_backdrop:SetBackdrop(BAR_BACKDROP)
	self.bar_backdrop:SetBackdropColor(0, 0, 0, 1)
	self.bar_backdrop:SetBackdropBorderColor(0, 0, 0, 1)
	self.bar_icon1:SetSize(20, 20)
	self.bar_icon1:SetDrawLayer('ARTWORK')
	self.bar_icon1.overlay = self.bar:CreateTexture(nil, 'OVERLAY')
	self.bar_icon1.overlay:SetAllPoints(self.bar_icon1)
	self.bar_icon1.overlay:SetTexture(BUTTON_OVERLAY)
	self.bar_icon1.overlay:SetVertexColor(0, 0, 0, 1)
	self.bar_icon1.shadow = self.bar:CreateTexture(nil, 'BORDER')
	self.bar_icon1.shadow:SetPoint('TOPLEFT', self.bar_icon1, 'TOPLEFT', -4, 4)
	self.bar_icon1.shadow:SetPoint('BOTTOMRIGHT', self.bar_icon1, 'BOTTOMRIGHT', 4, -4)
	self.bar_icon1.shadow:SetTexture(BUTTON_SHADOW)
	self.bar_icon2:SetSize(20, 20)
	self.bar_icon2:SetDrawLayer('ARTWORK')
	self.bar_icon2.overlay = self.bar:CreateTexture(nil, 'OVERLAY')
	self.bar_icon2.overlay:SetAllPoints(self.bar_icon2)
	self.bar_icon2.overlay:SetTexture(BUTTON_OVERLAY)
	self.bar_icon2.overlay:SetVertexColor(0, 0, 0, 1)
	self.bar_icon2.shadow = self.bar:CreateTexture(nil, 'BORDER')
	self.bar_icon2.shadow:SetPoint('TOPLEFT', self.bar_icon2, 'TOPLEFT', -4, 4)
	self.bar_icon2.shadow:SetPoint('BOTTOMRIGHT', self.bar_icon2, 'BOTTOMRIGHT', 4, -4)
	self.bar_icon2.shadow:SetTexture(BUTTON_SHADOW)
	self.bar_icon1:SetTexCoord(.08, .92, .08, .92)
	self.bar_icon2:SetTexCoord(.08, .92, .08, .92)
	self.bar_text:SetShadowOffset(0, 0)
	self.bar_timer:SetShadowOffset(0, 0)
	self.bar_spark:SetTexture(nil)
	self.skin = true
end

local function ApplyStyle(self)
	if not self.skin then
		SkinBar(self)
	end
	if self.color then
		self.bar:SetStatusBarColor(self.color.r, self.color.g, self.color.b)
	else
		self.bar:SetStatusBarColor(self.owner.options.StartColorR, self.owner.options.StartColorG, self.owner.options.StartColorB)
	end
	self.bar_text:SetTextColor(self.owner.options.TextColorR, self.owner.options.TextColorG, self.owner.options.TextColorB)
	self.bar_timer:SetTextColor(self.owner.options.TextColorR, self.owner.options.TextColorG, self.owner.options.TextColorB)
	if self.owner.options.IconLeft then self.bar_icon1:Show() self.bar_icon1.overlay:Show() self.bar_icon1.shadow:Show() else self.bar_icon1:Hide() self.bar_icon1.overlay:Hide() self.bar_icon1.shadow:Hide() end
	if self.owner.options.IconRight then self.bar_icon2:Show() self.bar_icon2.overlay:Show() self.bar_icon2.shadow:Show() else self.bar_icon2:Hide() self.bar_icon2.overlay:Hide() self.bar_icon2.shadow:Hide() end
	if self.enlarged then
		self.bar_texture:SetTexture(self.owner.options.Texture)
		self.bar_backdrop:SetAlpha(1)
		self.frame:SetWidth(self.owner.options.HugeWidth)
		self.bar:SetWidth(self.owner.options.HugeWidth)
		self.frame:SetScale(self.owner.options.HugeScale)
		self.bar_text:ClearAllPoints()
		self.bar_text:SetPoint('CENTER', self.frame, 'CENTER', 0, 0)
		self.bar_timer:ClearAllPoints()
		self.bar_timer:SetPoint('LEFT', self.bar_text, 'RIGHT', 4, 0)
		self.bar_icon1:ClearAllPoints()
		self.bar_icon1:SetPoint('RIGHT', self.bar_text, 'LEFT', -4, 0)
		self.bar_icon2:ClearAllPoints()
		self.bar_icon2:SetPoint('LEFT', self.bar_timer, 'RIGHT', 4, 0)
	else
		self.bar_texture:SetTexture(nil)
		self.bar_backdrop:SetAlpha(0)
		self.frame:SetWidth(self.owner.options.Width)
		self.bar:SetWidth(self.owner.options.Width)
		self.frame:SetScale(self.owner.options.Scale)
		self.bar_icon1:ClearAllPoints()
		self.bar_icon1:SetPoint('BOTTOMRIGHT', self.frame, 'BOTTOMLEFT', -4, 0)
		self.bar_icon2:ClearAllPoints()
		self.bar_icon2:SetPoint('BOTTOMLEFT', self.frame, 'BOTTOMRIGHT', 4, 0)
		self.bar_text:ClearAllPoints()
		self.bar_text:SetPoint('LEFT', self.bar_icon1, 'RIGHT', 4, 0)
		self.bar_timer:ClearAllPoints()
		self.bar_timer:SetPoint('RIGHT', self.bar_icon2, 'LEFT', -4, 0)
	end
	self.frame:Show()
	self.frame:SetAlpha(1)
	self.bar_text:SetFont(self.owner.options.Font, self.owner.options.FontSize, 'THICKOUTLINE')
	self.bar_timer:SetFont(self.owner.options.Font, self.owner.options.FontSize, 'THICKOUTLINE')
	self:Update(0)
end

local function Apply(self)
	local name = self.frame:GetName()
	self.bar = _G[name.."Bar"]
	self.bar_background = _G[name.."BarBackground"]
	self.bar_spark = _G[name.."BarSpark"]
	self.bar_texture = _G[name.."BarTexture"]
	self.bar_icon1 = _G[name.."BarIcon1"]
	self.bar_icon2 = _G[name.."BarIcon2"]
	self.bar_timer = _G[name.."BarTimer"]
	self.bar_text = _G[name.."BarName"]
	ApplyStyle(self)
	self.apply = true
end

local function ApplyBars(self, timer, id, icon, huge, small, color, isDummy)
	self.mainAnchor:ClearAllPoints()
	self.mainAnchor:SetPoint('LEFT', UIParent, 'LEFT', 130, 50)
	self.secAnchor:ClearAllPoints()
	self.secAnchor:SetPoint('CENTER', UIParent, 'CENTER', 0, 320)
	for bar in pairs(self.bars) do
		if not bar.apply then
			Apply(bar)
			bar.ApplyStyle = ApplyStyle
		 end
	end
end
hooksecurefunc(DBT, 'CreateBar', ApplyBars)



local function OnEvent()
	DBT_SavedOptions['DBM'].Texture = BAR_TEXTURE
	DBT_SavedOptions['DBM'].Font = DAMAGE_TEXT_FONT
	DBT_SavedOptions['DBM'].FontSize = 15
	DBT_SavedOptions['DBM'].Scale = 1
	DBT_SavedOptions['DBM'].HugeScale = 1.5
	DBT_SavedOptions['DBM'].Width = 200
	DBT_SavedOptions['DBM'].HugeWidth = 200
	DBT_SavedOptions['DBM'].StartColorR = 1
	DBT_SavedOptions['DBM'].StartColorG = 1
	DBT_SavedOptions['DBM'].StartColorB = 1
	DBT_SavedOptions['DBM'].EndColorR = .618
	DBT_SavedOptions['DBM'].EndColorG = 0
	DBT_SavedOptions['DBM'].EndColorB = 0
	DBT_SavedOptions['DBM'].IconLeft = true
	DBT_SavedOptions['DBM'].IconRight = false
	DBT_SavedOptions['DBM'].FillUpBars = false
	DBM_SavedOptions.SpecialWarningPoint = 'CENTER'
	DBM_SavedOptions.SpecialWarningX = 0
	DBM_SavedOptions.SpecialWarningY = 250
	DBM_SavedOptions.LTSpecialWarningPoint = 'CENTER'
	DBM_SavedOptions.LTSpecialWarningX = 0
	DBM_SavedOptions.LTSpecialWarningY = 140

	RaidWarningFrame.slot1:SetFont(DAMAGE_TEXT_FONT, 20, 'THICKOUTLINE')
	RaidWarningFrame.slot1:SetShadowOffset(0, 0)
	RaidWarningFrame.slot2:SetFont(DAMAGE_TEXT_FONT, 20, 'THICKOUTLINE')
	RaidWarningFrame.slot2:SetShadowOffset(0, 0)

	local RaidNoticeAddMessage = RaidNotice_AddMessage
	function RaidNotice_AddMessage(noticeFrame, textString, colorInfo, displayTime)
	  return RaidNoticeAddMessage(noticeFrame, textString and textString:gsub(':12:12', ':0:0:0:0:64:64:5:59:5:59'), colorInfo, displayTime)
	end

	print('|cFFCCCCCCC|cFFAAAAAAUI|r - DBM Skin Loaded.')
end

local F = CreateFrame('Frame')
	F:SetScript('OnEvent', OnEvent)
	F:RegisterEvent('PLAYER_LOGIN')