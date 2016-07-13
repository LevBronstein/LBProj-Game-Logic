/**
 *  LBSetParamVector
 *
 *  Creation date: 13.07.2016 22:46
 *  Copyright 2016, Windows7
 */
class LBSetParamVectorSeq extends SequenceAction;

var Actor targetactor;
var vector value;

var() name mechname;
var() name paramname;

event Activated()
{
    if(LBActor(targetactor)!=none)
        LBActor(targetactor).SetParamVector(mechname,paramname,value); 
    if(LBDynamicActor(targetactor)!=none)
        LBDynamicActor(targetactor).SetParamVector(mechname,paramname,value);
    if(LBPawn(targetactor)!=none)
        LBPawn(targetactor).SetParamVector(mechname,paramname,value);
    if(LBCamera(targetactor)!=none)
        LBCamera(targetactor).SetParamVector(mechname,paramname,value);    
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Set Actor Vector Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Vector Value",PropertyName=value)
}

