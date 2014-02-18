local C, D = unpack(select(2,...))

function D.LOAD.M:LoadCombatEvent()
	
	local API, FUNC = D.API, C.FUNC.UNIT
	local Frame, Icon, DropShadow, String = API.Frame, API.Icon, API.DropShadow, API.String
	local cfg = D.CFG['COMBAT_EVENT']
	local COMMON = cfg['common'] or {}
	local SOS = cfg['sos'] or {}
	local ColoredName = C.FUNC.UNIT.ColoredName
	local UnitName, GetSpellLink = UnitName, GetSpellLink
	local GetSpellTexture = GetSpellTexture
	local print, tremove, pairs, unpack = print, tremove, pairs, unpack

	local function Finished(self)
		self.parent:Hide()
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
			AG.fadeIn:SetDuration(.1)
			AG.fadeIn:SetOrder(1)
			AG.moveIn = AG:CreateAnimation('Translation')
			AG.moveIn:SetSmoothing('OUT_IN')
			AG.moveIn:SetDuration(.1)
			AG.moveIn:SetOrder(1)

			AG.moveStay = AG:CreateAnimation('Translation')
			AG.moveStay:SetDuration(.4)
			AG.moveStay:SetOrder(2)

			AG.fadeOut = AG:CreateAnimation('Alpha')
			AG.fadeOut:SetChange(-1)
			AG.fadeOut:SetDuration(.1)
			AG.fadeOut:SetOrder(3)
			AG.moveOut = AG:CreateAnimation('Translation')
			AG.moveOut:SetSmoothing('OUT_IN')
			AG.moveOut:SetDuration(.1)
			AG.moveOut:SetOrder(3)
			
			AG.parent = frame
			AG:SetScript('OnFinished', Finished)
		return AG
	end

	local function CreateAni_FADE(frame)
		local AG = frame:CreateAnimationGroup()
			AG.fadeIni = AG:CreateAnimation('Alpha')
			AG.fadeIni:SetChange(-1)
			AG.fadeIni:SetDuration(0)
			AG.fadeIni:SetOrder(0)
			AG.fadeIn = AG:CreateAnimation('Alpha')
			AG.fadeIn:SetChange(1)
			AG.fadeIn:SetDuration(.2)
			AG.fadeIn:SetOrder(1)
			AG.fadeOut = AG:CreateAnimation('Alpha')
			AG.fadeOut:SetStartDelay(.5)
			AG.fadeOut:SetChange(-1)
			AG.fadeOut:SetDuration(.3)
			AG.fadeOut:SetOrder(2)
			AG.parent = frame
			AG:SetScript('OnFinished', Finished)
		return AG
	end

	local function CreateAni_Scroll(frame)
		local AG = frame:CreateAnimationGroup()
			AG.fadeIni = AG:CreateAnimation('Alpha')
			AG.fadeIni:SetDuration(0)
			AG.fadeIni:SetChange(-1)
			AG.fadeIni:SetOrder(0)
			AG.moveIni = AG:CreateAnimation('Translation')
			AG.moveIni:SetDuration(0)
			AG.moveIni:SetOffset(0, 0)
			AG.moveIni:SetOrder(0)

			AG.moveUp = AG:CreateAnimation('Translation')
			AG.moveUp:SetDuration(3)
			AG.moveUp:SetOffset(0, 140)
			AG.moveUp:SetOrder(1)
			AG.moveUp:SetSmoothing('OUT_IN')

			AG.fadeIn = AG:CreateAnimation('Alpha')
			AG.fadeIn:SetDuration(.1)
			AG.fadeIn:SetChange(1)
			AG.fadeIn:SetOrder(1)

			AG.fadeOut = AG:CreateAnimation('Alpha')
			AG.fadeOut:SetStartDelay(2.75)
			AG.fadeOut:SetDuration(.25)
			AG.fadeOut:SetChange(-1)
			AG.fadeOut:SetOrder(1)

			AG.parent = frame
			AG:SetScript('OnFinished', Finished)
		return AG
	end



	local CombatEvent = CreateFrame('Frame', 'CombatEvent', C)
		CombatEvent:RegisterEvent('PLAYER_LOGIN')
		CombatEvent:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
		--CombatEvent:Hide()
		CombatEvent.EVENT_FRAME = {}
		CombatEvent.EVENT_CACHE = {
			['notification'] = setmetatable({}, {__mode = 'kv'}),
			['player'] = setmetatable({}, {__mode = 'kv'}),
			['playersub'] = setmetatable({}, {__mode = 'kv'}),
			['target'] = setmetatable({}, {__mode = 'kv'}),
			['targetsub'] = setmetatable({}, {__mode = 'kv'}),
			['focus'] = setmetatable({}, {__mode = 'kv'}),
			['focussub'] = setmetatable({}, {__mode = 'kv'}),
			['targettarget'] = setmetatable({}, {__mode = 'kv'}),
			['targettargetsub'] = setmetatable({}, {__mode = 'kv'}),
			['pet'] = setmetatable({}, {__mode = 'kv'}),
			['petsub'] = setmetatable({}, {__mode = 'kv'}),
			['playerscroll'] = setmetatable({}, {__mode = 'kv'}),
			['targetscroll'] = setmetatable({}, {__mode = 'kv'})
		}

	local function CheckDisplayCache(self)
		if #self.cache == 0 then return end
		CombatEvent:Display(self, unpack(self.cache[1]))
		tremove(self.cache, 1)
	end

	local function CreateDisplay(parent, align1, align2, x, y, factor, scale)
		local frame = Frame(nil, parent, align1, parent, align2, x*factor, y, 20, 20)
			frame:Hide()
			frame:SetScale(scale)
			frame:SetFrameLevel(11)
			frame.icon = Icon(frame, 20, 'ARTWORK')
			frame.shadow = DropShadow(frame)
			frame.shadow:SetBackdropBorderColor(0, 0, 0, 1)
			frame.amount = String(frame, align1, frame, align2, 4*factor, 0, cfg.font, 20, 'THICKOUTLINE')
			frame.spellname = String(frame, align1, frame, align2, 4*factor, 0, cfg.spellname_font, 18, cfg.spellname_fontFlag)
			frame.IN = CreateAni_H(frame)
			frame.IN.moveIni:SetOffset(10*factor, 0)
			frame.IN.moveIn:SetOffset(-10*factor, 0)
			frame.IN.moveStay:SetOffset(-2*factor, 0)
			frame.IN.moveOut:SetOffset(-10*factor, 0)
			frame.OUT = CreateAni_H(frame)
			frame.OUT.moveIni:SetOffset(-10*factor, 0)
			frame.OUT.moveIn:SetOffset(10*factor, 0)
			frame.OUT.moveStay:SetOffset(2*factor, 0)
			frame.OUT.moveOut:SetOffset(10*factor, 0)
			frame:SetScript('OnHide', CheckDisplayCache)
		return frame
	end

	local function UpdateNotification(self, elapsed)
		local a, b, c, x, y = self:GetPoint()
		self:SetPoint(a, b, c, x, 1+y)
	end

	local function ResetNotification(self)
		self:SetPoint('CENTER', UIParent, 'CENTER', 0, self.offset)
	end

	local function CreateNotification(offset)
		local frame = Frame(nil, C)
			frame:SetSize(1, 1)
			frame:SetFrameLevel(11)
			frame.offset = offset
			frame.text = String(frame, 'CENTER', frame, 'CENTER', 0, 0, cfg.spellname_font, 16, cfg.spellname_fontFlag)
			frame.FADE = CreateAni_FADE(frame)
			frame:Hide()
			frame:SetScript('OnShow', ResetNotification)
			frame:SetScript('OnHide', CheckDisplayCache)
			frame:SetScript('OnUpdate', UpdateNotification)
		return frame
	end

	CombatEvent.EVENT_FRAME['notification'] = CreateNotification(140)
	CombatEvent.EVENT_FRAME['notification'].cache = CombatEvent.EVENT_CACHE['notification']
	CombatEvent.EVENT_FRAME['player'] = CreateDisplay(C.UNITFRAME.Major['player'], 'LEFT', 'RIGHT', 0, -11, 1, 1)
	CombatEvent.EVENT_FRAME['player'].cache = CombatEvent.EVENT_CACHE['player']
	CombatEvent.EVENT_FRAME['playersub'] = CreateDisplay(C.UNITFRAME.Major['player'], 'LEFT', 'RIGHT', 12, -62, 1, .8)
	CombatEvent.EVENT_FRAME['playersub'].cache = CombatEvent.EVENT_CACHE['playersub']
	CombatEvent.EVENT_FRAME['target'] = CreateDisplay(C.UNITFRAME.Major['target'], 'RIGHT', 'LEFT', 0, -11, -1, 1)
	CombatEvent.EVENT_FRAME['target'].cache = CombatEvent.EVENT_CACHE['target']
	CombatEvent.EVENT_FRAME['targetsub'] = CreateDisplay(C.UNITFRAME.Major['target'], 'RIGHT', 'LEFT', 12, -62, -1, .8)
	CombatEvent.EVENT_FRAME['targetsub'].cache = CombatEvent.EVENT_CACHE['targetsub']
	CombatEvent.EVENT_FRAME['focus'] = CreateDisplay(C.UNITFRAME.Minor['focus'], 'LEFT', 'RIGHT', 0, -10, 1, .8)
	CombatEvent.EVENT_FRAME['focus'].cache = CombatEvent.EVENT_CACHE['focus']
	CombatEvent.EVENT_FRAME['focussub'] = CreateDisplay(C.UNITFRAME.Minor['focus'], 'LEFT', 'RIGHT', 12, -56, 1, .8)
	CombatEvent.EVENT_FRAME['focussub'].cache = CombatEvent.EVENT_CACHE['focussub']
	CombatEvent.EVENT_FRAME['targettarget'] = CreateDisplay(C.UNITFRAME.Minor['targettarget'], 'RIGHT', 'LEFT', 0, -10, -1, .8)
	CombatEvent.EVENT_FRAME['targettarget'].cache = CombatEvent.EVENT_CACHE['targettarget']
	CombatEvent.EVENT_FRAME['targettargetsub'] = CreateDisplay(C.UNITFRAME.Minor['targettarget'], 'RIGHT', 'LEFT', 12, -56, -1, .8)
	CombatEvent.EVENT_FRAME['targettargetsub'].cache = CombatEvent.EVENT_CACHE['targettargetsub']
	CombatEvent.EVENT_FRAME['pet'] = CreateDisplay(C.UNITFRAME.Minor['pet'], 'LEFT', 'RIGHT', 0, -10, 1, .8)
	CombatEvent.EVENT_FRAME['pet'].cache = CombatEvent.EVENT_CACHE['pet']
	CombatEvent.EVENT_FRAME['petsub'] = CreateDisplay(C.UNITFRAME.Minor['pet'], 'LEFT', 'RIGHT', 12, -56, 1, .8)
	CombatEvent.EVENT_FRAME['petsub'].cache = CombatEvent.EVENT_CACHE['petsub']

	local function CheckScrollCache(self)
		if #self.cache == 0 then return end
		CombatEvent:DisplayScroll(self, unpack(self.cache[1]))
		tremove(self.cache, 1)
	end

	local function CreateScroll(parent, align1, align2, x, y, factor)
		local frame = Frame(nil, parent, align1, parent, align2, x*factor, y, 16, 16)
			frame:Hide()
			frame.icon = Icon(frame, 16, 'ARTWORK')
			frame.shadow = DropShadow(frame)
			frame.amount = String(frame, align2, frame, align1, -2*factor, 0, cfg.font, cfg.fontSize-4, cfg.fontFlag, 0, 0)
			frame.text = String(frame, align1, frame, align2, 2*factor, 0, cfg.spellname_font, cfg.fontSize-4, cfg.fontFlag, 0, 0)
			frame.UP = CreateAni_Scroll(frame)
		return frame
	end

	for i = 1, 10 do
		CombatEvent.EVENT_FRAME['playerscroll'..i] = CreateScroll(C.UNITFRAME.Major['player'], 'RIGHT', 'LEFT', 10, -10, -1)
		CombatEvent.EVENT_FRAME['playerscroll'..i].cache = CombatEvent.EVENT_CACHE['playerscroll']
		CombatEvent.EVENT_FRAME['targetscroll'..i] = CreateScroll(C.UNITFRAME.Major['target'], 'LEFT', 'RIGHT', 10, -10, 1)
		CombatEvent.EVENT_FRAME['targetscroll'..i].cache = CombatEvent.EVENT_CACHE['targetscroll']
	end



	local function GetSpellIcon(spellID)
		return ('|T%s:0|t'):format(GetSpellTexture(spellID))
	end
	CombatEvent.GetSpellIcon = GetSpellIcon

	function CombatEvent:GetUnitChannel(unit)
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

	local SendChatMessage = SendChatMessage
	function CombatEvent:AddMessage(channel, text, ...)
		if not channel then return end
		SendChatMessage(text:format(...), channel, nil)
	end

	function CombatEvent:AddNotice(r, g, b, text, ...)
		CombatEvent.EVENT_FRAME['notification'].text:SetText(text:format(...))
		CombatEvent.EVENT_FRAME['notification'].text:SetTextColor(r, g, b)
		CombatEvent.EVENT_FRAME['notification']:Show()
		CombatEvent.EVENT_FRAME['notification']['FADE']:Play()
	end

	function CombatEvent:GetNextDisplay_(unit)
		local frame, counter = nil, nil
		for i = 1, 3 do
			frame = self.EVENT_FRAME[unit..i]
			counter = i
			if not frame:IsShown() then
				break
			else
				frame:SetFrameLevel(8+i)
				frame:SetAlpha(.33)
			end
		end
		return self.EVENT_FRAME[unit..(counter==3 and 1 or counter)]
	end

	function CombatEvent:Display(frame, animation, iconID, spellname, amount, r, g, b)
		frame.icon:SetTexture(GetSpellTexture(iconID))
		frame.spellname:SetText(spellname)
		frame.spellname:SetTextColor(r, g, b)
		frame.amount:SetText(amount)
		frame.amount:SetTextColor(r, g, b)
		frame[animation]:Play()
		frame:Show()
	end

	function CombatEvent:UpdateDisplay(frame)
		if self.EVENT_FRAME[frame]:IsShown() then return end
		CheckDisplayCache(self.EVENT_FRAME[frame])
	end

	function CombatEvent:DisplayScroll(frame, iconID, text, amount, r, g, b)
		frame.icon:SetTexture(GetSpellTexture(iconID))
		frame.amount:SetText(amount)
		frame.amount:SetTextColor(r, g, b)
		frame.text:SetText(text)
		frame.text:SetTextColor(r, g, b)
		frame.UP:Play()
		frame:Show()
	end

	function CombatEvent:UpdateScroll(frame)
		for i = 1, 10 do
			if not self.EVENT_FRAME[frame..i]:IsShown() then
				CheckScrollCache(self.EVENT_FRAME[frame..i])
				break
			end
		end
	end

	function CombatEvent:ResetScroll(frame)
		for i = 1, 10 do
			self.EVENT_FRAME[frame..i]:Hide()
			self.EVENT_FRAME[frame..i].UP:Stop()
		end
	end

	local function CombatEvent_OnUpdate(self, elapsed)
		self.elapsed = elapsed + (self.elapsed or 0)
		if self.elapsed < .3 then return end
		self.elapsed = nil
		if not C.UNITFRAME.Major['target']:IsShown() then
			wipe(self.EVENT_CACHE['targetscroll'])
			self:ResetScroll('targetscroll')
		end
		self:UpdateScroll('playerscroll')
		self:UpdateScroll('targetscroll')
	end
	CombatEvent:SetScript('OnUpdate', CombatEvent_OnUpdate)

	local flags = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_GUARDIAN)
	function CombatEvent:COMBAT_LOG_EVENT_UNFILTERED(timeStamp, combatEvent, hideCaster, sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, spellID, spellName, ...)
		if combatEvent == 'SPELL_AURA_APPLIED' and SOS[spellID] then
			self:AddMessage(self.CHANNEL, '[%s] > %s', sourceName, GetSpellLink(spellID))
			return
		end
		if sourceGUID ~= C.UNIT['player'] and sourceGUID ~= C.UNIT['pet'] and destGUID ~= C.UNIT['player'] and destGUID ~= C.UNIT['pet'] and sourceFlags1 ~= flags then return end
		self.CLEU[combatEvent](self, sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, spellID, spellName, ...)
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

	local collectgarbage = collectgarbage
	function CombatEvent:PLAYER_REGEN_ENABLED()
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
		self:RegisterEvent('PLAYER_REGEN_DISABLED')
		self:AddNotice(0, 1, 0, '- COMBAT -')
		collectgarbage('collect')
		if self.HideFriendlyNameplatesInCombat then
			SetCVar('nameplateShowFriends', 1)
		end
	end

	function CombatEvent:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, rank, line, spellID)
		if not unit then return end
		if not COMMON[spellID] then return end
		self:AddNotice(1, 1, 1, '%s > %s%s', ColoredName(unit), GetSpellIcon(spellID), spellName)
		self:AddMessage(self:GetUnitChannel(unit), '[%s] > %s', UnitName(unit), GetSpellLink(spellID))
		return	
	end

	function CombatEvent:ITEM_PUSH(bagID, itemIcon)
		self:AddNotice(1, 1, 1, ('|T%s:0|t'):format(itemIcon))
	end

	function CombatEvent:UI_INFO_MESSAGE(...)
		self:AddNotice(1, 1, 0, ...)
	end

	local IsInGroup, IsInRaid = IsInGroup, IsInRaid
	local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
	function CombatEvent:GROUP_ROSTER_UPDATE()
		local NAMEPLATE = C.NAMEPLATE
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			self.CHANNEL = 'INSTANCE_CHAT'
			if IsInRaid() then
				NAMEPLATE.group = 'raid%d'
			else
				NAMEPLATE.group = 'party%d'
			end
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
		self:RegisterEvent('UI_INFO_MESSAGE')
		self:RegisterEvent('ITEM_PUSH')
		self:UnregisterEvent('PLAYER_LOGIN')
		self.HideFriendlyNameplatesInCombat = ConceptionCFG['HideFriendlyNameplatesInCombat']
		self:GROUP_ROSTER_UPDATE()
	end

	C.COMBATEVENT = CombatEvent
end