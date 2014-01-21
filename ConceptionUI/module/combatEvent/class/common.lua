local C, D = unpack(select(2,...))
function D.LOAD.I:LoadCombatEventCFG()
	local CFG = D.CFG['COMBAT_EVENT']
	
		--ex:[玩家] > [技能]
		CFG['common'] = {
		-- BG
			[43987]  = true, -- Conjure Refreshment Table
			[29893]  = true, -- Soulwell
			[23034]  = true, -- Alliance Battle Standard
			[23035]  = true, -- Horde Battle Standard
		-- Engineering
			[54735]  = true, -- 
			[22700]  = true, -- Field Repair Bot 74A
			[44389]  = true, -- Field Repair Bot 110G
			[54711]  = true, -- Scrapbot Construction Kit
			[67826]  = true, -- Jeeves
			[54710]  = true, -- MOLL-E
		-- Damn Toys
			[61031]  = true, -- Toy Train Set
			[62949]  = true, -- Wind-Up Train Wrecker
			[133371] = true, -- Stackable Stag
			[128275] = true, -- Cremating Torch
			[131585] = true, -- Gin-Ji Knife Set
			[140271] = true, -- Ra'sha's Sacrificial Dagger
			[71909] = true,
		-- Banquets
			[104958] = true, -- Pandaren Banquet
			[105193] = true, -- Great Pandaren Banquet
			[126492] = true, -- Banquet of the Grill
			[126494] = true, -- Great Banquet of the Grill
			[126495] = true, -- Banquet of the Wok
			[126496] = true, -- Great Banquet of the Wok
			[126497] = true, -- Banquet of the Pot
			[126498] = true, -- Great Banquet of the Pot
			[126499] = true, -- Banquet of the Steamer
			[126500] = true, -- Great Banquet of the Steamer
			[126501] = true, -- Banquet of the Oven
			[126502] = true, -- Great Banquet of the Oven
			[126503] = true, -- Banquet of the Brew
			[126504] = true, -- Great Banquet of the Brew
			[126547] = true, -- Perpetual Leftovers
		-- Noodle Cart
			[145166] = true, -- Noodle Cart Kit
			[145169] = true, -- Deluxe Noodle Cart Kit
			[145196] = true, -- Pandaren Treasure Noodle Cart Kit
		}

end