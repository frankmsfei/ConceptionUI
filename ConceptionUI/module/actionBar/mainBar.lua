local mainBar = CreateFrame('Frame', nil, ConceptionCORE, 'SecureHandlerStateTemplate')
	mainBar:SetPoint('BOTTOM', UIParent, 'CENTER', 0, -270)
	mainBar:SetSize(26*6+5*6, 26*2+6)

	for i = 1, 12 do
		local button = _G['ActionButton'..i]
			button:SetParent(mainBar)
			button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('TOPLEFT', mainBar)
		elseif i == 7 then
			button:SetPoint('TOPLEFT', _G['ActionButton1'], 'BOTTOMLEFT', 0, -6)
		else 
			button:SetPoint('LEFT', _G['ActionButton'..i-1], 'RIGHT', 6, 0)
		end
		mainBar:SetFrameRef('button'..i, button)
	end

	mainBar:Execute([[
		ref = table.new()
		for i = 1, 12 do
			ref[i] = self:GetFrameRef('button'..i)
		end
	]])

	mainBar:SetAttribute('_onstate-page', [[
		for index, button in pairs(ref) do
			button:SetAttribute('actionpage', newstate)
		end
	]])

RegisterStateDriver(mainBar, 'visibility', '[petbattle][overridebar][vehicleui]hide; show')
RegisterStateDriver(mainBar, 'page', '[possessbar]12; [mod:shift]6; [mod:ctrl]5; 1')
RegisterStateDriver(OverrideActionBar, 'visibility', '[overridebar][vehicleui]show; hide')