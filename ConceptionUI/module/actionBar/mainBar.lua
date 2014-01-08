local mainBar = CreateFrame('Frame', nil, ConceptionCORE, 'SecureHandlerStateTemplate')
	mainBar:SetPoint('TOP', UIParent, 'CENTER', 0, -210)
	mainBar:SetSize(25.6*6+5*6, 25.6*2+6)

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

--[[
local overrideBar = CreateFrame('Frame', nil, C, 'SecureHandlerStateTemplate')
	overrideBar:SetPoint('TOP', UIParent, 'CENTER', 0, -210)
	overrideBar:SetSize(25.6*6+5*6, 25.6*2+6)

	for i = 1, 12 do
		local button = _G['OverrideActionBarButton'..i]
		if not button then
			break
		end
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('TOPLEFT', overrideBar)
		elseif i == 7 then
			button:SetPoint('TOPLEFT', _G['OverrideActionBarButton1'], 'BOTTOMLEFT', 0, -6)
		else 
			button:SetPoint('LEFT', _G['OverrideActionBarButton'..i-1], 'RIGHT', 6, 0)
		end
		button.SetPoint = dummy
	end



RegisterStateDriver(overrideBar, 'visibility', '[overridebar][vehicleui]show; hide')

OverrideActionBar:SetParent(overrideBar)
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript("OnShow", function(self)self:Hide() end)
]]
RegisterStateDriver(OverrideActionBar, 'visibility', '[overridebar][vehicleui]show; hide')