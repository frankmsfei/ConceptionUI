local NetStats = LibStub('LibDataBroker-1.1'):NewDataObject('NetStats', {type = 'data source'})
local GetNetStats, select = GetNetStats, select

local function Colored(n)
	if n < 21 then
		return '|cFF009E00', n -- green
	elseif n < 51 then
		return '|cFF9E9E00', n -- yellow
	else
		return '|cFF9E0000', n -- red
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

function NetStats.OnTooltipShow(tip)
	tip:ClearLines()
	local down, up, realm, world = GetNetStats()
	tip:AddDoubleLine('Net Stats', NetStats.text, 1, 1, 1)
	tip:AddLine(' ')
	tip:AddLine('頻寬', .62, .62, 0)
	tip:AddDoubleLine('背景下載', ('|cFF9E9E9E%s|r%%'):format(GetCVar('bgLoadThrottle')), .38, .38, .38, .38, .38, .38)
	tip:AddDoubleLine('下載', ('%s%.1f|cFF616161KB/s|r'):format(Colored(down)), .38, .38, .38)
	tip:AddDoubleLine('上傳', ('%s%.1f|cFF616161KB/s'):format(Colored(up)), .38, .38, .38)
	tip:AddLine(' ')
	tip:AddLine('延遲', .62, .62, 0)
	tip:AddDoubleLine('本地', ('%s%s|cFF616161ms|r'):format(Colored(realm)), .38, .38, .38)
	tip:AddDoubleLine('世界', ('%s%s|cFF616161ms|r'):format(Colored(world)), .38, .38, .38)
	tip:AddLine(' ')

	local lagTolerance = GetCVarBool('reducedLagTolerance')
	tip:AddDoubleLine('自定延遲容許值', lagTolerance and '|cFF009E00ON|r' or '|cFF9E0000OFF', .62, .62, 0)
	tip:AddDoubleLine('延遲容許值', ('|cFF%s%s|rms'):format(lagTolerance and '9E9E9E' or '616161', GetCVar('maxSpellStartRecoveryoffset')), .38, .38, .38, .38, .38, .38)
	tip:AddLine(' ')

	tip:AddDoubleLine('設定目前延遲為容許值', '[L]', .38, .38, .38, .62, .38, 0)
	tip:AddDoubleLine('切換自定延遲容許值', '[R]', .38, .38, .38, 0, .38, .62)
end

function NetStats.OnClick(_, button)
	if button == 'LeftButton' then
		SetCVar('maxSpellStartRecoveryoffset', select(3, GetNetStats()))
	elseif button == 'RightButton' then
		SetCVar('reducedLagTolerance', 1 - GetCVar('reducedLagTolerance'))
	end
	NetStats.OnTooltipShow(GameTooltip)
end