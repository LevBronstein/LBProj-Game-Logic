/**
 *  LBSetParamObjectSeq
 *
 *  Creation date: 19.06.2016 23:20
 *  Copyright 2016, Windows7
 */
class LBSetParamObjectSeq extends SequenceAction;

var Actor targetactor;
var object value;

var() name mechname;
var() name paramname;

event Activated()
{
    //`log(">>> ("@targetactor@"|"@targetpawn@")"@mechname@"."@paramname@"->"@value);
    if(LBActor(targetactor)!=none)
        LBActor(targetactor).SetParam(mechname,paramname,value); 
    if(LBDynamicActor(targetactor)!=none)
        LBDynamicActor(targetactor).SetParam(mechname,paramname,value);
    if(LBPawn(targetactor)!=none)
        LBPawn(targetactor).SetParam(mechname,paramname,value);
    if(LBCamera(targetactor)!=none)
        LBCamera(targetactor).SetParam(mechname,paramname,value);    
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Set Actor Object Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Object Value",PropertyName=value)
}