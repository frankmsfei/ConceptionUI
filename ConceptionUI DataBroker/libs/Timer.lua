local Timer = CreateFrame('Frame')
	Timer:RegisterEvent('PLAYER_LOGIN')

function Timer:OnLogin(func)
	self:HookScript('OnEvent', func)
end

function Timer:Update(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed < self.sec then return end
	self.elapsed = 0
	self.func()
end

function Timer:Set(key, sec, func)
	assert(not self[key], 'Timer: ['..key..'] Alerady Exist!!')
	self[key] = {elapsed = 0, sec = sec, func = func}
	self:HookScript('OnUpdate', function(self, elapsed) self:Update(self[key], elapsed) end)
end

_G['Timer'] = Timer