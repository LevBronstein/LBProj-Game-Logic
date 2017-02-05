/**
 *  LBCompareObjectsSeq
 *
 *  Creation date: 04.02.2017 23:54
 *  Copyright 2017, Windows7
 */
class LBCompareObjectsSeq extends SequenceCondition;

var() object ValueA;
var() object ValueB;

event Activated()
{    
    if (ValueA==ValueB) 
        OutputLinks[0].bHasImpulse = TRUE;
    else
        OutputLinks[1].bHasImpulse = TRUE;    
}

defaultproperties
{
    ObjName="Compare Objects"
    ObjCategory="LevBronstein"

    InputLinks(0)=(LinkDesc="In")
    OutputLinks(0)=(LinkDesc="A == B")
    OutputLinks(1)=(LinkDesc="A != B")

    VariableLinks(0)=(ExpectedType=class'SeqVar_Object', LinkDesc="A", PropertyName=ValueA)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Object', LinkDesc="B", PropertyName=ValueB)
}