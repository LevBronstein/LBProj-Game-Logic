/**
 *  LBPawn
 *
 *  Creation date: 04.04.2016 21:34
 *  Copyright 2016, Windows7
 */
class LBPawn extends Pawn
placeable
ClassGroup(LevBronstein);

var (Mechanisms) instanced array<LBMechanism> AllMechanisms; //mechanisms used for this pawn
var (Lighting) DynamicLightEnvironmentComponent LightEnvironment;


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

event Tick(float deltatime)
{
    TickAllMechanisms(deltatime);
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


defaultproperties
{
    bRunPhysicsWithNoController=true

    bStatic = False
    
    Components.Remove(Sprite)
   
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
      bSynthesizeSHLight=TRUE
      bIsCharacterLightEnvironment=TRUE
      bUseBooleanEnvironmentShadowing=FALSE
   End Object
   Components.Add(MyLightEnvironment)
   LightEnvironment=MyLightEnvironment
    
    Begin Object Class=SkeletalMeshComponent Name=WPawnSkeletalMeshComponent
       LightEnvironment=MyLightEnvironment
   End Object
   Mesh=WPawnSkeletalMeshComponent
   Components.Add(WPawnSkeletalMeshComponent)

}
