local C, D = unpack(select(2,...))
function D.LOAD.I:LoadCombatEventCFG()
	local CFG = D.CFG['COMBAT_EVENT']
	
		--ex:[玩家] > [技能]
		CFG['common'] = {
		-- Damn Portal
			[120146] = true, -- Ancient Portal: Dalaran
		-- RAID
			[29893]  = true, -- Soulwell
			[43987]  = true, -- Conjure Refreshment Table
		-- BG
			[23034]  = true, -- Alliance Battle Standard
			[23035]  = true, -- Horde Battle Standard
		-- Engineering
			[22700]  = true, -- Field Repair Bot 74A
			[44389]  = true, -- Field Repair Bot 110G
			[54711]  = true, -- Scrapbot Construction Kit
			[67826]  = true, -- Jeeves
			[54710]  = true, -- MOLL-E
			[54735]  = true, -- Electromagnetic Pulse
			[84348]  = true, -- nvisibility Field
		-- Toys
			[49844]  = true, -- Direbrew's Remote
			[61031]  = true, -- Toy Train Set
			[62949]  = true, -- Wind-Up Train Wrecker
			[133371] = true, -- Stackable Stag
			[128275] = true, -- Cremating Torch
			[131585] = true, -- Gin-Ji Knife Set
			[127320] = true, -- Magic Banana
			[140271] = true, -- Ra'sha's Sacrificial Dagger
			[131510] = true, -- Cracked Talisman
			[71909]  = true, -- The Heartbreaker
			[131493] = true, -- B. F. F. Necklace
			[129023] = true, -- Krastinov's Bag of Horrors
			[128328] = true, -- Ken-Ken's Mask
			[127800] = true, -- Turnip Punching Bag
			[130505] = true, -- Anatomical Dummy
			[147412] = true, -- Elixir of Wandering Spirits
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


		CFG['sos'] = {
			[82855]  = true, -- Dazzling
			[94794]  = true, -- Rocket Fuel Leak
		}
end