/**
 *  LBSetParamObjecArraySeq
 *
 *  Creation date: 06.02.2017 23:15
 *  Copyright 2017, Windows7
 */
class LBSetParamObjecArraySeq extends SequenceAction;

var Object targetactor;

var() name mechname;
var() name paramname;

event Activated()
{
    local int i;
    local array<SequenceObject> LinkedObjs;
    local SeqVar_ObjectList ObjListVar;
    local array<object> value;
    
    GetLinkedObjects(LinkedObjs, class'SeqVar_ObjectList', false);
    
    ObjListVar=SeqVar_ObjectList(LinkedObjs[0]);
    
    for (i=0;i<ObjListVar.ObjList.Length;i++)
    {
        value.AddItem(ObjListVar.ObjList[i]);    
    }
    
    if(LBActor(targetactor)!=none)
        LBActor(targetactor).SetParams(mechname,paramname,value); 
    if(LBDynamicActor(targetactor)!=none)
        LBDynamicActor(targetactor).SetParams(mechname,paramname,value);
    if(LBPawn(targetactor)!=none)
        LBPawn(targetactor).SetParams(mechname,paramname,value);   
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Set Actor Object Array Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_ObjectList',LinkDesc="Object Array Value")
}