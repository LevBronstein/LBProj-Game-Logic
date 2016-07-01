/**
 *  LBTargetedMovementMechanism
 *
 *  Creation date: 02.06.2016 21:59
 *  Copyright 2016, Windows7
 */
class LBTargetedMovementMechanism extends  LBInteractableMechanism;

var(TargetedMovement) vector TargetLocation;
var(TargetedMovement) float ForwardSpeed;
var(TargetedMovement) float kForwardSpeed;
var(TargetedMovement) float TurnSpeed;

var(MovementClamps) float ForwardSpeedMax;
var(MovementClamps) float ForwardSpeedMin;
var(MovementClamps) float DistanceToStop; //A value to fix
var(MovementClamps) bool bEnableMovement; //set to true to enable movement
var(MovementClamps) bool bEnableRotation; //set to true to enable rotation

var(Animation) bool bAnimateMovement; //Should we animate movement via animtree
var(Animation) name BlendByMoveSpdNode; //Which node to use for animating movement 
var(Animation) bool bAnimateRotation; //Should we animate rotation via animtree
var(Animation) name BlendByAngSpdNode; //Which node to use for animating rotation 

var(ParamSource) LBParamSourcePointer TargetLocationSrc;
var(ParamSource) LBParamSourcePointer bEnableMovementSrc;
var(ParamSource) LBParamSourcePointer bEnableRotationSrc;

var(MechanismDebug) bool bShowDebugLines;

//var TPBlendByMovementState blendbymovespd; //Animnode blending by move in the animtree
var LBBlendByAngSpeed blendbyangspd; //Animnode blending by angspeed in the animtree

var bool bIsPawnMechanism;
var float dRot;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;
    
    if (LBPawn(parent)!=none)
        bIsPawnMechanism=true;
    else
        bIsPawnMechanism=false;
    
    if (bIsPawnMechanism)
    {
        //blendbymovespd=TPBlendByMovementState(parent.Mesh.FindAnimNode(BlendByMoveSpd));
        blendbyangspd=LBBlendByAngSpeed(LBPawn(parent).Mesh.FindAnimNode(BlendByAngSpdNode));
    }
  
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if(benabled==false)
        return;
    
    if (bIsPawnMechanism)
    {   
        PerformPawnMovement(deltatime);
        UpdateAnimNodes();
    }
    else
    {
        PerformActorMovement(deltatime);
    }
}

function PerformPawnMovement(float dt)
{
    local vector v;
    local rotator r;
      
    v=vect(0,0,0); 

    v=TargetLocation-parent.location;
    v.z=0;
    
    r=RInterpTo(parent.rotation, rotator(normal(v)), dt, TurnSpeed*DegToUnrRot, true); //~9000!
    
    dRot=(r.Yaw-parent.Rotation.Yaw)*UnrRotToDeg;
 
    r.Pitch=0;
    r.Roll=0;
    
    if (bEnableRotation)
        parent.SetRotation(r);
    
    if (vsize(v)>=DistanceToStop)
    {
        v=normal(v);
        
        if (bEnableMovement)
            parent.Velocity=normal(v)*ForwardSpeed*kForwardSpeed; 
    }
    
    if (bShowDebugLines)
    {
        parent.DrawDebugSphere(TargetLocation, 64, 16, 255, 0, 0);
        parent.DrawDebugLine(parent.location+vect(0,0,32), TargetLocation, 255, 0, 0);
    }
}

function PerformActorMovement(float dt)
{
    local vector v;
    //local rotator r;
      
    v=vect(0,0,0); 

    v=TargetLocation-parent.location;
    
    if (vsize(v)>=DistanceToStop)
    {
        v=normal(v);
        
        if (bEnableMovement)
            parent.MoveSmooth(normal(v)*ForwardSpeed*kForwardSpeed);
        //paertn.Velocity=normal(v)*ForwardSpeed*kForwardSpeed; 
    }  
    
    if (bShowDebugLines)
    {
        parent.DrawDebugSphere(TargetLocation, 64, 16, 255, 0, 0);
        parent.DrawDebugLine(parent.location+vect(0,0,32), TargetLocation, 255, 0, 0);
    }
}

function UpdateAnimNodes()
{
    //if (blendbymovespd != none)
    //blendbymovespd.UpdateCurrentMoveState(PawnMovementState);
    
    if (blendbyangspd != none)    
    {
        blendbyangspd.UpdateAngSpeed(dRot);
    }
}

function GetParameters()
{
    if (TargetLocationSrc.bUseSource)
    {
        TargetLocation=GetTargetParamVector(TargetLocationSrc.SourceActor, TargetLocationSrc.SourceMechanismName, TargetLocationSrc.SourceParamName);
    }
    
    if (bEnableMovementSrc.bUseSource)
    {
        bEnableMovement=GetTargetParamBool(bEnableMovementSrc.SourceActor, bEnableMovementSrc.SourceMechanismName, bEnableMovementSrc.SourceParamName);
    }
    
    if (bEnableRotationSrc.bUseSource)
    {
        bEnableRotation=GetTargetParamBool(bEnableRotationSrc.SourceActor, bEnableRotationSrc.SourceMechanismName, bEnableRotationSrc.SourceParamName);
    }
}

function vector GetParamVector(name param)
{
    if (param=='TargetLocation')
        return TargetLocation;
}

function SetParamVector(name param, vector value, optional int priority=0)
{
    if (param=='TargetLocation')
        TargetLocation=value;
}
    
function float GetParamFloat(name param)
{
   if (param=='ForwardSpeed')
    return ForwardSpeed; 
}

function SetParamFloat(name param, float value, optional int priority=0) 
{
    if (param=='ForwardSpeed')
        ForwardSpeed=value;
}
    
function SetParamBool(name param, bool value, optional int priority=0) 
{
    if (param=='bEnableMovement')
        bEnableMovement=value;
    else if (param=='bEnableRotation')
        bEnableRotation=value;
}
    
defaultproperties
{
    ForwardSpeed=0
    kForwardSpeed=100
    TurnSpeed=250
    
    ForwardSpeedMax=3
    ForwardSpeedMin=0.7
    DistanceToStop=5.0
    
    bEnableMovement=true
    bEnableRotation=true
    
    dRot=0
    
    MechanismParams(0)=(ParamName="TargetLocation", ParamInfo="Vector. Read, Write. A destination of movement.")
    MechanismParams(1)=(ParamName="ForwardSpeed", ParamInfo="Float. Read, Write. Forward speed of the parent actor.")
}
