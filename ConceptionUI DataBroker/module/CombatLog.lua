local CombatLog = LibStub("LibDataBroker-1.1"):NewDataObject('CombatLog', {type = 'data source', value = false})

local IsInInstance, GetCurrentMapAreaID, LoggingCombat = IsInInstance, GetCurrentMapAreaID, LoggingCombat

function CombatLog.OnTooltipShow(tip)
	tip:ClearLines()
	tip:AddDoubleLine('Combat Log', CombatLog.value and '|cFF009E00ON|r' or '|cFF9E0000OFF|r',  1, 1, 1, .62, .62, .62)
	tip:AddLine(' ')
	tip:AddDoubleLine('進階戰鬥紀錄', GetCVar('advancedCombatLogging')=='1' and '|cFF009E00ON|r' or '|cFF9E0000OFF|r', .62, .62, 0, .62, .62, .62)
	tip:AddLine(' ')
	tip:AddDoubleLine('切換戰鬥紀錄', '[L]', .38, .38, .38, .62, .38, 0)
	tip:AddDoubleLine('切換進階紀錄', '[R]', .38, .38, .38, 0, .38, .62)
end

function CombatLog.OnClick(self, button)
	if button == 'LeftButton' then
		LoggingCombat(LoggingCombat() and 0 or 1)
	elseif button == 'RightButton' then
		SetCVar('advancedCombatLogging', 1 - GetCVar('advancedCombatLogging'))
	end
	CombatLog:UpdateText()
	CombatLog.OnTooltipShow(GameTooltip)
end

function CombatLog.UpdateText(self)
	local logging = LoggingCombat()
	if self.value ~= logging then
		self.value = logging
		self.text = ('|cFF616161LOG:%s'):format(logging and '|cFF009E00ON|r' or '|cFF9E0000OFF|r')
		ConceptionCORE.COMBATEVENT:AddNotice(1, 1, 1, ('%s戰鬥紀錄'), logging and '|TInterface/CURSOR/Attack:0|t|cFF009E00開啓|r' or'|TInterface/CURSOR/UnableAttack:0|t|cFF9E0000關閉|r')
	end
end

local function UpdateZone(self)
	local status = nil
	if IsInInstance() then
		local AreaID = GetCurrentMapAreaID()
		if AreaID == 953 then -- 930 = TOT
			status = 1
		end
	end
	LoggingCombat(status)
	self:UpdateText()
end
CombatLog['ZONE_CHANGED_NEW_AREA'] = UpdateZone
CombatLog['PLAYER_ENTERING_WORLD'] = UpdateZone


local F = CreateFrame('Frame')
	F:SetScript('OnEvent', function(_, event) CombatLog[event](CombatLog) end)
	F:RegisterEvent('PLAYER_ENTERING_WORLD')
	F:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	F:Hide()

SetCVar('advancedCombatLogging', 1)