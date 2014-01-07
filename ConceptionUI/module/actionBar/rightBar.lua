local C = select(2,...)[1]
local rightBar = CreateFrame('Frame', nil, C, 'SecureHandlerStateTemplate')
	rightBar:SetPoint('BOTTOMRIGHT', UIParent, 'RIGHT', -10, -270)
	rightBar:SetSize(25.6, 25.6*12+6*11)

	for i = 1, 12 do
		local button = _G['MultiBarRightButton'..i]
			button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('TOPLEFT', rightBar)
		else 
			button:SetPoint('TOP', _G['MultiBarRightButton'..i-1], 'BOTTOM', 0, -6)
		end
	end

MultiBarRight:SetParent(rightBar)
--MultiBarRight:EnableMouse(false)