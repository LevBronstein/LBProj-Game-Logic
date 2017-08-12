/**
 *  LBFloatToStringSeq
 *
 *  Creation date: 13.08.2017 01:24
 *  Copyright 2017, Win10
 */
class LBFloatToStringSeq extends SequenceAction;

var() float srcvalue;
var string resvalue;

event Activated()
{
    resvalue=string(srcvalue);    
}

defaultproperties
{
    bCallHandler=false
    
    ObjName="Convert Float To String"
    ObjCategory="LevBronstein Utils"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Float',LinkDesc="Source Value",PropertyName=srcvalue)
    VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="Result Value",bWriteable=true,PropertyName=resvalue)

}
