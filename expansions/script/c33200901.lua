--寒霜灵兽 暴雪王
function c33200901.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,33200901)
	e1:SetCost(c33200901.spcost)
	e1:SetTarget(c33200901.sptg)
	e1:SetOperation(c33200901.spop)
	c:RegisterEffect(e1)
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200901,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33200901.dcttg)
	e2:SetOperation(c33200901.dctop)
	c:RegisterEffect(e2)
	--weather
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33200901,0))
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,33210901)
	e0:SetCondition(c33200901.condition)
	e0:SetOperation(c33200901.operation)
	c:RegisterEffect(e0)
	local e3=e0:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

--e1
function c33200901.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST)
end
function c33200901.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c33200901.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e2
function c33200901.ctfilter(c)
	return c:GetCounter(0x132a)>0 and c:IsType(TYPE_MONSTER)
end
function c33200901.dcttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c33200901.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200901.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c33200901.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.floor(tc:GetDefense()/2))
end
function c33200901.dctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local def=math.floor(tc:GetDefense()/2)
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT) and def>0 then
		Duel.Recover(tp,def,REASON_EFFECT)
	end
end

--e3
function c33200901.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33200900)==0 and Duel.GetFlagEffect(1-tp,33200900)==0
end
function c33200901.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,33200900)==0 and Duel.GetFlagEffect(1-tp,33200900)==0 then 
		Duel.ResetFlagEffect(tp,33201000)
		Duel.ResetFlagEffect(tp,33201100)
		Duel.ResetFlagEffect(1-tp,33201000)
		Duel.ResetFlagEffect(1-tp,33201100)
		local c=e:GetHandler()
		Duel.Hint(24,0,aux.Stringid(33200900,0))
		Duel.RegisterFlagEffect(tp,33200900,RESET_PHASE+PHASE_END,0,5)
		Duel.RegisterFlagEffect(1-tp,33200900,RESET_PHASE+PHASE_END,0,5)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetLabel(0)
		e2:SetOperation(c33200901.ctop)
		e2:SetReset(RESET_PHASE+PHASE_END,5)
		Duel.RegisterEffect(e2,tp)
	end
end
function c33200901.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if Duel.GetFlagEffect(tp,33200900)<=0 then 
		e:Reset()
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD):Filter(Card.IsFaceup,nil)
	Duel.Hint(HINT_CARD,tp,33200900)
	Duel.Hint(24,0,aux.Stringid(33200900,2))
	for tc in aux.Next(g) do
		if tc:IsCanAddCounter(0x132a,1) then
			tc:AddCounter(0x132a,1)
		end
	end
	ct=ct+1
	e:SetLabel(ct)
	if ct==5 then
		Duel.Hint(HINT_CARD,tp,33200899)
		Duel.Hint(24,0,aux.Stringid(33200899,0))
		Duel.ResetFlagEffect(tp,33200900)
		Duel.ResetFlagEffect(1-tp,33200900)
	end
end