local Spec = LibStub('LibDataBroker-1.1'):NewDataObject('Spec', {type = 'data source'})

local SPEC = {
	-- Mage
	[62] = 'Arcane', [63] = 'Fire', [64] = 'Frost',
	-- Paladin
	[65] = 'Holy', [66] = 'Protection', [70] = 'Retribution',
	-- Warrior
	[71] = 'Arms', [72] = 'Furry', [73] = 'Protection',
	-- Druid
	[102] = 'Balance', [103] = 'FeralCombat', [104] = 'Guardian', [105] = 'Restoration',
	-- Death Knight
	[250] = 'Blood', [251] = 'Frost', [252] = 'Unholy',
	-- Hunter
	[253] = 'BeastMastery', [254] = 'Marksmanship', [255] = 'Survival',
	-- Priest
	[256] = 'Discipline', [257] = 'Holy', [258] = 'Shadow',
	-- Rogue
	[259] = 'Assassination', [260] = 'Combat', [261] = 'Subtlety',
	-- Shaman
	[262] = 'Elemental', [263] = 'Enhancement', [264] = 'Restoration',
	-- Warlock
	[265] = 'Affliction', [266] = 'Demonology', [267] = 'Destruction',
	-- Monk
	[268] = 'Brewmaster', [269] = 'Windwalker', [270] = 'Mistweaver'
}

local COLOR = {
	DAMAGER = '|cFF9E0000',
	HEALER = '|cFF009E00',
	TANK = '|cFF00009E',
}

local ICON = {
	[0] = {
		UNKNOWN = '|TInterface/GossipFrame/IncompleteQuestIcon:11|t',
		DAMAGER = '|TInterface/LFGFRAME/LFGROLE_BW:12:12:0:0:64:16:17:32:0:16|t',
		HEALER = '|TInterface/LFGFRAME/LFGROLE_BW:12:12:0:0:64:16:49:64:0:16|t',
		TANK = '|TInterface/LFGFRAME/LFGROLE_BW:12:12:0:0:64:16:33:48:0:16|t'
	},
	[1] = {
		UNKNOWN = '|TInterface/GossipFrame/DailyActiveQuestIcon:11|t',
		DAMAGER = '|TInterface/LFGFRAME/LFGROLE:12:12:0:0:64:16:17:32:0:16|t',
		HEALER = '|TInterface/LFGFRAME/LFGROLE:12:12:0:0:64:16:49:64:0:16|t',
		TANK = '|TInterface/LFGFRAME/LFGROLE:12:12:0:0:64:16:33:48:0:16|t'
	},
	FILL = '|T%s:12:12:0:0:48:48:5:44:5:44|t',
	EMPTY = '|TInterface/BUTTONS/UI-EmptySlot-Disabled:12:12:0:0:64:64:19:46:19:46|t'
}

local MENU = CreateFrame('Frame')
	MENU.relativePoint = 'TOPRIGHT'
	MENU.displayMode = 'MENU'
	MENU:SetScript('OnEvent', function(_, event) Spec[event](Spec, event) end)
	MENU:RegisterEvent('PLAYER_LOGIN')
	MENU:Hide()

local function GetGlyph(spec)
	local g = {}
	for i = 1, 6 do
		local _, _, _, _, icon = GetGlyphSocketInfo(i, spec)
		if icon then
			g[i] = ICON['FILL']:format(icon)
		else
			g[i] = ICON['EMPTY']
		end
	end
	return ('%s %s %s %s %s %s'):format(g[2], g[4], g[6], g[1], g[3], g[5])
end

local function GetTalent(spec)
	local t = {}
	for i = 1, 6 do
		t[i] = ICON['EMPTY']
	end
	for i = 1, 18 do
		local _, icon, tire, _, enable = GetTalentInfo(i, nil, spec)
		if enable then
			t[tire] = ICON['FILL']:format(icon)
		end
	end
	return ('%s %s %s %s %s %s'):format(t[1], t[2], t[3], t[4], t[5], t[6])
end

local function GetSpec(spec)
	if not spec then
		return 'None', 'UNKNOWN'
	else
		local id, _, _, _, _, role = GetSpecializationInfo(spec)
		return SPEC[id], role
	end
end

local function OnSelect(_, i)
	local db, set = ConceptionDBC.Spec, UIDROPDOWNMENU_MENU_VALUE
	if db[i] == set then
		db[i] = nil
		return
	else
		db[i] = set
		if i ~= Spec.value then
			return
		end
		EquipmentManager_EquipSet(set)
	end
end

local function ShowMenu(self, button)
	CloseDropDownMenus()
	if not self.name then return end
	if button == 'RightButton' then
		ToggleDropDownMenu(1, self.name, MENU, self, 0, 0)
	end
end

function Spec:Update()
	self.value = GetActiveSpecGroup()
	local spec = GetSpecialization()
	if spec then
		local id, _, _, _, _, role = GetSpecializationInfo(spec)
		self.text = ('%s%s|r'):format(COLOR[role], strupper(SPEC[id]))
		UnitSetRole('player', role)
	else
		self.text = '|cFF9E9E9ENONE|r'
		UnitSetRole('player', nil)
	end
	self.OnTooltipShow(GameTooltip)
end

function Spec:PLAYER_SPECIALIZATION_CHANGED()
	self:Update()
	local set = ConceptionDBC.Spec[self.value]
	if set then
		EquipmentManager_EquipSet(set)
	end
end

function Spec:PLAYER_LOGIN(event)
	ConceptionDBC = ConceptionDBC or {}
	ConceptionDBC.Spec = ConceptionDBC.Spec or {}
	self:Update()
	MENU:RegisterUnitEvent('PLAYER_SPECIALIZATION_CHANGED', 'player')
	MENU:UnregisterEvent(event)
end

function Spec.OnClick(_, button)
	if button == 'RightButton' then
		SetActiveSpecGroup(3-GetActiveSpecGroup())
		return
	elseif button == 'LeftButton' then
		if not IsAddOnLoaded('Blizzard_TalentUI') then
			UIParentLoadAddOn('Blizzard_TalentUI')
		end
		ToggleFrame(PlayerTalentFrame)
		TalentMicroButtonAlert:Hide()
	end
end

function Spec.OnTooltipShow(tip)
	tip:ClearLines()
	tip:AddDoubleLine('Specialization', Spec.text, 1, 1, 1, .62, .62, .62)
	local s1, r1 = GetSpec(GetSpecialization(nil, nil, 1))
	local s2, r2 = GetSpec(GetSpecialization(nil, nil, 2))
	if Spec.value == 1 then
		s1 = ('%s|cFF9E9E9E%s|r'):format(ICON[1][r1],s1)
		s2 = ('%s%s'):format(ICON[0][r2],s2)
	elseif Spec.value == 2 then
		s1 = ('%s%s'):format(ICON[0][r1],s1)
		s2 = ('%s|cFF9E9E9E%s|r'):format(ICON[1][r2],s2)
	end
	tip:AddLine(' ')
	tip:AddLine('主要', .62, .62, 0)
	tip:AddDoubleLine(s1, GetTalent(1), .38, .38, .38)
	tip:AddDoubleLine(ConceptionDBC.Spec[1] or ' ', GetGlyph(1), .38, .38, .38)
	tip:AddLine(' ')
	tip:AddLine('次要', .62, .62, 0)
	tip:AddDoubleLine(s2, GetTalent(2), .38, .38, .38)
	tip:AddDoubleLine(ConceptionDBC.Spec[2] or ' ', GetGlyph(2), .38, .38, .38)
	tip:AddLine(' ')
	local n, c = GetGlyphClearInfo()
	if n and c > 0 then
		tip:AddDoubleLine(n, c, .62, .62, .62, .62, .62, .62)
	else
		tip:AddDoubleLine(n, c, .38, .38, .38, .62, 0, 0)
	end
	tip:AddLine(' ')
	tip:AddDoubleLine('天賦介面', '[L]', .38, .38, .38, .62, .38, 0)
	tip:AddDoubleLine('切換天賦', '[R]', .38, .38, .38, 0, .38, .62)
end

function MENU.initialize()
	local info = {func = OnSelect}
	for i = 1, 2 do
		local spec = GetSpecialization(nil, nil, i)
		if spec then
			info.arg1 = i
			local id, _, _, icon = GetSpecializationInfo(spec)
			info.text = ('|T%s:14:14:0:-1:48:48:5:44:5:44|t %s'):format(icon, SPEC[id])
			info.checked = UIDROPDOWNMENU_MENU_VALUE == ConceptionDBC.Spec[i]
			UIDropDownMenu_AddButton(info)
		end
	end
end

hooksecurefunc('PaperDollEquipmentManagerPane_Update', function()
	local buttons = PaperDollEquipmentManagerPane.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if not button.hooked then
			 button:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
			 button:HookScript('OnClick', ShowMenu)
			 button.hooked = true
		end
	end
end)