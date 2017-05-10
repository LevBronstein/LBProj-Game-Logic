/**
 *  LBValueInterpolator
 *
 *  Creation date: 09.05.2017 02:04
 *  Copyright 2017, Windows7
 */
class LBValueInterpolator extends LBMechanism;

enum InterpFunctions
{
    InterpFunctions_Linear,
    InterpFunctions_Square,
    InterpFunctions_Cubic, 
};

struct Value
{
    var() float Value;
    var() string ValueName;
    var() float MaxValue;
    var() float MinValue;
    var() float InterpStep;
    var() InterpFunctions InterpFunction;
};

var() array<Value> Values;

function float InterpValueLinear(Value val, float dt)
{
    local float res;

    res=FClamp(val.Value + (val.InterpStep * dt),val.MinValue,val.MaxValue);
    
    return res;
}

function PerfromTick(float dt)
{
    local int i;

    for (i=0;i<Values.Length;i++)
    {
        switch (Values[i].InterpFunction)
        {
            case InterpFunctions_Linear:
                Values[i].Value=InterpValueLinear(Values[i],dt); 
                break;
            default: 
                Values[i].Value=InterpValueLinear(Values[i],dt); 
                break;    
        }
           
    }  
      
    if (bLogFullInfo)
        DisplayArray();  
}
   
function DisplayArray()
{
    local int i;

    `log("------------"@mechname@"------------");
    
    for (i=0;i<Values.Length;i++)
    {
        `log(Values[i].ValueName@":"@Values[i].Value@"["@Values[i].MinValue@","@Values[i].MaxValue@"]"@Values[i].InterpStep);           
    } 

    `log("------------------------------------");    
}    
    
defaultproperties
{
    mechname="Value_Interpolator"
}
