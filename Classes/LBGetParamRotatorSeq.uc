/**
 *  LBGetParamRotatorSeq
 *
 *  Creation date: 09.03.2017 01:20
 *  Copyright 2017, Windows7
 */
class LBGetParamRotatorSeq extends SequenceAction;

var Object targetactor;
var vector value;

var() name mechname;
var() name paramname;

event Activated()
{
    local rotator r;
    
    if(LBActor(targetactor)!=none)
        r=LBActor(targetactor).GetParamRotator(mechname,paramname);
    if(LBDynamicActor(targetactor)!=none)
        r=LBDynamicActor(targetactor).GetParamRotator(mechname,paramname);
    if(LBSKMPhysicsActor(targetactor)!=none)
        r=LBSKMPhysicsActor(targetactor).GetParamRotator(mechname,paramname);
    if(LBSMPhysicsActor(targetactor)!=none)
        r=LBSMPhysicsActor(targetactor).GetParamRotator(mechname,paramname);  
    if(LBPawn(targetactor)!=none)
        r=LBPawn(targetactor).GetParamRotator(mechname,paramname);
        
    //value.X=r.Yaw * UnrRotToDeg;
    //value.Y=r.Pitch * UnrRotToDeg;
    //value.Z=r.Roll * UnrRotToDeg;
    
    value=RotatorToVector(r);
}

function vector RotatorToVector(rotator r)
{
    local vector v;
    
    v.X=r.Yaw * UnrRotToDeg;
    v.Y=r.Pitch * UnrRotToDeg;
    v.Z=r.Roll * UnrRotToDeg;    
    
    return v;
}

function rotator VectorToRotator(vector v)
{
    local rotator r;
    
    r.Yaw=v.X * DegToUnrRot;
    r.Pitch=v.Y * DegToUnrRot;
    r.Roll=v.Z * DegToUnrRot;  
  
    return r;  
}

defaultproperties
{
    bCallHandler=false
    
    ObjName="Get Actor Vector (Rotator) Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Vector (Rotator) Value",bWriteable=true,PropertyName=value)
}

