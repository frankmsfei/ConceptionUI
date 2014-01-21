local Memory = LibStub('LibDataBroker-1.1'):NewDataObject('Memory')
local UpdateAddOnMemoryUsage, GetAddOnMemoryUsage = UpdateAddOnMemoryUsage, GetAddOnMemoryUsage
local AWP, N = _G['!AWP'], GetNumAddOns()

local function Colored(n)
	if n > 1024 then
		return '9E00', n/1024, 'M'
	elseif n > 500 then
		return '9E9E', n, 'K'
	elseif n > 50 then
		return '009E', n, 'K'
	else
		return '0061', n, 'K'
	end
end

local function FormatMemory(mem)
	return ('|cFF%s00%.2f|cFF616161%sB|r'):format(Colored(mem))
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
	tip:AddDoubleLine('玩家插件', Memory.text, .38, .38, .38)
	tip:AddDoubleLine('暴雪插件', FormatMemory(gc-total), .38, .38, .38)
	tip:AddDoubleLine('總計', FormatMemory(gc), .62, .62, .62)
	tip:AddLine(' ')
	tip:AddDoubleLine('刷新', '[L]', .38, .38, .38, .62, .38, 0)
	tip:AddDoubleLine('回收記憶體', '[R]', .38, .38, .38, 0, .38, .62)
	if AWP then
		tip:AddDoubleLine('插件管理', '[M]', .38, .38, .38, .19, .62, .19)
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