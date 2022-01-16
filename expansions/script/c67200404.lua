--术结天缘 静寂咏唱
function c67200404.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200404+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c67200404.target)
	e1:SetOperation(c67200404.operation)
	c:RegisterEffect(e1)	
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200404,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,67200405)
	e2:SetTarget(c67200404.thtg)
	e2:SetOperation(c67200404.thop)
	c:RegisterEffect(e2)
end
--
function c67200404.thfilter(c,e,tp)
	return c:IsSetCard(0x5671) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c67200404.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200404.thfilter,tp,LOCATION_DECKBOT,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECKBOT)
end
function c67200404.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g==0 then return end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	Duel.MoveSequence(tc,0)
	Duel.ConfirmDecktop(tp,1)
	--Duel.MoveSequence(tc,1)
	if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x5671) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,tc)
		local ct=tc:GetLevel()
		if ct>0 and Duel.GetMatchingGroupCount(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x1,1)>0
			and Duel.SelectYesNo(tp,aux.Stringid(67200404,0)) then
			while ct>0 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
				local ttc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,1,1,nil,0x1,1):GetFirst()
				if not ttc then break end
				ttc:AddCounter(0x1,1)
				ct=ct-1
			end
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
		end
	end
end
--
function c67200404.thfilter(c)
	return c:IsSetCard(0x5671) and c:IsAbleToDeck()
end
function c67200404.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200404.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_COST) end
	local g=Duel.GetMatchingGroup(c67200404.thfilter,tp,LOCATION_GRAVE,0,nil)
	local count=g:GetCount()
	local lvt={}
	local tc=g:GetFirst()
	while count>0 do
		local tlv=count
		lvt[tlv]=tlv
		count=count-1
	end
	local pc=1
	for i=1,g:GetCount() do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200404,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.RemoveCounter(tp,1,0,0x1,lv,REASON_COST)
	e:SetLabel(lv)
end
function c67200404.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if not Duel.IsCanRemoveCounter(tp,1,0,0x1,lv,REASON_COST) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c67200404.thfilter,tp,LOCATION_GRAVE,0,lv,lv,nil)
	if g:GetCount()>0 then
		--Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if ct==0 then return end
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end


