local petBar = CreateFrame('Frame', nil, ConceptionCORE)
	petBar:SetPoint('BOTTOMRIGHT', UIParent, 'RIGHT', -74, -270)
	petBar:SetSize(26, 26*12+6*11)

	for i = 1, 10 do
		local button = _G['PetActionButton'..i]
			button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('TOPLEFT', petBar)
		else 
			button:SetPoint('TOP', _G['PetActionButton'..i-1], 'BOTTOM', 0, -6)
		end
	end

PetActionBarFrame:SetParent(petBar)
PetActionBarFrame:SetScale(.8)--it's right?
