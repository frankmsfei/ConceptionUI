local NAMEPLATE = select(2,...)[1].NAMEPLATE

local BLACKLIST = {
	['虛無觸鬚'] = true,
	['暗影幻靈'] = true,
	['狂野小鬼'] = true,
	['亡靈大軍'] = true,
	['血蟲'] = true,
	['樹人'] = true,
}

local unpack = unpack
local DEFAULT_COLOR = setmetatable({
	HOSTILE	= {.618, .191, .191, nil},
	NEUTRAL	= {.618, .618, .382, nil},
	FRIENDLY	= {.191, .191, .618, nil},
	GRAY		= {.382, .382, .382, nil},
	NPC		= {.191, .618, .191, nil}
}, {__call = function(self, key) return unpack(self[key]) end})
NAMEPLATE.DEFAULT_COLOR = DEFAULT_COLOR

NAMEPLATE.OnShow = function(self)
	local name = self.old_name:GetText():gsub('%s%p+', '')
	if BLACKLIST[name] then
		self.hp:Hide()
		self:UpdateColor(0, 0, 0, 0)
		return
	end
	self.name = name
	self.update = name
	self.id:SetText(name)

	self.r, self.g, self.b = self:CheckColor()
	self:UpdateColor(self.r, self.g, self.b, 0)

	self:CheckHealth()
	self.hp:Show()

	NAMEPLATE.plates[self] = true
	--NAMEPLATE:Update(self)

	if not enemy then return end
	if self.boss:IsShown() then
		self.lv:SetText('|cFF9E0000B|r')
	else
		local level = self.level:GetText() or '??'
		if self.elite:IsShown() then
			if not self.elite:GetTexture() == 'Interface\\Tooltips\\EliteNameplateIcon' then
				self.lv:SetText(level..'R')
			else
				self.lv:SetText(level..'+')
			end
		else
			self.lv:SetText(level)
		end
		self.lv:SetTextColor(self.level:GetTextColor())
	end
end

NAMEPLATE.OnHide = function(self)
	NAMEPLATE.plates[self] = nil
	self.r, self.g, self.b = nil, nil, nil
	self.id:SetText(nil)
	self.lv:SetText(nil)
	self.name = nil
	self.player = nil
	self.enemy = nil
end

NAMEPLATE.CheckColor = function(self)
	local r, g, b = self.old_healthbar:GetStatusBarColor()
	if r + g == 0 then					-- BLUE
		self.player = true
		self.enemy = false
		return DEFAULT_COLOR('FRIENDLY')
	elseif g + b == 0 then					-- RED
		self.player = false
		self.enemy = true
		return DEFAULT_COLOR('HOSTILE')
	elseif r == g and g == b and r - .5 < .1 then	-- GRAY
		self.player = false
		self.enemy = true
		r, g, b = self.old_name:GetTextColor()
		if g + b == 0 then
			return DEFAULT_COLOR('HOSTILE')
		else
			return DEFAULT_COLOR('GRAY')
		end
	elseif r + g > 1.9 and b == 0 then			-- YELLOW
		self.player = false
		self.enemy = true
		return DEFAULT_COLOR('NEUTRAL')
	elseif r + b == 0 then					-- GREEN
		self.player = false
		self.enemy = false
		return DEFAULT_COLOR('NPC')
	else								-- ENEMY PLAYER
		self.player = true
		self.enemy = true
		return r, g, b
	end
end

NAMEPLATE.UpdateColor = function(self, r, g, b, a)
	self.id:SetTextColor(r, g, b, 1)
	self.healthbar:SetStatusBarColor(r, g, b, a)
	self.bg:SetBackdropColor(0, 0, 0, a)
	if not self.enemy then
		self.bg:SetBackdropBorderColor(r, g, b, a)
		return
	else
		self.bg:SetBackdropBorderColor(0, 0, 0, a)
	end
end

NAMEPLATE.CheckThreat = function(self)
	if not self.threatGlow:IsShown() then
		return
	end
	local r, g, b = self.threatGlow:GetVertexColor()
	self.healthbar:SetStatusBarColor(r, g, b, 1)
	self.bg:SetBackdropColor(0, 0, 0, 1)
	self.bg:SetBackdropBorderColor(.382*r, .382*g, .382*b, 1)
end

NAMEPLATE.CheckHealth = function(self)
	if not self.hp:IsShown() then
		return
	end
	local hpCur, hpMin, hpMax = self.old_healthbar:GetValue(), self.old_healthbar:GetMinMaxValues()
	self.healthbar:SetMinMaxValues(hpMin, hpMax)
	self.healthbar:SetValue(hpCur)
	--self.hpMax = hpMax
	if hpCur == hpMax then 
		self.hp:SetText(nil)
		return
	end
	local hpPer = hpCur/(hpMax-hpMin)
	self.hp:SetFormattedText('%d%%', 100*hpPer)
	if hpPer > .5 then
		self.hp:SetTextColor(0, 1, 0)
		return
	elseif hpPer > .2 then
		self.hp:SetTextColor(1, 1, 0)
		return
	else
		self.hp:SetTextColor(1, 0, 0)
		return 
	end
end

NAMEPLATE.CheckCast = function(self)
	if not self:IsShown() then
		return
	end
	self.castbar:SetValue(self:GetValue())
	local min, max = self:GetMinMaxValues()
	self.castbar:SetMinMaxValues(min, max)
	if self.shield:IsShown() then
		self.castbar:SetStatusBarColor(1, 0, 0)
	else
		self.castbar:SetStatusBarColor(1, 1, 0)
	end
end

NAMEPLATE.ShowCastBar = function(self)
	self.castbar:Show()
end

NAMEPLATE.HideCastbar = function(self)
	self.castbar:Hide()
end