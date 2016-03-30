/**
 *  MyProjMechanismDrivenActor
 *
 *  Creation date: 21.02.2016 22:46
 *  Copyright 2016, Windows7
 */
class LBActor extends Actor
placeable
ClassGroup(LevBronstein);

var(Mechanisms) editinline array<LBMechanism> AllMechanisms; //mechanisms used for this actor
var(Mechanisms) const StaticMeshComponent Mesh; //Mesh for this actor
var(Mechanisms) const editconst DynamicLightEnvironmentComponent LightEnvironment;

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
    CollisionComponent=Mesh
}
