local leftBar = CreateFrame('Frame', nil, ConceptionCORE)
	leftBar:SetPoint('BOTTOMRIGHT', UIParent, 'RIGHT', -42, -270)
	leftBar:SetSize(26, 26*12+6*11)

	for i = 1, 12 do
		local button = _G['MultiBarLeftButton'..i]
			button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('TOPLEFT', leftBar)
		else 
			button:SetPoint('TOP', _G['MultiBarLeftButton'..i-1], 'BOTTOM', 0, -6)
		end
	end

MultiBarLeft:SetParent(leftBar)