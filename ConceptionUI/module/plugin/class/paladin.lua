local C, D = unpack(select(2,...))
if C.CLASS ~= 'PALADIN' then return end

local x, y = 0, -132
local dp = GetSpellInfo(90174)
local buff, buff_texture = nil, nil

local GetSpecialization = GetSpecialization
local function UpdateSpec(self)
	local spec = GetSpecialization()
	if not spec then
		buff = nil
		buff_texture = nil
	elseif spec == 3 then -- Retribution
		buff = 84963 -- 異端
		buff_texture = [[Interface\AddOns\ConceptionUI\media\texture\holyPower\inq]]
	elseif spec == 2 then -- Protection
		buff = 132403 -- 公正盾
		buff_texture = [[Interface\AddOns\ConceptionUI\media\texture\holyPower\sor]]
	elseif spec == 1 then -- Holy
		buff = 88819 -- 破曉之光
		buff_texture = [[Interface\AddOns\ConceptionUI\media\texture\holyPower\sor]]
	end
	buff = GetSpellInfo(buff)
	self.BG:SetTexture(buff_texture)
	self.BG:SetVertexColor(.62, 0, 0, .5)
end

local remain, expiration, lastupdate = nil, nil, 0
local GetTime = GetTime
local function CountDown(self, elapsed)
	lastupdate = lastupdate + elapsed
	if lastupdate > .1 then lastupdate = 0
		remain = expiration - GetTime()
		if remain < 0 then
			self.SECOND:SetText()
			return
		elseif remain <= 4 then
			self.SECOND:SetFormattedText('|cFF9E0000%.1f|r', remain)
			return
		else
			self.SECOND:SetFormattedText('|cFF9E9E9E%d|r', remain)
			return
		end
	end
end


local api = D.API
local scale, Frame, Texture, String = api.scale, api.Frame, api.Texture, api.String
local F = Frame('ConceptionUI Paladin Plugin', C, 'TOP', UIParent, 'CENTER', x, y, 64, 64)
	F.BG = Texture(F, 'CENTER', F, 'CENTER', 0, 0, 64, 64, 'BACKGROUND')
	F.SECOND = String(F, 'CENTER', F, 'CENTER', 0, -2, D.MEDIA.FONT.edo, 18, 'NONE', 0, -1)
	F.HP = Texture(F, 'TOP', F, 'BOTTOM', 0, 16, 256, 32, 'BACKGROUND')
	F.HP:SetTexture('Interface/ComboFrame/ComboFrameBackground')
	F:SetScript('OnEvent', function(self, event, ...) return self[event](self, ...) end)
	F:RegisterEvent('PLAYER_ENTERING_WORLD')
	F:RegisterEvent('ZONE_CHANGED')
	F:RegisterUnitEvent('UNIT_AURA', 'player')
	F:RegisterUnitEvent('UNIT_POWER', 'player')
	F:RegisterUnitEvent('PLAYER_SPECIALIZATION_CHANGED', 'player')

local function CreatePoint(self)
	for i = 1, 5 do
		local size = (5==i) and 36 or 30
		local f = Frame(nil, self)
			f:SetSize(size, size)
			f:SetPoint("LEFT", F.HP, "LEFT", 65+23.5*(i-1), 0)
			f.tex = Texture(f, 'CENTER', f, 'CENTER', 0, 7, size, 1.5*size, 'OVERLAY')
			f.tex:SetTexture(D.MEDIA.TEXTURE.fire)
			f.tex:SetBlendMode("BLEND")
			f.tex:SetTexCoord(0,0.08333,0,1)
			f.tex:SetVertexColor(.62, .62*.25*(5-i), 0)
			f:SetAlpha(0)

		local t = (2 * 0.08333 * i)
		local function Loop()
			t = t + .08333
			if t > .99 then t = 0 end
			f.tex:SetTexCoord(t, .08333 + t, 0, 1)
		end

		f.l = f:CreateAnimationGroup()
		f.l:SetLooping('REPEAT')
		f.l:SetScript('OnLoop', Loop)
		f.l.a = f.l:CreateAnimation()
		f.l.a:SetDuration(.06)

		f.a = f:CreateAnimationGroup()
		f.a:SetLooping('NONE')
		f.a.a = f.a:CreateAnimation("Alpha")
		f.a.a:SetOrder(1)
		f.a.a:SetChange(1)
		f.a.a:SetDuration(.4)
		f.a:SetScript("OnFinished",function()f:SetAlpha(1)end)

		f.d = f:CreateAnimationGroup()
		f.d:SetLooping('NONE')
		f.d.a = f.d:CreateAnimation("Alpha")
		f.d.a:SetOrder(1)
		f.d.a:SetChange(-1)
		f.d.a:SetDuration(.5)
		f.d:SetScript("OnFinished",function()
			f:SetAlpha(0)
			f.l:Stop()
		end)
		F[i] = f
	end
end
CreatePoint(F)

local UnitPower, SPELL_POWER_HOLY_POWER = UnitPower, SPELL_POWER_HOLY_POWER
local function UpdatePower()
	local hop = UnitPower('player', SPELL_POWER_HOLY_POWER)
	for i = 1, 5 do
		local cp = F[i]
		if i <= hop then
			cp.a:Play()
			cp.l:Play()
		else
			cp.d:Play()
		end
	end
end

local select, UnitAura = select, UnitAura 
local function UpdateAura(self)
	if not buff then return end
	expiration = select(7, UnitAura('player', buff))
	if expiration then
		self:SetScript('OnUpdate', CountDown)
		self.BG:SetVertexColor(0, 0, 0, .7)
	else
		self:SetScript('OnUpdate', nil)
		self.SECOND:SetText(nil)
		self.BG:SetVertexColor(.62, 0, 0, .5)
		remain, expiration, lastupdate = nil, nil, 0
	end
end

function F:UNIT_POWER(unit, powertype)
	if powertype ~= 'HOLY_POWER' then return end
	UpdatePower()
end

function F:UNIT_AURA()
	UpdateAura(self)
end

function F:PLAYER_ENTERING_WORLD()
	UpdateSpec(self)
end

function F:PLAYER_SPECIALIZATION_CHANGED()
	UpdateSpec(self)
end

function F:ZONE_CHANGED()
	UpdatePower()
end