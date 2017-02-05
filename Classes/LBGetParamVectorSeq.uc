/**
 *  LBGetParamVectorSec
 *
 *  Creation date: 04.07.2016 18:45
 *  Copyright 2016, Windows7
 */
class LBGetParamVectorSeq extends SequenceAction;

var Object targetactor;
var vector value;

var() name mechname;
var() name paramname;

event Activated()
{
    if(LBActor(targetactor)!=none)
        value=LBActor(targetactor).GetParamVector(mechname,paramname);
    if(LBDynamicActor(targetactor)!=none)
        value=LBDynamicActor(targetactor).GetParamVector(mechname,paramname);
    if(LBPawn(targetactor)!=none)
        value=LBPawn(targetactor).GetParamVector(mechname,paramname);
}

defaultproperties
{
    bCallHandler=false
    
    ObjName="Get Actor Vector Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Vector Value",bWriteable=true,PropertyName=value)
}
