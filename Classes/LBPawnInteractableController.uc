/**
 *  LBPawnInteractableController
 *
 *  Creation date: 19.06.2016 23:35
 *  Copyright 2016, Windows7
 */
class LBPawnInteractableController extends LBInteractableMechanism;

struct LBAction
{
    var() string ActionName;
    //var name() AnimSecName; //in future
};
 
var(Animation) name BlendByActionNode; //def: blendbyaction

var(System) name TargetingMechanism;
var(System) name InventoryMechanism;
var(System) name GroupingMechanism;
var(System) name InteractingMechanism;

var(Gameplay) array<LBAction> ActionList;
var(Gameplay) int PawnCurrentAction; //0- no action

var LBBlendByAction blendbyaction;
var LBActor targetactor;

var int PawnPrevAction;

var int ActivateInteractionId;
var int DeactivateInteractionId;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;   
     
    blendbyaction=LBBlendByAction(LBPawn(parent).Mesh.FindAnimNode(BlendByActionNode));  
    if (blendbyaction == none)
    {
        LogError("BlendByActionNode" @ BlendByActionNode @ "not found in" @ LBPawn(parent) @ " in " @ LBPawn(parent).Mesh);
        return;
    }
    //SetNewAction(PawnCurrentAction);
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
    
    PerformTick();
}   

//основная процедура
function PerformTick()
{
    //UpdateCurrentAction();
    
    if (PawnCurrentAction==0)
    {
        //PerformMovement();
        //PerformHeadRotation();
        //PerformTargeting();
    }
    else if (PawnCurrentAction==1)
    {
        //PerformHeadRotation();
        //PerformTargeting();
        //PefrormHandling();
    }
    else if (PawnCurrentAction==2)
    {
        
    }
}

//здесь только устанавливаем ряд переменных
function PerformMovement()
{
}

function PerformHeadRotation()
{
}

function PerformTracking()
{
}

function PefrormHandling()
{
    if (targetactor!=none)
    {
    }
}
 
function UpdateCurrentAction()
{
    //костыль!
    //if (ActivateInteractionId!=-1)
    //{
    //    SetNewAction(1);
    //}
    //else
    //{
    //    SetNewAction(PawnPrevAction);
    //}
}

function GroupTargetedObject(bool bgroup)
{
    local actor a;
    local object o;
    
    o=GetTargetParam(parent, TargetingMechanism, 'TargetedObject');
    
    if (actor(o)==none)
    {
        LogError("proc: GroupTargetedObject(), targeted object is not an actor or none:"@o); 
        return;
    }
    
    a=actor(o);
    
    if (bgroup)
        SetTargetParam(parent, GroupingMechanism, 'AddSelectedObject', a);
    else
        SetTargetParam(parent, GroupingMechanism, 'RemoveSelectedObject', a);    
}

function UngroupTargetedObjectAndAfter(bool bgroup)
{
    local actor a;
    local object o;
    
    o=GetTargetParam(parent, TargetingMechanism, 'TargetedObject');
    
    if (actor(o)==none)
    {
        LogError("proc: GroupTargetedObject(), targeted object is not an actor or none:"@o); 
        return;
    }
    
    a=actor(o);
    
    SetTargetParam(parent, GroupingMechanism, 'RemoveSelectedObjectsAndAfter', a);
}
    
function array<object> GetSelectedObjects()
{
    local array<object> os;
    
    os=GetTargetParams(parent, GroupingMechanism, 'SelectedObjects');
    
    return os;
}    

function ActivateInteraction(int value)
{
    //local actor a;
    //local object o;
    //
    //ActivateInteractionId=value;
    //DeactivateInteractionId=-1;
    //
    //o=GetTargetParam(parent, InteractingMechanism, 'TargetedObject');
    //
    //if (actor(o)==none)
    //{
    //    LogError("proc: ActivateInteraction(), targeted object is not an actor or none:"@o); 
    //    return;
    //}
    //
    //a=actor(o);
    //
    //if (bgroup)
    //    SetTargetParam(parent, GroupingMechanism, 'AddSelectedObject', a);
    //else
    //    SetTargetParam(parent, GroupingMechanism, 'RemoveSelectedObject', a);  
}

function DeactivateInteraction(int value)
{
    //DeactivateInteractionId=value;
    //ActivateInteractionId=-1;
}
    
//function SetNewAction(int act)
//{
//    if (act<0 || act>ActionList.length)
//        return;
//        
//    if (act==0)
//    {
//       
//    }
//    else if (act==1)
//    {
//    }
//    
//    blendbyaction.UpdateCurrentAction(act);
//    //`log(act);
//}
    
function GetParameters()
{
  
}

function SetParamInt(name param, int value, optional int priority=0)
{
    //if (param=='PawnCurrentAction')
    //SetNewAction(value);
    //else if (param=='SolverInteraction')
    //    ChangeInteractionType(value); 
    //else if (param=='ActivatedInteractionID')
    //    ActivateInteraction(value);  
    //else if (param=='DeactivatedInteractionID')
    //    DeactivateInteraction(value); 
    //if (param=='CurInteraction')  
} 
    
function int GetParamInt(name param)
{
    //if (param=='PawnCurInteraction')
    //    return SolverCurInteraction;
    //if (param=='ActivatedInteractionID')
    //    return ActivateInteractionId; 
    //if (param=='DeactivatedInteractionID')
    //    return DeactivateInteractionId;          
}

function array<object> GetParams(name param)
{
    if (param=='GroupedObjects')
        return GetSelectedObjects();         
}
    
function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='GroupTargetedObject')
        GroupTargetedObject(value);
    else if (param=='UngroupTargetedObjectAndAfter')
        UngroupTargetedObjectAndAfter(value);
    //if (param=='bInteracting')
    //    ChangeInteraction(value);
}

   
defaultproperties
{
    mechname="Pawn_Interactable_Controller"
    
    BlendByActionNode="blendbyaction"
    
    TargetingMechanism="Targeting_Mechanism"
    InventoryMechanism="Inventory_Mechanism"
    GroupingMechanism="Grouping_Mechanism"
    
    //SolverCurrentAction=0
    //SolverPrevAction=0
    //SolverCurInteraction=-1
    //bInteracting=false
    
    ActivateInteractionId=-1
    DeactivateInteractionId=-1
    
    ActionList.Add((ActionName="No Action"))
    
    MechanismParams.Empty
    
    //MechanismParams(0)=(ParamName="PawnCurInteraction", ParamInfo="Integer. Read, Write.")
    MechanismParams(0)=(ParamName="GroupedObjects", ParamInfo="Array<Object>. Read.")
    MechanismParams(1)=(ParamName="GroupTargetedObject", ParamInfo="Boolean. Write. Set true to group @TargetedObject @TargetingMechanism, false to remove from the group.")
    MechanismParams(2)=(ParamName="UngroupTargetedObjectAndAfter", ParamInfo="Boolean. Write. Set true to remove from the group @TargetedObject and all following objects (if there are any).")
    MechanismParams(3)=(ParamName="ActivatedInteractionID", ParamInfo="Integer. Read, Write.")
    MechanismParams(4)=(ParamName="DeactivatedInteractionID", ParamInfo="Integer. Read, Write.")
    
}
