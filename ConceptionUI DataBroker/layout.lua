local	cargoShip = LibStub('LibCargoShip-2.1')


local qck = cargoShip('QuickClick')
local net = cargoShip('NetStats')
local fps = cargoShip('Graphics')
local mem = cargoShip('Memory')
local pbs = cargoShip('PetBattleStone')
local spc = cargoShip('Spec')
local dur = cargoShip('Durability')
local equ = cargoShip('Equip')

--local txt = cargoShip('Simply Notes',	{noIcon = false, noText = true})
--local bag = cargoShip('BankStack',		{noIcon = false, noText = true})	
						
--		local whisp = cargoShip('Broker_WhisperWhisper', {noIcon = false, noText = true})
--		whisp:SetPoint('LEFT', fps, 'RIGHT', x, 0)
local	x = 16
-- BOTTOM RIGHT
qck:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -8, 0)
qck.Text:SetJustifyH('RIGHT')
net:SetPoint('RIGHT', qck, 'LEFT', -x, 0)
net.Text:SetJustifyH('RIGHT')
fps:SetPoint('RIGHT', net, 'LEFT', -x, 0)
fps.Text:SetJustifyH('RIGHT')
mem:SetPoint('RIGHT', fps, 'LEFT', -x, 0)
mem.Text:SetJustifyH('RIGHT')
pbs:SetPoint('RIGHT', mem, 'LEFT', -x, 0)
pbs.Text:SetJustifyH('RIGHT')

-- BOTTOM CENTER
spc:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 0)
equ:SetPoint('RIGHT', spc, 'LEFT', -x, 0)
equ.Text:SetJustifyH('RIGHT')
dur:SetPoint('LEFT', spc, 'RIGHT', x, 0)
dur.Text:SetJustifyH('LEFT')

-- ICON BUTTONS
--txt:SetPoint('RIGHT', TimeManagerClockButton, 'LEFT', x, 0)
--bag:SetPoint('RIGHT', TimeManagerClockButton, 'LEFT', -3*x, 0)

--[[
local obj = {qck, net, fps, mem, pbs, spc, dur, equ}
for k, v in pairs(obj) do
	if v.Text then v.Text:SetFont('Interface\\AddOns\\ConceptionUI\\media\\fonts\\pixel.ttf', 10) end
	if v.Icon then v.Icon:SetTexCoord(.1, .9, .1, .9) end
end
wipe(obj)
]]