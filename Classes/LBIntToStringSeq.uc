/**
 *  LBIntToStringSeq
 *
 *  Creation date: 07.02.2017 19:30
 *  Copyright 2017, Windows7
 */
class LBIntToStringSeq extends SequenceAction;

var() int srcvalue;
var string resvalue;

event Activated()
{
    resvalue=string(srcvalue);    
}

defaultproperties
{
    bCallHandler=false
    
    ObjName="Convert Int To String"
    ObjCategory="LevBronstein Utils"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Source Value",PropertyName=srcvalue)
    VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="Result Value",bWriteable=true,PropertyName=resvalue)
}