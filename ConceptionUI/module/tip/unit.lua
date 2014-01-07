local COLOR = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
local function ClassColor(unit)
	local _, class = UnitClass(unit)
	if class then
		return COLOR[class].colorStr
	else
		return 'ffffffff'
	end
end

local UnitGUID = UnitGUID
local function UnitTarget(unit)
	if UnitGUID(unit)==UnitGUID('player') then
		return ' @|cFFFF0000'..UnitName('player')..'|r'
	else
		return ' @|c'..ClassColor(unit)..UnitName(unit)..'|r'
	end
end

local REALM =  GetRealmName()
local ICON_LIST = ICON_LIST
local function DetectUnit(self)
	local _, unit = self:GetUnit()
	if unit then
		local player = UnitIsPlayer(unit)
		if player then
			local name, realm = UnitName(unit)
			local title = UnitPVPName(unit) or ''
			if title then
				title = title:gsub(name, '')
			end
			GameTooltipTextLeft1:SetFormattedText('|cFF9E9E9E%s|c%s%s|r', title, ClassColor(unit), name)

			local g, d, r = GetGuildInfo(unit)
			if d then
				GameTooltipTextLeft2:SetTextColor(.9, .8, .6)
				GameTooltipTextLeft2:SetFormattedText('<%s>|r|cFF9E9E9E %s |r(%s)', g, d, 1+r)
			end

			local status = (UnitIsAFK(unit) and '|cFF9E6100 [AFK]|r') or (UnitIsDND(unit) and '|cFF9E0000 [DND]|r') or (not UnitIsConnected(unit) and '|cFF616161 [DC]|r')
			if status then
				self:AppendText(status)
			end

			local faction, Lfaction = UnitFactionGroup(unit)
			if faction then
				faction = 'Alliance' and '3333FF' or 'Horde' and 'FF3333'
				for i = 3, self:NumLines() do
					local line = _G['GameTooltipTextLeft'..i]
					local text = line:GetText() or ''
					if text:find('^'..Lfaction..'$') then
						line:SetFormattedText('|cFF%s%s - %s|r', faction, realm or REALM, Lfaction)
						break				
					end
				end
			else
				self:AddLine(realm or REALM)
			end
		end

		if UnitExists(unit..'target') then
			self:AppendText(UnitTarget(unit..'target'))
		end

		local raidicon = GetRaidTargetIndex(unit)
		if raidicon then
			GameTooltipTextLeft1:SetFormattedText('%s:0|t  %s', ICON_LIST[raidicon], GameTooltipTextLeft1:GetText())
		end
	end
end
GameTooltip:HookScript('OnTooltipSetUnit', DetectUnit)