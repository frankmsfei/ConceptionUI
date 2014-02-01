local C = unpack(select(2, ...))

local Tip = GameTooltip
C.FUNC.AURA = {
	OnEnter = function(self, unit, filter)
		self.anchor:SetScale(2)
		Tip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
		Tip:ClearLines()
		Tip:SetUnitAura(unit, self:GetID(), filter)
		Tip:Show()
	end,
	OnLeave = function(self)
		self.anchor:SetScale(1)
		Tip:Hide()
	end
}

local AURA = C.AURAFRAME
--local CACHE = setmetatable({}, {__mode='kv',
--	__call = function(self, key)

--	end
--})

local function GetDispelTypeColor(dispelType)
	if not dispelType then
		return .618, 0, 0
	end
	if dispelType == 'Disease' then
		return 0, .618, .191
	elseif dispelType == 'Curse' then
		return .618, 0, .618
	elseif dispelType == 'Magic' then
		return 0, .191, .618
	elseif dispelType == 'Poison' then
		return .618, .618, 0
	end
end

local function showAura(self, name, icon, stack, dispelType, expiration, desaturated, debuff, sort)
	self.name = name
	self.icon.overlay:Show()
	self.icon:SetTexture(icon)
	self.icon:SetDesaturated(desaturated)
	if debuff then
		self.shadow:SetBackdropBorderColor(GetDispelTypeColor(dispelType))
	end
	self.shadow:Show()
	self.stack:SetText(stack and stack>1 and stack or '')
	self.expiration = expiration or 0
	--if expiration ~= 0 then return end
	--self.timer:SetText(nil)
end

local function hideAura(self, sort)
	if not self.icon:GetTexture() then return end
	self.icon.overlay:Hide()
	self.shadow:Hide()
	self.name = nil
	self.expiration = nil
	self.icon:SetTexture(nil)
	self.stack:SetText(nil)
	self.timer:SetText(nil)
end

local function sortbuff(a, b)
	if a.expiration and b.expiration then
		return a.expiration > b.expiration
	end
end

local UnitAura = UnitAura
local UpdateAura = function(auras, unit, filter, debuff, sort)
	for i = 1, #auras do
		local name, _, icon, stack, dispelType, _, expiration, caster, _, _, _, _, _, player = UnitAura(unit, i, filter)
		if icon then
			showAura(auras[i], name, icon, stack, dispelType, expiration, (caster ~= 'player') and player, debuff)
		else
			hideAura(auras[i])
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

local function WeaponEnchantInfo_OnEnter(self)
	self.anchor:SetScale(2)
	Tip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
	Tip:ClearLines()
	Tip:SetInventoryItem('player', self:GetAttribute('target-slot'))
	Tip:Show()
end

local GetWeaponEnchantInfo, GetInventoryItemTexture = GetWeaponEnchantInfo, GetInventoryItemTexture
local function UpdateEnchant(auras, curTime)
	local mh, mhExpiration, _, oh, ohExpiration = GetWeaponEnchantInfo()
	if mh then
		showAura(auras[1], GetInventoryItemTexture("player", 16))
		auras[1].timer:SetFormattedText(time_format(0.001 * mhExpiration))
		auras[1]:SetScript('OnEnter', WeaponEnchantInfo_OnEnter)
	else
		hideAura(auras[1])
		auras[1]:SetScript('OnEnter', nil)
	end
	if oh then
		showAura(auras[2], GetInventoryItemTexture("player", 17))
		auras[2].timer:SetFormattedText(time_format(0.001 * ohExpiration))
		auras[2]:SetScript('OnEnter', WeaponEnchantInfo_OnEnter)
	else
		hideAura(auras[2])
		auras[2]:SetScript('OnEnter', nil)
	end
end

local GetTime, pairs = GetTime, pairs
local function OnUpdate(self, elapsed)
	--self.elapsed = elapsed + (self.elapsed or 0)
	--if self.elapsed < .1 then return end
	--self.elapsed = 0
	local now = GetTime()
	for _, v in pairs(AURA) do
		UpdateTimer(v, now)
	end
	UpdateAura(AURA['TargetTargetDeBuff'], 'targettarget', 'HARMFUL', true)
	UpdateEnchant(AURA['PlayerTemporaryBuff'], now)
end

local VALID = {['player']=true, ['target']=true, ['focus']=true, ['targettarget']=true}

local	F = CreateFrame('Frame')
	F:RegisterEvent('PLAYER_ENTERING_WORLD')
	F:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)

function F:UNIT_AURA(unit)
	if not VALID[unit] then return end
	if unit=='player' then
		UpdateAura(AURA['PlayerBuff'], unit, 'PLAYER|HELPFUL', false)
		UpdateAura(AURA['PlayerDeBuff'], unit, 'HARMFUL', true)
		UpdateAura(AURA['PlayerRaidBuff'], unit, 'HELPFUL', false)
		return
	elseif unit=='target' then
		UpdateAura(AURA['TargetBuff'], unit, 'HELPFUL', false)
		UpdateAura(AURA['TargetDeBuff'], unit, 'HARMFUL', true)
		return
	elseif unit=='focus' then
		UpdateAura(AURA['FocusDeBuff'], unit, 'HARMFUL', true)
		return
	end
end

function F:UNIT_TARGET(unit)
	if not VALID[unit] then return end
	if unit=='focus' or unit=='targettarget' then return end
	if unit=='player' then
		UpdateAura(AURA['TargetBuff'], 'target', 'HELPFUL', false)
		UpdateAura(AURA['TargetDeBuff'], 'target', 'HARMFUL', true)
		UpdateAura(AURA['TargetTargetDeBuff'], 'targettarget', 'HARMFUL', true)
		return
	elseif unit=='target' then
		UpdateAura(AURA['TargetTargetDeBuff'], 'targettarget', 'HARMFUL', true)
		return
	end
end

function F:PLAYER_FOCUS_CHANGED()
	UpdateAura(AURA['FocusDeBuff'], 'focus', 'HARMFUL', true)
end

function F:PLAYER_ENTERING_WORLD()
	self:UNIT_AURA('player')
	self:SetScript('OnUpdate', OnUpdate)
	self:RegisterEvent('UNIT_AURA')
	self:RegisterEvent('UNIT_TARGET')
	self:RegisterEvent('PLAYER_FOCUS_CHANGED')
	self:UnregisterEvent('PLAYER_ENTERING_WORLD')
end