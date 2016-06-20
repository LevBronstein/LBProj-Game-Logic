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
    ParamType_Object,
    ParamType_ObjectArray,
    ParamType_Float,
    ParamType_Integer,
    ParamType_Boolean,
    ParamType_Vector,
    ParamType_Rotator,
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
 
var(ParamSource) name ParameterSource; //A mechanism, from which we get all params via GetParamFloat
var(ParamSource) bool bUseParamSource; //Defines whether we should get params (from ParameterSource) 

var(MechanismInfo) array<LBMechanismParamInfo> MechanismParams;
 
function FirstTickInit()
{
    if (bfirsttick==true)
    {
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
    
event OwnerTick(float deltatime)
{
    FirstTickInit();
    
    if(benabled==false)
        return;
        
    if (bUseParamSource)
        GetParameters();       
}

function GetParameters();    
    
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