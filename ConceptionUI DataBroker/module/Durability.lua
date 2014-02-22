local Durability = LibStub("LibDataBroker-1.1"):NewDataObject("Durability", {type = 'data source'})
	DurabilityFrame:UnregisterAllEvents()
	DurabilityFrame:Hide()

local function GradientColor(percent)
	return percent <= 50 and 157.59 or 1.5759 * (100 - percent), percent >= 50 and 157.59 or 1.5759 * percent, 0, percent
end

local function UpdateDurability()
	local dur, total_cur, total_max, dangerous = 0, 0, 0, nil
	for i = 1, 19 do
		local cur, max = GetInventoryItemDurability(i)
		if cur then
			total_cur = total_cur + cur
			total_max = total_max + max
		end
		if GetInventoryAlertStatus(i) > 0 then
			dangerous = true
		end
	end
	if total_max == 0 then
		dur = 100
	elseif total_cur ~= 0 then
		dur = 100*total_cur/total_max
	end
	if not dangerous then
		dur = ('|cFF%02X%02X%02X%.1f|cFF616161%%|r'):format(GradientColor(dur))
	else
		dur = ('|cFF9E0000%.1f|cFF616161%%|r'):format(dur)
	end
	Durability.text = dur
end

local HiddenTip = CreateFrame('GameTooltip')
	HiddenTip['UPDATE_INVENTORY_DURABILITY'] = UpdateDurability
	HiddenTip:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
	HiddenTip:RegisterEvent('PLAYER_DEAD')
	HiddenTip:SetScript('OnEvent', function(self, event) self[event](self, event) end)
	HiddenTip:Hide()

	function HiddenTip:PLAYER_DEAD()
		UpdateDurability()
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	end

	function HiddenTip:PLAYER_REGEN_ENABLED(event)
		UpdateDurability()
		self:UnregisterEvent(event)
	end

local function tomoney(amount)
	local g = floor(amount / 10000)
	local s = floor((amount - (10000 * g)) / 100)
	local c = mod(amount, 100)
	return ('|cFF9E9E00%i|cFF616100g |cFF9E9E9E%i|cFF616161s |cFF9E6100%i|cFF613100c|r'):format(g, s, c)
end

	Durability.OnTooltipShow = function(Tip)
		Tip:AddDoubleLine('Durability', Durability.text, 1, 1, 1)
		Tip:AddLine(' ')
		local total_cost = 0
		for i = 1, 19 do
			local cur, max = GetInventoryItemDurability(i)
			if cur then
				Tip:AddDoubleLine(('|T%s:12:12:0:-1:48:48:5:44:5:44|t %s'):format(GetInventoryItemTexture('player', i), GetInventoryItemLink('player', i)), ('%d|cFF616161%%|r'):format(100*cur/max), 1, 1, 1, .62, .62, .62)
				local _, _, repair_cost = HiddenTip:SetInventoryItem('player', i)
				total_cost = total_cost + repair_cost
			end
			
		end
		Tip:AddLine(' ')
		Tip:AddDoubleLine('當前裝備', tomoney(total_cost), .62, .62, .62)
		for bag = 0, 4 do
			for slot = 1, GetContainerNumSlots(bag) do
				local _, repair_cost = HiddenTip:SetBagItem(bag, slot)
				if repair_cost and repair_cost > 0 then
					total_cost = total_cost + repair_cost
				end
			end
		end
		Tip:AddDoubleLine('總計', tomoney(total_cost), .62, .62, .62)
	end

DurabilityFrame:UnregisterAllEvents()
DurabilityFrame:Hide()
DurabilityFrame.Show = function()end