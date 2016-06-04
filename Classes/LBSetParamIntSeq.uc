/**
 *  LBSetParamIntSeq
 *
 *  Creation date: 15.05.2016 01:26
 *  Copyright 2016, Windows7
 */
class LBSetParamIntSeq extends SequenceAction;

var Actor targetactor;
var int value;

var() name mechname;
var() name paramname;

event Activated()
{
    //`log(">>> ("@targetactor@"|"@targetpawn@")"@mechname@"."@paramname@"->"@value);
    if(LBActor(targetactor)!=none)
        LBActor(targetactor).SetParamInt(mechname,paramname,value); 
    if(LBDynamicActor(targetactor)!=none)
        LBDynamicActor(targetactor).SetParamInt(mechname,paramname,value);
    if(LBPawn(targetactor)!=none)
        LBPawn(targetactor).SetParamInt(mechname,paramname,value);
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Set Actor Integer Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Integer Value",PropertyName=value)
}