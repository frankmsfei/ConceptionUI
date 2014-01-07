local Memory = LibStub('LibDataBroker-1.1'):NewDataObject('Memory')
local UpdateAddOnMemoryUsage, GetAddOnMemoryUsage = UpdateAddOnMemoryUsage, GetAddOnMemoryUsage
local AWP, N = _G['!AWP'], GetNumAddOns()

local function Colored(n)
	if n > 999 then
		n = n/1024
		if n > 24 then
			return '9E0000', n, 'M'
		elseif n > 10 then
			return '610000', n, 'M'
		elseif n > 5 then
			return '9E9E00', n, 'M'
		else
			return '616100', n, 'M'
		end
	else
		if n > 100 then
			return '009E00', n, 'K'
		else
			return '006100', n, 'K'
		end
	end
end

local function FormatMemory(mem)
	return ('|cFF%s%.2f|cFF616161%sB|r'):format(Colored(mem))
end

local function UpdateMemoryUsage()
	UpdateAddOnMemoryUsage()
	local total = 0
	for i = 1, N do
		total = total + GetAddOnMemoryUsage(i)
	end
	Memory.text = FormatMemory(total)
end
Timer:Set('Memory', 10, UpdateAddOnMemoryUsage)
Timer:OnLogin(UpdateMemoryUsage)

local function sort_method(a, b)
	return a.memory > b.memory
end

local mem = {}
function Memory.OnTooltipShow(tip)
	local total, gc = 0, gcinfo()
	for i = 1, N do
		local memusage = GetAddOnMemoryUsage(i)
		if memusage > 0 then
			total = total + memusage
			tinsert(mem, {addon = i, memory = memusage})
		end
	end
	Memory.text = FormatMemory(total)
	tip:ClearLines()
	tip:AddDoubleLine('Memory Usage', Memory.text, 1, 1, 1)
	tip:AddLine(' ')
	sort(mem, sort_method)
	for k, v in ipairs(mem) do
		tip:AddDoubleLine(select(2, GetAddOnInfo(v.addon)), FormatMemory(v.memory), .62, .62, 0)
	end
	wipe(mem)
	tip:AddLine(' ')
	tip:AddDoubleLine('User', Memory.text, .38, .38, .38)
	tip:AddDoubleLine('Blizzard', FormatMemory(gc-total), .38, .38, .38)
	tip:AddDoubleLine('Total', FormatMemory(gc), .62, .62, .62)

	tip:AddDoubleLine('\nRefresh', '\n[L]', .38, .38, .38, .62, .38, 0)
	tip:AddDoubleLine('Garbage Collect', '[R]', .38, .38, .38, 0, .38, .62)
	if AWP then
		tip:AddDoubleLine('AddOn Work Permission', '[M]', .38, .38, .38, .19, .62, .19)
	end
end

function Memory.OnClick(self, button)
	if button == 'LeftButton' then
		UpdateAddOnMemoryUsage()
		Memory.OnTooltipShow(GameTooltip)
		return
	elseif button == 'RightButton' then
		local gc = gcinfo()
		collectgarbage('collect')
		UpdateMemoryUsage()
		Memory.OnTooltipShow(GameTooltip)
		print(FormatMemory(gc - gcinfo()),  '|cFF616161 collocted!|r')
		return
	elseif button == 'MiddleButton' then
		if AWP then
			AWP:SetShown(not AWP:IsShown())
			return
		end
	end
end