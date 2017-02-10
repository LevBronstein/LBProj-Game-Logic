/**
 *  LBGetObjectListLength
 *
 *  Creation date: 07.02.2017 22:43
 *  Copyright 2017, Windows7
 */
class LBGetObjectListLength extends SequenceAction;
 
var int listlen; 
 
event Activated()
{
    local array<SequenceObject> LinkedObjs;
    local SeqVar_ObjectList ObjListVar;
    
    GetLinkedObjects(LinkedObjs, class'SeqVar_ObjectList', false);
    
    ObjListVar=SeqVar_ObjectList(LinkedObjs[0]);
    
    listlen=ObjListVar.ObjList.Length;   
}

defaultproperties
{
    bCallHandler=false
    
    ObjName="Get Object List Length"
    ObjCategory="LevBronstein Utils"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_ObjectList',LinkDesc="Object List Value")
    VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Length",bWriteable=true,PropertyName=listlen)
}
