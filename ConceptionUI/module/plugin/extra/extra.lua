local E, P = ExtraActionBarFrame, PlayerPowerBarAlt

E:SetParent(ConceptionUI[1])
E.SetParent = function()end
E:SetMovable(true)
E:ClearAllPoints()
E:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 150)
E.SetPoint = function()end
E:SetScale(.8)

P:SetParent(ConceptionUI[1])
P:SetMovable(true)
P:SetUserPlaced(true)
P:ClearAllPoints()
P:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 340)
P.SetPoint = function()end
P:SetScale(.8)