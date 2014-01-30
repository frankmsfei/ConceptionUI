local C, D = unpack(select(2,...))
local NAMEPLATE = C.NAMEPLATE
NAMEPLATE_FONT = nil

local px = D.API.scale(1)
local name_font = UNIT_NAME_FONT
local name_size = 12*px
local name_offset = 4*px
local numb_font = D.MEDIA.FONT.HandelGotD
local numb_size = 10*px
local hp_offset = 2*px
local lv_offset = -2*px
local info_offset = -2*px

local texture = D.MEDIA.TEXTURE.blank
local plate_width = 80*px
local healthbar_height = 2*px
local castbar_height = 1*px
local bar_gap = 1*px

local buttonShadow = D.MEDIA.TEXTURE.buttonShadow
local spellicon_size = 10*px
local spellicon_offset = -2*px
local raidicon_size = 32*px
local raidicon_offset = 50*px
local backdrop = {bgFile=texture, edgeFile=D.MEDIA.TEXTURE.backdropShadow, edgeSize=4*px, insets={left=4*px,right=4*px,top=4*px,bottom=4*px}, tile=false}
local backdrop_size = 5*px

function NAMEPLATE:Skin(plate)
	if plate.skined then return end
	plate.skined = true

	plate.healthbar = CreateFrame('StatusBar', nil, plate)
	plate.healthbar:SetStatusBarTexture(texture)
	plate.healthbar:SetSize(plate_width, healthbar_height)
	plate.healthbar:SetPoint('CENTER', plate, 'CENTER')
	plate.bg = CreateFrame('Frame', nil, plate.healthbar)
	plate.bg:SetBackdrop(backdrop)
	plate.bg:SetPoint('TOPLEFT', -backdrop_size, backdrop_size)
	plate.bg:SetPoint('BOTTOMRIGHT', backdrop_size, -backdrop_size)
	plate.bg:SetFrameLevel(plate.healthbar:GetFrameLevel() -1 > 0 and plate.healthbar:GetFrameLevel() -1 or 0)
	plate.bg:SetBackdropColor(0, 0, 0, 0)
	plate.bg:SetBackdropBorderColor(0, 0, 0, 0)
	plate.castbar = CreateFrame('StatusBar', nil, plate)
	plate.castbar:SetStatusBarTexture(texture)
	plate.castbar:SetSize(plate_width, castbar_height)
	plate.castbar:SetPoint('TOP', plate.healthbar, 'BOTTOM', 0, -bar_gap)
	plate.castbar.bg = plate.castbar:CreateTexture(nil, 'BACKGROUND')
	plate.castbar.bg:SetTexture(0, 0, 0, 1)
	plate.castbar.bg:SetAllPoints(plate.castbar)
	plate.castbar:Hide()
	plate.id = plate:CreateFontString()
	plate.id:SetFont(name_font, name_size, 'OUTLINE')
	plate.id:SetPoint('BOTTOM', plate.healthbar, 'TOP', 0, name_offset)
	plate.hp = plate:CreateFontString()
	plate.hp:SetPoint('LEFT', plate.id, 'RIGHT', hp_offset, 0)
	plate.hp:SetFont(numb_font, numb_size, 'OUTLINE')
	plate.lv = plate:CreateFontString()
	plate.lv:SetPoint('RIGHT', plate.id, 'LEFT', lv_offset, 0)
	plate.lv:SetFont(numb_font, numb_size, 'OUTLINE')

	plate.barFrame, plate.nameFrame = plate:GetChildren()

	plate.old_healthbar, plate.old_castbar = plate.barFrame:GetChildren()

	plate.old_healthbar:Hide()
	plate.old_healthbar.old_healthbar = plate.old_healthbar
	plate.old_healthbar.healthbar = plate.healthbar
	plate.old_healthbar.hp = plate.hp
	plate.old_healthbar:HookScript('OnValueChanged', NAMEPLATE.CheckHealth)

	plate.old_castbar.castbar = plate.castbar
	plate.old_castbar:HookScript('OnShow', NAMEPLATE.ShowCastBar)
	plate.old_castbar:HookScript('OnHide', NAMEPLATE.HideCastbar)
	plate.old_castbar:HookScript('OnValueChanged', NAMEPLATE.CheckCast)

	plate.old_castbar.castbarTexture, plate.old_castbar.castbarOverlay, plate.old_castbar.shield, plate.old_castbar.spellIcon, plate.old_castbar.spellName, plate.old_castbar.castbarShadow = plate.old_castbar:GetRegions()

	plate.old_castbar.castbarTexture:SetTexture(nil)
	plate.old_castbar.castbarOverlay:SetTexture(nil)
	plate.old_castbar.shield:SetTexture(nil)
	plate.old_castbar.spellIcon:SetTexCoord(.1, .9, .1, .9)
	plate.old_castbar.spellIcon:SetSize(spellicon_size, spellicon_size)
	plate.old_castbar.spellIcon:ClearAllPoints()
	plate.old_castbar.spellIcon:SetPoint('TOPRIGHT', plate.old_castbar.spellName, 'TOPLEFT', -1, -.5)
	plate.old_castbar.spellName:SetFont(name_font, numb_size, 'OUTLINE')
	plate.old_castbar.spellName:ClearAllPoints()
	plate.old_castbar.spellName:SetPoint('TOP', plate.castbar, 'BOTTOM', .5*spellicon_size, -1)
	plate.old_castbar.castbarShadow:SetTexture(nil)

	plate.old_castbar.iconShadow = plate.old_castbar:CreateTexture(nil, 'BACKGROUND')
	plate.old_castbar.iconShadow:SetTexture(buttonShadow)
	plate.old_castbar.iconShadow:SetPoint('TOPLEFT', plate.old_castbar.spellIcon, 'TOPLEFT', -2, 2)
	plate.old_castbar.iconShadow:SetPoint('BOTTOMRIGHT', plate.old_castbar.spellIcon, 'BOTTOMRIGHT', 2, -2)
	plate.old_castbar.iconShadow:SetVertexColor(1, 1, 1, 1)

	plate.threatGlow, plate.healthbarOverlay, plate.highlight, plate.level, plate.boss, plate.raidicon, plate.elite = plate.barFrame:GetRegions()
	plate.threatGlow:SetTexture(nil)
	plate.healthbarOverlay:Hide()
	plate.highlight:SetTexture(nil)
	plate.boss:SetTexture(nil)
	plate.raidicon:ClearAllPoints()
	plate.raidicon:SetPoint('TOP', plate.healthbar, 0, raidicon_offset)
	plate.raidicon:SetSize(raidicon_size, raidicon_size)
	plate.elite:SetAlpha(0)

	plate.old_name = plate.nameFrame:GetRegions()
	plate.old_name:Hide()

	plate.CheckColor = self.CheckColor
	plate.CheckThreat = self.CheckThreat
	plate.CheckHealth = self.CheckHealth
	plate.UpdateColor = self.UpdateColor
	plate:HookScript('OnShow', self.OnShow)
	plate:HookScript('OnHide', self.OnHide)
	self.OnShow(plate)
end