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

/********************** SET PARAM OVERLOADS **********************/

function SetParam(name mechanism, name param, object value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParam(param, value);    
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

/********************** GET PARAM OVERLOADS **********************/

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
