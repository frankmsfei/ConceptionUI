local C, D = unpack(select(2,...))

function D.LOAD.I:LoadFocusDeBuff()
	local func, api = C.FUNC.AURA, D.API
	local Frame, Button, Icon, DropShadow, String = api.Frame, api.Button, api.Icon, api.DropShadow, api.String
	local cfg = D.CFG['AURA_MINOR']

	local function CreateAura(name, i, parent)
		local a = Button(name..i, parent, 'TOPRIGHT', 'ConceptionUI FocusFrame PowerBar', 'BOTTOMRIGHT', -(cfg.size + cfg.gap) * (i-1) - 10, -28, cfg.size, cfg.size)
			a:SetID(i)
			a:SetScript('OnLeave', func.OnLeave)
			a.anchor = Frame(nil, a, 'CENTER', a, 'CENTER', 0, 0, cfg.size, cfg.size)
			a.icon = Icon(a.anchor, cfg.size, 'BACKGROUND')
			a.icon.overlay:Hide()
			a.shadow = DropShadow(a.anchor)
			a.shadow:SetBackdropBorderColor(1, 0, 0, .7)
			a.shadow:Hide()
			a.stack = String(a.anchor, 'BOTTOM', a.anchor, 'TOP', 1, -6, cfg.font, cfg.fontSize_stack, cfg.fontFlag, -1, -1)
			a.timer = String(a.anchor, 'TOP', a.anchor, 'BOTTOM', 1, 0, cfg.font, cfg.fontSize_timer, cfg.fontFlag, -1, -1)
		return a
	end

	local function OnEnter(self)
		return func.OnEnter(self, 'focus', 'HARMFUL')
	end

	local F = Frame('ConceptionUI FocusDeBuff', C.UNITFRAME.Minor['focus'])
		F:SetAlpha(cfg.alpha)

	for i = 1, cfg.amount do
		F[i] = CreateAura('ConceptionUI FocusDeBuff', i, F)
		F[i]:SetScript('OnEnter', OnEnter)
	end

	C.AURAFRAME['FocusDeBuff'] = F
end