local m=53727014
local cm=_G["c"..m]
cm.name="电脑深域N 镇暴总线"
function cm.initial_effect(c)
	aux.AddCodeList(c,53727003)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,function(g,lc)return g:IsExists(Card.IsLinkCode,1,nil,53727003)end)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(function(e,c)return c:GetEquipTarget()==e:GetHandler()end)
	e2:SetValue(cm.mtval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
function cm.eqfilter(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsCanBeEffectTarget(e)
end
function cm.fselect(g,ft)
	return (#g==1 or g:GetFirst():GetControler()~=g:GetNext():GetControler()) and ft>=#g
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(cm.eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return g:CheckSubGroup(cm.fselect,1,2,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,1,2,ft)
	Duel.SetTargetCard(sg)
	local gg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #gg>0 then Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,gg,#gg,0,0) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,sg,1,0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 or ft<g:GetCount() then return end 
	for tc in aux.Next(g) do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		Duel.Equip(tp,tc,c,false,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(function(e,c)return e:GetOwner()==c end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetValue(600)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.ConfirmCards(1-tp,g)
	Duel.EquipComplete()
end
function cm.mtval(e,c)
	if not c then return false end
	return c:IsCode(53727002)
end
