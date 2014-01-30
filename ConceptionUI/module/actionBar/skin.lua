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

	self.normal_texture = self:GetNormalTexture()
	if self.normal_texture then
		self.normal_texture:SetTexture(TEXTURE.buttonOverlay)
		self.normal_texture:SetVertexColor(0, 0, 0, 1)
		self.normal_texture:ClearAllPoints()
		self.normal_texture:SetAllPoints()
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
	self.count = count

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

	if self.FlyoutBorder then
		self.FlyoutBorder:SetTexture(nil)
	end

	if self.FlyoutBorderShadow then
		self.FlyoutBorderShadow:SetTexture(nil)
	end

	--self.FlyoutArrow

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

	self:SetAttribute('showgrid', 1)
	self:SetAttribute('statehidden', nil)
	self:Show()
 end
hooksecurefunc('ActionButton_Update', Skin)
hooksecurefunc('PetActionButton_OnEvent', Skin)

local IsEquippedAction, IsConsumableAction = IsEquippedAction, IsConsumableAction
local function UpdateAction(self)
	if not self.normal_texture then return end
	self.normal_texture:SetVertexColor(0, 0, 0, 1)
	if IsConsumableAction(self.action) then
		if self.count:GetText() == '0' then
			self.borderFrame:SetBackdropBorderColor(.6, .1, .1, 1)
			return
		else
			self.borderFrame:SetBackdropBorderColor(.1, .1, .1, 1)
			return
		end
	elseif IsEquippedAction(self.action) then
		self.borderFrame:SetBackdropBorderColor(.1, .6, .1, 1)
		return
	else
		self.borderFrame:SetBackdropBorderColor(.1, .1, .1, 1)
	end
end
hooksecurefunc('ActionButton_Update', UpdateAction)
hooksecurefunc('ActionButton_UpdateUsable', UpdateAction)
hooksecurefunc('ActionButton_ShowGrid', UpdateAction)

local ActionHasRange, IsActionInRange = ActionHasRange, IsActionInRange --local usable, oom = IsUsableAction(self.action)
local function UpdateActioRange(self)
	if not self.borderFrame then return end
	if not ActionHasRange(self.action) or self.count:GetText()=='0' then return end
	if IsActionInRange(self.action)~=0 then
		self.borderFrame:SetBackdropBorderColor(.1, .1, .1, 1)
		return
	else
		self.borderFrame:SetBackdropBorderColor(.6, .1, .1, 1)
	end
end
hooksecurefunc('ActionButton_OnUpdate', UpdateActioRange)

local function UpdatePetActionButton(self)
	for i = 1, 10 do
		local button = _G['PetActionButton'..i]
		button.normal_texture:SetTexture(TEXTURE.buttonOverlay)
		button.normal_texture:SetVertexColor(0, 0, 0, 1)
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)
		if isActive then
			button.borderFrame:SetBackdropBorderColor(.6, .6, .1, 1)
		else
			button.borderFrame:SetBackdropBorderColor(.1, .1, .1, 1)
		end
	end
end
hooksecurefunc('PetActionBar_Update', UpdatePetActionButton)

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