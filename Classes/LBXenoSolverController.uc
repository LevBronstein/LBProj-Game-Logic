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

struct LBInteraction
{
    var() string InteractionName;
    var() name TargetMechanism;
    var() name TargetParam;
    var() float Value; //A value to set
    var float DefaultValue; //A value to reset
};

var(XenoSolverInteractionSystem) name ManageableControllerMechName;

var(XenoSolverAnimationSystem) name BlendByActionNode; //def: blendbyaction

var(XenoSolverSystem) name TargetingMechanism;
var(XenoSolverSystem) name GroupingMechanism;

var(XenoSolverGameplay) array<LBAction> ActionList;
var(XenoSolverGameplay) int SolverCurrentAction; //0- no action
var(XenoSolverGameplay) array<LBInteraction> InteractionList;
var(XenoSolverGameplay) int SolverInteraction;

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

function ChangeInteraction(bool newinteraction)
{
    local LBInteraction v;
    
    if (bInteracting==newinteraction)
        return;
    
    v=InteractionList[SolverInteraction];
    
    if (newinteraction==true)
    {
        if (targetactor!=none)
        {
            bInteracting=true;
            SetTargetParamBool(targetactor, ManageableControllerMechName, 'bInteracting', true);
            SetTargetParamFloat(targetactor, v.TargetMechanism, v.TargetParam, v.Value); 
            LogInfo(v.InteractionName$"->"$targetactor$"."$v.TargetMechanism$"."$v.TargetParam$"<-"$v.Value);
        }
    }
    else
    {
        bInteracting=false;
        if (targetactor!=none)
        {
            SetTargetParamFloat(targetactor, v.TargetMechanism, v.TargetParam, v.DefaultValue);
            SetTargetParamBool(targetactor, ManageableControllerMechName, 'bInteracting', false); 
            LogInfo(v.InteractionName$"->"$targetactor$"."$v.TargetMechanism$"."$v.TargetParam$"<-"$v.DefaultValue@"(default)");         
        }
    }
}

function ChangeInteractionType(int newinteraction)
{
    if (newinteraction==SolverInteraction)
        return;
        
    if (newinteraction<0 || newinteraction>=InteractionList.Length)
        return;
    
    LogInfo("changed interaction from"@SolverInteraction@"to"@newinteraction);
    
    ChangeInteraction(false); //сбрасываем предыдущее взаимодействие
    SolverInteraction=newinteraction; //устанавливаем новое
    if (bInteracting)  
        ChangeInteraction(true); //подтверждаем новое взаимодействие
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
    
    //LogInfo(parent$"."$TargetingMechanism$".TargetedObject =" @o);
    //LogInfo(parent$"."$GroupingMechanism$".AddSelectedObject <-" @ a);
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
    if (LBPawn(parent)!=none)
    {
        
    }
    else
    {
        LogError("proc: GetParameters(), parent is not an LBPawn or none:" @parent);
    }
}

function SetParamInt(name param, int value, optional int priority=0)
{
    if (param=='SolverCurrentAction')
        SetNewAction(value);
    else if (param=='SolverInteraction')
        ChangeInteractionType(value);    
} 

function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='bInteracting')
        ChangeInteraction(value);
    if (param=='GroupTargetedObject')
        GroupTargetedObject(value);
}

   
defaultproperties
{
    
    BlendByActionNode="blendbyaction"
    ManageableControllerMechName="Managed_Object_Controller"
    
    TargetingMechanism="XS_Targeting"
    GroupingMechanism="XS_Grouping"
    
    SolverCurrentAction=0
    SolverPrevAction=0
    SolverInteraction=0
    bInteracting=false
    
    ActionList.Add((ActionName="No Action"))
    ActionList.Add((ActionName="Manipulation"))
    ActionList.Add((ActionName="Looking Around"))
    
}
