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

var(XenoSolverTargetingSystem) name TargetRayOriginSocket; //A socket in skeletal mesh of the owner, which should be used as a start of ray traces
var(XenoSolverTargetingSystem) float MaxTargetRayLength; //The length of the target ray. Warning! Can slow down the game!
var(XenoSolverTargetingSystem) bool bDisplayTraces; //When true - the debug lines are drawn

var(XenoSolverAnimationSystem) name BlendByActionNode; //def: blendbyaction

var(XenoSolverGameplay) array<LBAction> ActionList;
var(XenoSolverGameplay) int SolverCurrentAction; //0- no action
var(XenoSolverGameplay) array<LBInteraction> InteractionList;
var(XenoSolverGameplay) int SolverInteraction;

var(XenoSolverControlSystem) array<Actor> SelectedObjects; //List of objects, which are currentrly controlled
var(XenoSolverControlSystem) int CurrentSelectedObject; //Current object from this list

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

function PerformTargeting()
{
    local LBPawn p;
    local Actor hit;
    local vector l, d; 
    local rotator r;
    local vector oh, on;

    p=LBPawn(parent);
    if (parent==none)
    {
        LogError("proc: PerformTargeting(), parent is not an LBPawn or none:" @parent);   
        return;    
    }
    
    if (p.Mesh.GetSocketWorldLocationAndRotation(TargetRayOriginSocket, l, r, 0)==false)
        LogError("proc: PerformTargeting(), the mesh doesn't have a ray origin socket!");    
    d=vect(0,0,1)>>r;
    d=Normal(d);
    
    hit=TraceTargetRay(l, l+d*MaxTargetRayLength, oh, on, bDisplayTraces);
    
    if (LBActor(hit)!=none)
    {
        if (LBActor(hit)!=targetactor)
            ChangeTargetActor(LBActor(hit));
    }
    else
    {   
        if (LBActor(hit)!=targetactor)
            ChangeTargetActor(none);
    }
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
 
function ChangeTargetActor(LBActor a)
{
    //`log("Changing target from"@targetactor@"to"@a);
    ChangeInteraction(false);
    if (targetactor!=none)
        SetTargetParamBool(targetactor, ManageableControllerMechName, 'bTargeted', false);
    targetactor=a;
    if (targetactor!=none)
        SetTargetParamBool(targetactor, ManageableControllerMechName, 'bTargeted', true);
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
        
    SetTargetParamBool(a, ManageableControllerMechName, 'bSelected', true); 
    
    SelectedObjects.AddItem(a);
    SelectObject(CurrentSelectedObject);
}

function RemoveSelectedObjectByID(int id)
{
    if (id<0 || id>=SelectedObjects.Length)
        return;
    
    SetTargetParamBool(SelectedObjects[id], ManageableControllerMechName, 'bSelected', false);
        
    SelectedObjects.Remove(id, 1);
    SelectObject(CurrentSelectedObject); //т.к. элементы могли сместиться
}

function RemoveSelectedObject(actor a)
{
    
    if (LBActor(a)==none && LBPawn(a)==none)
        return;
        
    if (SelectedObjects.Find(a)==-1)
        return;
        
    SetTargetParamBool(a, ManageableControllerMechName, 'bSelected', false);
        
    SelectedObjects.RemoveItem(a);
    SelectObject(CurrentSelectedObject); //т.к. элементы могли сместиться
}

//Добавление объекта, на который смотрит персонаж, в список выделенных 
//Если true, пытаемся добавить, если false - убираем
function SelectTargetedObject(bool b)
{
    if (b==true)
        AddSelectedObject(targetactor);
    else
        RemoveSelectedObject(targetactor);
        
    LogXenoSolverControlSystem();   
}
 
function actor TraceTargetRay(vector origin, vector target, out vector hitloc, out vector hitnormal, optional bool bDrawTrace=false)
{
    local LBPawn p;
    local Actor hit;
    
    p=LBPawn(parent);
    if (parent==none)
    {
        LogError("proc: TraceTargetRay(), parent is not an LBPawn or none:" @parent);   
        return none;    
    }
    
    hit=p.Trace(hitloc, hitnormal, target, origin);
    
    if (bDrawTrace==false)
        return hit;
    
    if (hit!=none)
        p.DrawDebugLine(origin, hitloc, 255, 0, 0);
    else
        p.DrawDebugLine(origin, target, 0, 0, 255);
        
    return hit;
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
    if (param=='bTargetedObjectSelected')
        SelectTargetedObject(value);
}

    
function LogXenoSolverControlSystem()
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
    
    BlendByActionNode="blendbyaction"
    TargetRayOriginSocket="TargetRayOrigin"
    ManageableControllerMechName="Managed_Object_Controller"
    bDisplayTraces=false
    MaxTargetRayLength=2048
    
    SolverCurrentAction=0
    SolverPrevAction=0
    SolverInteraction=0
    bInteracting=false
    
    CurrentSelectedObject=-1
    
    ActionList.Add((ActionName="No Action"))
    ActionList.Add((ActionName="Manipulation"))
    ActionList.Add((ActionName="Looking Around"))
    
}
