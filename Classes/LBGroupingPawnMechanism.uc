/**
 *  LBGroupingPawnMechanism
 *
 *  Creation date: 24.05.2016 22:06
 *  Copyright 2016, Windows7
 */
class LBGroupingPawnMechanism extends LBInteractableMechanism;

var(GroupingMechanism) array<Actor> SelectedObjects; //List of objects, which are currentrly controlled
var(GroupingMechanism) int CurrentSelectedObject; //Current object from this list
var(GroupingMechanism) bool bNotifySelected; //Current object from this list
var(GroupingMechanism) LBParam SelectedActorParam; //Set this value to true when selected, false - when not

//Передвижение указателя в границах массива @SelectedObjects
function SelectObject(int newobj)
{
    if (SelectedObjects.Length==0)
        CurrentSelectedObject=-1;
    else
        CurrentSelectedObject=Clamp(newobj, 0, SelectedObjects.Length-1); 
}

//Добавление актора в SelectedObjects
//Лбые ли объекты можно добавлять?
function AddSelectedObject(actor a)
{
    if (LBActor(a)==none && LBPawn(a)==none)
        return;
 
    if (SelectedObjects.Find(a)!=-1)
        return;

    SetTargetParamBool(a, SelectedActorParam.MechanismName, SelectedActorParam.ParamName, true); 
    
    SelectedObjects.AddItem(a);
    SelectObject(CurrentSelectedObject);
    
    if (bLogFullInfo)
        LogSelectedObjectList();
}

function RemoveSelectedObjectByID(int id)
{
    if (id<0 || id>=SelectedObjects.Length)
        return;
    
    SetTargetParamBool(SelectedObjects[id], SelectedActorParam.MechanismName, SelectedActorParam.ParamName, false);
        
    SelectedObjects.Remove(id, 1);
    SelectObject(CurrentSelectedObject); //т.к. элементы могли сместиться
}

function RemoveSelectedObject(actor a)
{
    if (LBActor(a)==none && LBPawn(a)==none)
        return;
        
    if (SelectedObjects.Find(a)==-1)
        return;
        
    SetTargetParamBool(a, SelectedActorParam.MechanismName, SelectedActorParam.ParamName, false);
        
    SelectedObjects.RemoveItem(a);
    SelectObject(CurrentSelectedObject); //т.к. элементы могли сместиться
    
    if (bLogFullInfo)
        LogSelectedObjectList();
}

function SetParam(name param, object value, optional int priority=0)
{
    if (param=='AddSelectedObject')
        AddSelectedObject(actor(value));
    else if (param=='RemoveObject')
        RemoveSelectedObject(actor(value));
} 
        
function array<object> GetParams(name param)
{
    if (param=='SelectedObjects')
        return SelectedObjects;
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
    bLogFullInfo=false
}
