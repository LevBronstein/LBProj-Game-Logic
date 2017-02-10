/**
 *  LBActorManagmentMechanism
 *
 *  Creation date: 08.02.2017 21:02
 *  Copyright 2017, Windows7
 */
class LBActorManagmentMechanism extends LBActorContainerMechanism;

struct LBTargetedParam
{
    var() name ParamName;
    var() LBParamContainer ParamValue; 
    var() LBParamSourcePointer ParamValueSource;
    var() LBMechanismParam ParamTarget;
    var() bool bOVerrideTargetParentActor;
    var int Priority;   
};

var(Parameters) array<LBTargetedParam> Params;

function ApplyParam(actor a, LBTargetedParam param)
{
    local LBMechanismParam t;
    local int i;
    
    if (LBActor(a)==none && LBPawn(a)==none)
    {
        LogError("Actor"@a@"is not valid");
        return;
    }
 
    if (ContainedActors.Find(a)==-1)
    {
        LogError("Actor"@a@"is not in the list");
        return;
    }
    
    if (param.ParamTarget.MechanismName == '' || param.ParamTarget.ParamName == '' )
    {
        LogError("Param"@param.ParamName@"has invalid target:"@param.ParamTarget.MechanismName@","@param.ParamTarget.ParamName);
        return;    
    }
    
    t=param.ParamTarget;
    
    if (param.bOVerrideTargetParentActor)
        t.ParentActor=a;
    
    LogInfo("Applying"@param.ParamName@"to actor"@t.ParentActor);
     
    SetTargetParamContainerStr(t, param.ParamValue, param.ParamValueSource);
}

function ApplyParamToSelectedActor(int paramid)
{
    if (paramid<0 || paramid>=Params.Length)
    {
        LogError("Given param id"@paramid@"is not valid");
        return;   
    }    
    
    ApplyParam(ContainedActors[SelectedActor],Params[paramid]);
}

function ApplyParamToActorList(int paramid)
{
    local int i;
    
    if (paramid<0 || paramid>=Params.Length)
    {
        LogError("Given param id"@paramid@"is not valid");
        return;   
    }
    
    for (i=0;i<ContainedActors.Length;i++)
    {
        ApplyParam(ContainedActors[i],Params[paramid]);        
    }    
}

function SetParamInt(name param, int value, optional int priority=0)
{
    super.SetParamInt(param,value,priority);
    
    if (param=='ApplyParam')
    {
        ApplyParamToSelectedActor(value);    
    }
    else if (param=='ApplyParamToAll')
    {
        ApplyParamToActorList(value);        
    }
} 

defaultproperties
{
    mechname="Actor_Container_Mechanism"
    
    MechanismParams(8)=(ParamName="ApplyParam", ParamInfo="Integer. Apply param by given id @value to the selected actor @SelectedActor.")
    MechanismParams(9)=(ParamName="ApplyParamToAll", ParamInfo="Integer. Write. Apply param by given id @value to all actors in the list @ContainedActors.")
}
