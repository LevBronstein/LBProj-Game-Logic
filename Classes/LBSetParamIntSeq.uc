/**
 *  LBSetParamIntSeq
 *
 *  Creation date: 15.05.2016 01:26
 *  Copyright 2016, Windows7
 */
class LBSetParamIntSeq extends SequenceAction;

var LBActor targetactor;
var LBPawn targetpawn;
var int value;

var() name mechname;
var() name paramname;

event Activated()
{
    //`log(">>> ("@targetactor@"|"@targetpawn@")"@mechname@"."@paramname@"->"@value);
    if(targetactor!=none)
        targetactor.SetParamInt(mechname,paramname,value); 
    if(targetpawn!=none)
        targetpawn.SetParamInt(mechname,paramname,value);
    //`log(">>> ("@targetactor@"|"@targetpawn@")"@mechname@"."@paramname@"="@targetactor.GetParamFloat(mechname, paramname)); 
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Set Actor Integer Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Pawn",PropertyName=targetpawn)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Int',LinkDesc="Integer Value",PropertyName=value)
}