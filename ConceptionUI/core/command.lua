local SlashCmdList = SlashCmdList

-- Set CVar
SLASH_SCV1 = '/scv'
SlashCmdList.SCV = function(x)
	local cvar, n = x:match("^(%S*)%s*(%S*).-$")
	SetCVar(cvar, n)
end

-- Get CVar
SLASH_GCV1 = '/gcv'
SlashCmdList.GCV = function(cvar)
	print(GetCVar(cvar))
end

-- Sound Effect Switch
SLASH_SFX1 = '/x'
SlashCmdList.SFX = function()
	SetCVar('Sound_EnableSFX', 1-GetCVar('Sound_EnableSFX'))
end

-- Ready Check
SLASH_READYCHECK1 = '/rc'
SlashCmdList.READYCHECK = DoReadyCheck

-- Role Selec
SLASH_ROLESELECT1 = '/rs'
SlashCmdList.ROLESELECT = InitiateRolePoll

-- Calendar
SLASH_CALENDER1 = '/c'
SlashCmdList.CALENDER = ToggleCalendar

-- BN CustomMessage
SLASH_BN1 = '/bn'
SlashCmdList.BN = BNSetCustomMessage

-- 取出收起武器
SLASH_WEAPON1 = '/weapon'
SlashCmdList.WEAPON = ToggleSheath

-- Take BattlePet off
SLASH_PETOFF1 = '/petoff'
SlashCmdList.PETOFF = function(slot)
	if slot == '' then
		C_PetJournal.SetPetLoadOutInfo(1, 0)
		C_PetJournal.SetPetLoadOutInfo(2, 0)
		C_PetJournal.SetPetLoadOutInfo(3, 0)
	else
		C_PetJournal.SetPetLoadOutInfo(slot, 0)
	end
end

-- FarClip
SLASH_SETFARCLIP1 = '/fc'
SlashCmdList.SETFARCLIP = function(x)
	if x == '' then
		print('Farclip: '..GetCVar('farclip')..' (0-1600)')
	elseif x=='L' or x=='l' or x=='low' then
		SetCVar('farclip', 200)
	elseif x=='N' or x=='n' or x=='normal' then
		SetCVar('farclip', 600)
	elseif x=='G' or x=='g' or x=='good' then
		SetCVar('farclip', 800)
	elseif x=='H' or x=='h' or x=='high' then
		SetCVar('farclip', 1000)
	elseif x=='B' or x=='b' or x=='best' then
		SetCVar('farclip', 1300)
	elseif x=='U' or x=='u' or x=='ultra' then
		SetCVar('farclip', 1600)
	else
		SetCVar('farclip', x)
	end
end

-- Camera Zoom
SLASH_ZOOM1 = '/z'
SlashCmdList.ZOOM = function(n)
	n = tonumber(n)
	if not n then return print('Use "/z n" to zoom out or "/z -n" to zoom in.') end
	if abs(n) == 0 then
		CameraZoomOut(50)
	elseif n > 0 then
		CameraZoomOut(n)
	elseif n < 0 then
		CameraZoomIn(-n)
	end
end


-- NamePlates Toggle
SLASH_NAMEPLATE1 = '/n'
SlashCmdList.NAMEPLATE = function(x)
	local f, e = nil, nil
	if x == '0' then
		f = 0
		e = 0
	elseif x == '1' then
		f = 1
		e = 1
	elseif x == 'f' then
		f = 1
		e = 0
	elseif x == 'e' then
		f = 0
		e = 1
	end
	if f and e then
		local friend = {'nameplateShowFriends','nameplateShowFriendlyPets','nameplateShowFriendlyGuardians','nameplateShowFriendlyTotems'}
		local enemy = {'nameplateShowEnemies','nameplateShowEnemyPets','nameplateShowEnemyGuardians','nameplateShowEnemyTotems'}
		for k, v in pairs(friend) do SetCVar(v, f) end
		for k, v in pairs(enemy) do SetCVar(v, e) end
	end
end