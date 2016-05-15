/**
 *  LBActorController
 *
 *  Creation date: 15.05.2016 22:11
 *  Copyright 2016, Windows7
 */
class LBActorController extends LBMechanism;

struct NamedParam
{
    var() name ParamName;
    var() float ParamValue;
};

//fixed size in editor
var(Params) array<NamedParam> CurParamValues;

function float GetParamFloat(name param)
{
    local int i;
    
    for (i=0; i<CurParamValues.Length; i++)
    {
        if (CurParamValues[i].ParamName==param)
            return CurParamValues[i].ParamValue; 
    }
}  

function SetParamFloat(name param, float value)
{
    local int i;
    
    for (i=0; i<CurParamValues.Length; i++)
    {
        if (CurParamValues[i].ParamName==param)
            CurParamValues[i].ParamValue=value; 
    }
}

defaultproperties
{
}
