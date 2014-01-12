local C, D = unpack(select(2,...))

function D.LOAD.I:LoadTargetDeBuff()
	local func, api = C.FUNC.AURA, D.API
	local Frame, Button, Icon, DropShadow, String = api.Frame, api.Button, api.Icon, api.DropShadow, api.String
	local cfg = D.CFG['AURA_MAJOR']

	local function CreateAura(name, i, parent)
		local a = Button(name..i, parent, 'TOPLEFT', 'ConceptionUI TargetFrame PowerBar', 'BOTTOMLEFT', (cfg.size + cfg.gap) * (i-1) - 25, -66, cfg.size, cfg.size)
			a:SetID(i)
			a:SetScript('OnLeave', func.OnLeave)
			a.anchor = Frame(nil, a, 'CENTER', a, 'CENTER', 0, 0, cfg.size, cfg.size)
			a.icon = Icon(a.anchor, cfg.size, 'BACKGROUND')
			a.icon.overlay:Hide()
			a.shadow = DropShadow(a.anchor)
			a.shadow:Hide()
			a.stack = String(a.anchor, 'BOTTOM', a.anchor, 'TOP', 1, -6, cfg.font, cfg.fontSize_stack, cfg.fontFlag, 1, -1)
			a.timer = String(a.anchor, 'TOP', a.anchor, 'BOTTOM', 1, 0, cfg.font, cfg.fontSize_timer, cfg.fontFlag, 1, -1)
		return a
	end

	local function OnEnter(self)
		return func.OnEnter(self, 'target', 'HARMFUL')
	end

	local F = Frame('ConceptionUI TargetDeBuff', C.UNITFRAME.Major['target'])
		F:SetAlpha(cfg.alpha)

	for i = 1, cfg.amount do
		F[i] = CreateAura('ConceptionUI TargetDeBuff', i, F)
		F[i]:SetScript('OnEnter', OnEnter)
	end

	C.AURAFRAME['TargetDeBuff'] = F
end