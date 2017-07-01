/**
 *  LBHalfSumVectors
 *
 *  Creation date: 21.06.2017 19:59
 *  Copyright 2017, Win10
 */
class LBHalfSumVectorsSeq extends SequenceAction;

var vector vec1;
var vector vec2;
var vector result;

event Activated()
{
    local vector v;
    
    v.X=(vec1.X+vec2.X)/2;
    v.Y=(vec1.Y+vec2.Y)/2;
    v.Z=(vec1.Z+vec2.Z)/2;
        
    result=v;
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Halfsum Vectors"
    ObjCategory="LevBronstein Utils"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Vector1",PropertyName=vec1)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Vector2",PropertyName=vec2)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Result",bWriteable=true,PropertyName=result)
}
