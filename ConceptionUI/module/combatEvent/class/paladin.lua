local C, D = unpack(select(2,...))
if C.CLASS ~= 'PALADIN' then return end
function D.LOAD.M:LoadCombatEventClassCFG()
	local CFG = D.CFG['COMBAT_EVENT']

	
		--ex:[技能] > 目標
		--ex:[技能] DEACTIVATE [目標]
		CFG['aura'] = {  -- 技能喊話
			[853]    = true,	-- 制裁之錘
			[1022]   = true,	-- 保護聖禦
			[1038]   = true,	-- 拯救聖禦
			[1044]   = true,	-- 自由聖禦
			[6940]   = true,	-- 犧牲聖禦
			[20066]  = true,	-- 懺悔
			[20925]  = true,	-- 崇聖護盾
			[105593] = true,	-- 制裁之拳
			[114039] = true,	-- 純淨聖禦
		}

		
		--ex:[技能] ACTIVATE
		--ex:[技能] DEACTIVATE
		CFG['self'] = {  -- 自身技能喊話
			[498]    = true,	-- 聖佑術
			[642]    = true,	-- 聖盾術
			[1022]   = true,	-- 保護聖禦
			[1038]   = true,	-- 拯救聖禦
			[31850]  = true,	-- 忠誠防衛者
			[70940]  = true,	-- 神性守護
			[82327]  = true,	-- 神聖光輝
			[86659]  = true,	-- 遠古諸王守護者(防護)
			[31821]  = true,	-- 虔誠光環
			[114039] = true,  -- 純淨聖禦
			[132403] = false,	-- 盾擊buff
		}
	

		CFG['ae'] = {  -- 範圍直接攻擊
			[35395]  = true,	-- CS
			[53385]  = true,	-- 神性風暴
			[53595]  = true,	-- 公正之錘(物理)
			[85256]  = true,	-- TV
			[88263]  = true,	-- 公正之錘(神聖)
			[96172]  = true,	-- 聖光之手
			[119072] = true,	-- 神聖憤怒
		}
end