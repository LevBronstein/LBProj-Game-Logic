/**
 *  LBRadialMovementMechanism
 *
 *  Creation date: 04.07.2016 22:52
 *  Copyright 2016, Windows7
 */
class LBRadialMovementMechanism extends LBTransposeMechanism;

var(RadialMovement) vector CenterPoint; //A point which is used as a center for rotation
var(RadialMovement) vector LocationOffset; 
var(RadialMovement) bool bUseInitialLocation;

var(RadialMovement) rotator AngularSpeed; //Angular speed
var(RadialMovement) rotator LocalAngularSpeed; 
var(RadialMovement) rotator CurrentRotation;

var(MechanismDebug) bool bShowDebugLines;

function InitMechanism()
{
    if (bUseInitialLocation)
        LocationOffset=parent.Location-CenterPoint;
}

function PerformMovement(float dt)
{
    local vector X, Y, Z;  
    local vector l;
  
    GetAxes(CurrentRotation,X,Y,Z);
    
    l=CenterPoint+LocationOffset.X*X+LocationOffset.Y*Y+LocationOffset.Z*Z;
    
    parent.SetLocation(l);  
  
    CurrentRotation=CurrentRotation+AngularSpeed;   
}

function PerformRotation(float dt)
{   
    parent.SetRotation(parent.Rotation+LocalAngularSpeed);           
}

defaultproperties
{
    mechname="Radial_Movement_Mechanism"
}
