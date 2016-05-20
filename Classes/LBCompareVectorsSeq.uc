/**
 *  LBCompareVectorsSeq
 *
 *  Creation date: 21.05.2016 01:09
 *  Copyright 2016, Windows7
 */
class LBCompareVectorsSeq extends SequenceCondition;

var() vector ValueA;
var() vector ValueB;

event Activated()
{    
    local float dA;
    local float dB;
   
    dA=VSize(ValueA);
    dB=VSize(ValueB);
    
    if (dA > dB) 
        OutputLinks[0].bHasImpulse = TRUE;
    else if (dA == dB)
        OutputLinks[1].bHasImpulse = TRUE;
    else if (dA < dB)
        OutputLinks[2].bHasImpulse = TRUE;    
}


defaultproperties
{
    ObjName="Compare Vectors"
    ObjCategory="LevBronstein"

    InputLinks(0)=(LinkDesc="In")
    OutputLinks(0)=(LinkDesc="A > B")
    OutputLinks(1)=(LinkDesc="A = B")
    OutputLinks(2)=(LinkDesc="A < B")

    VariableLinks(0)=(ExpectedType=class'SeqVar_Vector', LinkDesc="A", PropertyName=ValueA)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Vector', LinkDesc="B", PropertyName=ValueB)
}
