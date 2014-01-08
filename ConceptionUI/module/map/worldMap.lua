WorldMapFrame.Position = WorldMapFrame:CreateFontString(nil, 'OVERLAY')
WorldMapFrame.Position:SetFont(STANDARD_TEXT_FONT, 12, 'THINOUTLINE')
WorldMapFrame.Position:SetPoint('BOTTOMLEFT', WorldMapPositioningGuide, 'BOTTOMLEFT', 10, 10)

local GetPlayerMapPosition = GetPlayerMapPosition
local function GetCoordinate()
	local x, y = GetPlayerMapPosition('player')
	return 100*x, 100*y
end

WorldMapFrame:HookScript('OnUpdate', function(self)
	self.Position:SetFormattedText('%.2f , %.2f', GetCoordinate())
end)

local UnitClass, UnitName, UnitGroupRolesAssigned, RAID_CLASS_COLORS = UnitClass, UnitName, UnitGroupRolesAssigned, RAID_CLASS_COLORS
local ROLE = {['DAMAGER'] = '<|c%s%s|r>', ['HEALER'] = '(|c%s%s|r)', ['TANK'] = '[|c%s%s|r]', ['NONE'] = '|c%s%s|r'}

local function SetName()
	for i = 1, 40 do
		local frame = _G['WorldMapRaid'..i]
		local unit = frame.unit
		if not UnitExists(unit) then break end
		if not frame.unitname then
			 frame.unitname = frame:CreateFontString(nil, 'OVERLAY')
			 frame.unitname:SetFont(STANDARD_TEXT_FONT, 8, 'THINOUTLINE')
			 frame.unitname:SetPoint('LEFT', frame.icon, 'RIGHT')
		end
		local colorStr = '00000000'
		local _, class = UnitClass(unit)
		if class then colorStr = RAID_CLASS_COLORS[class].colorStr end
		frame.unitname:SetFormattedText(ROLE[UnitGroupRolesAssigned(unit)], colorStr, UnitName(unit))
	end
end
hooksecurefunc('WorldMapFrame_UpdateUnits', SetName)