local C, D = unpack(select(2,...))

function D.LOAD.R:LoadTargetTargetFrame()
	local cfg = D.CFG['UNITFRAME_MINOR']
	local func, api, texture, font = C.FUNC.UNIT, D.API, D.MEDIA.TEXTURE, D.MEDIA.FONT
	local Frame, Button, Bar, Texture, String = api.Frame, api.Button, api.Bar, api.Texture, api.String
	local F = Button('ConceptionUI TargetTargetFrame', C, 'BOTTOMLEFT', UIParent, 'CENTER', cfg.x, cfg.y, cfg.hpBarW, cfg.fontSize_health+cfg.hpBarH+cfg.ppBarH, 'SecureUnitButtonTemplate')
		F:SetAlpha(cfg.alpha)
		F:SetBackdrop({bgFile=texture.blank})
		F:SetBackdropColor(0,0,0,0)
		F.hpBar = Bar('ConceptionUI TargetTargetFrame HealthBar', F, 'BOTTOMLEFT', UIParent, 'CENTER', cfg.x, cfg.y, cfg.hpBarW, cfg.hpBarH, 0, 100)
		F.hpBar:SetReverseFill(0)
		F.hpBar:SetStatusBarTexture(texture.blank)
		F.hpBar:SetStatusBarColor(1, 1, 1)
		F.hpBar.bg:SetTexture(0, 0, 0)
		F.ppBar = Bar('ConceptionUI TargetTargetFrame PowerBar', F, 'TOP', F.hpBar, 'BOTTOM', 0, -1, cfg.ppBarW, cfg.ppBarH, 0, 100)
		F.ppBar:SetReverseFill(0)
		F.ppBar:SetStatusBarTexture(texture.blank)
		F.ppBar:SetStatusBarColor(1, 1, 1)
		F.ppBar.bg:SetTexture(0, 0, 0)
		F.ppBar.icon = Texture(F.ppBar, 'TOPRIGHT', F.ppBar, 'BOTTOMLEFT', 0, -3, 1, 3, 'ARTWORK')
		F.ppBar.icon:SetTexture(texture.blank)
		F.ppBar.icon:Hide()
		F.barBacadrop = Frame(nil, F.hpBar, 'TOP', F.hpBar, 'TOP', 0, 3, cfg.hpBarW+6, cfg.hpBarH+1+cfg.ppBarH+6)
		F.barBacadrop:SetFrameLevel(F.hpBar:GetFrameLevel() -1 > 0 and F.hpBar:GetFrameLevel() -1 or 0)
		F.barBacadrop:SetBackdrop(texture.backdrop)
		F.barBacadrop:SetBackdropColor(0, 0, 0, .6)
		F.barBacadrop:SetBackdropBorderColor(0, 0, 0, .6)
		F.hpBar.hp = String(F.hpBar, 'BOTTOMLEFT', F.hpBar, 'TOPLEFT', 0, 1, font.HandelGotD, cfg.fontSize_health, cfg.fontFlag)
		F.ppBar.pp = String(F.ppBar, 'TOP', F.ppBar.icon, 'BOTTOM', 0, -2, font.HandelGotD, cfg.fontSize_power, cfg.fontFlag)
		F.name = String(F, 'BOTTOMRIGHT', F.hpBar, 'TOPRIGHT', 0, 2, cfg.font, cfg.fontSize, cfg.fontFlag)
		F.target = String(F, 'BOTTOMLEFT', F.name, 'BOTTOMRIGHT', 2, 0, cfg.font, cfg.fontSize, cfg.fontFlag)
		F.arrow = Texture(F, 'RIGHT', F.hpBar, 'LEFT', 0, -.5, 16, 16)
		F.arrow:SetTexture(texture.arrowR)
		F.arrow:Hide()
		F:Hide()

		local freq, UnitExists = cfg.frequency, UnitExists
		local function OnUpdate(self, elapsed)
			self.elapsed = (self.elapsed or 0) + elapsed
			if self.elapsed  < freq then return end
			self.elapsed = 0
			func.OnHpChanged(self, 'targettarget')
			func.OnPpChanged(self, 'targettarget')
		end

		local function OnShow(self)
			self:SetScript('OnUpdate', OnUpdate)
		end

		local function OnHide(self)
			self:SetScript('OnUpdate', nil)
		end

		F:SetAttribute('unit', 'targettarget')
		F:SetAttribute('*type1', 'target')
		F:SetAttribute('*type2', 'menu')
		F.menu = function(self) ToggleDropDownMenu(1, nil, TargetTargetFrameDropDown, self, 0, -2, nil, nil, 1.5) end
		F:HookScript('OnEnter', func.OnEnter)
		F:HookScript('OnLeave', func.OnLeave)
		F:HookScript('OnShow', func.OnShow)
		F:HookScript('OnHide', func.OnHide)
		F:HookScript('OnShow', OnShow)
		F:HookScript('OnHide', OnHide)
	C.UNITFRAME.Minor['targettarget'] = F
	RegisterUnitWatch(F)
end