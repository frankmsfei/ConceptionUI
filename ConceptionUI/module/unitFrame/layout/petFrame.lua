local C, D = unpack(select(2,...))

function D.LOAD.R:LoadPetFrame()
	local cfg = D.CFG['UNITFRAME_MINOR']
	local func, api, texture, font = C.FUNC.UNIT, D.API, D.MEDIA.TEXTURE, D.MEDIA.FONT
	local Frame, Button, Bar, Texture, String = api.Frame, api.Button, api.Bar, api.Texture, api.String
	local F = Button('ConceptionUI PetFrame', C, 'BOTTOMRIGHT', UIParent, 'CENTER', -cfg.x, -cfg.y-8, cfg.hpBarW, cfg.fontSize_health+cfg.hpBarH+cfg.ppBarH, 'SecureUnitButtonTemplate')
		F:SetAlpha(cfg.alpha)
		F:SetBackdrop({bgFile=texture.blank})
		F:SetBackdropColor(0,0,0,0)
		F.hpBar = Bar('ConceptionUI PetFrame HealthBar', F, 'TOPRIGHT', UIParent, 'CENTER', -cfg.x, -cfg.y-6, cfg.hpBarW, cfg.hpBarH, 0, 100)
		F.hpBar:SetReverseFill(1)
		F.hpBar:SetStatusBarTexture(texture.blank)
		F.hpBar:SetStatusBarColor(1,1,1)
		F.hpBar.bg:SetTexture(0,0,0)
		F.ppBar = Bar('ConceptionUI FocusFrame PowerBar', F, 'TOP', F.hpBar, 'BOTTOM', 0, -1, cfg.ppBarW, cfg.ppBarH, 0, 100)
		F.ppBar:SetReverseFill(1)
		F.ppBar:SetStatusBarTexture(texture.blank)
		F.ppBar:SetStatusBarColor(1,1,1)
		F.ppBar.bg:SetTexture(0,0,0)
		F.ppBar.icon = Texture(F.ppBar, 'TOPLEFT', F.ppBar, 'BOTTOMRIGHT', 0, -3, 1, 3, 'ARTWORK')
		F.ppBar.icon:SetTexture(texture.blank)
		F.ppBar.icon:Hide()
		F.barBacadrop = Frame(nil, F.hpBar, 'TOP', F.hpBar, 'TOP', 0, 3, cfg.hpBarW+6, cfg.hpBarH+1+cfg.ppBarH+6)
		F.barBacadrop:SetFrameLevel(F.hpBar:GetFrameLevel() -1 > 0 and F.hpBar:GetFrameLevel() -1 or 0)
		F.barBacadrop:SetBackdrop(texture.backdrop)
		F.barBacadrop:SetBackdropColor(0, 0, 0, .6)
		F.barBacadrop:SetBackdropBorderColor(0, 0, 0, .6)
		F.hpBar.hp = String(F.hpBar, 'BOTTOMRIGHT', F.hpBar, 'TOPRIGHT', 0, 1, font.HandelGotD, cfg.fontSize_health, cfg.fontFlag)
		F.ppBar.pp = String(F.ppBar, 'TOP', F.ppBar.icon, 'BOTTOM', 0, -2, font.HandelGotD, cfg.fontSize_power, cfg.fontFlag)
		F.name = String(F, 'BOTTOMLEFT', F.hpBar, 'TOPLEFT', 0, 2, cfg.font, cfg.fontSize, cfg.fontFlag)
		F.target = String(F, 'BOTTOMRIGHT', F.name, 'BOTTOMLEFT', -2, 0, cfg.font, cfg.fontSize, cfg.fontFlag)
		F.arrow = Texture(F, 'LEFT', F.hpBar, 'RIGHT', 0, -.5, 16, 16)
		F.arrow:SetTexture(texture.arrowL)
		F.arrow:Hide()
		F:Hide()
		F.menu = function(self) return ToggleDropDownMenu(1, nil, PetFrameDropDown, self, 0, -2, nil, nil, 1.5) end
		F:SetAttribute('unit', 'pet')
		F:SetAttribute('*type1', 'target')
		F:SetAttribute('*type2', 'menu')
		F:HookScript('OnEnter', func.OnEnter)
		F:HookScript('OnLeave', func.OnLeave)
		F:HookScript('OnShow', func.OnShow)
		F:HookScript('OnHide', func.OnHide)
	C.UNITFRAME.Minor['pet'] = F
	RegisterUnitWatch(F)
end