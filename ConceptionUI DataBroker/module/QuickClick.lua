LibStub('LibDataBroker-1.1'):NewDataObject('QuickClick', {
	type = 'launcher',
	text = '|cFF616161Ø|r',
	OnClick = function(_, button)
		local shift, alt, awp = IsShiftKeyDown(), IsAltKeyDown(), IsAddOnLoaded('!AWP')
		if button == 'LeftButton' then
			if shift then
				SetCVar('nameplateShowFriends', 1 - GetCVar('nameplateShowFriends'))
				return
			elseif alt then
				if not awp then return end
				SlashCmdList.AWP('load Basic')
				return
			else
				SetCVar('Sound_EnableSFX', 1 - GetCVar('Sound_EnableSFX'))
				return
			end
		elseif button == 'RightButton' then
			if shift then
				SetCVar('nameplateShowEnemies', 1 - GetCVar('nameplateShowEnemies'))
				return
			elseif alt then
				if not awp then return end
				SlashCmdList.AWP('load Raid')
				return
			else
				if not MacroFrame then
					ShowMacroFrame()
					return
				else
					MacroFrame:SetShown(not MacroFrame:IsShown())
					return
				end
			end
		elseif button == 'MiddleButton' then
			return ToggleMinimap()
		end
	end,
 	OnTooltipShow = function(tip)
		local server_time = ('%.2d:%.2d'):format(GetGameTime())
		tip:AddDoubleLine('ConceptionUI', server_time,  1, 1, 1, .62, .62, .62)
		tip:AddDoubleLine(date("%n%b %d '%y %t"), date("%n%A"), .62, .62, 0, .62, .62, .62)
		tip:AddDoubleLine('Local Time', date('%R'), .38, .38, .38, .38, .38, .38)
		tip:AddDoubleLine('Server Time', server_time, .38, .38, .38, .62, .62, .62)
		tip:AddLine('\nQuest Flag', .62, .62, 0)
		tip:AddDoubleLine('Blingtron 4000', IsQuestFlaggedCompleted(31752) and '|cFF616161done|r' or '|cFF9E9E9Enot yat|r', .38, .38, .38)
		tip:AddLine('\nCommon', .62, .62, 0)
		tip:AddDoubleLine('Toggle Sound Effect', '[L]', .38, .38, .38, .62, .38, 0)
		tip:AddDoubleLine('Toggle Macro Frame', '[R]', .38, .38, .38, 0, .38, .62)
		tip:AddDoubleLine('Toggle Minimap', '[M]', .38, .38, .38, .19, .62, .19)
		if IsAddOnLoaded('!AWP') then
			tip:AddLine('\nAddOn Profiles', .62, .62, 0)
			tip:AddDoubleLine('Basic', 'ALT+[L]', .38, .38, .38, .62, .38, 0)
			tip:AddDoubleLine('Raid', 'ALT+[R]', .38, .38, .38, 0, .38, .62)
		end
		tip:AddLine('\nNameplates', .62, .62, 0)
		tip:AddDoubleLine('Friendly Nameplates', 'SHIFT+[L]', .38, .38, .38, .62, .38, 0)
		tip:AddDoubleLine('Enemy Nameplates', 'SHIFT+[R]', .38, .38, .38, 0, .38, .62)
	end
})