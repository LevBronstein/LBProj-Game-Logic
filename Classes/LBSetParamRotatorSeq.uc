/**
 *  LBSetParamRotatorSeq
 *
 *  Creation date: 13.07.2016 22:52
 *  Copyright 2016, Windows7
 */
class LBSetParamRotatorSeq extends SequenceAction;

var Object targetactor;
var vector value;
var rotator rvalue;

var() name mechname;
var() name paramname;

event Activated()
{
    rvalue.Yaw=value.X * DegToUnrRot;
    rvalue.Pitch=value.Y * DegToUnrRot;
    rvalue.Roll=value.Z * DegToUnrRot;
    
    if(LBActor(targetactor)!=none)
        LBActor(targetactor).SetParamRotator(mechname,paramname,rvalue); 
    if(LBDynamicActor(targetactor)!=none)
        LBDynamicActor(targetactor).SetParamRotator(mechname,paramname,rvalue);
    if(LBPawn(targetactor)!=none)
        LBPawn(targetactor).SetParamRotator(mechname,paramname,rvalue);
    if(LBCamera(targetactor)!=none)
        LBCamera(targetactor).SetParamRotator(mechname,paramname,rvalue);
    if(LBSKMPhysicsActor(targetactor)!=none)
        LBSKMPhysicsActor(targetactor).SetParamRotator(mechname,paramname,rvalue); 
    if(LBSMPhysicsActor(targetactor)!=none)
        LBSMPhysicsActor(targetactor).SetParamRotator(mechname,paramname,rvalue);    
    if(LBSkeletalMeshActor(targetactor)!=none)
        LBSkeletalMeshActor(targetactor).SetParamRotator(mechname,paramname,rvalue);    
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Set Actor Vector (Rotator) Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Rotator (Vector) Value",PropertyName=value)
}