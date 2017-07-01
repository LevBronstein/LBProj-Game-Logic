/**
 *  LBClampFloatSeq
 *
 *  Creation date: 01.07.2017 23:41
 *  Copyright 2017, Win10
 */
class LBClampFloatSeq extends SequenceAction;

var float Value;
var() float MinValue;
var() float MaxValue;
var float Result;

event Activated()
{   
    result=Clamp(Value, MinValue,  MaxValue);
}

defaultproperties
{
    bCallHandler=false
    
    ObjName="Clamp Float Value"
    ObjCategory="LevBronstein Utils"
    
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Float',LinkDesc="Input Value",PropertyName=Value)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Min Value",PropertyName=MinValue)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Float',LinkDesc="Max Value",PropertyName=MaxValue)
    VariableLinks(3)=(ExpectedType=class'SeqVar_Float',LinkDesc="Result Value",bWriteable=true,PropertyName=Result)
}
