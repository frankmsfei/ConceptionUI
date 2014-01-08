local C, D = unpack(select(2,...))

UIPARENT_MANAGED_FRAME_POSITIONS['CastingBarFrame'] = nil
UIPARENT_MANAGED_FRAME_POSITIONS['PetCastingBarFrame'] = nil
C.auraRows = 0

local function Skin(self)
	self.spellName = self:CreateFontString()
	self.spellName:SetPoint('TOP', self, 'BOTTOM', 7, -2)
	self.spellName:SetFont(DAMAGE_TEXT_FONT, 12, 'THINOUTLINE')
	self.spellIconShadow = D.API.Texture(self, 'CENTER', self.icon, 'CENTER', 0, 0, 16, 16, 'BACKGROUND')
	self.spellIconShadow:SetTexture(D.MEDIA.TEXTURE.buttonShadow)
	self.spellIconShadow:SetVertexColor(0, 0, 0, .7)
	self.barBacadrop = CreateFrame('Frame', nil, self)
	self.barBacadrop:SetPoint('TOPLEFT', -3, 3)
	self.barBacadrop:SetPoint('BOTTOMRIGHT', 3, -3)
	self.barBacadrop:SetFrameLevel(self:GetFrameLevel() -1 > 0 and self:GetFrameLevel() -1 or 0)
	self.barBacadrop:SetBackdrop(D.MEDIA.TEXTURE.backdrop)
	self.barBacadrop:SetBackdropColor(0, 0, 0, .7)
	self.barBacadrop:SetBackdropBorderColor(0, 0, 0, .7)

	self:SetParent(C)
	self:ClearAllPoints()
	self:SetFrameLevel(9)

	self:SetStatusBarTexture(D.MEDIA.TEXTURE.blank)
	self.SetStatusBarTexture = D.API.dummy
	self.icon:Show()
	self.icon:SetTexCoord(.1, .9, .1, .9)
	self.icon:SetSize(12, 12)
	self.icon:ClearAllPoints()
	self.icon:SetPoint('RIGHT', self.spellName, 'LEFT', -2, 0)
	self.icon.SetPoint = D.API.dummy
	self.text:Hide()
	self.text.Show = D.API.dummy
	self.barFlash:Hide()
	self.barFlash.Show = D.API.dummy
	self.barSpark:Hide()
	self.barSpark.Show = D.API.dummy
	self.border:Hide()
	self.border.Show = D.API.dummy
	self.borderShield:SetTexture(nil)
	self.borderShield.SetTexture = D.API.dummy
end

Skin(CastingBarFrame)
CastingBarFrame:SetPoint('Center', UIParent, 'CENTER', 0, 42)
CastingBarFrame:SetSize(130, 2)

Skin(PetCastingBarFrame)
PetCastingBarFrame:SetPoint('Center', UIParent, 'CENTER', 0, 62)
PetCastingBarFrame:SetSize(130, 2)

Skin(TargetFrameSpellBar)
TargetFrameSpellBar:SetPoint('Center', UIParent, 'CENTER', 0, -7)
TargetFrameSpellBar:SetSize(180, 6)


local function Show(self)
	self.spellName:SetText(self.text:GetText())
	if self.borderShield:IsShown() then
		self:SetStatusBarColor(1, 0, 0, 1)
	else
		self:SetStatusBarColor(1, 1, 1, 1)
	end
end

hooksecurefunc(CastingBarFrame, 'Show', Show)
hooksecurefunc(PetCastingBarFrame, 'Show', Show)
hooksecurefunc(TargetFrameSpellBar, 'Show', Show)