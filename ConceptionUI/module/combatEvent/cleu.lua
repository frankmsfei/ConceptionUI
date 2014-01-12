local C, D = unpack(select(2,...))

function D.LOAD.E:LoadCombatEventCLEU()
	local AURA = D.CFG.COMBAT_EVENT['aura'] or {}
	local SELF = D.CFG.COMBAT_EVENT['self'] or {}
	local CLEU = setmetatable({}, {__index = function() return function() end end})

	local COLOR = setmetatable({
		[SCHOOL_MASK_NONE]     = {r=.191,g=.191,b=.191},
		[SCHOOL_MASK_PHYSICAL] = {r=.618,g=.000,b=.000},
		[SCHOOL_MASK_HOLY]     = {r=.618,g=.618,b=.000},
		[SCHOOL_MASK_FIRE]     = {r=.618,g=.382,b=.000},
		[SCHOOL_MASK_NATURE]   = {r=.191,g=.618,b=.191},
		[SCHOOL_MASK_FROST]    = {r=.382,g=.618,b=.618},
		[SCHOOL_MASK_SHADOW]   = {r=.382,g=.382,b=.618},
		[SCHOOL_MASK_ARCANE]   = {r=.618,g=.382,b=.618}
 	}, {__call = function(self, key) return self[key].r, self[key].g, self[key].b end})

	local ColoredName = C.FUNC.UNIT.ColoredName
	local GetSpellIcon = C.COMBATEVENT.GetSpellIcon

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

	local GetSpellLink, PlaySoundFile, select = GetSpellLink, PlaySoundFile, select 
	function CLEU:SPELL_INTERRUPT(sourceGUID, _, _, _, destGUID, destName, _, destFlags2, _, _, _, spellID, spellName)
		if sourceGUID ~= self.PLAYER then
			return
		end
		self:Display('TargetSubEvent', 'IN', spellID, nil, 'INTERRUPT', 0, 0, 1)
		self:AddNotice(1, 1, 1, 'INTERRUPTED %s%s - %s[%s]', GetSpellIcon(spellID), spellName, GetRaidTargetIcon(destFlags2, true), ColoredName(destName))
		self:AddMessage(self.CHANNEL, 'INTERRUPTED %s - %s[%s]', GetSpellLink(spellID), GetRaidTargetIcon(destFlags2, false), destName)
	end


	local function AuraApplied(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName, spellSchool, auraType)
		if destGUID == self.PLAYER then
			if sourceGUID == self.PLAYER then -- 上自己Buff
				if auraType ~= 'BUFF' then
					return -- 忽略Debuff
				end
				self:Display('PlayerEvent', 'IN', spellID, spellName, nil, COLOR(spellSchool))
				if not SELF[spellID] then
					return
				end
				self:AddNotice(0, 1, 0, '+ %s%s +', GetSpellIcon(spellID), spellName)
				self:AddMessage(self.CHANNEL, '%s ACTIVATE', GetSpellLink(spellID))
				return
			else -- 別人上我BUFF
				if sourceName then
					self:AddNotice(1, 1, 0, '+ %s%s [%s] +', GetSpellIcon(spellID), spellName, ColoredName(sourceName))
				else
					self:AddNotice(1, 1, 0, '+ %s%s +', GetSpellIcon(spellID), spellName)
				end
				self:Display('PlayerSubEvent', 'IN', spellID, spellName, nil, COLOR(spellSchool))
				return
			end
		else -- 我放在其他人身上
			if destGUID == C.UNITFRAME.Major['target'].guid then
				self:Display('TargetSubEvent', 'IN', spellID, spellName, nil, COLOR(spellSchool))
			end
			if not AURA[spellID] then
				return
			end
			self:AddNotice(1, 1, 0, '%s%s > %s[%s]', GetSpellIcon(spellID), spellName, GetRaidTargetIcon(destFlags2, true), ColoredName(destName))
			self:AddMessage(self.CHANNEL, '%s > %s[%s]', GetSpellLink(spellID), GetRaidTargetIcon(destFlags2, false), destName)
		end
	end

	function CLEU:SPELL_AURA_APPLIED(sourceGUID, sourceName, _, _, destGUID, destName, _, destFlags2, spellID, spellName, spellSchool, auraType)
		AuraApplied(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName, spellSchool, auraType)
	end

	function CLEU:SPELL_AURA_APPLIED_DOSE(sourceGUID, sourceName, _, _, destGUID, destName, _, destFlags2, spellID, spellName, spellSchool, auraType)
		AuraApplied(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName, spellSchool, auraType)
	end

	function CLEU:SPELL_AURA_REFRESH(sourceGUID, sourceName, _, _, destGUID, destName, _, destFlags2, spellID, spellName, spellSchool, auraType)
		AuraApplied(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName, spellSchool, auraType)
	end


	local function AuraRemoved(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName, spellSchool)
		if destGUID == self.PLAYER then
			if sourceGUID == self.PLAYER then
				--if auraType ~= 'BUFF' then
					--return -- 忽略Debuff
				--end
				self:Display('PlayerSubEvent', 'OUT', spellID, spellName, nil, COLOR(spellSchool))
				if not SELF[spellID] then
					return
				end
				self:AddNotice(1, 0, 0, ' - %s%s -', GetSpellIcon(spellID), spellName)
				self:AddMessage(self.CHANNEL, '%s DEACTIVATE', GetSpellLink(spellID))
				return
			else
				if sourceName then
					self:AddNotice(1, 1, 0, '- %s%s [%s] -', GetSpellIcon(spellID), spellName, ColoredName(sourceName))
				else
					self:AddNotice(1, 1, 0, '- %s%s -', GetSpellIcon(spellID), spellName)
				end
				self:Display('PlayerSubEvent', 'OUT', spellID, spellName, nil, COLOR(spellSchool))
				return
			end
		else -- sourceGUID == self.PLAYER
			if destGUID == C.UNITFRAME.Major['target'].guid then
				self:Display('TargetSubEvent', 'OUT', spellID, spellName, nil, COLOR(spellSchool))
			end
			if not AURA[spellID] then
				return
			end
			self:AddNotice(1, 0, 0, '%s%s DEACTIVATE %s[%s]', GetSpellIcon(spellID), spellName, GetRaidTargetIcon(destFlags2, true), ColoredName(destName))
			--self:AddMessage(self.CHANNEL, )
		end
	end

	function CLEU:SPELL_AURA_REMOVED(sourceGUID, sourceName, _, _, destGUID, destName, _, destFlags2, spellID, spellName, spellSchool)
		AuraRemoved(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName, spellSchool)
	end

	function CLEU:SPELL_AURA_REMOVED_DOES(sourceGUID, sourceName, _, _, destGUID, destName, _, destFlags2, spellID, spellName, spellSchool)
		AuraRemoved(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName, spellSchool)
	end

	function CLEU:SPELL_AURA_BROKEN(sourceGUID, sourceName, _, _, destGUID, destName, _, destFlags2, spellID, spellName, spellSchool)
		AuraRemoved(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName, spellSchool)
	end


	local function AttackMissed(self, sourceGUID, destGUID, spellID, spellSchool, missType)
		if sourceGUID == self.PLAYER then
			if destGUID == C.UNITFRAME.Major['target'].guid then
				self:Display('TargetEvent', 'OUT', spellID, nil, missType, COLOR(spellSchool))
			end
			return
		else
			self:Display('PlayerEvent', 'OUT', spellID, nil, missType, COLOR(spellSchool))
			return
		end
	end

	function CLEU:SWING_MISSED(sourceGUID, _, _, _, destGUID, _, _, _, missType)
		AttackMissed(self, sourceGUID, destGUID, 46917, 1, missType)
	end

	function CLEU:RANGE_MISSED(sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, spellSchool, missType)
		AttackMissed(self, sourceGUID, destGUID, spellID, spellSchool, missType)
	end

	function CLEU:SPELL_MISSED(sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, spellSchool, missType)
		AttackMissed(self, sourceGUID, destGUID, spellID, spellSchool, missType)
	end

	function CLEU:SPELL_PERIODIC_MISSED(sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, spellSchool, missType)
		AttackMissed(self, sourceGUID, destGUID, spellID, spellSchool, missType)
	end

	local function Attacked(self, sourceGUID, destGUID, spellID, spellSchool, amount, crit)
		if not crit then return end
		if sourceGUID == self.PLAYER then
			if destGUID == C.UNITFRAME.Major['target'].guid then
				self:Display('TargetEvent', 'IN', spellID, nil, amount, COLOR(spellSchool))
				return
			elseif destGUID == self.PLAYER then
				self:Display('PlayerEvent', 'IN', spellID, nil, amount, COLOR(spellSchool))
				return
			end
		elseif destGUID == self.PLAYER then
			self:Display('PlayerEvent', 'IN', spellID, nil, amount, COLOR(spellSchool))
			return
		end
	end

	function CLEU:SWING_DAMAGE(sourceGUID, _, _, _, destGUID, _, _, _, amount, _, spellSchool, _, _, _, crit)
		Attacked(self, sourceGUID, destGUID, 46917, spellSchool, amount, crit)
	end

	function CLEU:RANGE_DAMAGE(sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, spellSchool, amount, _, _, _, _, _, crit)
		Attacked(self, sourceGUID, destGUID, spellID, spellSchool, amount, crit)
	end

	function CLEU:SPELL_DAMAGE(sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, spellSchool, amount, _, _, _, _, _, crit)
		Attacked(self, sourceGUID, destGUID, spellID, spellSchool, amount, crit)
	end

	function SPELL_PERIODIC_DAMAGE(sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, spellSchool, amount, _, _, _, _, _, crit)
		Attacked(self, sourceGUID, destGUID, spellID, spellSchool, amount, crit)
	end

	function SPELL_BUILDING_DAMAGE(sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, spellSchool, amount, _, _, _, _, _, crit)
		Attacked(self, sourceGUID, destGUID, spellID, spellSchool, amount, crit)
	end

	function CLEU:ENVIRONMENTAL_DAMAGE(sourceGUID, _, _, _, destGUID, _, _, _, type, amount, _, _, _, _, _, crit)
		Attacked(self, sourceGUID, destGUID, 46917, 1, ('%d(%s)'):format(amount, type), 1)
	end

	C.COMBATEVENT.CLEU = CLEU
end