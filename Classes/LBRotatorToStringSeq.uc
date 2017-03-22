/**
 *  LBRotatorToStringSeq
 *
 *  Creation date: 09.03.2017 01:40
 *  Copyright 2017, Windows7
 */
class LBRotatorToStringSeq extends SequenceAction;

var() vector srcvalue;
var string resvalue;

event Activated()
{   
    local rotator r;
    
    r=VectorToRotator(srcvalue);
    
    resvalue=string(r*UnrRotToDeg);    
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
    
    ObjName="Convert Vector (Rotator) To String"
    ObjCategory="LevBronstein Utils"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Source Value",PropertyName=srcvalue)
    VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="Result Value",bWriteable=true,PropertyName=resvalue)
}
