--罗德岛·行动-战术指导
function c79029253.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029253,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,09029253)
	e2:SetCost(c79029253.thcost)
	e2:SetTarget(c79029253.thtg)
	e2:SetOperation(c79029253.thop)
	c:RegisterEffect(e2)   
	--sset
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029253,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetCountLimit(1,79029253)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c79029253.sscost)
	e2:SetTarget(c79029253.sstg)
	e2:SetOperation(c79029253.ssop)
	c:RegisterEffect(e2) 
end
function c79029253.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c79029253.tdfil(c,e)
	return c:IsAbleToHand() and c:IsSetCard(0xa900)
end
function c79029253.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetMatchingGroupCount(c79029253.tdfil,tp,LOCATION_DECK,0,nil,e)>=1 end
	local g=Duel.SelectMatchingCard(tp,c79029253.tdfil,tp,LOCATION_DECK,0,1,1,nil,e)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
end
function c79029253.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)  
end
function c79029253.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c79029253.ssfil(c,e)
	return c:IsSSetable() and (c:IsSetCard(0xb90d) or c:IsSetCard(0xc90e))
end
function c79029253.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetMatchingGroupCount(c79029253.ssfil,tp,LOCATION_DECK,0,nil,e)>=1 end
	local g=Duel.SelectMatchingCard(tp,c79029253.ssfil,tp,LOCATION_DECK,0,1,1,nil,e)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,g,1,tp,LOCATION_DECK)
end
function c79029253.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
end
end



