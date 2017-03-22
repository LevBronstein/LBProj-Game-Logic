/**
 *  LBAddParamRotatorSeq
 *
 *  Creation date: 09.03.2017 01:15
 *  Copyright 2017, Windows7
 */
class LBAddParamRotatorSeq extends SequenceAction;

var object targetactor;
var vector value;

var() name mechname;
var() name paramname;

event Activated()
{
    local rotator r,rvalue;
    local vector v;
    
    //rvalue.Yaw=value.X * DegToUnrRot;
    //rvalue.Pitch=value.Y * DegToUnrRot;
    //rvalue.Roll=value.Z * DegToUnrRot;
    
    rvalue=VectorToRotator(value);
    
    if(LBActor(targetactor)!=none)
    {
        r=LBActor(targetactor).GetParamRotator(mechname,paramname);
        r=r+rvalue;
        LBActor(targetactor).SetParamRotator(mechname,paramname,r);
    }
    if(LBDynamicActor(targetactor)!=none)
    {
        r=LBDynamicActor(targetactor).GetParamRotator(mechname,paramname);
        r=r+rvalue;
        LBDynamicActor(targetactor).SetParamRotator(mechname,paramname,r);
    }
    if(LBPawn(targetactor)!=none)
    {
        r=LBPawn(targetactor).GetParamRotator(mechname,paramname);
        r=r+rvalue;
        LBPawn(targetactor).SetParamRotator(mechname,paramname,r);
    }
    if(LBSMPhysicsActor(targetactor)!=none)
    {
        r=LBSMPhysicsActor(targetactor).GetParamRotator(mechname,paramname);
        r=r+rvalue;
        LBSMPhysicsActor(targetactor).SetParamRotator(mechname,paramname,r);
    }
    if(LBSKMPhysicsActor(targetactor)!=none)
    {
        r=LBSKMPhysicsActor(targetactor).GetParamRotator(mechname,paramname);
        r=r+rvalue;
        LBSKMPhysicsActor(targetactor).SetParamRotator(mechname,paramname,r);
    }
    if(LBCamera(targetactor)!=none)
    {
        r=LBCamera(targetactor).GetParamRotator(mechname,paramname);
        r=r+rvalue;
        LBCamera(targetactor).SetParamRotator(mechname,paramname,r);
    }
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
    
    ObjName="Add Actor Vector (Rotator) Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Vector (Rotator) Value",PropertyName=value)
}
