/**
 *  LBAddParamFloatSeq
 *
 *  Creation date: 30.04.2016 23:08
 *  Copyright 2016, Windows7
 */
class LBAddParamFloatSeq extends SequenceAction;

var Actor targetactor;
var float value;

var() name mechname;
var() name paramname;

event Activated()
{
    local float v;
    
    if(LBActor(targetactor)!=none)
    {
        v=LBActor(targetactor).GetParamFloat(mechname,paramname);
        v=v+value;
        LBActor(targetactor).SetParamFloat(mechname,paramname,v);
    }
    if(LBDynamicActor(targetactor)!=none)
    {
        v=LBDynamicActor(targetactor).GetParamFloat(mechname,paramname);
        v=v+value;
        LBDynamicActor(targetactor).SetParamFloat(mechname,paramname,v);
    }
    if(LBPawn(targetactor)!=none)
    {
        v=LBPawn(targetactor).GetParamFloat(mechname,paramname);
        v=v+value;
        LBPawn(targetactor).SetParamFloat(mechname,paramname,v);
    }
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Add Actor Float Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Float Value",PropertyName=value)
}

