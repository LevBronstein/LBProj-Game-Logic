/**
 *  LBCompareVectorsApproxSeq
 *
 *  Creation date: 21.05.2016 01:20
 *  Copyright 2016, Windows7
 */
class LBCompareVectorsApproxSeq extends SequenceCondition;

var() vector ValueA;
var() vector ValueB;
var() float Approximation;

event Activated()
{
    local float d;
    
    d=VSize(ValueA-ValueB);
    
    if (d <= Approximation)
        OutputLinks[0].bHasImpulse = TRUE;
    else
        OutputLinks[1].bHasImpulse = TRUE;    
        
    `log("A:"@ValueA@"B:"@ValueB@"d:"@d);
}

defaultproperties
{
    Approximation=0
    
    ObjName="Compare Vectors Approx"
    ObjCategory="LevBronstein"

    InputLinks(0)=(LinkDesc="In")
    OutputLinks(0)=(LinkDesc="Overlap")
    OutputLinks(1)=(LinkDesc="Don't overlap")

    VariableLinks(0)=(ExpectedType=class'SeqVar_Vector', LinkDesc="A", PropertyName=ValueA)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Vector', LinkDesc="B", PropertyName=ValueB)
}

