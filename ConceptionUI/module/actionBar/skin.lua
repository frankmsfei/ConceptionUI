local TEXTURE = select(2,...)[2].MEDIA.TEXTURE

local IsEquippedAction = IsEquippedAction
local function FixTexture(self)
	local texture = self:GetNormalTexture()
	if not IsEquippedAction(self.action) then
		texture:SetVertexColor(0, 0, 0)
		return
	else
		texture:SetVertexColor(0, 1, 0)
	end
end
hooksecurefunc('ActionButton_ShowGrid', FixTexture)
hooksecurefunc('ActionButton_UpdateUsable', FixTexture)

local function Skin(self)
	local name = self:GetName()
	if name:match('OverrideActionBarButton%d') then
		return
	end

	FixTexture(self)

	if self.skin then
		return
	end
	self.skin = true

	self:SetSize(25.6, 25.6)

	local texture = self:GetNormalTexture()
	if texture then
		texture:SetTexture(TEXTURE.buttonOverlay)
		texture:SetVertexColor(0, 0, 0, 1)
		texture:ClearAllPoints()
		texture:SetAllPoints()
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
		hotkey:SetFont(STANDARD_TEXT_FONT, 8, 'THINOUTLINE')
		hotkey:ClearAllPoints()
		hotkey:SetPoint('TOPRIGHT')
		hotkey:SetDrawLayer('HIGHLIGHT')
	end
		
	local macro_name = _G[name..'Name']
	if macro_name then
		macro_name:SetFont(STANDARD_TEXT_FONT, 8, 'THINOUTLINE')
		macro_name:ClearAllPoints()
		macro_name:SetPoint('BOTTOM')
		macro_name:SetDrawLayer('HIGHLIGHT')
	end

	local count = _G[name..'Count']
	if count then
		count:SetFont(STANDARD_TEXT_FONT, 12, 'THINOUTLINE')
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
--hooksecurefunc('PetActionBar_Update', Skin)

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