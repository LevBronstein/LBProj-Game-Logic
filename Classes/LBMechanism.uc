/**
 *  MyProjActorMechanismBase
 *
 *  Creation date: 21.02.2016 22:45
 *  Copyright 2016, Windows7
 */
class LBMechanism extends Object 
editinlinenew;

enum ParamTypes
{
    ParamType_Undefined,
    ParamType_Command,
    ParamType_Object,
    ParamType_ObjectArray,
    ParamType_Float,
    ParamType_Integer,
    ParamType_Boolean,
    ParamType_Vector,
    ParamType_Rotator,
};

//AnimNotifyTypes_None - the action can be interrupted
//AnimNotifyTypes_ActionStart - the action should go until it receives AnimNotifyTypes_ActionEnd
enum AnimNotifyTypes
{
    AnimNotifyTypes_None,
    AnimNotifyTypes_ActionStart,
    AnimNotifyTypes_PerformAction,
    AnimNotifyTypes_ActionEnd,
};

enum EditModes
{
    EditModes_Set,
    EditMides_Add
};

struct ObjectValue
{
    var() object Value;
    var() object DefaultValue;
};

struct ObjectArrayValue
{
    var() array<object> Value;
    var() array<object> DefaultValue;
};

struct FloatValue
{
    var() float Value;
    var() float DefaultValue; 
    var() bool bClampValue; //Set to true, if the value shoul be always between Min and Max 
    var() float ValueMin;
    var() float ValueMax;
};

struct IntegerValue
{
    var() int Value;
    var() int DefaultValue; 
    var() bool bClampValue; //Set to true, if the value shoul be always between Min and Max 
    var() int ValueMin;
    var() int ValueMax;
};

struct BooleanValue
{
    var() bool Value;
    var() bool DefaultValue; 
};

struct VectorValue
{
    var() vector Value;
    var() vector DefaultValue; 
};

struct RotatorValue
{
    var() rotator Value;
    var() rotator DefaultValue; 
};

struct LBParamContainer
{
    var() ParamTypes ParamType;
    var() ObjectValue ObjectParam;
    var() ObjectArrayValue ObjectArrayParam;
    var() FloatValue FloatParam; 
    var() IntegerValue IntegerParam;
    var() BooleanValue BooleanParam;
    var() VectorValue VectorParam;
    var() RotatorValue RotatorParam;
};

struct LBMechanismParamInfo
{
    var() editconst name ParamName;
    var() editconst ParamTypes ParamType;
    var() editconst string ParamInfo;
};

struct LBMechanismParam
{
    var() actor ParentActor;
    var() name MechanismName;
    var() name ParamName;
};

struct LBParamSourcePointer
{
    var() actor SourceActor;
    var() name SourceMechanismName;
    var() name SourceParamName;
    var() bool bUseSource;
};

struct LBParamValueSource
{
    var() editconst name ParamName;
    var() LBParamSourcePointer ValueSource;
};

struct LBParam
{
    var() name MechanismName;
    var() name ParamName;
};

struct LBTypedParamPtr
{
    var() LBMechanismParam ParamPtr;
    var() ParamTypes ParamType;
};


var(MechanismBase) actor parent; //parent actor
var(MechanismBase) class<Actor> parentclass;
var(MechanismBase) bool benabled; //whether this mechanism is currently enabled
var(MechanismBase) name mechname; //id of the current mech to find it out

var bool bfirsttick; //whether this is the first tick and we should do some inits

var(MechanismDebug) bool bLogDebug;
var(MechanismDebug) bool bLogFullInfo;

/*A mechanism, from which we get all params via GetParamFloat. Soon will be deprecated!*/ 
var(ParamSource) name ParameterSource; 
var(ParamSource) bool bUseParamSource; //Defines whether we should get params (from ParameterSource) 
/*An array, which contains a source pointer for each param*/
var(ParamSource) editfixedsize array<LBParamValueSource> ParamSource;

var(MechanismInfo) editfixedsize array<LBMechanismParamInfo> MechanismParams;

function InitMechanism()
{
    
}
 
function FirstTickInit()
{
    if (bfirsttick==true)
    {
        InitMechanism();
        bfirsttick=false;
    }
}
 
function SetParam(name param, object value, optional int priority=0)
{}
    
function SetParams(name param, array<object> value, optional int priority=0)
{}    
    
function SetParamInt(name param, int value, optional int priority=0)
{}    

function SetParamFloat(name param, float value, optional int priority=0)
{} 

function SetParamBool(name param, bool value, optional int priority=0)
{}        

function SetParamVector(name param, vector value, optional int priority=0)
{} 
 
function SetParamRotator(name param, rotator value, optional int priority=0)
{}    

//not fully supported for now    
function SetParamName(name param, name value, optional int priority=0)
{}     
    
function object GetParam(name param)
{}
    
function array<object> GetParams(name param)
{}
    
function int GetParamInt(name param)
{}    

function float GetParamFloat(name param)
{}      

function bool GetParamBool(name param)
{}
    
function vector GetParamVector(name param)
{} 
 
function rotator GetParamRotator(name param)
{}  

//not fully supported for now    
function name GetParamName(name param)
{}     
  
function PerfromTick(float dt)
{   
}
    
event OwnerTick(float deltatime)
{
    FirstTickInit();
    
    if(benabled==false)
        return;
        
    if (bUseParamSource)
        GetParameters(); 
  
    PerfromTick(deltatime);      
}

event OwnerAnimNotify(AnimNodeSequence notifynode, AnimNotifyTypes notifytype);
    
function GetParameters();    
    
function bool HasParam(name param)
{
    local int i;
    
    for (i=0;i<MechanismParams.Length;i++)
    {
        if (MechanismParams[i].ParamName==param)
            return true;
    } 
    
    return false;  
}

function bool HasParamWithType(name param, ParamTypes paramtype)
{
    local int i;
    
    for (i=0;i<MechanismParams.Length;i++)
    {
        if (MechanismParams[i].ParamName==param && MechanismParams[i].ParamType==paramtype)
            return true;
    } 
    
    return false;  
}

function LogError(string message)
{
    if (bLogDebug)
    `log(">>"$mechname$"::"$message$"<<");
}

function LogInfo(string message)
{
    if (bLogFullInfo)
    `log(">"$mechname$"::"$message$"<");
}

    
defaultproperties
{
    bfirsttick=true
    benabled=true
    
    bLogDebug=false
}