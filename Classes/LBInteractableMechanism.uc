/**
 *  LBInteractiveMechanism
 *
 *  Creation date: 18.05.2016 00:15
 *  Copyright 2016, Windows7
 */
class LBInteractableMechanism extends LBMechanism;

function SetTargetParamFloat(actor target, name targetmech, name targetparam, float value, optional int priority=0)
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

function SetTargetParamInt(actor target, name targetmech, name targetparam, int value, optional int priority=0)
{
    local LBActor a;
    local LBPawn p;

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

function SetTargetParamBool(actor target, name targetmech, name targetparam, bool value, optional int priority=0)
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

function SetTargetParam(actor target, name targetmech, name targetparam, object value, optional int priority=0)
{
    local LBActor a;
    local LBPawn p;

    a=LBActor(target);
    
    if (a!=none)
    {   
        a.SetParam(targetmech, targetparam, value);
        return;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        p.SetParam(targetmech, targetparam, value);
        return;
    }
}

function SetTargetParamVector(actor target, name targetmech, name targetparam, vector value, optional int priority=0)
{
    local LBActor a;
    local LBPawn p;

    a=LBActor(target);
    
    if (a!=none)
    {   
        a.SetParamVector(targetmech, targetparam, value);
        return;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        p.SetParamVector(targetmech, targetparam, value);
        return;
    }
}

function SetTargetParamRotator(actor target, name targetmech, name targetparam, rotator value, optional int priority=0)
{
    local LBActor a;
    local LBPawn p;

    a=LBActor(target);
    
    if (a!=none)
    {   
        a.SetParamRotator(targetmech, targetparam, value);
        return;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        p.SetParamRotator(targetmech, targetparam, value);
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

function int GetTargetParamInt(actor target, name targetmech, name targetparam)
{
    local LBActor a;
    local LBPawn p;
    local int value;

    a=LBActor(target);
    
    if (a!=none)
    {   
        value=a.GetParamInt(targetmech, targetparam);
        return value;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        value=p.GetParamInt(targetmech, targetparam);
        return value;
    }
}

function bool GetTargetParamBool(actor target, name targetmech, name targetparam)
{
    local LBActor a;
    local LBPawn p;
    local bool value;

    a=LBActor(target);
    
    if (a!=none)
    {   
        value=a.GetParamBool(targetmech, targetparam);
        return value;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        value=p.GetParamBool(targetmech, targetparam);
        return value;
    }
}

function object GetTargetParam(actor target, name targetmech, name targetparam)
{
    local LBActor a;
    local LBPawn p;
    local object value;

    a=LBActor(target);
    
    if (a!=none)
    {   
        value=a.GetParam(targetmech, targetparam);
        return value;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        value=p.GetParam(targetmech, targetparam);
        return value;
    }
}

function vector GetTargetParamVector(actor target, name targetmech, name targetparam)
{
    local LBActor a;
    local LBPawn p;
    local vector value;

    a=LBActor(target);
    
    if (a!=none)
    {   
        value=a.GetParamVector(targetmech, targetparam);
        return value;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        value=p.GetParamVector(targetmech, targetparam);
        return value;
    }
}

function rotator GetTargetParamRotator(actor target, name targetmech, name targetparam)
{
    local LBActor a;
    local LBPawn p;
    local rotator value;

    a=LBActor(target);
    
    if (a!=none)
    {   
        value=a.GetParamRotator(targetmech, targetparam);
        return value;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        value=p.GetParamRotator(targetmech, targetparam);
        return value;
    }
}

defaultproperties
{
}
