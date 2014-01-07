local UnitAura, UnitName = UnitAura, UnitName
local function AddAuraID(self, ...)
	local _,_,_,_,_,_,_,caster,_,_,id = UnitAura(...)
	if not id then return end
	self:AddLine(' ')
	self:AddDoubleLine('spell: '..id, caster and UnitName(caster))
end
hooksecurefunc(GameTooltip, 'SetUnitAura', AddAuraID)
--hooksecurefunc(GameTooltip, 'SetUnitBuff', AddAuraID)
--hooksecurefunc(GameTooltip, 'SetUnitDebuff', AddAuraID)


local function AddSpellID(self)
	local _, _, id = self:GetSpell()
	if not id then return end
	self:AddLine(' ')
	self:AddLine('spell: '..id)
end
GameTooltip:HookScript('OnTooltipSetSpell', AddSpellID)


local function AddItemID(self)
	local _, link = self:GetItem()
	if not link then return end
	local id = link:match('^.-:(%d+).-$')
	self:AddLine(' ')
	self:AddLine('item: '..id)
end
GameTooltip:HookScript('OnTooltipSetItem', AddItemID)
ItemRefTooltip:HookScript('OnTooltipSetItem', AddItemID)
ShoppingTooltip1:HookScript('OnTooltipSetItem', AddItemID)
ShoppingTooltip2:HookScript('OnTooltipSetItem', AddItemID)
ShoppingTooltip3:HookScript('OnTooltipSetItem', AddItemID)
ItemRefShoppingTooltip1:HookScript('OnTooltipSetItem', AddItemID)
ItemRefShoppingTooltip2:HookScript('OnTooltipSetItem', AddItemID)
ItemRefShoppingTooltip3:HookScript('OnTooltipSetItem', AddItemID)


local function AddLinkID(self, link)
	local type, id = link:match('^.-H(.-):(%d+).-$')
	if not id or type == 'item' or type == 'spell' then return end
	self:AddLine(id and ' ')
	self:AddLine(type..': '..id)
end 
hooksecurefunc(GameTooltip, 'SetHyperlink', AddLinkID)