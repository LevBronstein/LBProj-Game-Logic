/**
 *  LBGetParamNameSeq
 *
 *  Creation date: 22.12.2016 21:19
 *  Copyright 2016, Windows7
 */
class LBGetParamNameSeq extends SequenceAction;

var Object targetactor;
var name value;

var() name mechname;
var() name paramname;

event Activated()
{
    if(LBActor(targetactor)!=none)
        value=LBActor(targetactor).GetParamName(mechname,paramname);
    //if(LBDynamicActor(targetactor)!=none)
    //    value=LBDynamicActor(targetactor).GetParamName(mechname,paramname);
    if(LBSKMPhysicsActor(targetactor)!=none)
        value=LBSKMPhysicsActor(targetactor).GetParamName(mechname,paramname);  
    if(LBSMPhysicsActor(targetactor)!=none)
        value=LBSMPhysicsActor(targetactor).GetParamName(mechname,paramname);  
    if(LBPawn(targetactor)!=none)
        value=LBPawn(targetactor).GetParamName(mechname,paramname);
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Get Actor Name Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Name',LinkDesc="Name (literal) Value",bWriteable=true,PropertyName=value)
}
