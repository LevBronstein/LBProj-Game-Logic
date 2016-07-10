/**
 *  LBKismetEventActivator
 *
 *  Creation date: 20.05.2016 22:27
 *  Copyright 2016, Windows7
 */
class LBKismetEventConditionalActivator extends LBKismetEventActivator
dependson(LBConditionalProgramm);

var(EventActivation) LBCondition Condition;  

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
        
    if (bCheckOnTick)
    {
        if (CheckConditions())
            TriggerKismetEvent();    
    }
} 

function bool CheckConditions()
{
    local float value;
    local bool b;
    
    b=false;

    if (Condition.TargetActor == none || Condition.TargetMechanism == '' ||  Condition.TargetParam == '')
        return false;
    
    value=GetTargetParamFloat(Condition.TargetActor, Condition.TargetMechanism, Condition.TargetParam);

    switch (Condition.Condition)
    {
        case LBCondition_Equals: 
            if (value == Condition.ConditionalValueA)
                b=true;
            break; 
        case LBCondition_Less: 
            if (value < Condition.ConditionalValueA)
                b=true;
            break; 
        case LBCondition_LessOrEquals: 
            if (value <= Condition.ConditionalValueA)
                b=true; 
            break; 
        case LBCondition_Greater: 
            if (value > Condition.ConditionalValueA)
                b=true; 
            break; 
        case LBCondition_GreaterOrEquals: 
            if (value >= Condition.ConditionalValueA)
                b=true; 
            break;
        case LBCondition_Between: 
            if (value >= Condition.ConditionalValueA && value <= Condition.ConditionalValueB)
                b=true; 
            break; 
        case LBCondition_Outside: 
        if (value < Condition.ConditionalValueA && value > Condition.ConditionalValueB)
                b=true; 
            break;     
    }
        
    return b;
}
    
defaultproperties
{
}
