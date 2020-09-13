local m=90700048
local cm=_G["c"..m]
cm.name="本我诞生"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e1_tograve=Effect.CreateEffect(c)
	e1_tograve:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1_tograve:SetCode(EVENT_TO_GRAVE)
	e1_tograve:SetOperation(cm.activate)
	c:RegisterEffect(e1_tograve)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6312))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.rcon)
	e4:SetOperation(cm.rop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(cm.rgrcon)
	c:RegisterEffect(e5)
	local e5_assis=Effect.CreateEffect(c)
	e5_assis:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5_assis:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5_assis:SetCode(EVENT_TO_GRAVE)
	e5_assis:SetOperation(cm.regop)
	c:RegisterEffect(e5_assis)
end
function cm.actfilter(c)
	return c:IsCode(90700049) and c:IsAbleToHand() and not (c:IsLocation(LOCATION_REMOVED) and c:IsPosition(POS_FACEDOWN))
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetType()==EFFECT_TYPE_ACTIVATE and (not e:GetHandler():IsRelateToEffect(e)) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.actfilter),tp,0x3d,0,nil,e,tp)
	if Duel.SelectYesNo(tp,aux.Stringid(90700048,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
	end
end
function cm.rfilter(c)
	if c:IsSetCard(0x6312) and c:IsSummonType(SUMMON_TYPE_RITUAL) then
		return 1
	end
	return 0
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetSum(cm.rfilter)>0 and Duel.IsPlayerCanDraw(tp,1)
end
function cm.rgrcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0 and eg:GetSum(cm.rfilter)>0 and Duel.IsPlayerCanDraw(tp,1)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x6312) and tc:IsSummonType(SUMMON_TYPE_RITUAL) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(90700048,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		tc=eg:GetNext()
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_HAND) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end