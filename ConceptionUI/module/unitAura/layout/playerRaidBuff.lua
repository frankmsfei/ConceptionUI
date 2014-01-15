local C, D = unpack(select(2,...))

function D.LOAD.I:LoadPlayerRaidBuff()
	local func, api = C.FUNC.AURA, D.API
	local Frame, Button, Icon, DropShadow, String = api.Frame, api.Button, api.Icon, api.DropShadow, api.String
	local cfg = D.CFG['AURA_RAID']	

	local function CreateAura(name, i, parent)
		local a = Button(name..i, parent, 'TOPLEFT', UIParent, 'TOPLEFT', ((cfg.size + cfg.gap) * (i-1)) + 10, -10, cfg.size, cfg.size, 'SecureActionButtonTemplate')
			a:SetAttribute('*type2', 'cancelaura')
			a:SetID(i)
			a:SetScript('OnLeave', func.OnLeave)
			a.anchor = Frame(nil, a, 'CENTER', a, 'CENTER', 0, 0, cfg.size, cfg.size)
			a.icon = Icon(a.anchor, cfg.size, 'BACKGROUND')
			a.icon.overlay:Hide()
			a.shadow = DropShadow(a.anchor)
			a.shadow:Hide()
			a.stack = String(a.anchor, 'BOTTOM', a.anchor, 'TOP', 1, -6, cfg.font, cfg.fontSize_stack, cfg.fontFlag, -1, 1)
			a.timer = String(a.anchor, 'TOP', a.anchor, 'BOTTOM', 1, 0, cfg.font, cfg.fontSize_timer, cfg.fontFlag, -1, 1)
		return a
	end

	local function OnEnter(self)
		return func.OnEnter(self, 'player', 'HELPFUL')
	end

	local F = Frame('ConceptionUI PlayerRaidBuff', C)
		F:SetAlpha(cfg.alpha)

	for i = 1, cfg.amount do
		F[i] = CreateAura('ConceptionUI PlayerRaidBuff', i, F)
		F[i]:SetScript('OnEnter', OnEnter)
	end

	C.AURAFRAME['PlayerRaidBuff'] = F

	local T = {}

	for i = 1, 2 do
		T[i] = CreateAura('ConceptionUI PlayerTemporaryBuff', i, F)
		T[i]:SetPoint('TOPLEFT', F[i], 'BOTTOMLEFT', 0, -5-cfg.gap)
		T[i]:SetAttribute('target-slot', 15+i)
	end

	C.AURAFRAME['PlayerTemporaryBuff'] = T
end