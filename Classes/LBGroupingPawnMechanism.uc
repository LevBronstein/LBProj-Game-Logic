/**
 *  LBGroupingPawnMechanism
 *
 *  Creation date: 24.05.2016 22:06
 *  Copyright 2016, Windows7
 */
class LBGroupingPawnMechanism extends LBInteractableMechanism;

struct LBNotifyParam
{
    var() LBMechanismParam Destination;
    var() bool bOverrideTargetActor; //Override @Destination.ParentActor with target actor
    var() LBParamContainer MainValue;
    var() LBParamSourcePointer MainValueSource;
    var() bool bDefaultOnDeselect;
    var() LBParamContainer DefaultValue;
    var() LBParamSourcePointer DefaultValueSource;
};

var(GroupingMechanism) array<Actor> SelectedObjects; //List of objects, which are currentrly controlled
var(GroupingMechanism) int CurrentSelectedObject; //Current object from this list
var(GroupingMechanism) array<LBNotifyParam> NotifyParams; //Set to main values when selected, to default values - when deselected

//Передвижение указателя в границах массива @SelectedObjects
function SelectObject(int newobj)
{
    if (SelectedObjects.Length==0)
        CurrentSelectedObject=-1;
    else
        CurrentSelectedObject=Clamp(newobj, 0, SelectedObjects.Length-1); 
}

function SetNotifyParams(actor a)
{
    local int i;
    local LBMechanismParam src;
    
    for (i=0; i<NotifyParams.Length;i++)
    {
        if (NotifyParams[i].bOverrideTargetActor)
        {
            src=NotifyParams[i].Destination;
            src.ParentActor=a;
            SetTargetParamContainerStr(src, NotifyParams[i].MainValue, NotifyParams[i].MainValueSource);
        }
        else
            SetTargetParamContainerStr(NotifyParams[i].Destination, NotifyParams[i].MainValue, NotifyParams[i].MainValueSource);
    }
}
  
function DefaultNotifyParams(actor a)
{
    local int i;
    local LBMechanismParam src;
    
    for (i=0; i<NotifyParams.Length;i++)
    {
        if (NotifyParams[i].bDefaultOnDeselect)
        {
            if (NotifyParams[i].bOverrideTargetActor)
            {
                src=NotifyParams[i].Destination;
                src.ParentActor=a;
                SetTargetParamContainerStr(src, NotifyParams[i].DefaultValue, NotifyParams[i].DefaultValueSource);
            }
            else
                SetTargetParamContainerStr(NotifyParams[i].Destination, NotifyParams[i].DefaultValue, NotifyParams[i].DefaultValueSource);
        }
    }
}
  
//Добавление актора в SelectedObjects
//Лбые ли объекты можно добавлять?
function AddSelectedObject(actor a)
{
    if (LBActor(a)==none && LBPawn(a)==none)
        return;
 
    if (SelectedObjects.Find(a)!=-1)
        return;
    
    //if (bNotifySelected)
    //    SetTargetParamBool(a, SelectedActorParam.MechanismName, SelectedActorParam.ParamName, true);
    
    SetNotifyParams(a);
    
    SelectedObjects.AddItem(a);
    SelectObject(CurrentSelectedObject);
    
    if (bLogFullInfo)
        LogSelectedObjectList();
}

function RemoveSelectedObjectByID(int id)
{    
    if (id<0 || id>=SelectedObjects.Length)
        return;
    
    //if (bNotifySelected)
    //    SetTargetParamBool(SelectedObjects[id], SelectedActorParam.MechanismName, SelectedActorParam.ParamName, false);
    
    DefaultNotifyParams(SelectedObjects[id]);
    
    SelectedObjects.Remove(id, 1);
    SelectObject(CurrentSelectedObject); //т.к. элементы могли сместиться
}

function RemoveSelectedObject(actor a)
{    
    if (LBActor(a)==none && LBPawn(a)==none)
        return;
        
    if (SelectedObjects.Find(a)==-1)
        return;
    
    //    if (bNotifySelected)    
    //SetTargetParamBool(a, SelectedActorParam.MechanismName, SelectedActorParam.ParamName, false);
        
    DefaultNotifyParams(a);
    
    SelectedObjects.RemoveItem(a);
    SelectObject(CurrentSelectedObject); //т.к. элементы могли сместиться
    
    if (bLogFullInfo)
        LogSelectedObjectList();
}
    
function RemoveSelectedObjectsAfter(actor a)
{
    local int pos;
    local int i;
    local actor rem;
    local int remcount;
    
    pos=SelectedObjects.Find(a);
    //`log("pos="@pos@"remove"@(SelectedObjects.Length-pos));
    
    if (pos==-1)
        return;
    
    remcount=0;
    for (i=pos; i<SelectedObjects.Length; i++)
    { 
        rem=SelectedObjects[i];
        //`log("Removing"@i@rem);
        
        DefaultNotifyParams(rem);
        remcount=remcount+1;
    }
    
    SelectedObjects.Remove(pos,remcount); 
    
    SelectObject(pos-1);
    
    if (bLogFullInfo)
        LogSelectedObjectList();
}

function SetParam(name param, object value, optional int priority=0)
{
    if (param=='AddSelectedObject')
        AddSelectedObject(actor(value));
    else if (param=='RemoveSelectedObject')
        RemoveSelectedObject(actor(value));
    else if (param=='RemoveSelectedObjectsAndAfter')
        RemoveSelectedObjectsAfter(actor(value));
} 
        
function array<object> GetParams(name param)
{
    local array<object> o;
    local int i;
    
    if (param=='SelectedObjects')
        return SelectedObjects;
    else if (param=='SelectedObjectsAndSelf')
    {
        o.AddItem(parent);
        for (i=0; i<SelectedObjects.Length; i++)
        {
            o.AddItem(SelectedObjects[i]);
        }
        return o;
    }
}   

function object GetParam(name param)
{
    if (param=='LastSelectedObject')
    {
        if (SelectedObjects.Length==0)
            return none;
        else 
            return SelectedObjects[SelectedObjects.Length-1];
    }   
    else if (param=='LastSelectedObjectOrSlef')
    {
        if (SelectedObjects.Length==0)
            return parent;
        else 
            return SelectedObjects[SelectedObjects.Length-1];
    }
} 

function LogSelectedObjectList()
{
    local int i;
    
    `log("XSCS:: Total objects:"@SelectedObjects.Length);
    
    for (i=0;i<SelectedObjects.Length;i++)
    {
        if (CurrentSelectedObject==i)
            `log(">"$(i+1)$":"@SelectedObjects[i]$"<");
        else    
            `log((i+1)$":"@SelectedObjects[i]);
    }
}

defaultproperties
{
    mechname="Grouping_Mechanism"
    bLogFullInfo=false
    
    MechanismParams(0)=(ParamName="AddSelectedObject", ParamInfo="Object. Write. Add corresponding object to the list (group).")
    MechanismParams(1)=(ParamName="RemoveSelectedObject", ParamInfo="Object. Write. Remove corresponding object from the list (group).")
    MechanismParams(2)=(ParamName="RemoveSelectedObjectsAndAfter", ParamInfo="Object. Write. Remove corresponding object from the list (group) and all objects after its position.")
    MechanismParams(3)=(ParamName="SelectedObjects", ParamInfo="Object array. Read. Get all objects, that are currently stored in the list (group).")
    MechanismParams(4)=(ParamName="SelectedObjectsAndSelf", ParamInfo="Object array. Read. Get all objects that are currently stored in the list (group), including parent (first).")
    MechanismParams(5)=(ParamName="LastSelectedObject", ParamInfo="Object. Read. Get the last object in the list (group).") 
    MechanismParams(6)=(ParamName="LastSelectedObjectOrSlef", ParamInfo="Object. Read. Get the last object in the list (group), or get self, if the list is empty.")
}
