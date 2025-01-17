local m=53727009
local cm=_G["c"..m]
cm.name="身份注销"
function cm.initial_effect(c)
	aux.AddCodeList(c,53727003)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.setcon)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(cm.reset)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SSET)
		ge3:SetOperation(cm.seteg)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	cm.chain=true
end
function cm.seteg(e,tp,eg,ep,ev,re,r,rp)
	if cm.chain==true then
		local g=Group.CreateGroup()
		if cm[0] then g=cm[0] end
		g:Merge(eg)
		g:KeepAlive()
		cm[0]=g
	end
	if cm.chain==false then
		Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
	end
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm.chain=false
	if not cm[0] then return end
	Duel.RaiseEvent(cm[0],EVENT_CUSTOM+m,re,r,rp,ep,ev)
	cm[0]=nil
end
function cm.filter(c)
	return c:IsCode(53727003) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:GetOriginalCodeRule()==53727003 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
		else
			local code=tc:GetOriginalCodeRule()
			local max=Duel.GetFlagEffect(0,53727001)
			for i=1,max do
				if Duel.GetFlagEffect(0,53777000+i)>0 and Duel.GetFlagEffectLabel(0,53777000+i)==code then Duel.SetFlagEffectLabel(0,53777000+i,114) end
			end
			local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,0,0xff,0xff,nil,code)
			for nc in aux.Next(g) do
				local effs={nc:IsHasEffect(EFFECT_ADD_CODE)}
				for _,eff in ipairs(effs) do
					if eff:GetLabel()==53727001 then eff:Reset() end
				end
			end
		end
	end
end
function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable(true) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.cfilter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	local rg=g:Clone()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	if #rg>1 then rg=g:Select(tp,1,1,nil) end
	Duel.HintSelection(rg)
	if Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)~=0 and rg:GetFirst():IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
	end
end
