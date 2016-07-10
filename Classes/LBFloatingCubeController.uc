/**
 *  LBFloatingCubeController
 *
 *  Creation date: 20.06.2016 00:49
 *  Copyright 2016, Windows7
 */
class LBFloatingCubeController extends LBActorInteractableController;

enum FloatingCubeState
{
    No_Movement,
    Move_To_Point,
    Move_Follow_Actor,
    Move_In_Trajectory,
};


var(System) name TargetedMovementMechanism;
var(System) name RadialMovementMechanism;

var() vector TargetLocation;
var() actor OtherActor;

var(ParamSource) LBParamSourcePointer TargetLocationSelfSrc; //ссылка на TargetLocation в parent
var(ParamSource) LBParamSourcePointer OtherActorSrc; //ссылка на OtherActor
var(ParamSource) LBParamSourcePointer TargetLocationOtherActorSrc; //ссылка на TargetLocation в OtherActor
var(ParamSource) LBParamSourcePointer ActorStateSrc;

var(ParamSource) LBParamSourcePointer ForwardSpeedSrc;
var() float ForwardSpeed;

var FloatingCubeState fcstate;

var bool benabletargmove;
var bool benableradmove;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;   
        
    ChangeActorState(0);
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;   
    
    PerformTick(deltatime);  
    //`log(fcstate @ targetlocation @ benabletargmove @ benableradmove);
} 
  
function PerformTick(float deltatime)
{
    //CheckActorState();
}
     
function GetParameters()
{
    if (ForwardSpeedSrc.bUseSource)
    {
        ForwardSpeed=GetTargetParamFloat(ForwardSpeedSrc.SourceActor, ForwardSpeedSrc.SourceMechanismName, ForwardSpeedSrc.SourceParamName);
    }
    
    if (ActorStateSrc.bUseSource)
    {
        ChangeActorState(GetTargetParamInt(ActorStateSrc.SourceActor, ActorStateSrc.SourceMechanismName, ActorStateSrc.SourceParamName));   
    }
}

//как будет меняться состояние при достижении TargetLocation? 
function ChangeActorState(int value)
{
    if (value==0)
        fcstate=No_Movement;
    else if (value==1)
        fcstate=Move_To_Point;
    else if (value==2)
        fcstate=Move_Follow_Actor;
    else if (value==3)
        fcstate=Move_In_Trajectory;
        
    CheckActorState();
}
    
function CheckActorState()
{
    if (fcstate==No_Movement)
    {
        SetTargetParamBool(parent, TargetedMovementMechanism, 'bEnabled', false);
        SetTargetParamBool(parent, RadialMovementMechanism, 'bEnabled', false);
    }
    if (fcstate==Move_To_Point)
    {
        SetTargetParamBool(parent, TargetedMovementMechanism, 'bEnabled', true);
        SetTargetParamBool(parent, RadialMovementMechanism, 'bEnabled', false);
    }
    if (fcstate==Move_Follow_Actor)
    {
        SetTargetParamBool(parent, TargetedMovementMechanism, 'bEnabled', true);
        SetTargetParamBool(parent, RadialMovementMechanism, 'bEnabled', false);
    }
    if (fcstate==Move_In_Trajectory)
    {
        SetTargetParamBool(parent, TargetedMovementMechanism, 'bEnabled', false);
        SetTargetParamBool(parent, RadialMovementMechanism, 'bEnabled', true);
    }
}

function SetParamInt(name param, int value, optional int priority=0)
{
    if (param=='ActorState')
        ChangeActorState(value);
}   

function SetParam(name param, object value, optional int priority=0)
{
    if (param=='OtherActor')
        OtherActor=Actor(value);
}   
    
function SetParamVector(name param, vector value, optional int priority=0)
{
    if (param=='TargetLocation')
        TargetLocation=value;
}     
  
function vector GetParamVector(name param)
{
    if (param=='TargetLocation')
        return TargetLocation;
}  
    
function bool GetParamBool(name param)
{
    if (param=='bEnableTargetedMovement')
        return benabletargmove;
    else if (param=='bEnableRadialMovement')
        return benableradmove;
}

defaultproperties
{
    mechname="Floating_Cube_Controller"
    
    MechanismParams.Empty
    
    MechanismParams(0)=(ParamName="OtherActor", ParamInfo="Object. Write. Set this to a certain object to override targetlocation source object.")
    MechanismParams(1)=(ParamName="bEnableTargetedMovement", ParamInfo="Boolean. Read.")
    MechanismParams(2)=(ParamName="bEnableRadialMovement", ParamInfo="Boolean. Read.")
    MechanismParams(3)=(ParamName="ActorState", ParamInfo="Boolean. Read, Write. Sets or gets @fcstate (FloatingCubeState) enum.")
}
