/**
 *  MyProjActorMechanismBase
 *
 *  Creation date: 21.02.2016 22:45
 *  Copyright 2016, Windows7
 */
class LBMechanism extends Object 
editinlinenew;

 var(MechanismBase) actor parent; //parent actor
 var(MechanismBase) class<Actor> parentclass;
 
 var(MechanismBase) bool benabled; //whether this mechanism is currently enabled
 
 var bool bfirsttick; //whether this is the first tick and we should do some inits
 
 var(MechanismBase) name mechname; //id of the current mech to find it out
 var(MechanismDebug) bool bLogDebug;
 
 
function FirstTickInit()
{
    if (bfirsttick==true)
    {
        bfirsttick=false;
    }
}
 
function SetParam(name param, object value)
{}
    
function SetParamInt(name param, int value)
{}    

function SetParamFloat(name param, float value)
{} 

function SetParamBool(name param, bool value)
{}        

function SetParamVector(name param, vector value)
{} 
 
function SetParamRotator(name param, rotator value)
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
}

function LogError(string message)
{
    if (bLogDebug)
    `log(">>"@mechname@message@"<<");
}
    
defaultproperties
{
    bfirsttick=true
    benabled=true
    
    bLogDebug=false
}