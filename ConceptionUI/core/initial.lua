local C, D = unpack(select(2,...))

function D.LOAD.P:Initial()
	local cfg, api = D.CFG['OTHERS'], D.API

	-- Spell Activation Overlay
	SpellActivationOverlayFrame:SetScale(api.scale(1))

	-- RaidBossEmoteFrame
	RaidBossEmoteFrame:ClearAllPoints()
	RaidBossEmoteFrame:SetPoint('TOP', UIParent, 'CENTER', 0, 0)

	-- 解除玩家框架
	UnregisterUnitWatch(PlayerFrame)
	PlayerFrame:UnregisterAllEvents()
	PlayerFrame.Show = api.dummy
	PlayerFrame:Hide()
	PlayerFrameHealthBar:UnregisterAllEvents()
	PlayerFrameManaBar:UnregisterAllEvents()

	-- 解除目標框架
	UnregisterUnitWatch(TargetFrame)
	TargetFrame:UnregisterAllEvents()
	TargetFrame.Show = api.dummy
	TargetFrame:Hide()
	TargetFrameHealthBar:UnregisterAllEvents()
	TargetFrameManaBar:UnregisterAllEvents()

	-- 解除焦點框架
	UnregisterUnitWatch(FocusFrame)
	FocusFrame:UnregisterAllEvents()
	FocusFrame.Show = api.dummy
	FocusFrame:Hide()
	FocusFrameHealthBar:UnregisterAllEvents()
	FocusFrameManaBar:UnregisterAllEvents()

	-- 解除BUFF框架
	BuffFrame:UnregisterAllEvents()
	BuffFrame:Hide()
	TemporaryEnchantFrame:UnregisterAllEvents()
	TemporaryEnchantFrame:Hide()

	-- 解除賊貓集星
	ComboFrame:UnregisterAllEvents()
	ComboFrame.Show = api.dummy
	ComboFrame:Hide()

	-- 解除DK符文框架
	if cfg.killBZRuneFrame then
		RuneFrame:UnregisterAllEvents()
		RuneFrame.Show = api.dummy
		RuneFrame:Hide()
	end

	-- 解除團隊框架
	if cfg.killBZRaidFrame then
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager:Hide()
		CompactRaidFrameContainer:UnregisterAllEvents()
		CompactRaidFrameContainer:Hide()
	end

	-- 解除boss框架
	if cfg.killBZBossFrame then
		local _G = _G
		for i = 1, MAX_BOSS_FRAMES do
			local f = 'Boss'..i..'TargetFrame'
			UnregisterUnitWatch(_G[f])
			_G[f]:UnregisterAllEvents()
			_G[f].Show = api.dummy
			_G[f]:Hide()
			_G[f..'HealthBar']:UnregisterAllEvents()
			_G[f..'ManaBar']:UnregisterAllEvents()
		end
	end	
end