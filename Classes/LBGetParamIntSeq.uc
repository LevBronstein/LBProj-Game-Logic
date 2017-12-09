/**
 *  LBGetParamIntSeq
 *
 *  Creation date: 09.12.2017 04:34
 *  Copyright 2017, Win10
 */
class LBGetParamIntSeq extends SequenceAction;

var Object targetactor;
var int value;

var() name mechname;
var() name paramname;

event Activated()
{
    if(LBActor(targetactor)!=none)
        value=LBActor(targetactor).GetParamInt(mechname,paramname);
    if(LBDynamicActor(targetactor)!=none)
        value=LBDynamicActor(targetactor).GetParamInt(mechname,paramname);
    if(LBSKMPhysicsActor(targetactor)!=none)
        value=LBSKMPhysicsActor(targetactor).GetParamInt(mechname,paramname);  
    if(LBSMPhysicsActor(targetactor)!=none)
        value=LBSMPhysicsActor(targetactor).GetParamInt(mechname,paramname);     
    if(LBPawn(targetactor)!=none)
        value=LBPawn(targetactor).GetParamInt(mechname,paramname);
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Get Actor Integer Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Integer Value",bWriteable=true,PropertyName=value)
}
