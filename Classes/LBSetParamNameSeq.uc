/**
 *  LBSetParamNameSeq
 *
 *  Creation date: 22.12.2016 21:19
 *  Copyright 2016, Windows7
 */
class LBSetParamNameSeq extends SequenceAction;

var Object targetactor;
var name value;

var() name mechname;
var() name paramname;

event Activated()
{
    //`log(">>> ("@targetactor@"|"@targetpawn@")"@mechname@"."@paramname@"->"@value);
    if(LBActor(targetactor)!=none)
        LBActor(targetactor).SetParamName(mechname,paramname,value);
    //if(LBDynamicActor(targetactor)!=none)
    //    LBDynamicActor(targetactor).SetParamName(mechname,paramname,value);
    if(LBPawn(targetactor)!=none)
        LBPawn(targetactor).SetParamName(mechname,paramname,value);
    //if(LBCamera(targetactor)!=none)
    //    LBCamera(targetactor).SetParamName(mechname,paramname,value);
    //`log(">>> ("@targetactor@"|"@targetpawn@")"@mechname@"."@paramname@"="@targetactor.GetParamFloat(mechname, paramname)); 
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Set Actor Name Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Name',LinkDesc="Name (literal) Value",PropertyName=value)
}