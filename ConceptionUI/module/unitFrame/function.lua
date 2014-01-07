local C = unpack(select(2, ...))
	C.FUNC.UNIT = {}
local FUNC, xp = C.FUNC.UNIT, false

local UnitHealth, UnitHealthMax, UnitPower, UnitPowerMax, UnitIsDeadOrGhost = UnitHealth, UnitHealthMax, UnitPower, UnitPowerMax, UnitIsDeadOrGhost
local function OnHpChanged(frame, unit)
	if xp and unit == 'player' then return end
	local HP, curHp, maxHp = 0, 0, UnitHealthMax(unit)
	if not(maxHp == 0 or UnitIsDeadOrGhost(unit)) then
		curHp = UnitHealth(unit)
		HP = 100*curHp/maxHp
	end
	frame.hpBar:SetValue(HP)
	if not frame.hpInfo then return end
	frame.hpInfo:SetText(curHp)
end
FUNC.OnHpChanged = OnHpChanged

local function OnPpChanged(frame, unit)
	if xp and unit=='player' then return end
	local PP, curPp, maxPp = 0, 0, UnitPowerMax(unit)
	if not(maxPp == 0 or UnitIsDeadOrGhost(unit)) then
		curPp = UnitPower(unit)
		PP = 100*curPp/maxPp
	end
	frame.ppBar:SetValue(PP)
	if not frame.ppInfo then return end
	frame.ppInfo:SetText(curPp)
end
FUNC.OnPpChanged = OnPpChanged

local function hpBar_OnValueChanged(bar)
	local value = bar:GetValue()
	if value == 100 then
		bar.hp:SetText(nil)
		bar:SetStatusBarColor(1,1,1)
		return
	elseif value == 0 then
		bar.hp:SetText('|cFFFF0000DEAD|r')
		bar:SetStatusBarColor(0,0,0)
		return
	else
		bar.hp:SetFormattedText('%.1f', value)
		if value > 50 then
			bar:SetStatusBarColor(1,1,1)
			bar.hp:SetTextColor(1,1,1)
			return
		elseif value > 20 then
			bar:SetStatusBarColor(1,1,0)
			bar.hp:SetTextColor(1,1,0)
			return
		else
			bar:SetStatusBarColor(1,0,0)
			bar.hp:SetTextColor(1,0,0)
			return
		end
	end
end
FUNC.hpBar_OnValueChanged = hpBar_OnValueChanged

local function ppBar_OnValueChanged(bar)
	local value = bar:GetValue()
	if value == 100 then
	--	bar.icon:Hide()
	--	bar.pp:SetText()
		bar:SetStatusBarColor(1,1,1)
		return
	elseif value == 0 then
	--	bar.icon:Hide()
	--	bar.pp:SetText()
		bar:SetStatusBarColor(0,0,0)
		return
	else
	--	local pos = 0.01 * value * bar:GetWidth()
	--	if bar:GetReverseFill() == 1 then
	--		bar.icon:SetPoint('TOPLEFT', bar, 'BOTTOMRIGHT', -pos, -3)
	--	else
	--		bar.icon:SetPoint('TOPRIGHT', bar, 'BOTTOMLEFT', pos, -3)
	--	end
	--	bar.icon:Show()
	--	bar.pp:SetFormattedText('%.1f', value)
		if value > 50 then
			bar:SetStatusBarColor(1,1,1)
	--		bar.icon:SetVertexColor(1,1,1)
	--		bar.pp:SetTextColor(1,1,1)
			return
		elseif value > 20 then
			bar:SetStatusBarColor(1,1,0)
	--		bar.icon:SetVertexColor(1,1,0)
	--		bar.pp:SetTextColor(1,1,0)
			return
		else
			bar:SetStatusBarColor(1,0,0)
	--		bar.icon:SetVertexColor(1,0,0)
	--		bar.pp:SetTextColor(1,0,0)
			return
		end
	end
end
FUNC.ppBar_OnValueChanged = ppBar_OnValueChanged

local function Hex(color)
	if not color then
		return '|cFFFFFFFF'
	else
		return ('|cFF%02x%02x%02x'):format(255*color.r, 255*color.g, 255*color.b)
	end
end

local COLOR = RAID_CLASS_COLORS
local UnitClass, UnitName = UnitClass, UnitName
local function ColoredName(unit)
	local name = UnitName(unit)
	if not name then
		return unit or '|cFFCCCCCC????|r'
	end
	local _, class = UnitClass(unit)
	if class then
		return ('|c%s%s|r'):format(COLOR[class].colorStr, name)
	else
		return name
	end

end
FUNC.ColoredName = ColoredName

local GetRaidTargetIndex = GetRaidTargetIndex
local function GetRaidIcon(unit)
	local index = GetRaidTargetIndex(unit)
	if index then
		return ('|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:0|t'):format(index)
	else
		return ''
	end
end

local UnitExists, UnitIsAFK, UnitIsDND, UnitIsConnected = UnitExists, UnitIsAFK, UnitIsDND, UnitIsConnected
local function NameCheck(frame, unit)
	if not UnitExists(unit) then return end
	if not frame.target then
		local status = (UnitIsAFK(unit) and '|cFF9E6100AFK|r') or (UnitIsDND(unit) and '|cFF9E0000DND|r') or (not UnitIsConnected(unit) and '|cFF616161DC|r') or ''
		if unit == 'player' then
			frame.name:SetFormattedText('%s%s %s', GetRaidIcon(unit), ColoredName(unit), status)
			return
		else
			frame.name:SetFormattedText('%s %s%s', status, ColoredName(unit), GetRaidIcon(unit))
			return
		end
	else
		if unit == 'targettarget' then
			frame.name:SetFormattedText('%s%s', ColoredName(unit), GetRaidIcon(unit))
			local unitTarget = ('%starget'):format(unit)
			if not UnitExists(unitTarget) then
				frame.target:SetText()
				return
			else
				frame.target:SetFormattedText(' >  %s%s', ColoredName(unitTarget), GetRaidIcon(unitTarget))
				return
			end
		else
			frame.name:SetFormattedText('%s%s', GetRaidIcon(unit), ColoredName(unit))
			local unitTarget = ('%starget'):format(unit)
			if not UnitExists(unitTarget) then
				frame.target:SetText()
				return
			else
				frame.target:SetFormattedText('%s%s  < ', GetRaidIcon(unitTarget), ColoredName(unitTarget))
				return
			end
		end
	end
end
FUNC.NameCheck = NameCheck

function FUNC.OnShow(frame)
	local unit = frame:GetAttribute('unit')
	NameCheck(frame, unit)
	OnHpChanged(frame, unit)
	OnPpChanged(frame, unit)
	hpBar_OnValueChanged(frame.hpBar)
	ppBar_OnValueChanged(frame.ppBar)
	frame.hpBar:SetScript('OnValueChanged', hpBar_OnValueChanged)
	frame.ppBar:SetScript('OnValueChanged', ppBar_OnValueChanged)
end

function FUNC.OnHide(frame)
	frame.name:SetText(nil)
	frame.hpBar.hp:SetText(nil)
	frame.ppBar.pp:SetText(nil)
	frame.hpBar:SetValue(0)
	frame.ppBar:SetValue(0)
	frame.hpBar:SetScript('OnValueChanged', nil)
	frame.ppBar:SetScript('OnValueChanged', nil)
	if frame.taregt then frame.target:SetText(nil) end
	if frame.hpInfo then frame.hpInfo:SetText(nil) end
	if frame.ppInfo then frame.ppInfo:SetText(nil) end
end

local Tip = GameTooltip
local UnitAffectingCombat = UnitAffectingCombat
function FUNC.OnEnter(frame)
	frame:SetBackdropColor(0,0,0,.382)
	frame.arrow:Show()
	if UnitAffectingCombat('player') then return end
	local unit = frame:GetAttribute('unit')
	Tip:SetOwner(frame, 'ANCHOR_NONE')
	if frame.hpBar:GetReverseFill()==1 then
		Tip:SetPoint('TOPRIGHT', frame, 'BOTTOMRIGHT', 2, -4)
	else
		Tip:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', -2, -4)
	end
	Tip:ClearLines()
	Tip:SetUnit(unit)
	Tip:Show()
end

function FUNC.OnLeave(frame)
	xp = false
	frame:SetBackdropColor(0,0,0,0)
	frame.arrow:Hide()
	Tip:Hide()
end

local GetWatchedFactionInfo = GetWatchedFactionInfo
local factionStanding = 'FACTION_STANDING_LABEL%d'
local FACTION_BAR_COLORS = FACTION_BAR_COLORS
function FUNC.XP(self)
	if UnitAffectingCombat('player') then return end
	local factionName, standingID, minREP, maxREP, curREP = GetWatchedFactionInfo()
	if factionName then
		xp = true
		local cur, max = curREP - minREP, maxREP - minREP
		self.name:SetFormattedText('%s %s%s|r', factionName, Hex(FACTION_BAR_COLORS[standingID]), _G[factionStanding:format(standingID)])
		self.hpInfo:SetText(max)
		self.ppInfo:SetText(cur)
		self.hpBar:SetValue(.001+100*cur/max)
		self.ppBar:SetValue(100*cur/max)
		return
	else
		if UnitLevel('player')==MAX_PLAYER_LEVEL then
			return
		else
			xp = true
			local cur, max, rest = UnitXP('player'), UnitXPMax('player'), GetXPExhaustion('player') or 0
			self.hpInfo:SetText(max)
			self.ppInfo:SetText(cur)
			self.hpBar:SetValue(.001+100*cur/max)
			self.ppBar:SetValue(100*rest/max)
			self.ppBar:SetStatusBarColor(0,0,1)
			return
		end
	end
end