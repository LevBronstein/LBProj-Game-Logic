/**
 *  LBXenoSolverController
 *
 *  Creation date: 15.05.2016 00:47
 *  Copyright 2016, Windows7
 */
class LBXenoSolverController extends LBMechanism;

struct LBAction
{
    var() string ActionName;
    //var name() AnimSecName; //in future
};

var(ParamSource) name ParameterSource; //A mechanism, from which we'll get all params via GetParamFloat
var(ParamSource) bool bUseParamSource; //Defines whether we should get params (from ParameterSource)

var(XenoSolverTargetingSystem) name TargetRayOriginSocket; //A socket in skeletal mesh of the owner, which should be used as a start of ray traces
var(XenoSolverTargetingSystem) float MaxTargetRayLength; //The length of the target ray. Warning! Can slow down the game!
var(XenoSolverTargetingSystem) bool bDisplayTraces; //When true - the debug lines are drawn
var(XenoSolverTargetingSystem) name ManageableControllerMechName;
var(XenoSolverAnimationSystem) name BlendByActionNode; //def: blendbyaction

var(XenoSolverGameplay) array<LBAction> ActionList;
var(XenoSolverGameplay) int SolverCurrentAction; //0- no action
var(XenoSolverGameplay) bool bInteracting; //Set true if at this moment the solver is interacting with the target (targetactor)

var LBBlendByAction blendbyaction;
var LBActor targetactor;


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
    
    if (bUseParamSource)
        GetParameters();  
    
    PerformTcik();  
}   

function PerformTcik()
{
    if (SolverCurrentAction==0)
    {
        PerformMovement();
        PerformHeadRotation();
        PerformTargeting();
    }
    else if (SolverCurrentAction==1)
    {
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

function PerformTargeting()
{
    local LBPawn p;
    local Actor hit;
    local vector l, d; 
    local rotator r;
    local vector oh, on;
    local box b;

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
  
function ChangeTargetActor(LBActor a)
{
    //`log("Changing target from"@targetactor@"to"@a);
    if (targetactor!=none)
        targetactor.SetParamBool(ManageableControllerMechName, 'bTargeted', false);
    targetactor=a;
    if (targetactor!=none)
        targetactor.SetParamBool(ManageableControllerMechName, 'bTargeted', true);
}

function ChangeInteraction(bool newinteraction)
{
    if (newinteraction==true)
    {
        if (targetactor!=none)
        {
            bInteracting=true;
            targetactor.SetParamBool(ManageableControllerMechName, 'bInteracting', true);
        }
    }
    else
    {
        bInteracting=false;
        if (targetactor!=none)
        {
            targetactor.SetParamBool(ManageableControllerMechName, 'bInteracting', false);
        }
    }
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
    `log(act);
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

function SetParamInt(name param, int value)
{
    if (param=='SolverCurrentAction')
        SetNewAction(value);
} 

function SetParamBool(name param, bool value)
{
    if (param=='bInteracting')
        ChangeInteraction(value);
}
    
defaultproperties
{
    
    BlendByActionNode="blendbyaction"
    TargetRayOriginSocket="TargetRayOrigin"
    ManageableControllerMechName="Managed_Controller"
    bDisplayTraces=false
    MaxTargetRayLength=2048
    
    SolverCurrentAction=0
    bInteracting=false
    
    ActionList.Add((ActionName="No Action"))
    ActionList.Add((ActionName="Manipulation"))
    ActionList.Add((ActionName="Looking Around"))
    
}
