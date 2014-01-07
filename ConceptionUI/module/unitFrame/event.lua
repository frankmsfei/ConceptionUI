local C = unpack(select(2,...))
local FUNC = C.FUNC.UNIT
local MAJOR, MINOR = C.UNITFRAME.Major, C.UNITFRAME.Minor
local VALID = {['player']=true, ['target']=true, ['focus']=true, ['targettarget']=true, ['pet']=true}
local EVENT = CreateFrame('Frame'); EVENT:Hide()

	--[ ID ]--

	function EVENT:UNIT_NAME_UPDATE(unit)
		if not VALID[unit] then return end
		local f = MAJOR[unit] and MAJOR[unit] or MINOR[unit]
		FUNC.NameCheck(f, unit)
	end

	function EVENT:UNIT_CONNECTION(unit, connection)
		if not MAJOR[unit] then return end
		FUNC.NameCheck(MAJOR[unit], unit)
	end

	local pairs = pairs
	function EVENT:RAID_TARGET_UPDATE()
		for unit in pairs(MAJOR) do
			FUNC.NameCheck(MAJOR[unit], unit)
		end
		for unit in pairs(MINOR) do
			FUNC.NameCheck(MINOR[unit], unit)
		end
	end

	function EVENT:PLAYER_FLAGS_CHANGED(unit)
		if not MAJOR[unit] then return end
		FUNC.NameCheck(MAJOR[unit], unit)
	end

	function EVENT:CVAR_UPDATE()
		FUNC.NameCheck(MAJOR['player'], 'player')
	end

	--[ HP ]--

	local function DetectHealth(_, unit)
		if not VALID[unit] then return end
		local f = MAJOR[unit] and MAJOR[unit] or MINOR[unit]
		FUNC.OnHpChanged(f, unit)
	end

	EVENT['UNIT_HEALTH_FREQUENT'] = DetectHealth
	EVENT['UNIT_MAXHEALTH'] = DetectHealth

	--[ PP ]--

	local function DetectPower(_, unit)
		if not VALID[unit] then return end
		local f = MAJOR[unit] and MAJOR[unit] or MINOR[unit]
		FUNC.OnPpChanged(f, unit)
	end

	EVENT['UNIT_POWER_FREQUENT'] = DetectPower
	EVENT['UNIT_MAXPOWER'] = DetectPower

	function EVENT:PLAYER_ALIVE()
		FUNC.OnHpChanged(MAJOR['player'], 'player')
		FUNC.OnPpChanged(MAJOR['player'], 'player')
	end

	--[ 目標改變 ]--

	local function DetectUnit(frame, unit)
		local f = frame[unit]
		FUNC.NameCheck(f, unit)
		FUNC.OnHpChanged(f, unit)
		FUNC.OnPpChanged(f, unit)
	end

	function EVENT:UNIT_TARGET(unit)
		if not VALID[unit] then return end
		if unit=='player' then
			DetectUnit(MAJOR, 'target')
			DetectUnit(MINOR, 'targettarget')
			return
		elseif unit=='target' then
			DetectUnit(MINOR, 'targettarget')
			return
		elseif MINOR[unit] then
			FUNC.NameCheck(MINOR[unit], unit)
			return
		end
	end

	function EVENT:PLAYER_FOCUS_CHANGED()
		DetectUnit(MINOR, 'focus')
	end

	function EVENT:ZONE_CHANGED()
		DetectUnit(MINOR, 'focus')
	end

	function EVENT:UNIT_PET(unit)
		if unit~='player' then return end
		DetectUnit(MINOR, 'pet')
	end

	function EVENT:UNIT_ENTERED_VEHICLE(unit)
		if unit~='player' then return end
		DetectUnit(MINOR, 'pet')
	end

	EVENT:RegisterEvent('UNIT_NAME_UPDATE')
	EVENT:RegisterEvent('UNIT_CONNECTION')
	EVENT:RegisterEvent('RAID_TARGET_UPDATE')
	EVENT:RegisterEvent('PLAYER_FLAGS_CHANGED')
	EVENT:RegisterEvent('CVAR_UPDATE')
	EVENT:RegisterEvent('UNIT_HEALTH_FREQUENT')
	EVENT:RegisterEvent('UNIT_MAXHEALTH')
	EVENT:RegisterEvent('UNIT_POWER_FREQUENT')
	EVENT:RegisterEvent('UNIT_MAXPOWER')
	EVENT:RegisterEvent('PLAYER_ALIVE')
	EVENT:RegisterEvent('UNIT_TARGET')
	EVENT:RegisterEvent('PLAYER_FOCUS_CHANGED')
	EVENT:RegisterEvent('ZONE_CHANGED')
	EVENT:RegisterEvent('UNIT_PET')
	EVENT:RegisterEvent('UNIT_ENTERED_VEHICLE')

	EVENT:SetScript('OnEvent', function(self, event, ...) self[event](_, ...) end)