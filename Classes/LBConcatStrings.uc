/**
 *  LBConcatStrings
 *
 *  Creation date: 08.07.2017 23:57
 *  Copyright 2017, Win10
 */
class LBConcatStrings extends SequenceAction;

var String str1;
var String str2;
var String resstr;

event Activated()
{
    resstr=str1$str2; 
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Concat Strings"
    ObjCategory="LevBronstein Utils"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="String 1",PropertyName=str1)
    VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="String 2",PropertyName=str2)
    VariableLinks(2)=(ExpectedType=class'SeqVar_String',LinkDesc="Result",bWriteable=true,PropertyName=resstr)
}
