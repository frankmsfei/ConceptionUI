local _, D = unpack(select(2,...))
if C.CLASS ~= 'DEATHKNIGHT' then return end

RuneFrame:SetScale(D.API.scale(1))
RuneFrame:ClearAllPoints()
RuneFrame:SetPoint('TOP', UIParent, 'CENTER', 0, -130)