/**
 *  LBEnumeratedInteractableMechanism
 *
 *  Creation date: 18.05.2016 00:49
 *  Copyright 2016, Windows7
 */
class LBEnumeratedInteractionMechanism extends LBInteractableMechanism;

//Перенести ниже по иерархии!
enum ParamTypes
{
    PARAM_TYPE_FLOAT<DisplayName="Float">,
    PARAM_TYPE_INT<DisplayName="Integer">,
    PARAM_TYPE_BOOL<DisplayName="Boolean">,
};

//Перенести ниже по иерархии!
//Добавить ADD, SUB, MUL?
enum ParamQueries
{
    PARAM_QUERY_SET<DisplayName="Set">,
    PARAM_TYPE_GET<DisplayName="Get">,
};

//Перенести ниже по иерархии!
struct PresetParam
{
    var() name PresetName; //The name of this preset
    var() name ParamName; //The name of the parameter
    var() ParamTypes ParamType; //A type of the parameter 
    var() ParamQueries PramQuery; //A type of the query i.e. SET, GET
    var() float FloatParamValue; //The value used only, when ParamType is set to PARAM_TYPE_FLOAT
    var() int IntParamValue; //The value used only, when ParamType is set to PARAM_TYPE_INT
    var() bool BoolParamValue; //The value used only, when ParamType is set to PARAM_TYPE_BOOL
};

var(EnumeratedInteraction) array<PresetParam> Presets;

function ExecutePreset(actor target, name targetmech, int id)
{
   
    if (id<0 || id>=Presets.Length)
        return;
   
    Execute(target, targetmech, Presets[id]);
}

function Execute(actor target, name targetmech, PresetParam param)
{
    if (param.ParamType==PARAM_TYPE_FLOAT)
    {
        if (param.PramQuery==PARAM_QUERY_SET)
        {
            SetTargetParamFloat(target, targetmech, param.ParamName, param.FloatParamValue);
        }
    }
    else if (param.ParamType==PARAM_TYPE_INT)
    {
        if (param.PramQuery==PARAM_QUERY_SET)
        {
            SetTargetParamInt(target, targetmech, param.ParamName, param.IntParamValue);
        }
    }
    else if (param.ParamType==PARAM_TYPE_BOOL)
    {
        if (param.PramQuery==PARAM_QUERY_SET)
        {
            SetTargetParamBool(target, targetmech, param.ParamName, param.BoolParamValue);
        }
    }    
    else
        return;  
}

defaultproperties
{
}
