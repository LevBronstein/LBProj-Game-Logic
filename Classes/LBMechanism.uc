/**
 *  MyProjActorMechanismBase
 *
 *  Creation date: 21.02.2016 22:45
 *  Copyright 2016, Windows7
 */
class LBMechanism extends Object 
editinlinenew;

struct LBMechanismParam
{
    var() actor ParentActor;
    var() name MechanismName;
    var() name ParamName;
};

var(MechanismBase) actor parent; //parent actor
var(MechanismBase) class<Actor> parentclass;

var(MechanismBase) bool benabled; //whether this mechanism is currently enabled

var bool bfirsttick; //whether this is the first tick and we should do some inits

var(MechanismBase) name mechname; //id of the current mech to find it out
var(MechanismDebug) bool bLogDebug;
var(MechanismDebug) bool bLogFullInfo;
 
var(ParamSource) name ParameterSource; //A mechanism, from which we get all params via GetParamFloat
var(ParamSource) bool bUseParamSource; //Defines whether we should get params (from ParameterSource) 
 
function FirstTickInit()
{
    if (bfirsttick==true)
    {
        bfirsttick=false;
    }
}
 
function SetParam(name param, object value, optional int priority=0)
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