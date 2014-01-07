local C = unpack(select(2, ...))

local Tip = GameTooltip
C.FUNC.AURA = {
	OnEnter = function(self, unit, filter)
		self.anchor:SetScale(2)
		Tip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
		Tip:ClearLines()
		local slot = self:GetAttribute('target-slot')
		if slot then
			Tip:SetInventoryItem('player', slot)
		else
			Tip:SetUnitAura(unit, self:GetID(), filter)
		end
		Tip:Show()
	end,
	OnLeave = function(self)
		self.anchor:SetScale(1)
		Tip:Hide()
	end
}

local AURA = C.AURAFRAME
local function setAura(self, icon, stack, expiration)
	self.icon:SetTexture(icon)
	self.icon.overlay:Show()
	self.shadow:Show()
	self.stack:SetText(stack and stack>1 and stack or '')
	self.expiration = expiration or 0
	if expiration ~= 0 then return end
	self.timer:SetText(nil)
end
local function killAura(self)
	if not self.icon:GetTexture() then return end
	self.icon.overlay:Hide()
	self.shadow:Hide()
	self.expiration = nil
	self.icon:SetTexture(nil)
	self.stack:SetText(nil)
	self.timer:SetText(nil)
end

local UnitAura = UnitAura
local UpdateAura = function(auras, unit, filter)
	for i = 1, #auras do
		local _, _, icon, stack, _, _, expiration, caster, _, _, _, _, boss = UnitAura(unit, i, filter)
		if icon then
			setAura(auras[i], icon, stack, expiration)
		else
			killAura(auras[i])
		end
	end
end

local m, h, d = 1/60, 1/3600, 1/216000
local function time_format(sec)
	if sec < 0 then
		return '', nil
	elseif sec < 1 then
		return '|cFF9E0000%.1f|r', sec
	elseif sec < 60 then				-- seconds
		return '|cFF9E9E00%d|r', sec
	elseif sec < 3600 then				-- minutes
		return '|cFF009E00%.1f|r', m*sec
	elseif sec < 216000 then			-- hours
		return '|cFF9E9E9E%.1f|r', h*sec
	elseif sec < 12960000 then			-- days
		return '|cFF616161%d|r', d*sec
	else
		return '', nil
	end
end

local function UpdateTimer(auras, curTime)
	for i = 1, #auras do
		local expiration = auras[i].expiration
		if not expiration or expiration < 0 then return end -- only count the auras actual display
		auras[i].timer:SetFormattedText(time_format(expiration - curTime))
	end
end

local GetWeaponEnchantInfo, GetInventoryItemTexture = GetWeaponEnchantInfo, GetInventoryItemTexture
local UpdateEnchant = function(auras, curTime)
	local mh, mhExpiration, _, oh, ohExpiration = GetWeaponEnchantInfo()
	--if not mh and not oh then return end
	if mh then
		setAura(auras[1], GetInventoryItemTexture("player", 16))
		auras[1].timer:SetFormattedText(time_format(0.001 * mhExpiration))
	else
		killAura(auras[1])
	end
	if oh then
		setAura(auras[2], GetInventoryItemTexture("player", 17))
		auras[2].timer:SetFormattedText(time_format(0.001 * ohExpiration))
	else
		killAura(auras[2])
	end
end

local GetTime, pairs = GetTime, pairs
local function OnUpdate(self, elapsed)
	self.elapsed = elapsed + (self.elapsed or 0)
	if self.elapsed < .1 then return end
	self.elapsed = 0
	local now = GetTime()
	for _, v in pairs(AURA) do
		UpdateTimer(v, now)
	end
	UpdateAura(AURA['TargetTargetDeBuff'], 'targettarget', 'TARGET|HARMFUL')
	UpdateEnchant(AURA['PlayerTemporarydBuff'], now)
end

local VALID = {['player']=true, ['target']=true, ['focus']=true, ['targettarget']=true}

local	F = CreateFrame('Frame')
	F:RegisterEvent('PLAYER_ENTERING_WORLD')
	F:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)

function F:UNIT_AURA(unit)
	if not VALID[unit] then return end
	if unit=='player' then
		UpdateAura(AURA['PlayerBuff'], unit, 'PLAYER|HELPFUL')
		UpdateAura(AURA['PlayerDeBuff'], unit, 'HARMFUL')
		UpdateAura(AURA['PlayerRaidBuff'], unit, 'HELPFUL')
		return
	elseif unit=='target' then
		UpdateAura(AURA['TargetBuff'], unit, 'HELPFUL')
		UpdateAura(AURA['TargetDeBuff'], unit, 'HARMFUL')
		return
	elseif unit=='focus' then
		UpdateAura(AURA['FocusDeBuff'], unit, 'HARMFUL')
		return
	end
end

function F:UNIT_TARGET(unit)
	if not VALID[unit] then return end
	if unit=='focus' or unit=='targettarget' then return end
	if unit=='player' then
		UpdateAura(AURA['TargetBuff'], 'target', 'HELPFUL')
		UpdateAura(AURA['TargetDeBuff'], 'target', 'HARMFUL')
		UpdateAura(AURA['TargetTargetDeBuff'], 'targettarget', 'TARGET|HARMFUL')
		return
	elseif unit=='target' then
		UpdateAura(AURA['TargetTargetDeBuff'], 'targettarget', 'TARGET|HARMFUL')
		return
	end
end

function F:PLAYER_FOCUS_CHANGED()
	UpdateAura(AURA['FocusDeBuff'], 'focus', 'HARMFUL')
end

function F:PLAYER_ENTERING_WORLD()
	self:UNIT_AURA('player')
	self:SetScript('OnUpdate', OnUpdate)
	self:RegisterEvent('UNIT_AURA')
	self:RegisterEvent('UNIT_TARGET')
	self:RegisterEvent('PLAYER_FOCUS_CHANGED')
	self:UnregisterEvent('PLAYER_ENTERING_WORLD')
end