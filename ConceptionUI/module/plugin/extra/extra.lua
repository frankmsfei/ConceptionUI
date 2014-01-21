ExtraActionBarFrame:SetParent(ConceptionCORE)
--ExtraActionBarFrame.SetParent = function()end
--ExtraActionBarFrame:SetMovable(true)
--ExtraActionBarFrame:SetUserPlaced(true)
ExtraActionBarFrame:ClearAllPoints()
ExtraActionBarFrame:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 140)
--ExtraActionBarFrame.SetPoint = function()end
--ExtraActionBarFrame:SetScale(1)

PlayerPowerBarAlt:SetParent(ConceptionCORE)
--PlayerPowerBarAlt:SetMovable(true)
--PlayerPowerBarAlt:SetUserPlaced(true)
PlayerPowerBarAlt:ClearAllPoints()
PlayerPowerBarAlt:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 340)
--PlayerPowerBarAlt.SetPoint = function()end
--PlayerPowerBarAlt:SetScale(1)
PlayerPowerBarAlt.statusFrame.text:SetFont(DAMAGE_TEXT_FONT, 12, 'OUTLINE')