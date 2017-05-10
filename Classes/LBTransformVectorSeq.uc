/**
 *  LBTransformVectorSeq
 *
 *  Creation date: 08.04.2017 23:42
 *  Copyright 2017, Windows7
 */
class LBTransformVectorSeq extends SequenceAction;

var vector coordsys;
var vector value;
var vector result;

event Activated()
{
    local vector X, Y, Z;
    local rotator r;
    
    r.Yaw=coordsys.X*degtounrrot;
    r.Pitch=coordsys.Y*degtounrrot;
    r.Roll=coordsys.Z*degtounrrot;
    
    GetAxes(r,X,Y,Z);
    `log("Coordsys (rotator)"@r*unrrottodeg);
    
    result=value.X*X+value.Y*Y+value.Z*Z;
}

defaultproperties
{
    bCallHandler=false
    
    ObjName="Transform Vector"
    ObjCategory="LevBronstein Utils"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Coordinate System",PropertyName=coordsys)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Vector",PropertyName=value)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Result",bWriteable=true,PropertyName=result)
}
