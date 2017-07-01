/**
 *  LBPctInRangeSeq
 *
 *  Creation date: 01.07.2017 23:52
 *  Copyright 2017, Win10
 */
class LBPctInRangeSeq extends SequenceAction;

var float Value;
var() float MinValue;
var() float MaxValue;
var float Result;

event Activated()
{   
    Result=FPctByRange(Value, MinValue,  MaxValue);
}

defaultproperties
{
    bCallHandler=false
    
    ObjName="Percent In Range Float Value"
    ObjCategory="LevBronstein Utils"
    
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Float',LinkDesc="Input Value",PropertyName=Value)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Min Value",PropertyName=MinValue)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Float',LinkDesc="Max Value",PropertyName=MaxValue)
    VariableLinks(3)=(ExpectedType=class'SeqVar_Float',LinkDesc="Result Percent",bWriteable=true,PropertyName=Result)
}