/**
 *  LBInteractiveMechanism
 *
 *  Creation date: 18.05.2016 00:15
 *  Copyright 2016, Windows7
 */
class LBInteractableMechanism extends LBMechanism;

function SetTargetParamFloat(actor target, name targetmech, name targetparam, float value)
{
    local LBActor a;
    local LBPawn p;

    a=LBActor(target);
    
    if (a!=none)
    {   
        a.SetParamFloat(targetmech, targetparam, value);
        return;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        p.SetParamFloat(targetmech, targetparam, value);
        return;
    }
}

function SetTargetParamInt(actor target, name targetmech, name targetparam, int value)
{
    local LBActor a;
    local LBPawn p;
    `log(target@ targetmech@ targetparam@ value);
    a=LBActor(target);
    
    if (a!=none)
    {   
        
        a.SetParamInt(targetmech, targetparam, value);
        return;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        p.SetParamInt(targetmech, targetparam, value);
        return;
    }
}

function SetTargetParamBool(actor target, name targetmech, name targetparam, bool value)
{
    local LBActor a;
    local LBPawn p;

    a=LBActor(target);
    
    if (a!=none)
    {   
        a.SetParamBool(targetmech, targetparam, value);
        return;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        p.SetParamBool(targetmech, targetparam, value);
        return;
    }
}

function float GetTargetParamFloat(actor target, name targetmech, name targetparam)
{
    local LBActor a;
    local LBPawn p;
    local float value;

    a=LBActor(target);
    
    if (a!=none)
    {   
        value=a.GetParamFloat(targetmech, targetparam);
        return value;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        value=p.GetParamFloat(targetmech, targetparam);
        return value;
    }
}

function int GetTargetParamInt(actor target, name targetmech, name targetparam);
function bool GetTargetParamBool(actor target, name targetmech, name targetparam);

defaultproperties
{
}
