local m=82228563
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCondition(cm.spcon)  
	c:RegisterEffect(e1)
	--to grave  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_TOGRAVE)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con1) 
	e2:SetTarget(cm.tg)  
	e2:SetOperation(cm.op)
	e2:SetCost(cm.cost2)  
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(cm.con2)
	e3:SetCost(cm.cost)
	c:RegisterEffect(e3)
end
function cm.spfilter(c)  
	return c:IsCode(82228562)  
end  
function cm.spcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)  
end 
function cm.con1(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsPlayerAffectedByEffect(tp,82228569)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp) 
	return not Duel.IsPlayerAffectedByEffect(tp,82228569)
end 
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)  
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)  
end  
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end  
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)   
end  
function cm.tgfilter(c)  
	return c:IsSetCard(0x297) and not c:IsCode(m) and c:IsAbleToGrave()  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoGrave(g,REASON_EFFECT)  
	end  
end  