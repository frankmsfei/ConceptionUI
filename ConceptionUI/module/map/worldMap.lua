local UnitClass, UnitName, UnitGroupRolesAssigned, RAID_CLASS_COLORS = UnitClass, UnitName, UnitGroupRolesAssigned, RAID_CLASS_COLORS

local PATTERN = {['DAMAGER'] = '<|c%s%s|r>', ['HEALER'] = '(|c%s%s|r)', ['TANK'] = '[|c%s%s|r]', ['NONE'] = '|c%s%s|r'}

local function SetName()
	for i = 1, MAX_RAID_MEMBERS do
		local frame = _G["WorldMapRaid"..i]
		local unit = frame.unit
		if UnitExists(unit) then
			if not frame.unitname then
				 frame.unitname = frame:CreateFontString(nil, 'OVERLAY')
				 frame.unitname:SetFont(STANDARD_TEXT_FONT, 8, 'THINOUTLINE')
				 frame.unitname:SetPoint('LEFT', frame.icon, 'RIGHT')
			end

			local colorStr = '00000000'
			local _, class = UnitClass(unit)
			if class then colorStr = RAID_CLASS_COLORS[class].colorStr end
			local role = UnitGroupRolesAssigned('unit')
			frame.unitname:SetFormattedText(PATTERN[role], colorStr, UnitName(unit))
		end
	end
end
hooksecurefunc("WorldMapFrame_UpdateUnits", SetName)


--local UnitAffectingCombat, UnitIsDeadOrGhost, PlayerIsPVPInactive = UnitAffectingCombat, UnitIsDeadOrGhost, PlayerIsPVPInactive

function WorldMapUnit_Update() end