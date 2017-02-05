/**
 *  LBGetParamObject
 *
 *  Creation date: 13.06.2016 23:10
 *  Copyright 2016, Windows7
 */
class LBGetParamObjectSeq extends SequenceAction;

var Object targetactor;
var object value;

var() name mechname;
var() name paramname;

event Activated()
{
    if(LBActor(targetactor)!=none)
        value=LBActor(targetactor).GetParam(mechname,paramname);
    if(LBDynamicActor(targetactor)!=none)
        value=LBDynamicActor(targetactor).GetParam(mechname,paramname);
    if(LBPawn(targetactor)!=none)
        value=LBPawn(targetactor).GetParam(mechname,paramname);
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Get Actor Object Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Object Value",bWriteable=true,PropertyName=value)
}

