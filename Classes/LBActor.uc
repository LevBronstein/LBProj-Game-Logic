/**
 *  MyProjMechanismDrivenActor
 *
 *  Creation date: 21.02.2016 22:46
 *  Copyright 2016, Windows7
 */
class LBActor extends Actor
placeable
ClassGroup(LevBronstein);

var(Mechanisms) instanced array<LBMechanism> AllMechanisms; //mechanisms used for this actor
var(LBActor) const StaticMeshComponent Mesh; //Mesh for this actor
var(LBActor) const editconst DynamicLightEnvironmentComponent LightEnvironment;

event PostBeginPlay()
{
    super.PostBeginPlay();
    
    InitMechanisms();
}

function InitMechanisms()
{
    local int i;
    
    //init mechanisms
    for(i=0;i<AllMechanisms.length;i++)
    {
        if(AllMechanisms[i].parent==none)
            AllMechanisms[i].parent=self;
    }
}

function TickAllMechanisms(float deltatime)
{
    local int i;
    
    for(i=0;i<AllMechanisms.length;i++)
    {
        AllMechanisms[i].OwnerTick(deltatime);
    }
}

function LBMechanism GetMechanismByName(name mechname)
{
    local int i;
    
    for(i=0;i<AllMechanisms.length;i++)
    {
        if(AllMechanisms[i].mechname==mechname)
            return AllMechanisms[i];
    }
    return none;
}

function AnimNotifyAllMechanisms(AnimNodeSequence notifynode, AnimNotify notify)
{
    local int i;
    
    for(i=0;i<AllMechanisms.length;i++)
    {
        AllMechanisms[i].OwnerAnimNotify(notifynode,notify);
    }    
}

/********************** SET PARAM OVERLOADS **********************/

function SetParam(name mechanism, name param, object value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParam(param, value);    
}

function SetParams(name mechanism, name param, array<object> value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParams(param, value);    
}

function SetParamInt(name mechanism, name param, int value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
 
    m.SetParamInt(param, value);    
}

function SetParamFloat(name mechanism, name param, float value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParamFloat(param, value);    
}

function SetParamBool(name mechanism, name param, bool value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParamBool(param, value);    
}

function SetParamVector(name mechanism, name param, vector value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParamVector(param, value);    
}

function SetParamRotator(name mechanism, name param, rotator value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParamRotator(param, value);    
}

function SetParamName(name mechanism, name param, name value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParamName(param, value);    
}

/********************** GET PARAM OVERLOADS **********************/


function object GetParam(name mechanism, name param)
{
    local LBMechanism m;
    local object res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return none;
        
    res=m.GetParam(param);    
    return res;
}

function array<object> GetParams(name mechanism, name param)
{
    local LBMechanism m;
    local array<object> res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return res; //!!!
        
    res=m.GetParams(param);    
    return res;
}

function float GetParamFloat(name mechanism, name param)
{
    local LBMechanism m;
    local float res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return 0;
        
    res=m.GetParamFloat(param);    
    return res;
}

function bool GetParamBool(name mechanism, name param)
{
    local LBMechanism m;
    local bool res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return false;
        
    res=m.GetParamBool(param);    
    return res;
}

function int GetParamInt(name mechanism, name param)
{
    local LBMechanism m;
    local int res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return 0;
        
    res=m.GetParamInt(param);    
    return res;
}

function vector GetParamVector(name mechanism, name param)
{
    local LBMechanism m;
    local vector res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return vect(0,0,0);
        
    res=m.GetParamVector(param);    
    return res;
}

function rotator GetParamRotator(name mechanism, name param)
{
    local LBMechanism m;
    local rotator res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return rot(0,0,0);
        
    res=m.GetParamRotator(param);    
    return res;
}

function name GetParamName(name mechanism, name param)
{
    local LBMechanism m;
    local name res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return '';
        
    res=m.GetParamName(param);    
    return res;
}

event Tick(float deltatime)
{
    TickAllMechanisms(deltatime);
}

defaultproperties
{
    //bShouldShadowParentAllAttachedActors=TRUE
    
    bStatic=false
    bWorldGeometry=false
    //bPawnCanBaseOn=true
    bShadowParented=true
    
    bEdShouldSnap=true
    
    bCollideActors=true
    bCollideWorld=true
    bBlockActors=true
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bEnabled=TRUE
    End Object
 
    LightEnvironment=MyLightEnvironment
    Components.Add(MyLightEnvironment)
    
    Begin Object Class=StaticMeshComponent Name=BaseMesh
        StaticMesh=StaticMesh'EngineMeshes.Sphere'
        LightEnvironment=MyLightEnvironment
    End Object
    
    Components.Add(BaseMesh)
    Mesh=BaseMesh
    CollisionComponent=BaseMesh
}
