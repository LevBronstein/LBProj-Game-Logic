/**
 *  LBActorFactoryMechanism
 *
 *  Creation date: 05.02.2017 02:21
 *  Copyright 2017, Windows7
 */
class LBActorFactoryMechanism extends LBKismetInterfaceMechanism;

var(ActorFactoryGameplay) vector SpawnLocation;
var(ActorFactoryGameplay) rotator SpawnRotation;
var(ActorFactoryGameplay) bool bUseParentLocationRotation;

var(ActorFactorySystem) Actor ActorArchetype;

var(EventActivation) name OnCreatedInstance; 

function CreateInstance()
{
    local actor a;
    local vector v;
    local rotator r;
    
    
    if (ActorArchetype==none)
    {
        LogError("ActorArchetype is none!");
        return;
    }    
    
    if (bUseParentLocationRotation)
    {
        v=parent.Location;
        r=parent.Rotation;
    }
    else
    {
        v=SpawnLocation;
        r=SpawnRotation;    
    }
    a=parent.Spawn(ActorArchetype.Class, None, 'None', v, r, ActorArchetype);
    
    if (a!=none)
    {
        if (OnCreatedInstance != '')
        {
            ActivateKismetEvent(OnCreatedInstance,parent,a);    
        }    
    }
    else
    {
        LogError("Actor spawn error!");    
    }
}

function SetParamVector(name param, vector value, optional int priority=0)
{
    if (param=='SpawnLocation')
    {
        SpawnLocation=value;
    }
} 

function SetParamRotator(name param, rotator value, optional int priority=0)
{
    if (param=='SpawnRotation')
    {
        SpawnRotation=value;
    }
}   

function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='CreateOneInstance')
    {
        CreateInstance();
    }
    else if (param=='bUseParentLocationRotation')
    {
        bUseParentLocationRotation=value;
    }
}

defaultproperties
{
    mechname="Actor_Factory_Mechanism"
    
    MechanismParams(0)=(ParamName="SpawnLocation", ParamInfo="Vector. Read, Write. An initial offset for spawned actor.")
    MechanismParams(1)=(ParamName="SpawnRotation", ParamInfo="Rotator. Read, Write. An initial orientation for spawned actor.")
    MechanismParams(2)=(ParamName="bUseParentLocationRotation", ParamInfo="Bool. Read, Write. If set to true, @SpawnLocation and @SpawnRotation are taken from @parent @Location and @Rotation.")    
    MechanismParams(3)=(ParamName="CreateOneInstance", ParamInfo="Bool. Command. Initiates spawn process of one instance of @ActorArchetype. Calls proc @CreateInstance.")    
}
