local D = select(2,...)[2]

local vig = D.API.Frame()
	vig:SetAllPoints(UIParent)
	vig:SetBackdrop({bgFile=D.MEDIA.TEXTURE.vignetting})
	vig:SetFrameStrata('BACKGROUND')
	vig:SetFrameLevel(0)
--[[
local bordertop = D.API.Texture(vig)
	bordertop:SetPoint('TOPLEFT')
	bordertop:SetPoint('TOPRIGHT')
	bordertop:SetHeight(D.API.scale(30))
	bordertop:SetTexture(0, 0, 0)
]]
local borderbot = D.API.Texture(vig)
	borderbot:SetPoint('BOTTOMLEFT')
	borderbot:SetPoint('BOTTOMRIGHT')
	borderbot:SetHeight(D.API.scale(10))
	borderbot:SetTexture(0, 0, 0)