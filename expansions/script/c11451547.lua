--悠久之心：联结
--22.01.08
local m=11451547
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2,nil,nil,99)
	c:EnableReviveLimit()
	--mat
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(cm.adtg(EVENT_CHAINING))
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_BATTLE_END,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetTarget(cm.adtg(EVENT_FREE_CHAIN))
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SUMMON)
	e3:SetTarget(cm.adtg(EVENT_SUMMON))
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON)
	e4:SetTarget(cm.adtg(EVENT_FLIP_SUMMON))
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetTarget(cm.adtg(EVENT_SPSUMMON))
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EVENT_TO_HAND)
	e6:SetTarget(cm.adtg(EVENT_TO_HAND))
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetTarget(cm.adtg(EVENT_ATTACK_ANNOUNCE))
	c:RegisterEffect(e7)
	--act
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EVENT_ADJUST)
	e8:SetRange(LOCATION_MZONE)
	e8:SetOperation(cm.efop)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(m)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(cm.con)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_ACTIVATE_COST)
	e11:SetRange(LOCATION_MZONE)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetTargetRange(1,0)
	e11:SetTarget(cm.actarget)
	e11:SetOperation(cm.costop)
	c:RegisterEffect(e11)
end
function cm.filter(c,event)
	if not (c:IsCanOverlay(tp) and c:GetType()&0x100004==0x100004) then return false end
	local te=c:CheckActivateEffect(false,true,false)
	return te and te:GetCode()==event
end
function cm.adtg(event)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then
				return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,event) and e:GetHandler():IsType(TYPE_XYZ)
			end
			local _GetCurrentChain=Duel.GetCurrentChain
			Duel.GetCurrentChain=function() return _GetCurrentChain()-1 end
			local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,event)
			local ag=Group.CreateGroup()
			local codes={}
			for c in aux.Next(g) do
				local code=c:GetCode()
				if not ag:IsExists(Card.IsCode,1,nil,code) then
					ag:AddCard(c)
					table.insert(codes,code)
				end
			end
			table.sort(codes)
			local afilter={codes[1],OPCODE_ISCODE}
			if #codes>1 then
				for i=2,#codes do
					table.insert(afilter,codes[i])
					table.insert(afilter,OPCODE_ISCODE)
					table.insert(afilter,OPCODE_OR)
				end
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
			local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
			getmetatable(e:GetHandler()).announce_filter={TYPE_COUNTER,OPCODE_ISTYPE}
			Duel.SetTargetParam(ac)
			Duel.GetCurrentChain=_GetCurrentChain
			Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
		end
end
function cm.filter2(c,code)
	return c:IsCanOverlay(tp) and c:IsCode(code)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsType(TYPE_XYZ) then return end
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil,ac)
	if tg and #tg>0 then Duel.Overlay(c,tg) end
end
function cm.filter3(c)
	return c:GetType()&0x100004==0x100004 and c:IsSetCard(0x97d) and c:GetFlagEffect(m)==0
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup():Filter(cm.filter3,nil)
	for oc in aux.Next(og) do
		oc:RegisterFlagEffect(m,0,0,1)
		local te=oc:GetActivateEffect()
		local e1=Effect.CreateEffect(oc)
		e1:SetCategory(te:GetCategory())
		e1:SetType(EFFECT_TYPE_ACTIVATE)
		e1:SetCode(EVENT_CHAINING)
		e1:SetLabel(m)
		e1:SetCondition(te:GetCondition())
		e1:SetCost(cm.addcost)
		e1:SetTarget(te:GetTarget())
		e1:SetOperation(te:GetOperation())
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.addcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local xc=c:GetOverlayTarget()
		e:SetLabelObject(xc)
		return c:IsLocation(LOCATION_OVERLAY) and xc:IsHasEffect(m) and xc:IsControler(tp)
	end
	local tc=e:GetLabelObject()
	tc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	e:SetLabelObject(nil)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m+1)==0
end
function cm.actarget(e,te,tp)
	local og=e:GetHandler():GetOverlayGroup()
	e:SetLabelObject(te)
	return og and og:IsContains(te:GetHandler()) and te:GetLabel()==m
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	tc:CreateEffectRelation(te)
end