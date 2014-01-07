local TEXTURE = select(2,...)[2].MEDIA.TEXTURE

local TIPS = {
	GameTooltip,
	ItemRefTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2, 
	ShoppingTooltip3,
	ItemRefShoppingTooltip1,
	ItemRefShoppingTooltip2,
	ItemRefShoppingTooltip3,
	DropDownList1MenuBackdrop, 
	DropDownList2MenuBackdrop,
	WorldMapTooltip,
	WorldMapCompareTooltip1,
	WorldMapCompareTooltip2,
	WorldMapCompareTooltip3,
	BattlePetTooltip,
	--FloatingBattlePetTooltip,
	--FloatingPetBattleAbilityTooltip,
	FriendsTooltip,
	--BNToastFrame,
	--QueueStatusFrame,
}

local function Skin(self)
	if not self.backdrop then
		self:SetBackdrop(TEXTURE.backdrop)
		self.backdrop = true
	end
	self:SetBackdropColor(0, 0, 0, .66)
	self:SetBackdropBorderColor(0, 0, 0, .66)

	if self.id then
		self:AddLine(self.id)
	end

	--GameTooltipTextLeft1:SetShadowOffset(1, -1)
	--[[
	--local numlines = frame:NumLines()
	if numlines then
		for i = 1, frame:NumLines() do
			local lineL = _G[frame:GetName()..'TextLeft'..i]
			local lineR = _G[frame:GetName()..'TextRight'..i]
			local font, size, flag = lineL:GetFont()
			lineL:SetFont(font, size, flag)
			lineL:SetShadowOffset(0, -1)
			lineR:SetFont(font, size, flag)
			lineR:SetShadowOffset(0, -1)
		end
	end
	]]
end

for _, tip in pairs(TIPS) do
	tip:HookScript('OnShow', Skin)
end


local function FixMoneyFrame(self)
	if self.fixed then return end
	local prefix, suffix = self:GetRegions()
	if prefix then
		prefix:SetFontObject(GameTooltipText)
		prefix:SetShadowOffset(0, 0)
	end
	if suffix then
		suffix:SetFontObject(GameTooltipText)
		suffix:SetShadowOffset(0, 0)
	end
	--local _, copper, silver, gold = self:GetChildren()
	--copper:SetNormalFontObject(GameTooltipText)
	--silver:SetNormalFontObject(GameTooltipText)
	--gold:SetNormalFontObject(GameTooltipText)
	self.fixed = true
end
hooksecurefunc('MoneyFrame_SetType', FixMoneyFrame)