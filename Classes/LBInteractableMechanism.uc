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
    local LBSkeletalMeshActor s;
    local LBDynamicActor d;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;

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
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        d.SetParamFloat(targetmech, targetparam, value);
        return;
    }
    
    s=LBSkeletalMeshActor(target);
    
    if (s!=none)
    {   
        s.SetParamFloat(targetmech, targetparam, value);
        return;
    }
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        skmph.SetParamFloat(targetmech, targetparam, value);
        return;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        smph.SetParamFloat(targetmech, targetparam, value);
        return;
    }
}

function SetTargetParamInt(actor target, name targetmech, name targetparam, int value, optional int priority=0)
{
    local LBActor a;
    local LBPawn p;
    local LBDynamicActor d;
    local LBSkeletalMeshActor s;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;

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
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        d.SetParamInt(targetmech, targetparam, value);
        return;
    }
    
    s=LBSkeletalMeshActor(target);
    
    if (s!=none)
    {   
        s.SetParamInt(targetmech, targetparam, value);
        return;
    }
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        skmph.SetParamInt(targetmech, targetparam, value);
        return;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        smph.SetParamInt(targetmech, targetparam, value);
        return;
    }
}

function SetTargetParamBool(actor target, name targetmech, name targetparam, bool value, optional int priority=0)
{
    local LBActor a;
    local LBPawn p;
    local LBDynamicActor d;
    local LBSkeletalMeshActor s;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;

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
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        d.SetParamBool(targetmech, targetparam, value);
        return;
    }
    
    s=LBSkeletalMeshActor(target);
    
    if (s!=none)
    {   
        s.SetParamBool(targetmech, targetparam, value);
        return;
    }
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        skmph.SetParamBool(targetmech, targetparam, value);
        return;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        smph.SetParamBool(targetmech, targetparam, value);
        return;
    }
}

function SetTargetParam(actor target, name targetmech, name targetparam, object value, optional int priority=0)
{
    local LBActor a;
    local LBPawn p;
    local LBDynamicActor d;
    local LBSkeletalMeshActor s;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;

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
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        d.SetParam(targetmech, targetparam, value);
        return;
    }
    
    s=LBSkeletalMeshActor(target);
    
    if (s!=none)
    {   
        s.SetParam(targetmech, targetparam, value);
        return;
    }
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        skmph.SetParam(targetmech, targetparam, value);
        return;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        smph.SetParam(targetmech, targetparam, value);
        return;
    }
}

function SetTargetParams(actor target, name targetmech, name targetparam, array<object> value, optional int priority=0)
{
    local LBActor a;
    local LBPawn p;
    local LBDynamicActor d;
    local LBSkeletalMeshActor s;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;

    a=LBActor(target);
    
    if (a!=none)
    {   
        a.SetParams(targetmech, targetparam, value);
        return;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        p.SetParams(targetmech, targetparam, value);
        return;
    }
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        d.SetParams(targetmech, targetparam, value);
        return;
    }
    
    s=LBSkeletalMeshActor(target);
    
    if (s!=none)
    {   
        s.SetParams(targetmech, targetparam, value);
        return;
    }
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        skmph.SetParams(targetmech, targetparam, value);
        return;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        smph.SetParams(targetmech, targetparam, value);
        return;
    }
}

function SetTargetParamVector(actor target, name targetmech, name targetparam, vector value, optional int priority=0)
{
    local LBActor a;
    local LBPawn p;
    local LBDynamicActor d;
    local LBSkeletalMeshActor s;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;

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
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        d.SetParamVector(targetmech, targetparam, value);
        return;
    }
    
    s=LBSkeletalMeshActor(target);
    
    if (s!=none)
    {   
        s.SetParamVector(targetmech, targetparam, value);
        return;
    } 
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        skmph.SetParamVector(targetmech, targetparam, value);
        return;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        smph.SetParamVector(targetmech, targetparam, value);
        return;
    }
}

function SetTargetParamRotator(actor target, name targetmech, name targetparam, rotator value, optional int priority=0)
{
    local LBActor a;
    local LBPawn p;
    local LBDynamicActor d;
    local LBSkeletalMeshActor s;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;

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
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        d.SetParamRotator(targetmech, targetparam, value);
        return;
    }
    
    s=LBSkeletalMeshActor(target);
    
    if (s!=none)
    {   
        s.SetParamRotator(targetmech, targetparam, value);
        return;
    }
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        skmph.SetParamRotator(targetmech, targetparam, value);
        return;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        smph.SetParamRotator(targetmech, targetparam, value);
        return;
    }
}

function SetTargetParamContainer(actor target, name targetmech, name targetparam, LBParamContainer value, optional int priority=0)
{
    switch (value.ParamType)
    {
        case ParamType_Object:
            SetTargetParam(target, targetmech, targetparam, value.ObjectParam.value, priority);
        break;
        case ParamType_ObjectArray:
            SetTargetParams(target, targetmech, targetparam, value.ObjectArrayParam.value, priority);
        break;
        case ParamType_Float:
            SetTargetParamFloat(target, targetmech, targetparam, value.FloatParam.value, priority);
        break;
        case ParamType_Integer:
            SetTargetParamInt(target, targetmech, targetparam, value.IntegerParam.value, priority);
        break;
        case ParamType_Boolean:
            SetTargetParamBool(target, targetmech, targetparam, value.BooleanParam.value, priority);
        break;
        case ParamType_Vector:
            SetTargetParamVector(target, targetmech, targetparam, value.VectorParam.value, priority);
        break;
        case ParamType_Rotator:
            SetTargetParamRotator(target, targetmech, targetparam, value.RotatorParam.value, priority);
        break;
    } 
}

function SetTargetParamContainerPtr(LBMechanismParam target, LBParamContainer value)
{
    SetTargetParamContainer(target.ParentActor, target.MechanismName, target.ParamName, value);
}

function SetTargetParamContainerStr(LBMechanismParam target, LBParamContainer value, LBParamSourcePointer source, optional int priority=0)
{
    local LBParamContainer v;
    
    if (source.bUseSource)
    {
        v=GetTargetParamContainer(source.SourceActor, source.SourceMechanismName, source.SourceParamName, value.ParamType);
        SetTargetParamContainer(target.ParentActor, target.MechanismName, target.ParamName, v);
    }
    else
    {
        SetTargetParamContainer(target.ParentActor, target.MechanismName, target.ParamName, value);
    }
}

function float GetTargetParamFloat(actor target, name targetmech, name targetparam)
{
    local LBActor a;
    local LBPawn p;
    local LBDynamicActor d;
    local LBSkeletalMeshActor s;
    local float value;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;

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
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        value=d.GetParamFloat(targetmech, targetparam);
        return value;
    }
    
    s=LBSkeletalMeshActor(target);
    
    if (s!=none)
    {
        value=s.GetParamFloat(targetmech, targetparam);
        return value;
    }
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        value=skmph.GetParamFloat(targetmech, targetparam);
        return value;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        value=smph.GetParamFloat(targetmech, targetparam);
        return value;
    }
}

function int GetTargetParamInt(actor target, name targetmech, name targetparam)
{
    local LBActor a;
    local LBPawn p;
    local LBDynamicActor d;
    local LBSkeletalMeshActor s;
    local int value;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;

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
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        value=d.GetParamInt(targetmech, targetparam);
        return value;
    }
    
    s=LBSkeletalMeshActor (target);
    
    if (s!=none)
    {
        value=s.GetParamInt(targetmech, targetparam);
        return value;
    }
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        value=skmph.GetParamInt(targetmech, targetparam);
        return value;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        value=smph.GetParamInt(targetmech, targetparam);
        return value;
    }
}

function bool GetTargetParamBool(actor target, name targetmech, name targetparam)
{
    local LBActor a;
    local LBPawn p;
    local LBDynamicActor d;
    local LBSkeletalMeshActor s;
    local bool value;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;

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
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        value=d.GetParamBool(targetmech, targetparam);
        return value;
    }
    
    s=LBSkeletalMeshActor (target);
    
    if (s!=none)
    {
        value=s.GetParamBool(targetmech, targetparam);
        return value;
    }
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        value=skmph.GetParamBool(targetmech, targetparam);
        return value;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        value=smph.GetParamBool(targetmech, targetparam);
        return value;
    }
}

function object GetTargetParam(actor target, name targetmech, name targetparam)
{
    local LBActor a;
    local LBPawn p;
    local LBDynamicActor d;
    local LBSkeletalMeshActor s;
    local object value;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;
    
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
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        value=d.GetParam(targetmech, targetparam);
        return value;
    }
    
    s=LBSkeletalMeshActor(target);
    
    if (s!=none)
    {
        value=s.GetParam(targetmech, targetparam);
        return value;
    } 
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        value=skmph.GetParam(targetmech, targetparam);
        return value;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        value=smph.GetParam(targetmech, targetparam);
        return value;
    }
    
}

function array<object> GetTargetParams(actor target, name targetmech, name targetparam)
{
    local LBActor a;
    local LBPawn p;
    local LBDynamicActor d;
    local LBSkeletalMeshActor s;
    local array<object> value;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;    

    a=LBActor(target);
    
    if (a!=none)
    {   
        value=a.GetParams(targetmech, targetparam);
        return value;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        value=p.GetParams(targetmech, targetparam);
        return value;
    }
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        value=d.GetParams(targetmech, targetparam);
        return value;
    }
    
    s=LBSkeletalMeshActor (target);
    
    if (s!=none)
    {
        value=s.GetParams(targetmech, targetparam);
        return value;
    }
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        value=skmph.GetParams(targetmech, targetparam);
        return value;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        value=smph.GetParams(targetmech, targetparam);
        return value;
    }    
}

function vector GetTargetParamVector(actor target, name targetmech, name targetparam)
{
    local LBActor a;
    local LBPawn p;
    local LBDynamicActor d;
    local LBSkeletalMeshActor s;
    local vector value;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;    

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
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        value=d.GetParamVector(targetmech, targetparam);
        return value;
    }
    
    s=LBSkeletalMeshActor (target);
    
    if (s!=none)
    {
        value=s.GetParamVector(targetmech, targetparam);
        return value;
    }
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        value=skmph.GetParamVector(targetmech, targetparam);
        return value;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        value=smph.GetParamVector(targetmech, targetparam);
        return value;
    }    
}

function rotator GetTargetParamRotator(actor target, name targetmech, name targetparam)
{
    local LBActor a;
    local LBPawn p;
    local LBDynamicActor d;
    local LBSkeletalMeshActor s;
    local rotator value;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;    

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
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        value=d.GetParamRotator(targetmech, targetparam);
        return value;
    }
    
    s=LBSkeletalMeshActor (target);
    
    if (s!=none)
    {
        value=s.GetParamRotator(targetmech, targetparam);
        return value;
    }
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        value=skmph.GetParamRotator(targetmech, targetparam);
        return value;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        value=smph.GetParamRotator(targetmech, targetparam);
        return value;
    }    
}

function LBParamContainer GetTargetParamContainer(actor target, name targetmech, name targetparam, ParamTypes paramtype)
{
    local LBParamContainer param;
    
    param.ParamType=paramtype;
    
    switch (param.ParamType)
    {
        case ParamType_Object:
            param.ObjectParam.value=GetTargetParam(target, targetmech, targetparam);
        break;
        case ParamType_ObjectArray:
            param.ObjectArrayParam.value=GetTargetParams(target, targetmech, targetparam);
        break;
        case ParamType_Float:
            param.FloatParam.value=GetTargetParamFloat(target, targetmech, targetparam);
        break;
        case ParamType_Integer:
            param.IntegerParam.value=GetTargetParamInt(target, targetmech, targetparam);
        break;
        case ParamType_Boolean:
            param.BooleanParam.value=GetTargetParamBool(target, targetmech, targetparam);
        break;
        case ParamType_Vector:
            param.VectorParam.value=GetTargetParamVector(target, targetmech, targetparam);
        break;
        case ParamType_Rotator:
            param.RotatorParam.value=GetTargetParamRotator(target, targetmech, targetparam);
        break;
    } 
    
    return param;
}

function GetbEnabled()
{
    local int i;
    local bool value;
    
    for (i=0;i<ParamSource.Length;i++)
    {
        if (ParamSource[i].ParamName == 'bEnabled' && ParamSource[i].ValueSource.bUseSource)  
        {     
            value=GetTargetParamBool(ParamSource[i].ValueSource.SourceActor,ParamSource[i].ValueSource.SourceMechanismName,ParamSource[i].ValueSource.SourceParamName);
            SetTargetParamBool(parent,mechname,'bEnabled',value); 
        }
    }    
}

function GetParameters()
{
    local int i,j;
    local LBParamContainer value;
    
    for (i=0;i<ParamSource.Length;i++)
    {
        if (ParamSource[i].ValueSource.bUseSource)
        {
            for (j=0;j<MechanismParams.Length;j++)
            {
                if (ParamSource[i].ParamName == MechanismParams[j].ParamName)  
                {
                    value=GetTargetParamContainerSrc(ParamSource[i].ValueSource,MechanismParams[j].ParamType);
                    SetTargetParamContainer(parent,mechname,MechanismParams[j].ParamName,value);
                }  
            }
            
        }        
    }
} 

function LBParamContainer GetTargetParamContainerPtr(LBMechanismParam target, ParamTypes paramtype)
{
    local LBParamContainer v;
    v=GetTargetParamContainer(target.ParentActor, target.MechanismName, target.ParamName, paramtype);
    return v;
}

function LBParamContainer GetTargetParamContainerSrc(LBParamSourcePointer source, ParamTypes paramtype)
{
    local LBParamContainer v;
    
    if (source.bUseSource)
    {
        v=GetTargetParamContainer(source.SourceActor, source.SourceMechanismName, source.SourceParamName, paramtype);
    }
    
    return v;
}

function bool TargetHasMechanism(actor target, name targetmech)
{
    local LBActor a;
    local LBPawn p;
    local LBSkeletalMeshActor s;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;    

    a=LBActor(target);
    
    if (a!=none)
    {   
        if (a.GetMechanismByName(targetmech)!=none)
            return true;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        if (p.GetMechanismByName(targetmech)!=none)
            return true;
    }
        
    s=LBSkeletalMeshActor (target);
    
    if (s!=none)
    {
        if (s.GetMechanismByName(targetmech)!=none)
            return true;
    }    
        
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        if (skmph.GetMechanismByName(targetmech)!=none)
            return true;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        if (smph.GetMechanismByName(targetmech)!=none)
            return true;
    }                
        
    return false;
}

/*Returns true if @target is LBActor, LBPawn or other LB... actor*/
function bool TargetIsLBObject(actor target)
{
    if (LBActor(target)!=none || LBPawn(target)!=none || LBSkeletalMeshActor(target)!=none ||
    LBSKMPhysicsActor(target)!=none || LBSMPhysicsActor(target)!=none)
        return true;
    else 
        return false;    
}

defaultproperties
{
    MechanismParams.Add((ParamName="bEnabled", ParamType=ParamType_Boolean, ParamInfo="Boolean. Read, write. Enables or disables this mechanism."))
    
    ParamSource.Add((ParamName="bEnabled"))
}
