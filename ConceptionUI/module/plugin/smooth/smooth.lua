-- All Credits to Xuerian --

local C, D = unpack(select(2,...))
local UNIT_FRAMES = C.UNITFRAME
local smoothing = {}
local function Smooth(self, value)
	if value == self:GetValue() then
		smoothing[self] = nil
		self:SetValue_(value)
	else
		smoothing[self] = value
	end
end

local function SmoothBar(bar)
	bar.SetValue_ = bar.SetValue
	bar.SetValue = Smooth
end

local function hook(frame)
	if frame.hpBar then SmoothBar(frame.hpBar) end
	if frame.ppBar then SmoothBar(frame.ppBar) end
end

function D.LOAD.I:Smoooooth()
	for index, frame in pairs(UNIT_FRAMES.Major) do hook(frame) end
	for index, frame in pairs(UNIT_FRAMES.Minor) do hook(frame) end
end

local min, max, abs, GetFramerate = math.min, math.max, math.abs, GetFramerate
local function OnUpdate()
		local limit = 30/GetFramerate()
		for bar, value in pairs(smoothing) do
			local cur = bar:GetValue()
			local new = cur + min((value-cur)/3, max(value-cur, limit))
			if new ~= new then new = value end -- Mad hax to prevent QNAN.
			bar:SetValue_(new)
			if (cur == value) or (abs(new-value) < 1) then
				bar:SetValue_(value)
				smoothing[bar] = nil
			end
		end
end
local f = CreateFrame('Frame')
	f:SetScript('OnUpdate', OnUpdate)