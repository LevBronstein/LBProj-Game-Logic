/**
 *  LBDirectedMovementMechanism
 *
 *  Creation date: 09.03.2017 00:48
 *  Copyright 2017, Windows7
 */
class LBDirectedMovementMechanism extends LBTransposeMechanism;

var(DirectedMovement) float ForwardSpeed;
var(DirectedMovement) float kForwardSpeed;
var(DirectedMovement) rotator MoveDirection;

function PerformMovement(float dt)
{   
    if (LBActor(parent)!=none)
        parent.SetLocation(parent.location+ForwardSpeed*kForwardSpeed*Vector(MoveDirection));
        
    if (LBPawn(parent)!=none)
        parent.Velocity=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);    
}

function PerformRotation(float dt)
{
    parent.SetRotation(MoveDirection);
}

function SetParamFloat(name param, float value, optional int priority=0)
{
    super.SetParamFloat(param, value, priority);
    
    if (param=='ForwardSpeed' || param== 'FwdSpeed')
        ForwardSpeed=value; 
    else if (param=='MoveDirection-Yaw' || param== 'MoveDir-Yaw')
        MoveDirection.Yaw=value*DegToUnrRot;
    else if (param=='MoveDirection-Pitch' || param== 'MoveDir-Pitch')
        MoveDirection.Pitch=value*DegToUnrRot;  
    else if (param=='MoveDirection-Roll' || param== 'MoveDir-Roll')
        MoveDirection.Roll=value*DegToUnrRot;    
}

function SetParamRotator(name param, rotator value, optional int priority=0)
{
    super.SetParamRotator(param, value, priority);
    
    if (param=='MoveDirection' || param== 'MovementDirection')
        MoveDirection=value;    
}

function rotator GetParamRotator(name param)
{
    local rotator r;
    
    r=super.GetParamRotator(param);
    
    if (param=='MoveDirection' || param== 'MovementDirection')
        return MoveDirection;
    else 
        return r;    
}

function float GetParamFloat(name param)
{
    local float f;
    
    f=super.GetParamFloat(param);
    
    if (param=='ForwardSpeed' || param== 'FwdSpeed')
        return ForwardSpeed;
    else if (param=='MoveDirection-Yaw' || param== 'MoveDir-Yaw')
        return MoveDirection.Yaw*UnrRotToDeg;
    else if (param=='MoveDirection-Pitch' || param== 'MoveDir-Pitch')
        return MoveDirection.Pitch*UnrRotToDeg;  
    else if (param=='MoveDirection-Roll' || param== 'MoveDir-Roll')
       return MoveDirection.Roll*UnrRotToDeg;   
    else 
        return f;    
}  
    
defaultproperties
{
    mechname="Directed_Movement_Mechanism"
    
    ForwardSpeed=1.0f
    kForwardSpeed=100.0f
}
