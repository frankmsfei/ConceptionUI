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

local spellicon_size = 10*px
local spellicon_offset = -2*px
local raidicon_size = 32*px
local raidicon_offset = 50*px
local backdrop = {bgFile=texture, edgeFile=D.MEDIA.TEXTURE.backdropShadow, edgeSize=4*px, insets={left=4*px,right=4*px,top=4*px,bottom=4*px}, tile=false}
local backdrop_size = 5*px

function NAMEPLATE:Skin(plate)
	if plate.skined then return end
	plate.skined = true

	local healthbar = CreateFrame('StatusBar', nil, plate)
		healthbar:SetStatusBarTexture(texture)
		healthbar:SetSize(plate_width, healthbar_height)
		healthbar:SetPoint('CENTER', plate, 'CENTER')
		plate.healthbar = healthbar

	local bg = CreateFrame('Frame', nil, healthbar)
		bg:SetBackdrop(backdrop)
		bg:SetPoint('TOPLEFT', -backdrop_size, backdrop_size)
		bg:SetPoint('BOTTOMRIGHT', backdrop_size, -backdrop_size)
		bg:SetFrameLevel(healthbar:GetFrameLevel() -1 > 0 and healthbar:GetFrameLevel() -1 or 0)
		bg:SetBackdropColor(0, 0, 0, 0)
		bg:SetBackdropBorderColor(0, 0, 0, 0)
		plate.bg = bg

	local castbar = CreateFrame('StatusBar', nil, plate)
		castbar:SetStatusBarTexture(texture)
		castbar:SetSize(plate_width, castbar_height)
		castbar:SetPoint('TOP', healthbar, 'BOTTOM', 0, -bar_gap)
		castbar.bg = castbar:CreateTexture(nil, 'BACKGROUND')
		castbar.bg:SetTexture(0, 0, 0, 1)
		castbar.bg:SetAllPoints(castbar)
		castbar:Hide()

	local id = plate:CreateFontString()
		id:SetFont(name_font, name_size, 'OUTLINE')
		id:SetPoint('BOTTOM', healthbar, 'TOP', 0, name_offset)
		plate.id = id

	local hp = plate:CreateFontString()
		hp:SetPoint('LEFT', id, 'RIGHT', hp_offset, 0)
		hp:SetFont(numb_font, numb_size, 'OUTLINE')
		plate.hp = hp

	local lv = plate:CreateFontString()
		lv:SetPoint('RIGHT', id, 'LEFT', lv_offset, 0)
		lv:SetFont(numb_font, numb_size, 'OUTLINE')
		plate.lv = lv

	local barFrame, nameFrame = plate:GetChildren()
	local old_healthbar, old_castbar = barFrame:GetChildren()

		old_healthbar:HookScript('OnValueChanged', NAMEPLATE.CheckHealth)
		old_healthbar:Hide()
		old_healthbar.old_healthbar = old_healthbar
		old_healthbar.healthbar = healthbar
		old_healthbar.hp = hp
		plate.old_healthbar = old_healthbar

		old_castbar:HookScript('OnValueChanged', NAMEPLATE.CheckCast)
		old_castbar:HookScript('OnShow', NAMEPLATE.ShowCastBar)
		old_castbar:HookScript('OnHide', NAMEPLATE.HideCastbar)
		old_castbar.castbar = castbar

	local threatGlow, healthbarOverlay, highlight, level, boss, raidicon, elite = barFrame:GetRegions()

		threatGlow:SetTexture(nil)
		plate.threatGlow = threatGlow
		healthbarOverlay:Hide()
		highlight:SetTexture(nil)
		plate.highlight = highlight
		plate.level = level
		boss:SetTexture(nil)
		plate.boss = boss
		raidicon:ClearAllPoints()
		raidicon:SetPoint('TOP', healthbar, 0, raidicon_offset)
		raidicon:SetSize(raidicon_size, raidicon_size)
		elite:SetAlpha(0)
		plate.elite = elite

	local castbarTexture, castbarOverlay, shield, spellIcon, spellName, castbarShadow = old_castbar:GetRegions()

		castbarTexture:SetTexture(nil)
		castbarOverlay:SetTexture(nil)
		shield:SetTexture(nil)
		old_castbar.shield = shield
		spellIcon:SetTexCoord(.1, .9, .1, .9)
		spellIcon:SetSize(spellicon_size, spellicon_size)
		spellIcon:ClearAllPoints()
		spellIcon:SetPoint('TOPRIGHT', spellName, 'TOPLEFT', -1, -.5)
		old_castbar.spellIcon = spellIcon
		spellName:SetFont(name_font, numb_size)
		spellName:SetShadowOffset(0, -1)
		spellName:ClearAllPoints()
		spellName:SetPoint('TOP', castbar, 'BOTTOM', .5*spellicon_size, -1)
		old_castbar.spellName = spellName
		castbarShadow:SetTexture(nil)

	local old_name = nameFrame:GetRegions()

		old_name:Hide()
		plate.old_name = old_name

	plate.CheckColor = self.CheckColor
	plate.CheckThreat = self.CheckThreat
	plate.CheckHealth = self.CheckHealth
	plate.UpdateColor = self.UpdateColor
	plate:HookScript('OnShow', self.OnShow)
	plate:HookScript('OnHide', self.OnHide)
	self.OnShow(plate)
end