/**
 *  LBActorController
 *
 *  Creation date: 15.05.2016 22:11
 *  Copyright 2016, Windows7
 */
class LBActorController extends LBInteractableMechanism;

struct NamedParam
{
    var() name ParamName; //The name of this parameter
    var() ParamTypes ParamType; //The type of this parameter, set to identify value types
    
    //values of different type, use only that, which is set by @ParamType
    var() ObjectValue ObjectParam;
    var() ObjectArrayValue ObjectArrayParam;
    var() FloatValue FloatParam; 
    var() IntegerValue IntegerParam;
    var() BooleanValue BooleanParam;
    var() VectorValue VectorParam;
    var() RotatorValue RotatorParam;
    
    var() bool bUseSource; //Set to true to get value from anywhere, also @bUseParamSource should be set to true
    var() LBMechanismParam ValueSource;
    
    //priority
    var int Priority; 
};

var(Params) array<NamedParam> CurParamsValues;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;  
      
    ResetPriority();     
}
    
event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
        
    ResetPriority();
}   

//получение значения для каждой переменной, проблема может возникнуть, если до этого 
//она была установлена с более высоким приоритетом
function GetParameters()
{
    local int i;
        
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].bUseSource)
        {
            //гемор с приоритетами? тупо использовать внутренние функции?
            switch (CurParamsValues[i].ParamType)
            {
                case ParamType_Object:
                    SetParam(CurParamsValues[i].ParamName, GetTargetParam(CurParamsValues[i].ValueSource.ParentActor, CurParamsValues[i].ValueSource.MechanismName, CurParamsValues[i].ValueSource.ParamName));
                break;
                case ParamType_ObjectArray:
                    SetParams(CurParamsValues[i].ParamName, GetTargetParams(CurParamsValues[i].ValueSource.ParentActor, CurParamsValues[i].ValueSource.MechanismName, CurParamsValues[i].ValueSource.ParamName));
                break;
                case ParamType_Float:
                    SetParamFloat(CurParamsValues[i].ParamName, GetTargetParamFloat(CurParamsValues[i].ValueSource.ParentActor, CurParamsValues[i].ValueSource.MechanismName, CurParamsValues[i].ValueSource.ParamName));
                break;
                case ParamType_Integer:
                    SetParamInt(CurParamsValues[i].ParamName, GetTargetParamInt(CurParamsValues[i].ValueSource.ParentActor, CurParamsValues[i].ValueSource.MechanismName, CurParamsValues[i].ValueSource.ParamName));
                break;
                case ParamType_Boolean:
                    SetParamBool(CurParamsValues[i].ParamName, GetTargetParamBool(CurParamsValues[i].ValueSource.ParentActor, CurParamsValues[i].ValueSource.MechanismName, CurParamsValues[i].ValueSource.ParamName));
                break;
                case ParamType_Vector:
                    SetParamVector(CurParamsValues[i].ParamName, GetTargetParamVector(CurParamsValues[i].ValueSource.ParentActor, CurParamsValues[i].ValueSource.MechanismName, CurParamsValues[i].ValueSource.ParamName));
                break;
                case ParamType_Rotator:
                    SetParamRotator(CurParamsValues[i].ParamName, GetTargetParamRotator(CurParamsValues[i].ValueSource.ParentActor, CurParamsValues[i].ValueSource.MechanismName, CurParamsValues[i].ValueSource.ParamName));
                break;
            }
        }
    }
}

function ResetPriority()
{
    local int i;
        
    for (i=0; i<CurParamsValues.Length; i++)
    {
        CurParamsValues[i].Priority=0;
    }
}

function object GetParam(name param)
{
    local int i;
        
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        return CurParamsValues[i].ObjectParam.Value; 
    }
    
    LogError("Parameter name ("@param@") was not found!"); 
    return none;   
} 

function array<object> GetParams(name param)
{
    local int i;
    local array<object> val;    
    
    val.Length=0;
    
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        return CurParamsValues[i].ObjectArrayParam.Value; 
    }
    
    LogError("Parameter name ("@param@") was not found!"); 
    return val;   
} 


function float GetParamFloat(name param)
{
    local int i;
        
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        return CurParamsValues[i].FloatParam.Value; 
    }
    
    LogError("Parameter name ("@param@") was not found!"); 
    return 0;   
} 

function int GetParamInt(name param)
{
    local int i;
        
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        return CurParamsValues[i].IntegerParam.Value; 
    }
    
    LogError("Parameter name ("@param@") was not found!"); 
    return 0;   
}  

function bool GetParamBool(name param)
{
    local int i;
        
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        return CurParamsValues[i].BooleanParam.Value; 
    }
    
    LogError("Parameter name ("@param@") was not found!"); 
    return false;   
}  

function vector GetParamVector(name param)
{
    local int i;
        
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        return CurParamsValues[i].VectorParam.Value; 
    }
    
    LogError("Parameter name ("@param@") was not found!"); 
    return vect(0,0,0);   
} 

function rotator GetParamRotator(name param)
{
    local int i;
        
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        return CurParamsValues[i].RotatorParam.Value; 
    }
    
    LogError("Parameter name ("@param@") was not found!"); 
    return rot(0,0,0);   
} 

function SetParamFloat(name param, float value, optional int priority=0)
{
    local int i;
    
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        {
            if (CurParamsValues[i].Priority <= priority)
            {
                if (CurParamsValues[i].FloatParam.bClampValue)
                {
                    //А что, если значение, выходящее за пределы будет задано из редактора и не будет проверено в SetParamFloat?
                    CurParamsValues[i].FloatParam.Value=fclamp(value, CurParamsValues[i].FloatParam.ValueMin, CurParamsValues[i].FloatParam.ValueMax);
                }
                else
                    CurParamsValues[i].FloatParam.Value=value; 
                
                CurParamsValues[i].Priority=priority;
            }
            return;
        }
    }
    
    LogError("Parameter name ("@param@") was not found!");
}

function SetParamInt(name param, int value, optional int priority=0)
{
    local int i;
    
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        {
            if (CurParamsValues[i].Priority <= priority)
            {
                if (CurParamsValues[i].IntegerParam.bClampValue)
                {
                    //А что, если значение, выходящее за пределы будет задано из редактора и не будет проверено в SetParamFloat?
                    CurParamsValues[i].IntegerParam.Value=clamp(value, CurParamsValues[i].IntegerParam.ValueMin, CurParamsValues[i].IntegerParam.ValueMax);
                }
                else
                    CurParamsValues[i].IntegerParam.Value=value; 
                
                CurParamsValues[i].Priority=priority;
            }
            return;
        }
    }
    
    LogError("Parameter name ("@param@") was not found!");
}

function SetParamBool(name param, bool value, optional int priority=0)
{
    local int i;
    
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        {
            if (CurParamsValues[i].Priority <= priority)
            {
                CurParamsValues[i].BooleanParam.Value=value; 
                CurParamsValues[i].Priority=priority;
            }
            return;
        }
    }
    
    LogError("Parameter name ("@param@") was not found!");
}

function SetParam(name param, object value, optional int priority=0)
{
    local int i;
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        {
            if (CurParamsValues[i].Priority <= priority)
            {
                CurParamsValues[i].ObjectParam.Value=value; 
                CurParamsValues[i].Priority=priority;
            }
            return;
        }
    }
    
    LogError("Parameter name ("@param@") was not found, cannot set a value!");
}

function SetParams(name param, array<object> value, optional int priority=0)
{
    local int i;
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        {
            if (CurParamsValues[i].Priority <= priority)
            {
                CurParamsValues[i].ObjectArrayParam.Value=value; 
                CurParamsValues[i].Priority=priority;
            }
            return;
        }
    }
    
    LogError("Parameter name ("@param@") was not found, cannot set a value!");
}

function SetParamVector(name param, vector value, optional int priority=0)
{
    local int i;
    
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        {
            if (CurParamsValues[i].Priority <= priority)
            {
                CurParamsValues[i].VectorParam.Value=value; 
                CurParamsValues[i].Priority=priority;
            }
            return;
        }
    }
    
    LogError("Parameter name ("@param@") was not found, cannot set a value!");
}

function SetParamRotator(name param, rotator value, optional int priority=0)
{
    local int i;
    
    for (i=0; i<CurParamsValues.Length; i++)
    {
        if (CurParamsValues[i].ParamName==param)
        {
            if (CurParamsValues[i].Priority <= priority)
            {
                CurParamsValues[i].RotatorParam.Value=value; 
                CurParamsValues[i].Priority=priority;
            }
            return;
        }
    }
    
    LogError("Parameter name ("@param@") was not found, cannot set a value!");
}

function LogTransactions()
{
    local int i;
    
    `log("ActorController:: Total variables:"@CurParamsValues.Length);
    
    for (i=0;i<CurParamsValues.Length;i++)
    {
        `log(">"$(i+1)$":"@CurParamsValues[i].ParamName@"="@CurParamsValues[i].ObjectParam.Value$"<");
        
    }
}
    

defaultproperties
{
}
