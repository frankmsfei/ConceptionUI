local NetStats = LibStub('LibDataBroker-1.1'):NewDataObject('NetStats', {type = 'data source'})
local GetNetStats, select = GetNetStats, select

local function Colored(n)
	if n < 21 then
		return '|cFF006100', n -- green
	elseif n < 51 then
		return '|cFF616100', n -- yellow
	else
		return '|cFF610000', n -- red
	end
end

local ping_cache = 0
local function UpdateLatency()
	local _, _, ping = GetNetStats()
	if ping == ping_cache then return end
	ping_cache = ping
	SetCVar('maxSpellStartRecoveryoffset', ping_cache)
	NetStats.text = ('%s%s|cFF616161MS|r'):format(Colored(ping_cache))
end

Timer:Set('NetStats', 1, UpdateLatency)
--Timer:OnLogin(UpdateLatency)

function NetStats.OnTooltipShow(tip)
	local down, up, realm, world = GetNetStats()

	tip:ClearLines()

	tip:AddDoubleLine('Net Stats', realm, 1, 1, 1)
	tip:AddLine('\nBandwidth', .62, .62, 0)
	tip:AddDoubleLine('Background Download', ('|cFF9E9E9E%s|r%%'):format(GetCVar('bgLoadThrottle')), .38, .38, .38, .38, .38, .38)
	tip:AddDoubleLine('Download', ('%s%.1f|cFF616161KB/s|r'):format(Colored(down)), .38, .38, .38)
	tip:AddDoubleLine('Upload', ('%s%.1f|cFF616161KB/s'):format(Colored(up)), .38, .38, .38)

	tip:AddLine('\nLatency', .62, .62, 0)
	tip:AddDoubleLine('Local', ('%s%s|cFF616161ms|r'):format(Colored(realm)), .38, .38, .38)
	tip:AddDoubleLine('World', ('%s%s|cFF616161ms|r'):format(Colored(world)), .38, .38, .38)

	if GetCVarBool('reducedLagTolerance') then
		tip:AddDoubleLine('\nCustom Lag Tolerance', '\non', .62, .62, 0, 0, .62, 0)
		tip:AddDoubleLine('Lag Tolerance', ('%sms'):format(GetCVar('maxSpellStartRecoveryoffset')), .38, .38, .38, .62, .62, .62)
	else
		tip:AddDoubleLine('\nCustom Lag Tolerance', '\noff', .62, .62, 0, .62, 0, 0)
		tip:AddDoubleLine('Lag Tolerance', ('%sms'):format(GetCVar('maxSpellStartRecoveryoffset')), .38, .38, .38, .38, .38, .38)
	end

	tip:AddDoubleLine('\nSet Lag Tolerance to current latency', '\n[L]', .38, .38, .38, .62, .38, 0)
	tip:AddDoubleLine('Toggle Custom Lag Tolerance', '[R]', .38, .38, .38, 0, .38, .62)
end

function NetStats.OnClick(_, button)
	if button == 'LeftButton' then
		SetCVar('maxSpellStartRecoveryoffset', select(3, GetNetStats()))
	elseif button == 'RightButton' then
		SetCVar('reducedLagTolerance', 1 - GetCVar('reducedLagTolerance'))
	end
	NetStats.OnTooltipShow(GameTooltip)
end
