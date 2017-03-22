/**
 *  LBSetParamFloatSeq
 *
 *  Creation date: 06.04.2016 00:29
 *  Copyright 2016, Windows7
 */
class LBSetParamFloatSeq extends SequenceAction;

var Object targetactor;
var float value;

var() name mechname;
var() name paramname;

event Activated()
{
    //`log(">>> ("@targetactor@"|"@targetpawn@")"@mechname@"."@paramname@"->"@value);
    if(LBActor(targetactor)!=none)
        LBActor(targetactor).SetParamFloat(mechname,paramname,value);
    if(LBDynamicActor(targetactor)!=none)
        LBDynamicActor(targetactor).SetParamFloat(mechname,paramname,value);
    if(LBPawn(targetactor)!=none)
        LBPawn(targetactor).SetParamFloat(mechname,paramname,value);
    if(LBCamera(targetactor)!=none)
        LBCamera(targetactor).SetParamFloat(mechname,paramname,value);
    if(LBSKMPhysicsActor(targetactor)!=none)
        LBSKMPhysicsActor(targetactor).SetParamFloat(mechname,paramname,value); 
    if(LBSMPhysicsActor(targetactor)!=none)
        LBSMPhysicsActor(targetactor).SetParamFloat(mechname,paramname,value);    
    if(LBSkeletalMeshActor(targetactor)!=none)
        LBSkeletalMeshActor(targetactor).SetParamFloat(mechname,paramname,value);
    //`log(">>> ("@targetactor@"|"@targetpawn@")"@mechname@"."@paramname@"="@targetactor.GetParamFloat(mechname, paramname)); 
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Set Actor Float Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Float Value",PropertyName=value)
}
