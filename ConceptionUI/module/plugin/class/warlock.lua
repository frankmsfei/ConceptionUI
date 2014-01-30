local C, D = unpack(select(2,...))
if C.CLASS ~= 'WARLOCK' then return end

local x, y = 0, -160

C.unit = 'player'
WarlockPowerFrame:SetParent(C)
WarlockPowerFrame:SetPoint('TOP', UIParent, 'CENTER', x, y)