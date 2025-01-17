--虹彩偶像 中须霞
function c9910383.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910383)
	e1:SetCondition(c9910383.spcon)
	e1:SetTarget(c9910383.sptg)
	e1:SetOperation(c9910383.spop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910389)
	e2:SetTarget(c9910383.rmtg)
	e2:SetOperation(c9910383.rmop)
	c:RegisterEffect(e2)
end
function c9910383.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c9910383.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910383.spfilter(c,e,tp)
	return c:IsSetCard(0x5951) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910383.fselect(g,tp,c)
	local res=true
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then
		res=g:GetCount()<=1
	end
	return res and g:IsContains(c)
end
function c9910383.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9910383.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c9910383.fselect,false,1,2,tp,e:GetHandler())
	if sg:GetCount()>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
end
function c9910383.spellfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c9910383.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9910383.spellfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910383.spellfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910383,0))
	local g=Duel.SelectTarget(tp,c9910383.spellfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	g:AddCard(e:GetHandler())
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
end
function c9910383.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if g2:GetCount()==0 then return end
	Duel.HintSelection(g2)
	if Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)==0 then return end
	local rc=g2:GetFirst()
	if rc:IsLocation(LOCATION_REMOVED) then
		local fid=c:GetFieldID()
		rc:RegisterFlagEffect(9910383,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(fid)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910383.retcon)
		e1:SetOperation(c9910383.retop)
		Duel.RegisterEffect(e1,tp)
	end
	local g=Group.CreateGroup()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then g:AddCard(c) end
	if tc:IsRelateToEffect(e) then g:AddCard(tc) end
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c9910383.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffectLabel(9910383)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c9910383.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc:IsAbleToDeck() then return end
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.SelectYesNo(tp,aux.Stringid(9910383,1)) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		e:Reset()
	end
end
