/**
 *  LBGetParamObjectArraySeq
 *
 *  Creation date: 06.02.2017 23:13
 *  Copyright 2017, Windows7
 */
class LBGetParamObjectArraySeq extends SequenceAction;

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
    
    ObjListVar.ObjList.Length = 0;
    
    if(LBActor(targetactor)!=none)
        value=LBActor(targetactor).GetParams(mechname,paramname);
    if(LBDynamicActor(targetactor)!=none)
        value=LBDynamicActor(targetactor).GetParams(mechname,paramname);
    if(LBPawn(targetactor)!=none)
        value=LBPawn(targetactor).GetParams(mechname,paramname);
     
    for (i=0;i<value.Length;i++)
    {
        ObjListVar.ObjList.AddItem(value[i]);    
    }
}

defaultproperties
{
    bCallHandler=false
    
    ObjName="Get Actor Object Array Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_ObjectList',LinkDesc="Object Array Value")
}
