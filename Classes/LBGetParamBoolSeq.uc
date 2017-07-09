/**
 *  LBGetParamBoolSeq
 *
 *  Creation date: 07.07.2017 23:07
 *  Copyright 2017, Win10
 */
class LBGetParamBoolSeq extends SequenceAction;

var Object targetactor;
var bool value;

var() name mechname;
var() name paramname;

event Activated()
{
    if(LBActor(targetactor)!=none)
        value=LBActor(targetactor).GetParamBool(mechname,paramname);
    if(LBDynamicActor(targetactor)!=none)
        value=LBDynamicActor(targetactor).GetParamBool(mechname,paramname);
    if(LBSKMPhysicsActor(targetactor)!=none)
        value=LBSKMPhysicsActor(targetactor).GetParamBool(mechname,paramname);  
    if(LBSMPhysicsActor(targetactor)!=none)
        value=LBSMPhysicsActor(targetactor).GetParamBool(mechname,paramname);     
    if(LBPawn(targetactor)!=none)
        value=LBPawn(targetactor).GetParamBool(mechname,paramname);
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Get Actor Bool Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Bool',LinkDesc="Bool Value",bWriteable=true,PropertyName=value)
}