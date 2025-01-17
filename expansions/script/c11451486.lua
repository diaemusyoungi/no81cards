--魔人★双子兵装 冰封女神
local m=11451486
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.spcon)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.imcon)
	e2:SetCost(cm.imcost)
	e2:SetTarget(cm.imtg)
	e2:SetOperation(cm.imop)
	c:RegisterEffect(e2)
	--setname
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetRange(0xff)
	e5:SetValue(0x151)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetValue(0x6d)
	c:RegisterEffect(e6)
end
function cm.spfilter(c,sc)
	return c:IsCanBeXyzMaterial(sc) and ((c:IsFaceup() and (c:IsXyzLevel(sc,8) or (c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_FAIRY)))) or (c:IsLocation(LOCATION_HAND) and (c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_FAIRY))))
end
function cm.hand(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1
end
function cm.spcon(e,c,og,min,max)
	if c==nil then return true end
	if og and not min then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c,c)
	if og then
		local og2=og:Filter(Card.IsCanBeXyzMaterial,nil,c)
		g:Merge(og2)
	end
	return g:CheckSubGroup(cm.hand,2,2)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then return true end
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c,c)
	if og then
		local og2=og:Filter(Card.IsCanBeXyzMaterial,nil,c)
		g:Merge(og2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:SelectSubGroup(tp,cm.hand,Duel.IsSummonCancelable(),2,2)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
		local sg=Group.CreateGroup()
		for tc in aux.Next(og) do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local g=e:GetLabelObject()
		local sg=Group.CreateGroup()
		for tc in aux.Next(g) do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(g)
		Duel.Overlay(c,g)
		if g:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then Duel.ShuffleHand(tp) end
		g:DeleteGroup()
	end
end
function cm.filter(c,e)
	return c:IsCanOverlay() and c:IsCanBeEffectTarget(e)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and cm.filter(chkc,e) and chkc~=e:GetHandler() end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler(),e)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and (#g>=2 or (#g>0 and Duel.IsPlayerAffectedByEffect(tp,11451482))) end
	local op=0
	if Duel.IsPlayerAffectedByEffect(tp,11451482) then
		if #g>=2 then
			op=Duel.SelectOption(tp,aux.Stringid(11451483,2),aux.Stringid(11451483,3))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451483,op+2))
			if op==1 then
				Duel.RegisterFlagEffect(tp,11451482,0,0,1)
				Duel.ResetFlagEffect(tp,11451481)
			end
		else
			op=1
			Duel.RegisterFlagEffect(tp,11451482,0,0,1)
			Duel.ResetFlagEffect(tp,11451481)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,2-op,2-op,e:GetHandler(),e)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	else
		e:SetCategory(0)
	end
	if g1:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,1,0,0) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if not c:IsRelateToEffect(e) or #tg==0 then return false end
	if #tg==1 then
		local tc=tg:GetFirst()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,tc)
	end
	if #tg>1 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_XMATERIAL)
		local tc=tg:Select(1-tp,1,1,nil):GetFirst()
		tg:RemoveCard(tc)
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,tc)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function cm.imcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function cm.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) or (c:CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsPlayerAffectedByEffect(tp,11451482)) end
	local op=0
	if Duel.IsPlayerAffectedByEffect(tp,11451482) then
		if c:CheckRemoveOverlayCard(tp,2,REASON_COST) then
			op=Duel.SelectOption(tp,aux.Stringid(11451483,2),aux.Stringid(11451483,3))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451483,op+2))
			if op==1 then
				Duel.RegisterFlagEffect(tp,11451482,0,0,1)
				Duel.ResetFlagEffect(tp,11451481)
			end
		else
			op=1
			Duel.RegisterFlagEffect(tp,11451482,0,0,1)
			Duel.ResetFlagEffect(tp,11451481)
		end
	end
	c:RemoveOverlayCard(tp,2-op,2-op,REASON_COST)
end
function cm.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,eg:GetCount(),0,0)
end
function cm.imop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoGrave(eg,REASON_EFFECT)
end