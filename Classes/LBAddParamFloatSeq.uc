/**
 *  LBAddParamFloatSeq
 *
 *  Creation date: 30.04.2016 23:08
 *  Copyright 2016, Windows7
 */
class LBAddParamFloatSeq extends SequenceAction;

var LBActor targetactor;
var LBPawn targetpawn;
var float value;

var() name mechname;
var() name paramname;

event Activated()
{
    local float v;
    
    if(targetactor!=none)
    {
        v=value+targetactor.GetParamFloat(mechname,paramname);
        targetactor.SetParamFloat(mechname,paramname,v); 
    }
    if(targetpawn!=none)
    {
        v=value+targetpawn.GetParamFloat(mechname,paramname);
        targetpawn.SetParamFloat(mechname,paramname,v);
    }
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Add Actor Float Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Pawn",PropertyName=targetpawn)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Float',LinkDesc="Float Value",PropertyName=value)
}

