local Graphics = LibStub('LibDataBroker-1.1'):NewDataObject('Graphics', {type = 'data source'})
local GetFramerate, format = GetFramerate, format

local function Colored(n)
	if n <= 30 then
		return '|cFF610000', n -- red
	elseif n <= 50 then
		return '|cFF616100', n -- yellow
	else
		return '|cFF006100', n -- green
	end
end

local function UpdateFPS()
	Graphics.text = ('%s%.1f|cFF616161FPS|r'):format(Colored(GetFramerate()))
end
Timer:Set('Graphics', 1, UpdateFPS)
Timer:OnLogin(UpdateFPS)

local GetCVar = GetCVar
local function CVar(var, number)
	local value = tonumber(GetCVar(var))
	if not value then
		return var, 'not support', .38, .38, .38, .38, .38, .38
	end
	if value == 0 then
		return var, value, .38, .38, .38, .38, .38, .38
	elseif value < 1 then
		return var, value, .38, .38, .38, .38, .38, .38
	else
		return var, value, .62, .62, .62, .62, .62, .62
	end
end

function Graphics.OnTooltipShow(tip)
	tip:AddDoubleLine('Graphics', Graphics.text, 1, 1, 1, 1, 1, 1)

	tip:AddDoubleLine('\nGraphics Engine', ('\n%sbits, %s'):format(GetCVar('launchThirtyTwoBitClient') and '32' or '64', GetCVar('gxApi')), .62, .62, 0, .62, .62, .62)
	tip:AddDoubleLine('gxResolution', GetCVar('gxResolution'), .62, .62, .62, .62, .62, .62)
	tip:AddDoubleLine('gxColorBits', ('%sbit'):format(GetCVar('gxColorBits')), .62, .62, .62, .62, .62, .62)
	tip:AddDoubleLine('gxDepthBits', ('%sbit'):format(GetCVar('gxDepthBits')), .62, .62, .62, .62, .62, .62)
	tip:AddDoubleLine('gxRefresh', ('%sHz'):format(GetCVar('gxRefresh')), .62, .62, .62, .62, .62, .62)
	tip:AddDoubleLine('gxMultisample', ('%sx'):format(GetCVar('gxMultisample')), .62, .62, .62, .62, .62, .62)
	tip:AddDoubleLine(CVar('gxMultisampleQuality'))
	tip:AddDoubleLine(CVar('gxTextureCacheSize')) -- Set the cache size
	tip:AddDoubleLine(CVar('gxTripleBuffer'))
	tip:AddDoubleLine(CVar('gxVSync'))

	tip:AddLine('\nTextures', .62, .62, 0)
	tip:AddDoubleLine(CVar('baseMip'))
	tip:AddDoubleLine(CVar('bspcache'))
	tip:AddDoubleLine(CVar('componentCompress')) -- Fixes issues with characters being fully black caused by bad/old drivers.
	tip:AddDoubleLine(CVar('componentTextureLevel')) -- Number of mip levels used for character component textures
	tip:AddDoubleLine(CVar('componentThread'))
	tip:AddDoubleLine(CVar('textureFilteringMode'))

	tip:AddLine('Effects', .62, .62, 0)
	tip:AddDoubleLine(CVar('SSAO'))
	tip:AddDoubleLine(CVar('SSAOBlur'))
	tip:AddDoubleLine(CVar('reflectionMode'))
	tip:AddDoubleLine(CVar('reflectionDownscale'))
	tip:AddDoubleLine(CVar('waterDetail'))
	tip:AddDoubleLine(CVar('rippleDetail'))
	tip:AddDoubleLine(CVar('sunshafts'))
	tip:AddDoubleLine(CVar('SkyCloudLOD')) -- Level of detail for Sky
	tip:AddDoubleLine(CVar('SkySunGlare')) -- Toggles Sun Glare
	tip:AddDoubleLine(CVar('useWeatherShaders')) -- Enables weather shaders
	tip:AddDoubleLine(CVar('weatherDensity'))
	tip:AddDoubleLine(CVar('emphasizeMySpellEffects'))
	tip:AddDoubleLine(CVar('violenceLevel'))
	tip:AddDoubleLine(CVar('ffx'))
	tip:AddDoubleLine(CVar('ffxGlow'))
	tip:AddDoubleLine(CVar('ffxDeath'))
	tip:AddDoubleLine(CVar('ffxSpecial'))
	tip:AddDoubleLine(CVar('ffxRectangle'))
	tip:AddDoubleLine(CVar('ffxNetherWorld'))
	tip:AddDoubleLine(CVar('particleDensity'))

	tip:AddLine('Shadow', .62, .62, 0)
	tip:AddDoubleLine(CVar('shadowMode')) -- Controls the detail level of ingame shadows
	tip:AddDoubleLine(CVar('shadowTextureSize')) -- Shadow texture size
	tip:AddDoubleLine(CVar('shadowinstancing')) -- Shadow optimization which prevents flickering
	tip:AddDoubleLine(CVar('shadowcull')) -- enable shadow frustum culling
	tip:AddDoubleLine(CVar('shadowscissor')) -- Enables scissoring when rendering shadowmaps

	tip:AddLine('Environment', .62, .62, 0)
	tip:AddDoubleLine(CVar('groundEffectDist'))
	tip:AddDoubleLine(CVar('environmentDetail'))
	tip:AddDoubleLine(CVar('groundEffectDensity'))
	tip:AddDoubleLine(CVar('showfootprints')) -- Enables footprint display
	tip:AddDoubleLine(CVar('showfootprintparticles'))
	tip:AddDoubleLine(CVar('farclip'))
	tip:AddDoubleLine(CVar('nearclip'))

	tip:AddDoubleLine('\nUIParent Size', ('\n%dx%d'):format(GetScreenWidth(), GetScreenHeight()), .62, .62, 0, .62, .62, .62)
	if GetCVar('useuiscale') == '1' then
		tip:AddDoubleLine('uiScale', ('%s'):format(GetCVar('uiScale')), .62, .62, .62, .62, .62, .62)
	else
		tip:AddDoubleLine('uiScale', 'off', .38, .38, .38, .38, .38, .38)
	end
	tip:AddDoubleLine(CVar('maxFPS'))
	tip:AddDoubleLine(CVar('maxFPSbk'))

	tip:AddDoubleLine('\nscreenshotFormat', ('\n%s'):format(GetCVar('screenshotFormat')), .62, .62, 0, .62, .62, .62)
	tip:AddDoubleLine(CVar('screenshotQuality'))
	tip:AddDoubleLine('\nRefresh', '\n[L]', .38, .38, .38, .62, .38, 0)
	tip:AddDoubleLine('Restart Graphics Engine', '[R]', .38, .38, .38, 0, .38, .62)
	tip:AddDoubleLine('Window Mode Toggle', 'ALT+[L]', .38, .38, .38, .62, .38, 0)
end

function Graphics.OnClick(self, button)
	if button == 'LeftButton' then
		if IsAltKeyDown() then
			SetCVar( 'gxWindow', 1 - GetCVar('gxWindow') )
			RestartGx()
		else
			UpdateFPS()
			GameTooltip_Hide()
		end
	elseif button == 'RightButton' then
		RestartGx()
	end
end