/**
 *  LBActorMovemenBehaviorController
 *
 *  Creation date: 03.11.2017 00:55
 *  Copyright 2017, Win10
 */
class LBActorMovementBehaviorController extends LBActorBehaviorController;

var vector TargetLocation;
var rotator TargetRotation;
var int ForwardMovement; //1-forward, 0-stop, -1 - backawards

function vector GetTargetLocation();

function rotator GetTargetRotation();

function float GetForwardSpeed();

function int GetForwardMovement();

function PerfromTick(float dt)
{   
    TargetLocation=GetTargetLocation();
    TargetRotation=GetTargetRotation();
    ForwardMovement=GetForwardMovement();
}

defaultproperties
{
    mechname="Actor_Movement_Behavior_Controller" 
}
