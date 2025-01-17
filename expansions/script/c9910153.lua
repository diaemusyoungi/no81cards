--战车道的探寻
function c9910153.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910153+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910153.target)
	e1:SetOperation(c9910153.activate)
	c:RegisterEffect(e1)
end
function c9910153.xyzfilter(c,tp)
	return c:IsSetCard(0x952) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c9910153.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetRank())
end
function c9910153.thfilter(c,lv)
	return c:IsSetCard(0x952) and c:IsType(TYPE_MONSTER) and c:GetOriginalLevel()==lv and c:IsAbleToHand()
end
function c9910153.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910153.xyzfilter,tp,LOCATION_EXTRA,0,nil,tp)
	if chk==0 then return g:GetClassCount(Card.GetRank)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910153.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910153.xyzfilter,tp,LOCATION_EXTRA,0,nil,tp)
	if g:GetClassCount(Card.GetRank)<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.drkcheck,false,3,3)
	if sg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,sg)
	local tc=sg:RandomSelect(1-tp,1):GetFirst()
	Duel.ConfirmCards(tp,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c9910153.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetRank())
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	Duel.ShuffleExtra(tp)
	for sc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
		e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c9910153.spfilter)
		e1:SetLabelObject(sc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_INACTIVATE)
		e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetValue(c9910153.effilter)
		e2:SetLabelObject(sc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_DISEFFECT)
		e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
		e3:SetValue(c9910153.effilter)
		e3:SetLabelObject(sc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c9910153.spfilter(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c9910153.effilter(e,ct)
	local tc=e:GetLabelObject()
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
