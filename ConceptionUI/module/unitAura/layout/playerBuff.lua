local C, D = unpack(select(2,...))
	C.AURAFRAME['PlayerBuff'] = true

function D.LOAD.I:LoadPlayerBuff()
	local func, api = C.FUNC.AURA, D.API
	local Frame, Button, Icon, DropShadow, String = api.Frame, api.Button, api.Icon, api.DropShadow, api.String

	local cfg = D.CFG['AURA_MAJOR']
	local F = Frame('ConceptionUI PlayerBuff', C.UNITFRAME.Major['player'])
		F:SetAlpha(cfg.alpha)

	local function CreateAura(i)
		local a = Button('Conception UI PlayerBuff '..i, F, 'TOPRIGHT', 'ConceptionUI PlayerFrame PowerBar', 'BOTTOMRIGHT', -(cfg.size + cfg.gap) * (i-1) + 10, -28, cfg.size, cfg.size, 'SecureActionButtonTemplate')
			a:SetAttribute('*type2', 'cancelaura')
			a:SetID(i)
			a:HookScript('OnEnter', function(self) return func.OnEnter(self, 'player', 'PLAYER|HELPFUL') end)
			a:HookScript('OnLeave', func.OnLeave)
			a.anchor = Frame(nil, a, 'CENTER', a, 'CENTER', 0, 0, cfg.size, cfg.size)
			a.icon = Icon(a.anchor, cfg.size, 'BACKGROUND')
			a.icon.overlay:Hide()
			a.shadow = DropShadow(a.anchor)
			a.shadow:Hide()
			a.stack = String(a.anchor, 'BOTTOM', a.anchor, 'TOP', 1, -6, cfg.font, cfg.fontSize_stack, cfg.fontFlag, -1, -1)
			a.timer = String(a.anchor, 'TOP', a.anchor, 'BOTTOM', 1, 0, cfg.font, cfg.fontSize_timer, cfg.fontFlag, -1, -1)
		return a
	end

	for i = 1, cfg.amount do F[i] = CreateAura(i) end
	C.AURAFRAME['PlayerBuff'] = F
end