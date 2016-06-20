/**
 *  LBDebugMechanism
 *
 *  Creation date: 24.05.2016 00:25
 *  Copyright 2016, Windows7
 */
class LBDebugMechanism extends LBInteractableMechanism;

var() array<LBTypedParamPtr> DebugParams;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;     
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
   
    DisplayParamInfo();       
}   

function DisplayParamInfo()
{
    local int i;
    local LBParamContainer v;
    local string s;
    //local int j;
    
    for (i=0; i<DebugParams.Length; i++)
    {
        v=GetTargetParamContainerPtr(DebugParams[i].ParamPtr, DebugParams[i].ParamType);
        
        s="<undefined>";
        
        switch (DebugParams[i].ParamType)
        {
            case ParamType_Object:
                s=string(v.ObjectParam.value);
            break;
            case ParamType_ObjectArray:
                s="array["$string(v.ObjectArrayParam.value.Length)$"] of object";
                //for (j=0; j<ObjectArrayParam.value.Length; j++)
                // s=string(v.ObjectArrayParam.value[j]);   
            break;
            case ParamType_Float:
                s=string(v.FloatParam.value);
            break;
            case ParamType_Integer:
                s=string(v.IntegerParam.value);
            break;
            case ParamType_Boolean:
                s=string(v.BooleanParam.value);
            break;
            case ParamType_Vector:
                s=string(v.VectorParam.value);
            break;
            case ParamType_Rotator:
                s=string(v.RotatorParam.value);
            break;
        } 

    `log(DebugParams[i].ParamPtr.ParentActor$"."$DebugParams[i].ParamPtr.MechanismName$"."$DebugParams[i].ParamPtr.ParamName$"="$s); 
        
    }
}

defaultproperties
{
}
