/**
 *  LBDegToUnrRot
 *
 *  Creation date: 19.10.2017 23:23
 *  Copyright 2017, Win10
 */
class LBDegToUnrRot extends SequenceAction;

var() vector rotvalue;
var() float floatvalue;
var vector rotresult;
var float floatresult;

event Activated()
{
    rotresult=rotvalue * degtounrrot; 
    floatresult=floatvalue * degtounrrot;   
}

defaultproperties
{
    bCallHandler=false
    
    ObjName="Convert Deg To UnrRot"
    ObjCategory="LevBronstein Utils"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Rotator (vector) value",PropertyName=rotvalue)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Float value",PropertyName=floatvalue)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Rotator (vector) Result",bWriteable=true,PropertyName=rotresult)
    VariableLinks(3)=(ExpectedType=class'SeqVar_Float',LinkDesc="Float result",bWriteable=true,PropertyName=floatresult)
}
