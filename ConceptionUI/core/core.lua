local _, UI =  ...
_G[_] = UI

UI[1] = CreateFrame('Frame', 'ConceptionCORE', nil, 'SecureHandlerStateTemplate')
UI[2] = { LOAD = { P = {}, R = {}, I = {}, M = {}, E = {} } }

local CORE, DATA = UI[1], UI[2]
	CORE.FUNC = {}
	CORE.UNITFRAME = { Major = {}, Minor = {} }
	CORE.AURAFRAME = {}
	CORE.CLASS = select(2, UnitClass('player'))
	CORE.SCALE_FIX = max(768/tonumber(GetCVar('gxResolution'):match('%d+x(%d+)')), .64)
	CORE:SetScale(CORE.SCALE_FIX)
	CORE:SetScript('OnEvent', function(self, event, ...) DATA[event](DATA, event, ...) end)
	CORE:RegisterEvent('ADDON_LOADED')

function DATA:Load(data)
	for func in pairs(self.LOAD[data]) do
		self.LOAD[data][func]()
	end
end

function DATA:ADDON_LOADED(event, addon)
	if addon ~= _ then return end
	CORE:UnregisterEvent(event)
	CORE:RegisterEvent('PLAYER_LOGIN')
	ConceptionCFG = ConceptionCFG or {}
	self:Load('P')
	self:Load('R')
	self:Load('I')
	self:Load('M')
	self:Load('E')
end

function DATA:PLAYER_LOGIN(event)
	local alpha = CORE:GetAttribute('fade')
	CORE:SetAttribute('state-alpha', IsMounted() and alpha or 1)
	CORE.PLAYER = UnitGUID('player')
	CORE:SetScript('OnEvent', nil)
	CORE:UnregisterEvent(event)
	wipe(UI[2])
	collectgarbage('collect')
end

function DATA.LOAD.P:LoadCore()
	local function Show() CORE:SetAlpha(CORE:GetAttribute('state-alpha')) end
	local function Hide() CORE:SetAlpha(0) end
	CORE:SetFrameRef('UI', UIParent)
	CORE:Execute([[UI=self:GetFrameRef('UI')]])
	CORE:SetAttribute('fade', UI[2].CFG['OTHERS']['MOUNTED_ALPHA'])
	CORE:SetAttribute('_onstate-alpha', [[ if not UI:IsShown() then return end self:SetAlpha(newstate) ]])
	CORE:SetAttribute('_onstate-mount', [[ self:SetAttribute('state-alpha', newstate or self:GetAttribute('fade')) ]])
	RegisterStateDriver(CORE, 'mount', '[mounted]nil;1')
	UIParent:HookScript('OnShow', Show)
	UIParent:HookScript('OnHide', Hide)
	MovieFrame:HookScript('OnShow', Hide)
	MovieFrame:HookScript('OnHide', Show)
	PetBattleFrame:HookScript('OnShow', Hide)
	PetBattleFrame:HookScript('OnHide', Show)
end