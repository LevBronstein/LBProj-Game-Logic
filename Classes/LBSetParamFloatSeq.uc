/**
 *  LBSetParamFloatSeq
 *
 *  Creation date: 06.04.2016 00:29
 *  Copyright 2016, Windows7
 */
class LBSetParamFloatSeq extends SequenceAction;

var LBActor targetactor;
var LBPawn targetpawn;
var float value;

var() name mechname;
var() name paramname;

event Activated()
{
    if(targetactor!=none)
        targetactor.SetParamFloat(mechname,paramname,value); 
    if(targetpawn!=none)
        targetpawn.SetParamFloat(mechname,paramname,value);
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Set Actor Float Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Pawn",PropertyName=targetpawn)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Float',LinkDesc="Float Value",PropertyName=value)
}
