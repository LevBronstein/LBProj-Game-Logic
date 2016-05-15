/**
 *  LBSetParamBoolSeq
 *
 *  Creation date: 15.05.2016 23:14
 *  Copyright 2016, Windows7
 */
class LBSetParamBoolSeq extends SequenceAction;

var LBActor targetactor;
var LBPawn targetpawn;
var bool value;

var() name mechname;
var() name paramname;

event Activated()
{
    //`log(">>> ("@targetactor@"|"@targetpawn@")"@mechname@"."@paramname@"->"@value);
    if(targetactor!=none)
        targetactor.SetParamBool(mechname,paramname,value); 
    if(targetpawn!=none)
        targetpawn.SetParamBool(mechname,paramname,value);
    //`log(">>> ("@targetactor@"|"@targetpawn@")"@mechname@"."@paramname@"="@targetactor.GetParamFloat(mechname, paramname)); 
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Set Actor Bool Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Pawn",PropertyName=targetpawn)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Bool',LinkDesc="Bool Value",PropertyName=value)
}
