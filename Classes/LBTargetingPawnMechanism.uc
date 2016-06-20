/**
 *  LBTargetingPawnMechanism
 *
 *  Creation date: 23.05.2016 22:18
 *  Copyright 2016, Windows7
 */
class LBTargetingPawnMechanism extends LBInteractableMechanism;

var(TargetingPawnMechanism) name TargetRayOriginSocket; //A socket in skeletal mesh of the owner, which should be used as a start of ray traces
var(TargetingPawnMechanism) float MaxTargetRayLength; //The length of the target ray. Warning! Can slow down the game!
var(TargetingPawnMechanism) bool bNotifyTarget;
var(TargetingPawnMechanism) LBParam TargetActorParam; //Set this value to true when targeted, false - when not
var(MechanismDebug) bool bShowDebugLines; //Display debug in game

var Actor targetactor;

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
    
    PerformTargeting();
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
    
    hit=TraceTargetRay(l, l+d*MaxTargetRayLength, oh, on, bShowDebugLines);
    
    if (hit!=none)
    {
        if (hit!=targetactor)
            ChangeTargetActor(hit);
    }
    else
    {   
        if (hit!=targetactor)
            ChangeTargetActor(none);
    }
}

function ChangeTargetActor(Actor a)
{
    LogInfo("changing target from"@targetactor@"to"@a);
    if (targetactor!=none)
    {
        if (bNotifyTarget)
            SetTargetParamBool(targetactor, TargetActorParam.MechanismName, TargetActorParam.ParamName, false);
    }
    targetactor=a;
    if (targetactor!=none)
    {
        if (bNotifyTarget)
            SetTargetParamBool(targetactor, TargetActorParam.MechanismName, TargetActorParam.ParamName, true);
    }
}    
    
function actor TraceTargetRay(vector origin, vector target, out vector hitloc, out vector hitnormal, optional bool bDrawTrace=false)
{
    local LBPawn p;
    local Actor hit;
    local vector v;
    local box b;
    
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
        
    if (hit!=none)
    {
        hit.GetComponentsBoundingBox(b);
        v=b.max-b.min;
        hit.DrawDebugBox(hit.location, v/2, 255, 0, 0);
    }
        
    return hit;
}    
 
function object GetParam(name param)
{
    if (param=='TargetedObject')
    {
        return targetactor;
    }
    else return none;
} 

   
defaultproperties
{
    mechname="Targeting_Mechanism"
    TargetRayOriginSocket="TargetRayOrigin"
    
    bShowDebugLines=false
    MaxTargetRayLength=2048
    
    MechanismParams(0)=(ParamName="TargetedObject", ParamInfo="Object. Read. Get current visible (ray-traced) object.")
}
