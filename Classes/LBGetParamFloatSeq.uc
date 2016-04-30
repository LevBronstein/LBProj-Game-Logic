/**
 *  LBGetParamFloatSeq
 *
 *  Creation date: 30.04.2016 22:57
 *  Copyright 2016, Windows7
 */
class LBGetParamFloatSeq extends SequenceAction;

var LBActor targetactor;
var LBPawn targetpawn;
var float value;

var() name mechname;
var() name paramname;

event Activated()
{
    if(targetactor!=none)
        value=targetactor.GetParamFloat(mechname,paramname); 
    if(targetpawn!=none)
        value=targetpawn.GetParamFloat(mechname,paramname);
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Get Actor Float Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Pawn",PropertyName=targetpawn)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Float',LinkDesc="Float Value",bWriteable=true,PropertyName=value)
}
