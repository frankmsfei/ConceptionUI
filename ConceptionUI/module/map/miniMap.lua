local C, D = unpack(select(2,...))

function D.LOAD.M:SkinMinimap()
	--LoadAddOn('Minimap')
	function GetMinimapShape() return 'SQUARE' end
	Minimap:EnableMouse(true)
	Minimap:ClearAllPoints()
	Minimap:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -10, -10)
	Minimap:SetMaskTexture([[Interface\Buttons\WHITE8x8]])
	Minimap:SetSize(128, 128)

	MinimapBackdrop:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -5, 5)
	MinimapBackdrop:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 5, -5)
	MinimapBackdrop:SetBackdrop({edgeFile=[[Interface\AddOns\ConceptionUI\media\texture\backdropShadow]], edgeSize=5, insets={left=5,right=5,top=5,bottom=5}})
	MinimapBackdrop:SetBackdropBorderColor(0, 0, 0, .6)
	MinimapBackdrop:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	MinimapBackdrop:RegisterEvent("CALENDAR_ACTION_PENDING")
	MinimapBackdrop:SetScript("OnEvent", function(self, event)
		if event == 'CALENDAR_UPDATE_PENDING_INVITES' then
			self:SetBackdropBorderColor(.618, .618, 0, .6)
		elseif event == 'CALENDAR_ACTION_PENDING' then
			self:SetBackdropBorderColor(0, 0, 0, .6)
		end
	end)

	Minimap.Overlay = Minimap:CreateTexture(nil, 'BORDER')
	Minimap.Overlay:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', 0, 0)
	Minimap.Overlay:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 0, 0)
	Minimap.Overlay:SetTexture([[Interface\AddOns\ConceptionUI\media\texture\buttonOverlay]])
	Minimap.Overlay:SetVertexColor(0, 0, 0, 1)

	--Minimap.ZoneIcon = Minimap:CreateTexture(nil, 'OVERLAY')
	--Minimap.ZoneIcon:SetTexture([[Interface\AddOns\ConceptionUI\media\texture\arrowL]])
	--Minimap.ZoneIcon:SetPoint('BOTTOMRIGHT', Minimap, 'TOPRIGHT', 7, 1)

	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', 7, 7)
	--MiniMapInstanceDifficulty:SetScale(.8)

	MiniMapChallengeMode:ClearAllPoints()
	MiniMapChallengeMode:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', 7, 7)
	--MiniMapChallengeMode:SetScale(.8)

	GuildInstanceDifficulty:ClearAllPoints()
	GuildInstanceDifficulty:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', 7, 7)
	--GuildInstanceDifficulty:SetScale(.8)
	--SetSmallGuildTabardTextures("player", GuildInstanceDifficulty.emblem, GuildInstanceDifficulty.background, GuildInstanceDifficulty.border)

	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 7, -7)
	MiniMapMailIcon:SetTexture('Interface\\MINIMAP\\TRACKING\\Mailbox')
	MiniMapMailBorder:Hide()

	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:SetPoint('BOTTOMLEFT', Minimap, -7, -7)
	QueueStatusMinimapButton:Show()
	MiniMapRecordingButton:ClearAllPoints()
	MiniMapRecordingButton:SetPoint('BOTTOMLEFT', Minimap, -7, 7)
	
	MinimapZoneTextButton:SetParent(Minimap)
	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', 10, -5)
	MinimapZoneTextButton:SetFrameStrata('LOW')
	MinimapZoneText:SetJustifyH('RIGHT')
	MinimapZoneText:SetFont(DAMAGE_TEXT_FONT, 10)
	MinimapZoneText:SetShadowOffset(1, 1)
	MinimapZoneText:SetShadowColor(0, 0, 0, .7)

	MinimapCluster:RegisterEvent('PLAYER_ENTERING_WORLD')
	MinimapCluster:HookScript('OnEvent', function()
		local r, g, b = MinimapZoneText:GetTextColor()
		MinimapZoneText:SetTextColor(.618*r, .618*g, .618*b)
		local subzone, realzone = GetSubZoneText(), GetRealZoneText()
		if subzone ~= '' and subzone ~= realzone then
			MinimapZoneText:SetFormattedText('%s-%s', subzone, realzone)
			return
		else
			MinimapZoneText:SetText(realzone)
		end
	end)

	--[[hooksecurefunc('Minimap_Update', function()
		local r, g, b = MinimapZoneText:GetTextColor()
		
		MinimapZoneText:
		print(GetSubZoneText(), GetRealZoneText())
	end)]]
--[[
function Minimap_Update()
	MinimapZoneText:SetFormattedText('%s - %s', GetSubZoneText(), GetRealZoneText())

	local r, g, b = NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b
	local pvpType, isSubZonePvP, factionName = GetZonePVPInfo()
	if ( pvpType == "sanctuary" ) then
		r, g, b = 0.41, 0.8, 0.94
	elseif ( pvpType == "arena" ) then
		r, g, b = 1.0, 0.1, 0.1
	elseif ( pvpType == "friendly" ) then
		r, g, b = 0.1, 1.0, 0.1
	elseif ( pvpType == "hostile" ) then
		r, g, b = 1.0, 0.1, 0.1
	elseif ( pvpType == "contested" ) then
		r, g, b = 1.0, 0.7, 0.0
	end
	MinimapZoneText:SetTextColor(.618*r, .618*g, .618*b)

	Minimap_SetTooltip(pvpType, factionName)
end


	MinimapCluster:HookScript('OnEvent', function(self, event)
		print(event)
	--	local r, g, b = MinimapZoneText:GetTextColor()
	--	MinimapZoneText:SetTextColor(.618*r, .618*g, .618*b)
	--	if not MiniMapInstanceDifficulty:IsShown() and not MiniMapChallengeMode:IsShown() and not GuildInstanceDifficulty:IsShown() then
	--		GuildInstanceDifficultyHeroicTexture:Hide()
	--		GuildInstanceDifficultyChallengeModeTexture:Hide()
	--		GuildInstanceDifficultyText:SetText()
	--		GuildInstanceDifficulty:Show()
	--	end
	end)
]]
	

	do -- Hide Timer
		LoadAddOn('Blizzard_TimeManager')
		TimeManagerClockButton:Hide()
		MinimapNorthTag:SetAlpha(0)
		MinimapBorder:Hide()
		MinimapBorderTop:Hide()
		MinimapZoomIn:Hide()
		MinimapZoomOut:Hide()
		MiniMapVoiceChatFrame:Hide()
		MiniMapWorldMapButton:Hide()
		MiniMapTracking:Hide()
		GameTimeFrame:Hide()
	end

	local function OnMouseWheel(self, delta)
		if delta > 0 then Minimap_ZoomIn() else Minimap_ZoomOut() end
	end
	Minimap:SetScript('OnMouseWheel', OnMouseWheel)

	local function OnMouseUp(self, button)
		if button == 'RightButton' then
			ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, 0, 0)
		elseif button == 'MiddleButton' then
			ToggleCalendar()
		else
			Minimap_OnClick(self)
		end
	end
	Minimap:SetScript('OnMouseUp', OnMouseUp)
end