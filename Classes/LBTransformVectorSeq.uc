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

var() bool bInputInDegs;

event Activated()
{
    local vector X, Y, Z;
    local rotator r;
    
    if (bInputInDegs)
    {
        r.Yaw=coordsys.X*degtounrrot;
        r.Pitch=coordsys.Y*degtounrrot;
        r.Roll=coordsys.Z*degtounrrot;
    }
    else
    {
        r.Yaw=coordsys.X;
        r.Pitch=coordsys.Y;
        r.Roll=coordsys.Z;
    }
    
    GetAxes(r,X,Y,Z);
    //`log("Coordsys (rotator)"@coordsys*unrrottodeg);
    
    result=value.X*X+value.Y*Y+value.Z*Z;
}

defaultproperties
{
    bCallHandler=false
    
    bInputInDegs=true
    
    ObjName="Transform Vector"
    ObjCategory="LevBronstein Utils"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Coordinate System",PropertyName=coordsys)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Vector",PropertyName=value)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Result",bWriteable=true,PropertyName=result)
}
