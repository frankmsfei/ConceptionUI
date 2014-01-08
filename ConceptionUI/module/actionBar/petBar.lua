local petBar = CreateFrame('Frame', nil, C, 'SecureHandlerStateTemplate')
	petBar:SetPoint('BOTTOMRIGHT', UIParent, 'RIGHT', -80, -270)
	petBar:SetSize(25.6, 25.6*12+6*11)

	for i = 1, 10 do
		local button = _G['PetActionButton'..i]
			button:SetParent(petBar)
			button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('TOPLEFT', petBar)
		else 
			button:SetPoint('TOP', _G['PetActionButton'..i-1], 'BOTTOM', 0, -6)
		end
	end