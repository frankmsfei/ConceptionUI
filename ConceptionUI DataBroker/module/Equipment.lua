local Equip = LibStub('LibDataBroker-1.1'):NewDataObject('Equip', {type = 'data source'})

local MENU = CreateFrame('Frame')
	MENU.displayMode = 'MENU'
	MENU.info = {}
	MENU:SetScript('OnEvent', function(_, event) Equip[event](Equip, event) end)
	MENU:RegisterEvent('PLAYER_LOGIN')
	MENU:Hide()

local function Located(set)
	for slot, location in pairs(GetEquipmentSetLocations(set)) do
		if location == 0 then -- This slot should be emptied.
			if GetInventoryItemLink('player', slot) then
				return false
			end
		--elseif location == 1 then --  this slot is ignored.
		elseif location ~= 1 then
			if slot ~= select(5, EquipmentManager_UnpackLocation(location)) then
				return false
			end
		end
	end
	return true
end

local function OnSelect(self, set)
	if not InCombatLockdown() then
		EquipmentManager_EquipSet(set)
		return
	else
		MENU:RegisterEvent('PLAYER_REGEN_ENABLED')
		Equip.pending = set
		Equip:Update()
	end
end

function Equip:Update()
	if self.pending then
		self.text = ('|cFF9E0000%s|r'):format(self.pending)
		return
	else
		for i = 1, GetNumEquipmentSets() do
			local set = GetEquipmentSetInfo(i)
			if Located(set) then
				self.text = ('|cFF9E9E9E%s|r'):format(set)
				return
			else
				self.text = '|cFF616161UNKNOWN|r'
			end
		end
	end
end

function Equip:PLAYER_LOGIN(event)
	self:Update()
	self.PLAYER_EQUIPMENT_CHANGED = self.Update
	self.EQUIPMENT_SETS_CHANGED = self.Update
	MENU:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
	MENU:RegisterEvent('EQUIPMENT_SETS_CHANGED')
	MENU:UnregisterEvent(event)
end

function Equip:PLAYER_REGEN_ENABLED(event)
	MENU:UnregisterEvent(event)
	EquipmentManager_EquipSet(self.pending)
	self.pending = nil
end

function Equip.OnEnter(self)
	ToggleDropDownMenu(1, nil, MENU, self, -40, 90)
end

function MENU.initialize(self)
	for i = 1, GetNumEquipmentSets() do
		local set, icon = GetEquipmentSetInfo(i)
		MENU.info.text = ('|T%s:14:14:0:-1:48:48:5:44:5:44|t %s%s|r'):format(icon, Equip.pending and Equip.pending == set and '|cFF9E0000' or '', set)
		MENU.info.arg1 = set
		MENU.info.func = OnSelect
		MENU.info.checked = Located(set)
		UIDropDownMenu_AddButton(MENU.info)
		wipe(MENU.info)
	end
end



local function ShowEquipMenu(dropdownMenu, which, unit, name, userData)
	if which ~= 'SELF' then return end
	if UIDROPDOWNMENU_INIT_MENU.which ~= 'EQUIP_MENU' then return end
	for i = 1, GetNumEquipmentSets() do
		local set, icon = GetEquipmentSetInfo(i)
		MENU.info.text = ('|T%s:14:14:0:-1:48:48:5:44:5:44|t %s%s|r'):format(icon, Equip.pending and Equip.pending == set and '|cFF9E0000' or '', set)
		MENU.info.arg1 = set
		MENU.info.func = OnSelect
		MENU.info.checked = Located(set)
		UIDropDownMenu_AddButton(MENU.info, 2)
		wipe(MENU.info)
	end
end
hooksecurefunc('UnitPopup_ShowMenu', ShowEquipMenu)

UnitPopupButtons['EQUIP_MENU'] = {text = EQUIPSET_EQUIP, dist = 0, nested = 1}
UnitPopupMenus['EQUIP_MENU'] = {}
table.insert(UnitPopupMenus['SELF'], 1, 'EQUIP_MENU')