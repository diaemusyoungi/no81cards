--奉神天使 雷米尔
local m=20000357
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function cm.initial_effect(c)
	local e1=fs.sum(c,m,function(c)return c:IsLocation(LOCATION_GRAVE)and c:IsAbleToRemove()end,
	function(e,tp,eg,ep,ev,re,r,rp,g,fc)Duel.Remove(g,POS_FACEUP,REASON_EFFECT)end)
end