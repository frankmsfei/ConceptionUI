local C, D = unpack(select(2,...))
function GetMinimapShape() return 'SQUARE' end
function D.LOAD.M:SkinMinimap()
	Minimap:EnableMouse(true)
	Minimap:ClearAllPoints()
	Minimap:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -10, -10)
	Minimap:SetMaskTexture([[Interface\Buttons\WHITE8x8]])
	Minimap:SetSize(128, 128)

	Minimap.Overlay = Minimap:CreateTexture(nil, 'BORDER')
	Minimap.Overlay:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', 0, 0)
	Minimap.Overlay:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 0, 0)
	Minimap.Overlay:SetTexture(D.MEDIA.TEXTURE.buttonOverlay)
	Minimap.Overlay:SetVertexColor(0, 0, 0, 1)

	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 7, -7)
	MiniMapMailIcon:SetTexture('Interface\\MINIMAP\\TRACKING\\Mailbox')
	MiniMapMailBorder:Hide()

	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:SetPoint('BOTTOMLEFT', Minimap, -7, -7)
	QueueStatusMinimapButton:Show()

	MiniMapRecordingButton:ClearAllPoints()
	MiniMapRecordingButton:SetPoint('BOTTOMLEFT', Minimap, -7, 7)


	MinimapBackdrop:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -5, 5)
	MinimapBackdrop:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 5, -5)
	MinimapBackdrop:SetBackdrop(D.MEDIA.TEXTURE.dropshadow)
	MinimapBackdrop:SetBackdropBorderColor(0, 0, 0, .6)

	local function OnCalendarUpdate(self, event)
		if event == 'CALENDAR_UPDATE_PENDING_INVITES' then
			self:SetBackdropBorderColor(.618, .618, 0, .6)
		elseif event == 'CALENDAR_EVENT_ALARM' then
			self:SetBackdropBorderColor(.618, 0, 0, .6)
		else
			self:SetBackdropBorderColor(0, 0, 0, .6)
		end
	end
	MinimapBackdrop:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES')
	MinimapBackdrop:RegisterEvent('CALENDAR_ACTION_PENDING')
	MinimapBackdrop:RegisterEvent('CALENDAR_EVENT_ALARM')
	MinimapBackdrop:SetScript('OnEvent', OnCalendarUpdate)


	MinimapZoneTextButton:SetParent(Minimap)
	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', 10, -5)
	MinimapZoneTextButton:SetFrameStrata('LOW')
	MinimapZoneText:SetJustifyH('RIGHT')
	MinimapZoneText:SetFont(DAMAGE_TEXT_FONT, 10)
	MinimapZoneText:SetShadowOffset(1, 1)
	MinimapZoneText:SetShadowColor(0, 0, 0, .7)

	local function UpdateZoneText()
		SetMapToCurrentZone()
		local r, g, b = MinimapZoneText:GetTextColor()
		MinimapZoneText:SetTextColor(.618*r, .618*g, .618*b)
		local subzone, realzone = GetSubZoneText(), GetRealZoneText()
		if subzone ~= '' and subzone ~= realzone then
			MinimapZoneText:SetFormattedText('%s/%s', subzone, realzone)
			return
		else
			MinimapZoneText:SetText(realzone)
		end
	end
	MinimapCluster:RegisterEvent('PLAYER_ENTERING_WORLD')
	MinimapCluster:HookScript('OnEvent', UpdateZoneText)


	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', 7, 7)
	MiniMapChallengeMode:ClearAllPoints()
	MiniMapChallengeMode:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', 2, 1)
	GuildInstanceDifficulty:ClearAllPoints()
	GuildInstanceDifficulty:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', 4, 7)

	local function ShowGuildTabard()
		if not MiniMapInstanceDifficulty:IsShown() and not MiniMapChallengeMode:IsShown() and not GuildInstanceDifficulty:IsShown() then
			SetSmallGuildTabardTextures('player', GuildInstanceDifficulty.emblem, GuildInstanceDifficulty.background, GuildInstanceDifficulty.border)
			GuildInstanceDifficultyChallengeModeTexture:Hide()
			GuildInstanceDifficultyHeroicTexture:Hide()
			GuildInstanceDifficultyText:SetText()
			GuildInstanceDifficulty:Show()
		end
	end
	hooksecurefunc('MiniMapInstanceDifficulty_Update', ShowGuildTabard)


	GuildInstanceDifficulty.Button = CreateFrame('Button', nil, GuildInstanceDifficulty)
	GuildInstanceDifficulty.Button:SetAllPoints()
	GuildInstanceDifficulty.Button:SetScript('OnClick', ToggleMinimap)


	do -- Hide Obj
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
		elseif button == 'LefttButton' then
			Minimap_OnClick(self)
		end
	end
	Minimap:SetScript('OnMouseUp', OnMouseUp)
end