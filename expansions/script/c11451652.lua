--查拉图斯特喵如是说
--21.12.25
local m=11451652
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local t=debug.getregistry()
	for _,v in pairs(t) do
		if aux.GetValueType(v)=="Effect" and v:GetHandler():IsOriginalCodeRule(ac) and v:GetType()&EFFECT_TYPE_IGNITION>0 and v:GetHandler():GetOriginalType()&TYPE_MONSTER>0 then
			v:SetType(EFFECT_TYPE_QUICK_O)
			v:SetCode(EVENT_FREE_CHAIN)
			local pro,pro2=v:GetProperty()
			pro=pro|EFFECT_FLAG_CANNOT_DISABLE
			pro=pro|EFFECT_FLAG_CANNOT_INACTIVATE
			v:SetProperty(pro,pro2)
		end
	end
end