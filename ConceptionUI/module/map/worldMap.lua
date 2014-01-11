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
local ROLE = {
	['DAMAGER'] = '|c%s%s|r|TInterface/LFGFRAME/LFGROLE:0:0:0:0:64:16:17:32:1:16|t',
	['TANK']    = '|c%s%s|r|TInterface/LFGFRAME/LFGROLE:0:0:0:0:64:16:33:48:1:16|t',
	['HEALER']  = '|c%s%s|r|TInterface/LFGFRAME/LFGROLE:0:0:0:0:64:16:49:64:1:16|t',
	['NONE']    = '|c%s%s|r'
}

local function SetName(self)
		if not UnitExists(self.unit) then
			return
		end
		if not self.unitname then
			 self.unitname = self:CreateFontString(nil, 'OVERLAY')
			 self.unitname:SetFont(STANDARD_TEXT_FONT, 8, 'THINOUTLINE')
			 self.unitname:SetPoint('LEFT', self.icon, 'RIGHT')
		end
		local colorStr = '00000000'
		local _, class = UnitClass(self.unit)
		if class then colorStr = RAID_CLASS_COLORS[class].colorStr end
		self.unitname:SetFormattedText(ROLE[UnitGroupRolesAssigned(self.unit)], colorStr, UnitName(self.unit))
end

local FRAME = 'WorldMap%s%d'
local function CheckName()
	for i = 1, 4 do
		SetName(_G[FRAME:format('Party', i)])
	end
	for i = 1, 40 do
		SetName(_G[FRAME:format('Raid', i)])
	end
end
hooksecurefunc('WorldMapFrame_UpdateUnits', CheckName)