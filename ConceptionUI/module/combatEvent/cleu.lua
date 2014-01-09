local C, D = unpack(select(2,...))

function D.LOAD.E:LoadCombatEventCLEU()
	local AURA = D.CFG.COMBAT_EVENT['aura'] or {}
	local SELF = D.CFG.COMBAT_EVENT['self'] or {}
	local CLEU = setmetatable({}, {__index = function() return function() end end})

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
		self:Display('TargetSubEvent', 'IN', spellID, 'INTERRUPT', 0, 0, 1)
		self:AddNotice(1, 1, 1, 'INTERRUPTED %s%s - %s[%s]', GetSpellIcon(spellID), spellName, GetRaidTargetIcon(destFlags2, true), ColoredName(destName))
		self:AddMessage(self.CHANNEL, 'INTERRUPTED %s - %s[%s]', GetSpellLink(spellID), GetRaidTargetIcon(destFlags2, false), destName)
	end


	local function AuraApplied(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName, auraType)
		if destGUID == self.PLAYER then
			if sourceGUID == self.PLAYER then -- 上自己Buff
				if auraType ~= 'BUFF' then
					return -- 忽略Debuff
				end
				self:Display('PlayerEvent', 'IN', spellID, spellName, 1, 1, 0)
				if not SELF[spellID] then
					return
				end
				self:AddNotice(0, 1, 0, '+ %s%s +', GetSpellIcon(spellID), spellName)
				self:AddMessage(self.CHANNEL, '%s ACTIVATE', GetSpellLink(spellID))
				return
			else -- 別人上我BUFF
				self:AddNotice(1, 1, 0, '+ %s%s [%s] +', GetSpellIcon(spellID), spellName, ColoredName(sourceName))
				self:Display('PlayerSubEvent', 'IN', spellID, spellName, 1, 1, 0)
				return
			end
		else -- 我放在其他人身上
			self:Display('TargetSubEvent', 'IN', spellID, spellName, 1, 1, 0)
			if not AURA[spellID] then
				return
			end
			self:AddNotice(1, 1, 0, '%s%s > %s[%s]', GetSpellIcon(spellID), spellName, GetRaidTargetIcon(destFlags2, true), ColoredName(destName))
			self:AddMessage(self.CHANNEL, '%s > %s[%s]', GetSpellLink(spellID), GetRaidTargetIcon(destFlags2, false), destName)
		end
	end

	function CLEU:SPELL_AURA_APPLIED(sourceGUID, sourceName, _, _, destGUID, destName, _, destFlags2, spellID, spellName, _, auraType)
		AuraApplied(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName, auraType)
	end

	function CLEU:SPELL_AURA_APPLIED_DOSE(sourceGUID, sourceName, _, _, destGUID, destName, _, destFlags2, spellID, spellName, _, auraType)
		AuraApplied(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName, auraType)
	end

	function CLEU:SPELL_AURA_REFRESH(sourceGUID, sourceName, _, _, destGUID, destName, _, destFlags2, spellID, spellName, _, auraType)
		AuraApplied(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName, auraType)
	end


	local function AuraRemoved(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName)
		if destGUID == self.PLAYER then
			if sourceGUID == self.PLAYER then
				if auraType ~= 'BUFF' then
					return -- 忽略Debuff
				end
				self:Display('PlayerSubEvent', 'OUT', spellID, spellName, 1, 0, 0)
				if not SELF[spellID] then
					return
				end
				self:AddNotice(1, 0, 0, ' - %s%s -', GetSpellIcon(spellID), spellName)
				self:AddMessage(self.CHANNEL, '%s DEACTIVATE', GetSpellLink(spellID))
				return
			else
				self:AddNotice(1, 1, 0, '- %s%s [%s] -', GetSpellIcon(spellID), spellName, ColoredName(sourceName))
				self:Display('PlayerSubEvent', 'OUT', spellID, spellName, 1, 0, 0)
				return
			end
		else -- sourceGUID == self.PLAYER
			self:Display('TargetSubEvent', 'OUT', spellID, spellName, 1, 0, 0)
			if not AURA[spellID] then
				return
			end
			self:AddNotice(1, 0, 0, '%s%s DEACTIVATE %s[%s]', GetSpellIcon(spellID), spellName, GetRaidTargetIcon(destFlags2, true), ColoredName(destName))
			--self:AddMessage(self.CHANNEL, )
		end
	end

	function CLEU:SPELL_AURA_REMOVED(sourceGUID, sourceName, _, _, destGUID, destName, _, destFlags2, spellID, spellName)
		AuraRemoved(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName)
	end

	function CLEU:SPELL_AURA_REMOVED_DOES(sourceGUID, sourceName, _, _, destGUID, destName, _, destFlags2, spellID, spellName)
		AuraRemoved(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName)
	end

	function CLEU:SPELL_AURA_BROKEN(sourceGUID, sourceName, _, _, destGUID, destName, _, destFlags2, spellID, spellName)
		AuraRemoved(self, sourceGUID, sourceName, destGUID, destName, destFlags2, spellID, spellName)
	end


	local function AttackMissed(self, sourceGUID, spellID, missType)
		if sourceGUID == self.PLAYER then
			self:Display('TargetEvent', 'OUT', spellID, missType, 1, 0, 0)
			return
		else
			self:Display('PlayerEvent', 'OUT', spellID, missType, 1, 0, 0)
			return
		end
	end

	function CLEU:SWING_MISSED(sourceGUID, _, _, _, _, _, _, _, missType)
		AttackMissed(self, sourceGUID, 46917, missType)
	end

	function CLEU:RANGE_MISSED(sourceGUID, _, _, _, _, _, _, _, spellID, _, _, missType)
		AttackMissed(self, sourceGUID, spellID, missType)
	end

	function CLEU:SPELL_MISSED(sourceGUID, _, _, _, _, _, _, _, spellID, _, _, missType)
		AttackMissed(self, sourceGUID, spellID, missType)
	end

	function CLEU:SPELL_PERIODIC_MISSED(sourceGUID, _, _, _, _, _, _, _, spellID, _, _, missType)
		AttackMissed(self, sourceGUID, spellID, missType)
	end

	function CLEU:SWING_DAMAGE(_, _, _, _, _, _, _, _, amount)
		self:Display('TargetEvent', 'IN', 46917, amount, 1, 1, 1)
	end


	C.COMBATEVENT.CLEU = CLEU
end