if select(2, UnitClass('player')) ~= 'WARRIOR' then return end
local _, combatEvents = ...
local cfg = combatEvents.CFG

	--[[ 體位 ]]--
	cfg['stence'] = {
	--    [id]     = ani,
		[71]     = true,   -- 防禦
		[2457]   = true,   -- 戰鬥
		[2458]   = true,   -- 狂暴
	}

	--[[ 範圍直接攻擊 ]]--
	cfg['ae'] = {
	--    [id]      =  ani,
		[845]     =  true,   -- 順劈
		[6343]    =  true,   -- 雷霆
		[6572]    =  true,   -- 復仇
		[52174]   =  true,   -- 英勇躍擊
		[46924]   =  true,   -- 劍刃風暴
		[46968]   =  true,   -- 震懾
		[118000]  =  true,   -- 龍吼
	}

	--[[ 技能喊話 ]]--
	--[技能] 啟動
	--[技能] 結束
	cfg['aura'] = {
	--    [id]      = msg,
		[469]     = false,   -- 命令之吼
		[6673]    = false,   -- 戰鬥怒吼
		[871]     = true,    -- 盾牆
		[2565]    = false,   -- 盾牌格檔
		[23920]   = false,   -- 法術反射
		[97954]   = false,   -- 格檔法術
		[12976]   = true,    -- 破斧
		[55694]   = true,    -- 狂怒回復
		[97463]   = true,    -- 振奮咆哮
		[105909]  = false,   -- 復仇盾
		[102667]  = false,   -- 謊言
		[107951]  = true,    -- 深淵
		[82176]   = false,   -- 偏斜裝甲
		[82627]   = true,    -- 電漿護盾
	}

	--[[ 技能喊話 ]]--
	--[技能] > 目標
	cfg['spell'] = {
	--    [id]      =  msg,
		[3411]    =  false,  -- 阻擾
		[50720]   =  true,   -- 戒備
	}

	--[[ 技能喊話 ]]--
	--[技能] > 目標
	--解除 [技能] - 目標
	cfg['cc'] = {
	--    [id]      =  msg,
		[676]     =  false,   -- 繳械
		[5246]    =  false,   -- 破膽
		[46968]   =  false,   -- 震懾
		[18498]   =  false,   -- 沈默
	}