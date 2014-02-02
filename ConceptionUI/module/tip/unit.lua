local UnitGUID = UnitGUID
local UnitExists = UnitExists
local UnitName = UnitName
local UnitPVPName = UnitPVPName
local UnitLevel = UnitLevel
local UnitClassBase = UnitClassBase
local UnitRace = UnitRace
local UnitSex = UnitSex
local UnitReaction = UnitReaction
local UnitFactionGroup = UnitFactionGroup
local UnitClassification = UnitClassification
local UnitCreatureType, UnitCreatureFamily = UnitCreatureType, UnitCreatureFamily
local UnitIsPlayer, UnitIsBattlePet = UnitIsPlayer, UnitIsBattlePet
local UnitIsDeadOrGhost, UnitIsAFK, UnitIsDND, UnitIsConnected = UnitIsDeadOrGhost, UnitIsAFK, UnitIsDND, UnitIsConnected
local GetGuildInfo = GetGuildInfo
local GetRaidTargetIndex = GetRaidTargetIndex
local IsAltKeyDown = IsAltKeyDown -- debug
local NotifyInspect = NotifyInspect -- inspect
local GameTooltipText, GameTooltipHeaderText = GameTooltipText, GameTooltipHeaderText
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local FACTION_BAR_COLORS = FACTION_BAR_COLORS
local ICON_LIST = ICON_LIST
local LEVEL = LEVEL
local PVP = PVP
local UNIT = ConceptionCORE.UNIT
local PLAYER_NAME = UnitName('player')
local REALM =  GetRealmName()

local CACHE = setmetatable({},{
	__call = function(self, value)
		tinsert(self, value)
	end,
	__mode = 'kv'
})

local function HexColor(colorTable)
	return ('|cFF%02x%02x%02x'):format(255*colorTable.r, 255*colorTable.g, 255*colorTable.b)
end

local function GetClass(unit)
	if not unit then return end
	local Lclass, class = UnitClassBase(unit)
	if class then
		return RAID_CLASS_COLORS[class].colorStr, Lclass
	else
		return 'FF9E9E9E', '??'
	end
end

local function UnitIcon(unit)
	local index = GetRaidTargetIndex(unit)
	if not index then
		return ''
	else
		return ('%s:0|t'):format(ICON_LIST[index])
	end
end

local function SetTitleText(tip, title)
	if title then
		tip.TextLeft1:SetFontObject(GameTooltipText)
		tip.TextRight1:SetFontObject(GameTooltipText)
		tip.TextLeft2:SetFontObject(GameTooltipHeaderText)
		tip.TextRight2:SetFontObject(GameTooltipHeaderText)
	else
		tip.TextLeft1:SetFontObject(GameTooltipHeaderText)
		tip.TextRight1:SetFontObject(GameTooltipHeaderText)
		tip.TextLeft2:SetFontObject(GameTooltipText)
		tip.TextRight2:SetFontObject(GameTooltipText)
	end
end

local function UnitTarget(unit)
	if UNIT(UnitGUID(unit))=='player' then
		return ('|cFFFF0000%s|r'):format(PLAYER_NAME)
	else
		return ('|c%s%s|r'):format(GetClass(unit), UnitName(unit))
	end
end

local function SetUnit(tip)
	if IsAltKeyDown() then return end
	local name, unit = tip:GetUnit()
	if not unit then return end
	local class_color, class = GetClass(unit)
	local level = UnitLevel(unit)
	local sex = UnitSex(unit)
	local dead = UnitIsDeadOrGhost(unit)
	local location = nil
	if tip.TextLeft3:GetText() and not tip.TextLeft3:GetText():find(LEVEL) and not tip.TextLeft3:GetText():find(PVP) then
		location = tip.TextLeft3:GetText()
	end
	if tip.TextLeft4:GetText() and not tip.TextLeft4:GetText():find(LEVEL) and not tip.TextLeft4:GetText():find(PVP) then
		location = tip.TextLeft4:GetText()
	end
	if UnitIsPlayer(unit) then
		tip:ClearLines()
		local _, realm = UnitName(unit)
		if not realm or realm == '' then realm = REALM end
		local title = (UnitPVPName(unit) or ''):gsub(name, '')
		if title ~= '' then
			tip:AddLine(('|cFF9E9E9E%s|r'):format(title))
			SetTitleText(tip, true)
		end
		local status = dead and ' |cFF616161[DEAD]' or UnitIsAFK(unit) and ' |cFF9E6100[AFK]' or UnitIsDND(unit) and ' |cFF9E0000[DND]' or  UnitIsConnected(unit) and '' or ' |cFF616161[DC]'
		tip:AddDoubleLine(('%s|c%s%s%s|r'):format(UnitIcon(unit), class_color, name, status), ' ')
		if not InspectFrame:IsShown() and CanInspect(unit) then
			NotifyInspect(unit)
			tip:RegisterEvent('INSPECT_READY')
		end
		local guild, title, rank = GetGuildInfo(unit)
		if guild then
			tip:AddDoubleLine(('|cFF9E9E00<%s>|r'):format(guild), ('|cFF9E9E9E%s|cFF616161(%s)|r'):format(title, rank))
		end
		tip:AddDoubleLine( ('|cFF9E9E9E%s |c%s%s|r'):format(level or '??', class_color, class), ('|cFF9E9E9E%s%s|r'):format(UnitRace(unit) or '', sex == 2 and'♂' or sex == 3 and '♀' or ''), GetQuestDifficultyColor(level) )
		local faction, Lfaction = UnitFactionGroup(unit)
		if faction then
			tip:AddDoubleLine(('|cFF%s%s|r'):format(faction == 'Alliance' and '00619E' or faction == 'Horde' and '9E0000' or '009E00', Lfaction), ('|cFF9E9E9E%s|r'):format(realm))
		end
		if location and Lfaction and not location:match(Lfaction) then
			tip:AddLine(('|cFF9E9E00%s|r'):format(location))
		end
	else
		local discription = tip.TextLeft2:GetText()
		if not discription or discription:find(LEVEL) then
			discription = nil
		end
		if UnitIsBattlePet(unit) then
			name = tip.TextLeft1:GetText()
			level = UnitBattlePetLevel(unit)
			tip:ClearLines()
			if discription then
				tip:AddLine(('|cFF9E9E9E%s|r'):format(discription))
				SetTitleText(tip, true)
			end
			tip:AddDoubleLine(('%s%s%s'):format(UnitIcon(unit), name, dead and ' |cFF616161[DEAD]|r' or ''), _G['BATTLE_PET_DAMAGE_NAME_'..UnitBattlePetType(unit)])
			tip:AddDoubleLine( ('|cFF9E9E9E%s |c%s%s|r'):format(level or '??', class_color, class), ('|cFF9E9E9E%s%s%s|r'):format(UnitCreatureType(unit) or '', UnitCreatureFamily(unit) or '', sex == 2 and'♂' or sex == 3 and '♀' or ''))
		else
			for i = 4, tip:NumLines() do
				local text = _G['GameTooltipTextLeft'..i]:GetText()	
				if text:find('%d+/%d+') then
					CACHE(text)
				end
			end
			tip:ClearLines()
			if discription then
				tip:AddLine(('|cFF9E9E9E%s|r'):format(discription))
				SetTitleText(tip, true)
			end
			local classification =  UnitClassification(unit):find('rare') and '稀有'
			tip:AddDoubleLine(('%s%s%s%s|r'):format(UnitIcon(unit), HexColor(FACTION_BAR_COLORS[UnitReaction(unit, 'player')]), name, dead and ' |cFF616161[DEAD]' or ''), classification)
			if level == -1 then
				level = '|cFF9E0000BOSS'
			end
			tip:AddDoubleLine( ('|cFF9E9E9E%s |c%s%s|r'):format(level or '??', class_color, class), ('|cFF9E9E9E%s%s%s|r'):format(UnitCreatureType(unit) or '', UnitCreatureFamily(unit) or '', sex == 2 and'♂' or sex == 3 and '♀' or ''))

			if #CACHE > 0 then
				tip:AddLine(' ')
				for key, text in pairs(CACHE) do
					local name, progress, count = text:match('^ ([^ ]-) ?%- (.+)%p%s-(%d+/%d+)$') --local playerName, progress = strmatch(text, '^ ([^ ]-) ?%- (.+)$')
					name = name == '' and PLAYER_NAME or name
					local color = GetClass(name)
					tip:AddDoubleLine(progress, ('|c%s%s|r - %s'):format(color, name, count or ''), .62, .62, .62, .62, .62, .62)
				end
				wipe(CACHE)
			end
		end
	end

	if UnitExists(unit..'target') then
		tip:AddLine(' ')
		tip:AddLine(('@%s'):format(UnitTarget(unit..'target')))
	end
end
GameTooltip:HookScript('OnTooltipSetUnit', SetUnit)
GameTooltip:HookScript('OnHide', SetTitleText)