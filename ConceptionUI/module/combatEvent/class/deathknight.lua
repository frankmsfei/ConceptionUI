if select(2, UnitClass('player')) ~= 'DEATHKNIGHT' then return end
local _, combatEvents = ...
local cfg = combatEvents.CFG

	--[[ player aura 白名單 ]]--
	cfg['auraWhiteList'] = {
		[57330]  = true,  -- 號角
	}

	--[[ 領域 ]]--
	cfg['presence'] = {
		[48263]  = true,   -- 血
		[48265]  = true,   -- 邪
		[48266]  = true,   -- 冰
	}

	--[[ 技能喊話 ]]--
	--[技能] > 目標
	cfg['spell'] = {
		[61999]  = true,   -- 戰復
	}

	--[[ 技能喊話 ]]--
	--[技能] > 目標
	--解除 [技能] - 目標
	cfg['cc'] = {
		[47476]  = true,   -- 絞殺
		[49203]  = true,   -- 噬溫酷寒
	}

	--[[ 技能喊話 ]]--
	--[技能] 啟動
	--[技能] 結束
	cfg['aura'] = {
		[48707]  = true,   -- 反魔法護罩
		[48792]  = true,   -- 冰錮堅韌
	}

	--[[ 範圍直接攻擊 ]]--
	cfg['ae'] = {
		[49184]  = true,   -- 凜風衝擊
		[48721]  = true,   -- 沸血術
		[55050]  = true,   -- 碎心
	}