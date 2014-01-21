local cargoShip = LibStub('LibCargoShip-2.1')

local qck = cargoShip('QuickClick')
local net = cargoShip('NetStats')
local fps = cargoShip('Graphics')
local mem = cargoShip('Memory')
local spc = cargoShip('Spec')
local dur = cargoShip('Durability')
local equ = cargoShip('Equip')
local log = cargoShip('CombatLog')

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
log:SetPoint('RIGHT', mem, 'LEFT', -x, 0)
log.Text:SetJustifyH('RIGHT')


-- BOTTOM CENTER
spc:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 0)
spc.Text:SetJustifyH('CENTER')
equ:SetPoint('RIGHT', spc, 'LEFT', -x, 0)
equ.Text:SetJustifyH('RIGHT')
dur:SetPoint('LEFT', spc, 'RIGHT', x, 0)
dur.Text:SetJustifyH('LEFT')