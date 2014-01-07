local NAMEPLATE = CreateFrame('Frame')
local current = 0
local checked = 0
local WorldFrame = WorldFrame
local pairs, select = pairs, select

local function Check(numFrames)
	for i = 1 + checked, numFrames do
		local f = select(i, WorldFrame:GetChildren())
		if f:GetName() and f:GetName():match('NamePlate%d') then
			NAMEPLATE:Skin(f)
		end
	end
	return numFrames
end

local function Scan()
	current = WorldFrame:GetNumChildren()
	if checked ~= current then
		checked = Check(current)
	end
end

local function Loop()
	for plate in pairs(NAMEPLATE.plates) do
		NAMEPLATE:Update(plate)
	end
	Scan()
end

NAMEPLATE.ENGINE = NAMEPLATE:CreateAnimationGroup()
NAMEPLATE.ENGINE:CreateAnimation():SetDuration(.1)
NAMEPLATE.ENGINE:SetLooping('REPEAT')
NAMEPLATE.ENGINE:SetScript('OnLoop', Loop)

NAMEPLATE:RegisterEvent('PLAYER_LOGIN')
NAMEPLATE:SetScript('OnEvent', function(self, event)
	SetCVar('ShowVKeyCastbar', 1)
	SetCVar('ShowClassColorInNameplate', 1)
	SetCVar('repositionfrequency', 0)
	SetCVar('threatWarning', 3)
	SetCVar('bloatnameplates', 0)
	SetCVar('bloatthreat', 0)
	SetCVar('bloattest', 0)
	self.plates = {}
	self.ENGINE:Play()
	self.realm = GetRealmName('player')
	self.faction = UnitFactionGroup("player")
	self:UpdateClass('FRIENDLIST_UPDATE')
	self:UnregisterEvent(event)
	self:SetScript('OnEvent', self.UpdateClass)
	self:RegisterEvent('GROUP_ROSTER_UPDATE')
	self:RegisterEvent('FRIENDLIST_UPDATE')
	self:RegisterEvent('BN_FRIEND_ACCOUNT_ONLINE')
end)

select(2,...)[1].NAMEPLATE = NAMEPLATE