ITEM_BNETACCOUNTBOUND = '|cffffff00'..ITEM_BNETACCOUNTBOUND..'|r' -- Yellow
ITEM_BIND_ON_EQUIP = '|cff1111ff'..ITEM_BIND_ON_EQUIP..'|r' -- Blue
ITEM_BIND_ON_PICKUP = '|cffff00ff'..ITEM_BIND_ON_PICKUP..'|r' -- Purpke
ITEM_BIND_ON_USE = '|cff00ff00'..ITEM_BIND_ON_USE..'|r' -- Green
ITEM_BIND_QUEST = '|cffffffff'..ITEM_BIND_QUEST..'|r' -- White
ITEM_SOULBOUND = '|cffff0000'..ITEM_SOULBOUND..'|r' -- Red
ITEM_LEVEL = '|cff00ffffILV: %d|r' -- Skyblue
DAMAGE_TEMPLATE = 'DMG: %s - %s'
DPS_TEMPLATE = 'DPS: %s'
ITEM_SOCKETABLE = ''
ITEM_SOCKET_BONUS = '%s'
ITEM_SET_BONUS = 'SET: %s'
ITEM_SET_BONUS_GRAY = 'SET(%d): %s'
--ITEM_CREATED_BY = ""


--local GetMouseFocus, WorldFrame = GetMouseFocus, WorldFrame
local UIParent = UIParent
local function SetAnchor(tip, parent)
	if GetMouseFocus() == WorldFrame then
		--if  parent == UIParent then
			tip:SetOwner(parent, 'ANCHOR_CURSOR_RIGHT', 10, 10)
			return
		else
			tip:SetOwner(parent, 'ANCHOR_NONE')	
			tip:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -96, 96)
	end
	tip.default = 1
end
hooksecurefunc('GameTooltip_SetDefaultAnchor', SetAnchor)


local enable = {
	['achievement'] = true,
	['enchant'] = true,
	['glyph'] = true,
	['item'] = true,
	['quest'] = true,
	['spell'] = true,
	['talent'] = true,
	['unit'] = true,
	['currency'] = true,
	['instancelock'] = true,
	['player'] = false,
	['BNplayer'] = false,
	['battlepet'] = false,
}

local function OnHyperlinkEnter(self, data, link)
	if not enable[data:match('^(.-):.-$')] then return end
	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT')
	GameTooltip:SetHyperlink(link)
	GameTooltip:Show()
end
for i = 1, NUM_CHAT_WINDOWS do
   _G['ChatFrame'..i]:SetScript('OnHyperlinkEnter', OnHyperlinkEnter)
   _G['ChatFrame'..i]:SetScript('OnHyperlinkLeave', GameTooltip_Hide)
end


local function Simple(self, link, index, ...)
	return self.CompareItem(self, link, index)
end

local function hookCompareItems(tip)
	tip.CompareItem = tip.SetHyperlinkCompareItem
	tip.SetHyperlinkCompareItem = Simple
end

hookCompareItems(ShoppingTooltip1)
hookCompareItems(ShoppingTooltip2)
hookCompareItems(ShoppingTooltip3)
hookCompareItems(ItemRefShoppingTooltip1)
hookCompareItems(ItemRefShoppingTooltip2)
hookCompareItems(ItemRefShoppingTooltip3)


tinsert(UISpecialFrames, 'FloatingBattlePetTooltip')
tinsert(UISpecialFrames, 'FloatingPetBattleAbilityTooltip')