/**
 *  LBAbsFloatSeq
 *
 *  Creation date: 02.07.2017 02:16
 *  Copyright 2017, Win10
 */
class LBAbsFloatSeq extends SequenceAction;

var float Value;
var float Result;

event Activated()
{   
    result=abs(Value);
}

defaultproperties
{
    bCallHandler=false
    
    ObjName="Abs Float Value"
    ObjCategory="LevBronstein Utils"
    
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Float',LinkDesc="Input Value",PropertyName=Value)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Result Value",bWriteable=true,PropertyName=Result)
}