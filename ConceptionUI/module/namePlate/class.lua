local NAMEPLATE = select(2,...)[1].NAMEPLATE
local DEFAULT_COLOR = NAMEPLATE.DEFAULT_COLOR
local COLOR = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
local UnitName, UnitClass = UnitName, UnitClass
local GetNumFriends, GetFriendInfo, BNGetNumFriends, BNGetNumFriendToons, BNGetFriendToonInfo , BNGetToonInfo = GetNumFriends, GetFriendInfo, BNGetNumFriends, BNGetNumFriendToons, BNGetFriendToonInfo , BNGetToonInfo
local CLASS = {['聖騎士']='PALADIN',['牧師']='PRIEST',['術士']='WARLOCK',['戰士']='WARRIOR',['獵人']='HUNTER',['薩滿']='SHAMAN',['武僧']='MONK',['盜賊']='ROGUE',['死亡騎士']='DEATHKNIGHT',['法師']='MAGE',['德魯伊']='DRUID'}

NAMEPLATE.group = false
NAMEPLATE.class = setmetatable({}, {
	__call = function(self, name)
		local class = self[name]
		if not class then
			return DEFAULT_COLOR('FRIENDLY')
		end
		return COLOR[class].r, COLOR[class].g, COLOR[class].b, class
	end,
	__mode = 'kv'
})

function NAMEPLATE:CheckClass(unit)
	local _, class = UnitClass(unit)
	if not class then return end
	return COLOR[class].r, COLOR[class].g, COLOR[class].b
end

function NAMEPLATE:UpdateClass(event, ...)
	if event == 'GROUP_ROSTER_UPDATE' then
		wipe(NAMEPLATE.class)
		if NAMEPLATE.group then
			for i = 1, 40 do
				local unit = NAMEPLATE.group:format(i)
				local name = UnitName(unit)
				if not name then break end
				local _, class = UnitClass(unit)
				NAMEPLATE.class[name] = class
			end
		end
		NAMEPLATE:UpdateClass('FRIENDLIST_UPDATE')
		return
	elseif event == 'BN_FRIEND_ACCOUNT_ONLINE' then
		local unknown, name, client, realmName, realmID, faction, race, class = BNGetToonInfo(...)
		if realmName == NAMEPLATE.realm and faction == NAMEPLATE.faction then
			NAMEPLATE.class[name] = CLASS[class]
		end
		return
	elseif event == 'FRIENDLIST_UPDATE' then
		for i = 1, select(2, BNGetNumFriends()) do
			for j = 1, BNGetNumFriendToons(i) do
				local unknown, name, client, realmName, realmID, faction, race, class = BNGetFriendToonInfo(i, j)
				if realmName == NAMEPLATE.realm and faction == NAMEPLATE.faction then
					NAMEPLATE.class[name] = CLASS[class]
				end
			end
		end

		for i = 1, select(2, GetNumFriends()) do
			local name, _, class = GetFriendInfo(i)
			NAMEPLATE.class[name] = CLASS[class]
		end
		return
	end
end