/**
 *  LBIterateActorArraySeq
 *
 *  Creation date: 07.02.2017 00:35
 *  Copyright 2017, Windows7
 */
class LBGetObjectArrayElementSeq extends SequenceAction;

var int index;
var object outobject;

event Activated()
{
    local int i;
    local array<SequenceObject> LinkedObjs;
    local SeqVar_ObjectList ObjListVar;
    local SeqVar_Int IntVar;
    local array<object> value;
    
    GetLinkedObjects(LinkedObjs, class'SeqVar_ObjectList', false);
    
    ObjListVar=SeqVar_ObjectList(LinkedObjs[0]);
    
    `log("index"@index@"object:"@ObjListVar.ObjList[index]);
    
    GetLinkedObjects(LinkedObjs, class'SeqVar_Int', false);
    IntVar=SeqVar_Int(LinkedObjs[0]);
    `log("real index"@IntVar.IntValue);
    
    if (index >= 0 && index < ObjListVar.ObjList.Length)
        outobject=ObjListVar.ObjList[index];
    else
        outobject=none;
}

defaultproperties
{
    bCallHandler=false
    
    ObjName="Get Array Element"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_ObjectList',LinkDesc="Object Array Value")
    VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Index",PropertyName=index) 
    VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Out Object",bWriteable=true,PropertyName=outobject) 
}
