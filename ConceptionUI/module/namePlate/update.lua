local UnitExists = UnitExists

local NAMEPLATE = select(2,...)[1].NAMEPLATE


function NAMEPLATE:Update(plate)
	local r, g, b, player, enemy, name = plate.r, plate.g, plate.b, plate.player, plate.enemy, plate.name
	local a = 0
	local class = nil

	if player then
		if enemy then
			a = 1
		else
			r, g, b, class = NAMEPLATE.class(name)
		end
	else
		r, g, b = plate:CheckColor()
		if enemy then
			local _, ng, nb = plate.old_name:GetTextColor()
			if ng + nb == 0 then
				a = 1
			end
		end
	end

	if plate.highlight:IsShown() then
		a = 1
		if player and (not class) then
			if UnitExists('mouseover') then
				r, g, b = self:CheckClass('mouseover')
			end
		end
	elseif UnitExists('target') then
		if plate:GetAlpha() == 1 then
			a = 1
			if player and (not class) then
				if UnitExists('target') then
					r, g, b = self:CheckClass('target')
				end
			end
		end
	end

	plate:UpdateColor(r, g, b, a)
	plate:CheckThreat()
end