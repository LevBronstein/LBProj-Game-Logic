/**
 *  LBXenoSolverController
 *
 *  Creation date: 15.05.2016 00:47
 *  Copyright 2016, Windows7
 */
class LBXenoSolverController extends LBInteractableMechanism;

struct LBAction
{
    var() string ActionName;
    //var name() AnimSecName; //in future
};
 
var(XenoSolverAnimationSystem) name BlendByActionNode; //def: blendbyaction

var(XenoSolverSystem) name TargetingMechanism;
var(XenoSolverSystem) name GroupingMechanism;

var(XenoSolverGameplay) array<LBAction> ActionList;
var(XenoSolverGameplay) int SolverCurrentAction; //0- no action

var int ActivateInteractionId;
var int DeactivateInteractionId;

var int SolverCurInteraction;

var LBBlendByAction blendbyaction;
var LBActor targetactor;

var int SolverPrevAction;

var bool bInteracting; //Set true if at this moment the solver is interacting with the target (targetactor)
var bool bTracking; //Set true if at this moment the solver is tracking controlled object. When tracking we shouldn't use input for rotation.

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
    SetNewAction(SolverCurrentAction);
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
    
    PerformTcik();
}   

//основная процедура
function PerformTcik()
{
    UpdateCurrentAction();
    
    if (SolverCurrentAction==0)
    {
        PerformMovement();
        PerformHeadRotation();
        //PerformTargeting();
    }
    else if (SolverCurrentAction==1)
    {
        PerformHeadRotation();
        //PerformTargeting();
        //PefrormHandling();
    }
    else if (SolverCurrentAction==2)
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
    if (bInteracting==true)
    {
        SolverPrevAction=SolverCurrentAction;
        SetNewAction(1);
    }
    else
    {
        SetNewAction(SolverPrevAction);
    }
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
        SetTargetParam(parent, GroupingMechanism, 'RemoveObject', a);    
}

function array<object> GetSelectedObjects()
{
    local array<object> os;
    
    os=GetTargetParams(parent, GroupingMechanism, 'SelectedObjects');
    
    return os;
}    

function ActivateInteraction(int value)
{
    ActivateInteractionId=value;
    DeactivateInteractionId=-1;
}

function DeactivateInteraction(int value)
{
    DeactivateInteractionId=value;
    ActivateInteractionId=-1;
}
    
function SetNewAction(int act)
{
    if (act<0 || act>ActionList.length)
        return;
        
    if (act==0)
    {
       
    }
    else if (act==1)
    {
    }
    
    blendbyaction.UpdateCurrentAction(act);
    //`log(act);
}
    
function GetParameters()
{
  
}

function SetParamInt(name param, int value, optional int priority=0)
{
    if (param=='SolverCurrentAction')
        SetNewAction(value);
    //else if (param=='SolverInteraction')
    //    ChangeInteractionType(value); 
    else if (param=='ActivatedInteractionID')
        ActivateInteraction(value);  
    else if (param=='DeactivatedInteractionID')
        DeactivateInteraction(value);   
} 
    
function int GetParamInt(name param)
{
    if (param=='SolverCurInteraction')
        return SolverCurInteraction;
    if (param=='ActivatedInteractionID')
        return ActivateInteractionId; 
    if (param=='DeactivatedInteractionID')
        return DeactivateInteractionId;          
}

function array<object> GetParams(name param)
{
    if (param=='SelectedObjects')
        return GetSelectedObjects();         
}
    
function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='GroupTargetedObject')
        GroupTargetedObject(value);
    //if (param=='bInteracting')
    //    ChangeInteraction(value);
}

   
defaultproperties
{
    
    BlendByActionNode="blendbyaction"
    
    TargetingMechanism="XS_Targeting"
    GroupingMechanism="XS_Grouping"
    
    SolverCurrentAction=0
    SolverPrevAction=0
    SolverCurInteraction=-1
    bInteracting=false
    
    ActivateInteractionId=-1
    DeactivateInteractionId=-1
    
    ActionList.Add((ActionName="No Action"))
    ActionList.Add((ActionName="Manipulation"))
    ActionList.Add((ActionName="Looking Around"))
    
    MechanismParams.Empty
    
    MechanismParams(0)=(ParamName="SolverCurInteraction", ParamInfo="Integer. Read, Write.")
    MechanismParams(1)=(ParamName="SelectedObjects", ParamInfo="Array<Object>. Read.")
    MechanismParams(2)=(ParamName="ActivatedInteractionID", ParamInfo="Integer. Read, Write.")
    MechanismParams(3)=(ParamName="DeactivatedInteractionID", ParamInfo="Integer. Read, Write.")
    
}
