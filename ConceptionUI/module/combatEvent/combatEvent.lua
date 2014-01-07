local C, D = unpack(select(2,...))

function D.LOAD.M:LoadCombatEvent()
	
	local API, FUNC = D.API, C.FUNC.UNIT
	local Frame, Icon, DropShadow, String = API.Frame, API.Icon, API.DropShadow, API.String

	local  function Finished(self)
		self.parent:Hide()
		if self.ae then
			self.ae = 0
		end
	end

	local function CreateAni_H(frame)
		local AG = frame:CreateAnimationGroup()
			AG.fadeIni = AG:CreateAnimation('Alpha')
			AG.fadeIni:SetChange(-1)
			AG.fadeIni:SetDuration(0)
			AG.fadeIni:SetOrder(0)
			AG.moveIni = AG:CreateAnimation('Translation')
			AG.moveIni:SetDuration(0)
			AG.moveIni:SetOrder(0)
			
			AG.fadeIn = AG:CreateAnimation('Alpha')
			AG.fadeIn:SetChange(1)
			AG.fadeIn:SetDuration(.2)
			AG.fadeIn:SetOrder(1)
			AG.moveIn = AG:CreateAnimation('Translation')
			AG.moveIn:SetSmoothing('OUT_IN')
			AG.moveIn:SetDuration(.2)
			AG.moveIn:SetOrder(1)

			AG.moveStay = AG:CreateAnimation('Translation')
			AG.moveStay:SetDuration(.5)
			AG.moveStay:SetOrder(2)

			AG.fadeOut = AG:CreateAnimation('Alpha')
			AG.fadeOut:SetChange(-1)
			AG.fadeOut:SetDuration(.2)
			AG.fadeOut:SetOrder(3)
			AG.moveOut = AG:CreateAnimation('Translation')
			AG.moveOut:SetSmoothing('OUT_IN')
			AG.moveOut:SetDuration(.2)
			AG.moveOut:SetOrder(3)
			
			AG.ae = 0
			AG.parent = frame
			AG:SetScript('OnFinished', Finished)
		return AG
	end

	local function CreateAni_V(frame)
		local AG = frame:CreateAnimationGroup()
			AG.fadeIni = AG:CreateAnimation('Alpha')
			AG.fadeIni:SetChange(-1)
			AG.fadeIni:SetDuration(0)
			AG.fadeIni:SetOrder(0)
			AG.moveIni = AG:CreateAnimation('Translation')
			AG.moveIni:SetDuration(0)
			AG.moveIni:SetOrder(0)
			AG.moveIni:SetOffset(0, -100)
			AG.moveUp = AG:CreateAnimation('Translation')
			AG.moveUp:SetDuration(1.2)
			AG.moveUp:SetOffset(0, 200)
			AG.moveUp:SetOrder(1)
			AG.moveUp:SetSmoothing('IN_OUT')
			AG.fadeIn = AG:CreateAnimation('Alpha')
			AG.fadeIn:SetChange(.7)
			AG.fadeIn:SetDuration(.2)
			AG.fadeIn:SetOrder(1)
			AG.fadeOut = AG:CreateAnimation('Alpha')
			AG.fadeOut:SetStartDelay(.8)
			AG.fadeOut:SetChange(-1)
			AG.fadeOut:SetDuration(.2)
			AG.fadeOut:SetOrder(1)
			AG.parent = frame
			AG:SetScript('OnFinished', Finished)
		return AG
	end

	local TargetEvent = Frame('Conception TargetEvent', C, 'LEFT', UIParent, 'CENTER', D.CFG['COMBAT_EVENT'].x, D.CFG['COMBAT_EVENT'].y, 22, 22)
		TargetEvent:SetFrameLevel(9)
		TargetEvent.icon = Icon(TargetEvent, 22, 'BACKGROUND')
		TargetEvent.shadow = DropShadow(TargetEvent)
		TargetEvent.string = String(TargetEvent, 'LEFT', TargetEvent, 'RIGHT', 4, 0, D.CFG['COMBAT_EVENT'].font, D.CFG['COMBAT_EVENT'].fontSize, D.CFG['COMBAT_EVENT'].fontFlag, 1.25, -1.25)

		TargetEvent.IN = CreateAni_H(TargetEvent)
		TargetEvent.IN.moveIni:SetOffset(-20, 0)
		TargetEvent.IN.moveIn:SetOffset(20, 0)
		TargetEvent.IN.moveStay:SetOffset(1, 0)
		TargetEvent.IN.moveOut:SetOffset(20, 0)

		TargetEvent.OUT = CreateAni_H(TargetEvent)
		TargetEvent.OUT.moveIni:SetOffset(20, 0)
		TargetEvent.OUT.moveIn:SetOffset(-20, 0)
		TargetEvent.OUT.moveStay:SetOffset(-1, 0)
		TargetEvent.OUT.moveOut:SetOffset(-20, 0)

		TargetEvent:Hide()

	local TargetSubEvent = Frame('Conception TargetSubEvent', C, 'TOPLEFT', TargetEvent, 'BOTTOMLEFT', 10, -10, 20, 20)
		TargetSubEvent:SetFrameLevel(9)
		TargetSubEvent.icon = Icon(TargetSubEvent, 20, 'BACKGROUND')
		TargetSubEvent.shadow = DropShadow(TargetSubEvent)
		TargetSubEvent.string = String(TargetSubEvent, 'LEFT', TargetSubEvent, 'RIGHT', 3, 0, D.CFG['COMBAT_EVENT'].font, .8*D.CFG['COMBAT_EVENT'].fontSize, D.CFG['COMBAT_EVENT'].fontFlag, 1, -1)

		TargetSubEvent.IN = CreateAni_H(TargetSubEvent)
		TargetSubEvent.IN.moveIni:SetOffset(-16, 0)
		TargetSubEvent.IN.moveIn:SetOffset(16, 0)
		TargetSubEvent.IN.moveStay:SetOffset(2, 0)
		TargetSubEvent.IN.moveOut:SetOffset(16, 0)

		TargetSubEvent.OUT = CreateAni_H(TargetSubEvent)
		TargetSubEvent.OUT.moveIni:SetOffset(16, 0)
		TargetSubEvent.OUT.moveIn:SetOffset(-16, 0)
		TargetSubEvent.OUT.moveStay:SetOffset(-2, 0)
		TargetSubEvent.OUT.moveOut:SetOffset(-16, 0)

		TargetSubEvent:Hide()

	local PlayerEvent = Frame('Conception PlayerEvent', C, 'RIGHT', UIParent, 'CENTER', -D.CFG['COMBAT_EVENT'].x, D.CFG['COMBAT_EVENT'].y, 22, 22)
		PlayerEvent:SetFrameLevel(9)
		PlayerEvent.icon = Icon(PlayerEvent, 22, 'BACKGROUND')
		PlayerEvent.shadow = DropShadow(PlayerEvent)
		PlayerEvent.string = String(PlayerEvent, 'RIGHT', PlayerEvent.icon, 'LEFT', -4, 0, D.CFG['COMBAT_EVENT'].font, D.CFG['COMBAT_EVENT'].fontSize, D.CFG['COMBAT_EVENT'].fontFlag, -1.25, -1.25)

		PlayerEvent.IN = CreateAni_H(PlayerEvent)
		PlayerEvent.IN.moveIni:SetOffset(20, 0)
		PlayerEvent.IN.moveIn:SetOffset(-20, 0)
		PlayerEvent.IN.moveStay:SetOffset(-2, 0)
		PlayerEvent.IN.moveOut:SetOffset(-20, 0)

		PlayerEvent.OUT = CreateAni_H(PlayerEvent)
		PlayerEvent.OUT.moveIni:SetOffset(-20, 0)
		PlayerEvent.OUT.moveIn:SetOffset(20, 0)
		PlayerEvent.OUT.moveStay:SetOffset(2, 0)
		PlayerEvent.OUT.moveOut:SetOffset(20, 0)

		PlayerEvent:Hide()

	local PlayerSubEvent = Frame('Conception PlayerSubEvent', C, 'TOPRIGHT', PlayerEvent, 'BOTTOMRIGHT', -10, -10, 20, 20)
		PlayerSubEvent:SetFrameLevel(9)
		PlayerSubEvent.icon = Icon(PlayerSubEvent, 20, 'BACKGROUND')
		PlayerSubEvent.shadow = DropShadow(PlayerSubEvent)
		PlayerSubEvent.string = String(PlayerSubEvent, 'RIGHT', PlayerSubEvent.icon, 'LEFT', -3, 0, D.CFG['COMBAT_EVENT'].font, .8*D.CFG['COMBAT_EVENT'].fontSize, D.CFG['COMBAT_EVENT'].fontFlag, -1, -1)

		PlayerSubEvent.IN = CreateAni_H(PlayerSubEvent)
		PlayerSubEvent.IN.moveIni:SetOffset(16, 0)
		PlayerSubEvent.IN.moveIn:SetOffset(-16, 0)
		PlayerSubEvent.IN.moveStay:SetOffset(-2, 0)
		PlayerSubEvent.IN.moveOut:SetOffset(-16, 0)

		PlayerSubEvent.OUT = CreateAni_H(PlayerSubEvent)
		PlayerSubEvent.OUT.moveIni:SetOffset(-16, 0)
		PlayerSubEvent.OUT.moveIn:SetOffset(16, 0)
		PlayerSubEvent.OUT.moveStay:SetOffset(2, 0)
		PlayerSubEvent.OUT.moveOut:SetOffset(16, 0)

		PlayerSubEvent:Hide()
--[[
	local function CreateScroll(frame, i)
		local line = 'line'..i
		frame[line] = Frame(nil, C, 'CENTER', UIParent, 'CENTER', 0, 0, 16, 16)
		frame[line]:SetAlpha(0)
		frame[line].icon = Icon(frame[line], 16, 'ARTWORK')
		frame[line].shadow = DropShadow(frame[line])
		frame[line].string = String(frame[line], 'TOP', frame[line], 'BOTTOM', 0, 0, D.CFG['COMBAT_EVENT'].font, D.CFG['COMBAT_EVENT'].fontSize-4, D.CFG['COMBAT_EVENT'].fontFlag, 0, 0)
		frame[line].UP = CreateAni_V(frame[line])
		frame[line]:Hide()
	end

	for i = 1, 10 do
		CreateScroll(PlayerEvent, i)
		local line = 'line'..i
		PlayerEvent[line]:ClearAllPoints()
		PlayerEvent[line]:SetPoint('RIGHT', UIParent, 'CENTER', -D.CFG['COMBAT_EVENT'].x-32, D.CFG['COMBAT_EVENT'].y)
		PlayerEvent[line].string:ClearAllPoints()
		PlayerEvent[line].string:SetPoint('RIGHT', PlayerEvent[line].icon, 'LEFT', -2, 0)
		CreateScroll(TargetEvent, i)
		TargetEvent[line]:ClearAllPoints()
		TargetEvent[line]:SetPoint('LEFT', UIParent, 'CENTER', D.CFG['COMBAT_EVENT'].x+32, D.CFG['COMBAT_EVENT'].y)
		TargetEvent[line].string:ClearAllPoints()
		TargetEvent[line].string:SetPoint('LEFT', TargetEvent[line].icon, 'RIGHT', 2, 0)
	end
]]
	local CombatEvent = CreateFrame('Frame', 'CombatEvent', C)
		CombatEvent:RegisterEvent('PLAYER_LOGIN')
		CombatEvent:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
		CombatEvent:Hide()
		CombatEvent.TargetEvent = TargetEvent
		CombatEvent.PlayerEvent = PlayerEvent
		CombatEvent.TargetSubEvent = TargetSubEvent
		CombatEvent.PlayerSubEvent = PlayerSubEvent

	local SendChatMessage = SendChatMessage
	function CombatEvent:AddMessage(channel, text, ...)
		if not channel then return end
		SendChatMessage(text:format(...), channel, nil)
	end

	local NoticeColor = {r = 1, g = 1, b = 1}
	local RaidNotice_AddMessage, RaidBossEmoteFrame = RaidNotice_AddMessage, RaidBossEmoteFrame
	function CombatEvent:AddNotice(r, g, b, text, ...)
		NoticeColor.r = r
		NoticeColor.g = g
		NoticeColor.b = b
		RaidBossEmoteFrame.slot1.fadeOutTime = .5
		RaidBossEmoteFrame.slot2.fadeOutTime = .5
		RaidNotice_AddMessage(RaidBossEmoteFrame, text:format(...), NoticeColor, 1)
	end
--[[
	local GetSpellTexture = GetSpellTexture
	local function DisplayScroll(line, icon, text, r, g, b)
		if line.UP:IsPlaying() then return end
		line.icon:SetTexture(icon)
		line.string:SetText(text)
		line.string:SetTextColor(r, g, b)
		line.UP:Play()
		line:Show()
	end

	function CombatEvent:AddScroll(frame, iconID, text, r, g, b)
		frame = CombatEvent[frame]
		for i = 1, 10 do
			DisplayScroll(frame['line'..i], GetSpellTexture(iconID), text, r, g, b)
		end
	end
]]
	function CombatEvent:Display(frame, animation, iconID, text, r, g, b)
		frame = CombatEvent[frame]
		frame:Hide()
		frame[animation]:Stop()
		frame.icon:SetTexture(GetSpellTexture(iconID))
		frame.string:SetText(text)
		frame.string:SetTextColor(r, g, b)
		frame[animation]:Play()
		frame:Show()
	end


	function CombatEvent:COMBAT_LOG_EVENT_UNFILTERED(_, combatEvent, _, sourceGUID, sourceName, destGUID, ...)
		--local _, _, _, spellID = ...
		--print(_, combatEvent, _, sourceGUID, sourceName, destGUID, ...)
		if sourceGUID ~= self.PLAYER and destGUID ~= self.PLAYER then return end
		self.CLEU[combatEvent](self, sourceGUID, sourceName, destGUID, ...)
	end


	local collectgarbage, SetCVar = collectgarbage, SetCVar
	function CombatEvent:PLAYER_REGEN_DISABLED()
		self:UnregisterEvent('PLAYER_REGEN_DISABLED')
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
		self:AddNotice(1, 0, 0, '+ COMBAT +')
		if self.HideFriendlyNameplatesInCombat then
			SetCVar('nameplateShowFriends', 0)
		end
	end
	function CombatEvent:PLAYER_REGEN_ENABLED()
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
		self:RegisterEvent('PLAYER_REGEN_DISABLED')
		self:AddNotice(0, 1, 0, '- COMBAT -')
		if self.HideFriendlyNameplatesInCombat then
			SetCVar('nameplateShowFriends', 1)
		end
	end

	local GetSpellTexture = GetSpellTexture
	local function GetSpellIcon(spellID)
		return ('|T%s:0|t'):format(GetSpellTexture(spellID))
	end
	CombatEvent.GetSpellIcon = GetSpellIcon

	local function GetUnitChannel(unit)
		if unit:match('raid%d') then
			return CombatEvent.CHANNEL
		elseif unit:match('party%d') and CombatEvent.CHANNEL == 'PARTY' then
			return 'PARTY'
		elseif unit == 'player' and CombatEvent.CHANNEL == 'PARTY' then
			return 'PARTY'
		else
			return nil
		end
	end

	local UnitName, GetSpellLink = UnitName, GetSpellLink
	local ColoredName = C.FUNC.UNIT.ColoredName
	local COMMON = D.CFG.COMBAT_EVENT['common'] or {}
	function CombatEvent:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, rank, line, spellID)
		if not unit then return end
		if not COMMON[spellID] then return end
		self:AddNotice(1, 1, 1, '%s > %s%s', ColoredName(unit), GetSpellIcon(spellID), spellName)
		self:AddMessage(GetUnitChannel(unit), '%s > %s', UnitName(unit), GetSpellLink(spellID))
		return	
	end

	local IsInGroup, IsInRaid = IsInGroup, IsInRaid
	local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
	function CombatEvent:GROUP_ROSTER_UPDATE()
		local NAMEPLATE = C.NAMEPLATE
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			self.CHANNEL = 'INSTANCE_CHAT'
			NAMEPLATE.group = 'raid%d'
		elseif IsInRaid() then
			self.CHANNEL = 'RAID'
			NAMEPLATE.group = 'raid%d'
		elseif IsInGroup() then
			self.CHANNEL = 'PARTY'
			NAMEPLATE.group = 'party%d'
		else
			self.CHANNEL = nil
			NAMEPLATE.group = false
		end
	end

	function CombatEvent:PLAYER_LOGIN()
		RAID_NOTICE_FADE_OUT_TIME = .2
		self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')
		self:RegisterEvent('PLAYER_REGEN_DISABLED')
		self:RegisterEvent('GROUP_ROSTER_UPDATE')
		self:UnregisterEvent('PLAYER_LOGIN')
		self.PLAYER = C.PLAYER
		self.HideFriendlyNameplatesInCombat = ConceptionCFG['HideFriendlyNameplatesInCombat']
		self:GROUP_ROSTER_UPDATE()
	end

	C.COMBATEVENT = CombatEvent
end