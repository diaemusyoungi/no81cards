--ANOTHER RIDER Accel
function c65010335.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c65010335.condition)
	e1:SetTarget(c65010335.target)
	e1:SetOperation(c65010335.activate)
	c:RegisterEffect(e1)
end
function c65010335.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c65010335.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xcda0)
end
function c65010335.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010335.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c65010335.filter2(c,e)
	return c:IsFaceup() and c:IsSetCard(0xcda0) and not c:IsImmuneToEffect(e)
end
function c65010335.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c65010335.filter2,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(65010335,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		tc=sg:GetNext()
	end
	sg:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(fid)
	e2:SetLabelObject(sg)
	e2:SetCondition(c65010335.descon)
	e2:SetOperation(c65010335.desop)
	Duel.RegisterEffect(e2,tp)
end
function c65010335.desfilter(c,fid)
	return c:GetFlagEffectLabel(65010335)==fid
end
function c65010335.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c65010335.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c65010335.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local dg=g:Filter(c65010335.desfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Destroy(dg,REASON_EFFECT)
end

