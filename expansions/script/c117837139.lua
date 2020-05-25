function c117837139.initial_effect(c)
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,1,117837139,LOCATION_MZONE)
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetTarget(c117837139.sumtg)
    e1:SetOperation(c117837139.sumop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UNRELEASABLE_SUM)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e6)
    local e7=e5:Clone()
    e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    c:RegisterEffect(e7)
    local e8=e5:Clone()
    e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e8)
    local e9=Effect.CreateEffect(c)
    e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_MZONE)
    e9:SetProperty(EFFECT_FLAG_BOTH_SIDE)
    e9:SetCountLimit(1)
    e9:SetTarget(c117837139.sumtg2)
    e9:SetOperation(c117837139.sumop2)
    c:RegisterEffect(e9)
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e10:SetRange(LOCATION_MZONE)
    e10:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e10:SetTarget(c117837139.indtg)
    e10:SetValue(aux.TRUE)
    c:RegisterEffect(e10)
    local e11=e10:Clone()
    e11:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e11)
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_MUST_ATTACK)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_MZONE,0)
    e12:SetCondition(c117837139.sccon)
    c:RegisterEffect(e12)
    local e13=e12:Clone()
    e13:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e13:SetValue(c117837139.atlimit)
    c:RegisterEffect(e13)
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e14:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e14:SetRange(LOCATION_MZONE)
    e14:SetCountLimit(1)
    e14:SetCondition(c117837139.condition)
    e14:SetOperation(c117837139.operation)
    c:RegisterEffect(e14)
    local e15=e14:Clone()
    e15:SetCode(EVENT_PHASE+PHASE_BATTLE)
    c:RegisterEffect(e15)
end
function c117837139.sumfilter(c,e,tp)
    return c:IsCode(78371393,4779091,31764700,117837139) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_ATTACK,tp)
end
function c117837139.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCountFromEx(1-tp,tp,nil,c)>0 and Duel.IsExistingMatchingCard(c117837139.sumfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,1-tp,true,false) end
end
function c117837139.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c117837139.sumfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_ATTACK)==1 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_SPSUMMON_PROC)
        e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
        e1:SetRange(LOCATION_EXTRA)
        e1:SetValue(SUMMON_TYPE_LINK)
        c:RegisterEffect(e1)
        Duel.LinkSummon(1-tp,c,nil)
        e1:Reset()
    end
end
function c117837139.sumfilter2(c,e,tp)
    return c:IsCode(78371393,4779091,31764700,117837139) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c117837139.sumtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c117837139.sumfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,tp,LOCATION_HAND)
end
function c117837139.sumop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c117837139.sumfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
end
function c117837139.indtg(e,c)
    return c:IsCode(78371393,4779091,31764700,117837139)
end
function c117837139.scfilter(c)
    return c:IsCode(78371393,4779091,31764700,117837139) and c:IsFaceup()
end
function c117837139.sccon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c117837139.scfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c117837139.atlimit(e,c)
    return not (c:IsFaceup() and c:IsCode(78371393,4779091,31764700,117837139))
end
function c117837139.filter(c,e)
    return (not c:IsAbleToChangeControler() or c:IsImmuneToEffect(e)) and c:GetSequence()<5
end
function c117837139.filter2(c)
    return c:GetSequence()<5
end
function c117837139.condition(e)
    return Duel.GetTurnPlayer()~=e:GetHandler():GetControler()
end
function c117837139.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsExistingMatchingCard(c117837139.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e) then return false end
    local g1=Duel.GetMatchingGroup(c117837139.filter2,tp,LOCATION_MZONE,0,nil)
    local g2=Duel.GetMatchingGroup(c117837139.filter2,tp,0,LOCATION_MZONE,nil)
    Duel.Hint(HINT_CARD,0,117837139)
    Duel.ChangePosition(g1,POS_FACEUP_ATTACK)
    Duel.ChangePosition(g2,POS_FACEUP_ATTACK)
    if g1:GetCount()>g2:GetCount() then
        local g3=g1:RandomSelect(tp,g2:GetCount())
        g1:Sub(g3)
        Duel.SwapControl(g3,g2)
        Duel.GetControl(g1,1-tp)
    elseif g1:GetCount()<g2:GetCount() then
        local g3=g2:RandomSelect(tp,g1:GetCount())
        g2:Sub(g3)
        Duel.SwapControl(g3,g1)
        Duel.GetControl(g2,tp)
    else
        Duel.SwapControl(g1,g2)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_REFLECT_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,1)
    e2:SetValue(c117837139.refcon)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c117837139.refcon(e,re,val,r,rp,rc)
    return bit.band(r,REASON_EFFECT)~=0
end