local C, D = unpack(select(2,...))

function D.LOAD.E:LoadCombatEventCLEU()
	local AURA = D.CFG.COMBAT_EVENT['aura'] or {}
	local SELF = D.CFG.COMBAT_EVENT['self'] or {}
	local DoNothing = D.API.dummy
	local ColoredName = C.FUNC.UNIT.ColoredName
	local GetSpellIcon = C.COMBATEVENT.GetSpellIcon
	local GetSpellLink, PlaySoundFile, select = GetSpellLink, PlaySoundFile, select

	local COLOR = setmetatable({
		[0] = {r=.382,g=.382,b=.382},
		[1] = {r=.618,g=.618,b=.618},
		[2] = {r=.618,g=.618,b=.000},
		[3] = {r=.618,g=.382,b=.000},
		[4] = {r=.191,g=.618,b=.191},
		[5] = {r=.382,g=.618,b=.618},
		[6] = {r=.382,g=.382,b=.618},
		[7] = {r=.618,g=.382,b=.618},
		['HEAL'] = {r=.000,g=.618,b=.000},
		['INTERRUPT'] = {r=.000,g=.382,b=.618}
	}, {__call = function(self, key)
		if self[key] then
			return self[key].r, self[key].g, self[key].b
		else
			return self[0].r, self[0].g, self[0].b
		end
	end})

	local RT = {[1] = 1, [2] = 2, [4] = 3, [8] = 4, [16] = 5, [32] = 6, [64] = 7, [128] = 8}

	local bitband = bit.band
	local function GetRaidTargetIcon(unitFlags2, path)
		local i = bitband(unitFlags2, 255) -- bit.band(unitFlags, COMBATLOG_OBJECT_RAIDTARGET_MASK)
		if not RT[i] then return '' end
		i = RT[i]
		if path then
			return ('|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_%d:0|t'):format(i)
		else
			return ('{rt%d}'):format(i)
		end
	end

	local UNIT = setmetatable(C.UNIT, {
		__call = function(self, guid)
		if self['player'] == guid then
			return 'player'
		elseif self['target'] == guid then
			return 'target'
		elseif self['focus'] == guid then
			return 'focus'
		elseif self['targettarget'] == guid then
			return 'targettarget'
		else
			return
		end
	end})

	local function GetDisplayFrame(guid, major)
		local unit = UNIT(guid)
		if unit then
			return unit..(major and '' or 'sub')
		end
	end

	local function AuraApplied(self, sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, spellID, spellName, spellSchool, auraType)
		self:Display(GetDisplayFrame(destGUID, true), 'IN', spellID, spellName, nil, COLOR(spellSchool))
		if destGUID == UNIT['player'] then
			if sourceGUID == UNIT['player'] then -- 自己上自己
				if not SELF[spellID] then return end -- 過濾
				self:AddNotice(0, 1, 0, '+ %s%s +', GetSpellIcon(spellID), spellName)
				self:AddMessage(self.CHANNEL, '%s ACTIVATE', GetSpellLink(spellID))
				return
			else -- 別人上我
				if sourceName then
					self:AddNotice(1, 1, 0, '+ %s%s [%s] +', GetSpellIcon(spellID), spellName, ColoredName(sourceName))
				else
					self:AddNotice(1, 1, 0, '+ %s%s +', GetSpellIcon(spellID), spellName)
				end
				return
			end
		else -- 我放在其他人身上
			if not AURA[spellID] then return end -- 過濾
			self:AddNotice(1, 1, 0, '%s%s > %s[%s]', GetSpellIcon(spellID), spellName, GetRaidTargetIcon(destFlags2, true), ColoredName(destName))
			self:AddMessage(self.CHANNEL, '%s > %s[%s]', GetSpellLink(spellID), GetRaidTargetIcon(destFlags2, false), destName)
		end
	end

	local function AuraRemoved(self, sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, spellID, spellName, spellSchool, auraType)
		self:Display(GetDisplayFrame(destGUID), 'OUT', spellID, spellName, nil, COLOR(spellSchool))
		if destGUID == UNIT['player'] then
			if sourceGUID == UNIT['player'] then
				if not SELF[spellID] then return end
				self:AddNotice(1, 0, 0, ' - %s%s -', GetSpellIcon(spellID), spellName)
				self:AddMessage(self.CHANNEL, '%s DEACTIVATE', GetSpellLink(spellID))
				return
			else
				if sourceName then
					self:AddNotice(1, 1, 0, '- %s%s [%s] -', GetSpellIcon(spellID), spellName, ColoredName(sourceName))
				else
					self:AddNotice(1, 1, 0, '- %s%s -', GetSpellIcon(spellID), spellName)
				end
				return
			end
		else
			if not AURA[spellID] then return end
			self:AddNotice(1, 0, 0, '%s%s DEACTIVATE %s[%s]', GetSpellIcon(spellID), spellName, GetRaidTargetIcon(destFlags2, true), ColoredName(destName))
			self:AddMessage(self.CHANNEL, '%s DEACTIVATE %s[%s]', GetSpellLink(spellID), GetRaidTargetIcon(destFlags2, false), destName)
		end
	end

	local function Attacked(self, sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, spellID, spellName, spellSchool, amount, overKill, school, resisted, blocked, absorbed, critical)
		if critical then
			return self:Display(GetDisplayFrame(destGUID, true), 'IN', spellID, nil, amount, COLOR(school))
		end
	end

	local function AttackMissed(self, sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, spellID, spellName, spellSchool, missType, isOffHand, amountMissed)
		return self:Display(GetDisplayFrame(destGUID, true), 'OUT', spellID, nil, missType, COLOR(spellSchool))
	end

	local function Healed(self, sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, spellID, spellName, spellSchool, amount, overKill, school, resisted, blocked, absorbed, critical)
		return self:Display(GetDisplayFrame(destGUID, true), 'IN', spellID, nil, amount, COLOR('HEAL'))
	end

	local CLEU = setmetatable({}, {__index = function() return DoNothing end})
		CLEU['SPELL_AURA_APPLIED'] = AuraApplied
		CLEU['SPELL_AURA_REMOVED'] = AuraRemoved
		CLEU['SPELL_AURA_APPLIED_DOSE'] = AuraApplied
		CLEU['SPELL_AURA_REMOVED_DOES'] = AuraRemoved
		CLEU['SPELL_AURA_REFRESH'] = AuraApplied
		CLEU['SPELL_AURA_BROKEN'] = AuraRemoved
		CLEU['RANGE_DAMAGE'] = Attacked
		CLEU['RANGE_MISSED'] = AttackMissed
		CLEU['SPELL_DAMAGE'] = Attacked
		CLEU['SPELL_HEAL'] = Healed
		CLEU['SPELL_MISSED'] = AttackMissed
		CLEU['SPELL_PERIODIC_DAMAGE'] = Attacked
		CLEU['SPELL_PERIODIC_HEAL'] = Healed
		CLEU['SPELL_PERIODIC_MISSED'] = AttackMissed


	function CLEU:SWING_DAMAGE(sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, amount, overKill, school, resisted, blocked, absorbed, critical, glancing, crushing)
		return Attacked(self, sourceGUID, _, _, _, destGUID, _, _, _, 46917, _, 1, amount, overKill, school, resisted, blocked, absorbed, critical  or crushing)
	end

	function CLEU:SWING_MISSED(sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, missType)
		return AttackMissed(self, sourceGUID, _, _, _, destGUID, _, _, _, 46917, _, 1, missType)
	end

	function CLEU:ENVIRONMENTAL_DAMAGE(sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, environmentalType, amount, overKill, spellSchool, resisted, blocked, absorbed, critical)
		return Attacked(self, sourceGUID, _, _, _, destGUID, _, _, _, 46917, _, 1, amount, _, _, _, _, _, 1)
	end

	function CLEU:SPELL_INTERRUPT(sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, spellID, spellName, spellSchool, extraSpellID, extraSpellName, extraSchool)
		self:Display(GetDisplayFrame(destGUID, true), 'IN', spellID, nil, 'INTERRUPT', COLOR('INTERRUPT'))
		self:AddNotice(1, 1, 1, 'INTERRUPTED %s%s - %s[%s]', GetSpellIcon(extraSpellID), extraSpellName, GetRaidTargetIcon(destFlags2, true), ColoredName(destName))
		if sourceGUID ~= UNIT['player'] then
			return
		end
		self:AddMessage(self.CHANNEL, 'INTERRUPTED %s - %s[%s]', GetSpellLink(extraSpellID), GetRaidTargetIcon(destFlags2, false), destName)
	end

	--function CLEU:SPELL_CAST_SUCCESS(sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, spellID, spellName)
	--	self:AddMessage(self.CHANNEL, '%s%s > [%s]', sourceName, GetSpellLink(spellID), destName or '')
		--print( ('%s%s > [%s]'):format(sourceName, GetSpellLink(spellID), destName or '') )
	--end

	C.COMBATEVENT.CLEU = CLEU
end