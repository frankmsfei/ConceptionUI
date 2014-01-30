local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetInspectSpecialization = GetInspectSpecialization
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo

local ROLE_COLOR = {
	['DAMAGER'] = '9E0000',
	['HEALER'] = '009E00',
	['TANK'] = '00619E',
}

local function SetUnitSpec(tip)
	local name = UnitName('mouseover')
	local _, spec, _, _, _, role = GetSpecializationInfoByID(GetInspectSpecialization('mouseover'))
	if not spec then
		return
	else
		for i = 1, 2 do
			local linetext = tip['TextLeft'..i]:GetText()
			if linetext then
				if linetext:find(name) then
					tip['TextRight'..i]:SetFormattedText('|cFF%s%s|r', ROLE_COLOR[role], spec)
				end
			end
		end
	end
end

local levelAdjust={
	['0']=0,['1']=8,
	['373']=4,['374']=8,
	['375']=4,['376']=4,['377']=4,['379']=4,['380']=4,
	['445']=0,['446']=4,['447']=8,
	['451']=0,['452']=8,
	['453']=0,['454']=4,['455']=8,
	['456']=0,['466']=4,['457']=8,
	['458']=0,['459']=4,['460']=8,['461']=12,['462']=16,
	['465']=0,['467']=8,
	['468']=0,['470']=8,['471']=12,['472']=16,
	['476']=0,['479']=0,
	['491']=0,['492']=4,['493']=8,
	['494']=0,['495']=4,['496']=8,['497']=12,['498']=16
}

local function GetActualItemLevel(link, baseLevel)
	local upgrade = link:match(':(%d+)\124h%[')
	if not upgrade then return baseLevel end
	if not levelAdjust[upgrade] then print(link, upgrade, 'NOT IN UPGRADE DATABASE!!') end
	return baseLevel + (levelAdjust[upgrade] or 0)
end

local slot = {'Head','Neck','Shoulder','Shirt','Chest','Waist','Legs','Feet','Wrist','Hands','Finger0','Finger1','Trinket0','Trinket1','Back','MainHand','SecondaryHand','Tabard'}

local function SetUnitILV(tip)
	local total, count = 0, 0
	for slot, slotName in pairs(slot) do
		local itemLink = GetInventoryItemLink('mouseover', slot)
		if itemLink then
			local _, _, itemQuality, baseLevel = GetItemInfo(itemLink)
			local itemLevel = GetActualItemLevel(itemLink, baseLevel)
			if slotName ~= 'Shirt' and slotName ~= 'Tabard' then
				total = itemLevel + total
				count = count + 1
			end
		end
	end
	tip:AddLine(' ')
	tip:AddDoubleLine(('ilv: %.2f'):format(total/count), ('%d件'):format(count))
	tip:Show()
end

local function OnEvent(tip, event, guid)
	if event ~= 'INSPECT_READY' then return end
	if tip:IsShown() then
		SetUnitSpec(tip)
		SetUnitILV(tip)
	end
	tip:UnregisterEvent(event)
end
GameTooltip:HookScript('OnEvent', OnEvent)