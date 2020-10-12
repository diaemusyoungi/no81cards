--卡西米尔·特种干员-砾
function c79029016.initial_effect(c)
	--end battle phase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029016.condition)
	e1:SetCost(c79029016.cost)
	e1:SetOperation(c79029016.operation)
	c:RegisterEffect(e1)
end
function c79029016.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return tp~=Duel.GetTurnPlayer() and at and at:IsFaceup() and at:IsSetCard(0xa900)
end
function c79029016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	Duel.SetChainLimit(c79029016.chlimit)
end
function c79029016.chlimit(e,ep,tp)
	return tp==ep
end
function c79029016.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	Debug.Message("鼠群，聚集起来吧！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029016,1))
	end
end
