local TEXTURE = select(2,...)[2].MEDIA.TEXTURE

local function Skin(self)
	if self.skin then
		return
	end
	self.skin = true

	local name = self:GetName()

	if name:match('^Override%w+%d$') or name:match('^Extra%w+%d$') then
		return
	end

	self:SetSize(26, 26)

	local normal = self:GetNormalTexture()
	if normal then
		normal:SetTexture(TEXTURE.buttonOverlay)
		normal:SetVertexColor(0, 0, 0, 1)
		normal:ClearAllPoints()
		normal:SetAllPoints()
	end

	local pushed = self:GetPushedTexture()
	if pushed then
		pushed:SetTexture(TEXTURE.buttonOverlay)
		pushed:SetVertexColor(1, 0, 0, 1)
	end

	local highlight = self:GetHighlightTexture()
	if highlight then
		highlight:SetTexture(TEXTURE.buttonOverlay)
		highlight:SetVertexColor(1, 1, 0, 1)
	end

	local checked = self:GetCheckedTexture()
	if checked then
		checked:SetTexture(TEXTURE.buttonOverlay)
		checked:SetVertexColor(0, 0, 0, 1)
	end

	local border = _G[name..'Border']
	if border then
		border:SetTexture(nil)
	end

	local hotkey = _G[name..'HotKey']
	if hotkey then
		hotkey:SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
		hotkey:ClearAllPoints()
		hotkey:SetPoint('TOPRIGHT')
		hotkey:SetDrawLayer('HIGHLIGHT')
	end
		
	local macro_name = _G[name..'Name']
	if macro_name then
		macro_name:SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
		macro_name:ClearAllPoints()
		macro_name:SetPoint('BOTTOM')
		macro_name:SetDrawLayer('HIGHLIGHT')
	end

	local count = _G[name..'Count']
	if count then
		count:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
		count:ClearAllPoints()
		count:SetPoint('BOTTOMRIGHT')
		count:SetDrawLayer('OVERLAY')
	end

	local icon = _G[name..'Icon']
	if icon then
		icon:SetTexCoord(.1, .9, .1, .9)
		icon:ClearAllPoints()
		icon:SetAllPoints()
	end

	local cd = _G[name..'Cooldown']
	if cd then
		cd:ClearAllPoints()
		cd:SetAllPoints()
	end

	local floatingBG = _G[name..'FloatingBG']
	if floatingBG then
		floatingBG:Hide()
	end

	local normal2 = _G[name..'NormalTexture2']
	if normal2 then
		normal2:SetAlpha(0)
	end

	local flyoutBorder = self.FlyoutBorder
	if flyoutBorder then
		flyoutBorder:SetTexture(nil)
	end

	local flyoutBorderShadow = self.FlyoutBorderShadow
	if flyoutBorderShadow then
		flyoutBorderShadow:SetTexture(nil)
	end

	--local flyoutArrow = self.FlyoutArrow

	if not self.shadowFrame then
		self.shadowFrame = CreateFrame('Frame', nil, self)
		self.shadowFrame:SetFrameLevel(self:GetFrameLevel() -1)
		self.shadowFrame:SetPoint('TOPLEFT', -8, 8)
		self.shadowFrame:SetPoint('BOTTOMRIGHT', 8, -8)
		self.shadowFrame.shadow = self.shadowFrame:CreateTexture(nil, 'BACKGROUND')
		self.shadowFrame.shadow:SetTexture(TEXTURE.buttonShadow)
		self.shadowFrame.shadow:SetVertexColor(0, 0, 0, .6)
		self.shadowFrame.shadow:SetAllPoints()
	end

	if not self.borderFrame then
		self.borderFrame = CreateFrame('Frame', nil, self)
		self.borderFrame:SetPoint('TOPLEFT', -2, 2)
		self.borderFrame:SetPoint('BOTTOMRIGHT', 2, -2)
		self.borderFrame:SetFrameLevel(cd:GetFrameLevel()-1)
		self.borderFrame:SetBackdrop(TEXTURE.buttonBorder)
		self.borderFrame:SetBackdropBorderColor(.1, .1, .1, 1)
	end
 end
hooksecurefunc('ActionButton_Update', Skin)
hooksecurefunc('PetActionButton_OnEvent', Skin)

local IsEquippedAction, IsConsumableAction = IsEquippedAction, IsConsumableAction
local function FixTexture(self)
	self:GetNormalTexture():SetVertexColor(0, 0, 0, 1)
	if not self.borderFrame then
		return
	end
	local action = self.action
	if IsConsumableAction(action) then
		local count = tonumber(_G[self:GetName()..'Count']:GetText())
		if count == 0 then
			self.borderFrame:SetBackdropBorderColor(.6, .1, .1, 1)
		else
			self.borderFrame:SetBackdropBorderColor(.1, .1, .1, 1)
		end
		return
	elseif IsEquippedAction(action) then
		self.borderFrame:SetBackdropBorderColor(.1, .6, .1, 1)
		return
	else
		self.borderFrame:SetBackdropBorderColor(.1, .1, .1, 1)
	end
end
hooksecurefunc('ActionButton_Update', FixTexture)
hooksecurefunc('ActionButton_ShowGrid', FixTexture)
hooksecurefunc('ActionButton_UpdateUsable', FixTexture)


local function UpdateHotkeys(self, actionButtonType)
	local hotkey = _G[self:GetName()..'HotKey']
	local keytext = hotkey:GetText()
	keytext = keytext:gsub('s%-', 'S')
	keytext = keytext:gsub('a%-', 'A')
	keytext = keytext:gsub('c%-', 'C')
	keytext = keytext:gsub('滑鼠按鍵', 'M')
	keytext = keytext:gsub('滑鼠中鍵', 'M3')
	keytext = keytext:gsub('滑鼠滾輪向下滾動', 'MWD')
	keytext = keytext:gsub('滑鼠滾輪向上滾動', 'MWU')
	keytext = keytext:gsub('數字鍵盤', 'N')
	keytext = keytext:gsub('Num Lock', 'NL')
	keytext = keytext:gsub('Page Up', 'PU')
	keytext = keytext:gsub('Page Down', 'PD')
	keytext = keytext:gsub('Pause', 'P')
	keytext = keytext:gsub('空白鍵', 'SpB')
	keytext = keytext:gsub('Insert', 'Ins')
	keytext = keytext:gsub('Home', 'Hm')
	keytext = keytext:gsub('Delete', 'Del')
	keytext = keytext:gsub('`', '~')
	hotkey:SetText(keytext)
end
hooksecurefunc('ActionButton_UpdateHotkeys', UpdateHotkeys)