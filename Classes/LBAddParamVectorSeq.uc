/**
 *  LBAddParamVectorSeq
 *
 *  Creation date: 13.07.2016 23:38
 *  Copyright 2016, Windows7
 */
class LBAddParamVectorSeq extends SequenceAction;

var Actor targetactor;
var vector value;

var() name mechname;
var() name paramname;

event Activated()
{
    local vector v;
    
    if(LBActor(targetactor)!=none)
    {
        v=LBActor(targetactor).GetParamVector(mechname,paramname);
        v=v+value;
        LBActor(targetactor).SetParamVector(mechname,paramname,v);
    }
    if(LBDynamicActor(targetactor)!=none)
    {
        v=LBDynamicActor(targetactor).GetParamVector(mechname,paramname);
        v=v+value;
        LBDynamicActor(targetactor).SetParamVector(mechname,paramname,v);
    }
    if(LBPawn(targetactor)!=none)
    {
        v=LBPawn(targetactor).GetParamVector(mechname,paramname);
        v=v+value;
        LBPawn(targetactor).SetParamVector(mechname,paramname,v);
    }
    if(LBCamera(targetactor)!=none)
    {
        v=LBCamera(targetactor).GetParamVector(mechname,paramname);
        v=v+value;
        LBCamera(targetactor).SetParamVector(mechname,paramname,v);
    }
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Add Actor Vector Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Vector Value",PropertyName=value)
}
