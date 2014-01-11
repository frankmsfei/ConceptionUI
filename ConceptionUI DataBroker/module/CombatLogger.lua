local CombatLogger = LibStub("LibDataBroker-1.1"):NewDataObject("CombatLogger", {type = 'data source'})

local IsInInstance, GetCurrentMapAreaID, LoggingCombat = IsInInstance, GetCurrentMapAreaID, LoggingCombat

function CombatLogger:OnClick(button)
	local logging = LoggingCombat()
	if logging then
		LoggingCombat(false)
		CombatLogger.text = ('|cFF616161LOG:%s'):format('|cFF9E0000OFF|r')
	else
		LoggingCombat(true)
		CombatLogger.text = ('|cFF616161LOG:%s'):format('|cFF009E00ON|r')
	end
end

function CombatLogger:Update()
	local status = false
	if IsInInstance() then
		local AreaID = GetCurrentMapAreaID()
		if AreaID == 953 or AreaID == 930 then
			status = true
		end
	end
	LoggingCombat(status)
	self.text = ('|cFF616161LOG:%s'):format(status==true and '|cFF009E00ON|r' or '|cFF9E0000OFF|r')
end

function CombatLogger:ZONE_CHANGED_NEW_AREA()
	self:Update()
end

function CombatLogger:PLAYER_ENTERING_WORLD()
	self:Update()
end

local F = CreateFrame('Frame')
	F:SetScript('OnEvent', function(_, event) CombatLogger[event](CombatLogger, event) end)
	F:RegisterEvent('PLAYER_ENTERING_WORLD')
	F:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	F:Hide()