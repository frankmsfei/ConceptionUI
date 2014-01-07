local C, D = unpack(select(2,...))
local API, texture = {}, D.MEDIA['TEXTURE']

function API.dummy()
end

function API.scale(value)
	return value * C.SCALE_FIX
end

--[[
local SetExactSize = 
	function(obj, width, height)
		return obj:SetSize(scale(width), scale(height))
	end

local SetExactPoint =
	function(obj, objPoint, relativeObj, relativePoint, x, y)
		return obj:SetPoint(objPoint, relativeObj, relativePoint, scale(x), scale(y))
	end

local SetExactFont =
	function(obj, font, size, flag)
		return obj:SetFont(font, scale(size), flag or 'NONE')
	end

function API.addto(obj)
	if not obj.SetExactPoint then obj.SetExactPoint = SetExactPoint end
	if obj:GetObjectType() == 'FontString' then
		if not obj.SetExactFont then obj.SetExactFont = SetExactFont end
	else
		if not obj.SetExactSize then obj.SetExactSize = SetExactSize end
	end	
end
]]

function API.Frame(name ,parent, framePoint, relativeObj, relativePoint, x, y, w, h, temp)
	local frame = CreateFrame('Frame', name, parent, temp)
		if framePoint then frame:SetPoint(framePoint, relativeObj, relativePoint, x, y) end
		if w and h then frame:SetSize(w, h) end
	return frame
end

function API.Button(name ,parent, buttonPoint, relativeObj, relativePoint, x, y, w, h, temp)
	local button = CreateFrame('Button', name, parent, temp)
		button:SetPoint(buttonPoint, relativeObj, relativePoint, x, y)
		button:SetSize(w, h)
		button:RegisterForClicks('AnyDown')
		button:EnableMouse(true)
     return button
end

function API.Texture(parent, texturePoint, relativeObj, relativePoint, x, y, w, h, layer)
	local texture = parent:CreateTexture(nil, layer)
		if texturePoint then texture:SetPoint(texturePoint, relativeObj, relativePoint, x, y) end
		if w and h then texture:SetSize(w, h) end
     return texture
end

function API.Icon(parent, size, layer)
	local icon = parent:CreateTexture(nil, layer)
		icon:SetPoint('CENTER')
		icon:SetTexCoord(.08, .92, .08, .92)
		icon.overlay = parent:CreateTexture(nil, 'ARTWORK')
		icon.overlay:SetAllPoints(icon)
		icon.overlay:SetTexture(texture.buttonOverlay)
		icon.overlay:SetVertexColor(0, 0, 0, .7)
		if size then icon:SetSize(size, size) end
	return icon
end

function API.Bar(name, parent, barPoint, relativeObj, relativePoint, x, y, w, h, min, max)
	local bar = CreateFrame('StatusBar', name, parent)
		bar:SetPoint(barPoint, relativeObj, relativePoint, x, y)
		if w and h then bar:SetSize(w, h) end
		if min and max then bar:SetMinMaxValues(min, max) end
		bar.bg = bar:CreateTexture(nil, 'BACKGROUND')
		bar.bg:SetAllPoints(bar)
	return bar
end

function API.String(parent, objPoint, relativeObj, relativePoint, x, y, font, font_size, font_flag, shadow_x, shadow_y)
	local obj = parent:CreateFontString()
		obj:SetPoint(objPoint, relativeObj, relativePoint, x, y)
		obj:SetFont(font, font_size, font_flag)
		if shadow_x and shadow_y then obj:SetShadowOffset(shadow_x, shadow_y) end
	return obj
end

function API.DropShadow(parent)
	local backdrop = CreateFrame('Frame', nil, parent)
		backdrop:SetPoint('TOPRIGHT', parent, 'TOPRIGHT', 4, 4)
		backdrop:SetPoint('BOTTOMLEFT', parent, 'BOTTOMLEFT', -4, -4)
		backdrop:SetFrameLevel(parent:GetFrameLevel() -1 > 0 and parent:GetFrameLevel() -1 or 0)
		backdrop:SetBackdrop(texture.dropshadow)
		backdrop:SetBackdropBorderColor(0, 0, 0, .7)
	return backdrop
end

D.API = API