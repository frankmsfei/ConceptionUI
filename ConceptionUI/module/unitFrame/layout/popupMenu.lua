local C = unpack(select(2,...))

UnitPopupMenus['SELF'] = {
	'VEHICLE_LEAVE',
	'RAID_TARGET_ICON', 'SELECT_ROLE', 'SELECT_LOOT_SPECIALIZATION',
	'RESET_INSTANCES',
	'RESET_CHALLENGE_MODE',
	'CONVERT_TO_RAID', 'CONVERT_TO_PARTY',
	'DUNGEON_DIFFICULTY', 'RAID_DIFFICULTY',
	'LOOT_METHOD', 'LOOT_THRESHOLD', 'OPT_OUT_LOOT_TITLE', 'LOOT_PROMOTE',
	'PVP_FLAG',
	'INSTANCE_LEAVE', 'LEAVE',
	'INSPECT',
	'CANCEL'
}

UnitPopupMenus['PLAYER'] = {
	'RAID_TARGET_ICON',
	'TRADE', 'WHISPER', 'INSPECT', 'ACHIEVEMENTS',
	'INVITE', 'FOLLOW', 'DUEL', 'PET_BATTLE_PVP_DUEL',
	'RAF_SUMMON', 'RAF_GRANT_LEVEL',
	'ADD_FRIEND', 'ADD_FRIEND_MENU',
	'REPORT_PLAYER',
	'CANCEL'
}

UnitPopupMenus['PARTY'] = {
	'RAID_TARGET_ICON', 'SELECT_ROLE',
	'TRADE', 'WHISPER', 'INSPECT', 'ACHIEVEMENTS',
	'FOLLOW', 'DUEL', 'PET_BATTLE_PVP_DUEL',
	'MUTE', 'UNMUTE', 'PARTY_SILENCE', 'PARTY_UNSILENCE', 'RAID_SILENCE', 'RAID_UNSILENCE', 'BATTLEGROUND_SILENCE', 'BATTLEGROUND_UNSILENCE',
	'PROMOTE', 'PROMOTE_GUIDE', 'LOOT_PROMOTE',
	'RAF_SUMMON', 'RAF_GRANT_LEVEL',
	'ADD_FRIEND', 'ADD_FRIEND_MENU',
	'REPORT_PLAYER', 'PVP_REPORT_AFK', 'VOTE_TO_KICK', 'UNINVITE',
	'CANCEL'
}

UnitPopupMenus['RAID_PLAYER'] = {
	'RAID_TARGET_ICON',
	'SELECT_ROLE',
	'TRADE', 'WHISPER', 'INSPECT', 'ACHIEVEMENTS',
	'FOLLOW', 'DUEL', 'PET_BATTLE_PVP_DUEL',
	'MUTE', 'UNMUTE', 'RAID_SILENCE', 'RAID_UNSILENCE', 'BATTLEGROUND_SILENCE', 'BATTLEGROUND_UNSILENCE',
	'RAID_LEADER', 'RAID_PROMOTE', 'RAID_DEMOTE', 'LOOT_PROMOTE',
	'RAF_SUMMON', 'RAF_GRANT_LEVEL',
	'ADD_FRIEND', 'ADD_FRIEND_MENU',
	'REPORT_PLAYER', 'PVP_REPORT_AFK', 'VOTE_TO_KICK', 'RAID_REMOVE',
	'CANCEL'
}

UnitPopupMenus['RAID'] = {
	'RAID_TARGET_ICON',
	'MUTE', 'UNMUTE', 'RAID_SILENCE', 'RAID_UNSILENCE', 'BATTLEGROUND_SILENCE', 'BATTLEGROUND_UNSILENCE',
	'RAID_LEADER', 'RAID_PROMOTE', 'RAID_MAINTANK', 'RAID_MAINASSIST', 'LOOT_PROMOTE', 'RAID_DEMOTE',
	'REPORT_PLAYER', 'PVP_REPORT_AFK', 'VOTE_TO_KICK', 'RAID_REMOVE',
	'CANCEL'
}

UnitPopupMenus['TARGET'] = {
	'RAID_TARGET_ICON',
	'CANCEL'
}

UnitPopupMenus['FOCUS'] = {
	'RAID_TARGET_ICON',
	'WHISPER',
	'INSPECT',
	'CANCEL'
}

UnitPopupMenus['PET'] = {
	'PET_DISMISS',
	'RAID_TARGET_ICON',
	'PET_PAPERDOLL',
	'PET_RENAME',
	'PET_ABANDON',
	'CANCEL'
}

UnitPopupMenus['OTHERPET'] = {
	'RAID_TARGET_ICON',
	'REPORT_PET',
	'CANCEL'
}

UnitPopupMenus['OTHERBATTLEPET'] = {
	'RAID_TARGET_ICON',
	'REPORT_BATTLE_PET',
	'CANCEL'
}

UnitPopupMenus['VEHICLE'] = {
	'VEHICLE_LEAVE',
	'RAID_TARGET_ICON',
	'CANCEL'
}


TargetFrameDropDown.point = 'TOPRIGHT'
TargetFrameDropDown.relativePoint = 'BOTTOMRIGHT'

tinsert(UnitPopupFrames, 'TargetTargetFrameDropDown')
TargetTargetFrameDropDown = CreateFrame('Frame', 'TargetTargetFrameDropDown', UIParent, 'UIDropDownMenuTemplate')
TargetTargetFrameDropDown:Hide()
TargetTargetFrameDropDown.point = 'TOPRIGHT'
TargetTargetFrameDropDown.relativePoint = 'BOTTOMRIGHT'
TargetTargetFrameDropDown.displayMode = 'MENU'
TargetTargetFrameDropDown.initialize = function()
	if UnitExists('targettarget') then
		if UnitIsUnit('targettarget', 'player') then
			UnitPopup_ShowMenu(TargetTargetFrameDropDown, 'SELF', 'player')
		else
			if UnitIsPlayer('targettarget') then
				UnitPopup_ShowMenu(TargetTargetFrameDropDown, 'PLAYER', 'targettarget')
			else
				if UnitPlayerControlled('targettarget') then
					if UnitIsUnit('targettarget', 'pet') then
						UnitPopup_ShowMenu(TargetTargetFrameDropDown, 'PET', 'targettarget')
					else
						UnitPopup_ShowMenu(TargetTargetFrameDropDown, 'OTHERPET', 'targettarget')
					end
				else
					UnitPopup_ShowMenu(TargetTargetFrameDropDown, 'TARGET', 'targettarget')
				end
			end
		end
	end
end



UnitPopupButtons['TOGGLE_CALENDAR'] = {text = '行事曆', dist = 0}
UnitPopupButtons['STATUS_AVAILABLE'] = {text = FRIENDS_LIST_AVAILABLE, dist = 0}
UnitPopupButtons['STATUS_AWAY'] = {text = FRIENDS_LIST_AWAY, dist = 0}
UnitPopupButtons['STATUS_BUSY'] = {text = FRIENDS_LIST_BUSY, dist = 0}
UnitPopupButtons['STATUS'] = {text = STATUS, dist = 0, nested = 1}
UnitPopupMenus['STATUS'] = {'STATUS_AVAILABLE', 'STATUS_AWAY', 'STATUS_BUSY'}
UnitPopupButtons['SWAP_SPEC'] = {text = '切換天賦專精', dist = 0}
UnitPopupButtons['HIDE_NAMEPLATE'] = {text = '戰鬥中隱藏友方血條', dist = 0, nested = 1}
UnitPopupMenus['HIDE_NAMEPLATE'] = {}
UnitPopupButtons['SELECT_TITLE'] = {text = PAPERDOLL_SELECT_TITLE, dist = 0, nested = 1}
UnitPopupMenus['SELECT_TITLE'] = {}
UnitPopupButtons['GUILD_INVITE'] = {text = '公會邀請', dist = 0}
UnitPopupButtons['ADDFRIEND'] = {text = ADD_FRIEND, dist = 0}
local func = {
	['TOGGLE_CALENDAR'] = ToggleCalendar,
	['STATUS_AVAILABLE'] = function() SendChatMessage('' , (UnitIsAFK('player') and 'AFK') or (UnitIsDND('player') and 'DND')) end,
	['STATUS_AWAY'] = function() SendChatMessage('' , 'AFK') end,
	['STATUS_BUSY'] = function() SendChatMessage('' , 'DND') end,
	['SWAP_SPEC'] = function() SetActiveSpecGroup(3-GetActiveSpecGroup()) end,
	['GUILD_INVITE'] = GuildInvite,
	['ADDFRIEND'] = AddFriend,
}

local function insertbefore(t, before, value)
	for k, v in ipairs(t) do
		if v == before then
			return table.insert(t, k, value)
		end
	end
	table.insert(t, value)
end

local function insertafter(t, after, value)
	for k, v in ipairs(t) do
		if v == after then
			return table.insert(t, k+1, value)
		end
	end
	table.insert(t, value)
end

insertbefore(UnitPopupMenus['SELF'], 'CANCEL', 'TOGGLE_CALENDAR')
insertafter(UnitPopupMenus['SELF'], 'TOGGLE_CALENDAR', 'STATUS')
insertafter(UnitPopupMenus['SELF'], 'STATUS', 'SELECT_TITLE')
insertafter(UnitPopupMenus['SELF'], 'SELECT_LOOT_SPECIALIZATION', 'SWAP_SPEC')
insertafter(UnitPopupMenus['SELF'], 'SWAP_SPEC', 'HIDE_NAMEPLATE')
insertbefore(UnitPopupMenus['FOCUS'], 'CANCEL', 'GUILD_INVITE')
insertafter(UnitPopupMenus['FOCUS'], 'GUILD_INVITE', 'ADDFRIEND')
insertafter(UnitPopupMenus['PLAYER'], 'INVITE', 'GUILD_INVITE')
insertafter(UnitPopupMenus['PLAYER'], 'GUILD_INVITE', 'ADDFRIEND')
insertafter(UnitPopupMenus['FRIEND'], 'INVITE', 'GUILD_INVITE')
insertafter(UnitPopupMenus['FRIEND'], 'GUILD_INVITE', 'ADDFRIEND')

hooksecurefunc('UnitPopup_OnClick', function(self)
        local dropdownFrame = UIDROPDOWNMENU_INIT_MENU
        local button = self.value
        if func[button] then func[button](dropdownFrame.name) end
        PlaySound('UChatScrollButton')
end)

local function SetTitle(self, i)
	SetCurrentTitle(i)
	print('title selected')
end

local info = {}

hooksecurefunc('UnitPopup_ShowMenu', function(dropdownMenu, which, unit, name, userData)
	if which ~= 'SELF' then return end
	local which = UIDROPDOWNMENU_INIT_MENU.which
	if which == 'HIDE_NAMEPLATE' then
		local enable = ConceptionCFG['HideFriendlyNameplatesInCombat'] and ConceptionCFG['HideFriendlyNameplatesInCombat'] or false
		info.text = ENABLE
		info.func = function()
			ConceptionCFG['HideFriendlyNameplatesInCombat'] = true
			C.COMBATEVENT.HideFriendlyNameplatesInCombat = true
			if UnitAffectingCombat('player') then
				SetCVar('nameplateShowFriends', 0)
			end
		end
		info.checked = enable
		UIDropDownMenu_AddButton(info, 2)
		wipe(info)
		info.text = DISABLE
		info.func = function()
			ConceptionCFG['HideFriendlyNameplatesInCombat'] = false
			C.COMBATEVENT.HideFriendlyNameplatesInCombat = false
			if UnitAffectingCombat('player') then
				SetCVar('nameplateShowFriends', 1)
			end
		end
		info.checked = not enable
		UIDropDownMenu_AddButton(info, 2)
		wipe(info)
	elseif which == 'SELECT_TITLE' then
		local titles = ConceptionCFG['FavoriteTitles']
		if titles then
			for id in pairs(titles) do
				info.text = GetTitleName(id)
				info.arg1 = id
				info.func = SetTitle
				info.checked = GetCurrentTitle() == id
				UIDropDownMenu_AddButton(info, 2)
				wipe(info)
			end
		end
		info.text = PLAYER_TITLE_NONE
		info.arg1 = 0
		info.func = SetTitle
		info.checked = GetCurrentTitle() == 0
		UIDropDownMenu_AddButton(info, 2)
		wipe(info)
	end
end)

local function SelectFavoriteTitle(self)
	local id = self:GetParent().titleId
	ConceptionCFG['FavoriteTitles'][id] = self:GetChecked()
end

PaperDollTitlesPane:HookScript('OnShow', function(self)
	ConceptionCFG['FavoriteTitles'] = ConceptionCFG['FavoriteTitles'] or {}
	for i = 1, #self.buttons do
		if not self.buttons[i].checkbutton then
			self.buttons[i].checkbutton = CreateFrame('CheckButton', nil, self.buttons[i], 'UICheckButtonTemplate')
			self.buttons[i].checkbutton:SetSize(20, 20)
			self.buttons[i].checkbutton:SetPoint('RIGHT')
			self.buttons[i].checkbutton:SetScript('OnClick', SelectFavoriteTitle)
		end
	end
	self.update()
end)

hooksecurefunc(PaperDollTitlesPane, 'update', function()
	local titles = ConceptionCFG['FavoriteTitles']
	local buttons = PaperDollTitlesPane.buttons
	for i = 1, #buttons do
		if buttons[i].titleId == -1 then
			buttons[i].checkbutton:Hide()
		else
			if titles[buttons[i].titleId] then
				buttons[i].checkbutton:SetChecked(1)
			else
				buttons[i].checkbutton:SetChecked(0)
			end
			buttons[i].checkbutton:Show()
		end
	end
end)